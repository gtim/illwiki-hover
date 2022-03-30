# illwiki-hover

## Build instructions

Clone repo:

    $ git clone https://github.com/gtim/illwiki-hover.git
    $ cd illwiki-hover

Run a local dom5 inspector:

    $ git submodule --init
    $ cd dom5inspector
    $ python3 -m http.server

Run the processing scripts in another terminal while the local inspector is running:
    
    $ node dump-inspector-overlays.js # edit host address if not running on illwiki server
    $ perl copy-sprites.pl
    $ perl process.pl
    $ ./deploy.sh # edit paths if not running default arch dokuwiki install
