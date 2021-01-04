#include "protheus.ch"

/*
=====================================================================================
Programa............: M460Mark
Autor...............: Barbieri
Data................: 13/06/2017
Descricao / Objetivo: Ponto de Entrada M460Mark
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza o bloqueio de faturamento de pedido bloqueado
=====================================================================================
*/
     
User Function M460Mark()

	Local _lRet := .T.

	// chama rotina para validar se foram os pedidos bloqueados pelo FAT14 nao serao faturados
	If findfunction("u_xBlqMkRga") .AND. _lRet
		_lRet := u_xBlqMkRga()
	Endif
	/// Verifica se as notas possuem valor de frete informado.
	If findfunction("u_xBlqFrete") .AND. _lRet
		_lRet := u_xBlqFrete()
	Endif
		

Return(_lRet)