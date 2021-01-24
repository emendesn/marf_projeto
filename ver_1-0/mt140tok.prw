#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

user function MT140TOK()
	local lRet := .T.

	// valida inclusao de documento de transporte por modulo diferente do GFE
	If lRet
		If FindFunction("U_MGFEST35")
			lRet := U_MGFEST35()    
		Endif	
	Endif	

    /*--------------------------------------------+
    | Funcao que bloqueia duplicidades de NFE     |
    | johnny.osugi@totvspartners.com.br           |
    +--------------------------------------------*/
    If lRet .and. INCLUI // a variavel logica lRet quando verdadeiro e' porque passou na funcao U_MGFEST35().
       If FindFunction( "U_VLSERIE" )
          If .not. u_VlSerie()
             lRet := .F.
          EndIf
       EndIf
    EndIf
    	
Return( lRet )