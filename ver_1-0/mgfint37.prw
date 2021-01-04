#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa............: MGFINT37
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integracao De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Aprovacoes
Data................: 27/09/2019
Atualizacao.........: Foi inserida uma funcao INT37_EST para incluir
					  automaticamente o Cliente na Estrutura de Venda do vendedor.
History_1 - No final da aprovação da grade , atualizar o campo de alteração do 
Mercado Eletrônico 					   
=====================================================================================
*/
User Function MGFINT37

	Private cCadastro := "Aprovacoes de Cadastro"
	Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1},;
		{"Etapas"    ,"U_INT37_MAN", 0,2},;
		{"Visualizar","AxVisual", 0,2},;
		{"Analisar"  ,"U_INT37_APR",0,3},;
		{"Visualiza Alteracoes","U_INT37_VIS",0,2},;
		{"Legenda"   ,"U_INT37_Legenda", 0, 6 }}

	Private aCores    := { {'ZB1_STATUS=="1"','ENABLE' },;
		{'ZB1_STATUS=="2"','DISABLE' },;
		{'ZB1_STATUS=="3"','BR_AZUL' },;
		{'ZB1_STATUS=="4"','BR_AMARELO'}}

	dbSelectArea('ZB1')
	ZB1->(dbSetOrder(1))

	mBrowse( 6,1,22,75,"ZB1",,,,,,aCores)

Return
	**************************************************************************************************
User Function INT37_L2()

	local aLegenda:= {}

	AADD(aLegenda, {"ENABLE"	 ,'Etapa Aprovada'})
	AADD(aLegenda, {"DISABLE"	 ,'Etapa Rejeitada'})
	AADD(aLegenda, {"BR_AMARELO" ,'Etapa Pendente'})

	BrwLegenda('Aprovacoes de Cadastro','CDM',aLegenda)

Return

	**************************************************************************************************
User Function INT37_Legenda()

	local aLegenda:= {}

	AADD(aLegenda, {"ENABLE"	 ,'Solicitacao Aprovada'})
	AADD(aLegenda, {"DISABLE"	 ,'Solicitacao Rejeitada'})
	AADD(aLegenda, {"BR_AZUL"	 ,'Solicitacao Aberta'})
	AADD(aLegenda, {"BR_AMARELO" ,'Aprovacao em Andamento'})

	BrwLegenda('Aprovacoes de Cadastro','CDM',aLegenda)

Return
	**************************************************************************************************
User Function INT37_MAN( cAlias, nReg, nOpc )

	Private aRotina2  := aRotina
	Private cCadastro2 := cCadastro
	Private aIndexNF   := {}
	Private cFiltro    := ''
	Private bFiltraBrw := ''
	Private aCores     := { {'ZB2_STATUS=="1"','ENABLE' },;
		{'ZB2_STATUS=="2"','DISABLE' },;
		{'ZB2_STATUS=="3"','BR_AMARELO'}}


	cCadastro := 'Consulta Roteiro de Aprovacoes'
	aRotina := {}
	AADD(aRotina, { 'Pesquisar',  'AxPesqui', 0, 1 })
	AADD(aRotina, { 'Visualizar', 'AxVisual'  , 0, 2 })
	AADD(aRotina, { 'Legenda'     ,"U_INT37_L2", 0, 6 })

	dbSelectArea('ZB2')
	dbSetOrder(1)

	cFiltro  += "  ZB2_ID     == '"+ZB1->ZB1_ID+"'"

	bFiltraBrw  := {|| FilBrowse('ZB2',@aIndexNF,@cFiltro) }
	Eval(bFiltraBrw)

	mBrowse(6, 1, 22, 75, 'ZB2',,,,,,aCores)

EndFilBrw('ZB2',aIndexNF)

aRotina   := aRotina2
cCadastro := cCadastro2

Return
*******************************************************************************************************************************
User Function INT37_APR
	local bEtapa  := .T.
	local bPassou := .T.
	local cIDSET  := ''
	local cABA    := ''
	Private nRecZB2 := 0

// Verifica a etapa que esta parada
// Verifica se o usuario pertence ao Grupo IDSET da ZB2
// Verifica o tipo de Cadastro
	IF ZB1->ZB1_STATUS =='1' .OR. ZB1->ZB1_STATUS =='2'
		MsgAlert('Solicitacao j� Aprovada/Rejeitada !!')
	Else
		ZB2->(dbSetOrder(1))
		ZB2->(dbSeek(ZB1->ZB1_ID))
		bEtapa  := .T.
		bPassou := .F.
		While ZB2->(!Eof()) .And. ZB1->ZB1_ID == ZB2->ZB2_ID .And. bEtapa
			IF ZB2->ZB2_STATUS == '3'
				bEtapa  := .F.
				cIDSET  := ZB2->ZB2_IDSET
				cABA    := ZB2->ZB2_IDABA
				nRecZB2 := ZB2->(Recno())
				bPassou := .T.
			EndIF
			ZB2->(dbSkip())
		End
		IF bPassou
			bPassou := .F.
			ZAZ->(dbSetOrder(3))
			ZAZ->(dbSeek(cIDSET))
			bEtapa := .T.
			While ZAZ->(!Eof()) .And. ZAZ->ZAZ_IDSET == cIDSET .And. bEtapa
				IF ZAZ->ZAZ_USER == RetCodUsr()
					bEtapa     := .F.
					bPassou    := .T.
				EndIF
				ZAZ->(dbSkip())
			End
			IF !bPassou
				msgAlert('Usuario nao pertence ao Setor pendente de aprovacao!!')
			Else
				IF ZB1->ZB1_TIPO == '1' // Cadastro
					INT37_INC(cIDSet)
				ElseIF ZB1->ZB1_TIPO == '2' // Alteracao
					INT37_ALT(cIDSET,cABA)
				EndIF
			EndIF
		EndIF
	EndIF


Return
	*************************************************************************************************************************************************
