# Context Engineering Template - Flutter & Node.js

A comprehensive template for getting started with Context Engineering - the discipline of engineering context for AI coding assistants so they have the information necessary to get the job done end to end.

> **Context Engineering is 10x better than prompt engineering and 100x better than vibe coding.**

## 🚀 Quick Start

```bash
# 1. Clone this template
git clone https://github.com/your-username/context-engineering-flutter-node

# 2. Set up your project rules (optional - template provided)
# Edit CLAUDE.md to add your project-specific guidelines

# 3. Add examples (highly recommended)
# Place relevant code examples in the examples/ folder

# 4. Review PLANNING.md
# Understand the project architecture and constraints

# 5. Create your initial feature request
# Edit INITIAL.md with your feature requirements

# 6. Use Context Engineering with your AI assistant
# Provide INITIAL.md and relevant files to your AI coding assistant
# The AI will use the context to implement your feature properly
```

## 📚 Table of Contents

- [What is Context Engineering?](#what-is-context-engineering)
- [Template Structure](#template-structure)
- [Step-by-Step Guide](#step-by-step-guide)
- [Writing Effective INITIAL.md Files](#writing-effective-initialmd-files)
- [The PRP Workflow](#the-prp-workflow)
- [Using Examples Effectively](#using-examples-effectively)
- [Best Practices](#best-practices)

## What is Context Engineering?

Context Engineering represents a paradigm shift from traditional prompt engineering:

### Prompt Engineering vs Context Engineering

**Prompt Engineering:**
- Focuses on clever wording and specific phrasing
- Limited to how you phrase a task
- Like giving someone a sticky note

**Context Engineering:**
- A complete system for providing comprehensive context
- Includes documentation, examples, rules, patterns, and validation
- Like writing a full screenplay with all the details

### Why Context Engineering Matters

1. **Reduces AI Failures**: Most agent failures aren't model failures - they're context failures
2. **Ensures Consistency**: AI follows your project patterns and conventions
3. **Enables Complex Features**: AI can handle multi-step implementations with proper context
4. **Self-Correcting**: Validation loops allow AI to fix its own mistakes

## Template Structure

```
context-engineering-flutter-node/
├── PRPs/
│   └── templates/
│       └── prp_base.md       # Base template for PRPs
├── examples/                  # Your code examples (critical!)
│   ├── flutter/              # Flutter patterns and examples
│   └── backend/              # Node.js patterns and examples
├── frontend/                 # Your Flutter application
├── backend/                  # Your Node.js backend
├── CLAUDE.md                 # Global rules for AI assistant
├── INITIAL.md                # Template for feature requests
├── INITIAL_EXAMPLE.md        # Example feature request
├── PLANNING.md               # Project architecture and goals
├── TASK.md                   # Task tracking
└── README.md                 # This file
```

## Step-by-Step Guide

### 1. Set Up Global Rules (CLAUDE.md)

The `CLAUDE.md` file contains project-wide rules that the AI assistant will follow in every conversation. The template includes:

- **Project awareness**: Reading planning docs, checking tasks
- **Code structure**: File size limits, module organization
- **Testing requirements**: Unit test patterns, coverage expectations
- **Style conventions**: Language preferences, formatting rules
- **Documentation standards**: Docstring formats, commenting practices

**You can use the provided template as-is or customize it for your project.**

### 2. Create Your Initial Feature Request

Edit `INITIAL.md` to describe what you want to build:

```markdown
## FEATURE:
[Describe what you want to build - be specific about functionality and requirements]

## PLATFORMS:
[iOS, Android, Web - specify which platforms you're targeting]

## EXAMPLES:
[List any example files in the examples/ folder and explain how they should be used]

## DOCUMENTATION:
[Include links to relevant documentation, APIs, or packages]

## OTHER CONSIDERATIONS:
[Mention any gotchas, specific requirements, or things AI assistants commonly miss]
```

**See `INITIAL_EXAMPLE.md` for a complete example.**

### 3. Working with PRPs

PRPs (Product Requirements Prompts) are comprehensive implementation blueprints that include:

- Complete context and documentation
- Implementation steps with validation
- Error handling patterns
- Test requirements

To use PRPs effectively:

1. **Create a PRP** using the template in `PRPs/templates/prp_base.md`
2. **Fill in all sections** with specific requirements for your feature
3. **Include relevant documentation** links and example references
4. **Define clear success criteria** and validation steps

### 4. Implementing Features with AI

When working with an AI coding assistant:

1. **Provide comprehensive context**:
   - Share CLAUDE.md for project rules
   - Include INITIAL.md or your PRP
   - Reference relevant example files
   - Share PLANNING.md for architecture understanding

2. **The AI will**:
   - Read all provided context
   - Follow established patterns
   - Implement features across Flutter and Node.js
   - Create tests alongside implementation
   - Validate work against success criteria

## Writing Effective INITIAL.md Files

### Key Sections Explained

**FEATURE**: Be specific and comprehensive
- ❌ "Build a chat feature"
- ✅ "Build an async real-time chat with typing indicators, read receipts, image sharing, and offline support for iOS/Android/Web"

**PLATFORMS**: Specify target platforms
- iOS (minimum version)
- Android (minimum SDK)
- Web (browser requirements)

**EXAMPLES**: Leverage the examples/ folder
- Place relevant code patterns in `examples/`
- Reference specific files and patterns to follow
- Explain what aspects should be mimicked

**DOCUMENTATION**: Include all relevant resources
- Flutter package documentation
- Node.js/Express API documentation
- Database schema requirements
- Third-party service docs

**OTHER CONSIDERATIONS**: Capture important details
- Platform-specific differences
- Performance requirements
- Common pitfalls
- Security considerations

## The PRP Workflow

### Creating Effective PRPs

When creating a PRP:

1. **Research Phase**
   - Analyze your Flutter and Node.js codebase
   - Look for similar implementations
   - Identify conventions to follow

2. **Documentation Gathering**
   - Include relevant Flutter/Dart docs
   - Add Node.js/Express patterns
   - Reference package documentation

3. **Blueprint Creation**
   - Create step-by-step implementation plan
   - Include validation gates
   - Add test requirements

4. **Quality Check**
   - Ensure all context is included
   - Verify success criteria are measurable
   - Check that examples are referenced

### Using PRPs with AI

When providing a PRP to an AI assistant:

1. **Load Context**: Share the entire PRP document
2. **Planning**: AI creates detailed task list
3. **Execution**: AI implements each component
4. **Validation**: AI runs tests and linting
5. **Iteration**: AI fixes any issues found
6. **Completion**: AI ensures all requirements are met

## Using Examples Effectively

The `examples/` folder is **critical** for success. AI coding assistants perform much better when they can see patterns to follow.

### What to Include in Examples

#### Flutter Examples (`examples/flutter/`)
1. **API Service Pattern** - How you handle HTTP requests
2. **State Management** - Your chosen pattern (Provider/Riverpod/Bloc)
3. **Model Classes** - JSON serialization patterns
4. **Widget Structure** - How you organize UI components
5. **Navigation** - Routing patterns

#### Backend Examples (`examples/backend/`)
1. **Controller Pattern** - Express route handlers
2. **Service Layer** - Business logic organization
3. **Database Operations** - Prisma/Sequelize patterns
4. **Middleware** - Auth, validation, error handling
5. **API Response Format** - Consistent structure

### Example Structure

```
examples/
├── README.md           # Explains what each example demonstrates
├── flutter/
│   ├── api_service.dart       # HTTP client pattern
│   ├── auth_provider.dart     # State management example
│   ├── user_model.dart        # Data model pattern
│   └── home_screen.dart       # Screen structure pattern
└── backend/
    ├── auth.controller.js     # Controller pattern
    ├── user.service.js        # Service pattern
    ├── auth.middleware.js     # Middleware pattern
    └── prisma.service.js      # Database pattern
```

## Best Practices

### 1. Be Explicit in INITIAL.md
- Don't assume the AI knows your preferences
- Include specific requirements and constraints
- Reference examples liberally
- Specify target platforms clearly

### 2. Provide Comprehensive Examples
- More examples = better implementations
- Show both what to do AND what not to do
- Include error handling patterns
- Show platform-specific code

### 3. Use Validation Gates
- PRPs include test commands that must pass
- AI will iterate until all validations succeed
- This ensures working code on first try

### 4. Platform Considerations
- Always specify which platforms (iOS/Android/Web)
- Include platform-specific requirements
- Note UI differences between platforms
- Test on all target platforms

### 5. Customize CLAUDE.md
- Add your Flutter conventions
- Include Node.js standards
- Define API patterns
- Specify testing requirements

## Tech Stack Configuration

### Flutter Frontend
- **Framework**: Flutter 3.x+
- **State Management**: Provider/Riverpod/Bloc (specify in INITIAL.md)
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences/Hive
- **Navigation**: GoRouter

### Node.js Backend
- **Runtime**: Node.js 20.x LTS
- **Framework**: Express.js
- **Database**: PostgreSQL with pg driver
- **Authentication**: JWT
- **Validation**: Manual or library of choice
- **API Documentation**: Swagger (optional)

### Development Environment
- **Docker**: For PostgreSQL and other services
- **Hot Reload**: Both Flutter and Node.js
- **Testing**: Jest (backend), Flutter test (frontend)

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Flutter Documentation](https://docs.flutter.dev)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)