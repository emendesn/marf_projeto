#include "protheus.ch"

/*
===========================================================================================
Programa.:              MGFCOM91
Autor....:              Totvs
Data.....:              Julho/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada A100DEL
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Monta tela com os documento de entrada relacionados ao item do pedido de compra 
===========================================================================================
*/
User Function MGFCOM91()

Local aArea := {GetArea()}
Local oListBox1
Local cListBox1
Local nOpc := 0
Local aTitulo := { "Pedido/Aut.Ent","Produto","Documento","Cod. Forn.","Loja Forn.","Nome Forn.","Data Digitação","Qtd. Documento"}
Local cTitulo := "Consulta Especifica de documentos de entrada relacionados ao PC/AE"
Local aList1 := {}
Local lContinua := .F.
Local oDlg := Nil
Local oQtd := Nil
Local nQtd := 0
Local oSaldo := Nil
Local nSaldo := 0
Local oBold := Nil

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

aAdd(aList1,{"","","","","","","",""})

DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 300,670 PIXEL
@ 003,005 SAY "Qtd. PC/AE:"				 				SIZE 060,08 OF oDlg PIXEL FONT oBold COLOR CLR_HBLUE
@ 010,005 MSGET oQtd VAR nQtd PICTURE PesqPict("SC7","C7_QUANT") WHEN .F. SIZE 060,08 OF oDlg PIXEL FONT oBold COLOR CLR_HBLUE
@ 003,140 SAY "Saldo PC/AE:"		 					SIZE 060,08 OF oDlg PIXEL FONT oBold COLOR CLR_HBLUE
@ 010,150 MSGET oSaldo VAR nSaldo PICTURE PesqPict("SC7","C7_QUANT") WHEN .F. SIZE 060,08 OF oDlg PIXEL FONT oBold COLOR CLR_HBLUE

DEFINE SBUTTON FROM 005,280 TYPE 1 ACTION (nOpc := 0,oDlg:End()) ENABLE OF oDlg

@ 025,003 LISTBOX oListBox1 VAR cListBox1 Fields ;
HEADER OEMTOANSI(aTitulo[1]),OEMTOANSI(aTitulo[2]),OEMTOANSI(aTitulo[3]),OEMTOANSI(aTitulo[4]),OEMTOANSI(aTitulo[5]),OEMTOANSI(aTitulo[6]),OEMTOANSI(aTitulo[7]),OEMTOANSI(aTitulo[8]) SIZE 330,120 PIXEL ;
ColSizes 43,30,35,35,35,50,40,35
	
MsAguarde({|| MontaPro(@aList1,@oListBox1,@lContinua,@nQtd,@nSaldo)},"Processando consulta, aguarde...")
	
If !lContinua
	If SC7->C7_RESIDUO == "S"
		APMsgAlert("Item do Pedido/Aut.Ent. não tem notas relacionadas e está eliminada por residuo.")	
	Else	
		APMsgAlert("Não foram encontrados dados para a consulta solicitada.")	
	Endif	
Endif	
	
ACTIVATE MSDIALOG oDlg CENTERED

aEval(aArea,{|x| RestArea(x)})	

Return()


Static Function MontaPro(aList1,oListBox1,lContinua,nQtd,nSaldo)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local lFirst := .T.
Local nEntreg := 0

cQ := "SELECT D1_DOC,D1_PEDIDO,D1_COD,D1_DTDIGIT,D1_QUANT,D1_FORNECE,D1_LOJA "
cQ += "FROM "+RetSqlName("SD1")+" SD1 "
cQ += "WHERE SD1.D_E_L_E_T_ = ' ' "
cQ += "AND D1_FILIAL = '"+xFilial("SD1")+"' "
cQ += "AND D1_PEDIDO = '"+SC7->C7_NUM+"' "
cQ += "AND D1_ITEMPC = '"+SC7->C7_ITEM+"' "
cQ += "ORDER BY D1_FILIAL,D1_DOC "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQ),cAliasTrb, .F., .T.)

tcSetField(cAliasTrb,"D1_QUANT","N",TamSX3("D1_QUANT")[1],TamSX3("D1_QUANT")[2])
tcSetField(cAliasTrb,"D1_DTDIGIT","D",8,0)

nQtd := SC7->C7_QUANT

While (cAliasTrb)->(!Eof())
	If lFirst
		lFirst := .F.
		aList1 := {}
	Endif	
	aAdd(aList1,{SC7->C7_NUM,(cAliasTrb)->D1_COD,(cAliasTrb)->D1_DOC,(cAliasTrb)->D1_FORNECE,(cAliasTrb)->D1_LOJA,GetAdvFVal("SA2","A2_NREDUZ",xFilial("SA2")+(cAliasTrb)->D1_FORNECE+(cAliasTrb)->D1_LOJA,1,""),(cAliasTrb)->D1_DTDIGIT,Alltrim(Str((cAliasTrb)->D1_QUANT))})
	nEntreg += (cAliasTrb)->D1_QUANT	
	lContinua := .T.
	(cAliasTrb)->(dbSkip())
EndDo

//aSort(aList1,,,{|x,y| dTos(x[7])+x[3] > dTos(y[7])+y[3]}) // data digit+doc

nSaldo := nQtd-nEntreg

(cAliasTrb)->(dbCloseArea())

oListBox1:SetArray(aList1)
oListBox1:bLine := {|| {aList1[oListBox1:nAt,1],aList1[oListBox1:nAt,2],aList1[oListBox1:nAt,3],aList1[oListBox1:nAt,4],aList1[oListBox1:nAt,5],aList1[oListBox1:nAt,6],aList1[oListBox1:nAt,7],aList1[oListBox1:nAt,8]}}
oListBox1:Refresh()

Return()