Static Function INT37_ALT(cIDSET,cABA)
	local oDlg1
	local oButton
	local oBold
	local oListDados
	local cAprovador := Alltrim(RetCodUsr())+'-'+UsrRetName(RetCodUsr())
	local cSetor     := GetAdvFVal( "ZB6", "ZB6_NOME", cIDSET,1,"")
	local cRegistro  := ''
	local cDados     := ''
	local cCadZB1    := ''
	local cTab       := ''
	local bAba       := .F.

	Private aDados := {}
	Private aTodos := {}


	Private cOBS       := SPACE(254)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -16 BOLD

	DO CASE
	CASE ZB1->ZB1_CAD == '1'
		cCadZB1    :=  "Cadastro de Cliente"
		cTab       := 'SA1'
		dbSelectArea('SA1')
		SA1->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA1->A1_COD
		cDados     := SA1->A1_NOME
		bAba       := .T.
	CASE ZB1->ZB1_CAD == '2'
		cCadZB1    :=  "Cadastro de Endereco de Entrega"
		cTab       := 'SZ9'
		dbSelectArea('SZ9')
		SZ9->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SZ9->Z9_ZCLIENT
		cDados     := SZ9->Z9_ZRAZEND
	CASE ZB1->ZB1_CAD == '3'
		cCadZB1    :=  "Cadastro de Fornecedores"
		cTab       := 'SA2'
		dbSelectArea('SA2')
		SA2->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA2->A2_COD+'-'+SA2->A2_LOJA
		cDados     := SA2->A2_NOME
		bAba       := .T.
	CASE ZB1->ZB1_CAD == '4'
		cCadZB1    :=  "Cadastro de Transportadoras"
		cTab       := 'SA4'
		dbSelectArea('SA4')
		SA4->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA4->A4_COD
		cDados     := SA4->A4_NOME
	CASE ZB1->ZB1_CAD == '5'
		cCadZB1    :=  "Cadastro de Vendedores"
		cTab       := 'SA3'
		dbSelectArea('SA3')
		SA3->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA3->A3_COD
		cDados     := SA3->A3_NOME
	CASE ZB1->ZB1_CAD == '6'
		cCadZB1    :=  "Cadastro de Veiculos"
		cTab       := 'DA3'
		dbSelectArea('DA3')
		DA3->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := DA3->DA3_COD
		cDados     := DA3->DA3_DESC
	CASE ZB1->ZB1_CAD == '7'
		cCadZB1    :=  "Cadastro de Motorista"
		cTab       := 'DA4'
		dbSelectArea('DA4')
		DA4->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := DA4->DA4_COD
		cDados     := DA4->DA4_NOME
	CASE ZB1->ZB1_CAD == '8'
		cCadZB1    :=  "Cadastro de Produtos"
		cTab       := 'SB1'
		dbSelectArea('SB1')
		SB1->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SB1->B1_COD
		cDados     := SB1->B1_DESC
		bAba       := .T.
	ENDCASE
	DbSelectArea('ZB3')
	ZB3->(dbSetOrder(1))
	ZB3->(dbSeek(ZB1->ZB1_ID))
	While ZB3->(!Eof()) .And. ZB1->ZB1_ID == ZB3->ZB3_ID
		IF bAba
			IF cABA == ZB3->ZB3_ABA
				AAdd(aDados,{ZB3->ZB3_CAMPO,ZB3->ZB3_DESC,Alltrim(ZB3->ZB3_OLD),Alltrim(ZB3->ZB3_NEW)})
			EndIF
		Else
			AAdd(aDados,{ZB3->ZB3_CAMPO,ZB3->ZB3_DESC,Alltrim(ZB3->ZB3_OLD),Alltrim(ZB3->ZB3_NEW)})
		EndIF
		AAdd(aTodos,{ZB3->ZB3_CAMPO,ZB3->ZB3_DESC,Alltrim(ZB3->ZB3_OLD),Alltrim(ZB3->ZB3_NEW)})
		ZB3->(dbSkip())
	End

	DEFINE MSDIALOG oDlg1 TITLE "Analise da Alteracao" FROM 000, 000  TO 570, 810 COLORS 0, 16777215 PIXEL

	@ 005,005 SAY cCadZB1   SIZE 120, 020 OF oDLG1 PIXEL FONT oBold COLOR CLR_BLUE
	@ 017,005 TO 018,400  OF oDLG1 PIXEL

	@ 026,009  SAY "Aprovador"    	  SIZE 040, 009 OF oDLG1 COLORS 0, 16777215 PIXEL
	@ 022,044  MSGET  cAprovador	  SIZE 223, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right

	@ 042,009  SAY "Setor"    	      SIZE 040, 009 OF oDLG1 COLORS 0, 16777215 PIXEL
	@ 038,044  MSGET  cSetor          SIZE 100, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right

	@ 058,009  SAY "Registro"         SIZE 140, 009 OF oDLG1 COLORS 0, 16777215 PIXEL
	@ 054,044  MSGET  cRegistro       SIZE 042, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right
	@ 054,089  MSGET  cDados          SIZE 179, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right


	oListDados := TWBrowse():New( 072,009,391,150,,{'Campo','Descricao','Conteudo Anterior','Conteudo Atual'},{30,40,120,90},oDlg1, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oListDados:SetArray(aDados)
	cbLine := "{||{ aDados[oListDados:nAt,01], aDados[oListDados:nAt,02], aDados[oListDados:nAt,03], aDados[oListDados:nAt,04]} }"
	oListDados:bLine       := &cbLine

	//oListDados     := TListBox():New( 072,009,,,391,150,,oDlg1,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )

	@ 225,009  SAY "Observacao"    SIZE 040, 009 OF oDLG1 COLORS 0, 16777215 PIXEL
	@ 225,044  MSGET  cOBS         SIZE 232,026  OF oDLG1 COLORS 0, 16777215 PIXEL


	oButton := TButton():New( 264,088,"Aprovar" ,oDlg1,{||IIF(INT37_APV(cTab),oDlg1:End(),)},065,012,,,,.T.,,"",,,,.F. )
	oButton := TButton():New( 264,269,"Reprovar",oDlg1,{||IIF(INT37_REP(cTab),oDlg1:End(),)},065,012,,,,.T.,,"",,,,.F. )

	oButton := TButton():New( 022,335,"Visualizar Registro",oDlg1,{||INT37_VIS(cIDSET)},065,012,,,,.T.,,"",,,,.F. )
	oButton := TButton():New( 037,335,"Base de Conhecimento",oDlg1,{||INT37_BAS(cIDSET)},065,012,,,,.T.,,"",,,,.F. )

	ACTIVATE MSDIALOG oDlg1 CENTERED


Return
	*****************************************************************************************************************************
Static Function INT37_APV(cTab)
	local bRet := .F.
	local cSuf := ''
	local lNotAltSA1 := .F.
	local lAchei := .f.
	local I := 0
	IF MsgYESNO('Aprova as Alteracoes ?')
		bRet := .T.
		ZB2->(dbGoto(nRecZB2))
		RecLock("ZB2", .F.)
		ZB2->ZB2_IDAPR  := RetCodUsr()
		ZB2->ZB2_DATA   := date()
		ZB2->ZB2_HORA   := Time()
		ZB2->ZB2_STATUS := '1'
		ZB2->ZB2_EMAIL  := 'N'
		ZB2->ZB2_OBS    := cOBS
		ZB2->(msUnlock())
		ZB2->(dbSkip())
		
		IF ZB2->(!EOF()) .And. ZB1->ZB1_ID == ZB2->ZB2_ID
			RecLock("ZB2", .F.)
			ZB2->ZB2_EMAIL  := 'S'
			ZB2->(msUnlock())

			RecLock("ZB1", .F.)
			ZB1->ZB1_STATUS := '4'
			ZB1->ZB1_IDSET  := ZB2->ZB2_IDSET
			ZB1->(msUnlock())
			
		Else
		
			RecLock("ZB1", .F.)
			ZB1->ZB1_STATUS := '1'
			ZB1->ZB1_EMAIL  := 'S'
			ZB1->(msUnlock())

			cSuf := IF(SUBSTR(cTab,1,1)=='D',cTab,SubStr(cTab,2,2))
			dbSelectArea(cTab)
			&(cTab)->(dbGoTo(ZB1->ZB1_RECNO))

			RecLock(cTab, .F.)
			IF Len(aTodos) > 1 // mais de um campo alterado no cadastro
				// regra passada pela usuaria Valquiria do CDM, em 09/08/18
				// se for o cadastro de cliente e o que foi alterado foi o campo de bloqueio nao deve desbloquear o cliente,
				// pois quando o cdm inativa o cliente, o procedimento eh sempre preencher o campo de bloqueio com sim e neste caso, nem a aprovacao do financeiro deve desbloquear o cliente
				//		If (cTab == "SA1" .and. aScan(aTodos,{|x| AllTrim(x[1]) == AllTrim(cSuf+"_MSBLQL")}) > 0) //.and. aScan(aTodos,{|x| AllTrim(x[1]) == AllTrim(cSuf+"_ZALTCRE")}) > 0)
				//			lNotAltSA1 := .T.
				//		Else
				FOR I:= 1 TO LEN(aTodos)// Rafael 28/12/2018
					IF alltrim(aTodos[I][1])== AllTrim(cSuf+"_MSBLQL")
						&(cTab+"->"+cSuf+"_MSBLQL") := aTodos[I][4]
						lAchei:= .t.
					ENDIF
				NEXT
				IF !lAchei
					&(cTab+"->"+cSuf+"_MSBLQL") := "2"
				endif
				If cTab == "SA1"
					If SA1->A1_ZINATIV == "1"
						SA1->A1_ZINATIV := "0"
					EndIf
					If SA1->A1_XENVECO == "1"
						SA1->A1_XINTECO:= "0"
					EndIf

					if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
						if SA1->A1_XENVSFO == "S"
							SA1->A1_XINTSFO := "P"
						endif
					endif
				elseif cTab == "SZ9"
					SZ9->Z9_XINTSFO := "P"
				EndIf
				//		Endif
			Else // somente 1 campo alterado no cadastro e nao foi o campo de bloqueio
				IF alltrim(aTodos[1][1]) == AllTrim(cSuf+"_MSBLQL")
					&(cTab+"->"+cSuf+"_MSBLQL") :=  aTodos[1][4]     // '2' Rafael 28/12/2018
					If cTab == "SA1"
						If SA1->A1_ZINATIV == "1"
							SA1->A1_ZINATIV := "0"
						EndIf
						If SA1->A1_XENVECO == "1"
							SA1->A1_XINTECO:= "0"
						EndIf

						if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
							if SA1->A1_XENVSFO == "S"
								SA1->A1_XINTSFO := "P"
							endif
						endif
					EndIf
				Else
					&(cTab+"->"+cSuf+"_MSBLQL") := "2"
				EndIF
			EndIF

			if cTab == "SZ9"
				SZ9->Z9_XINTSFO := "P"
			endif

			if cTab == "SB1"  //Tratamento aprov. alteracao produto p/ Salesforce
				
				if SB1->B1_XENVSFO == "S"
					SB1->B1_XINTSFO := "P"
				endif

				// History_1 
				If SB1->B1_ZPEDME == "S" .AND. SB1->B1_COD >= '500000' .AND. SB1->B1_MGFFAM <> ' '
					SB1->B1_ZPEDME := "A"
				Endif
			endif

			// History_1 
			If cTab == 'SA2' .AND. SA2->A2_ZPEDME == "S" .AND. SA2->A2_ZINTME == "S" .AND. SA2->A2_EMAIL <> ' '
			
					SA2->A2_ZPEDME := "A"
			Endif

			IF cTab == 'SB1' .OR. cTab =='SA2' .OR. cTab =='SA4'
				&(cTab+"->"+cSuf+"_ZTAUREE") := 'S'
			ENDIF
			IF cTab == 'DA3' .OR. cTab =='DA4'
				&(cTab+"->"+cSuf+"_ZTAURE") := 'S'
			ENDIF
			&(cTab)->(msUnlock())

			IF cTab == 'SB1'
				FwIntegDef("MATA010",,,, "MATA010")
			EndIF
			IF cTab == 'SA1'
				FwIntegDef("MATA030",,,, "MATA030")
			EndIF

			IF cTab == 'SA2' // Atualiza cadastro Transportadora
				Cad_Transportadora()
			EndIF
			IF cTab == 'SA4' .OR. cTab == 'SA1' .OR. cTab == 'SA2'
				If !(cTab == 'SA1' .and. lNotAltSA1)
					Atu_GFE(cTab,.T.) // .T. Alteracao
				Endif
			EndIF
		EndIF
	EndIF

Return bRet
	*****************************************************************************************************************************
Static Function INT37_REP(cTab)
	local bRet   := .F.
	local cSuf   := ''
	local nI     := 0
	local cTipX3 := ''

	IF MsgYESNO('Reprovar as Alteracoes ?')
		IF Empty(Alltrim(cOBS))
			MsgAlert('Observacao em Branco, favor prencher !!')
		Else
			bRet := .T.
			ZB2->(dbGoto(nRecZB2))
			RecLock("ZB2", .F.)
			ZB2->ZB2_IDAPR  := RetCodUsr()
			ZB2->ZB2_DATA   := Date()
			ZB2->ZB2_HORA   := Time()
			ZB2->ZB2_STATUS := '2'
			ZB2->ZB2_EMAIL  := 'N'
			ZB2->ZB2_OBS    := cOBS
			ZB2->(msUnlock())
			ZB2->(dbSkip())

			RecLock("ZB1", .F.)
			ZB1->ZB1_STATUS := '2'
			ZB1->ZB1_EMAIL  := 'S'
			ZB1->(msUnlock())

			cSuf := IF(SUBSTR(cTab,1,1)=='D',cTab,SubStr(cTab,2,2))
			dbSelectArea(cTab)
			&(cTab)->(dbGoTo(ZB1->ZB1_RECNO))
			RecLock(cTab, .F.)
			&(cTab+"->"+cSuf+"_MSBLQL") := '2'
			If cTab == "SA1"
				If SA1->A1_ZINATIV == "1"
					SA1->A1_ZINATIV := "0"
				EndIf
				If SA1->A1_XENVECO == "1"
					SA1->A1_XINTECO:= "0"
				EndIf

				if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
					if SA1->A1_XENVSFO == "S"
						SA1->A1_XINTSFO := "P"
					endif
				endif
			elseif cTab == "SZ9"
				SZ9->Z9_XINTSFO := "P"

			elseif cTab == "SB1"     //Tratamento da reprova��es produto p/ Salesforce
				if SB1->B1_XENVSFO == "S"
					SB1->B1_XINTSFO := "P"
				endif
			EndIf

			For nI := 1 To Len(aTodos)
				cTipX3 := TamSX3(aTodos[nI,01])[03]
				IF cTipX3 == 'D'
					&(cTab+"->"+aTodos[nI,01]) := CTOD(aTodos[nI,03])
				ElseIF cTipX3 == 'N'
					&(cTab+"->"+aTodos[nI,01]) := VAL(aTodos[nI,03])
				ElseIF cTipX3 == 'L'
					&(cTab+"->"+aTodos[nI,01]) := IIF(VAL(aTodos[nI,03])=='T',.T.,.F.)
				Else
					&(cTab+"->"+aTodos[nI,01]) := aTodos[nI,03]
				EndIF
			Next nI
			IF cTab == 'SB1' .OR. cTab =='SA2' .OR. cTab =='SA4'
				&(cTab+"->"+cSuf+"_ZTAUREE") := 'S'
			ENDIF
			IF cTab == 'DA3' .OR. cTab =='DA4'
				&(cTab+"->"+cSuf+"_ZTAURE") := 'S'
			ENDIF
			&(cTab)->(msUnlock())
			IF cTab == 'SA4' .OR. cTab == 'SA2' .OR. cTab == 'SA1'
				Atu_GFE(cTab,.T.) //Alteracao
			EndIF
		EndIF
	EndIF



Return bRet

	*************************************************************************************************************************************************
Static Function INT37_INC(cIDSET)
	local cAlias   := ''
	local nReg     := 0
	local nOPC     := 0
	local cMsg     := ''
	local aButtons := {}
	local aDados   := {}
	local nI       := 0
	local cVNew    := ''
	local cVOld    := ''

	DO CASE
	CASE ZB1->ZB1_CAD == '1'
		cAlias  := 'SA1'
		nOpc    := 4
		AADD( aButtons, {"EDIT", {|| MsDocument('SA1',SA1->(RecNo()),4)}, "Conhecimento" } )
	CASE ZB1->ZB1_CAD == '2'
		cAlias  := 'SZ9'
		nOpc    := 4
	CASE ZB1->ZB1_CAD == '3'
		cAlias  := 'SA2'
		nOpc    := 4
		AADD( aButtons, {"EDIT", {|| MsDocument('SA2',SA2->(RecNo()),4)}, "Conhecimento" } )
	CASE ZB1->ZB1_CAD == '4'
		cAlias  := 'SA4'
		nOpc    := 4
	CASE ZB1->ZB1_CAD == '5'
		cAlias  := 'SA3'
		nOpc    := 4
	CASE ZB1->ZB1_CAD == '6'
		cAlias  := 'DA3'
		nOpc    := 4
		AADD( aButtons, {"EDIT", {|| MsDocument('DA3',DA3->(RecNo()),4)}, "Conhecimento" } )
	CASE ZB1->ZB1_CAD == '7'
		cAlias  := 'DA4'
		nOpc    := 4
		AADD( aButtons, {"EDIT", {|| MsDocument('DA4',DA4->(RecNo()),4)}, "Conhecimento" } )
	CASE ZB1->ZB1_CAD == '8'
		cAlias  := 'SB1'
		nOpc    := 4
		AADD( aButtons, {"EDIT", {|| MsDocument('SB1',SB1->(RecNo()),4)}, "Conhecimento" } )
	ENDCASE

	dbSelectArea(cAlias)
	&(cAlias)->(dbGoTo(ZB1->ZB1_RECNO))

	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(dbSeek(cAlias))
	While ( SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cAlias )
		If X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )
			IF VALTYPE(cAlias+'->'+Alltrim(SX3->X3_CAMPO)) <> 'U'
				AAdd(aDados, {Alltrim(SX3->X3_CAMPO),&(cAlias+'->'+Alltrim(SX3->X3_CAMPO)),SX3->X3_TITULO,SX3->X3_TIPO,SX3->X3_FOLDER})
			EndIF
		EndIF
		SX3->(dbSkip())
	EndDo



	nReg := ZB1->ZB1_RECNO
	IF AxAltera(cAlias,nReg,nOpc,,,,,,,,aButtons) == 1
		MBrChgLoop(.F.)
		ZB2->(dbGoto(nRecZB2))
		// Gravar a ZB3 com os campos alterados
		For nI := 1 To Len(aDados)
			IF &(cAlias+'->'+Alltrim(aDados[nI,01])) <> aDados[nI,02]
				RecLock("ZB3", .T.)
				ZB3->ZB3_ID     := ZB2->ZB2_ID
				ZB3->ZB3_CAMPO	:= aDados[nI,01]
				ZB3->ZB3_DESC   := aDados[nI,03]
				ZB3->ZB3_TIPO   := aDados[nI,04]
				IF aDados[nI,04] == 'D'
					cVNew := DTOC(&(cAlias+'->'+Alltrim(aDados[nI,01])))
					cVOld := DTOC(aDados[nI,02])
				ElseIF aDados[nI,04] == 'N'
					cVNew := Alltrim(STR(&(cAlias+'->'+Alltrim(aDados[nI,01]))))
					cVOld := Alltrim(STR(aDados[nI,02]))
				ElseIF aDados[nI,04] == 'L'
					cVNew := IIF(&(cAlias+'->'+Alltrim(aDados[nI,01])),'T','F')
					cVOld := IIF(aDados[nI,02],'T','F')
				Else
					cVNew := &(cAlias+'->'+Alltrim(aDados[nI,01]))
					cVOld := aDados[nI,02]
				EndIF
				ZB3->ZB3_OLD   	:= cVOld
				ZB3->ZB3_NEW    := cVNew
				ZB3->ZB3_ABA    := aDados[nI,05]
				ZB3->ZB3_SEQ    := ZB2->ZB2_SEQ
				ZB3->(msUnlock())
			EndIF
		Next nI
		cMsg := 'Deseja Aprovar a Inclusao ?'
		IF MsgYESNO(cMsg)
			RecLock("ZB2", .F.)
			ZB2->ZB2_IDAPR  := RetCodUsr()
			ZB2->ZB2_DATA   := Date()
			ZB2->ZB2_HORA   := Time()
			ZB2->ZB2_STATUS := '1'
			ZB2->ZB2_EMAIL  := 'N'
			ZB2->(msUnlock())
			ZB2->(dbSkip())
			IF ZB2->(!EOF()) .And. ZB1->ZB1_ID == ZB2->ZB2_ID
				RecLock("ZB2", .F.)
				ZB2->ZB2_EMAIL  := 'S'
				ZB2->(msUnlock())

				RecLock("ZB1", .F.)
				ZB1->ZB1_STATUS := '4'
				ZB1->ZB1_IDSET  := ZB2->ZB2_IDSET
				ZB1->(msUnlock())
			Else
				RecLock("ZB1", .F.)
				ZB1->ZB1_STATUS := '1'
				ZB1->ZB1_EMAIL  := 'S'
				ZB1->(msUnlock())


				cSuf := IF(SUBSTR(cAlias,1,1)=='D',cAlias,SubStr(cAlias,2,2))
				dbSelectArea(cAlias)
				&(cAlias)->(dbGoTo(ZB1->ZB1_RECNO))
				RecLock(cAlias, .F.)
				&(cAlias+"->"+cSuf+"_MSBLQL") := '2'
				If cAlias == "SA1"
					If SA1->A1_ZINATIV == "1"
						SA1->A1_ZINATIV := "0"
					EndIf
					If SA1->A1_XENVECO == "1"
						SA1->A1_XINTECO:= "0"
					EndIf

					if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
						if SA1->A1_XENVSFO == "S"
							SA1->A1_XINTSFO := "P"
						endif
					endif

					U_MGFFATBE() // INCLUI NA ESTRUTURA COMERCIAL - CASO NAO EXISTA

				elseif cAlias == "SZ9"
					SZ9->Z9_XINTSFO := "P"

				elseif cAlias == "SB1"  //Tratamento aprov. inclusao p/ Salesforce
					if SB1->B1_XENVSFO == "S"
						SB1->B1_XINTSFO := "P"
					endif
				EndIf

				IF cAlias == 'SB1' .OR. cAlias =='SA2' .OR. cAlias =='SA4'
					&(cAlias+"->"+cSuf+"_ZTAUREE") := 'S'
				ENDIF
				IF cAlias == 'DA3' .OR. cAlias =='DA4'
					&(cAlias+"->"+cSuf+"_ZTAURE") := 'S'
				ENDIF
				&(cAlias)->(msUnlock())

				IF cAlias == 'SB1'
					FwIntegDef("MATA010",,,, "MATA010")
				EndIF
				IF cAlias == 'SA1'
					FwIntegDef("MATA030",,,, "MATA030")
				EndIF

				IF cAlias == 'SA2' // Atualiza cadastro Transportadora
					Cad_Transportadora()
				EndIF

				IF cAlias == 'SA4' .OR. cAlias == 'SA1' .OR. cAlias == 'SA2'
					Atu_GFE(cAlias,.F.) //Inclusao
				EndIF
			EndIF
		Else
			//IF ZB2->ZB2_SEQ == '01'
			cOBS := Ret_Obs('Observacao')
			IF Empty(Alltrim(cOBS))
				MsgAlert('Observacao em Branco, favor prencher !!')
			Else
				RecLock("ZB2", .F.)
				ZB2->ZB2_IDAPR  := RetCodUsr()
				ZB2->ZB2_DATA   := Date()
				ZB2->ZB2_HORA   := Time()
				ZB2->ZB2_STATUS := '2'
				ZB2->ZB2_EMAIL  := 'N'
				ZB2->ZB2_OBS    := cOBS
				ZB2->(msUnlock())
				ZB2->(dbSkip())

				RecLock("ZB1", .F.)
				ZB1->ZB1_STATUS := '2'
				ZB1->ZB1_EMAIL  := 'S'
				ZB1->(msUnlock())

				dbSelectArea(cAlias)
				&(cAlias)->(dbGoTo(ZB1->ZB1_RECNO))
				RecLock(cAlias, .F.)
				&(cAlias)->(dbDelete())
				&(cAlias)->(msUnlock())

			EndIF
		EndIF
	EndIF


