#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFTAP08
Autor....:              Atilio Amarilla
Data.....:              08/11/2016
Descricao / Objetivo:   Integração PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Função de chamada de execautos MATA261 (Transf. Mod. 2)
=====================================================================================
*/

User Function MGFTAP08( aParam )
    Local cError     := ''
	// aParam - { D3_ACAO , D3_FILIAL	,	D3_EMISSAO ,	D3_ZHORA	,	D3_COD	,D3_QUANT	,	D3_LOTECT , D3_DTVALID	, D3_ZQTDPCS<>NIL	,
	//	  	 	D3_ZQTDPCS)	,	D3_ZQTDCXS }

	Local aRotAuto	:= {}

	Local nOpc		:= 3

	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd, nI, cStatus, nRecMon

	Local cAcao		:= aParam[1]
	Local cFilOrd	:= aParam[2]
	Local cDatEmi	:= StrTran(aParam[3],"-")
	Local cHotEmi	:= aParam[4]
	Local cCodPro	:= aParam[5]
	Local nQtdOrd	:= aParam[6]
	Local cLotCtl	//:= IIF(!Empty(aParam[7]),aParam[7],CriaVar("D3_LOTECTL",.F.))
	Local cDatVld	:= ""
	Local nQtdPcs	:= aParam[9]
	Local nQtdCxs	:= aParam[10]

	Local aRetorno	:= {{"1",""}}

	Local aErro, cErro, cArqLog, cLocBlq

	Local cCodInt, cCodTpInt, cNumDoc, cEndPad, cNumSer, cNumLot

	Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SB8" , "SBC" , "SC2" , "SD3" , "SES", "ZZE" , "SG1" , "SC5" , "SC6" , "SHD" , "SHE" , "SC3" , ;
							"AFM" , "SGJ" , "SX5" , "SZ1" , "SZ2" , "SZ3" }

	Local	dMovBlq
	
	//Local cHorFim, cExeIni, cExeFim
	//Local cHorIni	:= Time()
	//ConOut("[MGFIMP08][Thread: "+StrZero(ThreadId(),6)+"] Inicio "+cHorIni)

	// Seta job para nao consumir licenças
	// RpcSetType(3)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Preparação do Ambiente.                                                                                  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	//RpcSetEnv( "01" , cFilOrd , Nil, Nil, "EST" ) // , Nil, aTables )

	If Select("SX3")==0

		lSetEnv	:= .T.
	
		RpcSetEnv( "01" , cFilOrd , Nil, Nil, "EST") // , Nil, aTables )
	

	Else

		lSetEnv	:= .F.

	EndIf

	cFilAnt		:= cFilOrd

	dMovBlq	:= GetMV("MV_DBLQMOV")
	dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

	SetFunName("MGFTAP08") // ("MATA261") //

	cLotCtl	:= IIF(!Empty(aParam[7]),aParam[7],CriaVar("D3_LOTECTL",.F.))

	cCodInt		:= GetMv("MGF_TAP08A",,"001") // Taura Produção
	cCodTpInt	:= GetMv("MGF_TAP08B",,"006") // Inclusão OP
	cLocBlq		:= GetMv("MGF_TAPBLQ",,"66")		// Almoxarifado Boqueio
	cLocBlq		:= Stuff( Space(TamSX3("B1_LOCPAD")[1]) , 1 , Len(cLocBlq) , cLocBlq )
	cLocBlq		:= Subs( cLocBlq , 1 , TamSX3("B1_LOCPAD")[1] )

	cDirLog		:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs
	cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integração Taura Produção
	cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad )

	cNumSer		:= CriaVar("D3_NUMSERI",.F.)
	cNumLot		:= CriaVar("D3_NUMLOTE",.F.)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Seleção de Tabelas / Índices                                                                             |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	dbSelectArea("SB1")
	dbSetOrder(1)

	dbSelectArea("SB2")
	dbSetOrder(1)

	dbSelectArea("SB8")
	dbSetOrder(3)

	dbSelectArea("SBF")
	dbSetOrder(1) // BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE

	dbSelectArea("SD3")
	dbSetOrder(1)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Seleção de Tabelas / Índices                                                                             |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	cCodPro	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(cCodPro) , cCodPro )

	If Empty( SToD(cDatEmi) )
		aRetorno	:= {{"2","Data do movimento Inválida: "+AllTrim(cDatEmi)}}
	EndIf

	If nQtdOrd <= 0
		aRetorno	:= {{"2","Quantidade Inválida: "+AllTrim(Str(nQtdOrd))}}
	EndIf

	If Empty( aRetorno[1][2] ) .And. !SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
		aRetorno	:= {{"2","Código de Produto inválido: "+AllTrim(cCodPro)}}
	Else
		If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD ) )
			CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
		EndIf
		If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+cLocBlq ) )
			CriaSB2(SB1->B1_COD,cLocBlq)
		EndIf
		If SB1->B1_RASTRO $ "LS"
			If !Empty( cLotCtl )
				//ConOut("cLotCtl")
				cLotCtl	:= Stuff( Space(TamSX3("D3_LOTECTL")[1]) , 1 , Len(cLotCtl) , cLotCtl )
				If !SB8->( dbSeek( xFilial("SB8")+cCodPro+IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq)+cLotCtl ) )
					aRetorno	:= {{"2","Produto/Armazem/Lote inválido: "+AllTrim(cCodPro)+"/"+AllTrim(IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq)+"/"+AllTrim(cLotCtl))}}
				Else
					cDatVld	:= DTOS( SB8->B8_DTVALID )
					If SB1->B1_LOCALIZ == "S"
						If !SBF->( dbSeek( xFilial("SBF")+IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq)+cEndPad+cCodPro+cNumSer+cLotCtl+cNumLot ) )
							aRetorno	:= {{"2","Produto/Armazem/Lote/Endereço inválido: "+AllTrim(cCodPro)+"/"+AllTrim(IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq)+"/"+AllTrim(cLotCtl)+"/"+IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq))}}
						EndIf
					EndIf
				EndIf
			Else
				//ConOut("cLotCtl vazio")
				aRetorno	:= {{"2","Lote inválido (vazio) para o Produto: "+AllTrim(cCodPro)}}
			EndIf
		EndIf
		If Empty( aRetorno[1][2] ) .And. STOD(cDatEmi) <= dMovBlq 
			aRetorno	:= {{"2","Movimentacao com data anterior ao fechamento (Bloqueio de Movimentacao ou Virada de Saldos)."}}
		EndIf
	EndIf

	//ConOut("## MGFTAP08 Filial "+cFilOrd+" - Produto "+cCodPro+" - Quant ["+StrZero(nQtdOrd,10,0)+"] #####")

	If Empty( aRetorno[1][2] )

		dDataBase	:= STOD(cDatEmi)

		cNumDoc	:= "" // MGFTAP0801()
		
		While Empty(cNumDoc) .Or. !Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc,2,"" ) )
			cNumDoc	:= GetSXENum("SD3","D3_DOC")
			ConfirmSX8()
		EndDo

		aRotAuto	:= { {	cNumDoc		, ;	// 01.Numero do Documento
		DDATABASE	} }	// 02.Data da Transferencia


		aAdd( aRotAuto , {	SB1->B1_COD									, ;	// 01.Produto origem
							SB1->B1_DESC							, ;	// 02.Descricao
							SB1->B1_UM								, ;	// 03.Unidade de Medida
							IIF(cAcao=="1",SB1->B1_LOCPAD,cLocBlq)	, ;	// 04.local origem - 02
							IIF(SB1->B1_LOCALIZ=="S",cEndPad,CriaVar("D3_LOCALIZ",.F.))	, ;	// 05.ENDEREÇO ORIGEM
							cCodPro									, ;	// 06.produto DESTINO
							SB1->B1_DESC							, ;	// 07.Descricao PRODUTO DESTINO
							SB1->B1_UM								, ;	// 08.Unidade de Medida
							IIF(cAcao=="1",cLocBlq,SB1->B1_LOCPAD)	, ;	// 09.local DESTINO - 01
							IIF(SB1->B1_LOCALIZ=="S",cEndPad,CriaVar("D3_LOCALIZ",.F.))	, ;	// 10.Endereco Destino
							CriaVar("D3_NUMSERI",.F.)				, ;	// 11.Numero de Serie
							cLotCtl									, ;	// 12.lote ORIGEM
							CriaVar("D3_NUMLOTE",.F.)				, ;	// 13.Sublote  ORIGEM
							STOD(cDatVld)							, ;	// 14.Data de Validade
							CriaVar("D3_POTENCI",.F.)				, ;	// 15.Potencia do Lote
							nQtdOrd									, ;	// 16.QUANTIDADE - COMUN
							CriaVar("D3_QTSEGUM",.F.)				, ;	// 17.Quantidade na 2 UM
							CriaVar("D3_ESTORNO",.F.)				, ;	// 18.Estorno
							CriaVar("D3_NUMSEQ",.F.)				, ;	// 19.NumSeq
							cLotCtl									, ;	// 20.lote DESTINO
							STOD(cDatVld)							, ; // 21.Data de validade
							CriaVar("D3_ITEMGRD",.F.)				, ;	// 22.Grade D3_ITEMGRD
							"  "									, ;	// 23.Cod.CAT83  D3_CODLAN
							"  "									, ;	// 24.Cod.CAT83  D3_CODLAN
							"  "									} )	// 26.Observação D3_OBSERVA
