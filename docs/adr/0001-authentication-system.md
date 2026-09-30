# 1. Authentication System

## Status

Accepted

## Date

2026-09-30

## Context

The Schwinn Stationary Bike dashboard needs a secure authentication system to protect user data and provide access control between regular users and administrators. The system must support:

- User registration and login
- Password reset functionality
- Role-based access control (admin vs regular user)
- Session management
- Security best practices for password handling

## Decision

We will implement an authentication system based on FastAPI sessions with SQLite backend storage, using the following components:

1. **Session-based Authentication**: Use Starlette's `SessionMiddleware` to maintain user state across requests.

2. **Password Security**:
   - Passwords are hashed using Werkzeug's `check_password_hash` for verification
   - Password reset tokens use `itsdangerous.URLSafeTimedSerializer` with a configurable salt
   - Minimum password length is 8 characters

3. **Role-based Access Control**:
   - Two roles: admin and user
   - Admin users have full access to all features including admin panels
   - Regular users can only access their own data and dashboard features

4. **Email-based Authentication**:
   - User accounts are identified by email addresses
   - Email verification for admin accounts (optional but recommended)
   - Password reset emails sent via configured SMTP settings

5. **Security Considerations**:
   - Session cookies use `SessionMiddleware` with configurable secure flags
   - Password reset tokens expire after 1 hour by default
   - Audit logging for authentication events
   - Protection against brute-force attacks through rate limiting (not implemented in this ADR but should be considered)

## Rationale

The decision to implement session-based authentication using FastAPI's middleware pattern was made because:
- It provides a standard, well-tested approach to web application authentication
- It integrates cleanly with the existing FastAPI application architecture
- It supports both HTTP and HTTPS deployments properly through configuration
- The system needs to maintain user state across multiple requests for a dashboard application
- Session management is simpler than token-based approaches for this specific use case

## Consequences

### Positive

- Secure, well-tested authentication patterns using established libraries
- Clear separation between admin and user roles
- Password reset functionality with token-based security
- Audit logging for security events
- Session management that persists across requests

### Negative

- Requires proper configuration of environment variables for SMTP and secret keys
- SQLite database storage may not scale for very large deployments
- Session cookies need to be properly configured for production environments (secure flag, HttpOnly)
- Password reset functionality requires a working email system

### Neutral

- User registration is enabled by default but can be disabled by admin
- Admin setup is required before any user can log in
- The system supports both local development and containerized deployments

## Alternatives Considered

1. **JWT-based Authentication**: While JWT would provide stateless authentication, it's more complex to implement with proper refresh token handling and session management for a web application like this.

2. **OAuth2 Integration**: Adding OAuth2 would provide integration with external identity providers but adds complexity that isn't required for this specific use case.

3. **Token-based Authentication with Redis**: Using Redis for session storage could provide better scalability than SQLite, but introduces another dependency and complexity.

4. **Basic Auth**: Would be less user-friendly and not suitable for a web application with dashboard features.

## Supersession Criteria

This ADR may be superseded if:
- The system needs to support distributed deployments where session state cannot be maintained
- A requirement arises for integration with external identity providers (e.g., SAML, OAuth2)
- Security requirements change significantly

## Cross-links

- [0002-authentication-security.md](0002-authentication-security.md) - Security considerations for authentication