Return

static function INT37_EST(xcCod, xcLoja)
	local vendedor	:=	SA1->A1_VEND
	local roteiro := ZBJ->ZBJ_ROTEIR
	local supervisor := ZBJ->ZBJ_SUPERV
	local regiao := ZBJ->ZBJ_REGION
	local tatica := ZBJ->ZBJ_TATICA
	local nacionalidade := ZBJ->ZBJ_NACION
	local diretoria := ZBJ->ZBJ_DIRETO

	dbSelectArea('ZBJ')
	ZBJ->(dbSetOrder(1))
	if ZBJ->( dbSeek( xFilial('ZBJ') + vendedor ) ) .AND. !empty( alltrim( vendedor ) )

		roteiro := ZBJ->ZBJ_ROTEIR
		supervisor := ZBJ->ZBJ_SUPERV
		regiao := ZBJ->ZBJ_REGION
		tatica := ZBJ->ZBJ_TATICA
		nacionalidade := ZBJ->ZBJ_NACION
		diretoria := ZBJ->ZBJ_DIRETO

		RecLock('ZBJ', .T.)

		ZBJ->ZBJ_ROTEIR := roteiro
		ZBJ->ZBJ_SUPERV := supervisor
		ZBJ->ZBJ_REGION := regiao
		ZBJ->ZBJ_TATICA := tatica
		ZBJ->ZBJ_NACION := nacionalidade
		ZBJ->ZBJ_DIRETO := diretoria
		ZBJ->ZBJ_CLIENT := xcCod
		ZBJ->ZBJ_LOJA := xcLoja
		ZBJ->ZBJ_REPRES := vendedor

		ZBJ->(msUnlock())
	// else
	// 	alert('Representante Nao localizado ou Em Branco')
	endif

