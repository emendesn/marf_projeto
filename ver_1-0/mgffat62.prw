#include 'protheus.ch'
#include 'totvs.ch'

/*
	Verifica se pode alterar os campos para Pedidos de DEVOLUCAO
*/
user function MGFFAT62()
	local lRet := .T.

	lRet := ( !isInCallStack('A410DEVOL') .AND. !( ALTERA .AND. SC5->C5_ZTIPPED == "DV" ) )

return lRet