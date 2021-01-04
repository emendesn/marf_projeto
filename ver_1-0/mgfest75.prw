#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} MGFEST75
Cadastro de insums x fornecedor

@description
Cadastra insumos por fornecedor 

@author Wagner Neves
@since 15/05/2020
@type User Function

@table 
    ZG9 - Cabeçalho 
    ZGA - Itens 

@param
    Não se aplica
    
@return
    Não se aplica

@menu
    MGFEST75 - Insumos x Fornecedor

@history 
    15/05/2020 - RTASK0011129
/*/ 

User Function MGFEST75()

Local oBrowse		:= Nil
Local aBKRotina		:= {}
Private _cTipoProd    := GetMv("MGF_EST75",,"EM")
If Type('aRotina') <> 'U'
	aBKRotina		:= aRotina
Endif	
aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZG9')
oBrowse:SetDescription('Cadastro de Insumos x Fornecedor')

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
¦Programa  ¦MENUDEF  ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020¦
+----------+-------------------------------------------------------------------¦
*/

Static Function MenuDef()

Local aRotina := {}
aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFEST75', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.MGFEST75', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFEST75', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.MGFEST75', 0, 5, 0, NIL } )
//aAdd( aRotina, { 'Imprimir'		, 'VIEWDEF.MGFEST75', 0, 5, 0, NIL } )
Return( aRotina )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MODELDEF ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020¦
+----------+-------------------------------------------------------------------¦
*/

Static Function ModelDef()
Local oModel		:= Nil
Local oSTRZG9CAB	:= FWFormStruct(1, "ZG9")     
Local oSTRZGAITE	:= FWFormStruct(1, "ZGA")     
Local bLinPreZGA	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZGA(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}
Local aGatCabec		:= {}
Local aGatItem		:= {}

