# Pattern Catalog (43 Patterns)

This catalog defines the detection IDs used by `humanizing-writing`.

- Tier 1: dead giveaways (always transform)
- Tier 2: strong cumulative signals (always transform)
- Tier 3: subtle signals (transform with `--thorough`)

## Category A: vocabulary and word choice

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| A1 | Overused AI vocabulary | 1 | Red-flag words clustered in short spans (`delve`, `pivotal`, `tapestry`, `realm`) |
| A2 | Overused multi-word phrases | 1 | Stock phrases (`at its core`, `plays a pivotal role`, `it's worth noting`) |
| A3 | Excessive formal connectors | 1 | Repetitive openers (`Additionally`, `Moreover`, `Furthermore`) |
| A4 | Positive intensifiers and buzzwords | 2 | Marketing-like language (`innovative`, `transformative`, `cutting-edge`) |
| A5 | Copula avoidance | 2 | Fancy substitutes for `is`/`has` (`serves as`, `boasts`, `features`) |
| A6 | Elegant variation (synonym cycling) | 2 | Switching terms for same entity to avoid repetition |

## Category B: syntactic patterns

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| B1 | Negative parallelisms | 2 | Repeated `not just X, but Y` style constructions |
| B2 | Rule of three overuse | 2 | Forced triads in lists and clauses |
| B3 | Superficial `-ing` analyses | 1 | Empty participle tails (`highlighting`, `underscoring`, `reflecting`) |
| B4 | False ranges | 2 | Decorative `from X to Y` that are not real endpoints |
| B5 | Repetitive syntactic templates | 3 | Consecutive sentences with near-identical structure |
| B6 | Uniform sentence length | 3 | Low variation in sentence length across paragraphs |
| B7 | Excessive nominalization | 3 | Verb ideas converted into bloated noun phrases |

## Category C: content and semantic

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| C1 | Exaggerated significance | 1 | Inflated framing (`pivotal moment`, `testament to`, `turning point`) |
| C2 | Promotional or advertisement tone | 2 | Brochure voice (`vibrant`, `renowned`, `breathtaking`) |
| C3 | Vague attributions and weasel words | 2 | Unverifiable authority (`experts say`, `observers note`) |
| C4 | Overgeneralization | 2 | Sweeping claims without concrete scope or evidence |
| C5 | Superficial or generic analysis | 2 | Empty analysis wrappers without specific conclusions |
| C6 | Undue emphasis on media notability | 2 | Listing outlets as proxy for substance |
| C7 | Sentiment homogeneity | 3 | Uniformly neutral or positive affect, no nuance |

## Category D: structural

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| D1 | Formulaic conclusions | 1 | Generic closers (`In conclusion`, `future looks bright`) |
| D2 | Challenges-and-recovery formula | 1 | `Despite challenges ... continues to thrive` template |
| D3 | Inline-header vertical lists | 2 | `- **Header:** description` repeated per bullet |
| D4 | Rigid predictable organization | 3 | Overly symmetric section and paragraph architecture |
| D5 | Section summaries | 2 | Recapping the section immediately after explaining it |
| D6 | Title-as-proper-noun leads | 2 | Opening by defining the title phrase as an entity |
| D7 | Vague related-topics sections | 3 | Generic "See also" padding without specific relevance |

## Category E: formatting and style

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| E1 | Boldface overuse | 2 | Mechanical emphasis across many terms |
| E2 | Title case in headings | 2 | Defaulting to title case where sentence case is preferred |
| E3 | Em dash overuse | 2 | Dash-heavy prose where commas/periods are clearer |
| E4 | Emoji decoration | 2 | Decorative emoji bullets/headings in non-social copy |
| E5 | Inconsistent quotation mark style | 3 | Curly and straight quote mixing in one piece |
| E6 | Unnecessary tables | 3 | Tiny tables where prose is clearer |
| E7 | Non-standard heading hierarchy | 3 | Heading colon artifacts or skipped heading levels |

## Category F: behavioral and conversational

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| F1 | Collaborative chatbot artifacts | 1 | `I hope this helps`, `let me know if you'd like` |
| F2 | Knowledge-cutoff disclaimers | 1 | `As of my last update`, `based on available information` |
| F3 | Sycophantic or servile tone | 1 | Empty praise (`Great question!`, `You're absolutely right`) |
| F4 | Inappropriate direct address | 2 | Second-person coaching in non-conversational formats |
| F5 | Placeholder templates | 1 | `[Company Name]`, `[insert date]`, `PASTE_URL_HERE` |
| F6 | Didactic disclaimers and filler | 2 | `It's important to note`, `in order to`, `due to the fact that` |

## Category G: statistical and quantitative

| ID | Pattern | Tier | Quick definition |
|-|-|-|-|
| G1 | Low lexical diversity | 3 | Repetitive high-frequency vocabulary |
| G2 | Reduced sentence-length variation | 3 | Tight sentence-length clustering |
| G3 | Excessive hedging | 2 | Stacked uncertainty (`could potentially`, `might possibly`) |

## Application Rules

1. Tier 1 and Tier 2 patterns are always in scope.
2. Tier 3 patterns are in scope only with `--thorough`.
3. Do not force substitutions; prefer sentence-level rewrites.
4. Preserve facts, argument, and intended register.
