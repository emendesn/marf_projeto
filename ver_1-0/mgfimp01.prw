#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "MSGRAPHI.CH"

/*
=====================================================================================
Programa.:              MGFIMP01
Autor....:              Tiago Barbieri
Data.....:              05/09/2016
Descricao / Objetivo:   Importa��o de cadastros
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Tela de Importa��o de cadastros
Obs......:              Requer biblioteca MGFZFUNA.PRW
=====================================================================================
*/

User Function MGFIMP01()    // U_MGFIMP01()

	Local oRadMenu1
	Local oSay
	Local aOpcoes := {}
	Static oDlg3

	Private nRadMenu1 := 1

	//Private cLogDir	:= GetMv("MGF_IMP01A",,"\MGF\IMP\") // Parametro foi utilizado em outro GAP
	Private cLogDir	:= GetMv("MGF_IMPLOG",,"\MGF\IMP\") // Pasta de grava��o de logs - servidor
	Private nThrTrn	:= GetMv("MGF_IMP01B",,40)			// N�mero de Transa��es x Thread
	Private nThrMax	:= GetMv("MGF_IMP01C",,20)			// N�mero M�ximo de Threads
	Private cTMCus	:= GetMv("MGF_IMP01D",,"497")		// TM devolu��o - Custo informado
	Private cTMCus0	:= GetMv("MGF_IMP01E",,"498")		// TM devolu��o - Custo zero
	//Private lGrid	:= GetMv("MGF_IMP01F",,.T.)			// Uso de grid de Processamento
	Private nThrSlv	:= GetMv("MGF_IMP01G",,10)			// N�mero de Slaves dispon�veis para processar Threads


	aadd(aOpcoes,"Cadastros de Produtos SB1")                              //01 SB1
	aadd(aOpcoes,"Estrutura de Produtos SG1")                              //02 SG1
	aadd(aOpcoes,"Clientes SA1")                                           //03 SA1
	aadd(aOpcoes,"Fornecedores SA2")                                       //04 SA2
	aadd(aOpcoes,"Representantes/Vendedores SA3")                          //05 SA3
	aadd(aOpcoes,"Ve�culos DA3")                                           //06 DA3
	aadd(aOpcoes,"Transportadoras SA4")                                    //07 SA4
	aadd(aOpcoes,"Cadastro de Bens 'Ativo Fixo' - 2 arquivos SN1/SN3")     //08 SN1/SN3
	aadd(aOpcoes,"Saldos de Estoque SD3")                                  //09 SD3
	aadd(aOpcoes,"Pedidos de Compra em Aberto SC7")                        //10 SC7
	aadd(aOpcoes,"Pedidos de Venda em Aberto - 2 arquivos SC5/SC6")        //11 SC5/SC6
	aadd(aOpcoes,"Movimento Financeiro Contas a Pagar em Aberto SE2")      //12 SE2
	aadd(aOpcoes,"Movimento Financeiro Contas a Receber em Aberto SE1")    //13 SE1
	aadd(aOpcoes,"Ordens de Compra SC1")     							   //14 SC1
	aadd(aOpcoes,"Endere�o de Entrega SZ9")     						   //15 SZ9
	aadd(aOpcoes,"Motoristas DA4")     							   		   //16 DA4
	aadd(aOpcoes,"Contrato de Parceria SC3")     						   //17 SC3


	DEFINE MSDIALOG oDlg3 TITLE "Importa��o de Cadastros MARFRIG" FROM 000, 000  TO 380, 400 COLORS 0, 16777215 PIXEL
	oRadMenu1:= tRadMenu():New(20,06,aOpcoes,{|u|if(PCount()>0,nRadMenu1:=u,nRadMenu1)}, oDlg3,,,,,,,,159,130,,,,.T.)
	@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
	@ 170,  90 BUTTON "Importar" SIZE 050, 012 PIXEL OF oDlg3 Action(processa ({|| ImpCadMGF()},"Importa��o de Cadastros B�sicos"))
	@ 170, 150 BUTTON "Cancelar" SIZE 050, 012 PIXEL OF oDlg3 Action(oDlg3:End())

	ACTIVATE MSDIALOG oDlg3 CENTERED

Return

/*
========================================================
Fun��o de Importa��o de arquivo CSV com separador ";"
========================================================
*/
Static Function ImpCadMGF

	Local cArq	    := ""
	Local cArqd	    := ""

	Local aMonThread	:= {}
	Local aParEnv	:= { "01" , "010001" }

	Local cLogFile   := ""
	Local cTime      := ""
	Local aLog       := {}
	Local cLogWrite  := ""

	Local nHandle
	Local cLinha     := ''
	Local cLinhad    := ''
	Local lPrim      := .T.
	Local lPrimd     := .T.
	Local lPrimThr	 := .T.
	Local aCampos    := {}
	Local aCamposd   := {}
	Local aStru      := {}
	Local aDados     := {}
	Local aDadosd    := {}
	Local cBKFilial  := cFilAnt
	Local nCampos    := 0
	Local nCamposd   := 0
	Local cSQL       := ''
	Local cSQLd      := ''
	Local aExecAuto  := {}
	Local aExecAutod := {}
	Local aExecAutol := {}
	Local aThrCab	:= {}
	Local aThrDet	:= {}
	Local aThrLin	:= {}
	Local aThrFil	:= {}
	Local aTipoImp   := {}
	Local aTipoImpd  := {}
	Local nTipoImp   := 0
	Local nTipoImpd  := 0
	Local cTipo      := ''
	Local cTipod     := ''
	Local cTab       := ''
	Local cTabd      := ''
	Local nI
	Local nId
	Local nX
	Local cNiv
	Local cCod
	Local cBemN1
	Local cBemN3
	Local cItemN1
	Local cItemN3
	Local cChave
	Local nLinha	:= 0

	Local oGrid, cGridFunSt, cGridFunEx
	Local aGridParSt	:= {"01","010001"}
	Local nGrid	:= 0

	Private lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .F.
	Private lAutoErrNoFile := .T.
	Private aTabExclui     := 	{	{'B1',{"SB1"} },;										//01 SB1
	{'G1',{"SG1"} },;										//02 SG1
	{'A1',{"SA1"} },;										//03 SA1
	{'A2',{"SA2"} },;										//04 SA2
	{'A3',{"SA3"} },;										//05 SA3
	{'DA3',{"DA3"} },;										//06 DA3
	{'A4',{"SA4"} },;										//07 SA4
	{'N1',{"SN1","SN2","SN3","SN4","SN5","SN6","SNC"} },;	//08 SN1/SN3
	{'D3',{"SB2","SB8","SBF","SD3","SD5","SDA","SDB"} },;	//09 SD3
	{'C7',{"SC7","SCR"} },;									//10 SC7
	{'C5',{"SC5","SC6"} },;									//11 SC5/SC6
	{'E2',{"SE2","SCR"} },;									//12 SE2
	{'E1',{"SE1"} },;										//13 SE1
	{'C1',{"SC1","SCR"} },;									//14 SC1
	{'Z9',{"SZ9"} } ,;										//15 SZ9
	{'DA4',{"DA4"} } ,;										//16 DA4
	{'C3',{"SC3"} } }										//17 SC3

	Private lGrid	:= GetMv("MGF_IMP01F",,.T.) .And. nRadMenu1 <> 8			// Uso de grid de Processamento

	nThrMax			:= IIF(nRadMenu1 == 8,1,nThrMax)
	
	If !FWMakeDir( cLogDir , .T. ) //!U_zMakeDir( cLogDir , "Pasta Servidor" )

		Return

	EndIf

	cLogProc	:= cLogDir+"PROC_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG"
	//cLogProc	:= "PROC_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".XML"
	dDataIni	:= dDataAux	:= dDataFim	:= Date()
	cHoraIni	:= cHoraAux := cHoraFim := Time()

	cTxtProc	:= Replicate("-",80)+CRLF
	aTxtproc	:= {}
	//  --------------------------------------------------------------------------------
	//##### MGFIMP01 - Importacao N1 - 04/04/2017 - 12:12:12 #####
	cTxtProc 	+= "##### [MGFIMP01] Importac�o "+aTabExclui[nRadMenu1][1] +" - " + DtoC( dDataIni ) + "  - " + cHoraIni + " #####"+CRLF+CRLF
	nTxtProc	:= 0

	If lGrid

		oGrid := GridClient():New()

		// Defines name of preparation functions of environment and execution
		aGridParSt	:= {"01","010001",nRadmenu1}
		cGridFunSt  := 'U_ZGRIDS'
		cGridFunEx  := 'U_ZGRIDE'
		lGrid := oGrid:Prepare(cGridFunSt,aGridParSt,cGridFunEx)

		dDataFim	:= Date()
		cHoraFim	:= Time()

		cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Prepara��o do Grid - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
		aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Prepara��o do Grid" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

		dDataAux	:= Date()
		cHoraAux	:= Time()


		If !lGrid
			If !MsgYesNo("Erro na prepara��o do grid:"+CRLF+oGrid:GetError()+CRLF+CRLF+"Deseja continuar a importa��o usando multi-trheads?","Grid Prepare()")

				oGrid:Terminate()

				oGrid := NIL
				Return
			EndIf
		EndIf

	EndIf

	If .F. //!lGrid

		oGrid := FWIPCWait():New('U_XEXEC' , 10000)
		oGrid:SetThreads( nThrMax * nThrSlv )
		oGrid:SetEnvironment(cEmpAnt, cFilAnt)
		oGrid:Start('U_XEXEC') 	
		Sleep( 600 )

		dDataFim	:= Date()
		cHoraFim	:= Time()


		cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Prepara��o de Threads - In�cio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
		aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Prepara��o de Threads" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

		dDataAux	:= Date()
		cHoraAux	:= Time()


	EndIf

	//Return

	/*
	If nRadMenu1 <> 8 .And. nRadMenu1 <> 14

	MsgAlert("Importa��o de Cadastros - Op��o desabilitada!","ATEN��O")

	Return

	EndIf
	*/

	/*
	========================================================
	Importa��o de Dados
	========================================================
	*/


	// renomear arquivos LOG de importa��es anteriores
	aArqLog := Directory(cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-*.LOG")
	cPatLoc	:= ""
	If !Empty(aArqLog)
		For nX := 1 to Len(aArqLog)
			fRename(cLogDir+aArqLog[nX,1],cLogDir+Subs(aArqLog[nX,1],1,At(".LOG",Upper(aArqLog[nX,1])))+"BKP")
		Next nX
	EndIf

	dDataFim	:= Date()
	cHoraFim	:= Time()

	cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Backup arquivos Log - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
	aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Backup arquivos Log" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

	dDataAux	:= Date()
	cHoraAux	:= Time()

	//Arquivo Cabe�alho
	If nRadMenu1 == 8 .Or. nRadMenu1 == 11
		MsgAlert("Essa op��o precisa de 2 arquivos, o primeiro � o arquivo de CABE�ALHO!","ATEN��O")
	EndIf

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret�rio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " n�o foi selecionado. A Importa��o ser� abortada!","ATEN��O")
		Return
	Else
		cPatLoc := Subs(cArq,1, Rat("\",cArq) )
	EndIf


	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha    := FT_FREADLN()
	aTipoImp  := Separa(cLinha,";",.T.)
	cTipo     := SUBSTR(aTipoImp[1],1,2)
	If cTiPO $ "DA/" //Veiculos
		cTipo     := SUBSTR(aTipoImp[1],1,3)
	EndIf
	FT_FUSE()

	IF !(cTIPO $(aTabExclui[nRadMenu1][1]/*'N1'*/))
		MsgAlert('N�o � poss�vel importar a tabela: '+cTipo+ '  !!')
		Return
	EndIf

	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .AND.;
		!("CNUMCON" $ aTipoImp[nI] .OR. "CBANCOADT" $ aTipoImp[nI] .OR. "CAGENCIAADT" $ aTipoImp[nI] )//.OR. "AUTO" $ aTipoImp[nI])  
			MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
			Return
		ENDIF
		IF !SX3->(dbSeek(Alltrim(aTipoImp[nI]))) .AND. ;
		!("CNUMCON" $ aTipoImp[nI] .OR. "CBANCOADT" $ aTipoImp[nI] .OR. "CAGENCIAADT" $ aTipoImp[nI] )//.OR. "AUTO" $ aTipoImp[nI])  
			MsgAlert('Campo n�o encontrado na tabela :'+aTipoImp[nI]+' !!')
			Return
			//ELSEIF ( /*S/->X3_VISUAL $ ('V') .OR.*/ SX3->X3_CONTEXT == "V" ) .And. !AllTrim( SX3->X3_CAMPO )+"/" $ "C1_ITEM/C6_FILIAL/C6_ITEM/A1_COD/A1_LOJA/C7_ITEM/C7_UM/C7_OPER/A2_COD/A2_LOJA/"
		ELSEIF ( SX3->X3_CONTEXT == "V" ) .And. !(AllTrim( SX3->X3_CAMPO ) $ "C1_ITEM|C6_FILIAL|C6_ITEM|A1_COD|A1_LOJA|C7_ITEM|C7_UM|C7_OPER|A2_COD|A2_LOJA")
			MsgAlert('Campo marcado na tabela como visual (X3_CONTEXT) :'+aTipoImp[nI]+' !!')
			Return
		ElseIf cTipo $ 'C1/C7/G1/C3/'
			aAdd( aStru , { aTipoImp[nI] , SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL } )
		ENDIF
	Next nI

	nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

	cTab := ''
	For nI := 1 To Len(aTabExclui[nTipoImp,2])
		cTab += aTabExclui[nTipoImp,2,nI]+' '
	Next nI

	//Arquivo Itens
	If nRadMenu1 == 8 .Or. nRadMenu1 == 11
		MsgAlert("Agora � o arquivo de DETALHE!","ATEN��O")
		cArqd := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret�rio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

		If !File(cArqd)
			MsgStop("O arquivo " +cArqd + " n�o foi selecionado. A Importa��o ser� abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArqd)
		FT_FGOTOP()
		cLinhad    := FT_FREADLN()
		aTipoImpd  := Separa(cLinhad,";",.T.)
		cTipod     := SUBSTR(aTipoImpd[1],1,2)

		IF !(cTIPOd $('N3/C6/'))
			MsgAlert('N�o � possivel importar a tabela: '+cTipod+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nId := 1 To Len(aTipoImpd)
			IF cTipod <> SUBSTR(aTipoImpd[nId],1,2) .AND. ;
			!("CNUMCON" $ aTipoImpd[nId] .OR. "CBANCOADT" $ aTipoImpd[nId] .OR. "CAGENCIAADT" $ aTipoImpd[nId] )//.OR. "AUTO" $ aTipoImpd[nId])  
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImpd[nId]))) .AND. ;
			!("CNUMCON" $ aTipoImpd[nId] .OR. "CBANCOADT" $ aTipoImpd[nId] .OR. "CAGENCIAADT" $ aTipoImpd[nId] )//.OR. "AUTO" $ aTipoImpd[nId])  
				MsgAlert('Campo n�o encontrado na tabela :'+aTipoImpd[nId]+' !!')
				Return
			ELSEIF ( SX3->X3_VISUAL $ ('V') .OR. SX3->X3_CONTEXT == "V" ) .And. !AllTrim( SX3->X3_CAMPO )+"/" $ "C1_ITEM/C6_FILIAL/C6_ITEM/C6_UM/C6_OPER/A1_COD/A1_LOJA/C7_ITEM/C7_UM/"
				MsgAlert('Campo marcado na tabela como visual : (X3_CONTEXT) '+aTipoImpd[nId]+' !!')
				Return
			Else
				aAdd( aStru , { aTipoImpd[nId] , SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL } )
			ENDIF
		Next nId

	EndIf

	dDataFim	:= Date()
	cHoraFim	:= Time()

	cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Verifica��o de Arquivo(s) - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
	aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Verifica��o de Arquivo(s)" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )


	dDataAux	:= Date()
	cHoraAux	:= Time()
	/*
	If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da Importa��o ? ")
	For nI := 1 To Len(aTabExclui[nTipoImp,2])
	cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
	If aTabExclui[nTipoImp,2,nI] == "SCR"
	cSQL += " where CR_TIPO = "
	If aTabExclui[nTipoImp,2,1] == "SC1"
	cSQL += "'SC'"
	ElseIf aTabExclui[nTipoImp,2,1] == "SC7"
	cSQL += "'PC'"
	ElseIf aTabExclui[nTipoImp,2,1] == "SE2"
	cSQL += "'ZC'"
	EndIf
	EndIf
	If (TCSQLExec(cSQL) < 0)
	Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf
	cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
	If (TCSQLExec(cSQL) < 0)
	Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf
	Next nI
	EndIf
	*/
	dDataFim	:= Date()
	cHoraFim	:= Time()

	cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Limpeza Tabelas - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
	aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Limpeza Tabelas" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

	dDataAux	:= Date()
	cHoraAux	:= Time()

	// Detalhe - Montagem de Arquivo de Trabalho
	If nRadMenu1 == 8 .Or. nRadMenu1 == 11 .Or. nRadMenu1 == 14 .Or. nRadMenu1 == 10  .Or. nRadMenu1 == 2 .or. nRadMenu1 == 17

		cArqTRB := Criatrab(aStru,.T.)

		If Select("TRB1") > 0
			dbSelectArea("TRB1")
			dbCloseArea()
		EndIf

		dbUseArea( .T., __LocalDriver, cArqTrb , "TRB1", .F., .F. )

		If nRadMenu1 == 8
			cIndTrb	:= IIF( TRB1->( FieldPos( "N3_FILIAL" ) ) > 0,"N3_FILIAL+","")+"N3_CBASE+N3_ITEM+N3_TIPO"
		ElseIf nRadMenu1 == 14
			cIndTrb	:= IIF( TRB1->( FieldPos( "C1_FILIAL" ) ) > 0,"C1_FILIAL+","")+"C1_NUM+C1_ITEM"
		ElseIf nRadMenu1 == 11
			cIndTrb	:= IIF( TRB1->( FieldPos( "C6_FILIAL" ) ) > 0,"C6_FILIAL+","")+"C6_NUM+C6_ITEM"
		ElseIf nRadMenu1 == 10
			cIndTrb	:= IIF( TRB1->( FieldPos( "C7_FILIAL" ) ) > 0,"C7_FILIAL+","")+"C7_NUM+C7_ITEM"
		ElseIf nRadMenu1 == 2
			cIndTrb	:= IIF( TRB1->( FieldPos( "G1_FILIAL" ) ) > 0,"G1_FILIAL+","")+"G1_COD+G1_COMP"
		ElseIf nRadMenu1 == 17
			cIndTrb	:= IIF( TRB1->( FieldPos( "C3_FILIAL" ) ) > 0,"C3_FILIAL+","")+"C3_NUM"
		EndIf


		IndRegua( "TRB1", cArqTrb , cIndTrb , , , "Criando �ndice ...")

		If nRadMenu1 == 14 .Or. nRadMenu1 == 10 .Or. nRadMenu1 == 2 .or. nRadMenu1 == 17
			cArqd	:= cArq
		EndIf

		FT_FUSE(  cArqd )
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Montando arquivo de trabalho...")
			cLinhad := FT_FREADLN()
			If lPrimd
				aCamposd := Separa(cLinhad,";",.T.)
				lPrimd := .F.
			Else

				aDadosd	:= Separa(cLinhad,";",.T.)
				RecLock("TRB1",.T.)
				For nCamposd := 1 to Len( aDadosd )

					If  TamSx3(Upper(aCamposd[nCamposd]))[3] =='N'
						xValor	:= Val( StrTran(aDadosd[nCamposd],",",".") )
					ElseIf TamSx3(Upper(aCamposd[nCamposd]))[3] =='D'
						xValor	:= CTOD(aDadosd[nCamposd] )
					Else
						xValor	:= StrTran(aDadosd[nCamposd],'"')
					EndIf

					TRB1->( FieldPut( nCamposd , xValor ) )

				Next nCamposd
				TRB1->( msUnlock() )
			EndIf

			FT_FSKIP()

		EndDo
		FT_FUSE()

		dDataFim	:= Date()
		cHoraFim	:= Time()

		cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Arquivo de Trabalho - In�cio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + " #####)"+CRLF
		aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Arquivo de Trabalho" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

		dDataAux	:= Date()
		cHoraAux	:= Time()

	EndIf

	aThrDat	:= {}
	nI		:= 0

	If nRadMenu1 == 14 // SC1 - Solicta��es de Compra
		cCpoCab  := "C1_FILIAL/C1_NUM/C1_SOLICIT/C1_EMISSAO/C1_UNIDREQ/C1_CODCOMP/C1_FILENT/"
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "C1_NUM"})
	ElseIf nRadMenu1 == 10 // SC7 - Pedidos de Compra
		cCpoCab  := "C7_FILIAL/C7_NUM/C7_EMISSAO/C7_FORNECE/C7_LOJA/C7_COND/C7_CONTATO/C7_FILENT/C7_MOEDA/C7_TXMOEDA/"
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "C7_NUM"})
	ElseIf nRadMenu1 == 2 // SG1 - Estrutura
		cCpoCab  := "G1_FILIAL/G1_COD/"
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "G1_COD"})
	ElseIf nRadMenu1 == 17 // SC3- Contrato de Parceria
		cCpoCab  := "C3_FILIAL/C3_NUM/C3_EMISSAO/C3_FORNECE/C3_LOJA/C3_COND/C3_CONTATO/C3_FILENT/C3_MOEDA/"
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "C3_NUM"})
	ElseIf nRadMenu1 == 12 // SE2- Contas a Pagar
		cCpoCab  := ""
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "E2_FORNECE"})
		nPosLoj	:= aScan(aTipoImp,{|x| alltrim(x) == "E2_LOJA"})
	ElseIf nRadMenu1 == 8 // SN1- Ativo FIxo
		cCpoCab  := ""
		nPosCod	:= aScan(aTipoImp,{|x| alltrim(x) == "N1_CBASE"}) 
		nPosGrp	:= aScan(aTipoImp,{|x| alltrim(x) == "N1_GRUPO"}) // "N1_CBASE"})
	Else
		cCpoCab	:= ""
		nPosCod	:= 0
	EndIf

	cCpoCod	:= ""
	nI		:= 0

	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	cLinha := FT_FREADLN()
	aCampos := Separa(cLinha,";",.T.)
	FT_FSKIP()
	lPrim := .F.
	cLinha := ""

	While !FT_FEOF()

		IncProc("Importando registros...")

		nI++

		If Empty( cLinha )
			cLinha := FT_FREADLN()
		EndIf

		//If lPrim
		//	aCampos := Separa(cLinha,";",.T.)
		//	lPrim := .F.

		//	If nRadMenu1 <> 12
		//		FT_FSKIP()
		//	EndIf

		//ElseIf !Empty(cLinha)

		aDados	:= Separa(cLinha,";",.T.)
		cLinha := ""

		aExecAuto	:= {}
		aExecAutod	:= {}
		aExecAutol	:= {}
		aFilAnt		:= {}
		cFilAnt		:= cBKFilial

		If nPosCod > 0
			cCod	:= aDados[nPosCod]
			If nRadMenu1 == 12  
				cLoj	:= aDados[nPosLoj]
			ElseIf nRadMenu1 == 8 // SN1- Ativo FIxo
				cGrupo	:= aDados[nPosGrp]
			EndIf
		Else
			cCod	:= ""
		EndIf

		If Empty( cCpoCab ) .Or. cCpoCod <> cCod

			cCpoCod := cCod

			nLinha	:= nI

			For nCampos := 1 To Len(aCampos)
				If IIF(Empty(cCpoCab),.T.,AllTrim(Upper(aCampos[nCampos]))+"/"$cCpoCab)
					IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
						IF !Empty(aDados[nCampos])
							cFilAnt := aDados[nCampos]
						ENDIF
					Else
						If ("CNUMCON" $ aCampos[nCampos] .OR. "CBANCOADT" $ aCampos[nCampos] .OR. "CAGENCIAADT" $ aCampos[nCampos] ) //.OR. "AUTO" $ aCampos[nCampos])
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nCampos]	,Nil})
						ElseIF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aDados[nCampos]	:= StrTran( aDados[nCampos] , "," , "." )
							If  AllTrim(Upper(aCampos[nCampos]))== 'D3_CUSTO1'
								If !Empty(VAL(aDados[nCampos] )) // Custo > 0
									aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nCampos] )	,Nil})
									aAdd(aExecAuto ,{ "D3_TM" , cTMCus , Nil} )
								Else
									aAdd(aExecAuto ,{ "D3_TM" , cTMCus0 , Nil} )
								EndIf
							ElseIf !Empty(VAL(aDados[nCampos] ))
								aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nCampos] )	,Nil})
							EndIf


						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							If !Empty( CTOD(aDados[nCampos] ) )
								aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nCampos] )	,Nil})
							EndIf
						ElSeIf !Empty( aDados[nCampos] )

							If Upper(aCampos[nCampos]) $ "A3_COD/B1_COD/D3_COD/D3_LOCALIZ/D3_LOTECTL/N1_CBASE/N1_ITEM/C1_NUM/C5_NUM/C7_NUM/A1_COD/G1_COD/C3_NUM/DA4_COD/Z9_ZCLIENT"
								xValor	:= Stuff( Space( TamSX3(Upper(aCampos[nCampos]))[1] ) , 1 , Len(aDados[nCampos]) , aDados[nCampos] )
								aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	xValor	,Nil})
								If Upper(aCampos[nCampos]) $ "N1_CBASE/C1_NUM/C5_NUM/C7_NUM/A1_COD/G1_COD/C3_NUM"
									cBemN1  := xValor
								ElseIf Upper(aCampos[nCampos]) $ "N1_ITEM/"
									cItemN1 := xValor
								EndIf
							Else
								aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nCampos] 	,Nil})
							EndIf

						ENDIF
					ENDIF
				EndIf
			Next nCampos

			If nRadMenu1 == 2
				aAdd(aExecAuto ,{"G1_QUANT",1,NIL})
				aAdd(aExecAuto ,{"NIVALT","S",NIL})
			EndIf

			lCodBase	:= .T.

			If nRadMenu1 == 8 .Or. nRadMenu1 == 11 .Or. nRadMenu1 == 14 .Or. nRadMenu1 == 10  .Or. nRadMenu1 == 2 .Or. nRadMenu1 == 17

				If nRadMenu1 == 8
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "N3_FILIAL" ) ) > 0,"N3_FILIAL+","")+"N3_CBASE+N3_ITEM)"
					cFilChv	:= IIF( TRB1->( FieldPos( "N3_FILIAL" ) ) > 0,cFilAnt,"") + cBemN1 + cItemN1
				ElseIf nRadMenu1 == 14
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "C1_FILIAL" ) ) > 0,"C1_FILIAL+","")+"C1_NUM)"
					cFilChv	:= IIF( TRB1->( FieldPos( "C1_FILIAL" ) ) > 0,cFilAnt,"") + cBemN1
				ElseIf nRadMenu1 == 11
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "C6_FILIAL" ) ) > 0,"C6_FILIAL+","")+"C6_NUM)"
					cFilChv	:= IIF( TRB1->( FieldPos( "C6_FILIAL" ) ) > 0,cFilAnt,"") + cBemN1
				ElseIf nRadMenu1 == 10
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "C7_FILIAL" ) ) > 0,"C7_FILIAL+","")+"C7_NUM)"
					cFilChv	:= IIF( TRB1->( FieldPos( "C7_FILIAL" ) ) > 0,cFilAnt,"") + cBemN1
				ElseIf nRadMenu1 == 2
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "G1_FILIAL" ) ) > 0,"G1_FILIAL+","")+"G1_COD)"
					cFilChv	:= IIF( TRB1->( FieldPos( "G1_FILIAL" ) ) > 0,cFilAnt,"") + cBemN1
				ElseIf nRadMenu1 == 17
					cChave	:= "TRB1->("+IIF( TRB1->( FieldPos( "C3_FILIAL" ) ) > 0,"C3_FILIAL+","")+"C3_NUM)"
					cFilChv	:= IIF( TRB1->( FieldPos( "C3_FILIAL" ) ) > 0,xFilial("SC3"),"") + cBemN1
				Else
					cChave	:= ""
					cFilChv	:= ""
				EndIf

				lSeek	:= TRB1->( dbSeek( cFilChv ) )

				While !TRB1->( eof() ) .And. &(cChave) == cFilChv
					For nCamposd := 1 to Len( aCamposd )
						If IIF(Empty(cCpoCab) .Or. nRadMenu1 == 2,.T.,!aCamposd[nCamposd]+"/" $ cCpoCab )
							If !Empty( &("TRB1->"+aCamposd[nCamposd]) )
								aAdd( aExecAutol , { aCamposd[nCamposd] , &("TRB1->"+aCamposd[nCamposd]) , NIL } )
							EndIf
						EndIf
					Next nCamposd
					aAdd( aExecAutod , aExecAutol )
					aExecAutol	:= {}
					TRB1->( dbSkip() )
				EndDo

