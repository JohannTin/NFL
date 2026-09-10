# NFL model dashboard

**[View the dashboard →](https://johanntin.github.io/NFL/)**

A published snapshot of the game and player-prop board: market lines by book,
the model's prices against them, the offers that clear the EV floor, and the
writeup behind each pick.

`index.html` is self-contained — styles, script and the snapshot data are
inlined at build time — so it can be served as-is. `teampng/` holds the team
marks it links to.

Built from the private model repo with `public/dashboard/dashboard.py`; this
repo holds the output only, not the models or the collection code.