//							"  "									, ;	// 25.Id DCF     D3_IDDCF
							

							

		lMsHelpAuto := .T.
		lMsErroAuto := .F.

		// 23/11/2017 - Atilio - Produto bloqueado. Desbloqueio antes de Integração
		If SB1->B1_MSBLQL == '1'
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '2'
			SB1->( msUnlock() )
			lMsBlq			:= .T.
			//ConOut("Desbloqueio "+AllTrim(SB1->B1_COD))
		Else
			lMsBlq			:= .F.
			//ConOut("Sem Bloqueio "+AllTrim(SB1->B1_COD))
		EndIf

		//cExeIni	:= Time()
		//ConOut("[MGFIMP08][Thread: "+StrZero(ThreadId(),6)+"] ExecAuto Inicio "+cExeIni)

		//-- Chamada da rotina automatica
		msExecAuto({|x,y,z| Mata261(x,y,z)},aRotAuto,3)

		//cExeFim	:= Time()
		//ConOut("[MGFIMP08][Thread: "+StrZero(ThreadId(),6)+"] ExecAuto Fim "+cExeFim+" - Tempo: " + ElapTime(cExeIni,cExeFim))

		// 23/11/2017 - Atilio - Produto bloqueado. Bloqueio depois de Integração
		If lMsBlq
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '1'
			SB1->( msUnlock() )
			//ConOut("Bloqueio "+AllTrim(SB1->B1_COD))
		EndIf

		cErro := ""

		SD3->( dbSetOrder(2) )

		If SD3->( dbSeek( xFilial("SD3")+cNumDoc+cCodPro ) )// nQtdOrd == GetAdvFVal("SD3","D3_QUANT", xFilial("SD3")+cNumDoc+cCodPro,2,"" )
		
			//ConfirmSX8()

			aRetorno	:= {{"1",IIF(cAcao=="1","Bloqueio","Desbloqueio")+" realizado com sucesso. Doc: "+cNumDoc}}

			cStatus := "1"

			cErro	:= "Fil/Prod "+cFilOrd + "/" + cCodPro

			//cDocOri	:= cNumDoc

		ElseIf lMsErroAuto //.And. !(SD3->(D3_FILIAL+D3_COD)==cFilAnt+cCodPro .And. SD3->D3_QUANT == nQtdOrd) // .And. !SD3->( dbSeek( xFilial("SD3")+cNumDoc+cCodPro ) ) // Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc+cCodPro,2,"" ) )

			//RollBackSX8()

			//aRetorno	:= {{"2","Falha no ExecAuto Mata261."}}

			cStatus := "2"

			//aErro := GetAutoGRLog() // Retorna erro em array
			cErro := ""
			cErro += FunName() +" - ExecAuto Mata261" + CRLF

			cErro += "Filial  - "+ cFilOrd + CRLF
			cErro += "Doc.    - "+ cNumDoc + CRLF
			cErro += "Produto - "+ cCodPro + CRLF
			cErro += "Data    - " + DTOC(STOD(cDatEmi)) + CRLF
			cErro += " " + CRLF

						
			If (!IsBlind()) // COM INTERFACE GRÁFICA
			cErro += MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		        
		        cErro += PadC("Automatic routine ended with error", 80) + " Error: "+ cError
		    EndIf

			aRetorno := {{"2",cErro}}

			//cArqLog := FunName() +"-"+ DToS(dDataBase) +"-"+ StrTran(time(),":")+".LOG"

			//MemoWrite( cDirLog + cArqLog , cErro)

			//cErro	:= cDirLog + cArqLog

			//cDocOri	:= cNumDoc

		Else

			//ConfirmSX8()

			aRetorno	:= {{"1",IIF(cAcao=="1","Bloqueio","Desbloqueio")+" - Erro na movimentação. Doc: "+cNumDoc}}

			cStatus := "2"

			cErro	:= "Fil/Prod "+cFilOrd + "/" + cCodPro

			//cDocOri	:= cNumDoc


		EndIf

		cHorOrd	:= Time()
		cTempo	:= ElapTime(cHorIni,cHorOrd)

		//nRecMon	:=	U_MGFMONITOR(cFilAnt,cStatus,cCodInt,cCodTpInt,cErro,cDocOri,cTempo)

		// Gravar Monitor
		/*
		MGFMONITOR(cFil,cStatus,cCodint,cCodtpint,cErro,cDocori,cTempo)
		cFil: Filial da integração
		cStatus: Código do Status da integração, deverá ser 1 (Integrado) ou 2 (Erro)
		cCodint: Código da Integração, deverá existir no cadastro de integrações
		cCodtpint: Código do tipo de integração, deverá exisitir no cadastro de tipo de integrações
		cErro: Texto do Erro ocorrido na integração.
		cDocori: Numero do documento de origem referente a integração
		cTempo: Tempo decorrido da integração (00:00:00)
		*/


	EndIf

	//cHorFim	:= Time()
	//ConOut("[MGFIMP08][Thread: "+StrZero(ThreadId(),6)+"] Fim "+cHorFim+" - Tempo: " + ElapTime(cHorIni,cHorFim))

	If	.F. // lSetEnv

		RpcClearEnv()

		//ConOut("RpcClearEnv()")
	EndIf

