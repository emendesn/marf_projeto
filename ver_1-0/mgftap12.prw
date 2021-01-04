#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFTAP12
Autor....:              Atilio Amarilla
Data.....:              17/01/2017
Descricao / Objetivo:   Integração PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada de execautos MATA240 Mov. Internos (Ajustes)
=====================================================================================
*/

User Function MGFTAP12( aParam )
Local cError     := ''
// aParam - { cAcao ("1") , D3_FILIAL	,	D3_EMISSAO ,	D3_ZHORA	,	D3_COD	,D3_QUANT	,	D3_LOTECT , D3_DTVALID	, D3_ZQTDPCS<>NIL	,
//	  	 	D3_ZQTDPCS)	,	D3_ZQTDCXS }

Local aRotAuto	:= {}

Local nOpc		:= 3

Local dDatIni	:= Date()
Local cHorIni	:= Time()
Local cHorOrd, nI

Local cAcao		:= aParam[1]
Local cFilOrd	:= aParam[2]
Local cDatEmi	:= StrTran(aParam[3],"-")
Local cHorEmi	:= aParam[4]
Local cCodPro	:= aParam[5]
Local nQtdOrd	:= aParam[6]
Local cLotCtl	:= aParam[7]
Local cDatVld	:= StrTran(aParam[8],"-")
Local nQtdPcs	:= aParam[9]
Local nQtdCxs	:= aParam[10]
Local cOpTaura  := aParam[11]
Local cChaveIU  := aParam[12]

Local aRetorno	:= {{"1",""}}

Local aErro, cErro, cArqLog

Local dDatOrd, cNumOrd, cTpMov, cTpOrd, cCodLot

Local cCodInt, cCodTpInt, cTm , cTMDev , cTMReq, cEndPad

Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SB8" , "SBC" , "SC2" , "SD3" , "SES", "ZZE" , "SG1" , "SC5" , "SC6" , "SHD" , "SHE" , "SC3" , ;
		"AFM" , "SGJ" , "SX5" , "SZ1" , "SZ2" , "SZ3" }
		
Local	dMovBlq

// Seta job para nao consumir licenças
//RpcSetType(3)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparação do Ambiente.                                                                                  |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
//RpcSetEnv( "01" , cFilOrd , Nil, Nil, "EST", Nil ) //, aTables )

If Select("SX3")==0

	lSetEnv	:= .T.
	
	RpcSetEnv( "01" , cFilOrd , Nil, Nil, "EST" , Nil , aTables )

Else

	lSetEnv	:= .F.

EndIf

SetFunName("MATA240")

cCodInt	:= GetMv("MGF_TAP12A",,"001") // Taura Produção
cCodTpInt	:= GetMv("MGF_TAP12B",,"007") // Movimentos Internos - Ajustes

cTMDev		:= GetMv("MGF_TAP12C",,"112")// dev
cTMReq		:= GetMv("MGF_TAP12D",,"555")//req

cDirLog		:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs

cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integração Taura Produção
cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad ) 

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Seleção de Tabelas / Índices                                                                             |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(1)

dbSelectArea("SD3")
dbSetOrder(1)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Seleção de Tabelas / Índices                                                                             |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cCodPro	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(cCodPro) , cCodPro )

cFilAnt		:= cFilOrd

dMovBlq	:= GetMV("MV_DBLQMOV")
dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

If Empty( SToD(cDatEmi) )
	aRetorno	:= {{"2","Data do movimento Inválida: "+AllTrim(cDatEmi)}}
ElseIf STOD(cDatEmi) <= dMovBlq 
	aRetorno	:= {{"2","Movimentacao com data anterior ao fechamento (Bloqueio de Movimentacao ou Virada de Saldos)."}}
EndIf

If Empty( aRetorno[1][2] ) .And. !SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
	aRetorno	:= {{"2","Código de Produto inválido: "+AllTrim(cCodPro)}}
Else

	
	dDataBase	:= STOD(cDatEmi)
	
	If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD ) )
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf
EndIf
                    
SD3->(DbOrderNickName('ZCHAVEU'))
IF !Empty(cChaveIU)
    IF SD3->(dbSeek(cChaveIU))
	    aRetorno	:= {{"2","Chave já processada : "+AllTrim(cChaveIU)}}
	 EndIF
EndIF
SD3->(dbSetOrder(1))

