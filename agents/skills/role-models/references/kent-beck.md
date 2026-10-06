# Kent Beck

Reach for when:
- slicing a change so a reviewer can audit each step
- separating refactors from behavior changes in a diff
- untangling a change that mixed both

Transferable patterns:
- "Never mix structural and behavioral changes in the same commit"; make
  the structural changes first, and run the tests before and after each
- "make the change easy, then make the easy change"
- a tangled diff is often cheaper to discard and redo, tidying first
- warning signs in augmented coding: loops, features nobody asked for, and
  the agent disabling or deleting tests

Watch:
- he leads with tests (TDD from a plan); on high-accountability code the
  user leads with code and treats tests as confirmation, so carry over the
  structural/behavioral split, not the test-first order

Orientation reads:
- https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes
- https://newsletter.kentbeck.com/p/getting-untangled
