#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"           

/*/{Protheus.doc} MGFTAP21
Descricao / Objetivo:   Job para Integração PROTHEUS x Taura - JOB para Consumo sem Saldo e Encerramento de OP
Doc. Origem:            RITM0016473 PRB0040183  processo-produtivo-Taura_Marcelo_Carneiro

@author Marcelo Carneiro
@since 28/10/2019
@version 1.0
@return Nil

@type function
/*/

User Function MGFTAP21()

local cProg        := '01'//aParam[01]

Private _aMatriz   := {"01","010001"}  

Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"

IF lIsBlind
   RpcSetType(3)
   RpcSetEnv(_aMatriz[1],_aMatriz[2])  
   If !LockByName("MGFTAE21_"+cProg)
      Conout("JOB já em Execução : MGFTAE21 " + DTOC(dDATABASE) + " - " + TIME() )
      RpcClearEnv() 
      Return
   EndIf


   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Inicio do processamento - MGFTAP21 - Consumos de Produção - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       
   Proc_Mov() 
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Fim  - MGFTAE21 -  Consumos de Produção- ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       


    conOut("********************************************************************************************************************"+ CRLF)       
    conOut('---------------------- Inicio do processamento - MGFTAP21 - Encerramento de OP - ' + DTOC(dDATABASE) + " - " + TIME()  )
    conOut("********************************************************************************************************************"+ CRLF)       
    Proc_Enc()
    conOut("********************************************************************************************************************"+ CRLF)       
    conOut('---------------------- Fim  - MGFTAE21 -  Encerramento de OP - ' + DTOC(dDATABASE) + " - " + TIME()  )
    conOut("********************************************************************************************************************"+ CRLF) 




EndIF

Return
***********************************************************************************************************************************
Static Function Proc_Mov
    
Local cQryInc, cNumDoc,  aRotAuto
Local aNumDoc	:=  {}
Local nRegQry	:= 0
Local cIdProc	:= ""
Local cIdSeq	:= ""
Local cCodPA	:= ""
Local cArqLog	:= ""
Local cArqThr   := ""
Local cDirLog	:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs
Local nQtdVezes	:= GetMv("MGF_TAP21A",,5)	// Path de gravação de logs
Local aRotThread :={}
Local cFunTAP	:= ""

Private	dMovBlq
Private cTMReq	   := GetMv("MGF_TAP02D",,"555")
Private __cNewArea := GetNextAlias()

SetFunName("MGFTAP21")
cArqLog := FunName() +"-ERRO-"+ DToS(Date()) +"-"+ StrTran(Time(),":")+".LOG"



dbSelectArea("SB1")
SB1->( dbSetOrder(1) )
dbSelectArea("SB2")
SB2->( dbSetOrder(1) )
dbSelectArea("SC2")
SC2->( dbOrderNickName("OPTAURA") )
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
dbSelectArea("SD3")
SD3->( dbSetOrder(2) )


dMovBlq	:= GetMV("MV_DBLQMOV")
dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

cQryInc := "SELECT MAX(ZZE_IDPROC)  MAIOR"+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND ZZE_STATUS = '6' "+CRLF
cQryInc += "	AND ZZE_IDPROC like 'S%' "+CRLF
nRegQry := U_zMontaView( cQryInc, __cNewArea )
If nRegQry > 0 .AND. !Empty((__cNewArea)->MAIOR)
    cIdProc := Soma1((__cNewArea)->MAIOR)
Else    
    cIdProc := 'S'+Replicate("0",TamSX3("ZZE_IDPROC")[1]-1)
    cIdProc := Soma1(cIdProc)
EndIF
    
cIdSeq	:= Replicate("0",TamSX3("ZZE_IDSEQ")[1])

cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
cUpd += "SET ZZE_IDPROC = '"+cIdProc+"', " + CRLF
cUpd += "	 ZZE_IDSEQ = '"+Space(TamSX3("ZZE_IDSEQ")[1])+"' " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_STATUS = '6' "+CRLF
If TcSqlExec( cUpd ) == 0
    If "ORACLE" $ TcGetDB()
        TcSqlExec( "COMMIT" )
    EndIf
else
    RETURN
ENDIF

