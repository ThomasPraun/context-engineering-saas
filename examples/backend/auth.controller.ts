import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { PrismaService } from '../services/prisma.service';
import { validateRequest } from '../middlewares/validation.middleware';
import { AppError, asyncHandler } from '../utils/error-handler';
import { generateTokens, verifyRefreshToken } from '../utils/auth.utils';

// Validation schemas using Zod
const registerSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email format'),
    password: z.string().min(8, 'Password must be at least 8 characters'),
    name: z.string().min(2, 'Name must be at least 2 characters'),
  }),
});

const loginSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email format'),
    password: z.string().min(1, 'Password is required'),
  }),
});

const refreshTokenSchema = z.object({
  body: z.object({
    refreshToken: z.string().min(1, 'Refresh token is required'),
  }),
});

const forgotPasswordSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email format'),
  }),
});

const resetPasswordSchema = z.object({
  body: z.object({
    token: z.string().min(1, 'Reset token is required'),
    password: z.string().min(8, 'Password must be at least 8 characters'),
  }),
});

/**
 * Example Authentication Controller
 * Demonstrates:
 * - Async error handling
 * - Input validation
 * - JWT authentication
 * - Database operations with Prisma
 * - Proper response structure
 */
export class AuthController {
  private prisma: PrismaService;

  constructor() {
    this.prisma = PrismaService.getInstance();
  }

  /**
   * Register a new user
   */
  register = [
    validateRequest(registerSchema),
    asyncHandler(async (req: Request, res: Response) => {
      const { email, password, name } = req.body;

      // Check if user already exists
      const existingUser = await this.prisma.user.findUnique({
        where: { email },
      });

      if (existingUser) {
        throw new AppError('User with this email already exists', 409);
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create user with default preferences
      const user = await this.prisma.user.create({
        data: {
          email,
          password: hashedPassword,
          name,
          preferences: {
            create: {
              darkMode: false,
              language: 'en',
              emailNotifications: true,
              pushNotifications: true,
              notificationFrequency: 'instant',
            },
          },
        },
        include: {
          preferences: true,
          roles: {
            include: {
              role: {
                include: {
                  permissions: true,
                },
              },
            },
          },
        },
      });

      // Generate tokens
      const { accessToken, refreshToken } = generateTokens(user.id);

      // Store refresh token
      await this.prisma.refreshToken.create({
        data: {
          token: refreshToken,
          userId: user.id,
          expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
        },
      });

      // Format response
      const userResponse = this.formatUserResponse(user);

      res.status(201).json({
        success: true,
        data: {
          user: userResponse,
          accessToken,
          refreshToken,
        },
        metadata: {
          timestamp: new Date().toISOString(),
        },
      });
    }),
  ];

  /**
   * Login user
   */
  login = [
    validateRequest(loginSchema),
    asyncHandler(async (req: Request, res: Response) => {
      const { email, password } = req.body;

      // Find user with relations
      const user = await this.prisma.user.findUnique({
        where: { email },
        include: {
          preferences: true,
          roles: {
            include: {
              role: {
                include: {
                  permissions: true,
                },
              },
            },
          },
        },
      });

      if (!user) {
        throw new AppError('Invalid email or password', 401);
      }

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        throw new AppError('Invalid email or password', 401);
      }

      // Generate tokens
      const { accessToken, refreshToken } = generateTokens(user.id);

      // Store refresh token (remove old ones)
      await this.prisma.refreshToken.deleteMany({
        where: { userId: user.id },
      });

      await this.prisma.refreshToken.create({
        data: {
          token: refreshToken,
          userId: user.id,
          expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        },
      });

      // Update last login
      await this.prisma.user.update({
        where: { id: user.id },
        data: { lastLoginAt: new Date() },
      });

      // Format response
      const userResponse = this.formatUserResponse(user);

      res.json({
        success: true,
        data: {
          user: userResponse,
          accessToken,
          refreshToken,
        },
        metadata: {
          timestamp: new Date().toISOString(),
        },
      });
    }),
  ];

