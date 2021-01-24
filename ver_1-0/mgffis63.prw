#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

#DEFINE CRLF Chr(13) + Chr(10)

/*/
{Protheus.doc} MGFFIS63
Função responsável por processar as ordens de produção e grava na tabela ZGU, ZH8 e ZH9
@type  User Function
@author André Fracassi
@author Wagner Neves
@since 27/08/2020
@version P12 12.1.17
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
@table ZGU
@history
@obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
@menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
User Function MGFFIS63()

    Local _oBrowse

    //Instanciamento da Classe de Browse
    _oBrowse := FWMBrowse():New()
    //Definição da tabela do Browse
    _oBrowse:SetAlias("ZGU")

    //Definição do título do browser
    _oBrowse:SetDescription("Cabeçalho de Processamento")

	_oBrowse:AddLegend( "ZGU_STATUS == '1'"  , "GREEN"   , "Gerado xTract" )
	_oBrowse:AddLegend( "ZGU_STATUS == '2'"  , "Orange"    , "Gerado Movtos Estoque" )
	_oBrowse:AddLegend( "ZGU_STATUS == '3'"  , "RED"    , "Encerrado" )

    _oBrowse:Activate()

Return

/*/
    {Protheus.doc} MenuDef
    Funcao para definição de opções do menu
    @type  Static Function
    @author André Fracassi
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param param_name, param_type, param_descr
    @return _aRotina, Array, Retorna array contendo as opções de menu
    @example
    (examples)
    @see (links_or_references)
    @table ZGU
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function MenuDef()

    Local _aRotina := {}
    
    ADD OPTION _aRotina TITLE "Gerar/Mantem Movto"  ACTION "VIEWDEF.MGFFIS63"   OPERATION 4 ACCESS 0
    ADD OPTION _aRotina TITLE "Visualizar"   ACTION "VIEWDEF.MGFFIS63"   OPERATION 2 ACCESS 0
    //ADD OPTION _aRotina TITLE "Alterar"      ACTION "VIEWDEF.MGFFIS63"   OPERATION 4 ACCESS 0
    ADD OPTION _aRotina TITLE "Excluir"      ACTION "VIEWDEF.MGFFIS63"   OPERATION 5 ACCESS 0
Return( _aRotina )