/*
				If nRadMenu1 == 8

//					If TRB1->N3_CBASE == cBemN1
//
//						lCodBase	:= .F.
//
//					Else


						FT_FSKIP()

						If !FT_FEOF()

							cLinha := FT_FREADLN()

							aDados	:= Separa(cLinha,";",.T.)
							
							If cCod == aDados[nPosCod]
								lCodBase	:= .F.
							EndIf

						EndIf

//					EndIf

				EndIf
*/
			ElseIf nRadMenu1 == 12  

				FT_FSKIP()

				If !FT_FEOF()

					cLinha := FT_FREADLN()

					aDados	:= Separa(cLinha,";",.T.)
					If cCod + cLoj == aDados[nPosCod]+aDados[nPosLoj]
						lCodBase	:= .F.
					EndIf

				EndIf
				//FT_FSKIP(-1)

			EndIf

			aAdd( aThrCab , aExecAuto	)
			aAdd( aThrDet , aExecAutod 	)
			aAdd( aThrLin , nLinha	)
			aAdd( aThrFil , cFilAnt )

		EndIf

		If nRadMenu1 == 8

			FT_FSKIP()

			If !FT_FEOF()

				cLinha := FT_FREADLN()

				aDados	:= Separa(cLinha,";",.T.)
							
				If cCod	== aDados[nPosCod] // .Or. cGrupo	== aDados[nPosGrp]
					lCodBase	:= .F.
				EndIf

			EndIf

		EndIf


		If Len( aThrCab ) >= nThrTrn .And. lCodBase
		
			//ConOut("Len( aThrCab ) " + Str(Len( aThrCab )))

			aAdd( aThrDat , {	aThrCab	,;
			aThrDet	,;
			aThrLin ,;
			cEmpAnt ,;
			aThrFil , cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG" , nRadMenu1 } )

			aThrCab := {}
			aThrDet := {}
			aThrLin	:= {}
			aThrFil	:= {}

			If !lGrid // Threads
				/*
				oGrid:Go(aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase)

				aDel( aThrDat , 1 )

				aSize( aThrDat , Len( aThrDat ) - 1 )

				ElseIf !lGrid // Threads
				*/
				aMonThread := U_zMonThread("U_XEXEC")

				While aMonThread[1] >= nThrMax // .And. Len( aThrDat ) > 0

					Sleep( 1000 )

					aMonThread := U_zMonThread("U_XEXEC")

				EndDo

				ConOut("## MGFIMP01 - Nr de Threads ["+StrZero(aMonThread[1],03,0)+"] - Memoria ["+StrZero(aMonThread[2],12,0)+"] ##")

				StartJob ("U_XEXEC",GEtEnvServer(),.F.,aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase)

				If lPrimThr
					Sleep( 30000 )
					lPrimThr	 := .F.
				EndIf

				aDel( aThrDat , 1 )

				aSize( aThrDat , Len( aThrDat ) - 1 )

				aMonThread := U_zMonThread("U_XEXEC")

				nThrTrn	:= GetMv("MGF_IMP01B",,20)			// N�mero de Transa��es x Thread
				If nRadMenu1 <> 8
					nThrMax	:= GetMv("MGF_IMP01C",,20)			// N�mero de Transa��es x Thread
				EndIf

			Else
				/*
				While oGrid:GetIdleThreads() == 0

				Sleep( 1000 )

				EndDo
				*/
				//ConOut("## MGFIMP01 - Nr de Idle Threads ["+StrZero(oGrid:GetIdleThreads(),05,0)+"] ##")

				lGridOk := .F.
				nGrid++
				//MsgStop("Grid de Processamento - Envio ["+StrZero(nGrid,05,0)+"]" ,"Grid Execution")
				//While !lGridOk
				//MsgStop("Grid de Processamento - Start ["+StrZero(nGrid,05,0)+"]" ,"Grid Execution")

				lGridOk := oGrid:Execute({aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase,lGrid})
				//EndDo
				If !lGridOk
					cGridMsg := "[GRID] Erro oGrid:Execute()"+CRLF
					// An error occurred, either in processing, or in
					// Grid termination. Check the property arrays
					If !empty(oGrid:aErrorProc)
						// One or more fatal errors occurred that aborted the process
						// [1] : Sequential number of sent instruction that was not processed
						// [2] : Parameter sent for processing
						// [3] : Identification of Agent where the error occurred
						// [4] : Details of error event
						cGridMsg += CRLF
						cGridMsg += varinfo('ERR',oGrid:aErrorProc)+CRLF
					Endif
					If !empty(oGrid:aSendProc)
						// returns list of calls sent and not executed
						// [1] Sequential number of instruction
						// [2] Sending parameter
						// [3] Identification of Agent that received the requisition
						cGridMsg += CRLF
						cGridMsg += varinfo('PND',oGrid:aSendProc)+CRLF
					Endif
					cGridMsg += oGrid:GetError()
					cGridArq := cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG"
					U_zGravaLog(cGridArq,cGridMsg)
				EndIf

				//MsgStop("Grid de Processamento - Fim ["+StrZero(nGrid,05,0)+"]","Grid Execution")

				If lPrimThr
					Sleep( 30000 )
					lPrimThr	 := .F.
				EndIf

				aDel( aThrDat , 1 )

				aSize( aThrDat , Len( aThrDat ) - 1 )

				nThrTrn	:= GetMv("MGF_IMP01B",,20)			// N�mero de Transa��es x Thread
				If nRadMenu1 <> 8
					nThrMax	:= GetMv("MGF_IMP01C",,20)			// N�mero de Transa��es x Thread
				EndIf

			EndIf

		EndIf

		//EndIf

		If nRadMenu1 <> 12 .And. nRadMenu1 <> 8 
			FT_FSKIP()
			ConOut("FT_FSKIP()")
		EndIf

	EndDo

	FT_FUSE()

	If Len( aThrCab ) > 0 .Or. Len( aThrDat ) > 0

		If Len( aThrCab ) > 0

			aAdd( aThrDat , { aThrCab , aThrDet , aThrLin , cEmpAnt , aThrFil , cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG" , nRadMenu1 } )

			aThrCab := {}
			aThrDet := {}
			aThrLin	:= {}
			aThrFil	:= {}

		EndIf

		While Len( aThrDat ) > 0

			If !lGrid
				/*
				oGrid:Go(aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase)

				aDel( aThrDat , 1 )

				aSize( aThrDat , Len( aThrDat ) - 1 )

				ElseIf !lGrid
				*/
				aMonThread := U_zMonThread("U_XEXEC")

				If aMonThread[1] < nThrMax

					ConOut("## MGFIMP01 - Nr de Threads ["+StrZero(aMonThread[1],03,0)+"] - Memoria ["+StrZero(aMonThread[2],12,0)+"] ##")

					StartJob ("U_XEXEC",GEtEnvServer(),.F.,aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase)

					If lPrimThr
						Sleep( 10000 )
						lPrimThr	 := .F.
					EndIf

					aDel( aThrDat , 1 )

					aSize( aThrDat , Len( aThrDat ) - 1 )

				Else
					Sleep(1000)
				EndIf

			Else
				/*
				While oGrid:GetIdleThreads() == 0

				Sleep( 1000 )

				EndDo
				*/
				//ConOut("## MGFIMP01 - Nr de Idle Threads ["+StrZero(oGrid:GetIdleThreads(),05,0)+"] ##")


				lGridOk := .F.
				nGrid++

				//MsgStop("Grid de Processamento - Envio ["+StrZero(nGrid,05,0)+"]" ,"Grid Execution")
				//While !lGridOk
				//MsgStop("Grid de Processamento - Start ["+StrZero(nGrid,05,0)+"]" ,"Grid Execution")

				lGridOk := oGrid:Execute({aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase,lGrid})
				//EndDo
				If !lGridOk
					cGridMsg := "[GRID] Erro oGrid:Execute()"+CRLF
					// An error occurred, either in processing, or in
					// Grid termination. Check the property arrays
					If !empty(oGrid:aErrorProc)
						// One or more fatal errors occurred that aborted the process
						// [1] : Sequential number of sent instruction that was not processed
						// [2] : Parameter sent for processing
						// [3] : Identification of Agent where the error occurred
						// [4] : Details of error event
						cGridMsg += CRLF
						cGridMsg += varinfo('ERR',oGrid:aErrorProc)+CRLF
					Endif
					If !empty(oGrid:aSendProc)
						// returns list of calls sent and not executed
						// [1] Sequential number of instruction
						// [2] Sending parameter
						// [3] Identification of Agent that received the requisition
						cGridMsg += CRLF
						cGridMsg += varinfo('PND',oGrid:aSendProc)+CRLF
					Endif
					cGridMsg += oGrid:GetError()
					cGridArq := cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG"
					U_zGravaLog(cGridArq,cGridMsg)
				EndIf

				//MsgStop("Grid de Processamento - Fim ["+StrZero(nGrid,05,0)+"]","Grid Execution")

				If lPrimThr
					Sleep( 30000 )
					lPrimThr	 := .F.
				EndIf

				aDel( aThrDat , 1 )

				aSize( aThrDat , Len( aThrDat ) - 1 )

				nThrTrn	:= GetMv("MGF_IMP01B",,20)			// N�mero de Transa��es x Thread
				
				If nRadMenu1 <> 8
					nThrMax	:= GetMv("MGF_IMP01C",,20)			// N�mero de Transa��es x Thread
				EndIf

			EndIf

		EndDo

	EndIf



	If !lGrid
		/*
		// Fechamento das Threads
		oGrid:Stop()	//Metodo aguarda o encerramento de todas as threads antes de retornar o controle.
		FreeObj(oGrid) 

		ElseIf !lGrid
		*/
		//Espera termino de todas as threads
		aMonThread := U_zMonThread("U_XEXEC","[MGFIMP01-"+AllTrim(StrZero(nRadMenu1,2))+"]")

		While aMonThread[1] > 0

			Sleep(1000)

			aMonThread := U_zMonThread("U_XEXEC","[MGFIMP01-"+AllTrim(Str(nRadMenu1))+"]")

		EndDo
	Else
		// Finalizar o Grid Grid.
		lGridOk := oGrid:Terminate()
		If !lGridOk
			cGridMsg := "[GRID] Erro oGrid:Terminate()"+CRLF
			// An error occurred, either in processing, or in
			// Grid termination. Check the property arrays
			If !empty(oGrid:aErrorProc)
				// One or more fatal errors occurred that aborted the process
				// [1] : Sequential number of sent instruction that was not processed
				// [2] : Parameter sent for processing
				// [3] : Identification of Agent where the error occurred
				// [4] : Details of error event
				cGridMsg += CRLF
				cGridMsg += varinfo('ERR',oGrid:aErrorProc)+CRLF
			Endif
			If !empty(oGrid:aSendProc)
				// returns list of calls sent and not executed
				// [1] Sequential number of instruction
				// [2] Sending parameter
				// [3] Identification of Agent that received the requisition
				cGridMsg += CRLF
				cGridMsg += varinfo('PND',oGrid:aSendProc)+CRLF
			Endif
			cGridMsg += oGrid:GetError()
			cGridArq := cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".LOG"
			U_zGravaLog(cGridArq,cGridMsg)
		EndIf
	EndIf

	dDataFim	:= Date()
	cHoraFim	:= Time()

	cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Importacao de Dados - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + "#####)"+CRLF
	aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Importacao de Dados" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

	Sleep(30000)

	dDataAux	:= Date()
	cHoraAux	:= Time()

	//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
	aArqLog := Directory(cLogDir+"IMP_"+aTabExclui[nRadMenu1][1]+"-*.LOG")

	cFilAnt := cBKFilial

	dDataFim	:= Date()
	cHoraFim	:= Time()

	cTxtProc 	+= "##### "+StrZero(nTxtProc++,2)+" Arquivo(s) LOG - Inicio: " + cHoraAux + " / Fim: " + cHoraFim + IIF(dDataAux==dDataFim," / Intervalo: "+ElapTime(cHoraAux,cHoraFim)," ") + "#####)"+CRLF+CRLF
	aAdd( aTxtProc , { StrZero(Len(aTxtProc)+1,4) , "Arquivo(s) LOG" , cHoraAux , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraAux,cHoraFim) ," " ) } )

	dDataAux	:= Date()
	cHoraAux	:= Time()

	cTxtProc 	+= "##### [MGFIMP01] - Processamento Terminado - Inicio: " + cHoraIni + " / Fim: " + cHoraFim + IIF(dDataIni==dDataFim," / Intervalo: "+ElapTime(cHoraIni,cHoraFim),"") + " #####)"+CRLF
	cTxtProc	+= Replicate("-",80)+CRLF
	aAdd( aTxtProc , { "    " , "Processamento Total" , cHoraIni , cHoraFim , IIF(dDataAux==dDataFim, ElapTime(cHoraIni,cHoraFim) ," " ) } )

	//U_zGravaLog(cLogProc,cTxtProc)

	aColunas := {"Etapa","Descri��o","Inicio","Final","Intervalo"}
	//aTxtProc	:= {{"0001","Linha 0001"},{"0002","Linha 0002"}}
	cLogProc	:= "PROC_"+aTabExclui[nRadMenu1][1]+"-"+DTOS(Date())+StrTran(Time(),":")+".XML"
	cTxtProc	:= "MGFIMP01 Importacao "+aTabExclui[nRadMenu1][1] +" - " + DtoC( dDataIni ) + " - " + cHoraIni
	U_zGeraExc(aColunas,aTxtProc,cLogProc,cLogDir,IIf(!Empty( cPatLoc ) .And. ":\" $ cPatLoc , cPatLoc , "" ),cTxtProc)


	If !Empty( aArqLog )
		If !Empty( cPatLoc ) .And. ":\" $ cPatLoc

			For nX := 1 to Len(aArqLog)
				CpyS2T(cLogDir+aArqLog[nX,1],cPatLoc)
			Next nX

			MsgAlert("LOG(S) de erros (IMP_"+aTabExclui[nRadMenu1][1]+"-*.LOG) copiado(s) para "+cPatLoc)
		Else
			MsgAlert("LOG(S) de erros (IMP_"+aTabExclui[nRadMenu1][1]+"-*.LOG) gerado(s) em "+cLogDir)
		EndIf
	Else
		MsgInfo("Arquivo importado com sucesso!!")
	Endif



Return

/*
========================================================
StartJob Padr�o
========================================================
*/
User function xExec(nOpc,xI,aAutoCab,aAutoDet,cEmpresa,aFil,cLogFile,dData,lGrid)
    Local cError     := ''
	Local cLogWrite := ""
	Local nX := 0
	Local aLog := {}
	Local bError	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cLogDir	:= "\MGF\IMP\"

	Private lMsErroAuto, lMsErroAuto, cError

	DEFAULT lGrid := .F.

	BEGIN SEQUENCE

		PTInternal( 1 , "[MGFIMP01-"+AllTrim(StrZero(nOpc,2))+"][Thread: "+StrZero(ThreadId(),6)+"]" )

		//Prepare environment EMPRESA cEmpresa FILIAL cFil

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Prepara��o do Ambiente.                                                                                  |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		// Seta job para nao consumir licen�as
		If !lGrid
			If nOpc == 17
				RpcSetType(3)
				IF(ValType(aFil)=="A")
					Prepare environment EMPRESA cEmpresa FILIAL aFil[1] MODULO "COM"
				Else
					Prepare environment EMPRESA cEmpresa FILIAL aFil MODULO "COM"
				EndIf
			ElseIf nOpc <> 10 .And. nOpc <> 14
				RpcSetType(3)

				RpcSetEnv( cEmpresa , IIF(ValType(aFil)=="A",aFil[1],aFil))

			Else

				RpcSetEnv( cEmpresa , IIF(ValType(aFil)=="A",aFil[1],aFil),"t1004690","123")

			EndIf
		EndIf
		If ValType( dData ) == "D"
			dDataBase	:= dData
		EndIf

		For nx	:= 1 to Len(aAutoCab)

			lMsHelpAuto := .T.
			lMsErroAuto := .F.

			cFilAnt	:= aFil[nX]

			cErro := u_myExec(nOpc,aAutoCab[nX],IIF(Len(aAutoDet)>0,aAutoDet[nX],aAutoDet))

			//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
			If lMsErroAuto
				cLogWrite += Replicate("-",80)+CRLF
				cLogWrite += "Linha do erro no arquivo CSV: "+str(xI[nX])+CRLF+CRLF
				If nOpc == 8

					cLogWrite += "[Thread: "+StrZero(ThreadId(),6)+"] Codigo/Item: " + 	aAutoCab[nX][aScan(aAutoCab[nX],{|aAux|alltrim(aAux[1]) == "N1_CBASE"})][2] + "/" + ;
													aAutoCab[nX][aScan(aAutoCab[nX],{|aAux|alltrim(aAux[1]) == "N1_ITEM"})][2] +CRLF+CRLF
				
				EndIf
				If Empty(cErro)
					If (!IsBlind()) // COM INTERFACE GR�FICA
					cLogWrite += MostraErro()
				    Else // EM ESTADO DE JOB
				        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
				
				        ConOut(PadC("Automatic routine ended with error", 80))
				        ConOut("Error: "+ cError)
				        
				        cLogWrite  +=  PadC("Automatic routine ended with error", 80) + " Error: "+ cError
				    EndIf
					
					
				Else
					cLogWrite += cErro
				EndIf
				//cLogWrite += Replicate("-",80)+CRLF

			EndIf

		Next nX


		If !Empty( cLogWrite )
			U_zGravaLog(cLogFile,cLogWrite)
		EndIf

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Finaliza��o do Ambiente.                                                                                 |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		If !lGrid
			RpcClearEnv()
		EndIf

		RECOVER
		Conout('##### MGFIMP01 - Erro no Processamento - Verificar Log - ' + dToC(Date()) + ' - ' + time() )
	END SEQUENCE

	ErrorBlock( bError )

	If ValType(cError) == 'C'

		//ConOut("cError"+cError)

		cLogWrite += cError

		U_zGravaLog(cLogFile,cLogWrite)

	EndIf


Return cLogWrite

/*
========================================================
StartJob ExecAuto
========================================================
*/
User function MyExec(nOpc,aExecAuto,aExecAutod)

	Local cErro := ""
	Local aAux	:= {}
	Local cCod	:= cItem	:= ""
	Local nCont	:= 0

	If nOpc == 1
		MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3) // SB1 Produto
	ElseIf nOpc == 2
		MSExecAuto({|x,y,z| MATA200(x,y,z)},aExecAuto,aExecAutod,3) // SG1 Estrutura de Produto
	ElseIf nOpc == 3
		MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3) // SA1 Cliente
	ElseIf nOpc == 4
		MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3) // SA2 Fornecedores
	ElseIf nOpc == 5
		MSExecAuto({|x,y| MATA040(x,y)},aExecAuto,3) // SA3 Representantes/Vendedores
	ElseIf nOpc == 6
		MSExecAuto({|x,y| OMSA060(x,y)},aExecAuto,3) // DA3 Ve�culos
	ElseIf nOpc == 7
		MSExecAuto({|x,y| MATA050(x,y)},aExecAuto,3) // SA4 Transportadoras
	ElseIf nOpc == 8
		cCod	:=	aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1]) == "N1_CBASE"})][2]
		cItem	:=	aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1]) == "N1_ITEM"})][2]
		/*
		While !FreeForUse("SN1",cCod) .And. nCont <= 20
			nCont++
			ConOut("FreeForUse "+cCod+"/"+cItem)
			Sleep(1000)
		EndDo
		*/
		aParamATF	:= {}
		aAdd( aParamATF , {"MV_PAR01", 2 } ) // Mostra Lanc CTB	- 2 = N�o
		aAdd( aParamATF , {"MV_PAR02", 2 } ) // Repete Chapa	- 2 = N�o
		aAdd( aParamATF , {"MV_PAR03", 2 } ) // Copiar Valores	- 2 = Sem Acumulados
		aAdd( aParamATF , {"MV_PAR04", 2 } ) // Exibe Painel de Detalhes	- 2 = N�o
		aAdd( aParamATF , {"MV_PAR05", 2 } ) // Contabilizar Online			- 2 = N�o
		aAdd( aParamATF , {"MV_PAR06", 2 } ) // Aglutina Lan�amentos		- 2 = N�o
		
		MSExecAuto({|x,y,z| ATFA012(x,y,z)},aExecAuto,aExecAutod,3,aParamATF) // SN1/SN3 Bens Ativo Fixo CABECALHO/ITENS
		//MSExecAuto({|x,y,z| U_ATFZ012(x,y,z)},aExecAuto,aExecAutod,3) // SN1/SN3 Bens Ativo Fixo CABECALHO/ITENS
	ElseIf nOpc == 9

		// dDataBase := CTOD("31/03/2017")

		cCodPro	:=	aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1]) == "D3_COD"})][2]
		nQtdPro	:=	aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1]) == "D3_QUANT"})][2]
		cCodLoc	:=	IIF(aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_LOCAL"})>0,aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_LOCAL"})][2],"")
		cCodEnd	:=	IIF(aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_LOCALIZ"})>0,aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_LOCALIZ"})][2],"")
		cCodDoc	:=	IIF(aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_DOC"})>0,aExecAuto[aScan(aExecAuto,{|aAux|alltrim(aAux[1])=="D3_DOC"})][2],"")

		If Empty( cCodDoc )
			aAdd( aExecAuto , { "D3_DOC" , DTOS( dDataBase ) + "1" , NIL } )
		EndIf

		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
		if Empty( cCodLoc )
			cCodLoc := SB1->B1_LOCPAD
		EndIf
		SB2->( dbSetOrder(1) )
		If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+cCodLoc ) )
			CriaSB2(SB1->B1_COD,cCodLoc)
		EndIf


		MSExecAuto({|x,y| MATA240(x,y)},aExecAuto,3) // SD3 Saldo de estoque

		If !lMsErroAuto .And. !Empty( cCodEnd ) .And. SB1->B1_LOCALIZ == "S"


			__aCabec := {}
			//aAdd( __aCabec , {"DA_FILIAL"	, "010001"			, Nil}	)
			aAdd( __aCabec , {"DA_PRODUTO"	, SD3->D3_COD		, Nil}	)
			aAdd( __aCabec , {"DA_LOCAL"	, SD3->D3_LOCAL		, Nil}	)
			aAdd( __aCabec , {"DA_NUMSEQ"	, SD3->D3_NUMSEQ			, Nil}	)
			aAdd( __aCabec , {"DA_DOC"		, SD3->D3_DOC		, Nil}	)
			aAdd( __aCabec , {"DA_ORIGEM"	, "SD3"				, Nil}	)
			//aAdd( __aCabec , {"INDEX"		,1					, NIL}	)

			__aItens :=	{}

			//DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZ+DB_NUMSEQ
			aAdd( __aItens , {"DB_ITEM"		, "0001"				, Nil}	)
			aAdd( __aItens , {"DB_PRODUTO"	, SD3->D3_COD			, Nil}	)
			aAdd( __aItens , {"DB_LOCAL"	, SD3->D3_LOCAL			, Nil}	)
			aAdd( __aItens , {"DB_LOTECTL"	, SD3->D3_LOTECTL		, Nil}	)
			aAdd( __aItens , {"DB_NUMLOTE"	, SD3->D3_NUMLOTE		, Nil}	)
			aAdd( __aItens , {"DB_NUMSERI"	, SD3->D3_NUMSERI		, Nil}	)
			aAdd( __aItens , {"DB_LOCALIZ"	, cCodEnd				, Nil}	)
			aAdd( __aItens , {"DB_NUMSEQ"	, SD3->D3_NUMSEQ		, Nil}	)
			aAdd( __aItens , {"DB_DATA"		, SD3->D3_EMISSAO		, Nil}	)
			aAdd( __aItens , {"DB_QUANT"	, SD3->D3_QUANT			, Nil}	)

			__aItens	:= { __aItens }

			MsExecAuto({|x,y,z| Mata265(x,y,z)},__aCabec,__aItens,3)

		EndIf

		//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo

	ElseIf nOpc == 10
		SetFunName("MATA121")
		MSExecAuto({|x,y,z| MATA121(x,y,z)},aExecAuto,aExecAutod,3) // SC7 Pedido de Compra
	ElseIf nOpc == 11
		MSExecAuto({|x,y,z| MATA410(x,y,z)},aExecAuto,aExecAutod,3) // SC5/SC6 Pedidos de Venda CABECALHO/ITENS
	ElseIf nOpc == 12
		SetFunName("FINA050")
		If aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_TIPO'}),2] $ "PA "
			aAdd(aExecAuto, {"AUTBANCO","996",nil})
			aAdd(aExecAuto, {"AUTAGENCIA","00000",nil})
			aAdd(aExecAuto, {"AUTCONTA","0000000001",nil})
		EndIf
		aAux	:= {PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_PREFIXO'}),2],TAMSX3('E2_PREFIXO')[1]	),;
					PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_NUM'}),	2],TAMSX3('E2_NUM')[1]		),;
					PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_PARCELA'}),2],TAMSX3('E2_PARCELA')[1]	),;
					PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_TIPO'}),	2],TAMSX3('E2_TIPO')[1]		),;
					PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_FORNECE'}),2],TAMSX3('E2_FORNECE')[1]	),;
					PADR(aExecAuto[ascan(aExecAuto,{|x| x[1]='E2_LOJA'}),	2],TAMSX3('E2_LOJA')[1]		)	}
		DbSelectArea("SE2")
		DbSetOrder(1)
		//If !DbSeek(xFilial("SE2")+aAux[1]+aAux[2]+aAux[3]+aAux[4]+aAux[5]+aAux[6])
			pergunte("FINA050",.F.)
			//MSExecAuto({|y,z| FINA050(y,z)},aExecAuto,3)   // SE2 Contas a Pagar em aberto MESTRE
			
			public lPaMovBco := .F.
			
			MSExecAuto({|y,z| FINA050(y,z)},aExecAuto,3,/*nOpcAuto*/,/*bExecuta*/,/*aDadosBco*/,/*lExibeLanc*/,/*lOnline*/,/*aDadosCTB*/,/*aTitPrv*/,/*lMsBlQl*/,.F.)   // SE2 Contas a Pagar em aberto MESTRE
			//aRotAuto,nOpcion,nOpcAuto,bExecuta,aDadosBco,lExibeLanc,lOnline,aDadosCTB,aTitPrv,lMsBlQl,lPaMovBco
			
		//EndIf
	ElseIf nOpc == 13
		MSExecAuto({|x,y| FINA040(x,y)},aExecAuto,3)   // SE1 Contas a Receber em aberto MESTRE
	ElseIf nOpc == 14

		cCodPro	:=	aExecAutod[1][aScan(aExecAutod[1],{|aAux|alltrim(aAux[1]) == "C1_PRODUTO"})][2]
		cCtoCus	:=	IIF(aScan(aExecAutod[1],{|aAux|alltrim(aAux[1])=="C1_CC"})>0,aExecAutod[1][aScan(aExecAutod[1],{|aAux|alltrim(aAux[1])=="C1_CC"})][2],"")
		cGrpPro	:=	IIF(aScan(aExecAutod[1],{|aAux|alltrim(aAux[1])=="C1_ZGRPPRD"})>0,aExecAutod[1][aScan(aExecAutod[1],{|aAux|alltrim(aAux[1])=="C1_ZGRPPRD"})][2],"")

		if Empty( cGrpPro )
			SB1->( dbSetOrder(1) )
			SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
			cGrpPro := SB1->B1_GRUPO
		EndIf

		xCriaTab()

		SetFunName("MATA110")
		MSExecAuto({|x,y,z| MATA110(x,y,z)},aExecAuto,aExecAutod,3) // SC1 Solicita��o de Compra
	ElseIf nOpc == 15
		cErro := ImportMVC( "MGFFAT01","SZ9","FAT01MASTER",aExecAuto )  // SZ9 Endere�o de Entrega
	ElseIf nOpc == 16
		MSExecAuto({|x,y| OMSA040(x,y)},aExecAuto,3)   // DA4 Motoristas
	ElseIf nOpc == 17
		dbSelectArea("SC3")
		dbSetOrder(1)
		MSExecAuto( {|x,y,z| mata125(x,y,z)},aExecAuto,aExecAutod,3)
		//		MSExecAuto({|x,y,z| mata125(x,y,z)},aExecAuto,aExecAutod,3)   // SC3 Acordo Comercial
	Endif