  /**
   * Refresh access token
   */
  refreshToken = [
    validateRequest(refreshTokenSchema),
    asyncHandler(async (req: Request, res: Response) => {
      const { refreshToken } = req.body;

      // Verify refresh token
      const payload = verifyRefreshToken(refreshToken);
      if (!payload) {
        throw new AppError('Invalid refresh token', 401);
      }

      // Check if token exists in database
      const storedToken = await this.prisma.refreshToken.findFirst({
        where: {
          token: refreshToken,
          userId: payload.userId,
          expiresAt: { gt: new Date() },
        },
      });

      if (!storedToken) {
        throw new AppError('Invalid refresh token', 401);
      }

      // Generate new tokens
      const { accessToken, refreshToken: newRefreshToken } = generateTokens(
        payload.userId
      );

      // Replace old refresh token
      await this.prisma.refreshToken.update({
        where: { id: storedToken.id },
        data: {
          token: newRefreshToken,
          expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        },
      });

      res.json({
        success: true,
        data: {
          accessToken,
          refreshToken: newRefreshToken,
        },
        metadata: {
          timestamp: new Date().toISOString(),
        },
      });
    }),
  ];

  /**
   * Logout user
   */
  logout = asyncHandler(async (req: Request, res: Response) => {
    const userId = req.user?.id;

    if (userId) {
      // Remove all refresh tokens for user
      await this.prisma.refreshToken.deleteMany({
        where: { userId },
      });
    }

    res.json({
      success: true,
      data: null,
      metadata: {
        timestamp: new Date().toISOString(),
      },
    });
  });

  /**
   * Get current user
   */
  getMe = asyncHandler(async (req: Request, res: Response) => {
    const userId = req.user!.id;

    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        preferences: true,
        roles: {
          include: {
            role: {
              include: {
                permissions: true,
              },
            },
          },
        },
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    const userResponse = this.formatUserResponse(user);

    res.json({
      success: true,
      data: userResponse,
      metadata: {
        timestamp: new Date().toISOString(),
      },
    });
  });

  /**
   * Request password reset
   */
  forgotPassword = [
    validateRequest(forgotPasswordSchema),
    asyncHandler(async (req: Request, res: Response) => {
      const { email } = req.body;

      const user = await this.prisma.user.findUnique({
        where: { email },
      });

      // Don't reveal if user exists
      if (!user) {
        res.json({
          success: true,
          data: {
            message: 'If the email exists, a reset link has been sent.',
          },
          metadata: {
            timestamp: new Date().toISOString(),
          },
        });
        return;
      }

      // Generate reset token
      const resetToken = jwt.sign(
        { userId: user.id, type: 'password-reset' },
        process.env.JWT_SECRET!,
        { expiresIn: '1h' }
      );

      // Store reset token
      await this.prisma.passwordReset.create({
        data: {
          token: resetToken,
          userId: user.id,
          expiresAt: new Date(Date.now() + 60 * 60 * 1000), // 1 hour
        },
      });

      // TODO: Send email with reset link
      // await emailService.sendPasswordResetEmail(user.email, resetToken);

      res.json({
        success: true,
        data: {
          message: 'If the email exists, a reset link has been sent.',
        },
        metadata: {
          timestamp: new Date().toISOString(),
        },
      });
    }),
  ];

  /**
   * Reset password
   */
  resetPassword = [
    validateRequest(resetPasswordSchema),
    asyncHandler(async (req: Request, res: Response) => {
      const { token, password } = req.body;

      // Verify token
      let payload: any;
      try {
        payload = jwt.verify(token, process.env.JWT_SECRET!);
      } catch (error) {
        throw new AppError('Invalid or expired reset token', 400);
      }

      if (payload.type !== 'password-reset') {
        throw new AppError('Invalid reset token', 400);
      }

      // Check if token exists in database
      const resetToken = await this.prisma.passwordReset.findFirst({
        where: {
          token,
          userId: payload.userId,
          used: false,
          expiresAt: { gt: new Date() },
        },
      });

      if (!resetToken) {
        throw new AppError('Invalid or expired reset token', 400);
      }

      // Hash new password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Update password and mark token as used
      await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: payload.userId },
          data: { password: hashedPassword },
        }),
        this.prisma.passwordReset.update({
          where: { id: resetToken.id },
          data: { used: true },
        }),
      ]);

      res.json({
        success: true,
        data: {
          message: 'Password has been reset successfully.',
        },
        metadata: {
          timestamp: new Date().toISOString(),
        },
      });
    }),
  ];

  /**
   * Format user response (remove sensitive data)
   */
  private formatUserResponse(user: any) {
    // Extract permissions from roles
    const permissions = user.roles?.flatMap((userRole: any) =>
      userRole.role.permissions.map((perm: any) => perm.name)
    ) || [];

    const roles = user.roles?.map((userRole: any) => userRole.role.name) || [];

    return {
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      roles,
      permissions,
      preferences: user.preferences,
    };
  }
}