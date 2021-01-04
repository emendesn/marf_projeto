#INCLUDE "rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FILEIO.CH"

/*/{Protheus.doc} MGFSTACK
//TODO Utilizar IsInCallStack no Protheus
@author Barbieri
@since 23/04/2018
@version undefined
@type function
/*/
User Function MGFSTACK(cFun)  

Return(IsInCallStack(cFun))
