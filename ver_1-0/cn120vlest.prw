/*
=====================================================================================
Programa.:              CN120VLEST
Autor....:              Roberto Sidney
Data.....:              26/10/2016
Descricao / Objetivo:   Critica o estorno da medição de acordo com a rotina de origem
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada através do ponto de entrada A410CONS()
=====================================================================================
*/
User Function CN120VLEST
lRet := .T.    
DbSelectArea("CND")
if ALLTRIM(CND->CND_ZROTIN) = 'MATA460' .and. Funname() <> 'MATA521'
	ShowHelpDlg("NOESTOR", {"Esta medição foi gerada a partir da N.F., o estorno só poderá ocorrer a partir da exclusão da nota.",""},3,;
	{"Efetue a exclusão da nota",""},3)
	lRet := .F.
Endif
Return(lRet)