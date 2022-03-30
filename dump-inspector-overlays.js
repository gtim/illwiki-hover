const fs = require('fs')
const Browser = require('zombie');


// Function to render HTML overlays and download as a JSON blob

function overlaysToBlob( rowsArray ) {
    // replace generated CSS classes
    var rowsArray = rowsArray.map( str => str.replace( /\s*c\d{5}\d+/g, '' ) );
    // JSON
    var rowsJSON = JSON.stringify( rowsArray, null, 2)
    return rowsJSON;
}


// Run inspector and fetch item overlays

const browser = new Browser();
// For some reason, localhost:8000 causes DNS errors, so we supply server public IP
browser.visit('http://66.175.216.48:8000/', () => {
	browser.evaluate( 'var itemOverlays = DMI.modctx.itemdata.map( item => DMI.MItem.renderOverlay(item)); ');
	console.log('itemOverlays');
	var item_overlays = browser.evaluate( 'itemOverlays' );
	var item_overlays_json = overlaysToJSON( x );
	fs.writeFileSync('build/inspector-html/items.json', item_overlays_json );
});
