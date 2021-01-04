/*
=====================================================================================
Programa............: MS520VLD
Autor...............: Mauricio Gresele
Data................: Set/2017
Descricao / Objetivo: Ponto de entrada para validar se nota de saida pode ser excluida
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MS520VLD()

Local lRet := .T.

If FindFunction("U_MGFFAT48") .AND. lRet
	lRet := U_MGFFAT48()
Endif


//Valida exclusão do documento de saida (triangulação faturamento)
If lRet .and. FindFunction("u_MGFFAT75")
	lRet := u_MGFFAT75()
Endif

//validacao cancelamento Multiembarcador
If FindFunction("U_MGFGFE43 ") .AND. lRet
	lRet := U_MGFGFE43('1')
Endif

//Validacao da exclusao do titulo de ICMS Proprio
If FindFunction("U_MGFFATBP") .AND. lRet
	lRet := U_MGFFATBP()
Endif

Return (lRet)