/*/
    {Protheus.doc} ModelDef
    Funcao para criação de definicao de modelo
    @type  Static Function
    @author André Fracassi
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @table ZGU, ZH8, ZH9
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function ModelDef()

    Local _oModel
    Local _oStruZGU := FWFormStruct( 1, "ZGU", /*bAvalCampo*/, /*lViewUsado*/ )
    Local _oStruZH9 := FWFormStruct( 1, "ZH9", /*bAvalCampo*/, /*lViewUsado*/ )

    Local _nOperation

    _oModel     := MPFormModel():New('xMGFFIS63', /*bMPFormModelo*/, /*bPosValidacao*/, { |_oMdl| FIS63Commit( _oMdl ) } /*bCommit*/, /*bCancel*/ )
    _nOperation := _oModel:GetOperation()

    _oModel:AddFields("ZGUMASTER", /*cOwner*/, _oStruZGU )

    _oModel:AddGrid("ZH9DETAIL", "ZGUMASTER", _oStruZH9, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

    // Faz relaciomaneto entre os compomentes do model
    _oModel:SetRelation("ZH9DETAIL", { { "ZH9_FILIAL", 'xFilial("ZH9")' }, { "ZH9_CODIGO", "ZGU_CODIGO" } }, ZH9->( IndexKey( 2 ) ) )

    _oModel:SetPrimaryKey( { "ZGU_FILIAL", "ZGU_CODIGO", "ZGU_PERIOD" } )

    // Determina se é opcional a inserção de detalhe
    _oModel:GetModel("ZH9DETAIL"):SetOptional( .T. )

    _oModel:GetModel("ZH9DETAIL"):SetMaxLine(900000)//   -> Determina quantas linhas uma grid pode possuir;

    _oModel:GetModel("ZH9DETAIL"):GetMaxLine(900000)//   -> Retorna quantas linhas o grid pode possuir.

    // Adiciona a descricao do Modelo de Dados
    _oModel:GetModel("ZGUMASTER"):SetDescription( "Cabeçalho de Processamento" )
    _oModel:GetModel("ZH9DETAIL"):SetDescription( "Pós Processamento (Destino SAFX10)" )

    // Valida antes da ativação do model
    _oModel:SetVldActive( { |_oModel| FIS63VldAct( _oModel ) } )

    // Valida a ativação do model
    _oModel:SetActivate( { |_oModel| FIS63SetAct( _oModel ) } )

Return( _oModel )

/*/
    {Protheus.doc} ViewDef
    Funcao para criação de definicao de visualização
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @table ZGU, ZH8, ZH9
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function ViewDef()

    Local _oView
    Local _oModelVd	    := FWLoadModel("MGFFIS63") //ModelDef()
    Local _nOperation 	:= _oModelVd:GetOperation()
    Local _oStruZGU 	:= FWFormStruct( 2, "ZGU" )
    Local _oStruZH9 	:= FWFormStruct( 2, "ZH9" )

    // Cria o objeto de View
    _oView := FWFormView():New()
    _oView:SetModel( _oModelVd )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    _oView:AddField("VIEW_ZGU", _oStruZGU, "ZGUMASTER" )
    If _nOperation == MODEL_OPERATION_UPDATE
        _oStruZGU:SetProperty("ZGU_PERIOD", MVC_VIEW_CANCHANGE, .F.)
    EndIf

    _oView:AddGrid("VIEW_ZH9", _oStruZH9, "ZH9DETAIL" )

    //Remove os campos que não devem aparecer na janela
    _oStruZH9:RemoveField("ZH9_CODIGO")
    _oStruZH9:RemoveField("ZH9_PERIOD")

    //Criar um "box" horizontal para receber algum elemento da view
    _oView:CreateHorizontalBox("SUPERIOR",  20 )
    _oView:CreateHorizontalBox("INFERIOR2", 80 )

    //Relaciona o ID da View com o "box" para exibicao
    _oView:SetOwnerView("VIEW_ZGU", "SUPERIOR" )
    _oView:SetOwnerView("VIEW_ZH9", "INFERIOR2" )


    //Liga a identificacao do componente
    _oView:EnableTitleView("VIEW_ZGU", "Cabeçalho de Processamento" )
    _oView:EnableTitleView("VIEW_ZH9", "Pós Processamento (Destino SAFX10)" )

    //Força o fechamento da janela na confirmação
    _oView:SetCloseOnOk( { || .T. } )

Return( _oView )



/*/
    {Protheus.doc} FIS63VldAct
    Validação antes da ativação do model antes de apresentação da interface
    Valida se pode ser excluído Processamento Dados SAFX10
    @type  Static Function
    @author André Fracassi
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _oMdl, Objeto   , Nome do Objeto
    @return     _lRet, Boolean  , True/False para controle de exclusão
    @example
    (examples)
    @see (links_or_references)
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function FIS63VldAct( _oMdl )

    Local _lRet			:= .T.
    Local _nOperation 	:= _oMdl:GetOperation()
    Local _cTxtOperac   := "Processamento" //IIf( _nOperation == MODEL_OPERATION_INSERT, "Processamento", "Reprocessamento")
    Local _cTitPerg     := "Parâmetros " + _cTxtOperac

    Private _aRet       := {}
    Private _aParam     := {}

    // Validando Regras de Exclusao, Reprocessamento
    If _nOperation == MODEL_OPERATION_DELETE                //Exclusão
        If ZGU->ZGU_STATUS = "3"            //1=Pre Processado;2=Reprocessado;3=Encerrado
            Help( " ", 1, "Período encerrado", ,"Período já Encerrado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Período já foi encerrado. Não será permitida qualquer interferência."} /*aSoluc*/ )
            _lRet := .F.
        EndIf
        If ZGU->ZGU_STATUS = "1"            //1=Pre Processado;2=Reprocessado;3=Encerrado
            Help( " ", 1, "Estoque ainda não gerado", ,"Estoque ainda não gerado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Estoque ainda não gerado. Exclua pela rotina de geração de xTract."} /*aSoluc*/ )
            joj_lRet := .F.
        EndIf
    ElseIf _nOperation == MODEL_OPERATION_UPDATE            //Alteração
        //If ZGU->ZGU_STATUS $ "1"   // Gerado somente xtract
        //    Help( " ", 1, "Movimento de estoque não foi processado..", ,"Período não foi processado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Os movimentos de estoque desse período precisam ser gerados.."} /*aSoluc*/ )
        //    _lRet := .F.
        //Endif
        If ZGU->ZGU_STATUS = "3"            //1=Pre Processado;2=Reprocessado;3=Encerrado
            Help( " ", 1, "Período encerrado", ,"Período já Encerrado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Período já foi encerrado. Não será permitida qualquer interferência."} /*aSoluc*/ )
            _lRet := .F.
        EndIf
    ElseIf _nOperation == MODEL_OPERATION_INSERT             //Pre Processamento
        If ZGU->ZGU_STATUS $ "2"            //1=Pre Processado;2=Reprocessado;3=Encerrado            
            Help( " ", 1, "Período já processado...", ,"Período já foi processado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Esse período somente poderá ser alterado.."} /*aSoluc*/ )
            _lRet := .F.
        ELSEIf ZGU->ZGU_STATUS = "3"            //1=Pre Processado;2=Reprocessado;3=Encerrado
            Help( " ", 1, "Período encerrado", ,"Período já Encerrado", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Período já foi encerrado. Não será permitida qualquer interferência."} /*aSoluc*/ )
            _lRet := .F.
        ELSEIF ZGU->ZGU_STATUS $ "1"
            IF MSGYESNO("Gera movimentos de estoque da filial "+ZGU->ZGU_FILIAL+", período "+SUBS(ZGU->ZGU_PERIODO,5,2)+"/"+SUBS(ZGU->ZGU_PERIODO,1,4)+" ?","Gera Movimento de Estoque")
                DbSelectArea("ZGU")
                ZGU->( DbSetOrder( 3 ) )
                If ! ZGU->( DbSeek( ZGU->ZGU_FILIAL+ZGU->ZGU_PERIOD) ) .AND.  _nOperation == MODEL_OPERATION_INSERT
                    _lRet := .f.
                EndIf
            Else
                _lRet := .F.
            EndIf
        EndIf
    EndIf
Return( _lRet )

/*/
    {Protheus.doc} FIS63SetAct
    Validação após a ativação do model antes de apresentação da interface
    Carrega parâmetros iniciais para Processamento
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _oMdl, Objeto   , Nome do Objeto
    @return     _lRet, Boolean  , True/False para controle de exclusão
    @example
    (examples)
    @see (links_or_references)
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function FIS63SetAct( _oMdl )

    Local _lRet         := .T.
    Local _nOperation 	:= _oMdl:GetOperation()
    Local _cTxtOperac   := "Processamento" //IIf( _nOperation == MODEL_OPERATION_INSERT, "Processamento", "Reprocessamento")
    Local _cFilProc     := CriaVar("ZGU_FILIAL", .F. )
    Local _cPerProc     := CriaVar("ZGU_PERIOD", .F. )
  
    Private _oModZGU    := _oMdl:GetModel("ZGUMASTER")
    Private _oModZH9	:= _oMdl:GetModel("ZH9DETAIL")
    Private _oProcess
    // Valida se operação é Reprocessamento
    If _nOperation == MODEL_OPERATION_INSERT
        _oModZGU:SetValue("ZGU_CODIGO"  , ZGU->ZGU_CODIGO                       )
        _oModZGU:SetValue("ZGU_PERIOD"  , ZGU->ZGU_PERIOD                       )
        _oModZGU:SetValue("ZGU_USER"    , Alltrim(UsrRetName(RetCodUsr()))      )
        _oModZGU:SetValue("ZGU_NUSER"   , AllTrim( UsrFullName( RetCodUsr() ) ) )
        _oModZGU:SetValue("ZGU_STATUS"  , "2"                                   )

        // Definindo conteudo das variavies para processamento
        _cFilProc := ZGU->ZGU_FILIAL
        _cPerProc := ZGU->ZGU_PERIOD
    ElseIf _nOperation == MODEL_OPERATION_UPDATE
        _cFilProc := _oModZGU:GetValue("ZGU_FILIAL")
        _cPerProc := _oModZGU:GetValue("ZGU_PERIOD")
    EndIf

    //If _nOperation == MODEL_OPERATION_INSERT //.Or. _nOperation == MODEL_OPERATION_UPDATE
    If _nOperation == MODEL_OPERATION_UPDATE //.Or. _nOperation == MODEL_OPERATION_UPDATE
        _oProcess := MsNewProcess():New( { || FIS62Proc( _cFilProc, _cPerProc, _oProcess, _oMdl ) }, "Processando...", "Aguarde " + _cTxtOperac + " dos dados",.T. )
        _oProcess:Activate()
    EndIf

Return( _lRet )

/*/
    {Protheus.doc} FIS63Commit
    Validação após finalizado o modelo
    Define Status do Processamento
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _oMdl, Objeto   , Nome do Objeto
    @return     _lRet, Boolean  , True/False para controle de exclusão
    @example
    (examples)
    @see (links_or_references)
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function FIS63Commit( _oMdl )

    Local _lRet := .T.
	local _nOper		:= _oMdl:getOperation()
    LOCAL _nRec         := 0
    Local _cChave       := ""

   If FWFormCommit(_oMdl)
        _nRec := ZGU->(recno())
        IF _nOper = 3
            // DEIXA INCLUIR MAS DELETA OUTROS STATUS
            _cChave := ZGU->(ZGU_FILIAL+ZGU_CODIGO+ZGU_PERIOD)
            ZGU->(DbSetOrder(1))
            ZGU->(DBGOTOP())
            ZGU->(DbSeek(_cChave))
            While ZGU->(!Eof()) .and. _cChave == ZGU->(ZGU_FILIAL+ZGU_CODIGO+ZGU_PERIOD)
                if ZGU->ZGU_STATUS <> "2"
                    ZGU->(RecLock("ZGU",.F.))
                    ZGU->(DBDELETE())
                    ZGU->(MSUNLOCK())
                EndIf

                ZGU->(DBSKIP())
            enddo
            ZGU->(DBGOTO(_nrec))
        elseif _nOper = 4
            ZGU->(RecLock("ZGU",.F.))
            ZGU->ZGU_STATUS := "2"
            ZGU->(MSUNLOCK())
        elseif _nOper = 5
            // RECUPERA O REGISTRO DELETADO E MUDA STATUS PARA 1
            ZGU->(RecLock("ZGU",.F.))
            ZGU->(DBRECALL())
            ZGU->ZGU_STATUS := "1"
            ZGU->(MSUNLOCK())
        endif
   endif
Return( _lRet )


/*/
    {Protheus.doc} FIS62Proc
    Retorna informações de produção do xtract e gera dados para geração do safx10
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _cParam01, Caracter, Filial
    @param      _cParam02, Caracter, Periodo
    @param      _oParam03, Objeto, Objeto de Processamento
    @param      _oParam04, Objeto, Objeto Modelo ZGU
    @return     _lRet, Boolean  , True/False para controle de processamento
    @example
    (examples)
    @see (links_or_references)
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function FIS62Proc( _cParam01, _cParam02, _oParam03, _oParam04 )

    Local _lRet      := .F.
    Local _cFilDe    := _cParam01
    Local _cPeriodo  := _cParam02
    Local _oObjProc  := _oParam03
    Local _oModZGU   := _oParam04:GetModel("ZGUMASTER")
    Local _oModZH9   := _oParam04:GetModel("ZH9DETAIL")
    Local _lFez      := .f.

    //Retornando dados do XTract
    _oObjProc:SetRegua1( 1 )
    _oObjProc:SetRegua2( 2 )
      
    //Processando dados para xtract        
    //_oObjProc:IncRegua1("Processando Dados" + cValToChar( 1 ) + " de " + cValToChar( 3 ) )
    If loadSAFXZHA( _cFilDe, _cPeriodo, _oObjProc, /*_oModZHA*/ , _oModZGU ,@_lFez)
        //Processando dados movimentação de estoque sintetico
        //If genSAFX10( _cFilDe, _cPeriodo, _oObjProc, _oModZH9, _oModZGU ,@_lFez)
            
           _lRet := .T.
        //EndIf
    
    EndIf
    if _lFez
        ZGU->(RecLock("ZGU",.F.))
        ZGU->ZGU_STATUS := "2"
        ZGU->(MSUNLOCK())
        
        _oModZH9:DeActivate()
        _oModZH9:Activate()
    endif
