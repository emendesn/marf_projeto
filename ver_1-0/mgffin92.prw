/*
=====================================================================================
Programa............: MGFFIN92
Autor...............: Totvs
Data................: Março/2018 
Descricao / Objetivo: Rotina chamada pelo ponto de entrada F590CAN/F240CAN
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN92()

// exclui idcnab
If (IsInCallStack("FINA590") .and. ParamIxb[1] == "P")// .or. IsInCallStack("FINA240") .or. IsInCallStack("FINA241")
	If !Empty(SE2->E2_IDCNAB)
		SE2->(RecLock("SE2",.F.))
		SE2->E2_IDCNAB := ""
		SE2->(MsUnlock())
	Endif	
Endif

Return()	