Return

	***************************************************************************************************************************************
Static Function Ret_Obs(cTexto)

	local cMotivo := Space(254)
	local oButton2
	Static oDLG2


	DEFINE MSDIALOG oDLG2 TITLE "Entre com "+cTexto FROM 000, 000  TO 080, 395 COLORS 0, 16777215 PIXEL
	@ 008, 002 SAY  "Obs. :"    SIZE 028, 009 OF  oDLG2 COLORS 0, 16777215 PIXEL
	@ 006, 025 MSGET  cMotivo      SIZE 168, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	@ 021, 156 BUTTON oButton2 PROMPT "Confirma"  ACTION (oDLG2:End()) SIZE 037, 012 OF  oDLG2 PIXEL
	ACTIVATE MSDIALOG oDLG2 CENTERED

Return cMotivo
	**************************************************************************************************************
Static Function Atu_GFE(cTAB,bAlteracao)
	local lachei := .F.
	local PARAMIXB1 := {}
	local I := 0
	Private lMsErroAuto := .F.


	SetFunName("MGFINT37")

	IF cTab == 'SA2'
		dbSelectArea('SA2')
		SA2->(dbGoTo(ZB1->ZB1_RECNO))
		aadd(PARAMIXB1,{"A2_COD",SA2->A2_COD,})
		aadd(PARAMIXB1,{"A2_LOJA",SA2->A2_LOJA,})
		if ZB1->ZB1_STATUS=='2'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF alltrim(aTodos[I][1]) == "A2_MSBLQL"
						aadd(PARAMIXB1,{"A2_MSBLQL",aTodos[I][3],})
						lachei:= .t.
					ENDIF
				NEXT
			endIF
			if !lachei
				aadd(PARAMIXB1,{"A2_MSBLQL","1",})
			ENDIF //FIM ALTERACAO RAFAEL 28/12/2018
		ELSEIF ZB1->ZB1_STATUS=='1'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF  alltrim(aTodos[I][1]) == "A2_MSBLQL"
						aadd(PARAMIXB1,{"A2_MSBLQL",aTodos[I][4],})
						lachei:= .t.
					ENDIF
				NEXT
			EndIF
			if !lachei
				aadd(PARAMIXB1,{"A2_MSBLQL","2",})
			endif	//FIM ALTERACAO RAFAEL 28/12/2018
		ENDIF
		//aadd(PARAMIXB1,{"A2_MSBLQL",SA2->A2_MSBLQL,}) ALTERADO RAFAEL 01/11/2018
		MSExecAuto({|x,y| mata020(x,y)},PARAMIXB1,4)
		If lMsErroAuto
			msgAlert("Erro! Aprovacao/Reprova��o da alteracao do FORNECEDOR nao refletida no cadastro de EMITENTES do GFE!")
		EndIf
	ElseIF cTab == 'SA1'
		dbSelectArea('SA1')
		SA1->(dbGoTo(ZB1->ZB1_RECNO))
		aadd(PARAMIXB1,{"A1_COD",SA1->A1_COD,})
		aadd(PARAMIXB1,{"A1_LOJA",SA1->A1_LOJA,})
		if ZB1->ZB1_STATUS=='2'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF  alltrim(aTodos[I][1]) == "A1_MSBLQL"
						aadd(PARAMIXB1,{"A1_MSBLQL",aTodos[I][3],})
						lachei:= .t.
					ENDIF
				NEXT
			EndIF
			if !lachei
				aadd(PARAMIXB1,{"A1_MSBLQL","1",})
			ENDIF //FIM ALTERACAO RAFAEL 28/12/2018

		ELSEIF ZB1->ZB1_STATUS=='1'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF alltrim(aTodos[I][1]) == "A1_MSBLQL"
						aadd(PARAMIXB1,{"A1_MSBLQL",aTodos[I][4],})
						lachei:= .t.
					ENDIF
				NEXT
			EndIF
			if !lachei
				aadd(PARAMIXB1,{"A1_MSBLQL","2",})
			ENDIF //FIM ALTERACAO RAFAEL 28/12/2018
			If SA1->A1_ZINATIV == "1"
				aadd(PARAMIXB1,{"A1_ZINATIV", "0",})
			EndIf
			If SA1->A1_XENVECO == "1"
				aadd(PARAMIXB1,{"A1_XINTECO", "0",})
			EndIf

			if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
				if SA1->A1_XENVSFO == "S"
					aadd(PARAMIXB1,{"A1_XINTSFO", "P",})
				endif
			endif
		ENDIF
		//aadd(PARAMIXB1,{"A1_MSBLQL",SA1->A1_MSBLQL,}) ALTERADO RAFAEL 01/11/2018 tratamento para bloquear registro reprovado

		//if SA1->A1_MSBLQL == "2" .and. FieldPos("A1_ZINATIV") > 0 ALTERADO RAFAEL 01/11/2018 tratamento para bloquear registro reprovado

		MSExecAuto({|x,y| mata030(x,y)},PARAMIXB1,4)
		If lMsErroAuto
			msgAlert("Erro! Aprovacao/Reprova��o da alteracao��o do CLIENTE nao refletida no cadastro de EMITENTES do GFE!")
		EndIf
	ElseIF	cTab == 'SA4'
		dbSelectArea('SA4')
		SA4->(dbGoTo(ZB1->ZB1_RECNO))
		aadd(PARAMIXB1,{"A4_COD",SA4->A4_COD,})
		if ZB1->ZB1_STATUS=='2'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF alltrim(aTodos[I][1]) == AllTrim("A4_MSBLQL")
						aadd(PARAMIXB1,{"A4_MSBLQL",aTodos[I][3],})
						lachei:= .t.
					ENDIF
				NEXT
			EndIF
			if !lachei
				aadd(PARAMIXB1,{"A4_MSBLQL","1",})
			ENDIF //FIM ALTERACAO RAFAEL 28/12/2018
		ELSEIF ZB1->ZB1_STATUS=='1'
			IF bAlteracao
				FOR I:= 1 TO LEN(aTodos) //INICIO ALTERACAO RAFAEL 28/12/2018
					IF alltrim(aTodos[I][1]) == AllTrim("A4_MSBLQL")
						aadd(PARAMIXB1,{"A4_MSBLQL",aTodos[I][4],})
						lachei:= .t.
					ENDIF
				NEXT
			EndIF
			if !lachei
				aadd(PARAMIXB1,{"A4_MSBLQL","2",})
			ENDIF //FIM ALTERACAO RAFAEL 28/12/2018


			//	aadd(PARAMIXB1,{"A4_MSBLQL","2",})
		ENDIF

		//aadd(PARAMIXB1,{"A4_MSBLQL",SA4->A4_MSBLQL,})ALTERADO RAFAEL 01/11/2018 tratamento para bloquear registro reprovado
		MSExecAuto({|x,y| mata050(x,y)},PARAMIXB1,4)
		If lMsErroAuto
			msgAlert("Erro! Aprovacao/Reprova��o da alteracao da TRANSPORTADORA nao refletida no cadastro de EMITENTES do GFE!")
		EndIf
	EndIF
