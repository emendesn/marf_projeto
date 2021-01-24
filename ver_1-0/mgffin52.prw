#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              MGFFIN52
Autor....:              Leonardo Kume        
Data.....:              14/03/2017
Descricao / Objetivo:   Informações sobre o Limite de crédito do cliente da Rede 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFI52A(aParam)

	Local oRadMenu1
	Local aOpcoes := {}
	Static oDlg3
	Private nRadMenu1 := 1

	If aParam[1] == 1// Deve retornar o nome a ser exibido no botão

		Return "Outras funções"

	ElseIf aParam[1] == 2


	Else            

		aadd(aOpcoes,"Tit.Vencidos")
		aadd(aOpcoes,"Limite de Credito Rede")
		//aadd(aOpcoes,"Tit.Baixados Marfrig")

		DEFINE MSDIALOG oDlg3 TITLE "Funções Posição Cliente" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL
		oRadMenu1:= tRadMenu():New(20,06,aOpcoes,{|u|if(PCount()>0,nRadMenu1:=u,nRadMenu1)}, oDlg3,,,,,,,,159,130,,,,.T.)
		@ 006, 006 SAY oSay1 PROMPT "Selecione a função :" SIZE 091, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
		@ 070,  90 BUTTON "Executar" SIZE 050, 012 PIXEL OF oDlg3 Action(processa ({|| Botao()},"Executa função"))
		@ 070, 150 BUTTON "Cancelar" SIZE 050, 012 PIXEL OF oDlg3 Action(oDlg3:End())

		ACTIVATE MSDIALOG oDlg3 CENTERED

	ENDIF

Return()

Static Function Botao()

	If nRadMenu1 == 1
		Return U_MGFFIN20()	 
	ElseIf nRadMenu1 == 2
		Return U_MGFFIN52()	 
	ElseIf nRadMenu1 == 3
		Return U_MGFFIN54()	 
	EndIf

Return

User Function MGFFIN52()

	Local aAlias	:= {} 
	Local aParam 	:= {}
	Local aGet      := {"","","",""}
	LOCAL cQuery    := '' 
	LOCAL _cCodRede := SA1->A1_ZREDE  
	LOCAL dDtVenc   := DTOS(dDataBase)
	Local cAliasSA1	:= GetNextAlias() 
	Local cRaizCNPJ := Subs(SA1->A1_CGC,1,8)
	Local cQ := ""
	
	Private _xFilC  := " " 

	IF Select (cAliasSA1) > 0
		(cAliasSA1)->(dbCloseArea())  
	ENDIF

	cQ := StaticCall(MGFFIN22,QueryRede,_cCodRede,cRaizCNPJ,SA1->A1_EST)

	cQuery := "SELECT A1.A1_COD, A1.A1_LOJA, A1.A1_NOME, A1.A1_ZREDE, A1.A1_LC " +Chr(10)  
	cQuery += "  FROM "+RetSqlName("SA1")+" A1 " +Chr(10)   
	cQuery += " WHERE " +Chr(10)
	cQuery += "   A1.A1_FILIAL = '"+ xFilial("SA1") +"'" +CHR(10)
	//cQuery += "   AND (A1.A1_ZREDE = '"+ _cCodRede +"' OR SUBSTR(A1_CGC,1,8) = '"+cRaizCNPJ+"') " +CHR(10)
	cQuery += cQ
	cQuery += "   AND A1.D_E_L_E_T_=' ' " +Chr(10) 
	cQuery := ChangeQuery( cQuery )

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasSA1, .F., .T. )

	dbSelectArea(cAliasSA1)
	dBGotop()
	Do While !(cAliasSA1)->( Eof() )
		aadd( aAlias, { (cAliasSA1)->A1_COD, (cAliasSA1)->A1_LOJA, (cAliasSA1)->A1_NOME, (cAliasSA1)->A1_ZREDE, (cAliasSA1)->A1_LC })
		(cAliasSA1)->( DbSkip() )
	EndDo

	DEFINE DIALOG oDlg4 TITLE "Limites de crédito Cliente Rede "+ _cCodRede  FROM 180,180 TO 580,780 PIXEL
	nList := 1

	oBrowse := TCBrowse():New( 01 , 01, 300, 200,, {'Codigo','Loja','Nome','Rede','LC'},{20,50,50,50}, oDlg4,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	oBrowse:SetArray(aAlias)

	oBrowse:bLine := {||{ aAlias[oBrowse:nAt,01],;
	aAlias[oBrowse:nAt,02],;
	aAlias[oBrowse:nAt,03],;
	aAlias[oBrowse:nAt,04],;
	Transform(aAlias[oBrowse:nAT,05],'@E 99,999,999,999.99') } }

	ACTIVATE DIALOG oDlg4 CENTERED

	IF Select (cAliasSA1) > 0
		(cAliasSA1)->(dbCloseArea())  
	ENDIF


Return()