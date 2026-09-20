# The playable build

`index.html` is the game as it stands. One file, 56KB, no dependencies, no build
step, no server.

## Showing it to someone

**Option 1, the Claude link.** Open the artifact on claude.ai and use its
**Share** menu to give the other person access. They get a link that opens in
any browser.

**Option 2, the file itself.** Download `index.html` from GitHub (open it, then
the **Raw** button, then save the page) and double-click it. It opens in the
browser and runs. Nothing is installed and no account is needed.

That works because everything is inline: no image files, no module imports, no
network calls. The only outside reference is Google Fonts, and without a
connection it simply falls back to the system fonts and still plays.

So it can be emailed, dropped in Drive, or put on a memory stick, and it will
run on any machine with a browser, including a phone.

## Keeping it that way

Single-file, no-build, no-server is worth protecting. It is why Claude can hand
over a playable build in one message, and why anyone can try it without being
walked through a setup. If something ever seems to need a bundler or a package,
it is worth a conversation first.

`docs/PRODUCTION.md` section 7a has the related rules that keep a Steam wrap
cheap later.
