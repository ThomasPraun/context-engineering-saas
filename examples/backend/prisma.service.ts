import { PrismaClient } from '@prisma/client';

/**
 * Example Prisma Service - Singleton Pattern
 * Demonstrates:
 * - Singleton instance management
 * - Connection lifecycle
 * - Query logging in development
 * - Middleware for soft deletes
 * - Error handling
 */
export class PrismaService {
  private static instance: PrismaService;
  private prisma: PrismaClient;

  private constructor() {
    this.prisma = new PrismaClient({
      log: process.env.NODE_ENV === 'development' 
        ? ['query', 'error', 'warn'] 
        : ['error'],
      errorFormat: 'pretty',
    });

    this.setupMiddleware();
    this.setupShutdownHooks();
  }

  /**
   * Get singleton instance
   */
  static getInstance(): PrismaService {
    if (!PrismaService.instance) {
      PrismaService.instance = new PrismaService();
    }
    return PrismaService.instance;
  }

  /**
   * Get Prisma client instance
   */
  get client(): PrismaClient {
    return this.prisma;
  }

  /**
   * Connect to database
   */
  async connect(): Promise<void> {
    try {
      await this.prisma.$connect();
      console.log('✅ Database connected successfully');
    } catch (error) {
      console.error('❌ Database connection failed:', error);
      throw error;
    }
  }

  /**
   * Disconnect from database
   */
  async disconnect(): Promise<void> {
    await this.prisma.$disconnect();
    console.log('📤 Database disconnected');
  }

  /**
   * Setup Prisma middleware
   */
  private setupMiddleware(): void {
    // Soft delete middleware
    this.prisma.$use(async (params, next) => {
      // Check for soft delete models
      const softDeleteModels = ['User', 'Post', 'Comment'];
      
      if (softDeleteModels.includes(params.model || '')) {
        // Handle findUnique and findFirst
        if (params.action === 'findUnique' || params.action === 'findFirst') {
          params.action = 'findFirst';
          params.args.where = {
            ...params.args.where,
            deletedAt: null,
          };
        }

        // Handle findMany
        if (params.action === 'findMany') {
          if (params.args.where) {
            if (params.args.where.deletedAt === undefined) {
              params.args.where.deletedAt = null;
            }
          } else {
            params.args.where = { deletedAt: null };
          }
        }

        // Handle update - convert to updateMany
        if (params.action === 'update') {
          params.action = 'updateMany';
          params.args.where = {
            ...params.args.where,
            deletedAt: null,
          };
        }

        // Handle delete - convert to update (soft delete)
        if (params.action === 'delete') {
          params.action = 'update';
          params.args.data = { deletedAt: new Date() };
        }

        // Handle deleteMany - convert to updateMany (soft delete)
        if (params.action === 'deleteMany') {
          params.action = 'updateMany';
          params.args.data = { deletedAt: new Date() };
        }
      }

      return next(params);
    });

    // Query timing middleware (development only)
    if (process.env.NODE_ENV === 'development') {
      this.prisma.$use(async (params, next) => {
        const before = Date.now();
        const result = await next(params);
        const after = Date.now();
        
        console.log(
          `🔍 Query ${params.model}.${params.action} took ${after - before}ms`
        );
        
        return result;
      });
    }
  }

  /**
   * Setup shutdown hooks for graceful shutdown
   */
  private setupShutdownHooks(): void {
    process.on('beforeExit', async () => {
      await this.disconnect();
    });

    process.on('SIGINT', async () => {
      await this.disconnect();
      process.exit(0);
    });

    process.on('SIGTERM', async () => {
      await this.disconnect();
      process.exit(0);
    });
  }

  /**
   * Execute a transaction
   */
  async transaction<T>(
    fn: (prisma: Omit<PrismaClient, '$connect' | '$disconnect' | '$on' | '$transaction' | '$use'>) => Promise<T>
  ): Promise<T> {
    return this.prisma.$transaction(fn);
  }

  /**
   * Health check
   */
  async healthCheck(): Promise<boolean> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * Get database metrics
   */
  async getMetrics() {
    const [userCount, postCount, connectionCount] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.post.count(),
      this.prisma.$queryRaw`
        SELECT count(*) as count 
        FROM pg_stat_activity 
        WHERE datname = current_database()
      `,
    ]);

    return {
      users: userCount,
      posts: postCount,
      connections: connectionCount,
    };
  }
}

/**
 * Prisma query builder helpers
 * These demonstrate common query patterns
 */
export class PrismaQueryHelpers {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  /**
   * Paginate query results
   */
  async paginate<T>(
    model: any,
    {
      page = 1,
      limit = 10,
      where = {},
      orderBy = {},
      include = {},
    }: {
      page?: number;
      limit?: number;
      where?: any;
      orderBy?: any;
      include?: any;
    }
  ) {
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      model.findMany({
        where,
        orderBy,
        include,
        skip,
        take: limit,
      }),
      model.count({ where }),
    ]);

    return {
      data,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1,
      },
    };
  }

  /**
   * Bulk create with chunk processing
   */
  async bulkCreate<T>(
    model: any,
    data: T[],
    chunkSize: number = 1000
  ): Promise<number> {
    let created = 0;

    // Process in chunks to avoid memory issues
    for (let i = 0; i < data.length; i += chunkSize) {
      const chunk = data.slice(i, i + chunkSize);
      const result = await model.createMany({
        data: chunk,
        skipDuplicates: true,
      });
      created += result.count;
    }

    return created;
  }

  /**
   * Find or create record
   */
  async findOrCreate<T>(
    model: any,
    {
      where,
      create,
    }: {
      where: any;
      create: any;
    }
  ): Promise<{ record: T; created: boolean }> {
    // Try to find existing record
    let record = await model.findFirst({ where });
    let created = false;

    if (!record) {
      // Create if not found
      record = await model.create({ data: create });
      created = true;
    }

    return { record, created };
  }

  /**
   * Upsert multiple records
   */
  async upsertMany<T>(
    model: any,
    records: Array<{
      where: any;
      create: any;
      update: any;
    }>
  ): Promise<T[]> {
    const results = await this.prisma.$transaction(
      records.map((record) =>
        model.upsert({
          where: record.where,
          create: record.create,
          update: record.update,
        })
      )
    );

    return results;
  }

  /**
   * Full-text search helper
   */
  async search<T>(
    model: any,
    {
      query,
      fields,
      where = {},
      limit = 10,
    }: {
      query: string;
      fields: string[];
      where?: any;
      limit?: number;
    }
  ): Promise<T[]> {
    const searchConditions = fields.map((field) => ({
      [field]: {
        contains: query,
        mode: 'insensitive',
      },
    }));

    return model.findMany({
      where: {
        AND: [
          where,
          {
            OR: searchConditions,
          },
        ],
      },
      take: limit,
    });
  }
}

// Export singleton instance
export const prisma = PrismaService.getInstance().client;