return cErro

User function zExec( aParExec )

	Local nThrMax	:= GetMv("MGF_IMP01C",,20)			// N�mero M�ximo de Threads

	While U_zNumThread("U_XEXEC") >= nThrMax

		Sleep(1000)

	EndDo

	StartJob ("U_XEXEC",GEtEnvServer(),.F.,aParExec[7],aParExec[3],aParExec[1],aParExec[2],aParExec[4],aParExec[5],aParExec[6])

Return

Static Function MyError(oError)

	cError := oError:ERRORSTACK

Return

Static Function xCriaTab()

	Local __aStrut    := { {"CCUSTO","C",TamSX3('C1_CC')[1],0},{"GRUPO","C",TamSX3('B1_GRUPO')[1],0} }
	Local cArqThr     := CriaTrab( __aStrut , .T. )

	If Select('ZCUSTGRADE')>0
		('ZCUSTGRADE')->(dbGoTop())
		RecLock("ZCUSTGRADE",.F.)
		('ZCUSTGRADE')->CCUSTO :=''
		('ZCUSTGRADE')->GRUPO :=''
		('ZCUSTGRADE')->(MsUnlock())
	Else

		// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
		dbUseArea( .T., __LocalDriver, cArqThr, "ZCUSTGRADE" , .T. , .F. )

		RecLock("ZCUSTGRADE",.T.)
		('ZCUSTGRADE')->(MsUnlock())
	EndIf