cQryInc := "SELECT ZZE_FILIAL, ZZE_GERACA, ZZE_EMISSA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_COD, ZZE_LOTECT, ZZE_DTVALI, "+CRLF
cQryInc += "		SUM(ZZE_QUANT) ZZE_QUANT, SUM(ZZE_QTDPCS) ZZE_QTDPCS, SUM(ZZE_QTDCXS) ZZE_QTDCXS, ZZE_LOCAL, ZZE_OPTAUR "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND ZZE_IDPROC = '"+cIdProc+"' "+CRLF
cQryInc += "	AND ZZE_STATUS = '6' "+CRLF
cQryInc += "GROUP BY ZZE_FILIAL, ZZE_GERACA, ZZE_EMISSA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_COD, ZZE_LOTECT, ZZE_DTVALI, ZZE_LOCAL, "+CRLF
cQryInc += "	ZZE_OPTAUR "+CRLF
cQryInc += "ORDER BY 1"+CRLF

nRegQry := U_zMontaView( cQryInc, __cNewArea )
(__cNewArea)->( dbGoTop() )
While !(__cNewArea)->( eof() )

    cCodPA	:= (__cNewArea)->ZZE_CODPA
    cChave	:= (__cNewArea)->(ZZE_FILIAL+ZZE_OPTAUR+ZZE_CODPA)

    If SC2->( dbSeek( cChave ) )

        If !Empty( SC2->C2_DATRF )
            RecLock("SC2",.F.)
            SC2->C2_DATRF	:= CTOD("")
            SC2->( msUnlock() )
        EndIf

        cIdSeq	:= Soma1(cIdSeq)
        cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
        cUpd += "SET ZZE_IDSEQ = '"+cIdSeq+"' " + CRLF
        cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
        cUpd += "	AND ZZE_IDPROC = '"+cIdProc+"' "+CRLF
        cUpd += "	AND ZZE_STATUS = '6' "+CRLF
        cUpd += "	AND ZZE_FILIAL = '"+(__cNewArea)->ZZE_FILIAL+"' "+CRLF
        cUpd += "	AND ZZE_TPOP = '"+(__cNewArea)->ZZE_TPOP+"' "+CRLF
        cUpd += "	AND ZZE_TPMOV = '"+(__cNewArea)->ZZE_TPMOV+"' "+CRLF
        cUpd += "	AND ZZE_GERACA = '"+(__cNewArea)->ZZE_GERACA+"' "+CRLF
        cUpd += "	AND ZZE_EMISSA = '"+(__cNewArea)->ZZE_EMISSA+"' "+CRLF
        cUpd += "	AND ZZE_COD = '"+(__cNewArea)->ZZE_COD+"' "+CRLF
        cUpd += "	AND ZZE_CODPA = '"+(__cNewArea)->ZZE_CODPA+"' "+CRLF
        cUpd += "	AND ZZE_STATUS = '6' "+CRLF
        If !Empty( (__cNewArea)->ZZE_LOCAL )
            cUpd += "	AND ZZE_LOCAL = '"+(__cNewArea)->ZZE_LOCAL+"' "+CRLF
        Else
            cUpd += "	AND ZZE_LOCAL = '"+Space(TamSX3("ZZE_LOCAL")[1])+"' "+CRLF
        EndIf
        If !Empty( (__cNewArea)->ZZE_OPTAUR )
            cUpd += "	AND ZZE_OPTAUR = '"+(__cNewArea)->ZZE_OPTAUR+"' "+CRLF
        Else
            cUpd += "	AND ZZE_OPTAUR = '"+Space(TamSX3("ZZE_OPTAUR")[1])+"' "+CRLF
        EndIf

        If TcSqlExec( cUpd ) == 0
            If "ORACLE" $ TcGetDB()
                TcSqlExec( "COMMIT" )
            EndIf
        EndIf

        SB1->( dbSeek( xFilial("SB1")+(__cNewArea)->ZZE_COD ) )

        If !Empty( (__cNewArea)->ZZE_LOCAL )
            cCodLoc	:= Stuff( Space(TamSX3("ZZE_LOCAL")[1]) , 1 , Len((__cNewArea)->ZZE_LOCAL) , (__cNewArea)->ZZE_LOCAL )
        Else
            cCodLoc	:= SB1->B1_LOCPAD
        EndIf

        cNumOrd	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

        cNumDoc	:= NUMDOCD3(@aNumDoc)

        cFilAnt		:= (__cNewArea)->ZZE_FILIAL
        dDataBase	:= STOD( (__cNewArea)->ZZE_EMISSAO )

        aRotAuto	:= {}

        aAdd( aRotAuto ,	{"D3_FILIAL"	, cFilAnt						,NIL} )
        aAdd( aRotAuto ,	{"D3_TM"		, cTMReq  					    ,NIL} )
        aAdd( aRotAuto ,	{"D3_COD"		, SB1->B1_COD					,NIL} )
        aAdd( aRotAuto ,	{"D3_QUANT"		, (__cNewArea)->ZZE_QUANT		,NIL} )
        aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, (__cNewArea)->ZZE_QTDPCS		,NIL} )
        aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, (__cNewArea)->ZZE_QTDCXS		,NIL} )
        aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
        aAdd( aRotAuto ,	{"D3_LOCAL"		, cCodLoc						,NIL} )
        aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
        aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
        aAdd( aRotAuto ,	{"D3_EMISSAO"	, STOD((__cNewArea)->ZZE_EMISSA),NIL} )
        aAdd( aRotAuto ,	{"D3_ZTIPO"		, (__cNewArea)->ZZE_TPOP		,NIL} )
        If !Empty((__cNewArea)->ZZE_LOTECT) .And. SB1->B1_RASTRO $ "LS"
            aAdd( aRotAuto ,	{"D3_LOTECTL"	, (__cNewArea)->ZZE_LOTECT				,NIL} )
            aAdd( aRotAuto ,	{"D3_DTVALID"	, STOD((__cNewArea)->ZZE_DTVALI)		,NIL} )
        EndIf
        If SB1->B1_LOCALIZ == "S"
            aAdd( aRotAuto ,	{"D3_LOCALIZ"	, SB1->B1_LOCPAD		,NIL} )
        EndIf
        aAdd( aRotAuto , {"D3_ZOPTAUR"	, (__cNewArea)->ZZE_OPTAUR			,NIL} )
        aAdd( aRotAuto , {'__ZTPOP'		, (__cNewArea)->ZZE_TPOP			,NIL} )
        aAdd( aRotAuto , {'__ZTPMOV'	, (__cNewArea)->ZZE_TPMOV			,NIL} )
        aAdd( aRotAuto , {'__ZOPTAURA'	, (__cNewArea)->ZZE_OPTAUR			,NIL} )
        aAdd( aRotAuto , {'__ZCODPA'	, (__cNewArea)->ZZE_CODPA			,NIL} )
        aAdd( aRotAuto , {'__ZIDSEQ'	, cIdSeq							,NIL} )
        aAdd( aRotAuto , {'__ZLOCAL'	, (__cNewArea)->ZZE_LOCAL			,NIL} )
        aAdd( aRotThread , aRotAuto )

        cFunTAP		:= "U_MGFTAP05"
        cOpc		:= "1"
        aParThread	:= { cArqThr , cDirLog , cIdProc , "" }
        
        U_MGFTAP05( {cOpc , aRotThread , aParThread[1] , aParThread[2] , aParThread[3] , aParThread[4]} )

        aRotThread := {}

    EndIf

    (__cNewArea)->( dbSkip() )

