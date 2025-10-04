# API Design

## Basic rule

- For naming rule, prefer Processing function names and calling convention (this would match V and gg.)
- For implementation, prioritize openFramworks compatibility, especially when Processing has different theory (for example `fill` / `no_fill`.)
- If function overload or global variables becomes problem, check how Ebitengine or gg is doing, and choose natural one.

## This framework is/does:

- Eliminate hard part for artists. Provide easy way to do something.

## This framework is not / does not:

- Not provide everything. If there are other libraries already doing something well, we should directly use them. For example, networking (OSC or DMX.)
- Not game engine. Especially, we don't want to limit expression. So we don't provide for example ECS. Users should choose favorite library upon (in addition to) this framework. 