Return

Static Function ImportMVC( cModel,cAlias,cMaster,aCampos,cAliasD,cDetail,aCamposD )
	Local oModel, oAux, oStruct
	Local nI := 0
	Local nJ := 0
	Local nPos := 0
	Local lRet := .T.
	Local aAux := {}
	Local aC := {}
	Local aH := {}
	Local nItErro := 0
	Local lAux := .T.
	Local cErro := ""
	Local cError     := ''

	Default cDetail		:= ""
	Default cAliasD		:= ""
	Default aCamposD	:= {}

	dbSelectArea( cAlias )
	dbSetOrder( 1 )
	If !Empty(cAliasD)
		dbSelectArea( cAliasD )
		dbSetOrder( 1 )
	EndIf
	// Aqui ocorre o instânciamento do modelo de dados (Model)
	// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
	// que � a rotina de manuten��o de musicas
	oModel := FWLoadModel( cModel )
	// Temos que definir qual a opera��o deseja: 3 – Inclus�o / 4 – Altera��o / 5 - Exclus�o
	oModel:SetOperation( 3 )
	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()
	// Instanciamos apenas a parte do modelo referente aos dados de cabe�alho
	oAux := oModel:GetModel( cMaster  )
	// Obtemos a estrutura de dados do cabe�alho
	oStruct := oAux:GetStruct()
	aAux := oStruct:GetFields()
	If lRet
		For nI := 1 To Len( aCampos )
			// Verifica se os campos passados existem na estrutura do cabe�alho
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCampos[nI][1] ) } ) ) > 0
				// É feita a atribui��o do dado ao campo do Model do cabe�alho
				If !( lAux := oModel:SetValue( cMaster , aCampos[nI][1],aCampos[nI][2] ) )
					// Caso a atribui��o n�o possa ser feita, por algum motivo (valida��o, por exemplo)
					// o m�todo SetValue retorna .F.
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf
	If lRet .and. !Empty(cDetail)
		// Instanciamos apenas a parte do modelo referente aos dados do item
		oAux := oModel:GetModel( cDetail )
		// Obtemos a estrutura de dados do item
		oStruct := oAux:GetStruct()
		aAux := oStruct:GetFields()
		nItErro := 0
		For nI := 1 To Len( aCamposD )
			// Inclu�mos uma linha nova
			// ATEN��O: Os itens s�o criados em uma estrutura de grid (FORMGRID), portanto j� � criada uma primeira linha
			//branco automaticamente, desta forma come�amos a inserir novas linhas a partir da 2a. vez
			If nI > 1
				// Inclu�mos uma nova linha de item
				If ( nItErro := oAux:AddLine() ) <> nI
					// Se por algum motivo o m�todo AddLine() n�o consegue incluir a linha, // ele retorna a quantidade de linhas j� // existem no grid. Se conseguir retorna a quantidade mais 1
					lRet := .F.
					Exit
				EndIf
			EndIf
			For nJ := 1 To Len( aCamposD[nI] )
				// Verifica se os campos passados existem na estrutura de item
				If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCamposD[nI][nJ][1] ) } ) ) > 0
					If !( lAux := oModel:SetValue( cDetail, aCamposD[nI][nJ][1], aCamposD[nI][nJ][2] ) )
						// Caso a atribui��o n�o possa ser feita, por algum motivo (valida��o, por exemplo)
						// o m�todo SetValue retorna .F.
						lRet := .F.
						nItErro := nI
						Exit
					EndIf
				EndIf
			Next
			If !lRet
				Exit
			EndIf
		Next
	EndIf
	If lRet
		// Faz-se a valida��o dos dados, note que diferentemente das tradicionais "rotinas autom�ticas"
		// neste momento os dados n�o s�o gravados, s�o somente validados.
		If ( lRet := oModel:VldData() )
			// Se os dados foram validados faz-se a grava��o efetiva dos
			// dados (commit)
			oModel:CommitData()
		EndIf
	EndIf
	If !lRet
		// Se os dados n�o foram validados obtemos a descri��o do erro para gerar
		// LOG ou mensagem de aviso
		aErro := oModel:GetErrorMessage()
		// A estrutura do vetor com erro �:
		// [1] identificador (ID) do formul�rio de origem
		// [2] identificador (ID) do campo de origem
		// [3] identificador (ID) do formul�rio de erro
		// [4] identificador (ID) do campo de erro
		// [5] identificador (ID) do erro
		// [6] mensagem do erro
		// [7] mensagem da solu��o
		// [8] Valor atribu�do
		// [9] Valor anterior
		AutoGrLog( "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
		AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
		AutoGrLog( "Id do formul�rio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
		AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
		AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
		AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
		AutoGrLog( "Mensagem da solu��o: " + ' [' + AllToChar( aErro[7] ) + ']' )
		AutoGrLog( "Valor atribu�do: " + ' [' + AllToChar( aErro[8] ) + ']' )
		AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
		cErro :=  "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1] ) + ']'
		cErro +=  "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']'
		cErro +=  "Id do formul�rio de erro: " + ' [' + AllToChar( aErro[3] ) + ']'
		cErro +=  "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']'
		cErro +=  "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']'
		cErro +=  "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']'
		cErro +=  "Mensagem da solu��o: " + ' [' + AllToChar( aErro[7] ) + ']'
		cErro +=  "Valor atribu�do: " + ' [' + AllToChar( aErro[8] ) + ']'
		cErro +=  "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']'
		If nItErro > 0
			AutoGrLog( "Erro no Item: " + ' [' + AllTrim( AllToChar( nItErro ) ) + ']' )
		EndIf
		If (!IsBlind()) // COM INTERFACE GR�FICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	EndIf
	// Desativamos o Model
	oModel:DeActivate()
Return cErro

User Function zGridS(aParms)
	Local cEmp := aParms[1]
	Local cFil := aParms[2]
	Local nOpc := aParms[3]

	Conout("[GRID] Preparing Environment " + cEmp+cFil )

	RPCSetType(3) //Nao utilizar licenca
	
	If nOpc = 17
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "COM"
	Else
		RpcSetEnv( cEmp , cFil )
	EndIf

	If !(nOpc <> 10)
		//	If !(nOpc <> 10 .And. nOpc <> 14)
		__cUserId	:= Alltrim(GetMv("MGF_USRAUT"))	
	EndIf

	Conout("[GRID] Environment Prepared " + cEmp+cFil )

Return .T.

USER Function ZGRIDE(aParam)
	/*
	Local	nOpc	:=
	Local	xI
	Local	aAutoCab
	Local	aAutoDet
	Local	cEmpresa
	Local	aFil
	Local	cLogFile
	Local	dData
	Local	lGrid
	aThrDat[1][7],aThrDat[1][3],aThrDat[1][1],aThrDat[1][2],aThrDat[1][4],aThrDat[1][5],aThrDat[1][6],dDataBase,lGrid
	*/
	// Conout("[GRID] REQUISITION [aParam] Processing Parameter ["+str(Len(aParam),4)+"]")

	Sleep( 100000 )

	U_XEXEC(aParam[1],aParam[2],aParam[3],aParam[4],aParam[5],aParam[6],aParam[7],aParam[8],aParam[9])

	// Conout("[GRID] REQUISITION ["+str(Len(aParam),4)+"] OK")

Return
