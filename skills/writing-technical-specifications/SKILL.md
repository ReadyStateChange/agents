---
name: writing-technical-specifications
description: "Writes technical function and method specifications with preconditions and postconditions. Use when drafting technical specs, documenting function contracts, adding JSDoc/docstrings, or asked to specify behavior."
---

# Writing Technical Specifications

Write precise, implementation-independent function specifications using the **signature + effects** pattern. Specifications must define behavior for **all** representable inputs — no undefined behavior.

Good specifications optimize for three goals:

| Safe from bugs | Easy to understand | Ready for change |
| --- | --- | --- |
| Correct today and in the unknown future. | Communicates clearly with future programmers (including future you). | Accommodates change without forcing rewrites. |

## Core Principles

1. **No undefined behavior.** Every spec must define an outcome for every input the type system allows. Instead of leaving behavior undefined when a constraint is violated, first encode the constraint in the type system so the invalid input is unrepresentable; use exceptions/error returns only when the language cannot express the constraint directly.
2. **Make illegal states unrepresentable.** Use the type system to eliminate invalid states at compile time. When a business rule says "at least one of X or Y", don't use two optional fields — model the exact set of valid states with a union/discriminated type. If the type system can enforce it, the spec doesn't need a precondition for it.
3. **Prefer domain types over primitives.** When a primitive (`string`, `number`, etc.) has domain meaning (email, user ID, currency, percentage), prefer Branded/Opaque/refined types so invalid values are unrepresentable at compile time.

## Specification Structure

Every specification has two required parts and one optional part:

1. **Signature** — function name, parameter types, return type. Use precise types that make illegal inputs unrepresentable.
2. **Effects clause** (postcondition) — what the function guarantees for every valid input, including error cases.
3. **Requires clause** (precondition) — optional. Prefer encoding constraints in types first; when a constraint cannot be encoded in the type system, default to a **strong precondition** that captures the domain invariant. If runtime checking is needed, define violation behavior explicitly (usually via exceptions). If relaxing that constraint for flexibility, confirm with the human first and document the broader behavior precisely.

## Specification Dimensions

Every spec choice should be explicit on three dimensions.

### Deterministic vs. underdetermined

- **Deterministic spec**: exactly one valid output for each valid input.
- **Underdetermined spec**: multiple outputs may satisfy the postcondition; implementors may choose any.

Underdetermined is different from runtime nondeterminism. An underdetermined spec can still be satisfied by a deterministic implementation. Use underdetermined specs deliberately to preserve implementation freedom when clients do not need a uniquely determined result.

### Declarative vs. operational

- **Declarative**: describes what must be true of the result.
- **Operational**: describes how the function computes the result.

Prefer declarative specs almost always. Operational language leaks implementation strategy and can unintentionally constrain future changes.

### Stronger vs. weaker

A spec `S2` is stronger than `S1` when:

