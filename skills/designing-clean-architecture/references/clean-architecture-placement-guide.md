# Clean Architecture Placement Guide

Use this guide while designing software and reviewing code.
Place logic according to what the code means, not according to the framework that calls it.

## Core Rule

Put logic in the innermost layer that can own it without depending on outer details.

Dependency direction must always point inward.

```text
Frameworks / Infrastructure
        v
Interface / Adapters
        v
Application / Use Cases
        v
Domain / Business Rules
```

Outer layers may depend on inner layers.
Inner layers must never depend on outer layers.

## The Layers

### 1. Domain (Business Logic)

The domain defines the meaning of the business.

Put logic here when it answers:

- What rules define correctness?
- What states are valid?
- What invariants must always hold?
- What calculations define the product?

Examples:

- Invoice total calculation
- Refund cannot exceed original payment
- Order cannot ship before payment clears
- Subscription expiration rules
- Ownership rules
- Pricing logic
- Discount policies
- Allowed state transitions

Typical contents:

- Entities
- Value objects
- Domain services
- Business rules
- Invariants
- Core calculations

Domain must not know about:

- HTTP
- React or UI frameworks
- SQL or ORM models
- Framework request objects
- Authentication tokens
- Third-party SDKs
- Message queues
- File systems

Test:

If the web framework disappeared, this code would still make sense.

### 2. Application (Use Case Logic)

The application layer defines how the system carries out actions.

Put logic here when it answers:

- What happens when the user performs an action?
- What steps run in what order?
- Which domain rules must be applied?
- What external services are involved?

Examples:

- Checkout order
- Publish article
- Refund payment
- Invite team member
- Reset password
- Approve expense report
- Generate monthly invoice

Typical contents:

- Use cases
- Command handlers
- Orchestrators
- Application services
- Transaction boundaries
- Authorization policies tied to the action
- Interfaces for repositories and external services

Application must not know:

- Which database implements the repository
- Which framework called the use case
- How tokens are parsed
- How responses are rendered

Test:

The same use case could run from:

- An API
- A CLI
- A background job
- A test

### 3. Interface / Adapter Layer

This layer translates between the outside world and the application core.

Put logic here when it answers:

- How does an HTTP request map to a use case?
- How do domain results map to JSON or UI props?
- How do database rows map to domain objects?

Examples:

- Controllers
- Route handlers
- Presenters
- Serializers
- DTO mappers
- Repository implementations
- Form adapters

Typical responsibilities:

- Parse requests
- Validate input shape
- Call use cases
- Translate domain errors
- Map objects between layers

Test:

Adapters should remain thin.
If business rules appear here, move them inward.

### 4. Framework / Infrastructure

This layer contains tools, runtime wiring, and integrations.

Put logic here when it answers:

- How does the system run?
- How does the system talk to external services?

Examples:

- Express / Nest / Rails setup
- Database drivers
- Repository implementations
- Stripe client
- Email provider
- Redis cache
- Message queue clients
- File storage adapters
- OAuth configuration

Infrastructure should contain:

- Framework setup
- Configuration
- SDK usage
- Interface implementations

Infrastructure should not contain:

- Product policy
- Domain calculations
- Workflow decisions

Test:

You could swap the framework or vendor with minimal change to the core.

## Common Logic Placement

### Business Logic

Put in Domain when it defines the business itself.

Examples:

- Pricing rules
- Discount logic
- Ownership rules
- Eligibility rules
- State transitions

### Application Logic

Put in Application when it coordinates actions.

Examples:

- Load order
- Verify permissions
- Call payment service
- Persist results
- Emit events

### Authorization Logic

Split carefully.

Product policy -> Domain / Application

Examples:

- Only admins can refund above $500
- Free plans may create 3 projects
- Feature enabled only if org config allows it
- Only draft owner can publish

Security enforcement -> Infrastructure

Examples:

- Require login
- Parse JWT
- Verify session
- Middleware guards
- Cookie parsing

Rule:

```text
Authentication = edge
Authorization policy = core
Enforcement = edge
```

### Validation Logic

Input validation -> Adapter

