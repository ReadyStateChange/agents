---
name: writing-specifications
description: "Writes formal function/method specifications with preconditions and postconditions. Use when writing specs, documenting function contracts, adding JSDoc/docstrings, or asked to specify behavior."
---

# Writing Specifications

Write precise, implementation-independent function specifications using the **signature + requires + effects** pattern.

## Specification Structure

Every specification has exactly three parts:

1. **Signature** — function name, parameter types, return type
2. **Requires clause** (precondition) — constraints on inputs that must hold when the function is called
3. **Effects clause** (postcondition) — what the function guarantees when the precondition is met

## Rules

### What a specification MUST do

- Describe the contract between caller and implementer
- Talk only about parameters, return values, and observable effects
- Be precise enough that someone could write the implementation OR write tests from the spec alone
- Use the language of the domain, not the language of the implementation

### What a specification MUST NOT do

- Reference local variables, private fields, or internal state
- Describe the algorithm or implementation strategy
- Mention performance characteristics (unless they are part of the contract)
- Use vague language ("handles errors appropriately", "processes the data")

The implementation is **invisible** to the spec reader. It is behind a firewall.

## Requires Clause Patterns

The requires clause narrows what the caller may pass. Common patterns:

| Pattern | Example |
|---------|---------|
| **Narrowing a type** | `requires arr is non-empty` |
| **Parameter interactions** | `requires low <= high` |
| **Domain constraints** | `requires val occurs exactly once in arr` |
| **Nullability** | `requires key is not null` |
| **Range bounds** | `requires 0 <= index < arr.length` |

If there are no preconditions beyond what the type system enforces, omit the requires clause.

## Effects Clause Patterns

The effects clause describes what the function guarantees. Common patterns:

| Pattern | Example |
|---------|---------|
| **Return value relates to inputs** | `returns index i such that arr[i] = val` |
| **Exceptions and when** | `throws NotFoundException if key is not in map` |
| **Mutation** | `mutates arr by sorting it in ascending order` |
| **No mutation** | `does not modify arr` |
| **Side effects** | `writes the record to the database` |
| **Postcondition on state** | `after return, the connection is closed` |

## Format

Use the documentation comment style of the target language (JSDoc, Javadoc, Python docstring, Rust doc comments, etc.).

### TypeScript/JavaScript (JSDoc)

```ts
/**
 * Find a value in an array.
 * @param arr - array to search; requires val occurs exactly once in arr
 * @param val - value to search for
 * @returns index i such that arr[i] = val
 */
```

### Python (docstring)

```python
def find(arr: list[int], val: int) -> int:
    """Find a value in an array.

    Args:
        arr: array to search; requires val occurs exactly once in arr
        val: value to search for

    Returns:
        index i such that arr[i] = val
    """
```

### Rust (doc comments)

```rust
/// Find a value in a slice.
///
/// # Arguments
/// * `arr` - slice to search; requires `val` occurs exactly once in `arr`
/// * `val` - value to search for
///
/// # Returns
/// index `i` such that `arr[i] == val`
```

### Java (Javadoc)

```java
/**
 * Find a value in an array.
 * @param arr array to search, requires that val occurs exactly once in arr
 * @param val value to search for
 * @return index i such that arr[i] = val
 */
```

## Workflow

When asked to write a specification:

1. **Read the function** — understand its signature and behavior
2. **Identify the precondition** — what must the caller guarantee?
3. **Identify the postcondition** — what does the function guarantee in return?
4. **Check the firewall** — does the spec mention anything internal? If so, remove it
5. **Write the spec** — using the target language's doc comment format
6. **Verify completeness** — could someone write correct tests from this spec alone?

## Quality Checklist

Before finalizing a specification, verify:

- [ ] Every parameter is documented
- [ ] Return value is described in terms of inputs
- [ ] All thrown exceptions are listed with their conditions
- [ ] All mutations are explicitly stated (or "does not modify" is stated)
- [ ] No implementation details leak through the spec
- [ ] A reader could write the function OR its tests from the spec alone
- [ ] Requires clause only constrains things the type system cannot express

## Anti-Patterns

| ❌ Bad | ✅ Good | Why |
|--------|---------|-----|
| "Loops through the array to find val" | "Returns index i such that arr[i] = val" | Describes algorithm, not contract |
| "Uses a hash map internally" | (omit entirely) | Implementation detail |
| "Handles edge cases" | "Throws EmptyArrayError if arr is empty" | Vague vs. precise |
| "Returns the result" | "Returns the sum of all elements in arr" | Meaningless vs. specific |
| "Sets the internal counter to 0" | "After return, size() returns 0" | Private field vs. observable behavior |
