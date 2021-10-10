jQuery( document ).ready(function() {
	jQuery( "span.illwikihover_link" ).each( function(i,e) {
		var spell_div = jQuery('<div/>', {'class':'illwikihover_popup'}).hide().appendTo( document.body);
		if ( jQuery(e).data("spellid") ) {
			spell_div.load( '/dom5/lib/plugins/illwikihover/spell/' + jQuery(e).data("spellid") + ".htm" );
		} else if ( jQuery(e).data("itemid") ) {
			spell_div.load( '/dom5/lib/plugins/illwikihover/item/' + jQuery(e).data("itemid") + ".htm" );
		} else if ( jQuery(e).data("unitid") ) {
			spell_div.load( '/dom5/lib/plugins/illwikihover/unit/' + jQuery(e).data("unitid") + ".htm" );
		}
		spell_div.css( jQuery(e).offset() );
		jQuery(e).on( 'click', function() {
			//jQuery(e).data('pinned', ! jQuery(e).data('pinned'));
			/*
			// make x unless exists
			if ( ! spell_div.find('.illwikihover_spell_popup_x').length ) { 
				spell_div.append( jQuery('<p/>', {'class':'illwikihover_spell_popup_x'}) );
			}*/
		});
		jQuery(e).hover(
			function(ev){
				jQuery(ev.target).data('pinned',false);
				spell_div.css({'top':ev.pageY+12, 'left':ev.pageX-170});
				spell_div.show();
			}, function(ev){
				if ( ! jQuery(ev.target).data('pinned') ) {
					spell_div.hide();
				}
			}
		);
	});
});
