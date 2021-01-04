#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'
                  
/*+----------------------------------------------------------------------------+
¦Programa  ¦MGFEST71 ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
¦Descrição ¦ Rotina para controle de alçada solicitação armazém - EPI          ¦
¦          ¦												                   ¦
+----------+-------------------------------------------------------------------¦
¦ Uso      ¦ MARFRIG                  				                           ¦
+----------------------------------------------------------------------------+*/

User Function MGFEST71()
Local oBrowse		:= Nil
Local aBKRotina		:= {}

If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		MsgAlert("Esta filial não está habilitada para executar essa rotina-MGFEST71","MGF_EPIFIL")
		Return
ENDIF

If Type('aRotina') <> 'U'
	aBKRotina		:= aRotina
Endif	
aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZG5')
oBrowse:SetDescription('Controle de Alçada')

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
¦Programa  ¦MENUDEF  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function MenuDef()

Local aRotina := {}
aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFEST71', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.MGFEST71', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFEST71', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.MGFEST71', 0, 5, 0, NIL } )
Return( aRotina )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MODELDEF ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ModelDef()
Local oModel		:= Nil
Local oSTRZG5CAB	:= FWFormStruct(1, "ZG5")     
Local oSTRZG5ITE	:= FWFormStruct(1, "ZG5")     
Local bLinPreZG5	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZG5(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}
Local aGatilho		:= {}

oSTRZG5CAB:SetProperty( "ZG5_CODGRP"    , MODEL_FIELD_INIT, { |cNumTmp| If( INCLUI, ( cNumTmp := GetSXENum('ZG5','ZG5_CODGRP'), cNumTmp ), ZG5->ZG5_CODGRP ) } )
oSTRZG5CAB:SetProperty( "ZG5_NOMGRP" 	, MODEL_FIELD_OBRIGAT,  .T. )