1. `S2` has a weaker-or-equal precondition (accepts at least all inputs of `S1`), and
2. `S2` has a stronger-or-equal postcondition (promises at least what `S1` promised for `S1`'s valid inputs).

Use this as a design tool:

- Weaker preconditions are better for clients.
- Stronger postconditions are better for clients.
- Overly strong specs can become unimplementable or brittle.
- Some specs are incomparable (neither stronger nor weaker); treat migration between them as a behavior change.

Authoring default for this skill:

- Prefer stronger input constraints by default (types first, then preconditions).
- Prefer Branded/Opaque domain types over raw primitives whenever possible.
- Prefer type-level constraints over exception-based validation whenever the language can express the invariant.
- Treat weaker preconditions or intentionally underdetermined behavior as flexibility choices that require explicit human confirmation.

## Rules

### What a specification MUST do

- Describe the contract between caller and implementer
- Talk only about parameters, return values, and observable effects
- Be precise enough that someone could write the implementation OR write tests from the spec alone
- Use the language of the domain, not the language of the implementation
- State behavior for all representable inputs (success, failure, and exceptional cases)
- Be explicit about whether the spec is deterministic or intentionally underdetermined
- Return informative results that disambiguate outcomes (e.g., avoid ambiguous sentinels)
- Be coherent: one logical responsibility per function contract

### What a specification MUST NOT do

- Reference local variables, private fields, or internal state
- Describe the algorithm or implementation strategy (operational wording)
- Mention performance characteristics (unless they are part of the contract)
- Use vague language ("handles errors appropriately", "processes the data")
- Promise impossible guarantees (e.g., guaranteed external I/O success with no failure mode)

The implementation is **invisible** to the spec reader. It is behind a firewall.

## Designing Good Specs

### Coherent

The spec should describe one logical unit of work. If the behavior combines unrelated responsibilities, split the API.

### Informative results

Return values should be unambiguous. Do not use one sentinel to represent multiple meanings (e.g., `null` meaning both "missing" and "mapped to null"). Use richer result types or distinct error outcomes.

### Strong enough

Special cases must still leave clients in a well-defined state. If an exception is possible during mutation, specify the resulting observable state precisely.

### Weak enough

Do not over-promise beyond the system's control. For external resources, specify attempts and explicit failure outcomes instead of guaranteed success.

## Constraining Inputs

Before widening accepted inputs, first ask whether the domain invariant should be encoded as a type or precondition. The default is to keep invalid states out of the contract, with type-level encoding preferred over exception-based validation when possible.

| Constraint you want to express | How to encode it safely |
|-------------------------------|-------------------------|
| `requires arr is non-empty` | Use a `NonEmptyArray<T>` type, or keep the precondition and throw `EmptyArrayError` on violation |
| `requires low <= high` | Use a `Range(low, high)` type that enforces `low <= high` at construction |
| `requires val occurs exactly once in arr` | Use a validated wrapper type for this invariant, or keep the precondition and throw a documented error if missing/duplicated |
| `requires key is not null` | Use a non-nullable type (TypeScript strict mode, Rust's default) |
| `requires 0 <= index < arr.length` | Use a bounded index type, or throw `IndexOutOfBoundsError` |
| `requires a !== b` (no aliasing) | Keep the precondition explicit, or throw an `AliasingError` if `a === b` |

If you truly cannot encode the invariant in the type system (e.g., a mathematical property that needs dynamic knowledge), document a precondition explicitly and keep it strong enough to protect correctness.

Use fail-fast checks and documented exceptions for precondition violations when feasible. If runtime checks are prohibitively expensive (e.g., verifying sortedness before binary search), the precondition may remain unchecked but must still be explicit.

## Effects Clause Patterns

The effects clause describes what the function guarantees. Common patterns:

| Pattern | Example |
|---------|---------|
| **Return value relates to inputs** | `returns index i such that arr[i] = val` |
| **Deterministic guarantee** | `returns the smallest index i such that arr[i] = val` |
| **Intentional underdetermination** | `returns some index i such that arr[i] = val` |
| **Exceptions and when** | `throws NotFoundException if key is not in map` |
| **Mutation** | `mutates arr by sorting it in ascending order` |
| **No mutation** | `does not modify arr` |
| **Side effects** | `writes the record to the database` |
| **Postcondition on state** | `after return, the connection is closed` |

## Specifying Mutation

Unless a postcondition explicitly describes mutation, **assume the function does not modify its inputs**. This is the default convention — just as `null` is implicitly disallowed unless stated otherwise.

When a function mutates an object, the effects clause must describe:
1. **Which** parameter is modified
2. **How** it is modified
3. Any return value (separately from the mutation)

### Examples

**Mutating function (all cases defined — no undefined behavior):**

```ts
/**
 * Adds the elements of array2 to the end of array1.
 * @returns true if array1 changed as a result
 * @throws AliasingError if array1 === array2
 */
function addAll(array1: Array<string>, array2: Array<string>): boolean
```

The aliasing case is not left undefined — it throws a documented exception. The spec defines behavior for every possible input.

**Mutating function with no return value:**

```
sort(array: Array<string>): void
requires: nothing
effects:  puts array in sorted order, i.e. array[i] ≤ array[j]
          for all 0 ≤ i < j < array.length
```

**Non-mutating function (mutation is implicitly absent):**

```
toLowerCase(array: Array<string>): Array<string>
requires: nothing
effects:  returns a new array t, same length as array,
          where t[i] = array[i].toLowerCase()
```

The spec of `toLowerCase` does not need to say "array is not modified" — the absence of any mutation postcondition already communicates that.

## Specifying Exceptions

Exceptions define behavior for inputs that cannot be made unrepresentable by the type system. **Every exception a function can throw must be documented** — this is how we achieve total specifications with no undefined behavior.

When exceptions occur during mutation, specify the post-exception observable state. Avoid specs that permit partially mutated, undefined intermediate states unless that behavior is itself explicitly specified.

### Use strongest types first, exceptions second

The hierarchy of preference:

1. **Make it unrepresentable** — use the type system so the invalid input cannot be constructed at all
2. **Use documented exceptions** — if the type system cannot prevent it, define an explicit error outcome
3. **Never leave behavior undefined** — a `requires` clause with no corresponding error case is a spec gap

If the target language has expressive type features (e.g., union/discriminated types, newtypes/branded types, smart constructors, value classes), prefer those over widening types and compensating with exceptions.

### Document all exceptions with `@throws`

```ts
/**
 * Compute the integer square root.
 * @param x - integer value to take square root of
 * @returns square root of x
 * @throws NotPerfectSquareError if x is not a perfect square
 */
function integerSquareRoot(x: number): number
```

The spec defines behavior for both perfect and non-perfect squares. No input leads to undefined behavior.

### Type-enforced constraints need no `@throws`

When the type system already prevents an invalid input, no exception or precondition is needed:

```ts
/**
 * @param array - array of strings to convert to lower case
 * @returns new array t, same length as array,
 *          where t[i] is array[i] converted to lowercase for all valid indices i
 */
function toLowerCase(array: Array<string>): Array<string>
```

No `@throws TypeError` — the type system already prevents non-string-array inputs. This is not undefined behavior; the invalid state is simply unrepresentable.

## Making Illegal States Unrepresentable

The most powerful way to eliminate preconditions is to design types so that invalid states **cannot exist**. When the type system enforces a business rule, the spec doesn't need to mention it — the constraint is baked into the signature.

### Example: "A contact must have an email or a postal address"

❌ **Two optional fields — allows the illegal "neither" state:**

```ts
type Contact = {
  name: Name;
  email?: EmailContactInfo;    // both could be undefined!
  postal?: PostalContactInfo;
}
```

This type allows four states, but the business rule only permits three.

✅ **Discriminated union — only legal states exist:**

```ts
type ContactInfo =
  | { kind: "emailOnly";    email: EmailContactInfo }
  | { kind: "postalOnly";   postal: PostalContactInfo }
  | { kind: "emailAndPost"; email: EmailContactInfo; postal: PostalContactInfo };

type Contact = {
  name: Name;
  contactInfo: ContactInfo;
}
```

The fourth case (no contact info at all) is unrepresentable. Any function that accepts a `Contact` gets the business rule for free — no precondition, no runtime check, no undefined behavior.

### Why bother?

- **Self-documenting** — the union cases _are_ the business rule
- **Breaking changes surface at compile time** — if the rule changes, the type changes, and all callers must be updated
- **No runtime gaps** — you cannot forget to handle a case; the compiler forces exhaustive matching

### When to apply this

Before writing a spec, ask: _"Can I reshape the types so this precondition disappears?"_

| Instead of this precondition | Reshape the type |
|------------------------------|-----------------|
| "requires at least one of email or postal" | Use a union: `EmailOnly \| PostalOnly \| Both` |
| "requires non-empty array" | Use `NonEmptyArray<T>` |
| "requires valid email string" | Use a branded `EmailAddress` type with a smart constructor |
| "requires status is 'active' or 'pending'" | Use a union: `Active \| Pending` instead of a raw string |

## Format

Use the documentation comment style of the target language (JSDoc, Javadoc, Python docstring, Rust doc comments, etc.).

### TypeScript/JavaScript (JSDoc)

```ts
/**
 * Find a value in an array.
 * @param arr - array to search
 * @param val - value to search for
 * @returns smallest index i such that arr[i] = val, or -1 if no such index exists
 */
```

### Python (docstring)

```python
def find(arr: list[int], val: int) -> int:
    """Find a value in an array.

    Args:
        arr: array to search
        val: value to search for

    Returns:
        smallest index i such that arr[i] == val, or -1 if no such index exists
    """
```

### Rust (doc comments)

```rust
/// Find a value in a slice.
///
/// # Arguments
/// * `arr` - slice to search
/// * `val` - value to search for
///
/// # Returns
/// smallest index `i` such that `arr[i] == val`, or `-1` if no such index exists
```

### Java (Javadoc)

```java
/**
 * Find a value in an array.
 * @param arr array to search
 * @param val value to search for
 * @return smallest index i such that arr[i] = val, or -1 if no such index exists
 */
```

## Workflow

When asked to write a specification:

1. **Read the function** — understand its signature and behavior
2. **Examine the types** — can any precondition be eliminated by reshaping types to make illegal states unrepresentable?
3. **Choose determinism level** — default to deterministic unless underdetermination is explicitly desired and confirmed by the human.
4. **Write declarative effects** — state what must hold, not how to compute it
5. **Define behavior for all inputs** — for every input the type system allows, define return/mutation/exception outcomes
6. **Set input constraints** — encode invariants in types first; if not possible, keep explicit preconditions strong and define violation behavior
7. **Tune spec strength** — keep constraints strong-by-default for safety; only weaken preconditions for flexibility after explicit human confirmation
8. **Check coherence and informative results** — single responsibility, unambiguous outputs
9. **Check the firewall** — remove implementation details and operational phrasing
10. **Write in target doc format** — JSDoc/Javadoc/docstring/doc comments
11. **Verify totality and change-readiness** — no undefined behavior and enough implementation freedom

## Quality Checklist

Before finalizing a specification, verify:

- [ ] **No undefined behavior** — every representable input has a defined outcome
- [ ] **Illegal states are unrepresentable** — types encode business rules wherever possible
- [ ] **Determinism choice is explicit** — deterministic by default; underdetermined only with explicit human confirmation
- [ ] **Spec is declarative** — describes outcomes, not algorithm steps
- [ ] Every parameter is documented
- [ ] Return value is described in terms of inputs
- [ ] Results are informative and unambiguous (no overloaded sentinel meanings)
- [ ] All thrown exceptions are listed with their conditions
- [ ] All mutations are explicitly stated (or "does not modify" is stated)
- [ ] Exceptional mutation cases leave a defined observable state
- [ ] Spec is coherent (one logical unit of work)
- [ ] Input constraints are strong enough to encode domain invariants (types first, then preconditions)
- [ ] Branded/Opaque domain types are preferred over raw primitives when language features allow it
- [ ] Type-level invariants are used instead of exception-based validation when the language supports them
- [ ] Spec strength is appropriate for intent (safety-first by default; flexibility only when explicitly requested)
- [ ] No implementation details leak through the spec
- [ ] A reader could write the function OR its tests from the spec alone
- [ ] Any precondition not encoded in types is explicit, justified, and has defined violation behavior when feasible

## Anti-Patterns

| ❌ Bad | ✅ Good | Why |
|--------|---------|-----|
| `requires arr is non-empty` with unspecified behavior on violation | `arr: NonEmptyArray<T>` or `@throws EmptyArrayError if arr is empty` | Strong constraint is good; undefined violation behavior is not |
| `email?: string; postal?: string` (both optional) | `ContactInfo = EmailOnly \| PostalOnly \| Both` | Allows illegal "neither" state |
| "Loops through the array to find val" | "Returns index i such that arr[i] = val" | Describes algorithm, not contract |
| "Searches left-to-right and returns first match" (when clients do not need first) | "Returns some index i such that arr[i] = val" | Operational overconstraint reduces implementation freedom |
| "Uses a hash map internally" | (omit entirely) | Implementation detail |
| "Handles edge cases" | "Throws EmptyArrayError if arr is empty" | Vague vs. precise |
| "Returns the result" | "Returns the sum of all elements in arr" | Meaningless vs. specific |
| "Sets the internal counter to 0" | "After return, size() returns 0" | Private field vs. observable behavior |
| `returns null when key missing` while null values are allowed | `returns Option<V>` / `Result` distinguishing missing from mapped-null | Ambiguous, non-informative result |
| `email: string`, `userId: string`, `amount: number` for domain-bearing inputs | `email: EmailAddress`, `userId: UserId`, `amount: Money` (Branded/Opaque/newtype wrappers) | Domain constraints become explicit and statically checkable |
| Accepts broad primitive inputs then throws for common invalid states in a language with rich types | Use refined/branded/union/newtype parameters so invalid states are unrepresentable | Prefer compile-time guarantees over runtime rejection |
| `effects: opens file filename` | `attempts to open file filename for read; throws PermissionError/FileNotFoundError on failure` | Overly strong and underspecified failure behavior |
| One function spec describing unrelated tasks | Split into separate function specs | Incoherent contract is harder to understand and evolve |
