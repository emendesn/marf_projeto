#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

#DEFINE CRLF Chr(13) + Chr(10)

User Function MGFFIS65()
    Local oBrowse

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias('ZGU')
    oBrowse:SetDescription('Registros Movimento XTract')

    oBrowse:AddLegend( "ZGU_STATUS == '1'"  , "GREEN"   , "Gerado xTract" )
    oBrowse:AddLegend( "ZGU_STATUS == '2'"  , "Orange"  , "Gerado Movtos Estoque" )
    oBrowse:AddLegend( "ZGU_STATUS == '3'"  , "RED"     , "Encerrado" )

    oBrowse:Activate()
Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE '&Visualizar'     ACTION 'VIEWDEF.MGFFIS65' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE '&Gerar/Excluir'  ACTION 'U_MGFIS65A'       OPERATION 3 ACCESS 0
    //ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFFIS65' OPERATION 4 ACCESS 0
    //ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFFIS65' OPERATION 5 ACCESS 0
Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
    // Cria a estrutura a ser usada no Modelo de Dados
    Local oStruZGU := FWFormStruct( 1, 'ZGU', /*bAvalCampo*/,/*lViewUsado*/ )
    Local oModel

    // Cria o objeto do Modelo de Dados
    oModel := FWModelActive()
    oModel := MPFormModel():New('XMGFFIS65', /*bPreValidacao*/, /*{ |oModel| FISBIPOS( oModel )}pos valid*/, /*bCommit*/, /*bCancel*/ )

    // Adiciona ao modelo uma estrutura de formulùrio de ediùùo por campo
    oModel:AddFields( 'ZGUMASTER', /*cOwner*/, oStruZGU,  /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

    // Adiciona a descricao do Modelo de Dados
    oModel:SetDescription( 'xTract' )
    oModel:SetPrimaryKey({})

    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZGUMASTER' ):SetDescription( 'Registros xTract' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
    // Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
    Local oModel   := FWLoadModel('MGFFIS65')
    // Cria a estrutura a ser usada na View
    Local oStruZGU := FWFormStruct( 2, 'ZGU' )
    Local oView
    Local cCampos := {}

    // Cria o objeto de View
    oView := FWFormView():New()

    // Define qual o Modelo de dados serù utilizado
    oView:SetModel( oModel )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField('VIEW_ZGU', oStruZGU, 'ZGUMASTER')

    // Criar um "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'TELA' , 100 )

    // Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZGU', 'TELA' )

Return oView


User Function MGFIS65A()

    Local   aSay     := {}
    Local   aButton  := {}
    Local   _nOpc    := 0
    Local   Titulo   := 'IMPORTACAO xTract'
    Local   cDesc1   := 'Esta rotina faz a importacao dos registros do banco xTract conforme parametros'
    Local   cDesc2   := 'informados.'
    Local   cDesc3   := ''
    Local   _lOk     := .T.
    Local   _lOk1    := .T.
    Local   _lRet    := .T.
    Local	_aArea   := getarea()
    Local	_aParam	 := {}
    Local	_aRet	 := {}
    Local aComboMes  := {" ","Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
    Local aComboAno  := {" ","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035"}
    Local _cFil_at   := xFilial("SD3")

    RESTAREA(_aArea)

    //AAdd( _aParam, { 1, "Filial         " , Space( TamSx3("ZH8_FILIAL")[ 01 ] ), "", "ExistCpo('SM0',cEmpAnt+MV_PAR01)", "SM0", "", 015, .T. } )      //MV_PAR01
    AAdd( _aParam, { 1, "Filial         " , _cFil_at , "", "ExistCpo('SM0',cEmpAnt+MV_PAR01)", "SM0", "", 015, .T. } )      //MV_PAR01
    AAdd( _aParam, { 2, "MÍs ReferÍncia " ,1,aComboMes,50,"",.T.})
    AAdd( _aParam, { 2, "Ano ReferÍncia " ,1,aComboAno,50,"",.T.})
    AADD( _aParam, { 3, "Processo       " ,1,{"Gera","Exclui"},40,"",.T.})

    If ParamBox(_aParam, "Informe os par‚metros",@_aRet)
        _nOpc := 1
    else
        return
    EndIf

    Mv_Par01 := _aRet[1]
    Mv_Par02 := _aRet[2]
    Mv_Par03 := _aRet[3]

    IF MV_PAR02='Janeiro'
        MV_PAR02 := "01"
    ELSEIF MV_PAR02=='Fevereiro'
        MV_PAR02 := "02"
    ELSEIF MV_PAR02=='Marco'
        MV_PAR02 := "03"
    ELSEIF MV_PAR02=='Abril'
        MV_PAR02 := "04"
    ELSEIF MV_PAR02=='Maio'
        MV_PAR02 := "05"
    ELSEIF MV_PAR02=='Junho'
        MV_PAR02 := "06"
    ELSEIF MV_PAR02=='Julho'
        MV_PAR02 := "07"
    ELSEIF MV_PAR02=='Agosto'
        MV_PAR02 := "08"
    ELSEIF MV_PAR02=='Setembro'
        MV_PAR02 := "09"
    ELSEIF MV_PAR02=='Outubro'
        MV_PAR02 := "10"
    ELSEIF MV_PAR02=='Novembro'
        MV_PAR02 := "11"
    ELSEIF MV_PAR02=='Dezembro'
        MV_PAR02 := "12"
    ENDIF

    _cPeriodo := MV_PAR03+MV_PAR02  // 042018

    If _cPeriodo < "201804"
        MSGINFO("PerÌodo precisa ser maior que Abril/2018","PerÌodo N„o Permitido")
        Return
    Endif

    If _nOpc == 1
        If  _aRet[4]=2 // Exclusao
            If MSGYESNO("Deseja excluir os registros ref ao perÌodo de "+_cPeriodo+" da filial "+MV_PAR01+" ?","Confirma Exclus„o...")
                ZGU->( DbSetOrder( 3 ) )
                If ZGU->( DbSeek( MV_PAR01 + _cPeriodo ))
                    IF ZGU->ZGU_STATUS == '2'
                        MSGALERT("PerÌodo n„o pode ser excluÌdo, pois j· houve processsamento dos movimentos de estoque.","Exclus„o n„o permitida")
                        _lRet := .f.
                    ElseIf ZGU->ZGU_STATUS == '3'
                        MSGALERT("PerÌodo n„o pode ser excluÌdo, pois j· foi encerrado.","Exclus„o n„o permitida")
                        _lRet := .f.
                    EndIf
                EndIf
                If _lRet = .f.
                    Return
                EndIf
                Processa( { || _lOk1 := fDelReg() },'Aguarde','Excluindo registros do xTract ref. ao periodo de '+subs(_cperiodo,5,2)+'/'+subs(_cperiodo,1,4)+'...',.F.)
                If _lOk1
                    MsgInfo( 'Exclus„o finalizada com sucesso.', 'Finalizado' )
                Else
                    MsgAlert( 'Exclus„o apresentou problemas. Favor verificar...', 'AtenÁ„o!!!' )
                EndIf
            endif
            Return
        Else
            ZGU->( DbSetOrder( 3 ) )
            If ZGU->( DbSeek( MV_PAR01 + _cPeriodo ))
                MSGALERT("PerÌodo j· foi importado. Exclua o perÌodo e gere novamente...","ImportaÁ„o j· realizada!!!")
                Return
            Endif
        EndIf
        Processa( { || _lOk := Runproc() },'Aguarde','Importando registros do xTract...',.F.)
        If _lOk
            ApMsgInfo( 'Processamento terminado com sucesso.', 'ATEN«√O' )
        EndIf
    EndIf

Return NIL

Static Function Runproc()
    Local cQryZH8       := " "
    Local _cAliasXTr    := GetNextAlias()
    Local _nTotReg      := 0
    Local _nContReg     := 0
    Local aResult       := {}
    Local _lRet         := .T.
    local cMsg 		    := ""
    Local _ctime1	    := ""
    Local _ctime2       := ""
    local _ctm1	        := ""
    Local _ctm2	        := ""
    Local _cNum	        := ""
    Local _cDtIni       := ""
    Local _cDtFim       := ""

    _xCodEmp    := ALLTRIM(POSICIONE("ZGJ",1,xFilial("ZGJ")+cFilAnt,"ZGJ_EST"))

    _cDtIni := dtos(FirstDate(stod(_cPeriodo+"01")))
    _cDtFim := dtos(lastday(stod(_cPeriodo+"01")))

    BeginSql Alias _cAliasXTr
        SELECT
            CASE
                WHEN ee.coderp=010003 then '03'
            ELSE
                CAST(ee.coderp AS VARCHAR(2))
            END coderp,
            dcco.codver,
            dcco.codper,
            CAST(dcco.codpro AS CHAR(10)) codpro,
            pa.despro as despro1,
            CAST(dcco.codembins  AS CHAR(10)) codembins,
            pei.despro,
            dcco.codtip,
            nro_Op,
            TO_CHAR(dataop,'YYYYMMDD') dataop,
            sum(dcco.qtdembins) as qtdembins,
            sum(dcco.valembins) as valembins
        FROM cix.demconsumocatop@xtract dcco
            inner join cix.emperp@xtract ee on ee.codemp=dcco.codemp
            inner join cix.prod@xtract pa on pa.codpro=dcco.codpro
            inner join cix.prod@xtract  pei on pei.codpro=dcco.codembins
        WHERE
            dcco.codver=3

            AND ee.coderp = %Exp:_xcodEmp%
            //AND ee.coderp   = '03'

            //AND dataop between to_date(_cDtIni,'YYYYMMDD') and to_date(_cDtFim,'YYYYMMDD')
            //AND dataop between to_date('20180101','YYYYMMDD') and to_date('20180131','YYYYMMDD')
            AND dcco.codper = %Exp:_cPeriodo%
            //AND dcco.codper = '201803'
            //AND dcco.nro_op = %Exp:_cOProducao%
            //AND rownum < 1001
            group by ee.coderp,dcco.codver,dcco.codper,dcco.codpro,pa.despro,dcco.codembins,pei.despro,dcco.codtip,nro_op,dcco.dataop
    EndSql
    DbSelectArea( _cAliasXTr )
    MSAguarde( { || ( _cAliasXTr )->( DbEval( { || _nTotReg++ } ) ) }, "Aguarde...", "Contando registros do XTract" )
    ( _cAliasXTr )->( DbGoTop() )
    If _nTotReg == 0
        MsgAlert("N„o existem registros no xTract. Favor verificar os par‚metros ou acionar o respons·vel pela geraÁ„o dos dados no xTract !!! ","AtenÁ„o !!!")
        Return( .f. )
    Endif

    _cNum := GetSXENum("ZGU","ZGU_CODIGO")
    
    Begin Transaction
        ZGU->(RECLOCK("ZGU",.T.))
        ZGU->ZGU_FILIAL	:= xFilial("ZGU")
        ZGU->ZGU_CODIGO	:= _cNUM
        ZGU->ZGU_PERIOD := _cPeriodo
        ZGU->ZGU_USER	:= Alltrim(UsrRetName(RetCodUsr()))
        ZGU->ZGU_NUSER	:= Alltrim(UsrFullName(RetCodUsr()))
        ZGU->ZGU_DTPROC	:= DDATABASE
        ZGU->ZGU_HRPROC	:= Left(Time(),05)
        ZGU->ZGU_STATUS	:= "1"
        ZGU->(MSUNLOCK())
    End Transaction
    _ctime1 := time()
    _ctm1	:= time()

    ProcRegua(_nTotReg)

    While ( _cAliasXTr )->( !Eof() )

        Begin Transaction
            ZH8->(RECLOCK("ZH8",.T.))
            ZH8->ZH8_FILIAL  := xFilial("ZH8") //_oModZGU:GetValue("ZGU_FILIAL")
            ZH8->ZH8_CODIGO  := ZGU->ZGU_CODIGO //"000002" //_oModZGU:GetValue("ZGU_CODIGO")
            ZH8->ZH8_PERIOD  := _cPeriodo // "201803" //_oModZGU:GetValue("ZGU_PERIOD")
            ZH8->ZH8_CODPRO  := ( _cAliasXTr )->CODPRO+"     "
            ZH8->ZH8_NOMPRO  := ( _cAliasXTr )->DESPRO1
            ZH8->ZH8_CODINS  := ( _cAliasXTr )->CODEMBINS+"     "
            ZH8->ZH8_NOMINS  := ( _cAliasXTr )->DESPRO
            ZH8->ZH8_CODTIP  := alltrim(str(( _cAliasXTr )->CODTIP))
            ZH8->ZH8_NROP    := alltrim(str(( _cAliasXTr )->NRO_OP))
            ZH8->ZH8_DATOP   := STOD( ( _cAliasXTr )->DATAOP)
            ZH8->ZH8_QEMBIN  := ( _cAliasXTr )->QTDEMBINS
            ZH8->ZH8_VEMBIN  := ( _cAliasXTr )->VALEMBINS
            ZH8->(MSUNLOCK())
        End Transaction
        if (_nContReg % 10000) = 0
            _ctime2 := time()
            _ctime1 := time()
        endif
        DbSelectArea( _cAliasXTr )
        ( _cAliasXTr )->( DbSkip() )
        _nContReg++

        IncProc("Importando Registro "+cValtoChar(_nContReg)+" de um total de "+cValtoChar(_nTotReg)+" registros")

    EndDo
    _ctm2 := time()
    ( _cAliasXTr )->(DbCloseArea())
    cMsg += " "+CRLF
    cMsg += " "+CRLF
    cMsg += " ImportaÁ„o Realizada Por : "+Alltrim(UsrFullName(RetCodUsr()))+CRLF
    cMsg += " ImportaÁ„o Realizada Em  : "+dtoc(dDatabase)+CRLF
    cMsg += " Filial                   : "+MV_PAR01 +CRLF
    cMsg += " PerÌodo                  : "+_cPeriodo +CRLF
    cMsg += " Total de Registros       : "+cValtochar(_nTotReg)+CRLF
    cMsg += " Inicio ImportaÁ„o        : "+_ctm1 + CRLF
    cMsg += " Fim da ImportaÁ„o        : "+_ctm2 + CRLF
    cMsg += " Tempo total              : "  +elaptime(_ctm1 , _ctm2) + CRLF

    StaticCall( MGFEEC64 , showLog , cMsg , "Tempo de ImportaÁ„o Registros xTract" , "" )

Return( _lRet )


Static function fDelReg()
    Local cDelZGU	:= ""
    Local cDelZH8	:= ""
    Local _lRet     := .t.

    cDelZH8 := "DELETE FROM " + RetSqlname("ZH8")							+ CRLF
    cDelZH8 += " WHERE"														+ CRLF
    cDelZH8 += " 		ZH8_FILIAL	=	'" + MV_PAR01 + "'"		        	+ CRLF
    cDelZH8 += " 	AND	ZH8_PERIOD	=	'" + _cPeriodo + "'" 		    	+ CRLF
    if tcSQLExec( cDelZH8 ) < 0
        conout("N„o foi possÌvel executar DELETE no ZH8." + CRLF + tcSqlError())
        _lRet := .f.
        Return(_lRet)
    endif

    cDelZGU := "DELETE FROM " + RetSqlname("ZGU")							+ CRLF
    cDelZGU += " WHERE"														+ CRLF
    cDelZGU += " 		ZGU_FILIAL	=	'" + MV_PAR01 + "'"		        	+ CRLF
    cDelZGU += " 	AND	ZGU_PERIOD	=	'" + _cPeriodo + "'" 		    	+ CRLF
    if tcSQLExec( cDelZGU ) < 0
        conout("N„o foi possÌvel executar DELETE ZGU." + CRLF + tcSqlError())
        _lRet := .f.
    endif

Return(_lRet)
