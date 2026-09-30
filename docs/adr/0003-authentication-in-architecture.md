# 3. Authentication in System Architecture

## Status

Accepted

## Date

2026-09-30

## Context

The Schwinn Stationary Bike dashboard is a FastAPI web application that requires authentication to protect user data and control access to sensitive features. Understanding how authentication fits into the overall system architecture is crucial for designing a secure, maintainable, and scalable solution.

## Decision

Authentication is implemented as a core architectural component that:

1. **Integrates with Application Flow**:
   - Authentication is enforced through Starlette's `SessionMiddleware` 
   - Public endpoints are clearly defined in configuration
   - Admin setup is required before regular user authentication is possible

2. **Uses Established Web Patterns**:
   - Session-based authentication for state management using `SessionMiddleware`
   - Form-based login and registration workflows
   - Password reset via email with time-limited tokens

3. **Maintains Separation of Concerns**:
   - Authentication logic is separated into dedicated service modules
   - User data storage is separate from business logic
   - Security concerns are handled in dedicated components

4. **Supports Containerized Deployment**:
   - Configuration via environment variables
   - Default paths for data files that can be overridden
   - Compatibility with Docker deployment patterns

## Rationale

The authentication system was designed to integrate cleanly with the existing FastAPI architecture while maintaining security and usability:

- The session-based approach using `SessionMiddleware` is well-suited for this dashboard application
- Separation of concerns allows for easier maintenance and testing
- The system supports both development and production deployment patterns
- Security is handled at the application level with proper logging and audit capabilities

## Consequences

### Positive

- Clear separation between authentication logic and business logic
- Easy to understand and maintain authentication flow
- Supports both development and production deployment patterns
- Follows established web application security practices
- Modular design allows for future enhancements

### Negative

- Session-based approach may not scale well in distributed environments
- SQLite database storage is limited compared to more robust databases
- Authentication system requires proper configuration for secure operation
- Email functionality is required for full password reset feature

### Neutral

- The system supports both HTTP and HTTPS deployments
- Default configurations are provided but can be customized
- Security is handled at the application level rather than infrastructure level
- All authentication flows are designed to be user-friendly

## Alternatives Considered

1. **JWT-based Authentication**: Would provide stateless authentication but would require more complex token refresh handling and doesn't integrate well with the existing session management patterns.

2. **OAuth2 Integration**: Would provide enterprise identity integration but adds complexity that isn't required for this specific use case.

3. **API Key Authentication**: Not suitable for a dashboard application with user accounts and personal data access.

4. **Custom Security Framework**: Would provide maximum control but would require significant development effort and maintenance overhead.

## Supersession Criteria

This ADR may be superseded if:
- The system needs to support distributed deployments where session state cannot be maintained
- A requirement arises for integration with external identity providers (e.g., SAML, OAuth2)
- Security requirements change significantly

## Cross-links

- [0001-authentication-system.md](0001-authentication-system.md) - Overall authentication system design
- [0002-authentication-security.md](0002-authentication-security.md) - Security considerations for authentication
