#include "protheus.ch"

/*
=====================================================================================
Programa............: A410CONS
Autor...............: Roberto Sidney
Data................: 14/09/2016
Descricao / Objetivo: Bot�o no pedido de venda para exibir endere�o de entrega por completo
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function A410CONS()

Local aBotao := {}

If Findfunction("U_VISUSZ9")
	Aadd(aBotao, {'ENDERE�O',{||U_VISUSZ9(2)},"Endere�o de Entrega"})
Endif
If Findfunction("U_MGFGCT05")
	Aadd(aBotao, {'CONTRATO',{||U_MGFGCT05()},"Seleciona Contrato"})
Endif

return (aBotao)


/*
=====================================================================================
Programa............: VISUSZ9
Autor...............: Roberto Sidney
Data................: 14/09/2016
Descricao / Objetivo: Visualiza endere�o de entrega
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function VISUSZ9(nPar)

// Salva �reas
_cAreSC5  := SC5->(GetArea())
_cAreaSZ9 := SZ9->(GetArea())

_cChaveSZ9 := If(nPar == 1,SC5->(C5_CLIENTE+C5_LOJACLI+C5_ZIDEND),M->C5_CLIENTE+M->C5_LOJACLI+M->C5_ZIDEND)

dbSelectArea("SZ9")

IF SZ9->(dbSeek(xFilial("SZ9")+_cChaveSZ9))
	AxVisual("SZ9")
Else
	ShowHelpDlg("IDEND", {"Endere�o de entrega n�o informado ou n�o localizado.",""},3,;
						 {"Informe o codigo do endere�o de entrega.",""},3)
	Return(.F.)
EndIf

// Restaura areas
RestArea(_cAreaSZ9)
RestArea(_cAreSC5)

Return(.T.)
