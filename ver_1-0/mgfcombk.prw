#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} MGFCOMBK
Função para detalhar Programação de Entrega de pedido de compra
@type  User Function
@author Wagner Neves
@since 14/08/2020
@version 2020.08
@obs TASK - [RTASK0011453] Follow UP – Acompanhamento de Entregas de Compras
/*/
User Function MGFCOMBK()

    Private _oBrowse
    Private _aCpoBrw	:= {}
    Private _cTituloBrw	:= "Follow Up Compras"
    Private _cAliasSC7
    Private _oTmpTable
    Private _aSeek      := {}
    Private _aStru      := {}

    // Definindo campos do MBrowse
    AAdd( _aCpoBrw, {"Filial"         , "TMP_FILIAL"  , "C", TamSx3("C7_FILIAL")[ 01 ]    , TamSx3("C7_FILIAL")[ 02 ]    , PesqPict("SC7", "C7_FILIAL") } )
    AAdd( _aCpoBrw, {"Pedido"         , "TMP_NUM"     , "C", TamSx3("C7_NUM")[ 01 ]       , TamSx3("C7_NUM")[ 02 ]       , PesqPict("SC7", "C7_NUM") } )
    AAdd( _aCpoBrw, {"Dt. Emissão"    , "TMP_EMISSA"  , "D", TamSx3("C7_EMISSAO")[ 01 ]   , TamSx3("C7_EMISSAO")[ 02 ]   , PesqPict("SC7", "C7_EMISSAO") } )
    AAdd( _aCpoBrw, {"Fornecedor"     , "TMP_FORNEC"  , "C", TamSx3("C7_FORNECE")[ 01 ]   , TamSx3("C7_FORNECE")[ 02 ]   , PesqPict("SC7", "C7_FORNECE") } )
    AAdd( _aCpoBrw, {"Loja"           , "TMP_LOJA"    , "C", TamSx3("C7_LOJA")[ 01 ]      , TamSx3("C7_LOJA")[ 02 ]      , PesqPict("SC7", "C7_LOJA") } )
    AAdd( _aCpoBrw, {"Nome"           , "TMP_NOME"    , "C", TamSx3("A2_NOME")[ 01 ]      , TamSx3("A2_NOME")[ 02 ]      , PesqPict("SA2", "A2_NOME") } )
    If COMBKParam()
        //Campos que irão compor a pesquisa
        AAdd( _aSeek, {"Pedido", { {"", "C", TamSx3("C7_NUM")[ 01 ], TamSx3("C7_NUM")[ 02 ], "Pedido", "@!" } }, 1, .T. } )
        AAdd( _aSeek, {"Fornecedor", { {"", "C", TamSx3("C7_FORNECE")[ 01 ], TamSx3("C7_FORNECE")[ 02 ], "Fornecedor", "@!" } }, 2, .T. } )

        _oBrowse := FWMBrowse():New()
        _oBrowse:SetTemporary( .T. )
        _oBrowse:SetAlias( _cAliasSC7 )
        _oBrowse:SetDescription( _cTituloBrw )
        _oBrowse:SetFields( _aCpoBrw )
        _oBrowse:SetSeek( .T., _aSeek )
        _oBrowse:DisableDetails()

        SetKey( VK_F12, { || fFilDados() } )

        _oBrowse:Activate()

        DbSelectArea( _cAliasSC7 )
        ( _cAliasSC7 )->( DbCloseArea() )

        _oTmpTable:Delete()

        SetKey(VK_F12, Nil )
    EndIf

Return



/*/{Protheus.doc} COMBKParam
Parâmetros para filtro de pedido de compra
@type  User Function
@author Wagner Neves
@since 14/08/2020
@version 2020.08
@obs TASK - [RTASK0011453] Follow UP – Acompanhamento de Entregas de Compras
/*/
Static Function COMBKParam()

    Local _lRet         := .F.
    Local _cTitPerg     := "Parâmetros Filtra Pedido de Compra"

    Private _aRet       := {}
    Private _aParam     := {}

    AAdd( _aParam, { 1, "Fornecedor De" , Space( TamSx3("A2_COD")[ 01 ] )	        , "@!"  , 'Vazio() .OR. ExistCpo("SA2", MV_PAR01 )' , "SA2"	, "", 015, .F. } )          //MV_PAR01
    AAdd( _aParam, { 1, "Fornecedor Até", Replicate("Z", TamSx3("A2_COD")[ 01 ] )	, "@!"  , ""                                        , "SA2"	, "", 015, .T. } )          //MV_PAR02
    AAdd( _aParam, { 1, "Loja De"       , Space( TamSx3("A2_LOJA")[ 01 ] )	        , "@!"  , ""                                        , ""    , "", 015, .F. } )          //MV_PAR03
    AAdd( _aParam, { 1, "Loja Até"      , Replicate("Z", TamSx3("A2_LOJA")[ 01 ] )	, "@!"  , ""                                        , ""    , "", 015, .T. } )          //MV_PAR04
    AAdd( _aParam, { 1, "Data De"       , dDatabase                                 , ""    , ""                                        , ""    , "", 050, .T. } )          //MV_PAR05
    AAdd( _aParam, { 1, "Data Ate"      , dDatabase                                 , ""    , ""                                        , ""    , "", 050, .T. } )          //MV_PAR06
    If ParamBox( _aParam, _cTitPerg, @_aRet )
        MsAguarde( { || COMBKLoad( _aRet[ 01 ], _aRet[ 02 ], _aRet[ 03 ], _aRet[ 04 ], _aRet[ 05 ], _aRet[ 06 ] ) }, "Aguarde...", "Selecionando Pedidos de Compra", .T. )
        _lRet := .T.
    EndIf

Return( _lRet )



/*/{Protheus.doc} COMBKLoad
Criar tabela e índice temporário para Cabecalho de Pedido
@type  User Function
@author Wagner Neves
@since 14/08/2020
@version 2020.08
@obs TASK - [RTASK0011453] Follow UP – Acompanhamento de Entregas de Compras
/*/
Static Function COMBKLoad( _cParam01, _cParam02, _cParam03, _cParam04, _dParam05, _dParam06 )

    Local _cForDe       := _cParam01
    Local _cForAte		:= _cParam02
    Local _cLojDe		:= _cParam03
    Local _cLojAte		:= _cParam04
    Local _dDtDe        := _dParam05
    Local _dDtAte       := _dParam06

    Local _cAliasQry    := GetNextAlias()

    If Select( _cAliasSC7 ) > 0
        DbSelectArea( _cAliasSC7 )
        ( _cAliasSC7 )->( DbCloseArea() )
    EndIf

    _cAliasSC7  := GetNextAlias()
    _oTmpTable  := FWTemporaryTable():New( _cAliasSC7 )

    // Criando estrutura de tabela temporaria
    AAdd( _aStru, {"TMP_FILIAL"  , "C", TamSx3("C7_FILIAL")[ 01 ]    , TamSx3("C7_FILIAL")[ 02 ]     } )
    AAdd( _aStru, {"TMP_NUM"     , "C", TamSx3("C7_NUM")[ 01 ]       , TamSx3("C7_NUM")[ 02 ]        } )
    AAdd( _aStru, {"TMP_EMISSA"  , "D", TamSx3("C7_EMISSAO")[ 01 ]   , TamSx3("C7_EMISSAO")[ 02 ]    } )
    AAdd( _aStru, {"TMP_FORNEC"  , "C", TamSx3("C7_FORNECE")[ 01 ]   , TamSx3("C7_FORNECE")[ 02 ]    } )
    AAdd( _aStru, {"TMP_LOJA"    , "C", TamSx3("C7_LOJA")[ 01 ]      , TamSx3("C7_LOJA")[ 02 ]       } )
    AAdd( _aStru, {"TMP_NOME"    , "C", TamSx3("A2_NOME")[ 01 ]      , TamSx3("A2_NOME")[ 02 ]       } )

    _oTmpTable:SetFields( _aStru )
    _oTmpTable:AddIndex("1", {"TMP_NUM"} )
    _oTmpTable:AddIndex("2", {"TMP_FORNEC"} )
    _oTmpTable:Create()

    BeginSql Alias _cAliasQry
        column C7_EMISSAO as Date
        SELECT
            SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO,
            SC7.C7_FORNECE, SC7.C7_LOJA, SA2.A2_NOME
        FROM
            %table:SC7% SC7
                INNER JOIN %table:SB1% SB1 ON
                        SB1.B1_FILIAL  = %xFilial:SB1%
                    AND SB1.B1_COD     = SC7.C7_PRODUTO
                    AND SB1.%notDel%
                INNER JOIN %table:SA2% SA2 ON
                        SA2.A2_FILIAL  = %xFilial:SA2%
                    AND SA2.A2_COD     = SC7.C7_FORNECE
                    AND SA2.A2_LOJA    = SC7.C7_LOJA
                    AND SA2.%notDel%
        WHERE
                SC7.C7_FILIAL  = %xFilial:SC7%
            AND SC7.C7_FORNECE BETWEEN %Exp:_cForDe% AND %Exp:_cForAte%
            AND SC7.C7_LOJA BETWEEN %Exp:_cLojDe% AND %Exp:_cLojAte%
            AND SC7.C7_EMISSAO BETWEEN %Exp:DTOS( _dDtDe )% AND %Exp:DTOS( _dDtAte )%
            AND SB1.B1_TIPO = 'EM'
            AND SC7.C7_ENCER = ' '
            AND SC7.C7_QUJE < SC7.C7_QUANT
            AND SC7.C7_RESIDUO = ' '
            AND SC7.%notDel%
        GROUP BY
            SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO,
            SC7.C7_FORNECE, SC7.C7_LOJA, SA2.A2_NOME
        ORDER BY
            %Order:SC7,3%
    EndSql

    DbSelectArea( _cAliasQry )
    ( _cAliasQry )->( DbGoTop() )
    While ( _cAliasQry )->( !Eof() )
        If RecLock( _cAliasSC7, .T. )
            ( _cAliasSC7 )->TMP_FILIAL := ( _cAliasQry )->C7_FILIAL
            ( _cAliasSC7 )->TMP_NUM     := ( _cAliasQry )->C7_NUM
            ( _cAliasSC7 )->TMP_EMISSA  := ( _cAliasQry )->C7_EMISSAO
            ( _cAliasSC7 )->TMP_FORNEC  := ( _cAliasQry )->C7_FORNECE
            ( _cAliasSC7 )->TMP_LOJA    := ( _cAliasQry )->C7_LOJA
            ( _cAliasSC7 )->TMP_NOME    := ( _cAliasQry )->A2_NOME
            ( _cAliasSC7 )->( MsUnLock() )
        EndIf
        DbSelectArea( _cAliasQry )
        ( _cAliasQry )->( DbSkip() )
    EndDo

    DbSelectArea( _cAliasQry )
    ( _cAliasQry )->( DbCloseArea() )

    // Atualiza Browse somente quando objeto estiver inicializado
    If _oBrowse != Nil
        _oBrowse:SetAlias( _cAliasSC7 )
        _oBrowse:Refresh(.T.)
    EndIf

Return



/*/{Protheus.doc} MenuDef
Menu Browse
@type function
@version 2020.08
@author Wagner Neves
@since 14/08/2020
@return Objeto, Objeto do modelo.
/*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCOMBK" 	OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCOMBK" 	OPERATION 4 ACCESS 0

Return aRotina



/*/{Protheus.doc} ModelDef
Modelo da Tela principal da Programação de Entrega
@type function
@version 2020.08
@author Wagner Neves
@since 14/08/2020
@return Objeto, Objeto do modelo.
/*/
Static Function ModelDef()

    Local _oModel
    Local _oStrTMP      := fMontaMdTMP( _cAliasSC7 )
    Local _oStrSC7I     := FWFormStruct( 1, "SC7", { |x| AllTrim(x) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_QUANT|C7_QUJE" } )
    Local _oStrZGG      := FWFormStruct( 1, "ZGG", { |x| AllTrim(x) $ "ZGG_QUANT|ZGG_DTPRF|ZGG_PREPED|ZGG_REQUIS" } )
    Local _bLinePosZGG  := { | _oModel, _nLine, _cAction, _cCampo, _cValor, _cAtual | fLinePosZGG( _oModel, _nLine, _cAction, _cCampo, _cValor, _cAtual ) }

    // Cria o objeto do Modelo de Dados
    _oModel := MPFormModel():New("xCOMBK", /**/, , /*bCommit*/, /*bCancel*/ )

    // Adiciona a descricao do Modelo de Dados
    _oModel:SetDescription("Pedido de Compra")

    // Adiciona ao modelo uma estrutura de formulário de edição por campo
    _oModel:AddFields( "SC7MASTER", /*cOwner*/, _oStrTMP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

    _oModel:AddGrid( "SC7DETAIL", "SC7MASTER", _oStrSC7I, /*bPreValidacaoLinha*/, /*bPosValidacaoLinha*/, /*bCargaLinha*/ )
    _oModel:GetModel("SC7DETAIL"):SetNoInsertLine( .T. )
    _oModel:GetModel("SC7DETAIL"):SetNoUpdateLine( .T. )
    _oModel:GetModel("SC7DETAIL"):SetNoDeleteLine( .T. )

    _oModel:AddGrid( "ZGGDETAIL", "SC7DETAIL", _oStrZGG, /*bPreValidacaoLinha*/, _bLinePosZGG /*bPosValidacaoLinha*/, /*bCargaLinha*/ )
        _oModel:GetModel("ZGGDETAIL"):SetOptional( .T. )
        _oStrZGG:SetProperty("ZGG_QUANT", MODEL_FIELD_VALID, { | | fValQtd( _oStrZGG ) } )
        //      AddField( < cTitulo >, < cTooltip >, < cIdField >, < cTipo >, < nTamanho >           , [ nDecimal ]           , [ bValid ], [ bWhen ], [ aValues ], [ lObrigat ], [ bInit ], < lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ] )
        _oStrZGG:AddField(""         , ""          , "C7_QUJE"   , "N"      , TamSx3("C7_QUJE")[ 01 ], TamSx3("C7_QUJE")[ 02 ], NIL       , NIL      , NIL        , NIL         , NIL      , NIL     , NIL       , NIL         , NIL )

    //Adiciona chave Primária
    _oModel:SetPrimaryKey( {"TMP_FILIAL", "TMP_FORNEC", "TMP_LOJA", "TMP_NUM"} )

    // Adiciona relação entre cabeçalho e item (relacionamento entre mesma tabela)
    _oModel:SetRelation( "SC7DETAIL", { {"C7_FILIAL", "TMP_FILIAL"}, {"C7_FORNECE", "TMP_FORNEC"}, {"C7_LOJA", "TMP_LOJA"}, {"C7_NUM", "TMP_NUM"} }, SC7->( IndexKey( 1 ) ) )
    _oModel:SetRelation( "ZGGDETAIL", { {"ZGG_FILIAL", "TMP_FILIAL"}, {"ZGG_PEDIDO", "TMP_NUM"}, {"ZGG_ITEM", "C7_ITEM"}, {"ZGG_PROD", "C7_PRODUTO"} }, ZGG->( IndexKey( 1 ) ) )

    // Adiciona a descricao do Componente do Modelo de Dados
    _oModel:GetModel( "SC7MASTER" ):SetDescription("Pedido de Compra")
    _oModel:GetModel( "SC7DETAIL" ):SetDescription("Itens Pedido de Compra")
    _oModel:GetModel( "ZGGDETAIL" ):SetDescription("Datas de Entrega")

Return( _oModel )



/*/{Protheus.doc} VIEWDEF
View da Tela principal da Programação de Entrega
@type function
@version 2020.08
@author Wagner Neves
@since 14/08/2020
@return Objeto, Objeto da view.
/*/
Static Function ViewDef()

    // Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
    Local _oView
    Local _oModel    := ModelDef()

    // Cria a estrutura a ser usada na View
    Local _oStruTMP  := fMontaVdTMP( )
    Local _oStruSC7I := FWFormStruct( 2, "SC7", { |x| AllTrim(x) $ "C7_ITEM|C7_PRODUTO|C7_DESCRI|C7_QUANT|C7_QUJE" } )
    Local _oStruZGG  := FWFormStruct( 2, "ZGG", { |x| AllTrim(x) $ "ZGG_QUANT|ZGG_DTPRF|ZGG_PREPED|ZGG_REQUIS" } )

    // Cria o objeto de View
    _oView := FWFormView():New()

    // Define qual o Modelo de dados será utilizado
    _oView:SetModel( _oModel )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    _oView:AddField( "VIEW_SC7C", _oStruTMP, "SC7MASTER" )

    _oView:AddGrid( "VIEW_SC7I", _oStruSC7I, "SC7DETAIL" )
        _oStruSC7I:RemoveField("C7_DESC")
        //         AddField( <cIdField >, <cOrdem >, <cTitulo >                   , <cDescric >                  , <aHelp >                  , <cType >, <cPicture >           , <bPictVar >, <cLookUp >, <lCanChange >, <cFolder >, <cGroup >, [ aComboValues ], [ nMaxLenCombo ], <cIniBrow >, <lVirtual >, <cPictVar >, [ lInsertLine ]
        _oStruSC7I:AddField("C7_QUJE"   , "08"     , AllTrim("Quant. já entregue"), AllTrim("Quant. já entregue"), {"Quantidade já entregue"}, "N"     , X3Picture( "C7_QUJE" ), NIL        , ""        , .F.          , NIL       , NIL      , NIL             , NIL             , NIL        , NIL        , NIL        , NIL )

    _oView:AddGrid( "VIEW_ZGG", _oStruZGG, "ZGGDETAIL" )

    _oView:CreateHorizontalBox( "BOX_FORM_SC7", 30 )
    _oView:SetOwnerView( "VIEW_SC7C", "BOX_FORM_SC7" )
    _oView:EnableTitleView( "VIEW_SC7C", "Pedido de Compra" )

    _oView:CreateHorizontalBox( "BOX_FORM_DET", 70 )

        _oView:CreateVerticalBox( "BOXOPE_ESQ", 50, "BOX_FORM_DET" )
        _oView:SetOwnerView( "VIEW_SC7I", "BOXOPE_ESQ" )
        _oView:EnableTitleView( "VIEW_SC7I", "Item Pedido de Compra" )

        _oView:CreateVerticalBox( "BOXOPE_DIR", 50, "BOX_FORM_DET" )
        _oView:SetOwnerView( "VIEW_ZGG", "BOXOPE_DIR" )
        _oView:EnableTitleView( "VIEW_ZGG", "Datas de Entrega" )

    _oView:SetCloseOnOk( { || .T. } )

Return( _oView )



/*/{Protheus.doc} fMontaTMP
Monta a estrutura da tabela temporária do cabecalho da programacao de entrega
@type function
@version 2020.08
@author Andre Fracassi
@since 14/08/2020
@param _cParam01, Caracter, Parâmetro com o alias da tabela temporária.
@return Object, Retorna o objeto da estrutura para o Model.
/*/
Static Function fMontaMdTMP( _cParam01 )

    Local _oStruct   := FWFormModelStruct():New()
    Local _aCampos   := {}

    AAdd( _aCampos, "TMP_FILIAL" )
    AAdd( _aCampos, "TMP_NUM"    )
    AAdd( _aCampos, "TMP_EMISSA" )
    AAdd( _aCampos, "TMP_FORNEC" )
    AAdd( _aCampos, "TMP_LOJA"   )
    AAdd( _aCampos, "TMP_NOME"   )

    _oStruct:AddTable( _cAliasSC7, _aCampos, "Follow Up Compras", Nil )

    //      AddField( < cTitulo >   , < cTooltip > , < cIdField >, < cTipo >, < nTamanho >, [ nDecimal ], [ bValid ], [ bWhen ], [ aValues ], [ lObrigat ], [ bInit ], < lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ] )
    _oStruct:AddField( "Filial"     , "Filial"     , "TMP_FILIAL", "C"      , 06          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )
    _oStruct:AddField( "Numero"     , "Numero"     , "TMP_NUM"   , "C"      , 06          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )
    _oStruct:AddField( "Dt. Emissao", "Dt. Emissao", "TMP_EMISSA", "D"      , 08          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )
    _oStruct:AddField( "Fornecedor" , "Fornecedor" , "TMP_FORNEC", "C"      , 06          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )
    _oStruct:AddField( "Loja"       , "Loja"       , "TMP_LOJA"  , "C"      , 02          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )
    _oStruct:AddField( "Nome"       , "Nome"       , "TMP_NOME"  , "C"      , 60          , 0           , NIL       , NIL      , NIL        , NIL         , NIL      , .T.     , NIL       , NIL         , NIL )

Return( _oStruct )



/*/{Protheus.doc} fMontaVTMP
Monta objeto da estrutura da View da programacao de entrega
@type function
@version 2020.08
@author Wagner Neves
@since 14/08/2020
@return Logico, Objeto da estrutura da view.
/*/
Static Function fMontaVdTMP( )

    Local _oStruct := FWFormViewStruct():New()

    //       AddField( <cIdField > , <cOrdem >  , <cTitulo >  , <cDescric > , <aHelp >   , <cType >    , <cPicture >, <bPictVar >, <cLookUp >, <lCanChange >, <cFolder >, <cGroup >, [ aComboValues ], [ nMaxLenCombo ], <cIniBrow >, <lVirtual >, <cPictVar >, [ lInsertLine ], [ nWidth ]
    _oStruct:AddField( "TMP_FILIAL", "01"       , "Filial"    , "Filial"    , Nil        , "C"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )
    _oStruct:AddField( "TMP_NUM"   , "02"       , "Numero"    , "Numero"    , Nil        , "C"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )
    _oStruct:AddField( "TMP_EMISSA", "03"       , "Dt Emissao", "Dt Emissao", Nil        , "D"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )
    _oStruct:AddField( "TMP_FORNEC", "04"       , "Fornecedor", "Fornecedor", Nil        , "C"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )
    _oStruct:AddField( "TMP_LOJA"  , "05"       , "Loja"      , "Loja"      , Nil        , "C"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )
    _oStruct:AddField( "TMP_NOME"  , "06"       , "Nome"      , "Nome"      , Nil        , "C"         , ""         , Nil        , Nil       , .F.          , Nil       , Nil      , Nil            , Nil              , Nil        , Nil        , Nil        , Nil            , Nil )

Return( _oStruct )



/*/{Protheus.doc} fValQtd
Valida Quantidade Programada x Saldo Item Pedido de Compra
@type function
@version 2020.08
@author Wagner Neves
@since 14/08/2020
@param _oViewZGG , Objeto  , Modelo da Grid do Detalhe da Programação de Entrega.
@param _nLine    , Numerico, Posição atual da linha do grid.
@param _cAction  , Caracter, Ação do Grid.
@param _cCampo   , Caracter, Campo que está sendo digitado.
@param _cValor   ,         , Valor atrinuido ao campo.
@param _cAtual   ,         , Valor atual do campo.
@return Logico, Retorna verdadeiro ou falso na validação.
/*/
Static Function fValQtd( _oViewZGG, _nLine, _cAction, _cCampo, _cValor, _cAtual )

    Local _lRet         := .T.
    Local _oModel       := FWModelActive()
    Local _oModelSC7D   := _oModel:GetModel("SC7DETAIL")
    Local _oModelZGG    := _oModel:GetModel("ZGGDETAIL")
    Local _nCont        := 0
    Local _nQtdProg     := 0
    Local _nQtdProd     := _oModelSC7D:GetValue("C7_QUANT")
    Local _nQtdQuJe     := _oModelSC7D:GetValue("C7_QUJE")
    Local _nSaldo       := ( _nQtdProd - _nQtdQuJe )


    For _nCont := 1 To _oModelZGG:Length()
        _oModelZGG:GoLine( _nCont )
        If !_oModelZGG:IsDeleted()
            _nQtdProg += _oModelZGG:GetValue("ZGG_QUANT")
        EndIf
    Next

    If _nQtdProg > _nSaldo
        Help( " ", 1, "QTDADE", ,"Quantidade Total Programada é Maior que a Qtdade do Item do Pedido", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Ajustar Quantidade"} /*aSoluc*/ )
        _lRet := .F.
    EndIf

Return( _lRet )



/*/{Protheus.doc} fLinePosZGG
Função que pós valida as ações do grid da Programação de Entrega
@type function
@version 2020.08
@author Wagner Neves
@since 20/08/2020
@param _oModelZGG, Objeto  , Modelo da GRID de Detalhes da Programação de Entrega
@param _nLine    , Numerico, Numero da linha para Validação
@param _cAction  , Caracter, Ação que está ocorrendo na grid para validação
@param _cCampo   , Caracter, Campo que está sofrendo a ação
@param _cValor   ,         , Valor que está sendo validado de acordo com o tipo do campo
@param _cAtual   ,         , Valor atual do campo que está sendo validado
@return Logico, Retorno logico sendo verdadeiro para validar a ação e falso para recusar a ação
/*/
Static Function fLinePosZGG( _oModelSD3, _nLine, _cAction, _cCampo, _cValor, _cAtual )

    Local _lRet         := .T.
    Local _oModel       := FWModelActive()
    Local _oModelSC7D   := _oModel:GetModel("SC7DETAIL")
    Local _oModelZGG    := _oModel:GetModel("ZGGDETAIL")
    Local _nCont        := 0
    Local _nQtdProg     := 0
    Local _nQtdProd     := _oModelSC7D:GetValue("C7_QUANT")
    Local _nQtdQuJe     := _oModelSC7D:GetValue("C7_QUJE")
    Local _nSaldo       := ( _nQtdProd - _nQtdQuJe )

    For _nCont := 1 To _oModelZGG:Length()
        _oModelZGG:GoLine( _nCont )
        If !_oModelZGG:IsDeleted()
            _nQtdProg += _oModelZGG:GetValue("ZGG_QUANT")
        EndIf
    Next

    If _nQtdProg > _nSaldo
        Help( " ", 1, "QTDADE", ,"Quantidade Total Programada é Maior que a Qtdade do Item do Pedido", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Ajustar Quantidade"} /*aSoluc*/ )
        _lRet := .F.
    EndIf

Return( _lRet )
