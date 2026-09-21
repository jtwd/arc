# Two harnesses

Nobody on this project can see the screen while the code is being written, so
these exist to catch the two classes of bug that a syntax check misses and a
player finds immediately. Both are dependency-free; run them with Node from
anywhere.

```
node test/smoke.js
node test/bounds.js
```

## `smoke.js` — does anything throw?

Stubs just enough DOM to run `index.html`'s real code, then drives it: every
creature at every elite modifier, the bear through each of its states, every
room kind, every door kind taken, the trade fire bought out and then visited
broke, and twelve complete runs from the Hearth to the Mammoth.

It cannot tell you whether the bear looks like a bear. It can tell you that
nothing in the build throws.

## `bounds.js` — does anything get clipped?

Each figure is painted into a 360 by 360 buffer with its origin at (180, 260)
so the paper reserve can be dilated from the whole silhouette. A rig that
overruns that buffer is silently clipped at the edge.

This one implements a real 2D transform stack over the stub context and
measures the bounding box of every painted point, for every rig in every state,
at the depth where the scale peaks. It prints the worst case and exits non-zero
if anything clips.

The reared Cave Bear is the tightest thing in the game at 24 pixels spare, so
run this after any change to a rig's proportions.