/*
RegToMemory('SA2')
MyMaEnvEAI(,,4,"MATA020",{ { "SA2", "MATA020_SA2" , NIL, NIL, NIL, NIL } } )
  */
  /*
	If FindFunction("MaEnvEAI")
		IF cTab == 'SA4'
		MaEnvEAI(,,4,"MATA050",{ { "SA4", "MATA050_SA4" , NIL, NIL, NIL, NIL} } )
		ElseIF cTab == 'SA2'
		MaEnvEAI(,,4,"MATA020",{ { "SA2", "MATA020_SA2" , NIL, NIL, NIL, NIL } } )
		ElseIF cTab == 'SA1'
		MaEnvEAI(,,4,"MATA030",{ { "SA1", "MATA030_SA1", NIL, NIL, NIL, NIL } },,,,,,"MATA030"  )
		EndIf
	EndIF
    */
Return
	*************************************************************************************************************************************************
Static Function INT37_VIS(cIDSET)
	local cAlias := ''
	local nReg   := 0
	local nOPC   := 0
	local cMsg   := ''
	local cBkCad := cCadastro
	Private cCadastro := "Visualiza Registro"


	DO CASE
	CASE ZB1->ZB1_CAD == '1'
		cAlias  := 'SA1'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '2'
		cAlias  := 'SZ9'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '3'
		cAlias  := 'SA2'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '4'
		cAlias  := 'SA4'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '5'
		cAlias  := 'SA3'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '6'
		cAlias  := 'DA3'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '7'
		cAlias  := 'DA4'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '8'
		cAlias  := 'SB1'
		nOpc    := 2
	ENDCASE

	dbSelectArea(cAlias)
	&(cAlias)->(dbGoTo(ZB1->ZB1_RECNO))

	nReg := ZB1->ZB1_RECNO
	AxVisual(cAlias,nReg,nOpc)
	MBrChgLoop(.F.)
	cCadastro := cBkCad

