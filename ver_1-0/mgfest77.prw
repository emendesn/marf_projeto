#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'

/*+------------------------------------------------------------------------------+
¦Programa  ¦MGFEST77  ¦ Autor ¦ Wagner Neves                ¦ Data ¦ 27.04.2020  ¦
----------+----------------------------------------------------------------------¦
¦Descrição ¦ Rotina para controle de alçada solicitação armazém - Embalagens 	 ¦
¦          ¦												                     ¦
+----------+---------------------------------------------------------------------¦
¦ Uso      ¦ MARFRIG                  				                             ¦
+-------------------------------------------------------------------------------+*/

User Function MGFEST77()
Local oBrowse		:= Nil
Local aBKRotina		:= {}
/*
// Definição do parametro MGF_EST77A
If !ExisteSx6("MGF_EST77A")
    CriarSX6("MGF_EST77A", "C", "Verifica se a filial está habilitada para executar essa rotina.", "010002/010041" )
EndIf
	If !cFilAnt $GetMv("MGF_EST77A")
	MsgAlert("Esta filial não está habilitada para executar essa rotina-MGFEST77","MGF_EST77A")
	Return
ENDIF
*/
If Type('aRotina') <> 'U'
	aBKRotina := aRotina
Endif
aRotina := MenuDef()
oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZGB')
oBrowse:SetDescription('Controle de Alçada - Embalagens')
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
¦Programa  ¦MENUDEF  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 28.05.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function MenuDef()

	Local aRotina := {}
	aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.MGFEST77', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.MGFEST77', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.MGFEST77', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.MGFEST77', 0, 5, 0, NIL } )
Return( aRotina )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦MODELDEF ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ModelDef()
	Local oModel		:= Nil
	Local oSTRZGBCAB	:= FWFormStruct(1, "ZGB")
	Local oSTRZGBITE	:= FWFormStruct(1, "ZGB")
	Local bLinPreZGB	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePreZGB(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel)}
	Local aGatilho		:= {}

	oSTRZGBCAB:SetProperty( "ZGB_CODGRP"    , MODEL_FIELD_INIT, { |cNumTmp| If( INCLUI, ( cNumTmp := GetSXENum('ZGB','ZGB_CODGRP'), cNumTmp ), ZGB->ZGB_CODGRP ) } )
	oSTRZGBCAB:SetProperty( "ZGB_NOMGRP" 	, MODEL_FIELD_OBRIGAT,  .T. )

	oSTRZGBITE:SetProperty( "ZGB_USUAPR" 	, MODEL_FIELD_OBRIGAT,  .T. )
	oSTRZGBITE:SetProperty( "ZGB_NOMAPR" 	, MODEL_FIELD_OBRIGAT,  .T. )
	oSTRZGBITE:SetProperty( "ZGB_NIVEL" 	, MODEL_FIELD_OBRIGAT,  .T. )
//-----------------------------------Inicio dos gatilhos

// Gatilhos Cliente
	aGatilho := FwStruTrigger ( 'ZGB_USUAPR' /**cDom*/, 'ZGB_NOMAPR' /*cCDom*/, "StaticCall( MGFEST77, gZGBCODALC )" /*cRegra*/, .F. /*lSeek*/, /*cAlias*/,  /*nOrdem*/, /*cChave*/, /*cCondic*/ )
	oSTRZGBITE:AddTrigger( aGatilho[1] /*cIdField*/, aGatilho[2] /*cTargetIdField*/, aGatilho[3] /*bPre*/, aGatilho[4] /*bSetValue*/ )

//-------------------------------------------- FIM DOS GATILHOS

	oModel:= MPFormModel():New("MODELO", Nil, Nil, { |oMdl| bCommit( oMdl ) } )
	oModel:AddFields("MODEL_ZGB_CAB", Nil, oSTRZGBCAB)
	oModel:AddGrid("MODEL_ZGB_ITE", "MODEL_ZGB_CAB", oSTRZGBITE, bLinPreZGB)
	oModel:SetPrimaryKey({"ZGB_CODROM","ZGB_CODAPR"})
	oModel:SetRelation("MODEL_ZGB_ITE",{{"ZGB_FILIAL",'xFilial("ZGB")'},{"ZGB_CODGRP","ZGB_CODGRP"}},ZGB->(IndexKey()))
	oModel:SetDescription('Controle de Alçada-Embalagem')
	oModel:GetModel( "MODEL_ZGB_ITE" ):SetDescription( 'Controle de Alçada-Embalagens' )
Return( oModel )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦VIEWDEF  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function ViewDef()
	Local oModel	:= FWLoadModel("MGFEST77") // Vincular o View ao Model
	Local oView		:= FWFormView():New() // Criacao da Interface
	Local oStrZGBC	:= FWFormStruct(2, 'ZGB')
	Local oStrZGBD	:= FWFormStruct(2, 'ZGB')

// CAMPOS QUE SERÃƒO EXCLUIDOS DO CABEÇALHO 
	oStrZGBC:RemoveField( "ZGB_ITEM" )
	oStrZGBC:RemoveField( "ZGB_USUAPR" )
	oStrZGBC:RemoveField( "ZGB_NOMAPR" )
	oStrZGBC:RemoveField( "ZGB_NIVEL" )

