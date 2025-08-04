## FEATURE:

Real-time task management application with collaborative features. Users can create projects, add tasks, assign them to team members, track progress, and receive notifications. The app should work offline and sync when connection is restored.

## PLATFORMS:

- iOS (minimum version: 12.0)
- Android (minimum SDK: 21)
- Web (Chrome 90+, Firefox 88+, Safari 14+)

## TECHNICAL REQUIREMENTS:

### Flutter Frontend
- State Management: Provider
- Local Storage: Hive for offline task storage
- Push Notifications: Firebase Cloud Messaging
- Real-time Updates: Socket.io client

### Node.js Backend  
- Database: PostgreSQL with pg driver
- Authentication: JWT with refresh tokens
- Real-time: Socket.io for live updates
- File Storage: Local filesystem for attachments

## CORE FEATURES:

1. **User Management**
   - Registration/Login with email
   - User profiles with avatars
   - Team invitation system

2. **Project Management**
   - Create/Edit/Delete projects
   - Add team members to projects
   - Project templates

3. **Task Management**
   - Create tasks with title, description, due date
   - Assign tasks to team members
   - Add attachments to tasks
   - Task status (Todo, In Progress, Done)
   - Task comments and activity log

4. **Real-time Collaboration**
   - Live task updates
   - Online presence indicators
   - Typing indicators in comments
   - Push notifications for assignments

5. **Offline Support**
   - Cache projects and tasks locally
   - Queue changes when offline
   - Sync when reconnected
   - Conflict resolution

## EXAMPLES:

In the `examples/` folder:
- `examples/flutter/user.dart` - Follow this structure for data models
- `examples/flutter/router.dart` - Navigation patterns with GoRouter
- `examples/flutter/app_validators.dart` - Form validation patterns
- `examples/backend/users.controllers.js` - Controller patterns
- `examples/backend/db.js` - Database connection pattern

## DOCUMENTATION:

- Provider package: https://pub.dev/packages/provider
- Hive documentation: https://docs.hivedb.dev/
- Socket.io client for Flutter: https://pub.dev/packages/socket_io_client
- PostgreSQL documentation: https://www.postgresql.org/docs/
- JWT implementation: https://github.com/auth0/node-jsonwebtoken

## OTHER CONSIDERATIONS:

### Platform-Specific:
- **iOS**: Need push notification certificates
- **Android**: Configure Firebase for FCM
- **Web**: Implement service worker for offline support

### Performance:
- Paginate task lists (50 items per page)
- Lazy load project members
- Compress images before upload
- Cache frequently accessed data

### Security:
- Validate all inputs on backend
- Implement rate limiting
- Secure file uploads (max 10MB)
- Project-level permissions

### UI/UX:
- Material Design on Android
- Cupertino widgets on iOS  
- Responsive design for tablets
- Dark mode support
- Accessibility labels

### Known Gotchas:
- Socket.io connection must be singleton in Flutter
- Hive requires initialization before use
- iOS notifications need special handling when app is killed
- Database schema must be set up before server start
- Handle JWT expiration gracefully

### Testing Requirements:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows
- API endpoint tests
- Test offline/online transitions