Return

	*************************************************************************************************************************************************
Static Function INT37_BAS(cIDSET)
	local cAlias := ''
	local nReg   := 0
	local nOPC   := 0
	local cMsg   := ''
	local bTem   := .T.
	local cBkCad := cCadastro
	Private cCadastro := "Base de Conhecimento"

	DO CASE
	CASE ZB1->ZB1_CAD == '1'
		cAlias  := 'SA1'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '2'
		bTem   := .F.
	CASE ZB1->ZB1_CAD == '3'
		cAlias  := 'SA2'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '4'
		cAlias  := 'SA4'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '5'
		bTem   := .F.
	CASE ZB1->ZB1_CAD == '6'
		cAlias  := 'DA3'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '7'
		cAlias  := 'DA4'
		nOpc    := 2
	CASE ZB1->ZB1_CAD == '8'
		cAlias  := 'SB1'
		nOpc    := 2
	ENDCASE

	IF !bTem
		MsgAlert('Tipo de Cadastro nao tem base de conhecimento!')
		Return
	EndIF

	dbSelectArea(cAlias)
	&(cAlias)->(dbGoTo(ZB1->ZB1_RECNO))

	nReg := ZB1->ZB1_RECNO

	MsDocument(cAlias,nReg,4)

	cCadastro := cBkCad

