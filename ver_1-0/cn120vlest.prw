/*
=====================================================================================
Programa.:              CN120VLEST
Autor....:              Roberto Sidney
Data.....:              26/10/2016
Descricao / Objetivo:   Critica o estorno da medicao de acordo com a rotina de origem
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              
Obs......:              Chamada efetuada atraves do ponto de entrada A410CONS()
=====================================================================================
*/
User Function CN120VLEST
lRet := .T.    
DbSelectArea("CND")
if ALLTRIM(CND->CND_ZROTIN) = 'MATA460' .and. Funname() <> 'MATA521'
	ShowHelpDlg("NOESTOR", {"Esta medicao foi gerada a partir da N.F., o estorno s� podera ocorrer a partir da exclusao da nota.",""},3,;
	{"Efetue a exclusao da nota",""},3)
	lRet := .F.
Endif
Return(lRet)