# floooh

Reach for when:
- studying Zig/C interop boundaries
- studying build graph design under native vs web split
- studying generated binding surfaces with explicit platform policy
- studying practical low-level examples instead of framework-style architecture

Transferable patterns:
- keep platform and backend choice explicit in build surface
- make foreign-library integration feel native without lying about underlying system
- use generation where bindings need it, but keep build and runtime seams inspectable
- keep sample code close to real integration path

Watch:
- heavy C and platform glue means some good patterns are interop-specific
- generated bindings can look cleaner than hand-written design reality

Orientation reads:
- https://github.com/floooh/sokol-zig

Code reads:
- https://github.com/floooh/sokol-zig/blob/master/build.zig
- https://github.com/floooh/pacman.zig/blob/main/build.zig