EndDo
cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
cUpd += "SET ZZE_RECMON = ZZE_RECMON + 1 " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_IDPROC = '"+cIdProc+"' "+CRLF
cUpd += "	AND ZZE_STATUS = '6' "+CRLF
If TcSqlExec( cUpd ) == 0
    If "ORACLE" $ TcGetDB()
        TcSqlExec( "COMMIT" )
    EndIf
else
    RETURN
ENDIF
cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
cUpd += "SET  ZZE_STATUS='2' , ZZE_DESCER= '[MGFTAP21] Sem Saldo, Reprocessado "+Alltrim(STR(nQtdVezes)) +" vezes'" + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += "	AND ZZE_IDPROC = '"+cIdProc+"' "+CRLF
cUpd += "	AND ZZE_STATUS = '6' "+CRLF
cUpd += "	AND ZZE_RECMON >= "+Alltrim(STR(nQtdVezes)) 
If TcSqlExec( cUpd ) == 0
    If "ORACLE" $ TcGetDB()
        TcSqlExec( "COMMIT" )
    EndIf
ENDIF



    
dbSelectArea(__cNewArea)
dbCloseArea()

Return 
************************************************************************************************************************
Static Function NUMDOCD3() //aNumDoc)

	Local cNumDoc	:= ""
		
	While Empty(cNumDoc) .Or. SD3->( dbSeek( xFilial("SD3")+cNumDoc ) ) 
		cNumDoc	:= GetSXENum("SD3","D3_DOC")
		ConfirmSX8()
	EndDo
	

Return( cNumDoc )

************************************************************************************************************************

/*/{Protheus.doc} Proc_Enc
    Reprocessa os encerramentos a partir do estado de erro quanto
    o valor produzido no Protheus for diferente no Taura
    Origem: RTASK0010122/RITM0016740

    @type  Function
    @author natanael.filho@marfrig.com.br
    @since 29/10/2019
    @version 1
    @param
    @return nil
    /*/

