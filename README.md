# illwiki-hover

## Build instruction

1. Open the dom 5 inspector, paste content of `scrape-inspector.js` into dev console (F12) and save the resulting three JSON files in `build/inspector-html`

2. Make sure inspector submodule in directory is up-to-date

3.  `perl copy-sprites.pl`

4. `perl process.pl`

5. This should have (re-)generated the `dist/illwikihover` folder, except for a couple static files that are already there. Copy the entire folder into the dokuwiki plugin folder.
