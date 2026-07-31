# Andrew Kelley

## Core Model

```text
system legibility
  → complete model
  → precise intent
  → direct use of the substrate
  → robust, optimal, reusable software
```

Andrew treats systems programming as a way of modeling any software system.
Identify the lowest relevant API, understand its real resource and failure
contracts, then express the program as precise transformations over that
substrate. Abstractions remain useful while their system effects stay knowable.

Core values:
- together we serve the users
- help people reach a more complete understanding of the system
- communicate intent precisely
- edge cases and resource failure are part of the contract
- favor reading and reduce what the programmer must remember
- reject local maxima and inherited premises

Reach for when:
- the design hides the lowest relevant API or resource contract
- abstraction makes control, cost, failure, or state hard to explain
- a system could express intent more directly to its substrate
- studying data-oriented design from actual access patterns
- challenging an inherited premise that constrains the design space

## Best Transmitter

- [Making Systems Programming Accessible](https://www.youtube.com/watch?v=Qncdi-Fg0-I)
  ([transcript](https://www.josherich.me/podcast/making-systems-programming-accessible-by-andrew-kelley))
  - direct statement and clarification of the system model
  - defines accessibility as progress toward complete system understanding
  - derives precise intent and lowest-API reasoning without depending on Zig

## Teaching Sequence

- [Software Should Be Perfect](https://www.youtube.com/watch?v=Z4oYSByyRak)
  - normative quality bar; valid inputs include resource exhaustion and edge cases
- [A Practical Guide to Applying Data-Oriented Design](https://vimeo.com/649009599)
  - mechanical consequence: representation follows access and machine behavior
- [A Systems-Minded Approach to Creating a Music Player Application](https://www.youtube.com/watch?v=SCLrNqc9jdE)
  - applies the system model to an ordinary product

Transferable lessons:
- expose enough of the substrate to explain correctness, cost, and failure
- make precise intent the shortest path through the system
- keep resource ownership and failure explicit
- design for the reader and maintainer
- search beyond the best version of a weak inherited premise

Watch:
- “lowest relevant API” is scope-relative; literal hardware may add no value
- complete understanding is a direction and design test, not a claim that every
  operator must know every implementation detail
- distinguish Andrew's teachings from Zig's current constraints and rough edges

## Reference Material

Use Zig as sustained evidence and a source of concrete mechanics:
- https://github.com/ziglang/zig
- https://github.com/ziglang/zig/blob/master/lib/std/Build.zig
- https://ziglang.org/learn/overview/
- https://ziglang.org/learn/why_zig_rust_d_cpp/
- https://ziglang.org/devlog/2025/
