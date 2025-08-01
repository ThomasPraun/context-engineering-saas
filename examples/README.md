# Examples Directory

This directory contains example code patterns that should be followed throughout the project. These examples demonstrate best practices, common patterns, and architectural decisions.

## Flutter Examples

### `flutter/api_service.dart`
**Purpose**: HTTP client setup with authentication and error handling

**Key patterns demonstrated**:
- Dio interceptors for auth token management
- Automatic token refresh on 401 errors
- Centralized error handling and transformation
- Request/response logging in debug mode
- File upload with progress tracking
- Type-safe API responses

**When to use**: Reference this when implementing any API calls in your Flutter app.

### `flutter/auth_provider.dart`
**Purpose**: Authentication state management using Provider pattern

**Key patterns demonstrated**:
- ChangeNotifier for reactive state
- JWT token management
- Offline support with cached user data
- Error state handling
- Login/logout/registration flows
- Permission and role checking

**When to use**: Reference this when implementing any state management or authentication features.

### `flutter/user_model.dart`
**Purpose**: Data model with JSON serialization

**Key patterns demonstrated**:
- Null-safe model design
- Factory constructors for JSON parsing
- toJson/fromJson methods
- copyWith pattern for immutability
- Nested model relationships
- Enum handling
- Model composition

**When to use**: Reference this when creating any data models in Flutter.

## Backend Examples

### `backend/auth.controller.ts`
**Purpose**: Express controller with authentication endpoints

**Key patterns demonstrated**:
- Async error handling with wrapper
- Zod validation middleware
- JWT token generation
- Password hashing with bcrypt
- Prisma database operations
- Consistent response format
- Transaction handling

**When to use**: Reference this when creating any Express controllers.

### `backend/prisma.service.ts`
**Purpose**: Database service singleton with Prisma

**Key patterns demonstrated**:
- Singleton pattern for database connection
- Soft delete middleware
- Query performance logging
- Transaction helpers
- Pagination utilities
- Bulk operations
- Health checks

**When to use**: Reference this when implementing database operations or services.

### `backend/validation.middleware.ts`
**Purpose**: Request validation using Zod schemas

**Key patterns demonstrated**:
- Schema-based validation
- Error formatting
- Reusable validation patterns
- Custom validators
- Type inference from schemas
- File upload validation
- Input sanitization

**When to use**: Reference this when implementing API validation.

## How to Use These Examples

1. **Don't copy directly** - These examples are from a different project. Use them as inspiration and patterns to follow.

2. **Adapt to your needs** - Take the patterns and apply them to your specific use case.

3. **Maintain consistency** - Once you establish a pattern based on these examples, use it throughout your project.

4. **Consider your scale** - Some patterns (like the singleton database service) are great for small to medium apps but might need adjustment for larger applications.

## Adding New Examples

When adding new examples:

1. Place them in the appropriate subdirectory (`flutter/` or `backend/`)
2. Include comprehensive comments explaining the patterns
3. Show both what TO do and what NOT to do
4. Update this README with a description
5. Ensure the example is self-contained and understandable

## Common Patterns Across Examples

### Error Handling
- Always use try-catch blocks
- Transform errors into user-friendly messages
- Log errors in development
- Provide fallbacks for critical features

### Type Safety
- No `any` types in TypeScript
- Use Zod for runtime validation
- Leverage TypeScript's type system
- Use null safety in Dart

### State Management
- Single source of truth
- Immutable updates
- Clear separation of concerns
- Reactive patterns

### API Design
- Consistent response structure
- Proper HTTP status codes
- Comprehensive error responses
- Request validation

### Security
- Never expose sensitive data
- Hash passwords
- Validate all inputs
- Use authentication middleware

## Platform-Specific Considerations

### Flutter
- Handle platform differences (iOS vs Android)
- Implement responsive design
- Consider offline functionality
- Optimize for performance

### Node.js
- Use async/await everywhere
- Implement proper middleware
- Handle database connections carefully
- Use environment variables