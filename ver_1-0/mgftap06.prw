#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFTAP06
Autor....:              Atilio Amarilla
Data.....:              08/11/2016
Descricao / Objetivo:   Integração PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada de execautos MATA685 Apontamento de Perdas
=====================================================================================
*/                                            
User Function xMGFTAP06                                                                                                                                
Local aRetFuncao := {}

aRetFuncao	:= U_MGFTAP06(	{	'020001',;
								'73154251258431887'		,;
								'11'	,;
								'2017-05-25',;
								'2017-05-25'	,;
								'09:00:00'	,;
								'301400',;
								'008900',;
								104.565,;
								''	,;
								''	,;
								5	,;
								5,;
								'1705241112580'} )	// Passagem de parâmetros para 



return


User Function MGFTAP06( aParam )

// aParam - { D3_FILIAL	, D3_IDTAURA	, D3_TPOP	, D3_GERACAO	, D3_EMISSAO	,D3_ZHORA	,D3_CODPA	,D3_COD		,D3_QUANT	, D3_LOTECTL	,;
//				D3_DTVALID	,D3_ZQTDPCS	,	D3_ZQTDCXS }

Local aRetorno	:= {{"1",""}}
Local aRotAuto	:= {}
Local cError     := ''
Local nOpc		:= 3

Local dDatIni	:= Date()
Local cHorIni	:= Time()
Local cHorOrd, nI

Local cFilOrd	:= aParam[1]
Local cIdTaura	:= aParam[2]
Local cTpOrd	:= aParam[3]
Local cDatOrd	:= StrTran(aParam[4],"-")
Local cDatEmi	:= StrTran(aParam[5],"-")
Local cHorEmi	:= aParam[6]
Local cCodPA	:= aParam[7]
Local cCodPro	:= aParam[8]
Local nQtdOrd	:= aParam[9]
Local cLotCtl	:= aParam[10]
Local cDatVld	:= aParam[11]
Local nQtdPcs	:= aParam[12]
Local nQtdCxs	:= aParam[13]
Local cOpTaura	:= aParam[14]

Local aErro, cErro, cArqLog

Local cNumOrd

Local cCodInt, cCodTpInt, cDirLog, cTipInd, cChave, cEndPad

Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SC2" , "SBC" , "SC2" , "SZ1" , "SZ2" , "SZ3" }

Private 	lMsHelpAuto := .T.
Private 	lMsErroAuto := .F.





// Seta job para nao consumir licenças
//RpcSetType(3)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparação do Ambiente.                                                                                  |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If Select("SX3")==0

	lSetEnv	:= .T.
	
	RpcSetEnv( "01" , cFilOrd , Nil, Nil, "PCP" ) // , Nil, aTables )
	

Else

	lSetEnv	:= .F.

EndIf

SetFunName("MGFTAP06")

cCodInt	:= GetMv("MGF_TAP06A",,"001") // Taura Produção
cCodTpInt	:= GetMv("MGF_TAP06B",,"004") // Inclusão OP

cDirLog		:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs
cTipInd		:= GetMv("MGF_TAP02P",,"11/12/")		// Tipo OP Industrializado.

cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integração Taura Produção
cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad ) 


cFilAnt		:= cFilOrd
//dDataBase	:= STOD(cDatEmi)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Seleção de Tabelas / Índices                                                                             |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SBC")
dbSetOrder(1)

dbSelectArea("SC2")
SC2->( dbSetOrder(9) ) // C2_FILIAL+C2_NUM+C2_ITEM+C2_PRODUTO

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Seleção de Tabelas / Índices                                                                             |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cTpOrd	:= Stuff( Space(TamSX3("C2_ITEM")[1]) , 1 , Len(cTpOrd) , cTpOrd )
cCodPro	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(cCodPro) , cCodPro )

If Empty( SToD(cDatOrd) )
	aRetorno	:= {{"2","Data da OP Inválida: "+AllTrim(cDatOrd)}}
EndIf

If Empty( aRetorno[1][2] ) .And. Empty( SToD(cDatEmi) )
	aRetorno	:= {{"2","Data do movimento Inválida: "+AllTrim(cDatEmi)}}
EndIf

If Empty( aRetorno[1][2] ) .And. Empty( cOpTaura )
	aRetorno	:= {{"2","OP em Branco"}}
EndIf

If Empty( aRetorno[1][2] ) .And. !SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
	aRetorno	:= {{"2","Código de Produto inválido: "+AllTrim(cCodPro)}}
EndIf

If Empty( aRetorno[1][2] )
	cFilOrd		:= Stuff( Space(TamSX3("C2_FILIAL")[1]) , 1 , Len(cFilOrd) , cFilOrd )
	cOpTaura	:= Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len(cOpTaura) , cOpTaura )
	cCodPA 		:= Stuff( Space(TamSX3("C2_PRODUTO")[1]) , 1 , Len(cCodPA) , cCodPA )
	If cTpOrd $ cTipInd
		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= cFilOrd+cOpTaura
	Else
		SC2->( dbSetOrder(9) ) // C2_FILIAL+C2_NUM+C2_ITEM+C2_PRODUTO
		cChave	:= cFilOrd+Subs(cDatOrd,3,6)+cTpOrd+cCodPA
	EndIf
		
	If !SC2->( dbSeek( cChave ) )
