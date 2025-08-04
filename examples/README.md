# Examples Directory

This directory contains example code patterns that should be followed throughout the project. These examples demonstrate best practices, common patterns, and architectural decisions.

## Flutter Examples

### `flutter/user.dart`
**Purpose**: Data model with JSON serialization

**Key patterns demonstrated**:
- Null-safe model design
- Factory constructors for JSON parsing
- toJson/fromJson methods
- Nested model relationships (User and Vehicle)
- Equality operators and hashCode
- Comprehensive toString methods

**When to use**: Reference this when creating any data models in Flutter.

### `flutter/app_validators.dart`
**Purpose**: Centralized form validation patterns

**Key patterns demonstrated**:
- Reusable validation functions
- Email, password, and numeric validators
- Custom validation logic
- Composite validators
- Internationalized error messages
- Length and character type validation

**When to use**: Reference this when implementing form validation in Flutter.

### `flutter/router.dart`
**Purpose**: App navigation using GoRouter

**Key patterns demonstrated**:
- Route configuration with GoRouter
- Authentication-based redirects
- Shell routes for bottom navigation
- Custom page transitions
- Navigation extensions
- Query parameters handling

**When to use**: Reference this when setting up navigation and routing.

### `flutter/theme.dart`
**Purpose**: Centralized theme configuration

**Key patterns demonstrated**:
- Material 3 theme setup
- Light and dark theme support
- Custom color schemes
- Typography definitions
- Consistent spacing and dimensions
- AppBar theming

**When to use**: Reference this when implementing UI theming and styling.

### Additional Flutter Utilities

- `flutter/assets_path.dart` - Centralized asset path management
- `flutter/enum.dart` - Enum definitions and helpers
- `flutter/messages.dart` - Internationalized message strings
- `flutter/storage_keys.dart` - Local storage key constants

## Backend Examples

### `backend/index.js`
**Purpose**: Express server setup and middleware configuration

**Key patterns demonstrated**:
- ES6 module imports
- Express middleware setup (morgan, JSON parsing)
- Route registration
- Server initialization
- Environment-based configuration

**When to use**: Reference this when setting up the main server file.

### `backend/users.controllers.js`
**Purpose**: Express controller with CRUD operations

**Key patterns demonstrated**:
- Async/await pattern for database operations
- PostgreSQL queries using pg pool
- Error handling with appropriate status codes
- RESTful endpoint implementation
- Parameterized queries for security

**When to use**: Reference this when creating any Express controllers.

### `backend/users.routes.js`
**Purpose**: Express route definitions

**Key patterns demonstrated**:
- Route organization with Express Router
- RESTful route naming
- Controller function mapping
- Debug mode conditional routes
- Clean route structure

**When to use**: Reference this when setting up API routes.

### `backend/config.js`
**Purpose**: Environment configuration management

**Key patterns demonstrated**:
- Environment variable usage
- Default value fallbacks
- Configuration exports
- Database connection strings
- Debug mode settings

**When to use**: Reference this when managing application configuration.

### `backend/db.js`
**Purpose**: PostgreSQL database connection

**Key patterns demonstrated**:
- Connection pool setup
- Type parsing configuration (BIGINT handling)
- SSL configuration
- Database connection management

**When to use**: Reference this when setting up database connections.

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
- Use null safety in Dart
- Validate inputs on both client and server
- Handle null/undefined cases explicitly
- Use proper type annotations in JavaScript

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
- Store passwords securely (when implementing auth)
- Validate all inputs
- Use parameterized queries for database operations
- Sanitize user data

## Platform-Specific Considerations

### Flutter
- Handle platform differences (iOS vs Android vs Web)
- Implement responsive design for all screen sizes
- Consider offline functionality
- Optimize for performance
- Use platform-specific widgets when appropriate

### Node.js
- Use async/await everywhere
- Implement proper middleware ordering
- Handle database connections with pools
- Use environment variables for configuration
- Always handle promise rejections