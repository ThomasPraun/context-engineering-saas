name: "Flutter/Node.js PRP Template"
description: |

## Purpose
Template optimized for AI agents to implement Flutter multiplatform features with Node.js backend, including sufficient context and self-validation capabilities.

## Core Principles
1. **Context is King**: Include ALL necessary documentation, examples, and platform considerations
2. **Validation Loops**: Provide executable tests the AI can run and fix
3. **Platform Awareness**: Consider iOS, Android, and Web differences
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global Rules**: Follow all rules in CLAUDE.md

---

## Goal
[What needs to be built - be specific about the end state across all platforms]

## Why
- [Business value and user impact]
- [Integration with existing features]
- [Problems this solves]

## What
[User-visible behavior and technical requirements]

### Success Criteria
- [ ] Works on iOS, Android, and Web
- [ ] [Specific measurable outcomes]
- [ ] All tests passing
- [ ] Performance targets met

## All Needed Context

### Documentation & References
```yaml
# MUST READ - Include these in your context window
- url: [Flutter documentation URL]
  why: [Specific widgets or patterns needed]
  
- url: [Node.js/Express documentation]
  why: [Backend patterns needed]
  
- file: examples/flutter/[file].dart
  why: [Pattern to follow]
  
- file: examples/backend/[file].js  
  why: [Backend pattern to follow]
  
- doc: [Package documentation]
  critical: [Key insight that prevents errors]
```

### Current Codebase Structure
```bash
frontend/
├── lib/
│   ├── models/
│   ├── providers/
│   ├── services/
│   ├── screens/
│   └── widgets/

backend/
├── controllers/
├── services/
├── middleware/
├── models/
└── routes/
```

### Platform-Specific Considerations
```yaml
iOS:
  - Minimum version: 
  - Special permissions:
  - Platform-specific UI:
  
Android:
  - Minimum SDK:
  - Permissions needed:
  - Material Design considerations:
  
Web:
  - Browser support:
  - Responsive breakpoints:
  - PWA considerations:
```

### Known Gotchas
```dart
// Flutter gotchas
// Example: setState() called after dispose()
// Example: Platform.isIOS doesn't work on web
```

```javascript
// Node.js gotchas
// Example: Prisma connection pool limits
// Example: JWT expiration handling
```

## Implementation Blueprint

### Data Models

#### Flutter Models
```dart
// lib/models/[model].dart
class Model {
  // Follow pattern from examples
  
  factory Model.fromJson(Map<String, dynamic> json) {
    // Handle null values
  }
  
  Map<String, dynamic> toJson() {
    // Convert to JSON
  }
}
```

#### Backend Database Schema
```prisma
// Prisma schema additions
model NewModel {
  id        String   @id @default(uuid())
  // fields
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

### Implementation Tasks

```yaml
Task 1 - Backend API Setup:
  CREATE controllers/[feature].controller.js:
    - PATTERN: Follow existing controller pattern
    - IMPLEMENT: CRUD operations
    - USE: Input validation
    - INCLUDE: Error handling

  CREATE services/[feature].service.js:
    - PATTERN: Business logic separation
    - USE: Prisma for database
    - IMPLEMENT: Complex operations

  UPDATE routes/index.js:
    - ADD: New routes
    - USE: Authentication middleware

Task 2 - Flutter State Management:
  CREATE lib/providers/[feature]_provider.dart:
    - PATTERN: Follow existing providers
    - USE: ChangeNotifier
    - IMPLEMENT: State management
    - HANDLE: Loading and error states

Task 3 - Flutter UI Implementation:
  CREATE lib/screens/[feature]_screen.dart:
    - USE: Scaffold structure
    - IMPLEMENT: Platform-specific UI
    - ADD: Responsive design
    - HANDLE: All states

  CREATE lib/widgets/[feature]_widget.dart:
    - KEEP: Reusable and focused
    - USE: Platform adaptive widgets

Task 4 - Integration:
  UPDATE lib/services/api_service.dart:
    - ADD: New endpoints
    - IMPLEMENT: Error handling
    - USE: Dio interceptors

Task 5 - Testing:
  CREATE test/[feature]_test.dart:
    - TEST: Widget rendering
    - TEST: State management
    - TEST: API integration

  CREATE backend/tests/[feature].test.js:
    - TEST: All endpoints
    - TEST: Business logic
    - TEST: Error cases
```

### Integration Points
```yaml
API Endpoints:
  - GET /api/[resource]
  - POST /api/[resource]
  - PUT /api/[resource]/:id
  - DELETE /api/[resource]/:id

Database:
  - Migration needed
  - Indexes to add
  
Flutter Navigation:
  - Add to router
  - Deep linking setup
```

## Validation Loop

### Level 1: Linting
```bash
# Flutter
flutter analyze

# Backend
npm run lint
```

### Level 2: Unit Tests
```bash
# Flutter
flutter test

# Backend
npm test
```

### Level 3: Platform Testing
```bash
# iOS
flutter run -d ios

# Android  
flutter run -d android

# Web
flutter run -d chrome
```

### Level 4: Integration Testing
```bash
# Start backend
npm run dev

# Test API
curl http://localhost:3000/api/endpoint

# Run Flutter integration tests
flutter test integration_test/
```

## Final Validation Checklist
- [ ] Flutter: No analyzer issues
- [ ] Backend: No linting errors
- [ ] All unit tests passing
- [ ] Works on all platforms
- [ ] Responsive design verified
- [ ] API documented
- [ ] Error handling complete
- [ ] Performance acceptable
- [ ] Security reviewed

## Anti-Patterns to Avoid
- ❌ Don't hardcode values
- ❌ Don't skip platform testing
- ❌ Don't ignore error states
- ❌ Don't forget loading indicators
- ❌ Don't trust client validation alone
- ❌ Don't use synchronous I/O
- ❌ Don't skip null checks
- ❌ Don't ignore offline scenarios