oSTRZG5ITE:SetProperty( "ZG5_USUAPR" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZG5ITE:SetProperty( "ZG5_NOMAPR" 	, MODEL_FIELD_OBRIGAT,  .T. )
oSTRZG5ITE:SetProperty( "ZG5_NIVEL" 	, MODEL_FIELD_OBRIGAT,  .T. )
//-----------------------------------Inicio dos gatilhos

// Gatilhos Cliente
aGatilho := FwStruTrigger ( 'ZG5_USUAPR' /**cDom*/, 'ZG5_NOMAPR' /*cCDom*/, "StaticCall( MGFEST71, gZG5CODALC )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
oSTRZG5ITE:AddTrigger( aGatilho[1] /*cIdField*/, aGatilho[2] /*cTargetIdField*/, aGatilho[3] /*bPre*/, aGatilho[4] /*bSetValue*/ )


//-------------------------------------------- FIM DOS GATILHOS

oModel:= MPFormModel():New("MODELO", Nil, Nil, { |oMdl| bCommit( oMdl ) } )
oModel:AddFields("MODEL_ZG5_CAB", Nil, oSTRZG5CAB)
oModel:AddGrid("MODEL_ZG5_ITE", "MODEL_ZG5_CAB", oSTRZG5ITE, bLinPreZG5)
oModel:SetPrimaryKey({"ZG5_CODROM","ZG5_CODAPR"})
oModel:SetRelation("MODEL_ZG5_ITE",{{"ZG5_FILIAL",'xFilial("ZG5")'},{"ZG5_CODGRP","ZG5_CODGRP"}},ZG5->(IndexKey()))
oModel:SetDescription('Controle de Alçada')
oModel:GetModel( "MODEL_ZG5_ITE" ):SetDescription( 'Controle de Alçada' )
Return( oModel ) 

/*
+------------------------------------------------------------------------------+
¦Programa  ¦VIEWDEF  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ViewDef()
Local oModel	:= FWLoadModel("MGFEST71") // Vincular o View ao Model
Local oView		:= FWFormView():New() // Criacao da Interface
Local oStrZG5C	:= FWFormStruct(2, 'ZG5')
Local oStrZG5D	:= FWFormStruct(2, 'ZG5')

// CAMPOS QUE SERÃO EXCLUIDOS DO CABEÇALHO 
oStrZG5C:RemoveField( "ZG5_ITEM" )
oStrZG5C:RemoveField( "ZG5_USUAPR" )
oStrZG5C:RemoveField( "ZG5_NOMAPR" )
oStrZG5C:RemoveField( "ZG5_NIVEL" )

// CAMPOS QUE SERÃO EXCLUIDOS DO ITEM 
oStrZG5D:RemoveField( "ZG5_CODGRP")
oStrZG5D:RemoveField( "ZG5_NOMGRP")

oView:SetModel(oModel)
oView:AddField( 'VIEW_ZG5C' , oStrZG5C, "MODEL_ZG5_CAB" )
oView:AddGrid(  'VIEW_ZG5D' , oStrZG5D, 'MODEL_ZG5_ITE' )

oView:CreateHorizontalBox( 'SUPERIOR', 20,,,) //20
oView:CreateHorizontalBox( 'INFERIOR', 80,,,) //80

//oView:AddGrid(  'VIEW_ZG5D' , oStrZG5D, 'MODEL_ZG5_ITE' )
oView:AddIncrementField( 'VIEW_ZG5D', 'ZG5_ITEM' )

oView:SetOwnerView( 'VIEW_ZG5C', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZG5D', 'INFERIOR' )
Return( oView )


/*
+------------------------------------------------------------------------------+
¦Programa  ¦bCancel  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCancel(oModel)
Local lRet := .T.
Return( lRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦GZG5CODALC  ¦ Autor ¦ Wagner Neves              ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function gZG5CODALC()
Local cRet	:= ''
cCodUser := UsrRetname(ALLTRIM(FwFldGet('ZG5_USUAPR')))
cRet 		:= Alltrim(cCodUser)
Return( cRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦bCommit  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCommit( oModel )
Local oModelCAB		:= oModel:GetModel('MODEL_ZG5_CAB')
Local oModelITE		:= oModel:GetModel('MODEL_ZG5_ITE')
Local nOperation 	:= oModel:GetOperation()
Local cFilialZG5	:= xFilial("ZG5")
Local nI			:= 00
Local lRet 			:= .T.
Local nTamArray1	:= oModelITE:Length()

Begin Transaction

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_DELETE 
	
	If nOperation == MODEL_OPERATION_INSERT
		cNumTmp := GetSXENum('ZG5','ZG5_CODGRP')
		ConfirmSX8()
	Else
		cNumRom := ZG5->ZG5_CODGRP
	Endif
	
	For nI := 01 to nTamArray1
			
		oModelITE:GoLine(nI)
		
		If oModelITE:IsDeleted() .OR. nOperation == MODEL_OPERATION_DELETE 
		
			If ZG5->( dbSeek( cFilialZG5 + oModelITE:GetValue( 'ZG5_CODGRP' ) + oModelITE:GetValue( 'ZG5_ITEM' ) ) )
				RecLock('ZG5', .F.)
				ZG5->( dbDelete() )
				ZG5->(MsUnlock())			
			Endif		
		Else
			If ZG5->( dbSeek( cFilialZG5 + oModelITE:GetValue( 'ZG5_CODGRP' ) + oModelITE:GetValue( 'ZG5_ITEM' ) ) )
				RecLock('ZG5', .F.)
			Else
				RecLock('ZG5', .T.)
			Endif
			//Filial
			ZG5->ZG5_FILIAL  := cFilialZG5
			//Cabeçalho
			ZG5->ZG5_CODGRP	:= oModelCAB:GetValue( 'ZG5_CODGRP')
			ZG5->ZG5_NOMGRP := oModelCAB:GetValue( 'ZG5_NOMGRP' )
			ZG5->ZG5_ITEM	:= oModelITE:GetValue( 'ZG5_ITEM' )
			ZG5->ZG5_USUAPR := oModelITE:GetValue( 'ZG5_USUAPR' )
			ZG5->ZG5_NOMAPR := oModelITE:GetValue( 'ZG5_NOMAPR' ) //oModelITE:GetValue( 'ZG5_NOMAPR' )
			ZG5->ZG5_NIVEL  := oModelITE:GetValue( 'ZG5_NIVEL' )	
			ZG5->(MsUnlock())	
		Endif
		
	Next nI

EndIf

End Transaction

Return( lRet )

/*
+---------------------------------------------------------------------------------+
¦Programa  ¦LINEPREZG5  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+----------------------------------------------------------------------¦
@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, Ação UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno
*/
Static Function LinePreZG5( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )
Local lRet 			:= .T.
Local oModelITE		:= oModel:GetModel( 'MODEL_ZG5_ITE' )
Local nI			:= 00
Local nLineZG5		:= oModelITE:GetLine()
Local nTamArray1	:= oModelITE:Length()
Begin Sequence
If cAction == "SETVALUE"
	If cIDField == 'ZG5_USUAPR' 
		oModelITE:SetValue( 'ZG5_CODGRP', FwFldGet('ZG5_CODGRP') )
		oModelITE:SetValue( 'ZG5_NOMGRP', FwFldGet('ZG5_NOMGRP') )
		
		For nI := 01 to nTamArray1
			
			If nI <> nLineZG5

				oModelITE:GoLine(nI)

				If xValue == oModelITE:GetValue( 'ZG5_USUAPR' )
				
					oModel:SetErrorMessage(, , , ,'LinePreZG5' , "Codigo já informado no item: " + oModelITE:GetValue( 'ZG5_ITEM' ), "Alterar produto já informado", , )
					lRet := .F.; Break
				
				Endif
				
			Endif
			
		Next nI

	Endif

Endif
End Sequence
oModelITE:GoLine(nLineZG5)
Return( lRet )