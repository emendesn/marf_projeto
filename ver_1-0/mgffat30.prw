#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT30

Bloqueia altera��o dos campos Cliente e Condicao de Pagto no Pedido de Venda

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 20/03/2017
/*/
//-------------------------------------------------------------------
user function MGFFAT30()
	local lRet		:= .T.
	Local nPosProd	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO"		})     

	if upper(allTrim(funName())) == "MATA410"
		if len(aCols) >= 1
			if !empty(aCols[1, nPosProd])
			   //	msgAlert("N�o � permitida a altera��o do Cliente/Cond Pagto ap�s inserido contrato.")
				//lRet := .F.
			endif
		endif
	endif

return lRet
