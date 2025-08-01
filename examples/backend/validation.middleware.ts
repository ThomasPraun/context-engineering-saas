import { Request, Response, NextFunction } from 'express';
import { z, ZodError, ZodSchema } from 'zod';
import { AppError } from '../utils/error-handler';

/**
 * Example Validation Middleware using Zod
 * Demonstrates:
 * - Request validation (body, params, query)
 * - Error formatting
 * - Type safety
 * - Reusable validation patterns
 */

/**
 * Generic validation middleware factory
 */
export const validateRequest = (schema: ZodSchema) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Validate request against schema
      const validated = await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });

      // Replace request properties with validated data
      req.body = validated.body || req.body;
      req.query = validated.query || req.query;
      req.params = validated.params || req.params;

      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const formattedErrors = formatZodErrors(error);
        return res.status(422).json({
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Validation failed',
            errors: formattedErrors,
          },
          metadata: {
            timestamp: new Date().toISOString(),
          },
        });
      }
      next(error);
    }
  };
};

/**
 * Format Zod errors for consistent API response
 */
function formatZodErrors(error: ZodError): Record<string, string[]> {
  const errors: Record<string, string[]> = {};

  error.errors.forEach((err) => {
    const path = err.path.join('.');
    if (!errors[path]) {
      errors[path] = [];
    }
    errors[path].push(err.message);
  });

  return errors;
}

/**
 * Common validation schemas
 */

// Pagination schema
export const paginationSchema = z.object({
  query: z.object({
    page: z.string().regex(/^\d+$/).transform(Number).default('1'),
    limit: z.string().regex(/^\d+$/).transform(Number).default('10'),
    sort: z.string().optional(),
    order: z.enum(['asc', 'desc']).default('desc'),
  }),
});

// ID parameter schema
export const idParamSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid ID format'),
  }),
});

// Search query schema
export const searchSchema = z.object({
  query: z.object({
    q: z.string().min(1, 'Search query is required'),
    fields: z.string().optional(), // comma-separated fields
  }),
});

/**
 * Custom validators
 */

// Email validator with DNS check (async)
export const emailWithDnsCheck = z
  .string()
  .email()
  .refine(async (email) => {
    // In production, you might want to check DNS MX records
    // For now, just check format
    const domain = email.split('@')[1];
    return domain && domain.includes('.');
  }, 'Invalid email domain');

// Phone number validator (international format)
export const phoneNumber = z
  .string()
  .regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number format');

// Strong password validator
export const strongPassword = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
  .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
  .regex(/[0-9]/, 'Password must contain at least one number')
  .regex(/[^A-Za-z0-9]/, 'Password must contain at least one special character');

// Date range validator
export const dateRangeSchema = z.object({
  startDate: z.string().datetime(),
  endDate: z.string().datetime(),
}).refine((data) => {
  return new Date(data.startDate) <= new Date(data.endDate);
}, {
  message: 'Start date must be before or equal to end date',
  path: ['endDate'],
});

/**
 * Request validation schemas for different features
 */

// User registration schema
export const userRegistrationSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email format'),
    password: strongPassword,
    name: z.string().min(2, 'Name must be at least 2 characters'),
    phone: phoneNumber.optional(),
    dateOfBirth: z.string().datetime().optional(),
    preferences: z.object({
      darkMode: z.boolean().default(false),
      language: z.enum(['en', 'es', 'fr', 'de']).default('en'),
      emailNotifications: z.boolean().default(true),
    }).optional(),
  }),
});

// User profile update schema
export const userUpdateSchema = z.object({
  body: z.object({
    name: z.string().min(2).optional(),
    bio: z.string().max(500).optional(),
    avatarUrl: z.string().url().optional(),
    phone: phoneNumber.optional(),
    preferences: z.object({
      darkMode: z.boolean().optional(),
      language: z.enum(['en', 'es', 'fr', 'de']).optional(),
      emailNotifications: z.boolean().optional(),
      pushNotifications: z.boolean().optional(),
    }).optional(),
  }),
});

// Post creation schema
export const createPostSchema = z.object({
  body: z.object({
    title: z.string().min(3).max(200),
    content: z.string().min(10),
    tags: z.array(z.string()).max(5).optional(),
    status: z.enum(['draft', 'published']).default('draft'),
    publishedAt: z.string().datetime().optional(),
  }),
});

// File upload validation
export const fileUploadSchema = z.object({
  file: z.object({
    mimetype: z.enum([
      'image/jpeg',
      'image/png',
      'image/gif',
      'image/webp',
      'application/pdf',
    ]),
    size: z.number().max(10 * 1024 * 1024, 'File size must be less than 10MB'),
  }),
});

/**
 * Middleware for validating file uploads
 */
export const validateFileUpload = (options: {
  maxSize?: number;
  allowedTypes?: string[];
}) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.file) {
      return next(new AppError('No file uploaded', 400));
    }

    const { maxSize = 10 * 1024 * 1024, allowedTypes = ['image/jpeg', 'image/png'] } = options;

    // Check file size
    if (req.file.size > maxSize) {
      return next(new AppError(`File size must be less than ${maxSize / 1024 / 1024}MB`, 400));
    }

    // Check file type
    if (!allowedTypes.includes(req.file.mimetype)) {
      return next(new AppError(`File type must be one of: ${allowedTypes.join(', ')}`, 400));
    }

    next();
  };
};

/**
 * Sanitization middleware
 */
export const sanitizeInput = (fields: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    fields.forEach((field) => {
      if (req.body[field] && typeof req.body[field] === 'string') {
        // Remove HTML tags
        req.body[field] = req.body[field].replace(/<[^>]*>?/gm, '');
        // Trim whitespace
        req.body[field] = req.body[field].trim();
        // Remove extra spaces
        req.body[field] = req.body[field].replace(/\s+/g, ' ');
      }
    });
    next();
  };
};

/**
 * Rate limiting validation
 */
export const rateLimitSchema = z.object({
  headers: z.object({
    'x-api-key': z.string().optional(),
    'x-rate-limit-remaining': z.string().optional(),
  }),
});

/**
 * Complex nested validation example
 */
export const createOrderSchema = z.object({
  body: z.object({
    customer: z.object({
      name: z.string().min(2),
      email: z.string().email(),
      phone: phoneNumber,
      address: z.object({
        street: z.string().min(5),
        city: z.string().min(2),
        state: z.string().length(2),
        zipCode: z.string().regex(/^\d{5}(-\d{4})?$/),
        country: z.string().length(2),
      }),
    }),
    items: z.array(
      z.object({
        productId: z.string().uuid(),
        quantity: z.number().int().min(1),
        price: z.number().positive(),
      })
    ).min(1, 'Order must contain at least one item'),
    paymentMethod: z.enum(['credit_card', 'paypal', 'stripe']),
    couponCode: z.string().optional(),
    notes: z.string().max(500).optional(),
  }),
}).refine((data) => {
  // Custom validation: total must be positive
  const total = data.body.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  return total > 0;
}, {
  message: 'Order total must be greater than 0',
  path: ['body', 'items'],
});

/**
 * Type inference from schemas
 */
export type UserRegistration = z.infer<typeof userRegistrationSchema>['body'];
export type UserUpdate = z.infer<typeof userUpdateSchema>['body'];
export type CreatePost = z.infer<typeof createPostSchema>['body'];
export type CreateOrder = z.infer<typeof createOrderSchema>['body'];