# Testing Anti-Patterns

Load this reference when:
- Writing or changing tests
- Adding or reviewing mocks, spies, fakes, or stubs
- Considering test-only methods or fields in production code
- Reviewing whether a test really follows the written specification

## Overview

Tests must verify behavior promised by the specification, not behavior that happens to exist in the current implementation.

**Core principle:** if an assertion cannot be traced back to the specification, it is suspect.

Use this reference with `writing-technical-specifications` and `specification-driven-tdd`.

## Gate Before Any Test Assertion

Before keeping any assertion, ask:

```text
1. What clause in the specification justifies this assertion?
2. Is this checking an observable result, exception, mutation, or side effect?
3. Am I asserting an implementation detail instead of the contract?
```

If you cannot point to the specification, rewrite the test or fix the specification first.

## Anti-Pattern 1: Testing Mock Behavior Instead of Contract Behavior

**The violation:**

```typescript
test('renders sidebar', () => {
  render(<Page />);
  expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
});
```

**Why this is wrong:**
- It proves the mock rendered, not that the real contract was satisfied
- The assertion usually has no basis in the specification
- The test becomes coupled to test scaffolding rather than product behavior

**The fix:**

```typescript
test('renders primary navigation', () => {
  render(<Page />);
  expect(screen.getByRole('navigation')).toBeInTheDocument();
});
```

If the dependency must be replaced for isolation, assert the caller's specified behavior, not the mock's presence.

### Gate Function

```text
BEFORE asserting on a mock-derived artifact:
  Ask: "Is this observable behavior promised by the specification?"

  IF no:
    STOP - Delete the assertion or unmock the dependency

  Test the specified behavior instead
```

## Anti-Pattern 2: Test-Only Methods in Production Code

**The violation:**

```typescript
class Session {
  async destroy() {
    await this._workspaceManager?.destroyWorkspace(this.id);
  }
}
```

Used only from tests:

```typescript
afterEach(() => session.destroy());
```

**Why this is wrong:**
- It adds public surface area not required by the specification
- It leaks test setup or cleanup concerns into production design
- It pressures the contract to mirror the test harness instead of real behavior

**The fix:**

```typescript
export async function cleanupSession(session: Session) {
  const workspace = session.getWorkspaceInfo();
  if (workspace) {
    await workspaceManager.destroyWorkspace(workspace.id);
  }
}
```

Use test utilities for test concerns unless cleanup behavior is itself part of the production contract.

### Gate Function

```text
BEFORE adding a method, field, or option for tests:
  Ask: "Is this required by the written specification?"

  IF no:
    STOP - Do not add it to production code
    Put it in test utilities or fixtures instead
```

## Anti-Pattern 3: Mocking Without Understanding Contract-Relevant Behavior

**The violation:**

```typescript
test('detects duplicate server', async () => {
  vi.mock('ToolCatalog', () => ({
    discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
  }));

  await addServer(config);
  await addServer(config);
});
```

**Why this is wrong:**
- The mock may remove side effects the contract depends on
- The test can fail or pass for reasons unrelated to the specification
- It hides which dependency behavior is actually necessary

**The fix:**

Mock only the lower-level behavior you truly need to isolate, while preserving contract-relevant outcomes.

```typescript
test('detects duplicate server', async () => {
  vi.mock('MCPServerManager');

  await addServer(config);
  await expect(addServer(config)).rejects.toThrow(DuplicateServerError);
});
```

### Gate Function

```text
BEFORE mocking any dependency:
  1. Ask: "What specified behavior is this test trying to verify?"
  2. Ask: "Which real side effects are required for that behavior to happen?"
  3. Ask: "Will this mock preserve those contract-relevant effects?"

  IF unsure:
    Run the test against the real dependency path first
    Observe what behavior is actually required
    Then mock the lowest safe layer
```

## Anti-Pattern 4: Incomplete Mocks That Break the Contract Shape

**The violation:**

```typescript
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' }
};
```

**Why this is wrong:**
- It may not match the contract shape the system actually consumes
- It can hide downstream assumptions until integration time
- It gives false confidence because the double does not behave like the specified dependency

**The fix:**

Use complete, contract-faithful test doubles.

```typescript
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' },
  metadata: { requestId: 'req-789', timestamp: 1234567890 }
};
```

### Gate Function

```text
BEFORE creating a fake response or object:
  Ask: "What does the real contract for this dependency guarantee?"

  Actions:
    1. Read the real type or specification
    2. Preserve all fields and behaviors the caller may rely on
    3. Do not invent a narrower structure just because this test uses less
```

## Anti-Pattern 5: Spies on Internal Choreography

**The violation:**

```typescript
test('processes the order', async () => {
  const validateSpy = vi.spyOn(orderService, 'validate');
  const persistSpy = vi.spyOn(orderRepo, 'save');

  await submitOrder(order);

  expect(validateSpy).toHaveBeenCalledBefore(persistSpy);
});
```

**Why this is wrong:**
- Call order is usually an implementation detail
- The specification rarely promises helper choreography
- The test blocks harmless refactors while adding little confidence

**The fix:**

Assert the specified outcome:

```typescript
test('stores a valid order and returns its identifier', async () => {
  const result = await submitOrder(order);
  expect(result.orderId).toBeDefined();
});
```

Only assert call ordering if the specification explicitly makes that ordering observable.

## Anti-Pattern 6: Tests Written After Implementation as "Verification"

**The violation:**

```text
Implementation complete
Now writing tests to verify it
```

**Why this is wrong:**
- Tests written after the fact tend to mirror implementation details
- Passing immediately does not prove the test can detect a missing behavior
- The specification is no longer clearly driving design

**The fix:**

Follow the spec-driven sequence:

```text
1. Write or confirm the specification
2. Write a failing contract test
3. Implement the minimum code to pass
4. Refactor without changing the contract
```

If code came first and there were no failing tests, write the specification, delete the code, and restart.

## When Mocks Become a Smell

Warning signs:
- Mock setup is longer than the test body
- The test fails only because a mock shape changed
- You need multiple spies to prove one behavior
- You cannot explain why each mock is necessary in contract terms
- The mock exposes internals not mentioned in the specification

Usually this means one of three things:
- The test is asserting internals
- The mock is at the wrong level
- An integration-style test would be simpler and more faithful

## Quick Review Checklist

Use this when reviewing test quality:

- [ ] Can every assertion be traced to the specification?
- [ ] Does the test verify observable behavior rather than internal choreography?
- [ ] Are mocks preserving contract-relevant behavior?
- [ ] Are fake objects faithful to the real contract shape?
- [ ] Did we avoid adding production APIs solely for tests?
- [ ] Did the test fail before implementation existed?

## Bottom Line

Mocks are tools to isolate. They are not the thing being verified.

In specification-driven TDD, a good test is one that would still be valid after a full internal rewrite, as long as the specification stays the same.