Return
	*************************************************************************************************************************************************
Static Function Cad_Transportadora()

	local aDados  := {}
	local cArea   := SA4->(GetArea())
	local bAltera := .F.
	local nOpc    := 3
	local nI      := 0
	local aErro   := {}
	local cErro   := ''

	Private lMsHelpAuto     := .T.
	Private lMsErroAuto     := .F.
	Private lAutoErrNoFile  := .T.

	IF SA2->A2_ZTRANSP <> '1' // Somente do Tipo Transportadora
		Return
	EndIF
	SA4->(dbSetOrder(3)) //CGC
	bAltera := SA4->(dbSeek(xFilial('SA4')+SA2->A2_CGC))

	aAdd(aDados, {"A4_FILIAL", xFilial("SA4")		, Nil})
	IF bAltera
		aAdd(aDados, {"A4_COD"   ,SA4->A4_COD , Nil})
		nOpc    := 4

	EndIF
	aAdd(aDados, {"A4_CGC"      , SA2->A2_CGC   , Nil})
	aAdd(aDados, {"A4_NOME"     , SA2->A2_NOME   , Nil})
	aAdd(aDados, {"A4_NREDUZ"   , SA2->A2_NREDUZ , Nil})
	aAdd(aDados, {"A4_BAIRRO"   , SA2->A2_BAIRRO , Nil})
	aAdd(aDados, {"A4_END"      , SA2->A2_END    , Nil})
	aAdd(aDados, {"A4_EST"      , SA2->A2_EST    , Nil})
	aAdd(aDados, {"A4_COD_MUN"  , SA2->A2_COD_MUN , Nil})
	aAdd(aDados, {"A4_CEP"      , SA2->A2_CEP    , Nil})
	aAdd(aDados, {"A4_DDD"      , SA2->A2_DDD    , Nil})
	aAdd(aDados, {"A4_DDI"      , SA2->A2_DDI    , Nil})
	aAdd(aDados, {"A4_TEL"      , SA2->A2_TEL    , Nil})
	aAdd(aDados, {"A4_INSEST"   , SA2->A2_INSCR  , Nil})
	aAdd(aDados, {"A4_ZPAIS"    , SA2->A2_ZPAIS   , Nil})
	aAdd(aDados, {"A4_EMAIL"    , SA2->A2_EMAIL  , Nil})
	aAdd(aDados, {"A4_COMPLEM"  , IIF(Empty(SA2->A2_COMPLEM),SA2->A2_ENDCOMP,SA2->A2_COMPLEM), Nil})
	aAdd(aDados, {"A4_ZPESSOA"  , SA2->A2_TIPO   , Nil})
	aAdd(aDados, {"A4_ZNASCIO"  , SA2->A2_ZNASCIO, Nil})
	aAdd(aDados, {"A4_CODPAIS"  , SA2->A2_CODPAIS, Nil})
	aAdd(aDados, {"A4_TPTRANS"  , '1', Nil})
	SA4->(dbSetOrder(1))
	MSExecAuto({|x,y|mata050(x,y)},aDados,nOpc)
	If lMsErroAuto
		aErro := GetAutoGRLog()
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		MsgStop("Erro na gravacao da transportadora: " +cErro)
	EndIf

	RestArea(cArea)

Return
	***********************************************************************************************************************************************************
User Function INT37_VIS

