#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} MA410DEL
//TODO Ponto de entrada ao final da exclusão de pedido de venda
@author leonardo.kume
@since 26/01/2018
@version 6
@return boolean, retorna se pode ou não excluir

@type function
/*/
User Function MA410DEL()

local lRet := .T.

if FindFunction("U_MGFEEC43")
	lRet := U_MGFEEC43()
endif

Return lRet