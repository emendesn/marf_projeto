#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFCOM57
Autor....:              Gresele
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MTA094RO
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFCOM57(aButtons)

If IsInCallStack("MATA094")
	aAdd(aButtons,{OemToAnsi("Histórico Contratos Parceria"),"U_COM57Proc",0,4,0,Nil})
Endif	
	
Return(aButtons)


User Function COM57Proc()

Local oListBox
Local cListBox
Local aSC3 := {"Contrato","Item","Produto","Valor Unitário","Quantidade","Condição Pagamento","Emissão","Fornecedor"}
Local cTitulo := "Histórico Contratos Parceria"
Local aList := {}
Local oDlg
//Local nVal := 0
Local oVar

If SCR->CR_TIPO != "CP"
	ApMsgAlert("Esta consulta somente é disponível para documentos provenientes de 'Contrato de Parceria'.")
	Return()
Endif	

ProcCons(@aList)

//nVal := GetAdvFVal("SC3","C3_PRECO",xFilial("SC3")+Alltrim(SCR->CR_NUM),1,0)

DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 310,650 OF oMainWnd PIXEL
//@ 003,005 SAY "Valor Unitário Item/Contrato:" SIZE 080,08 OF oDlg PIXEL
//@ 003,080 SAY oVal VAR nVal Picture("999,999,999.99") SIZE 050,08 OF oDlg PIXEL 

@ 015,005 LISTBOX oListBox VAR cListBox Fields HEADER aSC3[1],aSC3[2],aSC3[3],aSC3[4],aSC3[5],aSC3[6],aSC3[7],aSC3[8] SIZE 315,120  PIXEL
oListBox:SetArray(aList)
oListBox:bLine := {|| {aList[oListBox:nAt,1],aList[oListBox:nAt,2],aList[oListBox:nAt,3],aList[oListBox:nAt,4],aList[oListBox:nAt,5],aList[oListBox:nAt,6],aList[oListBox:nAt,7],aList[oListBox:nAt,8]}}

DEFINE SBUTTON FROM 140,280 TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
	
Return()


Static Function ProcCons(aList)

Local cAliasTrb := GetNextAlias()
Local cQ := ""

aList	:= {}

cQ := "SELECT * "
cQ += "FROM "+RetSqlName("SC3")+" SC3 "
cQ += "WHERE SC3.D_E_L_E_T_ = ' ' "
cQ += "AND C3_FILIAL = '"+xFilial("SC3")+"' " 
cQ += "AND C3_FORNECE = '"+GetAdvFVal("SC3","C3_FORNECE",xFilial("SC3")+Alltrim(SCR->CR_NUM),1,"")+"' "
cQ += "AND C3_LOJA = '"+GetAdvFVal("SC3","C3_LOJA",xFilial("SC3")+Alltrim(SCR->CR_NUM),1,"")+"' "
//cQ += "AND C3_PRODUTO = '"+SC3->C3_PRODUTO+"' "
cQ += "ORDER BY C3_FILIAL,C3_EMISSAO DESC,C3_NUM DESC,C3_PRODUTO "

dbUseArea(.T.,"TOPCONN",tcGenQry(,,ChangeQuery(cQ)),cAliasTrb,.F.,.T.)

aEval(SC3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasTrb,x[1],x[2],x[3],x[4]),Nil)})

While (cAliasTrb)->(!Eof())
	aAdd(aList,{(cAliasTrb)->C3_NUM,(cAliasTrb)->C3_ITEM,(cAliasTrb)->C3_PRODUTO,Str((cAliasTrb)->C3_PRECO,12,2),Str((cAliasTrb)->C3_QUANT,12,3),GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+(cAliasTrb)->C3_COND,1,""),dToc((cAliasTrb)->C3_EMISSAO),GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+(cAliasTrb)->C3_FORNECE+(cAliasTrb)->C3_LOJA,1,"")})
	(cAliasTrb)->(dbSkip())
EndDo

If Len(aList) == 0
	aAdd(aList,{"","","",0,0,"",dToc(""),""})
EndIf

(cAliasTrb)->(dbCloseArea())

Return()