If Empty( aRetorno[1][2] )

	If cAcao == "1" // Requisição
		cTM := cTMReq
	Else
		cTM := cTMDev
	EndIf
			
	cNumDoc	:= ""
		
	While Empty(cNumDoc) .Or. !Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc,2,"" ) )
		cNumDoc	:= GetSXENum("SD3","D3_DOC")
		ConfirmSX8()
	EndDo
	
	aRotAuto	:= {}
		
	aAdd( aRotAuto ,	{"D3_FILIAL"	, cFilAnt			,NIL} )
	aAdd( aRotAuto ,	{"D3_TM"		, cTM				,NIL} )
	aAdd( aRotAuto ,	{"D3_COD"		, SB1->B1_COD		,NIL} )
	aAdd( aRotAuto ,	{"D3_QUANT"		, nQtdOrd			,NIL} )
	aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, nQtdPcs			,NIL} )
	aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, nQtdCxs			,NIL} )
	aAdd( aRotAuto ,	{"D3_LOCAL"		, SB1->B1_LOCPAD	,NIL} )
	aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc			,NIL} )
	aAdd( aRotAuto ,	{"D3_EMISSAO"	, STOD(cDatEmi)		,NIL} )
	aAdd( aRotAuto ,	{"D3_ZHORA"		, cHorEmi			,NIL} )
	aAdd( aRotAuto ,    {"D3_ZOPTAUR"	, cOpTaura      	,NIL} )
	If !Empty(cLotCtl) .And. SB1->B1_RASTRO $ "LS"
		aAdd( aRotAuto ,	{"D3_LOTECTL"	, cLotCtl		,NIL} )
		aAdd( aRotAuto ,	{"D3_DTVALID"	, STOD(cDatVld)	,NIL} )
	EndIf
	If SB1->B1_LOCALIZ == "S"
		aAdd( aRotAuto ,	{"D3_LOCALIZ"	, cEndPad		,NIL} )
	EndIf 
	IF !Empty(cChaveIU) 
		aAdd( aRotAuto ,	{"D3_ZCHAVEU"	, cChaveIU		,NIL} )
	EndIF

	//ConOut("## MGFTAP05 Filial "+cFilOrd+" - cNumDoc "+cNumDoc+" - Produto "+cCodPro+" - Quant ["+StrZero(nQtdOrd,10,0)+"] #####")
	
	
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	
	// 23/11/2017 - Atilio - Produto bloqueado. Desbloqueio antes de Integração
	If SB1->B1_MSBLQL == '1'
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '2'
		SB1->( msUnlock() )
		lMsBlq			:= .T.
	Else
		lMsBlq			:= .F.
	EndIf

	//-- Chamada da rotina automatica
	msExecAuto({|x,Y| Mata240(x,Y)},aRotAuto,nOpc)
	
	// 23/11/2017 - Atilio - Produto bloqueado. Bloqueio depois de Integração
	If lMsBlq
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '1'
		SB1->( msUnlock() )
	EndIf

	cHorOrd	:= Time()
	
	cErro := ""
	If lMsErroAuto
		RollBackSX8()
		
		//aRetorno	:= {{"2","Falha no ExecAuto Mata240."}}
		
		cStatus := "2"
		
		//aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""
		cErro += FunName() +" - ExecAuto Mata240" + CRLF
		
		cErro += "Filial  - "+ cFilOrd + CRLF
		cErro += "Doc.    - "+ cNumDoc + CRLF
		cErro += "Produto - "+ cCodPro + CRLF
		cErro += "Lote    - "+ cLotCtl + CRLF
		cErro += "Quant.  - "+ AllTrim(Str(nQtdOrd)) + CRLF
		cErro += "Data    - "+ cDatVld + CRLF
		cErro += " " + CRLF
		
				
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		cErro += MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	        
	        cErro += PadC("Automatic routine ended with error", 80) + " Error: "+ cError
	    EndIf
		
		
		//ConOut( cErro )
		aRetorno	:= {{"2",cErro}}
		
		//cArqLog := FunName() +"-"+ DToS(dDataBase) +"-"+ StrTran(time(),":")+".LOG"
		
		//MemoWrite( cDirLog + cArqLog , cErro)
		
		//cErro	:= cDirLog + cArqLog
		
		//cDocOri	:= cNumDoc
		
	Else
		
		ConfirmSX8()
		
		aRetorno	:= {{"1",IIF(cAcao=="1","Baixa","Geracao")+" de estoque realizada com sucesso."}}
				
		cStatus := "1"
		
		cErro	:= "Fil/Doc/Prod "+cFilOrd + "/" + cNumDoc + "/" + cCodPro
		
		cDocOri	:= cNumDoc
		
	EndIf
	
	cHorOrd	:= Time()
	cTempo	:= ElapTime(cHorIni,cHorOrd)
	
//	nRecMon	:=	U_MGFMONITOR(cFilAnt,cStatus,cCodInt,cCodTpInt,cErro,cDocOri,cTempo)
	
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

If	.F. // lSetEnv

	RpcClearEnv()

EndIf

Return( aRetorno )