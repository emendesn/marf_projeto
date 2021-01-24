#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa.:              fGrvCpos
Autor....:              Luis Artuso
Data.....:              01/11/16
Descricao / Objetivo:   Execucao DO P.E. EECAE100
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				Rotina chamadora: MGFEEC09.PRW
=====================================================================================
*/
User Function fGrvCpos()

	Local cParam := ""

	Do Case

		Case (ValType(ParamIxb) = "A")

		cParam	:= ParamIxb[1]

		Case (ValType(ParamIxb) = "C" )

		cParam	:= ParamIxb

	EndCase

	If ( AllTrim(cParam) == "GRV_CPOS_CUSTOM" )

		fEEC1001()

	EndIf

Return .T.

/*
=====================================================================================
Programa.:              fEEC1001
Autor....:              Luis Artuso
Data.....:              01/11/16
Descricao / Objetivo:   Verifica e grava (caso haja alteracao nos campos conforme rotina) na tabela ZZ7
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fEEC1001()

	Local aAreaAtu		:= GetArea()
	Local aAreaEE7		:= EE7->(GetArea())
	Local aAreaEEC		:= EEC->(GetArea())
	Local cFieldsEEC	:= ""
	Local cFieldsZZ7	:= ""
	Local aFieldsEEC	:= {}
	Local aFieldsZZ7	:= {}
	Local cAliasTMP		:= ""
	Local cQuery		:= ""
	Local cChaveEEC		:= ""
	Local cAliasZZ6		:= ""
	Local cAliasZZ7		:= ""
	Local cAliasEE7		:= ""
	Local cAliasEEC		:= ""
	Local nReg			:= 0
	Local nPosField		:= 0
	Local lAlterou		:= .F.
	Local nX			:= 0
	Local nLen			:= 0
	Local cFieldEEC		:= ""
	Local xValue		:= ""
	Local oDlg
	Local oGet1
	Local cGet1			:= ""
	Local oButton1
	Local oButton2

	cFieldsEEC	:= "EEC_XAGEMB|EEC_BOOK|EEC_ETA|EEC_DEADLI|EEC_OBS|EEC_EMBARC"

	cFieldsZZ7	:= "ZZ7_AGEMB|ZZ7_BOOK|ZZ7_ETA|ZZ7_DEAD|ZZ7_OBS|ZZ7_EMBARC"

	aFieldsEEC	:= StrToKarr(cFieldsEEC , "|")

	aFieldsZZ7	:= StrToKarr(cFieldsZZ7 , "|")

	cAliasTMP	:= GetNextAlias()

	cAliasZZ6	:= "ZZ6"

	cAliasZZ7	:= "ZZ7"

	cAliasEEC	:= "EEC"

	cAliasEE7	:= "EE7"

	DbSelectArea(cAliasEE7)
	(cAliasEE7)->(DbSetOrder(1))
	(cAliasEE7)->(DbSeek(xFilial("EE7")+M->EEC_PEDREF))
	//	cChaveEEC	:= xFilial(cAliasZZ7) + M->EEC_PREEMB + " "
	If Select("EEC") > 0
		cChaveEEC	:= xFilial(cAliasZZ7) + M->EEC_ZEXP + M->EEC_ZANOEX+ M->EEC_ZSUBEX + " "
	Else
		cChaveEEC	:= xFilial(cAliasZZ7) + M->EE7_ZEXP + M->EE7_ZANOEX+ M->EE7_ZSUBEX + " "
	Endif

	cQuery		:=	"SELECT MAX(R_E_C_N_O_) REGISTRO FROM " + RetSqlName(cAliasZZ7) + " " + cAliasZZ7 + " "

	cQuery		+=	"WHERE "

	cQuery		+=		cAliasZZ7+".ZZ7_CHAVE = " + "'" + cChaveEEC + "'" + " AND "

	cQuery		+=		cAliasZZ7+".D_E_L_E_T_ <> " + "'*'"

	cQuery		+=	"GROUP BY "

	cQuery		+=		cAliasZZ7+".ZZ7_CHAVE "

	fExecQry(cQuery , cAliasTMP)

	Do Case

		Case ( ALTERA )

			nReg	:= (cAliasTMP)->(REGISTRO)
	
			(cAliasZZ7)->(dbGoTo(nReg))
	
			nLen	:= Len(aFieldsEEC)
	
			Do While ( (++nX <= nLen) .AND. (!lAlterou) )
	
				cFieldEEC	:= aFieldsEEC[nX]
	
				nPosField	:=	(cAliasZZ7)->(FieldPos(aFieldsZZ7[nX]))
	
				xValue		:=	(cAliasZZ7)->(FieldGet(nPosField))
	
				If ( ValType(xValue) == "C" )
	
					xValue	:= PadR(xValue , TamSX3(cFieldEEC)[1])
	
				EndIf
	
				If TamSX3(cFieldEEC)[3] == "D"
					if ValType(xValue) == "C"
						xValue := iif("/" $ xValue,CTOD(xValue),STOD(xValue))
					EndIf
				EndIf
	
				If ( ValType(xValue) == "C" )
					If ! ( Alltrim((cAliasEEC)->(&cFieldEEC)) == Alltrim((cAliasZZ7)->(xValue) ) )
	
						lAlterou	:= .T.
	
					EndIf
				Else
					If ! ( (cAliasEEC)->(&cFieldEEC) == (cAliasZZ7)->(xValue) )
	
						lAlterou	:= .T.
	
					EndIf
				EndIf
	
			EndDo
	
			If ( lAlterou ) .and. !IsInCallStack("u_mgftas02") .and. !IsInCallStack("u_tas02eecap100") .and. !IsInCallStack("U_MONINT72")
				
				ConPad1(NIL,NIL,NIL,"ZZ6C01") //Executa a consulta padrao
	
				DEFINE MSDIALOG oDlg TITLE OemToAnsi( 'Informe a justificativa ' ) From 000 , 000 TO 250,450 OF GetWndDefault() PIXEL
	
				@ 015 , 035 GET oGet1 VAR cGet1 MEMO SIZE 160, 80 OF oDlg COLORS 0, 16777215 PIXEL
				@ 105 , 125 BUTTON oButton1 PROMPT "&Limpa " SIZE 040 , 15 OF oDlg PIXEL ACTION (cGet1 := "" , oDlg:SetFocus())
				@ 105 , 175 BUTTON oButton2 PROMPT "&Grava o Motivo" SIZE 040 , 15 OF oDlg PIXEL ACTION oDlg:End()
	
				ACTIVATE MSDIALOG oDlg
	
	
				RecLock(cAliasZZ7 , .T.)
		
				For nX	:=	1 TO nLen
		
					nPosField	:=	(cAliasEEC)->(FieldPos(aFieldsEEC[nX]))
		
					xValue		:=	(cAliasEEC)->(FieldGet(nPosField))
		
					If aFieldsEEC[nX] == "EEC_OBS"
						xValue := E_MSMM(EEC->EEC_CODMEM,60)
					EndIf
		
					If !(Empty(xValue))
		
						nPosField	:=	(cAliasZZ7)->(FieldPos(aFieldsZZ7[nX]))
		
						(cAliasZZ7)->(FieldPut(nPosField , xValue))
		
					EndIf
	
				Next nX
				
				(cAliasZZ7)->(MsUnlock())
			EndIf
			If ( lAlterou )
				RecLock((cAliasZZ7), .F.)
				(cAliasZZ7)->ZZ7_FILIAL	:=	(cAliasEEC)->(EEC_FILIAL)
				(cAliasZZ7)->ZZ7_DATA	:=	dDataBase
				(cAliasZZ7)->ZZ7_USER	:=	(cAliasEEC)->(EEC_CODUSU)
				(cAliasZZ7)->ZZ7_CHAVE	:=	cChaveEEC
				(cAliasZZ7)->ZZ7_MOTIVO	:=	Iif(lAlterou,(cAliasZZ6)->(ZZ6_DESCR),"")
		
				(cAliasZZ7)->(MsUnlock())
		
				MSMM(NIL,NIL,NIL,AllTrim(cGet1),1,,,"ZZ7","ZZ7_CODMEM")
			EndIf

		Case ( INCLUI )

			nLen	:= Len(aFieldsEEC)
	
			RecLock(cAliasZZ7 , .T.)
	
			For nX	:=	1 TO nLen
	
				nPosField	:=	(cAliasEEC)->(FieldPos(aFieldsEEC[nX]))
	
				xValue	:=	(cAliasEEC)->(FieldGet(nPosField))
	
				If !(Empty(xValue))
	
					nPosField	:=	(cAliasZZ7)->(FieldPos(aFieldsZZ7[nX]))
	
					(cAliasZZ7)->(FieldPut(nPosField , xValue))
	
				EndIf
	
			Next nX
	
			(cAliasZZ7)->ZZ7_FILIAL	:=	(cAliasEEC)->(EEC_FILIAL)
			(cAliasZZ7)->ZZ7_DATA	:=	dDataBase
			(cAliasZZ7)->ZZ7_USER	:=	(cAliasEEC)->(EEC_CODUSU)
			(cAliasZZ7)->ZZ7_CHAVE	:=	cChaveEEC
	
			(cAliasZZ7)->(MsUnlock())

	EndCase

	EEC->(RestArea(aAreaEEC))
	EE7->(RestArea(aAreaEE7))
	RestArea(aAreaAtu)

Return

/*
=====================================================================================
Programa.:              fExecQry
Autor....:              Luis Artuso
Data.....:              03/11/16
Descricao / Objetivo:   Verifica se ha alteracoes anteriores na tabela ZZ7 para a embarcacao. Posiciona no ultimo registro e verifica os campos alterados.
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fExecQry(cQuery , cAlias)

	Local lNewArea	:= .T.
	Local cRdd		:= __cRdd
	Local lShare	:= .F.
	Local lOnlyRead	:= .T.

	dbUseArea(lNewArea , cRdd , TcGenQry(NIL , NIL , cQuery) , cAlias , lShare , lOnlyRead)

Return


user function tela()

	Local oDlg
	Local oGet1


	//PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'

	//Seta job para nao consumir licensas
	RpcSetType(3)

	// Seta job para empresa filial desejada
	RpcSetEnv( '99', '01',,,)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi( 'Informe a justificativa ' ) From 000 , 000 TO 250,450 OF GetWndDefault() PIXEL

	@ 015 , 035 GET oGet1 VAR cGet1 MEMO SIZE 160, 80 OF oDlg COLORS 0, 16777215 PIXEL
	@ 105 , 125 BUTTON oButton1 PROMPT "&Limpa " SIZE 040 , 15 OF oDlg PIXEL ACTION (cGet1 := "" , oDlg:SetFocus())
	@ 105 , 175 BUTTON oButton2 PROMPT "&Grava o Motivo" SIZE 040 , 15 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg

Return