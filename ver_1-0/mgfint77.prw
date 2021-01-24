#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFINT77
Inicialização do Processo de gravação de fornecedores autorizados
para importação do xml.
Seleção efetuada via MarkBrowse
@author Luiz Cesar Silva
@since 10/09/2020
@version P11
/*/
//-------------------------------------------------------------------

User Function MGFINT77()
    FwMsgRun(, {|| U_xBuscSA2() }, "Processando", "Aguarde. Movendo arquivos para processamento" )
return

//-------------------------------------------------------------------
/*/{Protheus.doc} xBuscSA2
Processa Filtro do SA2 - Fornecedores
@author Luiz Cesar Silva
@since 10/09/2020
@version P11
/*/
//-------------------------------------------------------------------
User Function xBuscSA2()

// Preparar Paramxbox
// Parametros para cnsiderar :
// Codigo Loja de Ate
// CNPJ de Ate

  Local _lRet         := .F.
    Local _cTitPerg     := "Parâmetros Filtro Fornecedores"

    Private _aRet       := {}
    Private _aParam     := {}

    AAdd( _aParam, { 1, "Fornecedor De" , Space( TamSx3("A2_COD")[ 01 ] )	        , "@!"  , 'Vazio() .OR. ExistCpo("SA2", MV_PAR01 )' , "SA2"	, "", 015, .F. } )          //MV_PAR01
    AAdd( _aParam, { 1, "Fornecedor Até", Replicate("Z", TamSx3("A2_COD")[ 01 ] )	, "@!"  , ""                                        , "SA2"	, "", 015, .T. } )          //MV_PAR02
    AAdd( _aParam, { 1, "Loja De"       , Space( TamSx3("A2_LOJA")[ 01 ] )	        , "@!"  , ""                                        , ""    , "", 015, .F. } )          //MV_PAR03
    AAdd( _aParam, { 1, "Loja Até"      , Replicate("Z", TamSx3("A2_LOJA")[ 01 ] )	, "@!"  , ""                                        , ""    , "", 015, .T. } )          //MV_PAR04
    If ParamBox( _aParam, _cTitPerg, @_aRet )
        MsAguarde( { || U_xProcForn( _aRet[ 01 ], _aRet[ 02 ], _aRet[ 03 ], _aRet[ 04 ] ) }, "Aguarde...", "Selecionando Fornecedores", .T. )
        _lRet := .T.
    EndIf

Return( _lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} xProcForn
Processa Filtro do SA2 - Fornecedores
@author Luiz Cesar Silva
@since 10/09/2020
@version P11
/*/
//-------------------------------------------------------------------
User Function XPROCFORN(cFornde,cFornAte,cLojde,cLojate)

	
    Private oMark
    Private aRotina := MenuDef()
    Private _cFornini  := cFornde
    Private _cFornFim  := cFornate

    oMark := FWMarkBrowse():New()
    oMark:SetAlias("SA2")
    oMark:SetSemaphore(.T.)
    oMark:SetDescription('Seleção de Fornecedores')
    oMark:SetFieldMark( 'A2_OK' )
    oMark:SetFilterDefault('A2_FILIAL==XFILIAL("SA2") .AND. A2_COD >= "'+cFornde+'" .AND. A2_COD <= "'+cFornate+'" .AND. A2_LOJA >= "'+cLojde+'" .AND. A2_LOJA <= "'+cLojate+'" .AND. A2_MSBLQL <> "1" ')
    oMark:SetAllMark( { || oMark:AllMark() } )
    oMark:Activate()

Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Processar' ACTION 'U_COMP77PROC()' OPERATION 2 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()

Return FWLoadModel( 'COMP77_MVC' )

//-------------------------------------------------------------------
Static Function ViewDef()

Return FWLoadView( 'COMP77_MVC' )

//-------------------------------------------------------------------
/*/{Protheus.doc} COMP77PROC
Chamado do processo de gravação no ZHB - Fornecedor Autorizado para importar xml
@author Luiz Cesar Silva
@since 10/09/2020
@version P11
/*/
//-------------------------------------------------------------------
User Function COMP77PROC()

MsAguarde( { || U_xGravaForn() }, "Aguarde...", "Gravando Fornecedores", .T. )
oMark:CleanFilter()
oMark:SetFilterDefault('SA2->A2_COD = "ZZZZZZ"')

Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} xGravaForn
Efetiva o processo de gravação no ZHB - Fornecedor Autorizado para importar xml
@author Luiz Cesar Silva
@since 10/09/2020
@version P11
/*/
//-------------------------------------------------------------------
User Function xGravaForn()

Local aArea := GetArea()
Local cMarca := oMark:Mark()
Local lInverte := oMark:IsInvert()

Local nCt := 0

Local _cAliasQry  := GetNextAlias()

BeginSql Alias _cAliasQry
        SELECT 
            A2_COD,A2_LOJA, A2_NOME, A2_CGC,A2_OK
        FROM
            %table:SA2% SA2
        WHERE
                SA2.A2_FILIAL  = %xFilial:SA2%
            AND SA2.A2_COD BETWEEN %Exp:_cFornini% AND %Exp:_cFornfim%  
            AND SA2.A2_OK = %Exp:cMarca%
            AND SA2.%notDel%
EndSql

DbSelectArea( _cAliasQry )
( _cAliasQry )->( DbGoTop() )

While !( _cAliasQry )->( EOF() ) 

    ZHB->(dbsetorder(1))
    IF !ZHB->(dbseek(xFilial("ZHB")+( _cAliasQry )->A2_COD+( _cAliasQry )->A2_LOJA)) .AND. ( _cAliasQry )->A2_OK==cMarca 

       dbselectArea("ZHB")
       reclock("ZHB",.T.)
            ZHB->ZHB_FORNEC  := ( _cAliasQry )->A2_COD    
            ZHB->ZHB_LOJA    := ( _cAliasQry )->A2_LOJA   
            ZHB->ZHB_NOME    := ( _cAliasQry )->A2_NOME   
            ZHB->ZHB_CGC     := ( _cAliasQry )->A2_CGC    
       MsUnLock()
    EndIf
    DbSelectArea( _cAliasQry )
    ( _cAliasQry )->( dbSkip() )
End 

dbclosearea(_cAliasQry)

RestArea( aArea )

Return NIL
