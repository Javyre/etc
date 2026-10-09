# Naming work

For a rename, a naming review, or naming a new design. Code Work's Names
section holds the philosophy and the pressures; this holds how to work names
through with the user, the forms that show relationships, and the defaults.

## Method

1. Map the names as one system. Write the flow they live in as a pseudo
   stacktrace of the real code, with each name at its stage.
2. Name each stage for its defining property, then read the whole set: each
   word should be confirmed by its neighbors, and none should claim a
   neighbor's job. Expect one change to move several names; settle them
   together.
3. Show the user where each name lives before asking about it: its
   definition, its call sites, and the flow around them. The user may not
   know this code.
4. Propose names as before/after call sites, read at the call site farthest
   from the definition.
5. When a candidate comes from a precedent, say why the precedent chose it,
   so the user can judge whether that reason holds here.
6. Once the user decides, use the word everywhere the concept appears: code,
   docs, comments, commands, and chat.

Done when the set reads as a whole at its call sites and each decided word is
applied everywhere.

## Showing relationships

- A policy for a thing: `Cache` -> `Caching`.
- An act and its result: `Find` -> `Found`.
- A concept that matters only inside its owner: nest it (`Parser.Error`), so
  readers see its scope and whether they need it. Flat is the default;
  nesting often wins.
- A chain: the same verb at its entry and its links (`handler.call(...)`,
  `next.call(...)`).
- Kinds of one shape: share the word and qualify each kind (`http.Request`,
  `rpc.Request`). The shared word claims a shared shape, not one lifetime or
  implementation.
- An analogy: a shared word commits to an analogy and invites extending it.
  Use one when the analogy holds and will keep holding as the design grows.

## Defaults

- Fields: name the contents (`open_files`); reach for the role or the product
  when the contents say less.
- Callbacks: `on_<event>` (`on_focus`); the bare event name when the owner
  already reads as a set of hooks. A slot that wraps names the relation
  (`around`) and calls its continuation `next`.
- Predicates: ask the question (`is_empty()`) rather than leave a comparison
  to decode (`head != null`).
- Call direction: the call reads in its natural direction: `style.patch(p)`,
  not `p.over(style)`.
- User-facing names: a command shares its API's vocabulary, so learning one
  teaches the other. A concept users never see stays out of command names.
- Design direction: when the design is settled on where it is going, lean
  names toward it.
- Claims: a name or comment claims what its owner covers and decides; a
  narrower owner takes a narrower word. `place` for one placement strategy,
  or "will retry" where another component decides retries, claims too much.
  This is a leaning: take the wider word when the narrow one turns awkward.
- Terms: a defined term means only what its definition covers.
- Files: files people browse get short, memorable names; files on an agent's
  discovery path get names that say what they are for.

## Open

- Sharing one word across unrelated modules versus other pressures has no
  settled tiebreaker. Candidate: share when the concepts are related; split
  when a reader who meets both would be misled.
- Fields: contents, product, or role.