// CAMPOS QUE SERÃƒO EXCLUIDOS DO ITEM 
	oStrZGBD:RemoveField( "ZGB_CODGRP")
	oStrZGBD:RemoveField( "ZGB_NOMGRP")

	oView:SetModel(oModel)
	oView:AddField( 'VIEW_ZGBC' , oStrZGBC, "MODEL_ZGB_CAB" )
	oView:AddGrid(  'VIEW_ZGBD' , oStrZGBD, 'MODEL_ZGB_ITE' )

	oView:CreateHorizontalBox( 'SUPERIOR', 20,,,) //20
	oView:CreateHorizontalBox( 'INFERIOR', 80,,,) //80

	oView:AddIncrementField( 'VIEW_ZGBD', 'ZGB_ITEM' )

	oView:SetOwnerView( 'VIEW_ZGBC', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZGBD', 'INFERIOR' )
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
¦Programa  ¦GZGBCODALC  ¦ Autor ¦ Wagner Neves              ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function gZGBCODALC()
	Local cRet	:= ''
	cRet	    := UPPER(UsrFullName(FwFldGet("ZGB_USUAPR")))
Return( cRet )

/*
+------------------------------------------------------------------------------+
¦Programa  ¦bCommit  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCommit( oModel )
	Local oModelCAB		:= oModel:GetModel('MODEL_ZGB_CAB')
	Local oModelITE		:= oModel:GetModel('MODEL_ZGB_ITE')
	Local nOperation 	:= oModel:GetOperation()
	Local cFilialZGB	:= xFilial("ZGB")
	Local nI			:= 00
	Local lRet 			:= .T.
	Local nTamArray1	:= oModelITE:Length()

	Begin Transaction

		If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_DELETE

			If nOperation == MODEL_OPERATION_INSERT
				cNumTmp := GetSXENum('ZGB','ZGB_CODGRP')
				ConfirmSX8()
			Else
				cNumRom := ZGB->ZGB_CODGRP
			Endif

			For nI := 01 to nTamArray1

				oModelITE:GoLine(nI)

				If oModelITE:IsDeleted() .OR. nOperation == MODEL_OPERATION_DELETE

					If ZGB->( dbSeek( cFilialZGB + oModelITE:GetValue( 'ZGB_CODGRP' ) + oModelITE:GetValue( 'ZGB_ITEM' ) ) )
						RecLock('ZGB', .F.)
						ZGB->( dbDelete() )
						ZGB->(MsUnlock())
					Endif
				Else
					If ZGB->( dbSeek( cFilialZGB + oModelITE:GetValue( 'ZGB_CODGRP' ) + oModelITE:GetValue( 'ZGB_ITEM' ) ) )
						RecLock('ZGB', .F.)
					Else
						RecLock('ZGB', .T.)
					Endif
					//Filial
					ZGB->ZGB_FILIAL  := cFilialZGB
					//Cabeçalho
					ZGB->ZGB_CODGRP	:= oModelCAB:GetValue( 'ZGB_CODGRP')
					ZGB->ZGB_NOMGRP := oModelCAB:GetValue( 'ZGB_NOMGRP' )
					ZGB->ZGB_ITEM	:= oModelITE:GetValue( 'ZGB_ITEM' )
					ZGB->ZGB_USUAPR := oModelITE:GetValue( 'ZGB_USUAPR' )
					ZGB->ZGB_NOMAPR := oModelITE:GetValue( 'ZGB_NOMAPR' )
					ZGB->ZGB_NIVEL  := oModelITE:GetValue( 'ZGB_NIVEL' )
					ZGB->(MsUnlock())
					ZGB->(MsUnlock())
				Endif

			Next nI

		EndIf

	End Transaction

Return( lRet )

/*
+---------------------------------------------------------------------------------+
¦Programa  ¦LINEPREZGB  ¦ Autor ¦ Wagner Neves                 ¦ Data ¦ 27.04.2020¦
+----------+----------------------------------------------------------------------¦
@param		oGridModel		, Objeto	, Grid
@param		nLine			, Numerico	, Linha do grid
@param		cAction			, Caracter	, AÃ§Ã£o UNDELETE / DELETE / SETVALUE / CANSETVALUE
@param		cIDField		, Caracter	, Campo Sendo atualizado
@param		xValue			, Indefinido, Novo valor
@param		xCurrentValue	, Indefinido, Valor antigo
@return		lRet, Boolean, Retorno
*/
Static Function LinePreZGB( oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue, oModel )
	Local lRet 			:= .T.
	Local oModelITE		:= oModel:GetModel( 'MODEL_ZGB_ITE' )
	Local nI			:= 00
	Local nLineZGB		:= oModelITE:GetLine()
	Local nTamArray1	:= oModelITE:Length()
	Begin Sequence
		If cAction == "SETVALUE"
			If cIDField == 'ZGB_USUAPR'
				oModelITE:SetValue( 'ZGB_CODGRP', FwFldGet('ZGB_CODGRP') )
				oModelITE:SetValue( 'ZGB_NOMGRP', FwFldGet('ZGB_NOMGRP') )

				For nI := 01 to nTamArray1

					If nI <> nLineZGB

						oModelITE:GoLine(nI)

						If xValue == oModelITE:GetValue( 'ZGB_USUAPR' )

							oModel:SetErrorMessage(, , , ,'LinePreZGB' , "Código usuário já informado no item: " + oModelITE:GetValue( 'ZGB_ITEM' ), "Alterar usuário já informado", , )
							lRet := .F.; Break

						Endif

					Endif

				Next nI

			Endif

		Endif
	End Sequence
	oModelITE:GoLine(nLineZGB)
Return( lRet )