//	If !SC2->( dbSeek( cFilOrd+Subs(cDatOrd,3,6)+cTpOrd+cCodPA ) )
		aRetorno	:= {{"2","OP não localizada. Fil/Num/Tipo/Prod: "+AllTrim(cFilOrd)+"/"+AllTrim(Subs(cDatOrd,3,6))+"/"+AllTrim(cTpOrd)+"/"+AllTrim(cCodPA)}}
	Else
		cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
		cNumOrd	:= Stuff( Space(TamSX3("BC_OP")[1]) , 1 , Len(cNumOrd) , cNumOrd )
		SC2->( dbSetOrder(1) )
		SC2->( dbGoTop() )
	EndIf
EndIf

If Empty( aRetorno[1][2] )
	
	//ConOut("## MGFTAP06 Filial "+cFilOrd+" - cNumOrd "+cNumOrd+" - Produto "+cCodPro+" - Quant ["+StrZero(nQtdOrd,10,0)+"] #####")
	
	
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	
	SX1->( dbSetORder(1))
	If SX1->( DbSeek(PadR( "MTA685" , Len(SX1->X1_GRUPO)) + "01" ))
		Reclock("SX1",.F.)
	//	SX1->X1_PRESEL := 2
		SX1->( msUnlock() )
	EndIf
	
	mv_par01 := 2

	_aCabec		:= {}
	_aLinha		:= {}
	_aItens		:= {}
	
	//aAdd( _aCabec ,	{"BC_FILIAL"	, cFilOrd		,NIL} )
	aAdd( _aCabec ,	{"BC_OP"		, cNumOrd		,NIL} )

	aAdd( _aLinha ,	{"BC_PRODUTO"	, cCodPro		,NIL} )
	aAdd( _aLinha ,	{"BC_QUANT"		, nQtdord	,NIL} )
	aAdd( _aLinha ,	{"BC_LOCORIG"	, SB1->B1_LOCPAD			,NIL} )
	aAdd( _aLinha ,	{"BC_TIPO" 		 ,"R" 			,NIL})
	aAdd( _aLinha ,	{"BC_MOTIVO" 	 ,"PP"    		,NIL})
	aAdd( _aLinha ,	{"BC_DATA"		, dDataBase				,NIL} )    


	If !Empty(cLotCtl) .And. SB1->B1_RASTRO $ "LS"
		aAdd( _aLinha ,	{"BC_LOTECTL"	, cLotCtl		,NIL} )
		//aAdd( _aLinha ,	{"BC_DTVALID"	, STOD(cDatVld),NIL} )
	EndIf
	
	If SB1->B1_LOCALIZ == "S"
		aAdd( _aLinha ,	{"BC_LOCALIZ"	, cEndPad		,NIL} )
	EndIf


	aAdd( _aItens , _aLinha )

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
	msExecAuto({|x,y,z| Mata685(x,y,z)},_aCabec,_aItens,3)
	
	// 23/11/2017 - Atilio - Produto bloqueado. Bloqueio depois de Integração
	If lMsBlq
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '1'
		SB1->( msUnlock() )
	EndIf

	cHorOrd	:= Time()
	
	cErro := ""
	If !lMsErroAuto
	     aRetorno	:= {{"1","Integrado com Sucesso"}}
    Else
		//aRetorno	:= {{"2","Falha no ExecAuto Mata685."}}
		/*
		cErro := MostraErro()
		
		Conout( cErro )
		*/
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""
		cErro += FunName() +" - ExecAuto Mata685" + CRLF
		
		cErro += "Filial  - "+ cFilOrd + CRLF
		cErro += "Ordem   - "+ cNumOrd + CRLF
		cErro += "Produto - "+ cCodPro + CRLF
		cErro += "Data    - " + DTOC(STOD(cDatEmi)) + CRLF
		cErro += " " + CRLF
		/*
		for nI := 1 to len(aErro)
		cErro += aErro[nI] + CRLF
		next nI
		*/
		
		
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		cErro += MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	        
	        cErro += PadC("Automatic routine ended with error", 80) + " Error: "+ cError
	    EndIf
	
		
		
		aRetorno := {{"2",cErro}}
		
		cArqLog := FunName() +"-"+ DToS(dDataBase) +"-"+ StrTran(time(),":")+".LOG"
		
		MemoWrite( cDirLog + cArqLog , cErro)
		
		cErro	:= cDirLog + cArqLog
		
		cDocOri	:= cLotCtl
		
		cTempo	:= ElapTime(cHorIni,cHorOrd)
		
		//U_MGFMONITOR(cFilAnt,"2",cCodInt,cCodTpInt,cErro,cDocOri,cTempo)
		
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

//	Else
		
//		cErro	:= "Fil/OP/Prod "+cFilOrd + "/" + cNumOrd + "/" + cNumOrd + "/" + cCodPro
		
//		cDocOri	:= cNumOrd
		
//		cTempo	:= ElapTime(cHorIni,cHorOrd)
		
//		U_MGFMONITOR(cFilAnt,"1",cCodInt,cCodTpInt,cErro,cDocOri,cTempo)
		
	EndIf
	
EndIf

If	.F. // lSetEnv

	RpcClearEnv()

EndIf

Return( aRetorno )