Return( _lRet )

/*/
    {Protheus.doc} genSAFSD3
    Processa dados dos movimentos da SD3
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _cParam01, Caracter, Filial
    @param      _dParam02, Date, Data
    @param      _oParam03, Objeto, Objeto de Processamento
    @param      _oParam04, Objeto, Objeto Modelo ZGU
    @return     _lRet, Boolean  , True/False para controle de processamento
    @example
    (examples)
    @see (links_or_references)
    @table ZHA
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function loadSAFxZHA( _cParam01, _dParam02, _oParam03, _oParam04, _oParam05 ,_lFez )
    Local _oModel 	:= FwModelActive()
    Local _lRet         := .T.
    Local _cFilDe       := _cParam01
    Local _dPeriodo     := _dParam02
    Local _oObjProc     := _oParam03
//    Local _oModZHA      := _oModel:GetModel("ZHADETAIL")
    Local _oModZGU      := _oModel:GetModel("ZGUMASTER")
    Local _cAliasZHA    := GetNextAlias()
    Local _cCodigo      := ""
    Local _cQuebra      := ""
    Local _cIn          := ""
    Local _cPrimeira    := ""    

    Local _nTotReg      := 0
    Local _nContReg     := 0
    Local _nContZH9     := 0

    //_oModZHA:SetNoUpdateLine( .F. )
    //_oModZHA:SetNoDeleteLine( .F. )

    // Logica de processamento para geração dos dados da SD3
    _oObjProc:SetRegua2( 1 )
    _oObjProc:IncRegua2("Selecionando Registros Movimentos Estoque....." ) 

    _cCodigo    := _oModZGU:GetValue("ZGU_CODIGO")
    _dPeriodo   := _oModZGU:GetValue("ZGU_PERIOD")

/*    BeginSql Alias _cAliasZHA
        SELECT ZHA.ZHA_CODIGO
            FROM %table:ZHA% ZHA
            WHERE ZHA.ZHA_FILIAL = %xFilial:ZHA%
                AND ZHA.ZHA_CODIGO = %Exp:_cCodigo%
                AND ZHA.ZHA_PERIOD = %Exp:_dPeriodo%
                AND ZHA.%NotDel%
                AND rownum = 1
    EndSql

    DbSelectArea( _cAliasZHA )
    if ( _cAliasZHA )->(!EOF())
        _lRet := .f.
    EndIf
    ( _cAliasZHA )->(dbCloseArea())
*/
    if _lRet
        BeginSql Alias _cAliasZHA
            SELECT DISTINCT SD3.D3_FILIAL, 
                            SD3.D3_TM, 
                            SD3.D3_CF, 
                            SD3.D3_COD, 
                            SB1.B1_DESC, 
                            SD3.D3_OP, 
                            SB1.B1_TIPO
            FROM   %table:SD3% SD3 
                INNER JOIN %table:SB1% SB1 
                        ON SB1.B1_FILIAL =  %xFilial:SB1% AND  SB1.B1_COD = SD3.D3_COD  AND SB1.%NotDel%
            WHERE  1 = 1 
                AND SD3.D3_FILIAL = %xFilial:SD3%
                AND SUBSTR(D3_EMISSAO,01,06) = %Exp:_dPeriodo%
                AND SD3.D3_CF LIKE 'PR%' 
                //AND SD3.D3_COD IN ('000004','003001','003002','003003')
                AND SD3.D3_OP <> ' ' 
                AND SD3.D3_ESTORNO = ' '
                AND SD3.%NotDel%
            ORDER  BY SD3.D3_COD, 
                    SD3.D3_OP 
        EndSql

        DbSelectArea( _cAliasZHA )
        MSAguarde( { || ( _cAliasZHA )->( DbEval( { || _nTotReg++ } ) ) }, "Aguarde...", "Retornando total de registros Movimento Estoque" )
        ( _cAliasZHA )->( DbGoTop() )  
        _oObjProc:IncRegua1("Processando Dados Movimentos do Estoque-Analítico " ) //+ cValToChar( 2 ) + " de " + cValToChar( 3 ) )
        _oObjProc:SetRegua2( _ntotReg ) 
        ( _cAliasZHA )->( DbGoTop() )  
        While ( _cAliasZHA )->( !Eof() )
            _oObjProc:IncRegua2("Movimentos do Estoque  " + cValToChar( _nContReg ) + " de " + cValToChar( _nTotReg ) )
            //if _nContReg > 1
            //    _oModZHA:AddLine()
            //endif

            if _cQuebra <> ( _cAliasZHA )->D3_COD
                if !empty(_cQuebra)
                    //_cIn += ")"
                    sfLoadOP(_dPeriodo,_cIn,_cPrimeira,_cQuebra,@_nContZH9)
                endif
                _cQuebra    := ( _cAliasZHA )->D3_COD
                _cIn        := ""
                _cPrimeira  := alltrim(( _cAliasZHA )->D3_OP)
            endif
            
            //_cIn += if(empty(_cIn),"('",",'") + alltrim(( _cAliasZHA )->D3_OP) + "'"
            _cIn += if(empty(_cIn),"","','") + alltrim(( _cAliasZHA )->D3_OP)

            ( _cAliasZHA )->( DbSkip() )
            _nContReg++
        EndDo
        ( _cAliasZHA )->(dbCloseArea())
        if !empty(_cQuebra)
            //_cIn += ")"
            sfLoadOP(_dPeriodo,_cIn,_cPrimeira,_cQuebra,@_nContZH9)
        endif

    EndIf

    if _nContZH9 > 0
        _lFez := .t.
    endif

    //_oModZHA:SetNoUpdateLine( .T. )
    //_oModZHA:SetNoDeleteLine( .T. )

    _lRet := .t.
    
