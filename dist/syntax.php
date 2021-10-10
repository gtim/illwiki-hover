<?php
/**
 * DokuWiki Plugin illwikihover (Syntax Component)
 *
 * @license GPL 3
 * @author  Tim <tim@gurka.se>
 */

// must be run within Dokuwiki
if (!defined('DOKU_INC')) {
    die();
}

class syntax_plugin_illwikihover extends DokuWiki_Syntax_Plugin
{
    /**
     * @return string Syntax mode type
     */
    public function getType()
    {
        return 'substition';
    }

    /**
     * @return string Paragraph type
     */
    public function getPType()
    {
        return 'normal';
    }

    /**
     * @return int Sort order - Low numbers go before high numbers
     */
    public function getSort()
    {
        return 999;
    }

    /**
     * Connect lookup pattern to lexer.
     *
     * @param string $mode Parser mode
     */
    public function connectTo($mode)
    {
        $this->Lexer->addSpecialPattern('\?\?[a-zA-Z \'-]+?(?:#\d+)?\?\?', $mode, 'plugin_illwikihover');
    }

//    public function postConnect()
//    {
//        $this->Lexer->addExitPattern('</FIXME>', 'plugin_illwikihover');
//    }

    /**
     * Handle matches of the illwikihover syntax
     *
     * @param string       $match   The match of the syntax
     * @param int          $state   The state of the handler
     * @param int          $pos     The position in the document
     * @param Doku_Handler $handler The handler
     *
     * @return array Data for the renderer
     */
    public function handle($match, $state, $pos, Doku_Handler $handler)
    {
        $data = array();

        #$this->Lexer->addSpecialPattern(, $mode, 'plugin_illwikihover');
	$match_f = substr($match, 2, -2);
	$match_a = explode( '#', $match_f );
	$name = $match_a[0];
	$supplied_id = ( isset($match_a[1]) ? $match_a[1] : 0 );
	$spell_ids = json_decode( file_get_contents( dirname(__FILE__) . '/spell_nametoid_hash.json'), true );
	$item_ids = json_decode( file_get_contents( dirname(__FILE__) . '/item_nametoid_hash.json'), true );
	$unit_ids = json_decode( file_get_contents( dirname(__FILE__) . '/unit_nametoid_hash.json'), true );
	if ( key_exists( $name, $spell_ids ) ) {
		$data[0] = sprintf( '<span class="illwikihover_link" data-spellid="%d" data-pinned="false">%s</span>', $spell_ids{$name}, $name );
	} elseif ( key_exists( $name, $item_ids ) ) {
		$data[0] = sprintf( '<span class="illwikihover_link" data-itemid="%d" data-pinned="false">%s</span>', $item_ids{$name}, $name );
	} elseif ( key_exists( $name, $unit_ids ) ) {
		if ( $supplied_id ) {
			if ( in_array( $supplied_id, $unit_ids{$name} ) ) {
				$data[0] = sprintf( '<span class="illwikihover_link" data-unitid="%d" data-pinned="false">%s</span>', $supplied_id, $name );
			} else {
				$data[0] = $name;
			}
		} else {
			$data[0] = sprintf( '<span class="illwikihover_link" data-unitid="%d" data-pinned="false">%s</span>', $unit_ids{$name}[0], $name );
		}
	} else {
		$data[0] = $name;
	}

        return $data;
    }

    /**
     * Render xhtml output or metadata
     *
     * @param string        $mode     Renderer mode (supported modes: xhtml)
     * @param Doku_Renderer $renderer The renderer
     * @param array         $data     The data from the handler() function
     *
     * @return bool If rendering was successful.
     */
    public function render($mode, Doku_Renderer $renderer, $data)
    {
        if ($mode !== 'xhtml') {
            return false;
        }
	$renderer->doc .= $data[0];
        return true;
    }
}