//local aCoors  := 	FWGetDialogSize( oMainWnd )
//DEFINE MSDIALOG oDlg TITLE 'Consulta Alteracoes' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL
	local oDlg1
	local oButton
	local oBold
	local cRegistro  := ''
	local cDados     := ''
	local cCadZB1    := ''
	local cTab       := ''
	local bAba       := .F.

	Private oListDados
	Private oListZB3
	Private aAprova  := {}
	Private aZB3     := {}


	DEFINE FONT oBold NAME "Arial" SIZE 0, -16 BOLD

	DO CASE
	CASE ZB1->ZB1_CAD == '1'
		cCadZB1    :=  "Cadastro de Cliente"
		cTab       := 'SA1'
		dbSelectArea('SA1')
		SA1->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA1->A1_COD
		cDados     := SA1->A1_NOME
		bAba       := .T.
	CASE ZB1->ZB1_CAD == '2'
		cCadZB1    :=  "Cadastro de Endereco de Entrega"
		cTab       := 'SZ9'
		dbSelectArea('SZ9')
		SZ9->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SZ9->Z9_ZCLIENT
		cDados     := SZ9->Z9_ZRAZEND
	CASE ZB1->ZB1_CAD == '3'
		cCadZB1    :=  "Cadastro de Fornecedores"
		cTab       := 'SA2'
		dbSelectArea('SA2')
		SA2->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA2->A2_COD+'-'+SA2->A2_LOJA
		cDados     := SA2->A2_NOME
		bAba       := .T.
	CASE ZB1->ZB1_CAD == '4'
		cCadZB1    :=  "Cadastro de Transportadoras"
		cTab       := 'SA4'
		dbSelectArea('SA4')
		SA4->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA4->A4_COD
		cDados     := SA4->A4_NOME
	CASE ZB1->ZB1_CAD == '5'
		cCadZB1    :=  "Cadastro de Vendedores"
		cTab       := 'SA3'
		dbSelectArea('SA3')
		SA3->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SA3->A3_COD
		cDados     := SA3->A3_NOME
	CASE ZB1->ZB1_CAD == '6'
		cCadZB1    :=  "Cadastro de Veiculos"
		cTab       := 'DA3'
		dbSelectArea('DA3')
		DA3->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := DA3->DA3_COD
		cDados     := DA3->DA3_DESC
	CASE ZB1->ZB1_CAD == '7'
		cCadZB1    :=  "Cadastro de Motorista"
		cTab       := 'DA4'
		dbSelectArea('DA4')
		DA4->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := DA4->DA4_COD
		cDados     := DA4->DA4_NOME
	CASE ZB1->ZB1_CAD == '8'
		cCadZB1    :=  "Cadastro de Produtos"
		cTab       := 'SB1'
		dbSelectArea('SB1')
		SB1->(dbGoTo(ZB1->ZB1_RECNO))
		cRegistro  := SB1->B1_COD
		cDados     := SB1->B1_DESC
		bAba       := .T.
	ENDCASE
	DbSelectArea('ZB2')
	ZB2->(dbSetOrder(1))
	ZB2->(dbSeek(ZB1->ZB1_ID))
	While ZB2->(!Eof()) .And. ZB1->ZB1_ID == ZB2->ZB2_ID

		IF ZB2->ZB2_STATUS=="1"
			cCor := LoadBitmap( GetResources(), "BR_VERDE")
		ELSEIF ZB2->ZB2_STATUS=="2"
			cCor := LoadBitmap( GetResources(), "BR_VERMELHO")
		Else
			cCor := LoadBitmap( GetResources(), "BR_AMARELO" )
		EndIF
		AAdd(aAprova,{ cCor,;
			ZB2->ZB2_SEQ ,;
			GetAdvFVal( "ZB6", "ZB6_NOME", ZB2->ZB2_IDSET,1,""),;
			USRRETNAME(ZB2->ZB2_IDAPR),;
			ZB2->ZB2_DATA ,;
			ZB2->ZB2_HORA ,;
			ZB2->ZB2_OBS, ZB2->(Recno())})
		ZB2->(dbSkip())
	End

	cCadZB1 += IIF(ZB1->ZB1_TIPO =='1', ' - Inclusao',' - Alteracao')
	Carrega_dados(aAprova[01,08])

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Campos Alterados" FROM 000, 000  TO 570, 810 COLORS 0, 16777215 PIXEL

	@ 005,005 SAY cCadZB1   SIZE 220, 020 OF oDLG1 PIXEL FONT oBold COLOR CLR_BLUE
	@ 017,005 TO 018,400  OF oDLG1 PIXEL

	@ 026,009  SAY "Registro"         SIZE 140, 009 OF oDLG1 COLORS 0, 16777215 PIXEL
	@ 022,044  MSGET  cRegistro       SIZE 042, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right
	@ 022,089  MSGET  cDados          SIZE 179, 010 OF oDLG1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right

	oListDados := TWBrowse():New( 040,009,391,070,,{'','Seq.','Setor','Aprovador','Data','Hora','Obs'},{20,30,60,60,35,35,80},oDlg1, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oListDados:SetArray(aAprova)
	cbLine := "{||{ aAprova[oListDados:nAt,01], aAprova[oListDados:nAt,02], aAprova[oListDados:nAt,03],"+;
		" aAprova[oListDados:nAt,04], aAprova[oListDados:nAt,05], aAprova[oListDados:nAt,06], aAprova[oListDados:nAt,07]} }"
	oListDados:bLine       := &cbLine
	oListDados:bChange     := {||AtualizaBrowse()}


	oListZB3 := TWBrowse():New( 120,009,391,150,,{'Campo','Descricao','Conteudo Anterior','Conteudo Atual'},{30,40,120,90},oDlg1, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oListZB3:SetArray(aZB3)
	cbLine := "{||{ aZB3[oListZB3:nAt,01], aZB3[oListZB3:nAt,02], aZB3[oListZB3:nAt,03], aZB3[oListZB3:nAt,04]} }"
	oListZB3:bLine       := &cbLine

	oButton := TButton():New( 002,335,"Sair",oDlg1,{||oDlg1:End()},065,012,,,,.T.,,"",,,,.F. )


	ACTIVATE MSDIALOG oDlg1 CENTERED

Return
	**********************************************************************************************************************
Static Function Carrega_Dados(nRecno)
	local bCad := .F.

	ZB2->(dbGoTo(nRecno))

	aZB3 := {}
	DbSelectArea('ZB3')
	ZB3->(dbSetOrder(1))
	ZB3->(dbSeek(ZB1->ZB1_ID))
	While ZB3->(!Eof()) .And. ZB1->ZB1_ID == ZB3->ZB3_ID
		bCad := .F.
		IF ZB1->ZB1_TIPO == '1'
			IF ZB2->ZB2_SEQ == ZB3->ZB3_SEQ
				bCad := .T.
			EndIF
		Else
			IF ZB1->ZB1_CAD $ '#1#3#8#'
				IF ZB2->ZB2_IDABA $ ZB3->ZB3_ABA
					bCad := .T.
				EndIF
			Else
				bCad := .T.
			EndIF
		EndIF
		IF bCad
			AAdd(aZB3,{ZB3->ZB3_CAMPO,ZB3->ZB3_DESC,Alltrim(ZB3->ZB3_OLD),Alltrim(ZB3->ZB3_NEW)})
		EndIF
		ZB3->(dbSkip())
	End
	IF Len(aZB3) == 0
		aZB3 := {{'','','',''}}
	EndIF
Return
	**************************************************************************************************************************************
Static Function AtualizaBrowse

	Carrega_Dados(aAprova[oListDados:nAt,08])

	oListZB3:SetArray(aZB3)
	cbLine := "{||{ aZB3[oListZB3:nAt,01], aZB3[oListZB3:nAt,02], aZB3[oListZB3:nAt,03], aZB3[oListZB3:nAt,04]} }"
	oListZB3:bLine       := &cbLine
	oListZB3:DrawSelect()
	oListZB3:Refresh()

Return