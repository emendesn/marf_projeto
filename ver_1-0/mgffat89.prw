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
Obs.................: Restri��o de c�pia de pedidos anteriores � data de atualiza��o da NF-e 4.0.
=====================================================================================
*/
User Function MGFFAT89()

Local lRet := .T.
Local aArea := Getarea()
Local dDtFim := SuperGetMV('MGF_FAT89D',.T.,StoD('20170101'))

If SC5->C5_EMISSAO < dDtFim
	lRet := .F.
	MSGAlert("N�o � permitido copiar Pedidos de Venda anteriores � data " + DtoC(dDtFim) + ", conforme par�metro MGF_FAT89D.","RESTRI��O DE C�PIA!")
EndIf

Return lRet