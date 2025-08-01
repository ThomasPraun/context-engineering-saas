## Flutter & Node.js Development Instructions

### Project Awareness & Context
- **Always read `PLANNING.md`** at the start of a new conversation to understand the project's architecture, goals, style, and constraints.
- **Check `TASK.md`** before starting a new task. If the task isn't listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** as described in `PLANNING.md`.
- **Follow existing patterns** in the `examples/` directory.

### Architecture & Stack
- **Frontend**: Flutter (Dart) in `/frontend` directory
  - Support for iOS, Android, and Web platforms
  - Use null safety and latest Dart features
  - Follow Material Design on Android, Cupertino on iOS
  - Implement responsive design for different screen sizes
- **Backend**: Node.js with Express in `/backend` directory
  - Use ES6+ JavaScript or TypeScript
  - PostgreSQL with Prisma ORM
  - JWT-based authentication
  - RESTful API design
- **Development**: Docker Compose for PostgreSQL and other services

### Code Structure & Modularity
- **Never create a file longer than 300 lines**. Split large files into smaller, focused modules.
- **Flutter Structure**:
  ```
  frontend/
  ├── lib/
  │   ├── models/        # Data models
  │   ├── providers/     # State management
  │   ├── services/      # API and device services
  │   ├── screens/       # Full page widgets
  │   ├── widgets/       # Reusable components
  │   └── utils/         # Helper functions
  ```
- **Backend Structure**:
  ```
  backend/
  ├── controllers/       # Route handlers
  ├── services/         # Business logic
  ├── middleware/       # Express middleware
  ├── models/          # Database models
  ├── routes/          # API routes
  └── utils/           # Helper functions
  ```

### Testing & Reliability
- **Write tests alongside implementation**, not after
- **Flutter Tests**:
  - Widget tests for UI components
  - Unit tests for business logic
  - Integration tests for critical flows
- **Backend Tests**:
  - Unit tests for services
  - API endpoint tests
  - Database integration tests
- **Aim for >80% test coverage**

### Task Completion
- **Mark completed tasks in `TASK.md`** immediately after finishing them
- **Add discovered tasks** during development
- **Document technical decisions**

### Style & Conventions

#### Flutter/Dart
- Follow Dart style guide
- Use `flutter analyze` before committing
- Meaningful variable names
- Document public APIs with `///`
- Prefer composition over inheritance
- Use `const` constructors where possible

#### Node.js/JavaScript
- Use ESLint configuration
- Async/await over callbacks
- Meaningful function names
- JSDoc for documentation
- Error-first callbacks where needed
- Use environment variables for config

### Platform Considerations
- **Always test on all target platforms**
- **Handle platform differences explicitly**:
  ```dart
  if (Platform.isIOS) {
    // iOS specific code
  } else if (Platform.isAndroid) {
    // Android specific code
  } else if (kIsWeb) {
    // Web specific code
  }
  ```
- **Responsive Design**:
  - Mobile: < 600px
  - Tablet: 600px - 1200px
  - Desktop: > 1200px

### API Design
- **RESTful conventions**:
  - GET for reading
  - POST for creating
  - PUT/PATCH for updating
  - DELETE for removing
- **Consistent response format**:
  ```json
  {
    "success": true,
    "data": {},
    "error": null,
    "message": ""
  }
  ```
- **Proper status codes**:
  - 200: Success
  - 201: Created
  - 400: Bad Request
  - 401: Unauthorized
  - 404: Not Found
  - 500: Server Error

### Documentation & Explainability
- **Comment non-obvious code**
- **Update README.md** with setup instructions
- **Document API endpoints**
- **Include examples for complex features**

### Security Best Practices
- **Never hardcode secrets**
- **Validate all inputs**
- **Use HTTPS in production**
- **Implement rate limiting**
- **Sanitize user data**
- **Hash passwords with bcrypt**

### Performance Optimization
- **Flutter**:
  - Use `ListView.builder` for long lists
  - Implement image caching
  - Minimize widget rebuilds
  - Use `const` widgets
- **Backend**:
  - Implement pagination
  - Use database indexes
  - Cache frequently accessed data
  - Optimize database queries

### AI Behavior Rules
- **Never assume missing context**. Ask questions if unclear.
- **Always verify file paths exist** before referencing
- **Test code before considering task complete**
- **Follow existing patterns** in the codebase
- **Consider offline functionality** for mobile features
- **Implement loading and error states**
- **Use proper error handling** throughout

### Common Pitfalls to Avoid
- Don't forget to dispose controllers in Flutter
- Don't use synchronous I/O in Node.js
- Don't trust client-side validation alone
- Don't forget CORS configuration
- Don't hardcode API URLs
- Don't skip error handling
- Don't ignore platform differences
- Don't forget to handle offline state

### Docker & Development Workflow
- **Use Docker Compose** for local development
- **Services include**:
  - PostgreSQL database
  - pgAdmin for database management
  - Redis for caching (optional)
- **Hot reload** enabled for both Flutter and Node.js