oSTRZG9CAB:SetProperty( "ZG9_CODPRO" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.T.) } )
oSTRZG9CAB:SetProperty( "ZG9_CODPRO" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZG9CAB:SetProperty( "ZG9_FORNEC" 	, MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.T.) } )
oSTRZG9CAB:SetProperty( "ZG9_FORNEC"  	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZG9CAB:SetProperty( "ZG9_LOJA" 	    , MODEL_FIELD_WHEN,{ ||If(ALTERA,.F.,.T.) } )
oSTRZG9CAB:SetProperty( "ZG9_LOJA"  	, MODEL_FIELD_OBRIGAT,  .T. )

oSTRZGAITE:SetProperty( "ZGA_ITEFIL"  , MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGAITE:SetProperty( "ZGA_LEADTM"  , MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGAITE:SetProperty( "ZGA_TRANST"  , MODEL_FIELD_OBRIGAT,  .T. )
oSTRZGAITE:SetProperty( "ZGA_ESTMIN"  , MODEL_FIELD_OBRIGAT,  .T. )

//-----------------------------------Inicio dos gatilhos

// Gatilhos Cabeçalho
aGatCabec := FwStruTrigger ( 'ZG9_CODPRO'    /*cDom*/, 'ZG9_DESCRI' /*cCDom*/, "StaticCall( MGFEST75, GZG9_PROD )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZG9CAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

aGatCabec := FwStruTrigger ( 'ZG9_LOJA'    /*cDom*/, 'ZG9_NOMFOR' /*cCDom*/, "StaticCall( MGFEST75, GZG9_FORN1 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZG9CAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

aGatCabec := FwStruTrigger ( 'ZG9_LOJA'    /*cDom*/, 'ZG9_MUN' /*cCDom*/, "StaticCall( MGFEST75, GZG9_FORN2 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZG9CAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

aGatCabec := FwStruTrigger ( 'ZG9_LOJA'    /*cDom*/, 'ZG9_UF' /*cCDom*/, "StaticCall( MGFEST75, GZG9_FORN3 )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZG9CAB:AddTrigger( aGatCabec[1] /*cIdField*/, aGatCabec[2] /*cTargetIdField*/, aGatCabec[3] /*bPre*/, aGatCabec[4] /*bSetValue*/ )

// Gatilhos Item
aGatItem := FwStruTrigger ( 'ZGA_ITEFIL'    /*cDom*/, 'ZGA_FILNOM' /*cCDom*/, "StaticCall( MGFEST75, GZGA_FILIA )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZGAITE:AddTrigger( aGatiTEM[1] /*cIdField*/, aGatiTEM[2] /*cTargetIdField*/, aGatiTEM[3] /*bPre*/, aGatiTEM[4] /*bSetValue*/ )

//-------------------------------------------- FIM DOS GATILHOS

oModel:= MPFormModel():New("MODELO", Nil, Nil, { |oMdl| bCommit( oMdl ) } )
oModel:AddFields("MODEL_ZG9_CAB", Nil, oSTRZG9CAB)
oModel:AddGrid("MODEL_ZGA_ITE", "MODEL_ZG9_CAB", oSTRZGAITE, bLinPreZGA)
oModel:SetPrimaryKey({"ZG9_CODPRO","ZG9_FORNEC","ZG9_LOJA"})

oModel:SetRelation("MODEL_ZGA_ITE",  {{"ZGA_FILIAL","ZG9_FILIAL"},{"ZGA_CODPRO","ZG9_CODPRO"},{"ZGA_FORNEC","ZG9_FORNEC"},{"ZGA_LOJA","ZG9_LOJA"}},ZGA->(IndexKey(1)))
oModel:SetDescription('Insumos x Fornecedor')
oModel:GetModel( "MODEL_ZGA_ITE" ):SetDescription( 'Filiais' )
Return( oModel ) 

/*
+------------------------------------------------------------------------------+
¦Programa  ¦VIEWDEF  ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020     ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ViewDef()

Local oModel	:= FWLoadModel("MGFEST75") // Vincular o View ao Model
Local oView		:= FWFormView():New() // Criacao da Interface
Local oStrZG9C	:= FWFormStruct(2, 'ZG9')
Local oStrZGAD	:= FWFormStruct(2, 'ZGA')

// CAMPOS QUE SERÃO EXCLUIDOS DO CABEÇALHO 
//oStrZG9C:RemoveField( "ZG9_" )

// CAMPOS QUE SERÃO EXCLUIDOS DO ITEM 
oStrZGAD:RemoveField( "ZGA_CODPRO")
oStrZGAD:RemoveField( "ZGA_FORNEC")
oStrZGAD:RemoveField( "ZGA_LOJA")

oView:SetModel(oModel)
oView:AddField( 'VIEW_ZG9C' , oStrZG9C, "MODEL_ZG9_CAB" )
oView:AddGrid(  'VIEW_ZGAD' , oStrZGAD, 'MODEL_ZGA_ITE' )

oView:CreateHorizontalBox( 'SUPERIOR', 35,,,) //20
oView:CreateHorizontalBox( 'INFERIOR', 65,,,) //80

//oView:AddGrid(  'VIEW_ZG9D' , oStrZG9D, 'MODEL_ZG9_ITE' )
oView:AddIncrementField( 'VIEW_ZGAD', 'ZGA_ITEM' )

oView:SetOwnerView( 'VIEW_ZG9C', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZGAD', 'INFERIOR' )
Return( oView )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦BCANCEL  ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCancel(oModel)
Local lRet := .T.
Return( lRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZG9_PROD ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020    ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZG9_PROD()
Local cRet	:= ''
SB1->(DbSetOrder(1))
SB1->(DBGOTOP())
If SB1->( dbSeek( xFilial('SB1') + FwFldGet("ZG9_CODPRO") ))
    cRet    :=  SB1->B1_DESC
EndIf
Return( cRet )

/*+----------------------------------------------------------------------------+
¦Programa  ¦GZG9_FORN1 ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020    ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZG9_FORN1()
Local cRet	:= ''
SA2->(DbSetOrder(1))
SA2->(DBGOTOP())
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZG9_FORNEC")+FwFldGet("ZG9_LOJA") ))
	cRet	:= SA2->A2_NOME
EndIf
Return( cRet )

/*+----------------------------------------------------------------------------+
¦Programa  ¦GZG9_FORN2¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020    ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZG9_FORN2()
Local cRet	:= ''
SA2->(DbSetOrder(1))
SA2->(DBGOTOP())
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZG9_FORNEC")+FwFldGet("ZG9_LOJA") ))
	cRet	:= SA2->A2_MUN
EndIf
Return( cRet )

/*+----------------------------------------------------------------------------+
¦Programa  ¦GZG9_FORN3 ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020    ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZG9_FORN3()
Local cRet	:= ''
SA2->(DbSetOrder(1))
SA2->(DBGOTOP())
If SA2->( dbSeek( xFilial('SA2') + FwFldGet("ZG9_FORNEC")+FwFldGet("ZG9_LOJA") ))
	cRet	:= SA2->A2_EST
EndIf
Return( cRet )

/*+----------------------------------------------------------------------------+
¦Programa  ¦GZG9_FILIA¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020    ¦
+----------+-------------------------------------------------------------------¦
*/
Static Function GZGA_FILIA()
Local cRet	:= ''
DbSelectArea( "SM0" )
nRegSM0 := SM0->(Recno())
SM0->(DbGoTop())
While ! SM0->(Eof())
	If SM0->M0_CODFIL = FwFldGet("ZGA_ITEFIL")
		cRet := SM0->M0_FILIAL
	EndIf
	SM0->(DBSKIP())
EndDo
SM0->(DbGoto(nRegSM0))	
Return cRet

/*
+---------------------------------------------------------------------------------+
¦Programa  ¦BCOMMIT      ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020¦
+----------+----------------------------------------------------------------------¦
*/

Static Function bCommit( oModel )

Local oModelCAB		:= oModel:GetModel('MODEL_ZG9_CAB')
Local oModelITE		:= oModel:GetModel('MODEL_ZGA_ITE')
Local nOperation 	:= oModel:GetOperation()
Local cFilialZG9	:= xFilial("ZG9")
Local cFilialZGA	:= xFilial("ZGA")
Local nI			:= 00
Local lRet 			:= .T.
Local nTamArray1	:= oModelITE:Length()

Begin Transaction

    If  nOperation == MODEL_OPERATION_INSERT .OR. ;
        nOperation == MODEL_OPERATION_UPDATE .OR. ;
        nOperation == MODEL_OPERATION_DELETE 
        
        If ZG9->( DbSeek( cFilialZG9 + oModelCAB:GetValue( 'ZG9_CODPRO' ) + oModelCAB:GetValue( 'ZG9_FORNEC' ) + oModelCAB:GetValue( 'ZG9_LOJA' ) ) )
            RecLock('ZG9', .F.)
        Else
            RecLock('ZG9', .T.)
        Endif        

        If nOperation == MODEL_OPERATION_DELETE 
            RecLock('ZG9', .F.)
            ZG9->( dbDelete() )
            ZG9->(MsUnlock())			
        Else
            //Cabeçalho
            ZG9->ZG9_FILIAL  	:= cFilialZG9        
            ZG9->ZG9_CODPRO		:= oModelCAB:GetValue( 'ZG9_CODPRO')
            ZG9->ZG9_DESCRI		:= oModelCAB:GetValue( 'ZG9_DESCRI')
            ZG9->ZG9_FORNEC		:= oModelCAB:GetValue( 'ZG9_FORNEC')
            ZG9->ZG9_LOJA		:= oModelCAB:GetValue( 'ZG9_LOJA')
            ZG9->ZG9_NOMFOR		:= oModelCAB:GetValue( 'ZG9_NOMFOR')
            ZG9->ZG9_MUN		:= oModelCAB:GetValue( 'ZG9_MUN')
            ZG9->ZG9_UF	    	:= oModelCAB:GetValue( 'ZG9_UF')
            ZG9->(MsUnlock())	
        EndIf

        For nI := 01 to nTamArray1
            
            oModelITE:GoLine(nI)
            
            If oModelITE:IsDeleted() .OR. nOperation == MODEL_OPERATION_DELETE 
                ZGA->(DBSETORDER(1))    
                If ZGA->( dbSeek( cFilialZGA + oModelITE:GetValue( 'ZGA_CODPRO' ) + oModelITE:GetValue( 'ZGA_FORNEC' ) + oModelITE:GetValue( 'ZGA_LOJA' ) + oModelITE:GetValue( 'ZGA_ITEFIL' ) ) )
                    RecLock('ZGA', .F.)
                    ZGA->( dbDelete() )
                    ZGA->(MsUnlock())			
                Endif		
            Else
                ZGA->(DBSETORDER(1))    
                If ZGA->( dbSeek( cFilialZGA + oModelITE:GetValue( 'ZGA_CODPRO' ) + oModelITE:GetValue( 'ZGA_FORNEC' ) + oModelITE:GetValue( 'ZGA_LOJA' ) + oModelITE:GetValue( 'ZGA_ITEFIL' ) ) )
                    RecLock('ZGA', .F.)
                Else
                    RecLock('ZGA', .T.)
                Endif
                ZGA->ZGA_FILIAL  	:= cFilialZGA
                ZGA->ZGA_CODPRO		:= oModelCAB:GetValue( 'ZG9_CODPRO')
                ZGA->ZGA_FORNEC		:= oModelCAB:GetValue( 'ZG9_FORNEC')
                ZGA->ZGA_LOJA		:= oModelCAB:GetValue( 'ZG9_LOJA')			
                ZGA->ZGA_ITEFIL    	:= oModelITE:GetValue( 'ZGA_ITEFIL')
                ZGA->ZGA_FILNOM 	:= oModelITE:GetValue( 'ZGA_FILNOM')
                ZGA->ZGA_LEADTM 	:= oModelITE:GetValue( 'ZGA_LEADTM')
                ZGA->ZGA_UMLEAD	    := oModelITE:GetValue( 'ZGA_UMLEAD')
                ZGA->ZGA_TRANST 	:= oModelITE:GetValue( 'ZGA_TRANST')
                ZGA->ZGA_UMTRAN	    := oModelITE:GetValue( 'ZGA_UMTRAN')
                ZGA->ZGA_ESTMIN	    := oModelITE:GetValue( 'ZGA_ESTMIN')
                ZGA->ZGA_UMESTM	    := oModelITE:GetValue( 'ZGA_UMESTM')
                ZGA->ZGA_LOTMIN     := oModelITE:GetValue( 'ZGA_LOTMIN')
                ZGA->(MsUnlock())	
            Endif
            
        Next nI

    EndIf

End Transaction

Return( lRet )


/*
+---------------------------------------------------------------------------------+
¦Programa  ¦LINEPREZGA  ¦ Autor ¦ Wagner Neves - Marfrig  ¦ Data ¦ 15/05/2020¦
+----------+----------------------------------------------------------------------¦

@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, Ação UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno

*/

Static Function LinePreZGA( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )

Local lRet 			:= .T.
Local oModelITE		:= oModel:GetModel( 'MODEL_ZGA_ITE' )
Local nI			:= 00
Local nLineZGA		:= oModelITE:GetLine()
Local nTamArray1	:= oModelITE:Length()

Begin Sequence

If cAction == "SETVALUE"

	If cIDField == 'ZGA_ITEFIL' 

       // oModelITE:SetValue( 'ZGA_ITEFIL' , FwFldGet('ZGA_ITEFIL'))
        
		For nI := 01 to nTamArray1
			
			If nI <> nLineZGA

				oModelITE:GoLine(nI)

				If xValue == oModelITE:GetValue( 'ZGA_ITEFIL' )

					oModel:SetErrorMessage(, , , ,'LinePreZGA' , "Filial já existe neste cadastro", "Informe outra filial", , )
					lRet := .F.; Break
				
				Endif
				
			Endif
			
		Next nI

	Endif

Endif
End Sequence
oModelITE:GoLine(nLineZGA)
Return( lRet )