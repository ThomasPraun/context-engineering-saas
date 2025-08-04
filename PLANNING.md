# Project Planning

## Overview
This document outlines the architecture, goals, style guidelines, and constraints for the project. It serves as the central reference for maintaining consistency across the codebase.

## Project Goals
- [Define the main objectives of your project]
- [What problems does it solve?]
- [Who is the target audience?]

## Architecture

### Frontend (Flutter)
- **State Management**: [Provider/Riverpod/Bloc - choose one]
- **Navigation**: GoRouter
- **Local Storage**: [SharedPreferences/Hive/Drift]
- **HTTP Client**: Dio
- **Supported Platforms**: iOS, Android, Web

### Backend (Node.js)
- **Framework**: Express.js
- **Database**: PostgreSQL with pg driver
- **Authentication**: JWT tokens
- **API Style**: RESTful
- **Module System**: ES6 modules

### Infrastructure
- **Development**: Docker Compose for services
- **Database Management**: pgAdmin
- **Version Control**: Git

## Code Style Guidelines

### General Principles
- Keep functions small and focused (< 30 lines)
- Use descriptive names that explain purpose
- Comment WHY, not WHAT
- Prefer composition over inheritance
- Early returns to reduce nesting

### Flutter Conventions
- Follow Dart style guide
- Use `const` constructors where possible
- Implement proper dispose methods
- Handle all loading and error states
- Support offline functionality

### Node.js Conventions
- Use async/await over callbacks
- Handle all promise rejections
- Use environment variables for config
- Implement proper error middleware
- Always validate inputs

## File Organization

### Flutter
```
frontend/
├── lib/
│   ├── models/         # Data models
│   ├── providers/      # State management
│   ├── services/       # API and device services
│   ├── screens/        # Full page widgets
│   ├── widgets/        # Reusable components
│   └── utils/          # Helper functions
```

### Backend
```
backend/
├── controllers/        # Route handlers
├── services/          # Business logic
├── middleware/        # Express middleware
├── routes/            # API routes
├── config/            # Configuration
└── utils/             # Helper functions
```

## Design Patterns

### API Response Format
```json
{
  "success": true,
  "data": {},
  "error": null,
  "message": ""
}
```

### Error Handling
- Client: Show user-friendly messages
- Server: Log detailed errors, return safe messages
- Always provide fallback UI states

### Database Queries
- Use parameterized queries
- Handle connection pool properly
- Implement pagination for lists
- Add appropriate indexes

## Development Workflow
1. Read this planning document
2. Check TASK.md for current tasks
3. Follow patterns in examples/ directory
4. Write tests alongside features
5. Ensure all platforms work
6. Update documentation as needed

## Performance Considerations
- Lazy load data when possible
- Implement proper caching strategies
- Optimize images and assets
- Use pagination for large datasets
- Monitor database query performance

## Security Guidelines
- Never commit secrets
- Validate all inputs
- Use HTTPS in production
- Implement rate limiting
- Follow OWASP guidelines
- Regular dependency updates

## Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows
- API endpoint testing
- Aim for >80% coverage

## Documentation Requirements
- Update README.md for setup changes
- Document all API endpoints
- Include code examples
- Explain complex logic
- Keep TASK.md current

## Constraints & Limitations
- [List any technical constraints]
- [Budget or time limitations]
- [Performance requirements]
- [Compatibility requirements]