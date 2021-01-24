#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
/*/
=============================================================================
{Protheus.doc} MGFCRM54
Tela que permite alterar os ajustes de direcionamento

@description
Cadastra regra para Vendas interestaduais x Grupo tributário
Regra verificada pelo ponto de entrada

@author Wagner Nevers
@since 02/03/2020
@type User Function

@table
ZAV - Cabeçalho
ZAW - Itens
SD1 -

@param
NÃ£o se aplica

@return
NÃ£o se aplica

@menu
MGFCRM54 - Ajuste Direcionamento

@history
02/03/2020 - RTASK0010802 - Chamados RITM0038569 - Wagner Neves
/*/ 
User Function MGFCRM54()

    Local oBrowse		:= Nil
    Local aBKRotina		:= {}



    Private _cAlias	:=	"ZAV"
    Private aAR           := { } //AR vinculado ao RAMI e Documento de entrada. Será utilizado para validar é permitido alterar o motivo e para atualizar também o AR, se permitido.
    Private _cCodMot      := ' '
    Private _Motivo       := ' '
    Private _CodJus       := ' '
    Private _Justif       := ' '

    If Type('aRotina') <> 'U'
        aBKRotina		:= aRotina
    Endif
    aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias('ZAV')
    oBrowse:SetDescription('Ajuste Direcionamento')

    oBrowse:SetWalkThru(.F.)
    oBrowse:SetAmbiente(.F.)
    oBrowse:SetUseCursor(.F.)
    oBrowse:DisableLocate(.F.)
    oBrowse:DisableConfig()
    oBrowse:DisableDetails()
    oBrowse:Activate()
    aRotina	:= aBKRotina
Return( Nil )

/*
+------------------------------------------------------------------------------+
Â¦Programa  Â¦MENUDEF  Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+-------------------------------------------------------------------Â¦
*/

Static Function MenuDef()

    Local aRotina := {}
    aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFCRM54', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFCRM54', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Log Alteracao', "u_zVisLog1",0,5})
Return( aRotina )

/*
+------------------------------------------------------------------------------+
Â¦Programa  Â¦MODELDEF Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+-------------------------------------------------------------------Â¦
*/

