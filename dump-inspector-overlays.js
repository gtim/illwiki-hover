const fs = require('fs')
const Browser = require('zombie');


// Function to render HTML overlays and download as JSON 

function overlaysToJSON( rowsArray ) {
    var rowsArray = rowsArray.map( str => str.replace( /\s*c\d{5}\d+/g, '' ) ); // replace generated CSS classes
    var rowsJSON = JSON.stringify( rowsArray, null, 2)
    return rowsJSON;
}


// Run inspector and fetch item overlays

const browser = new Browser();
browser.visit('http://66.175.216.48:8000/', () => { // localhost:8000 causes DNS errors, so we supply server public IP
	console.log('item overlays');
	browser.evaluate( 'var itemOverlays = DMI.modctx.itemdata.map( item => DMI.MItem.renderOverlay(item)); ');
	var item_overlays_json = overlaysToJSON( browser.evaluate( 'itemOverlays' ) );
	fs.writeFileSync('build/inspector-html/items.json', item_overlays_json );


	console.log('spell overlays');
	browser.evaluate(
		'var spellOverlays = DMI.modctx.spelldata.filter('+
			'function(spell){ return spell.school != -1; }'+ // behind-the-scenes spells
		').map( spell => DMI.MSpell.renderOverlay(spell) );'
	);
	var spell_overlays_json = overlaysToJSON( browser.evaluate( 'spellOverlays' ) );
	fs.writeFileSync('build/inspector-html/spells.json', spell_overlays_json );

	console.log('unit overlays');
	browser.evaluate( 'var unitOverlays = DMI.modctx.unitdata.map( unit => DMI.MUnit.renderOverlay(unit)); ');
	var unit_overlays_json = overlaysToJSON( browser.evaluate( 'unitOverlays' ) );
	fs.writeFileSync('build/inspector-html/units.json', unit_overlays_json );
});
