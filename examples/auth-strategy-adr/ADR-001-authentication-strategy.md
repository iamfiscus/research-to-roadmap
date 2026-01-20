# ADR-001: Authentication Strategy for Microservices

## Status

**Accepted** (2024-01-15)

**Deciders**: Alex Thompson (Architect), Maria Garcia (Security Lead), James Wilson (Platform Lead)
**Technical Story**: PLAT-1847

## Context and Problem Statement

We are migrating from a monolithic Rails application to a microservices architecture. The current session-based authentication (Rails sessions with Redis) does not translate well to a distributed system where:

- Multiple services need to authenticate requests
- Services communicate via both synchronous (REST) and asynchronous (events) channels
- Mobile apps require long-lived sessions
- Third-party integrations need scoped API access

**Key Question**: How should we authenticate and authorize requests across our microservices?

## Decision Drivers

1. **Security**: Must meet SOC 2 and GDPR requirements
2. **Scalability**: Support 10x current traffic without auth bottleneck
3. **Developer Experience**: Easy to implement in new services
4. **Performance**: Auth check must add <10ms latency
5. **Flexibility**: Support user sessions, service-to-service, and API keys
6. **Operational Simplicity**: Minimize new infrastructure

## Considered Options

### Option 1: JWT (JSON Web Tokens)
Stateless tokens containing claims, signed by auth service.

### Option 2: Session Tokens with Centralized Store
Traditional sessions stored in Redis, validated on each request.

### Option 3: OAuth 2.0 with External IdP
Delegate to Auth0, Okta, or similar identity provider.

### Option 4: mTLS (Mutual TLS)
Certificate-based authentication between services.

## Decision Outcome

**Chosen option**: **Option 1 - JWT**, because it provides the best balance of scalability, developer experience, and operational simplicity for our microservices architecture.

We will implement JWT with the following specifications:
- Short-lived access tokens (15 minutes)
- Long-lived refresh tokens (7 days) stored in database
- RS256 signing algorithm with key rotation
- Standard claims plus custom `roles` and `permissions` claims

### Positive Consequences

- **Stateless validation**: Services can validate tokens without network calls
- **Scalability**: No centralized session store bottleneck
- **Flexibility**: Claims can carry authorization info
- **Standard**: Well-understood pattern, good library support
- **Mobile-friendly**: Works well with native apps

### Negative Consequences

- **Token revocation complexity**: Cannot instantly revoke tokens
- **Token size**: JWTs are larger than session IDs (~800 bytes vs 32 bytes)
- **Key management**: Must implement secure key rotation
- **Clock skew sensitivity**: Requires synchronized clocks across services

## Pros and Cons of the Options

### Option 1: JWT

**Implementation approach**: Auth service issues JWTs on login, services validate locally using public key.

* Good, because stateless - no session store needed
* Good, because claims carry user context (reduces service calls)
* Good, because standard format with excellent library support
* Good, because works for both user and service-to-service auth
* Bad, because cannot instantly revoke tokens
* Bad, because token size increases header overhead
* Bad, because key rotation adds operational complexity

### Option 2: Session Tokens with Centralized Store

**Implementation approach**: Auth service issues opaque tokens, validates against Redis on each request.

* Good, because instant revocation possible
* Good, because small token size
* Good, because familiar pattern from monolith
* Bad, because Redis becomes single point of failure
* Bad, because every request requires Redis lookup
* Bad, because session store must scale with traffic
* Bad, because doesn't work well for service-to-service

### Option 3: OAuth 2.0 with External IdP

**Implementation approach**: Use Auth0 or Okta for all authentication flows.

* Good, because offloads security complexity
* Good, because built-in MFA, SSO, social login
* Good, because compliance certifications included
* Bad, because vendor lock-in and ongoing cost (~$3/user/month)
* Bad, because latency for token validation (external call)
* Bad, because less control over token contents
* Bad, because complex for service-to-service auth

### Option 4: mTLS

**Implementation approach**: Services authenticate via client certificates.

* Good, because very secure (mutual authentication)
* Good, because no tokens to steal
* Good, because works at network level
* Bad, because complex certificate management
* Bad, because doesn't carry user identity (only service identity)
* Bad, because difficult for mobile/browser clients
* Bad, because steep learning curve for team

## Technical Details

### Token Structure

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "key-2024-01"
  },
  "payload": {
    "sub": "user-123",
    "iss": "auth.ourcompany.com",
    "aud": "api.ourcompany.com",
    "exp": 1705330800,
    "iat": 1705329900,
    "roles": ["user", "premium"],
    "permissions": ["read:orders", "write:profile"],
    "org_id": "org-456"
  }
}
```

### Token Revocation Strategy

Since JWTs cannot be instantly revoked, we implement:

1. **Short expiry** (15 min) limits exposure window
2. **Refresh token rotation** - each refresh issues new refresh token
3. **Token blacklist** (Redis) for critical revocations - only checked for sensitive operations
4. **Logout propagates** via event to invalidate refresh tokens

### Key Rotation

- RSA 2048-bit keys
- New key generated monthly
- Old keys valid for 30 days after rotation
- Keys distributed via JWKS endpoint
- Services cache keys with 1-hour TTL

## Links

- [JWT RFC 7519](https://tools.ietf.org/html/rfc7519)
- [Security Review Notes](./security-review.md)
- [Implementation Estimate](./implementation-estimate.md)
- [Options Analysis Details](./options-analysis.md)