Return( _lRet )


/*/
    {Protheus.doc} sfLoadOP
    Processa dados dos movimentos da SD3 e da ZH8
    @type  Static Function
    @author Jairo O Junior
    @author Wagner Neves
    @since 29/09/2020
    @version P12 12.1.17
    @param      _dPeriodo, Caracter, Filial
    @param      _cIn, Caracter, OP's para in "IN" da querie
    @param      _cPrimira, Caracter, Primeira OP para gravar no ZH9
    @param      _cCodPai, Caracter, Codigo Produto Pai
    @return     _nContReg, Numerico, Contador de registro passado por referencia @
    @example
    (examples)
    @see (links_or_references)
    @table ZH9
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
static function sfLoadOP(_dPeriodo,_cIn,_cPrimeira,_cCodPai,_nContReg)

   Local _cAliasD3    := GetNextAlias()
   //Local _nContReg    := 0
   Local _cCod        := _oModZGU:GetValue("ZGU_CODIGO") 
   Local _nTotQt      := 0  
   Local _nRegZH8     := 0
   Local _nRecZH9     := 0
 

       // Grava Cod Pai e Materias primas da OP
       BeginSql Alias _cAliasD3
            SELECT D3_FILIAL, 
                D3_TM, 
                D3_CF, 
                D3_COD, 
                B1_DESC, 
                CASE 
                    WHEN SUBSTR(D3_CF, 1, 2) = 'PR' THEN 1 
                    WHEN SUBSTR(D3_CF, 1, 2) = 'DE' THEN 2 
                    ELSE 9 
                END XTP, 
                Sum(D3_QUANT) D3_QUANT
            FROM   %table:SD3% SD3 
                INNER JOIN %table:SB1% SB1 
                        ON SB1.B1_FILIAL =  %xFilial:SB1% AND  SB1.B1_COD = SD3.D3_COD  AND SB1.%NotDel%
            WHERE  1 = 1 
                AND SD3.D3_FILIAL = %xFilial:SD3%
                AND SUBSTR(D3_EMISSAO,01,06) = %Exp:_dPeriodo%
                AND SD3.D3_OP IN (%Exp:_cIn%)
                AND SD3.D3_ESTORNO = ' '
                AND SD3.%NotDel%
            GROUP  BY D3_FILIAL, 
                    D3_TM, 
                    D3_CF, 
                    D3_COD, 
                    B1_DESC, 
                    CASE 
                        WHEN SUBSTR(D3_CF, 1, 2) = 'PR' THEN 1 
                        WHEN SUBSTR(D3_CF, 1, 2) = 'DE' THEN 2 
                        ELSE 9 
                    END 
            ORDER  BY XTP, 
                    D3_CF, 
                    D3_COD
       EndSql

        ( _cAliasD3 )->( DbGoTop() )  
        While ( _cAliasD3 )->( !Eof() )
            _nContReg++
 
            ZH9->(RECLOCK("ZH9",.T.))
            ZH9->ZH9_FILIAL      := _oModZGU:GetValue("ZGU_FILIAL")   
            ZH9->ZH9_CODIGO      := _oModZGU:GetValue("ZGU_CODIGO")   
            ZH9->ZH9_PERIOD      := _oModZGU:GetValue("ZGU_PERIOD")   
            ZH9->ZH9_ITEM        := STRZERO(_nContReg,6)              
            ZH9->ZH9_SETOR       := ''                                
            ZH9->ZH9_DSETOR      := ''                                
            ZH9->ZH9_NUMOP       := ALLTRIM( _cPrimeira ) + "_A" //( _cAliasZH9 )->D3_ZOPTAUR        
            ZH9->ZH9_CODPRO      := ( _cAliasD3 )->D3_COD            
            //ZH9->ZH9_NOMPRO      := ( _cAliasZH9 )->B1_DESC           
            ZH9->ZH9_OPERAC      := ( _cAliasD3 )->D3_TM                    
            ZH9->ZH9_QTDPRO      := ( _cAliasD3 )->D3_QUANT                  
            ZH9->ZH9_QTDINS      := 0                                   //FUNÇÃO QTD INSUMOS        
            ZH9->ZH9_DTPROC      := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
            ZH9->ZH9_DATA        := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
            ZH9->ZH9_TIPO        := IF((_cAliasD3)->XTP=1,"1","9")
            ZH9->ZH9_UM          := ""//_cZH9Um                                   
            ZH9->ZH9_CF          := ( _cAliasD3 )->D3_CF                            
            ZH9->ZH9_UM2         := ""//_cZH9Um                                   
            ZH9->ZH9_POSIPI      := ""//_cZH9NCM                                 
            ZH9->ZH9_IPRORA      := ''                                
            ZH9->ZH9_CODRAS      := _cCodPai                                
            ZH9->ZH9_NPROD       := ''                                        
            ZH9->(MSUNLOCK())

            if (_cAliasD3)->XTP=1
                _nTotQt += ( _cAliasD3 )->D3_QUANT 
            endif


            DbSelectArea( _cAliasD3 )
            ( _cAliasD3 )->( DbSkip() )

        EndDo
        ( _cAliasD3 )->(dbCloseArea())


    // Grava Insumos da OP
    BeginSql Alias _cAliasD3
        SELECT ZH8_CODINS ,  ZH8_NOMINS,  SUM(ZH8_QEMBIN) ZH8_QEMBIN
        FROM %table:ZH8% ZH8
        WHERE 
           ZH8_FILIAL =  %xFilial:ZH8%
            AND ZH8_CODIGO =  %Exp:_cCod%
            AND ZH8_PERIOD = %Exp:_dPeriodo%
            AND ZH8_CODPRO = %Exp:_cCodPai%
            AND ZH8_QEMBIN <> 0
            AND ZH8.%NotDel%
        GROUP BY ZH8_CODINS ,  ZH8_NOMINS 
        ORDER BY ZH8_CODINS
      EndSql

        ( _cAliasD3 )->( DbGoTop() )  
        While ( _cAliasD3 )->( !Eof() )
            _nContReg++
            _nRegZH8++

            if _nRegZH8 = 1
                ZH9->(RECLOCK("ZH9",.T.))
                ZH9->ZH9_FILIAL      := _oModZGU:GetValue("ZGU_FILIAL")   
                ZH9->ZH9_CODIGO      := _oModZGU:GetValue("ZGU_CODIGO")   
                ZH9->ZH9_PERIOD      := _oModZGU:GetValue("ZGU_PERIOD")   
                ZH9->ZH9_ITEM        := STRZERO(_nContReg,6)              
                ZH9->ZH9_SETOR       := 'X'                                
                ZH9->ZH9_DSETOR      := ''                                
                ZH9->ZH9_NUMOP       := ALLTRIM( _cPrimeira ) + "_B" //( _cAliasZH9 )->D3_ZOPTAUR        
                ZH9->ZH9_CODPRO      := _cCodPai   //( _cAliasD3 )->ZH8_CODINS          
                //ZH9->ZH9_NOMPRO      := ( _cAliasZH9 )->B1_DESC           
                ZH9->ZH9_OPERAC      := "" //( _cAliasD3 )->D3_TM                    
                ZH9->ZH9_QTDPRO      := _nTotQt//( _cAliasD3 )->ZH8_QEMBIN               
                ZH9->ZH9_QTDINS      := 0                                   //FUNÇÃO QTD INSUMOS        
                ZH9->ZH9_DTPROC      := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
                ZH9->ZH9_DATA        := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
                ZH9->ZH9_TIPO        := "1" //IF((_cAliasD3)->XTP=1,"1","9")
                ZH9->ZH9_UM          := ""//_cZH9Um                                   
                ZH9->ZH9_CF          := "" //( _cAliasD3 )->D3_CF                            
                ZH9->ZH9_UM2         := ""//_cZH9Um                                   
                ZH9->ZH9_POSIPI      := ""//_cZH9NCM                                 
                ZH9->ZH9_IPRORA      := ''                                
                ZH9->ZH9_CODRAS      := _cCodPai                                
                ZH9->ZH9_NPROD       := ''                                        
                ZH9->(MSUNLOCK())
                _nRecZH9 := ZH9->(Recno())
                 _nContReg++
           endif

            ZH9->(RECLOCK("ZH9",.T.))
            ZH9->ZH9_FILIAL      := _oModZGU:GetValue("ZGU_FILIAL")   
            ZH9->ZH9_CODIGO      := _oModZGU:GetValue("ZGU_CODIGO")   
            ZH9->ZH9_PERIOD      := _oModZGU:GetValue("ZGU_PERIOD")   
            ZH9->ZH9_ITEM        := STRZERO(_nContReg,6)              
            ZH9->ZH9_SETOR       := 'X'                                
            ZH9->ZH9_DSETOR      := ''                                
            ZH9->ZH9_NUMOP       := ALLTRIM( _cPrimeira ) + "_B" //( _cAliasZH9 )->D3_ZOPTAUR        
            ZH9->ZH9_CODPRO      := ( _cAliasD3 )->ZH8_CODINS          
            //ZH9->ZH9_NOMPRO      := ( _cAliasZH9 )->B1_DESC           
            ZH9->ZH9_OPERAC      := "" //( _cAliasD3 )->D3_TM                    
            ZH9->ZH9_QTDPRO      := ( _cAliasD3 )->ZH8_QEMBIN               
            ZH9->ZH9_QTDINS      := 0                                   //FUNÇÃO QTD INSUMOS        
            ZH9->ZH9_DTPROC      := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
            ZH9->ZH9_DATA        := lastday(stod(_dPeriodo+"01")) ////STOD( ( _cAliasZH9 )->D3_EMISSAO )        
            ZH9->ZH9_TIPO        := "9" //IF((_cAliasD3)->XTP=1,"1","9")
            ZH9->ZH9_UM          := ""//_cZH9Um                                   
            ZH9->ZH9_CF          := "" //( _cAliasD3 )->D3_CF                            
            ZH9->ZH9_UM2         := ""//_cZH9Um                                   
            ZH9->ZH9_POSIPI      := ""//_cZH9NCM                                 
            ZH9->ZH9_IPRORA      := ''                                
            ZH9->ZH9_CODRAS      := _cCodPai                                
            ZH9->ZH9_NPROD       := ''                                        
            ZH9->(MSUNLOCK())

            //_nTotQt += ( _cAliasD3 )->ZH8_QEMBIN 

            DbSelectArea( _cAliasD3 )
            ( _cAliasD3 )->( DbSkip() )

        EndDo
        ( _cAliasD3 )->(dbCloseArea())

        //if _nRecZH9 <> 0
        //    ZH9->(DBGOTO(_nRecZH9))
        //    ZH9->(RECLOCK("ZH9",.F.))
        //    ZH9->ZH9_QTDPRO      := _nTotQt
        //    ZH9->(MSUNLOCK())
        //endif

return()


/*/
    {Protheus.doc} genSAFX10
    Processa dados obtidos do XTract e gera informações de produção (grava dados na tablea ZH9)
    Será utilizado na extração do layout SAFX10
    @type  Static Function
    @author André Fracassi 
    @author Wagner Neves
    @since 27/08/2020
    @version P12 12.1.17
    @param      _cParam01, Caracter, Filial
    @param      _dParam02, Date, Data
    @param      _oParam03, Objeto, Objeto de Processamento
    @param      _oParam04, Objeto, Objeto Modelo ZGU
    @return     _lRet, Boolean  , True/False para controle de processamento
    @example
    (examples)
    @see (links_or_references)
    @table ZH9
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualizações-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function genSAFX10( _cParam01, _dParam02, _oParam03, _oParam04, _oParam05 , _lFez )
    Local _oModel   	:= FwModelActive()
    Local _lRet         := .T.
    Local _cFilDe       := _cParam01
    Local _dPeriodo     := _dParam02
    Local _oObjProc     := _oParam03
    Local _oModZH9      := _oModel:GetModel("ZH9DETAIL")
    Local _oModZGU      := _oModel:GetModel("ZGUMASTER")
    Local _cAliasZH9    := GetNextAlias()
    Local _nTotReg      := 0
    Local _nContReg     := 0
    Local _cCodigo      := ""

    _oObjProc:SetRegua2( 1 )
    _oObjProc:IncRegua2("Selecionando Registros Movimentos Estoque-Sintetico...." ) 

    _cCodigo    := _oModZGU:GetValue("ZGU_CODIGO")
    _dPeriodo   := _oModZGU:GetValue("ZGU_PERIOD")

   BeginSql Alias _cAliasZH9
        SELECT ZH9.ZH9_CODIGO
            FROM %table:ZH9% ZH9
            WHERE ZH9.ZH9_FILIAL = %xFilial:ZH9%
                AND ZH9.ZH9_CODIGO = %Exp:_cCodigo%
                AND ZH9.ZH9_PERIOD = %Exp:_dPeriodo%
                AND ZH9.%NotDel%
                AND rownum = 1
    EndSql

    DbSelectArea( _cAliasZH9 )
    if ( _cAliasZH9 )->(!EOF())
        _lRet := .f.
    EndIf
    ( _cAliasZH9 )->(dbCloseArea())

    if _lRet

        BeginSql Alias _cAliasZH9
            SELECT 
                SD3.D3_FILIAL, SD3.D3_TM, SD3.D3_CF, SD3.D3_COD, SB1.B1_DESC, SUM( SD3.D3_QUANT ) D3_QUANT, SD3.D3_EMISSAO, SD3.D3_ZOPTAUR, SB1.B1_UM , SB1.B1_POSIPI
            FROM 
                %table:SD3% SD3
                INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL =  %xFilial:SB1% AND SB1.B1_COD=SD3.D3_COD  AND SB1.%NotDel%
            WHERE
                SD3.D3_ZOPTAUR IS NOT NULL
                AND SD3.D3_FILIAL = %xFilial:SD3%
                AND SD3.D3_ESTORNO = ' '
                AND SD3.%NotDel% 
                AND SUBSTR(D3_EMISSAO,01,06) = %Exp:_dPeriodo% 
            GROUP BY
            SD3.D3_FILIAL, SD3.D3_TM, SD3.D3_CF, SD3.D3_COD, SB1.B1_DESC, SD3.D3_EMISSAO, SD3.D3_ZOPTAUR, SB1.B1_UM , SB1.B1_POSIPI
            ORDER BY SD3.D3_EMISSAO, SD3.D3_COD, SD3.D3_ZOPTAUR
        EndSql
        _nContReg := 1
        // Gravando dados na tabela ZH9
        DbSelectArea( _cAliasZH9 )
        MSAguarde( { || ( _cAliasZH9 )->( DbEval( { || _nTotReg++ } ) ) }, "Aguarde...", "Retornando total de registros da SAFX10" )
        ( _cAliasZH9 )->( DbGoTop() )
        _oObjProc:IncRegua1("Processando Dados SAFX10") // + cValToChar( 3 ) + " de " + cValToChar( 3 ) )
        _oObjProc:SetRegua2( _ntotReg )
        ( _cAliasZH9 )->( DbGoTop() )    
        While ( _cAliasZH9 )->( ! Eof() )            
        //If _ncontreg > 1
        //    _oModZH9:AddLine()
        //EndIf
            _oObjProc:IncRegua2("Gerando dados SAFX10 - " + cValToChar( _nContReg ) + " de " + cValTochar(_nTotReg) )
            
            _czH9Um  := ( _cAliasZH9 )->B1_UM  //POSICIONE("SB1",1,xFilial("SB1")+( _cAliasZH9 )->D3_COD,"B1_UM")
            _czH9NCM := ( _cAliasZH9 )->B1_POSIPI  //POSICIONE("SB1",1,xFilial("SB1")+( _cAliasZH9 )->D3_COD,"B1_POSIPI")

            ZH9->(RECLOCK("ZH9",.T.))
            ZH9->ZH9_FILIAL      := _oModZGU:GetValue("ZGU_FILIAL")   
            ZH9->ZH9_CODIGO      := _oModZGU:GetValue("ZGU_CODIGO")   
            ZH9->ZH9_PERIOD      := _oModZGU:GetValue("ZGU_PERIOD")   
            ZH9->ZH9_ITEM        := STRZERO(_nContReg,6)              
            ZH9->ZH9_SETOR       := ''                                
            ZH9->ZH9_DSETOR      := ''                                
            ZH9->ZH9_NUMOP       := ( _cAliasZH9 )->D3_ZOPTAUR        
            ZH9->ZH9_CODPRO      := ( _cAliasZH9 )->D3_COD            
            //ZH9->ZH9_NOMPRO      := ( _cAliasZH9 )->B1_DESC           
            ZH9->ZH9_OPERAC      := ( _cAliasZH9 )->D3_TM                    
            ZH9->ZH9_QTDPRO      := ( _cAliasZH9 )->D3_QUANT                  
            ZH9->ZH9_QTDINS      := 0                                   //FUNÇÃO QTD INSUMOS        
            ZH9->ZH9_DTPROC      := STOD( ( _cAliasZH9 )->D3_EMISSAO )        
            ZH9->ZH9_UM          := _cZH9Um                                   
            ZH9->ZH9_CF          := ( _cAliasZH9 )->D3_CF                            
            ZH9->ZH9_UM2         := _cZH9Um                                   
            ZH9->ZH9_POSIPI      := _cZH9NCM                                 
            ZH9->ZH9_IPRORA      := ''                                
            ZH9->ZH9_CODRAS      := ''                                
            ZH9->ZH9_NPROD       := ''                                        
            ZH9->(MSUNLOCK())

            DbSelectArea( _cAliasZH9 )
            ( _cAliasZH9 )->( DbSkip() )
            _nContReg++
        EndDo
        ( _cAliasZH9 )->(DbCloseArea())
    endif

    if _nContReg > 0
        _lFez := .t.
    endif
    _lRet := .t.
Return( _lRet )

/* PENDENCIAS

   SETOR COMO TRATAR POIS NAO TEMOS NA SD3
   PRODUTO RASTRO
   NIVEL (SEQ CALCULO ???)
   QTD INSUMO

*/
