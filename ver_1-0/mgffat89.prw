#include "protheus.ch"
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFAT89
Autor...............: Natanael Filho
Data................: 31/JULHO/2018 
Descricao / Objetivo: Fiscal
Doc. Origem.........: Marfrig
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Restrição de cópia de pedidos anteriores à data de atualização da NF-e 4.0.
=====================================================================================
*/
User Function MGFFAT89()

Local lRet := .T.
Local aArea := Getarea()
Local dDtFim := SuperGetMV('MGF_FAT89D',.T.,StoD('20170101'))

If SC5->C5_EMISSAO < dDtFim
	lRet := .F.
	MSGAlert("Não é permitido copiar Pedidos de Venda anteriores à data " + DtoC(dDtFim) + ", conforme parâmetro MGF_FAT89D.","RESTRIÇÃO DE CÓPIA!")
EndIf

Return lRet