Return( aRetorno )

Static Function MGFTAP0801()

	Local cRet, cSeq
	Local cAliasTRB, cQuery

	cAliasTRB := GetNextAlias()

	cQuery := "SELECT MAX( D3_DOC ) D3_DOC " + CRLF
	cQuery += "FROM "+RetSqlName("SD3")+" SD3 "+CRLF
	cQuery += "WHERE SD3.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND D3_FILIAL = '"+ xFilial("SD3") +"' "+CRLF
	cQuery += "	AND D3_EMISSAO = '"+DTOS(dDataBase)+"' "+CRLF
	If "ORACLE" $ TcGetDB()
		cQuery += "	AND SUBSTR(D3_DOC,1,6) = '"+SUBSTRING(DTOS(dDataBase),3,6)+"' "+CRLF
	Else
		cQuery += "	AND SUBSTRING(D3_DOC,1,6) = '"+SUBSTRING(DTOS(dDataBase),3,6)+"' "+CRLF
	EndIf

	cQuery	:= ChangeQuery( cQuery )

	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .F. )

	If !Empty( (cAliasTRB)->D3_DOC )
		cSeq := Soma1( Subs( (cAliasTRB)->D3_DOC , 7 , 3 ) )
		cRet	:=  Subs(DTOS(dDataBase),3,6) + cSeq
	Else
		cSeq	:= "001"
		cRet	:=  Subs(DTOS(dDataBase),3,6) + cSeq
	EndIf

	dbSelectArea(cAliasTRB)

	dbCloseArea()

Return( cRet )