Examples:

- Required JSON fields
- Malformed email
- Invalid enum values

Business validation -> Domain / Application

Examples:

- Cannot cancel shipped order
- Refund exceeds original payment
- Project name must be unique in organization

### Persistence

Repository interface: application/domain boundary.

Database implementation: infrastructure.

ORM models: adapters or infrastructure.

### UI Logic

Presentation logic -> UI layer

Examples:

- UI state
- Layout
- Button disabling
- Loading indicators

Business rules -> Domain/Application

Examples:

- Plan eligibility
- Permission checks
- Pricing calculations

### External Services

Split into:

Core interface:

```text
PaymentGateway
EmailService
NotificationPublisher
```

Infrastructure implementation:

```text
StripeGateway
SESService
KafkaPublisher
```

## Design Review Checklist

Use this checklist while designing a system.

### Domain

- [ ] Business rules live in domain code.
- [ ] Domain code contains no framework imports.
- [ ] Domain logic expresses invariants and policies.
- [ ] Domain objects do not depend on database models.
- [ ] Domain logic remains meaningful without UI or HTTP.

### Application

- [ ] Each major user action has a clear use case.
- [ ] Workflows live in application services or handlers.
- [ ] Use cases depend only on interfaces for external systems.
- [ ] Authorization rules tied to actions live here or in domain.
- [ ] Transactions or workflow coordination happen here.

### Adapters

- [ ] Controllers only map requests to use cases.
- [ ] Adapters convert between external and internal models.
- [ ] Adapters contain minimal business decisions.
- [ ] Input validation stays at the boundary.

### Infrastructure

- [ ] Framework setup lives here.
- [ ] SDK clients live here.
- [ ] Database implementations live here.
- [ ] Infrastructure implements interfaces defined inward.
- [ ] Infrastructure contains no business policy.

## Code Review Checklist

Use this when reviewing pull requests.

### Dependency Direction

- [ ] Inner layers do not import outer layers.
- [ ] Domain does not depend on frameworks or infrastructure.
- [ ] Use cases depend only on abstractions.

### Business Logic Placement

- [ ] Pricing rules live in domain code.
- [ ] Permission rules are not duplicated across controllers.
- [ ] Calculations are not embedded in UI components.
- [ ] Controllers do not contain product policy.

### Workflow Logic

- [ ] Controllers do not orchestrate workflows.
- [ ] Use cases coordinate the workflow.
- [ ] External service calls go through interfaces.

### Framework Leakage

- [ ] Domain types do not include framework types.
- [ ] Application services do not accept request objects.
- [ ] Business logic does not depend on ORM models.

### Duplication

- [ ] Authorization rules appear in one place.
- [ ] Pricing logic appears in one place.
- [ ] Domain calculations are reusable across use cases.

## Fast Placement Questions

Ask these in order.

1. Does this rule define the business? -> Domain
2. Does this coordinate a user action? -> Application
3. Does this translate between layers? -> Adapter
4. Does this talk to a tool or framework? -> Infrastructure

## Architecture Smells

### Controller-Heavy Logic

Controllers contain:

- Calculations
- Permission checks
- Workflow orchestration

Move logic inward.

### UI-Heavy Business Logic

React or UI components compute:

- Pricing
- Permission rules
- Eligibility logic

Move logic inward.

### ORM-Driven Domain

ORM models become the domain model.

This often causes:

- Persistence coupling
- Domain leakage
- Migration difficulty

### Excess Abstraction

- Interfaces without boundaries
- Five layers around simple CRUD

Architecture should match complexity.

## Default Design Workflow

1. Identify the use case.

Define:

- Actor
- Action
- Inputs
- Outputs
- Rules
- Side effects

2. Extract business rules.

Place them in domain logic.

3. Define boundaries.

Create interfaces for:

- Repositories
- Payment gateways
- Email services
- External APIs

4. Implement adapters.

Translate external input to use cases.

5. Implement infrastructure.

Provide concrete implementations.

## One-Sentence Rule

Place business rules in the domain, workflow in application, translation in adapters, and tool integration in infrastructure.