Static Function ModelDef()
    Local oModel		:= Nil
    Local oSTRZAVCAB	:= FWFormStruct(1, "ZAV")
    Local oSTRZAWITE	:= FWFormStruct(1, "ZAW")
    Local bLinPreZAW	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZAW(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}

    aAux := nil

    aAux := FwStruTrigger(;
        'ZAW_DIRECI'						,;		    // DOMINIO
    'ZAW_MOTIVO'							,;			// CONTRA DOMINIO
    "u_getDirec(FWFldGet('ZAW_DIRECI'), 1)"	,;			// REGRA PREENCHIMENTO
    .F.										,;			// POSICIONA
    ,;	                                        		// ALIAS
    ,;			                                        // ORDEM
    ,;			                                        // CHAVE
    ".T."									,;			// CONDICAO
    )
    oSTRZAWITE:AddTrigger( ;
        aAux[1], ;                                      // [01] Id do campo de origem
    aAux[2], ;                                          // [02] Id do campo de destino
    aAux[3], ;                                          // [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                     		// [04] Bloco de codigo de execução do gatilho

    aAux := FwStruTrigger(;
        'ZAW_DIRECI'							,;	    // DOMINIO
    'ZAW_JUSTIF'								,;		// CONTRA DOMINIO
    "u_getDirec(FWFldGet('ZAW_DIRECI'), 2)"		,;		// REGRA PREENCHIMENTO
    .F.											,;		// POSICIONA
    ,;		                                            // ALIAS
    ,;		                                            // ORDEM
    ,;		                                            // CHAVE
    ".T."										,;		// CONDICAO
    )
    oSTRZAWITE:AddTrigger( ;
    aAux[1]			                            ,;		// [01] Id do campo de origem
    aAux[2]			                            ,;		// [02] Id do campo de destino
    aAux[3]			                            ,;		// [03] Bloco de codigo de validação da execução do gatilho
    aAux[4] )                                     		// [04] Bloco de codigo de execução do gatilho


// Propriedades cabealho
    oSTRZAVCAB:SetProperty( "ZAV_CODIGO" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_TPFLAG" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_TPFLAG"    , MODEL_FIELD_OBRIGAT,  .F. )
    oSTRZAVCAB:SetProperty( "ZAV_PEDIDO" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_NOTA" 	    , MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_SERIE" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_NFEMIS" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_CLIENT" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_LOJA" 	    , MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_NMCLI" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_REVEND" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_REVEND"    , MODEL_FIELD_OBRIGAT,  .F. )
    oSTRZAVCAB:SetProperty( "ZAV_DTABER" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_STATUS" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oSTRZAVCAB:SetProperty( "ZAV_NOMEUS" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )

// Propriedades item
    oStrZAWIte:SetProperty('ZAW_ID'		    ,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_ITEMNF'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_NOTA'	    ,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_SERIE'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_CDPROD'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_DESCPR'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_QTD'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_PRECO'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_TOTAL'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_DIRECI'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.T.,.T.) } )
    oStrZAWIte:SetProperty('ZAW_MOTIVO'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_JUSTIF'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_MTDES'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_OBS'	    ,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_STATUS'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_RESOLU'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_LOGUSR'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_MOTAFE'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )
    oStrZAWIte:SetProperty('ZAW_RESPAF'		,MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.F.) } )

    oModel:=MPFormModel():New("MODELO", Nil /*bPre*/, { |oMdl| bPost( oMdl ) } /*bPost*/, { |oMdl| bCommit( oMdl ) }/*bCommit*/, Nil /*bCancel*/ )
    oModel:AddFields("MODEL_ZAV_CAB", Nil, oSTRZAVCAB)
    oModel:AddGrid("MODEL_ZAW_ITE", "MODEL_ZAV_CAB", oSTRZAWITE, bLinPreZAW)
    oModel:SetPrimaryKey({"ZAV_CODIGO"})

    oModel:SetRelation("MODEL_ZAW_ITE",  {{"ZAW_FILIAL","ZAV_FILIAL"}   ,{"ZAW_CDRAMI","ZAV_CODIGO"}},ZAW->(IndexKey()))
    oModel:SetDescription('Ajuste Direcionamento')
    oModel:GetModel("MODEL_ZAW_ITE"):SetNoDeleteLine(.T.)
    oModel:GetModel("MODEL_ZAW_ITE"):SetNoInsertLine(.T.)

Return( oModel )

/*
+------------------------------------------------------------------------------+
Â¦Programa  Â¦VIEWDEF  Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+-------------------------------------------------------------------Â¦
*/
Static Function ViewDef()

    Local oModel	:= FWLoadModel("MGFCRM54") // Vincular o View ao Model
    Local oView		:= FWFormView():New() // Criacao da Interface
    Local oStrZAVC	:= FWFormStruct(2, 'ZAV')
    Local oStrZAWD	:= FWFormStruct(2, 'ZAW')


// Orderna colunas no item
    oStrZAWD:SetProperty('ZAW_ID'		    ,MVC_VIEW_ORDEM, '01')
    oStrZAWD:SetProperty('ZAW_ITEMNF'		,MVC_VIEW_ORDEM, '02')
    oStrZAWD:SetProperty('ZAW_NOTA'	    	,MVC_VIEW_ORDEM, '03')
    oStrZAWD:SetProperty('ZAW_SERIE'		,MVC_VIEW_ORDEM, '04')
    oStrZAWD:SetProperty('ZAW_CDPROD'		,MVC_VIEW_ORDEM, '05')
    oStrZAWD:SetProperty('ZAW_DESCPR'		,MVC_VIEW_ORDEM, '06')
    oStrZAWD:SetProperty('ZAW_DIRECI'		,MVC_VIEW_ORDEM, '07')
    oStrZAWD:SetProperty('ZAW_MOTIVO'		,MVC_VIEW_ORDEM, '08')
    oStrZAWD:SetProperty('ZAW_JUSTIF'		,MVC_VIEW_ORDEM, '09')
    oStrZAWD:SetProperty('ZAW_QTD'		    ,MVC_VIEW_ORDEM, '10')
    oStrZAWD:SetProperty('ZAW_PRECO'		,MVC_VIEW_ORDEM, '11')
    oStrZAWD:SetProperty('ZAW_TOTAL'		,MVC_VIEW_ORDEM, '12')
    oStrZAWD:SetProperty('ZAW_MTDES'		,MVC_VIEW_ORDEM, '13')
    oStrZAWD:SetProperty('ZAW_OBS'	    	,MVC_VIEW_ORDEM, '14')


// CAMPOS QUE SERÃƒO EXCLUIDOS DO CABEÃ‡ALHO 
    oStrZAVC:RemoveField( "ZAV_FILIAL" )
    oStrZAVC:RemoveField( "ZAV_TIPO" )
    oStrZAVC:RemoveField( "ZAV_ORDRET" )
    oStrZAVC:RemoveField( "ZAV_PLANTA" )
    oStrZAVC:RemoveField( "ZAV_NMCLI" )
    oStrZAVC:RemoveField( "ZAV_COMERC" )
    oStrZAVC:RemoveField( "ZAV_QUALID" )
    oStrZAVC:RemoveField( "ZAV_EXPEDI" )
    oStrZAVC:RemoveField( "ZAV_PCP" )
    oStrZAVC:RemoveField( "ZAV_TRANSP" )
    oStrZAVC:RemoveField( "ZAV_DTTRAN" )
    oStrZAVC:RemoveField( "ZAV_NMTRAN" )
    oStrZAVC:RemoveField( "ZAV_DTRET" )
    oStrZAVC:RemoveField( "ZAV_DTCOME" )
    oStrZAVC:RemoveField( "ZAV_DTEXPE" )
    oStrZAVC:RemoveField( "ZAV_DTPCP" )
    oStrZAVC:RemoveField( "ZAV_TRAN" )
    oStrZAVC:RemoveField( "ZAV_CODUSR" )
    oStrZAVC:RemoveField( "ZAV_MAILUS" )
    oStrZAVC:RemoveField( "ZAV_DTQUAL" )
    oStrZAVC:RemoveField( "ZAV_CONTA" )
    oStrZAVC:RemoveField( "ZAV_CREDEC" )


// CAMPOS QUE SERÃƒO EXCLUIDOS DO ITEM 
    oStrZAWD:RemoveField("ZAW_FILIAL")
    oStrZAWD:RemoveField("ZAW_CDRAMI")
    oStrZAWD:RemoveField("ZAW_STATUS")
    oStrZAWD:RemoveField("ZAW_RESOLU")
    oStrZAWD:RemoveField("ZAW_LOGUSR")
    oStrZAWD:RemoveField("ZAW_MOTAFE")
    oStrZAWD:RemoveField("ZAW_RESPAF")


    oView:SetModel(oModel)

    oView:AddField( 'VIEW_ZAVC' , oStrZAVC, "MODEL_ZAV_CAB" )

    oView:AddGrid('VIEW_ZAWD' , oStrZAWD, 'MODEL_ZAW_ITE' )

    oView:CreateHorizontalBox( 'SUPERIOR', 35,,,) //20
    oView:CreateHorizontalBox( 'INFERIOR', 65,,,) //80

    oView:AddIncrementField( 'VIEW_ZAWD', 'ZAW_ID' )

    oView:SetOwnerView( 'VIEW_ZAVC', 'SUPERIOR' )
    oView:SetOwnerView( 'VIEW_ZAWD', 'INFERIOR' )
Return( oView )

/*
+------------------------------------------------------------------------------+
Â¦Programa  Â¦BCANCEL  Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+-------------------------------------------------------------------Â¦
*/
Static Function bCancel(oModel)
    Local lRet := .T.
Return( lRet )

/*
+---------------------------------------------------------------------------------+
Â¦Programa  Â¦BCOMMIT      Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+----------------------------------------------------------------------Â¦
*/

Static Function bCommit( oModel )

    Local oModelCAB		:= oModel:GetModel('MODEL_ZAV_CAB')
    Local oModelITE		:= oModel:GetModel('MODEL_ZAW_ITE')
    Local nOperation 	:= oModel:GetOperation()
    Local cFilialZAV	:= xFilial("ZAV")
    Local cFilialZAW	:= xFilial("ZAW")
    Local _cSenha       := ZAV->ZAV_CODIGO
    Local nI			:= 00
    Local lRet 			:= .T.
    Local nTamArray1	:= oModelITE:Length()
    Local _cDireci      := ' '
    Local _cMotivo      := ' '
    Local _cJustif      := ' '
    Local _lRes         := .F.
    Local cAliasZaw     := GetNextAlias()
    Local _cFilial      := ' '
    Local _cItemNf      := ' '
    Local _cCdRami      := ' '
    Begin Transaction

        If  nOperation == MODEL_OPERATION_UPDATE

            For nI := 01 to nTamArray1

                oModelITE:GoLine(nI)

                _cFilial := cFilialZAW
                _cItemNf := oModelITE:GetValue( 'ZAW_ITEMNF')
                _cCdRami := oModelITE:GetValue( 'ZAW_CDRAMI')
                _cCdiD   := oModelITE:GetValue( 'ZAW_ID')

                If Select(cAliasZaw) > 0
                    (cAliasZaw)->(DbClosearea())
                Endif

                BeginSql Alias cAliasZAW
    	        SELECT  
                    ZAW_ITEMNF,ZAW_CDRAMI,ZAW_DIRECI, ZAW_MOTIVO, ZAW_JUSTIF,ZAW_CDPROD,ZAW_QTD
	            FROM 
                    %Table:ZAW% ZAW
	            WHERE
    	            ZAW.ZAW_FILIAL  = %EXP:cFilialZAW% AND
	                ZAW.ZAW_CDRAMI  = %EXP:_cCdRami%  AND
                    ZAW.ZAW_ITEMNF  = %EXP:_cItemNf%  AND
                    ZAW.ZAW_ID      = %EXP:_cCdiD%  AND                    
	                ZAW.%notdel%
                EndSql
                (cAliasZAW)->(DbGoTop())
                If ALLTRIM((cAliasZAW)->ZAW_DIRECI) <> ALLTRIM(oModelITE:GetValue( 'ZAW_DIRECI'))
                    _cDirNovo:= ALLTRIM(oModelITE:GetValue( 'ZAW_DIRECI'))
                    _cDireci := (cAliasZAW)->ZAW_DIRECI
                    _lRes := .T.
                ENDIF

                If ALLTRIM((cAliasZAW)->ZAW_MOTIVO) <> ALLTRIM(oModelITE:GetValue( 'ZAW_MOTIVO'))
                    _cMotNovo:= ALLTRIM(oModelITE:GetValue( 'ZAW_MOTIVO'))
                    _cMotivo := (cAliasZAW)->ZAW_MOTIVO
                    _lRes := .T.
                ENDIF

                If ALLTRIM((cAliasZAW)->ZAW_JUSTIF) <> ALLTRIM(oModelITE:GetValue( 'ZAW_JUSTIF'))
                    _cJusNovo:= ALLTRIM(oModelITE:GetValue( 'ZAW_JUSTIF'))
                    _cJustif := (cAliasZAW)->ZAW_JUSTIF
                    _lRes := .T.
                ENDIF

                // Grava ZAW
                If ZAW->( DbSeek( cFilialZAW + oModelITE:GetValue( 'ZAW_CDRAMI' ) + oModelITE:GetValue('ZAW_ITEMNF')) )
                    WHILE .T.
                        IF ZAW->ZAW_ID == _cCdiD    
                            RecLock('ZAW', .F.)
                            ZAW->ZAW_DIRECI	       := oModelITE:GetValue( 'ZAW_DIRECI')
                            ZAW->ZAW_MOTIVO	       := oModelITE:GetValue( 'ZAW_MOTIVO')
                            ZAW->ZAW_JUSTIF	       := oModelITE:GetValue( 'ZAW_JUSTIF')
                            ZAW->(MsUnlock())
                            EXIT
                        else
                            ZAW->(dbskip())
                        endif
                    ENDDO
                ENDIF

                //Se houve alteração grava SD1 e ZZI (Item AR), t1005551 
                If _lRes .AND. ;
                        RetornaZau(_cFilial,oModelITE:GetValue( 'ZAW_DIRECI')) //Preenche os codigos e descrição dos motivos e justificativas conforma o novo direcionamento 
                        
                    _cProd    := oModelITE:GetValue( 'ZAW_CDPROD')
                    _cQtd     := oModelITE:GetValue( 'ZAW_QTD')

                    zGravSd1(_cCdRami,_cItemNf,_cProd,_cQtd)

                    // Atualiza o motivo do AR.
                    If !Empty(aAR)
                        If !UpdateAR(aAR[1],aAR[2],_cProd) //Filial AR, Numero AR, Produto, Justificativa
                            Help(,,"MGFCRM54 - Validação do AR",,"Não foi possível Atualziar o AR "+ aAR[1] + " .",1,0,,,,,,{"Verifique se o AR já está encerrado"})
                        EndIf
                    EndIf

                    If CV8->(FieldPos("CV8_IDMOV")) > 0 .And. !Empty(CV8->(IndexKey(5)))
                        __cIdCV8:= GetSXENum("CV8","CV8_IDMOV",,5)
                        cIdCV8 	:= __cIdCV8
                        ConfirmSX8()
                    EndIf
                    
                    cMsg := "Alteração : Item "+STRZERO(VAL(_cItemNf),4)+" - Direcionamento de "+Alltrim(_cDireci)+" para "+Alltrim(_cDirNovo)

                    xGravCV8("A",ZAV->ZAV_CODIGO,cMsg,Nil,"MGFCRM54",Nil,Nil,__cIdCV8)
                                        
                    _lRes := .F.

                ENDIF

            Next nI

        EndIf

    End Transaction

Return( lRet )

Static Function xGravCv8(cType, cBatchProc, cMsg, cDetalhes, cSubProc, cMsgSubProc, lCabec, cIdCV8)
Local lCpoSub	:= CV8->(FieldPos("CV8_SBPROC")) > 0
Local lCpoId	:= CV8->(FieldPos("CV8_IDMOV")) > 0
Default lCabec	:= Nil
Default cIdCV8	:= ""
	If 	(Valtype(lCabec) == "L" .And. lCabec ) .Or. Valtype(lCabec) == "U"
		dbSelectArea("CV8")
		RecLock("CV8",.T.)
			CV8->CV8_FILIAL:= xFilial("CV8")
			CV8->CV8_DATA 	:= MsDate()
			CV8->CV8_HORA 	:= SubStr(Time(),1,TamSx3("CV8_HORA")[1])
			CV8->CV8_PROC	:= cBatchProc
			CV8->CV8_USER	:= cUserName+"-"+Subs(UsrFullName(__cUseriD),1,20)
			CV8->CV8_INFO   := cType
			CV8->CV8_MSG 	:= Alltrim(cMsg)
			CV8->CV8_DET	:= cDetalhes
			If lCpoSub
				CV8->CV8_SBPROC := cSubProc
			EndIf
			If lCpoId
				CV8->CV8_IDMOV := cIdCV8
			EndIf
		MsUnlock()
	EndIf

Return



/*
+---------------------------------------------------------------------------------+
Â¦Programa  Â¦LINEPREZAW  Â¦ Autor Â¦ "Wagner Neves"  - Marfrig  Â¦ Data Â¦ 31.10.2019Â¦
+----------+----------------------------------------------------------------------Â¦

@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, Ação UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno

*/

Static Function LinePreZAW( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )

    Local lRet 			:= .T.
    Local oModelITE		:= oModel:GetModel( 'MODEL_ZAW_ITE' )
    Local nI			:= 00
    Local nLineZAW		:= oModelITE:GetLine()
    Local nTamArray1	:= oModelITE:Length()

    Begin Sequence

        If cAction == "SETVALUE"

            If cIDField == 'ZAW_CDRAMI'

                oModelITE:SetValue( 'ZAW_CDRAMI', FwFldGet('ZAW_CDRAMI'))

                For nI := 01 to nTamArray1

                    If nI <> nLineZAW

                        oModelITE:GoLine(nI)

                        If xValue == oModelITE:GetValue( 'ZAW_CDRAMI' )

                            oModel:SetErrorMessage(, , , ,'LinePreZAW' , "Codigo já informado no item: " + oModelITE:GetValue( 'ZAW_ID' ), "Alterar Grupo de Tributação já informado", , )
                            lRet := .F.; Break

                        Endif

                    Endif

                Next nI

            Endif

        Endif
    End Sequence
    oModelITE:GoLine(nLineZAW)
Return( lRet )


/*/{Protheus.doc} zGravSd1
Atualiza os itens do Documento de entrada com os novos motivos e justificativas
@type  Static Function
@author Natanael Filho
@since 02/07/2020
@version 12.1.17
@param _cCdRami, char, Numero da RAMI
@param _cItemNf, char, Item da Nota fiscal
@param _cProd, char, Código do Produto
@param _cQtd, char, Quantidade do Produto
@example
(examples)
@see (links_or_references)
/*/
Static Function zGravSd1(_cCdRami,_cItemNf,_cProd,_cQtd)

    Local cFilialZAW    := xFilial("ZAW")
    Local cAliasSd1     := GetNextAlias()
    Local nSd1          := 0

    If Select(cAliasSd1) > 0
        (cAliasSd1)->(DbClosearea())
    Endif
  
    BeginSql Alias cAliasSd1
        Select 
            zaw_filial filial,zaw_cdrami rami,zaw_itemnf itemnf,count(*) contador
        FROM 
            %Table:ZAW% ZAW
        WHERE 
            zaw.%notdel% AND
            zaw_filial=%EXP:cFilialZAW% AND
            zaw_cdrami=%EXP:_cCdRami%
            having count(*) > 1
            group by zaw_filial,zaw_cdrami,zaw_itemnf
    EndSql

    Count To nSd1

    (cAliasSd1)->(DbGoTop())
    If nSd1 > 0 .And. (cAliasSd1)->Contador > 1     
        cQuery := " Update "+RetSqlName("SD1")
        cQuery += " Set "
        cQuery += " D1_ZCODMOT='"+_cCodMot+"',"
        cQuery += "D1_ZDESCMO='"+_Motivo+"',"
        cQuery += "D1_ZCODJUS='"+_CodJus+"',"
        cQuery += "D1_ZDESCJU='"+_Justif+"'"
        cQuery += " Where D1_FILIAL = '"+xFilial('SD1')+"'"
        cQuery += " AND D1_ZRAMI = '"+_cCdRami+"'"
        cQuery += " AND D1_ITEMORI ='"+_cItemNf+"'"
        cQuery += " AND D1_COD ='"+_cProd+"'"
        cQuery += " AND D1_QUANT ='"+Alltrim(STR(_cQtd))+"'"
        cQuery += " AND d_e_l_e_t_ = ' '"
        IF (TcSQLExec(cQuery) < 0)
            bContinua   := .F.
            MsgStop(TcSQLError())
        ENDIF
    else
        cQuery := " Update "+RetSqlName("SD1")
        cQuery += " Set "
        cQuery += " D1_ZCODMOT='"+_cCodMot+"',"
        cQuery += "D1_ZDESCMO='"+_Motivo+"',"
        cQuery += "D1_ZCODJUS='"+_CodJus+"',"
        cQuery += "D1_ZDESCJU='"+_Justif+"'"
        cQuery += " Where D1_FILIAL = '"+xFilial('SD1')+"'"
        cQuery += " AND D1_ZRAMI = '"+_cCdRami+"'"
        cQuery += " AND D1_ITEMORI ='"+_cItemNf+"'"
        cQuery += " AND d_e_l_e_t_ = ' '"
        IF (TcSQLExec(cQuery) < 0)
            bContinua   := .F.
            MsgStop(TcSQLError())
        ENDIF
    endif

    (cAliasSd1)->(DbClosearea())

Return
    
User Function zVisLog1()
_cRecno := ZAV->(Recno())
ProcLogView(cFilAnt,ZAV->ZAV_CODIGO,"MGFCRM54")
Go _cRecno
Return


/*/{Protheus.doc} bPost
    Validação pós validação do Modelo, Equivale ao "Tudo OK"
    @type  Static Function
    @author Natanael Filho
    @since 01/07/2020
    @version 12.1.17
    @param oModel, Object FWFormModel, Modelo MVC
    @return lRet, Bolean, Confirma ou não o commit
    @example
    -
    @see (links_or_references)
    -
    /*/
Static Function bPost(oModel)

    Local oModelCAB		:= oModel:GetModel('MODEL_ZAV_CAB')
    Local oModelITE		:= oModel:GetModel('MODEL_ZAW_ITE')
    Local nOperation    := oModel:GetOperation()
    Local cFilialZAV	:= xFilial("ZAV")
    Local cFilialZAW	:= xFilial("ZAW")
    Local nTamArray1	:= oModelITE:Length() // Quantidade de linhas do Grid
    Local lRet := .T.
    Local aRetTaura     := { } //Array de Retorno Taura referente ao AR.{Cod}
    Local aProdJus       := { } //Array com Produto e Justificativa para ser enviado ao Taura
    Local cNota := ' ',cSerie := ' ',cCodFor := ' ',cLojFor := ' ' //Documento, Serie, Fornecedor/Cliente / Loja For/Cli

    //Valida apenas alterações
    If nOperation == MODEL_OPERATION_UPDATE .AND. lRet
        cNota   := oModelcab:GetValue("ZAV_NOTA")
        cSerie  := oModelcab:GetValue("ZAV_SERIE")
        cCodFor := oModelcab:GetValue("ZAV_CLIENT")
        cLojFor := oModelcab:GetValue("ZAV_LOJA")
        cDireci := oModelIte:GetValue("ZAW_DIRECI") //Motivo x Justificativa

    //Caso não esteja finalizada, prosseguir normalmente com a atualização da RAMI no Protheus e não será necessária a integração pois a informação ainda não existe no Taura
        If (oModelcab:GetValue("ZAV_STATUS") == '1'; //1: Finalizado
            .AND. oModelcab:GetValue("ZAV_TPFLAG") != '1' ); //1: devolução ; 2: Reclamação
             .AND. lRet
            
            //O programa deverá verificar se a RAMI possui um AR vinculado
            aAR:= aGetAR(cFilialZAV,cNota,cSerie,cCodFor,cLojFor) // {AR,Status}
            
            //Caso não exista um AR, prosseguir com a atualização da RAMI no Protheus e não será necessária a integração pois a informação não existe no Taura.
            If !EMPTY(aAR)
                If aAR[3] != '0' // AR já enviado ao Taura. Se não foi enviado ainda "0", pode deixar alterar normalmente.

                    //Monta o array com Produto e Justificativa para ser enviado ao Taura
                    For nCount := 1 to oModelITE:Length()
                        oModelITE:GoLine(nCount)

                        If RetornaZau(cFilialZAV,oModelITE:GetValue( 'ZAW_DIRECI')) //Preenche os codigos e descrição dos motivos e justificativas conforma o novo direcionamento 
                            Aadd(aProdJus,{;
                                    Alltrim(oModelITE:GetValue("ZAW_CDPROD")),; //Produto
                                    Alltrim(_CodJus)}) //Justificativa
                        Else
                            Help(,,"[MGFCRM54] Validação do AR Taura",,"Direcionamento não encontrado na tabela de MOTIVO X JUSTIFICATIVA RAMI (ZAU)"/*Mensagem de retorno do Taura*/,1,0)
                        EndIf
                    Next nCount

                    FWMSGRUN( , {|| aRetTaura := U_MGFTAE30(aAR[1]/*Filial*/,aAR[2]/*AR*/,aProdJus/*{{Produtos,Justificativa},{Produtos,Justificativa}}*/); //Consulta se o AR pode ser alterado no Taura.
                                             }, "Aguarde!" , 'Validando a alteração do AR no Taura.' )
                    If !Empty(aRetTaura)
                        If aRetTaura[1] = 2 // Status 2, houve mensagem de erro do Taura
                            lRet := .F.
                            Help(,,"[MGFCRM54] Validação do AR Taura",,aRetTaura[2]/*Mensagem de retorno do Taura*/,1,0)
                        EndIf    
                    EndIf
                EndIf
            EndIf
        EndIf

    EndIf

    
Return lRet


/*/{Protheus.doc} aGetAR
    Verifica se existe AR para a RAMI/Doc de Devolução
    @type  Static Function
    @author Natanael Filho
    @since 02/07/2020
    @version 12.1.17
    @param cFilDoc, char, Filial
    @param cNota, char, Documento de Entrada
    @param cSerie, char, Serie do Documento de Entrada
    @param cCodFor, char, Forcedor / Cliente
    @param cLojFor, char, Loja Forcedor / Cliente
    @return aRet, Array, Retorna o AR e o Status
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function aGetAR(cFilDoc,cNota,cSerie,cCodFor,cLojFor)

    Local cNextAlias:= GetNextAlias()
    Local aRet := {}

    If Select(cNextAlias) > 0
        (cNextAlias)->(DbClosearea())
    Endif


    BeginSql Alias cNextAlias

        SELECT ZZH_FILIAL, ZZH_AR, ZZH_STATUS
        FROM 
            %Table:ZZH% ZZH
        WHERE
            ZZH.%NotDel% AND
            ZZH.ZZH_FILIAL = %Exp:cFilDoc% AND
            ZZH.ZZH_DOC = %Exp:cNota% AND
            ZZH.ZZH_SERIE = %Exp:cSerie% AND	
            ZZH.ZZH_FORNEC = %Exp:cCodFor% AND
            ZZH.ZZH_LOJA = %Exp:cLojFor%
        EndSql

        (cNextAlias)->(DbGoTop())

        If (cNextAlias)->(!EOF())
            aADD(aRet,(cNextAlias)->ZZH_FILIAL)
            aADD(aRet,(cNextAlias)->ZZH_AR)
            aADD(aRet,(cNextAlias)->ZZH_STATUS)
        EndIf

        (cNextAlias)->(DbClosearea())

Return aRet

/*/{Protheus.doc} UpdateAR
    Atualiza o AR, se existente, com os novos motivos
    @type  Static Function
    @author Natanael Filho
    @since 02/07/2020
    @version 12.1.17
    @param cFilDoc, char, Filial
    @param cAR, char, Numero do AR
    @param cProd, char, Produto
    @param cNovodir, char, Justificativa
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function UpdateAR(cFilAR,cAR,cProd)

    Local lARRet        := .F.

    //ZZI: AR ITENS
    cQuery := " Update "+RetSqlName("ZZI")
    cQuery += " Set "
    cQuery += " ZZI_CODMOT='"+_cCodMot+"',"
    cQuery += " ZZI_CODJUS='"+_CodJus+"' "
    cQuery += " Where ZZI_FILIAL = '" + cFilAR + "'"
    cQuery += " AND ZZI_AR = '" + cAR + "'"
    cQuery += " AND ZZI_PRODUT ='"+ cProd +"'"
    cQuery += " AND D_E_L_E_T_ = ' '"
    IF (TcSQLExec(cQuery) < 0)
        bContinua   := .F.
        MsgStop(TcSQLError())
    Else
        lARRet := .T.
    EndIf


Return lARRet


/*/{Protheus.doc} aRetZau
Preenche os codigos e descrição dos motivos e justificativas conforma o novo direcionamento
@type  Static Function
@author Natanael Filho
@since 02/07/2020
@version 12.1.17
@param cFilialZAU, char, Filial ZAU
@param _cNovodir, char, Novo Direcionamento
@return		lRetZau, Boolean, Retorna se foi encontrado ou não o registro na ZAU
@example
(examples)
@see (links_or_references)
/*/
Static Function RetornaZau(cFilialZAU,_cNovodir)

   Local cAliasZau     := GetNextAlias()
   Local lRetZau       := .F.
   Local nZau          := 0

    If Select(cAliasZau) > 0
        (cAliasZau)->(DbClosearea())
    Endif

    BeginSql Alias cAliasZAU
    SELECT  
        ZAU_CODIGO,ZAU_CODMOT,ZAU_MOTIVO,ZAU_CODJUS,ZAU_JUSTIF
    FROM 
        %Table:ZAU% ZAU
    WHERE
        ZAU.ZAU_FILIAL  = %EXP:cFilialZAU% AND
        ZAU.ZAU_CODIGO  = %EXP:_cNovoDir%  AND
        ZAU.%notdel%
    EndSql
    
    Count To nZau
    (cAliasZAU)->(DbGoTop())

    If nZau > 0
        _cCodMot :=ALLTRIM((cAliasZAU)->ZAU_CODMOT) //D1_ZCODMOT
        _Motivo := ALLTRIM((cAliasZAU)->ZAU_MOTIVO) //D1_ZDESCMO
        _CodJus := ALLTRIM((cAliasZAU)->ZAU_CODJUS) //D1_ZCODJUS
        _Justif := ALLTRIM((cAliasZAU)->ZAU_JUSTIF) //D1_ZDESCJU 
       lRetZau  := .T. 
    EndIf

    (cAliasZau)->(DbClosearea())

Return lRetZau
