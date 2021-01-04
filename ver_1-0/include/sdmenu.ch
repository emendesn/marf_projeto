#xcommand SDMENU [ <aMenu> ] => [ <aMenu> := ] SDMnuBegin( [<aMenu>] )

#xcommand SDMENUITEM <cPrompt> ;
       [ ACTION <cAction> ] ;
			 [ PAISLOC <cLoc> ] ;
 			 [ <lLocked: LOCKED> ] ;
			 [ RESOURCE <cResName> ] ;
			 [ MODNAME <cModName> ] ;
			 [ ACCESS <nAccess> ] ;
			 [ ID <cID> ] ;
       => ;
          SDMnuAddItem( <cPrompt>, <cAction>, [<cLoc>], [<.lLocked.>], [<cResName>], [<cModName>], [<nAccess>], [<cID>] )

#xcommand SDSEPARATOR => SDMnuAddItem()

#xcommand SDENDMENU => SDMnuEnd()
