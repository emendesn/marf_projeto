#include "protheus.ch"
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFAT89
Autor...............: Natanael Filho
Data................: 31/JULHO/2018 
Descricao / Objetivo: Fiscal
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: Restricao de copia de pedidos anteriores � data de atualizacao da NF-e 4.0.
=====================================================================================
*/
User Function MGFFAT89()

Local lRet := .T.
Local aArea := Getarea()
Local dDtFim := SuperGetMV('MGF_FAT89D',.T.,StoD('20170101'))

If SC5->C5_EMISSAO < dDtFim
	lRet := .F.
	MSGAlert("Nao � permitido copiar Pedidos de Venda anteriores � data " + DtoC(dDtFim) + ", conforme parametro MGF_FAT89D.","RESTRI��O DE C�PIA!")
EndIf

Return lRet