Static Function Proc_Enc()
    Local _lRet         := Nil
    Local _cStusRej     := Alltrim(SuperGetMV("MGF_TAP21B",.T.,'7')) //Estado gravado no ero de processamento do encerramento de OP.
    Local _nQtdVez      := SuperGetMV("MGF_TAP21A",.T.,5) //Quantidade máxima para processamento.
    Local aRotThread    := {}
    Local _cArqLog      := ' ' 
    Local _cQryInc      := ' '  //Query
    Local _cUpd         := ' '  //Update
    Local _cIdProc      := ' '  //Id de processamento
    LocaL _nRegQry      := 0    //Numero de registro retornados na Query
    Local _cDirLog	:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs
    Local _cIdSeq       := ' '
    Local _cArqThr       := ' '

    Private __cNewArea := GetNextAlias()


    SetFunName("MGFTAP21")
    _cArqLog := FunName() +"-ERRO-"+ DToS(Date()) +"-"+ StrTran(Time(),":")+".LOG"

    //Pegar o maior numero de sequencia de processamento.
    _cQryInc := "SELECT MAX(ZZE_IDPROC)  MAIOR"+CRLF
    _cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
    _cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
    _cQryInc += "	AND ZZE_STATUS = '" + _cStusRej + "' " + CRLF //Estado gravado no ero de processamento do encerramento de OP.
    _cQryInc += "	AND ZZE_TPMOV = '"+"04"+"' "+CRLF   //04 = Encerramento de OP.
    _cQryInc += "	AND ZZE_IDPROC like 'S%' "+CRLF     //Definido que haveria S na frente do ID para referenciar os reprocessamentos.
    
    _nRegQry := U_zMontaView( _cQryInc, __cNewArea ) //Executa a Quqer

    If _nRegQry > 0 .AND. !Empty((__cNewArea)->MAIOR)
        _cIdProc := Soma1((__cNewArea)->MAIOR)
    Else    
        _cIdProc := 'S'+Replicate("0",TamSX3("ZZE_IDPROC")[1]-1)
        _cIdProc := Soma1(_cIdProc)
    EndIF

    _cIdSeq	:= Replicate("0",TamSX3("ZZE_IDSEQ")[1])

    
    //Atualiza os registros a serem processamos com o ID de processamento
    _cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
    _cUpd += "SET ZZE_IDPROC = '"+_cIdProc+"', " + CRLF
    _cUpd += "	 ZZE_IDSEQ = '"+Space(TamSX3("ZZE_IDSEQ")[1])+"' " + CRLF
    _cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
    _cUpd += "	AND ZZE_STATUS = '" + _cStusRej + "' " + CRLF //Estado gravado no ero de processamento do encerramento de OP.
    If TcSqlExec( _cUpd ) == 0
        If "ORACLE" $ TcGetDB()
            TcSqlExec( "COMMIT" )
        EndIf
    else
        RETURN
    ENDIF

    //Query para retorno dos registros marcados com o ID de processamento
    _cQryInc := "SELECT ZZE.R_E_C_N_O_ ZZE_RECNO, ZZE.* "+CRLF
    _cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
    _cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
    _cQryInc += "	AND ZZE_STATUS = '" + _cStusRej + "' " + CRLF
    _cQryInc += "	AND ZZE_IDPROC = '" + _cIdProc + "' " + CRLF
    _cQryInc += "ORDER BY 1 "+CRLF


    _nRegQry := U_zMontaView( _cQryInc, __cNewArea )
 
 
    (__cNewArea)->( dbGoTop() )
    While !(__cNewArea)->( eof() )

        //Cria seguencia de processamento para o ID de processamento.
        _cIdSeq	:= Soma1(_cIdSeq)
        _cUpd := "UPDATE "+RetSqlName("ZZE") + " ZZE "  + CRLF
        _cUpd += "SET ZZE_IDSEQ = '"+_cIdSeq+"' " + CRLF
        _cUpd += "WHERE D_E_L_E_T_ = ' ' " + CRLF
        _cUpd += "	AND ZZE.R_E_C_N_O_ = " + Alltrim(Str((__cNewArea)->ZZE_RECNO))   + CRLF

        If TcSqlExec( _cUpd ) == 0
            If "ORACLE" $ TcGetDB()
                TcSqlExec( "COMMIT" )
            EndIf
        EndIf

        cCodPA	:= (__cNewArea)->ZZE_CODPA
        cTpOP	:= (__cNewArea)->ZZE_TPOP

        SC2->( dbOrderNickName("OPTAURA") )
        cChave	:= (__cNewArea)->(ZZE_FILIAL+ZZE_OPTAUR+ZZE_CODPA)

        If SC2->( dbSeek( cChave ) )
                SB1->( dbSeek( xFilial("SB1")+cCodPa ) )

                cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )

                cNumDoc	:= "" // MGFTAP0202(@aNumDoc)

                cFilAnt		:= (__cNewArea)->ZZE_FILIAL
                dDataBase	:= STOD( (__cNewArea)->ZZE_EMISSAO )

                aRotAuto	:= {}

                aAdd( aRotAuto , {'C2_FILIAL'	, (__cNewArea)->ZZE_FILIAL			,NIL} )
                aAdd( aRotAuto , {'C2_NUM'		, Subs(cNumOrd,1,6) 				,NIL} )
                aAdd( aRotAuto , {'C2_SEQUEN'	, Subs(cNumOrd,9,3)					,NIL} )
                aAdd( aRotAuto , {'C2_ITEM'		, Subs(cNumOrd,7,2)					,NIL} )
                aAdd( aRotAuto , {'C2_PRODUTO'	, cCodPA							,NIL} )
                aAdd( aRotAuto , {'C2_QUANT'	, (__cNewArea)->ZZE_QUANT			,NIL} )
                aAdd( aRotAuto , {'__ZTPOP'		, cTPop								,NIL} )
                aAdd( aRotAuto , {'__ZTPMOV'	, (__cNewArea)->ZZE_TPMOV			,NIL} )
                aAdd( aRotAuto , {'__ZNUMOP'	, cNumOrd							,NIL} )
                aAdd( aRotAuto , {'__ZDATOP'	, STOD( (__cNewArea)->ZZE_GERACA )	,NIL} )
                aAdd( aRotAuto , {'__ZDATEM'	, STOD( (__cNewArea)->ZZE_EMISSA )	,NIL} )

                aAdd( aRotAuto , {'__ZIDSEQ'	, _cIdSeq							,NIL} )

                aAdd( aRotThread , aRotAuto )

        Else

            cStatus	:= "2"
            cMsgErr	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
            cMsgArq	:= ""
            cNumOrd	:= ""
            cNumDoc	:= ""
            cDtProc	:= DTOS( Date() )
            cHrProc	:= Time()

            U_MGFTAP14(cStatus,_cIdProc,_cIdSeq,cMsgErr,cMsgArq, cNumOrd,cNumDoc,cDtProc,cHrProc,FunName(),cFilAnt)

        EndIf

            (__cNewArea)->( dbSkip() )

        If Len( aRotThread ) > 0

            cFunTAP		:= "U_MGFTAP07"
            cOpc		:= "1"
            aParThread	:= { _cArqThr , _cDirLog , _cIdProc , "" }
            U_MGFTAP07( {cOpc , aRotThread , aParThread[1] , aParThread[2] , aParThread[3] , aParThread[4]} )

            aRotThread := {}
        EndIf

    EndDo

    //Atualiza o contador de quantidade processada na ZZE
    _cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
    _cUpd += "SET ZZE_RECMON = ZZE_RECMON + 1 " + CRLF
    _cUpd += "WHERE D_E_L_E_T_ = ' ' " + CRLF
    _cUpd += "	AND ZZE_IDPROC = '"+_cIdProc+"' "+CRLF
    _cUpd += "	AND ZZE_FILIAL = '" + xFilial("ZZE") + "' " + CRLF
    If TcSqlExec( _cUpd ) == 0
        If "ORACLE" $ TcGetDB()
            TcSqlExec( "COMMIT" )
        EndIf
    else
        RETURN
    ENDIF
    _cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
    _cUpd += "SET  ZZE_STATUS='2' , ZZE_DESCER='[MGFTAP21] Encerramento divergente, Reprocessado "+Alltrim(STR(_nQtdVez)) +" vezes'" + CRLF
    _cUpd += "WHERE D_E_L_E_T_ = ' ' " + CRLF
    _cUpd += "	AND ZZE_IDPROC = '"+_cIdProc+"' " + CRLF
    _cUpd += "	AND ZZE_FILIAL = '" + xFilial("ZZE") + "' " + CRLF
    _cUpd += "	AND ZZE_RECMON >= " + Alltrim(STR(_nQtdVez)) 
    If TcSqlExec( _cUpd ) == 0
        If "ORACLE" $ TcGetDB()
            TcSqlExec( "COMMIT" )
        EndIf
    ENDIF

    dbSelectArea(__cNewArea)
    dbCloseArea()
                         
Return _lRet