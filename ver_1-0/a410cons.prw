#include "protheus.ch"

/*
=====================================================================================
Programa............: A410CONS
Autor...............: Roberto Sidney
Data................: 14/09/2016
Descricao / Objetivo: Botao no pedido de venda para exibir endereco de entrega por completo
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function A410CONS()

Local aBotao := {}

If Findfunction("U_VISUSZ9")
Aadd(aBotao, {'ENDERECO',{||U_VISUSZ9(2)},"Endereco de Entrega"})
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
Descricao / Objetivo: Visualiza endereco de entrega
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function VISUSZ9(nPar)
// Salva areas
_cAreSC5 := SC5->(GetArea())
_cAreaSZ9 := SZ9->(GetArea())

_cChaveSZ9 := iif(nPar = 1,SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_ZIDEND,M->C5_CLIENTE+M->C5_LOJACLI+M->C5_ZIDEND)
DbSelectArea("SZ9")
IF SZ9->(DbSeek(xFilial("SZ9")+_cChaveSZ9))
	AxVisual("SZ9")
Else
	ShowHelpDlg("IDEND", {"Endereco de entrega nao informado ou nao localizado.",""},3,;
	{"Informe o codigo do endereco de entrega.",""},3)
	Return(.F.)
Endif

// Restaura areas
RestArea(_cAreaSZ9)
RestArea(_cAreSC5)

return(.T.)

