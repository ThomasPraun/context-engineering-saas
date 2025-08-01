import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';
import { AppError } from './error-handler';

interface TokenPayload {
  userId: string;
  type: 'access' | 'refresh';
}

interface AuthRequest extends Request {
  user?: {
    id: string;
    email?: string;
    roles?: string[];
  };
}

/**
 * Generate access and refresh tokens
 */
export const generateTokens = (userId: string) => {
  const accessToken = jwt.sign(
    { userId, type: 'access' },
    process.env.JWT_SECRET!,
    { expiresIn: process.env.JWT_EXPIRES_IN || '15m' }
  );

  const refreshToken = jwt.sign(
    { userId, type: 'refresh' },
    process.env.JWT_REFRESH_SECRET!,
    { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d' }
  );

  return { accessToken, refreshToken };
};

/**
 * Verify refresh token
 */
export const verifyRefreshToken = (token: string): TokenPayload | null => {
  try {
    const payload = jwt.verify(
      token,
      process.env.JWT_REFRESH_SECRET!
    ) as TokenPayload;
    
    if (payload.type !== 'refresh') {
      return null;
    }
    
    return payload;
  } catch (error) {
    return null;
  }
};

/**
 * Authentication middleware
 */
export const authenticate = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ')
      ? authHeader.substring(7)
      : null;

    if (!token) {
      throw new AppError('Authentication required', 401);
    }

    // Verify token
    const payload = jwt.verify(
      token,
      process.env.JWT_SECRET!
    ) as TokenPayload;

    if (payload.type !== 'access') {
      throw new AppError('Invalid token type', 401);
    }

    // Attach user to request
    req.user = {
      id: payload.userId,
    };

    // Optional: Load full user data from database
    // const user = await prisma.user.findUnique({
    //   where: { id: payload.userId },
    //   include: { roles: true }
    // });
    // 
    // if (!user) {
    //   throw new AppError('User not found', 401);
    // }
    // 
    // req.user = {
    //   id: user.id,
    //   email: user.email,
    //   roles: user.roles.map(r => r.name)
    // };

    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return next(new AppError('Invalid token', 401));
    }
    if (error instanceof jwt.TokenExpiredError) {
      return next(new AppError('Token expired', 401));
    }
    next(error);
  }
};

/**
 * Authorization middleware - check roles
 */
export const authorize = (...roles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return next(new AppError('Authentication required', 401));
    }

    if (!req.user.roles || !roles.some(role => req.user!.roles!.includes(role))) {
      return next(new AppError('Insufficient permissions', 403));
    }

    next();
  };
};

/**
 * Optional authentication - doesn't fail if no token
 */
export const optionalAuth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ')
      ? authHeader.substring(7)
      : null;

    if (token) {
      const payload = jwt.verify(
        token,
        process.env.JWT_SECRET!
      ) as TokenPayload;

      if (payload.type === 'access') {
        req.user = {
          id: payload.userId,
        };
      }
    }

    next();
  } catch (error) {
    // Ignore errors and continue without auth
    next();
  }
};

/**
 * Generate random string for tokens
 */
export const generateRandomToken = (length: number = 32): string => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
};

/**
 * Hash a token for storage (one-way)
 */
export const hashToken = (token: string): string => {
  const crypto = require('crypto');
  return crypto
    .createHash('sha256')
    .update(token)
    .digest('hex');
};