#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM68
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Rotina chamada pelo ponto de entrada MT100CLA
=====================================================================================
*/
User Function MGFCOM68()

If l103Class
	If SF1->F1_ZBLQVAL == "S" .and. SF1->F1_STATUS == "B"	
		APMsgAlert("Documento esta bloqueado por divergencia de valores totais. Sera necessario liberar o documento pela rotina de Liberacao de Documentos.")
	Endif
Endif

Return()		