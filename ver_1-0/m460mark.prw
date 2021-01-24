#include "protheus.ch"

/*
=====================================================================================
Programa............: M460Mark
Autor...............: Barbieri
Data................: 13/06/2017
Descrição / Objetivo: Ponto de Entrada M460Mark
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza o bloqueio de faturamento de pedido bloqueado
=====================================================================================
*/
     
User Function M460Mark()
	Local _lRet := .T.

	// chama rotina para validar se foram os pedidos bloqueados pelo FAT14 não serão faturados
	If findfunction("u_xBlqMkRga") .AND. _lRet
		_lRet := u_xBlqMkRga()
	Endif
	/// Verifica se as notas possuem valor de frete informado.
	If findfunction("u_xBlqFrete") .AND. _lRet
		_lRet := u_xBlqFrete()
	Endif
	//-----| Valida o campo Utiliza carga |-----\\ 
	If FindFunction("U_MGFFATC0") .AND. _lRet
		 _lRet := U_MGFFATC0()
	Endif	
Return(_lRet)