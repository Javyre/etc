# Views

A view shows a shape faster than prose can: structure, flow, ownership, code,
or a change to any of them. Put each view beside the sentence it supports and
keep only what the reader's question needs.

Pick the view by what the reader must judge:

| To judge | Show |
|---|---|
| logic the code would bury, or code not yet written | pseudocode |
| runtime flow or causality | call tree or pseudo stack trace |
| ownership and state | tree with owners and boundaries |
| where things live | shallow file tree, one role per entry |
| how the code reads and is called | the real code: signatures and call sites |
| alternatives or cases | aligned table |
| a change | a diff of whichever view carries it |

Diff the structure view for a structural change and the code for a change in
expression. Show the whole target block when most of it is new, or when a
diff would hide order or ownership.

Order views by dependency: contracts and data before the logic that uses them,
and logic before layout.

Draw figures as text in fenced code blocks. Use one notation per document,
with the same glyphs, indentation, and arrows throughout, and label parts on
the figure. Keep each view small enough to take in at a glance; split a large
one by question. Skip Mermaid and UML unless the diagram is itself the
artifact or no text figure carries the point.
