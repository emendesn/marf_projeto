#Include "Protheus.ch"
#Include "FwMvcDef.ch"
#Include "FwMBrowse.ch"

/*/{Protheus.doc} MGFEEC05
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFEEC05()


	Local aRotOld := aRotina
	Local cChave := ""

	Private oBrowse

	If IsInCallStack("U_MGFEEC18")
		cChave := xFilial("ZZ7")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP
	Else
		cChave := xFilial("ZZ7")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP
	EndIf

	oBrowse := FWMarkBrowse():New()
	oBrowse:SetAlias("ZZ7")
	oBrowse:SetDescription("Log Alteraçoes")
	aRotina := oBrowse:SetMenuDef("MGFEEC05")
	oBrowse:SetFilterDefault("ALLTRIM(ZZ7_CHAVE) == '"+cChave+"'")
	oBrowse:Activate()


	aRotina := aRotOld
Return NIL

Static Function MenuDef()

	Local aRotina := {}

	Aadd( aRotina, { "Visualizar", "VIEWDEF.MGFEEC05", 0, 2, 0,,, })

Return aRotina


Static Function ModelDef()

	Local oStruZZ7 := FWFormStruct( 1, "ZZ7")
	Local oModel


	oModel := MPFormModel():New("EEC05M", , , , )


	oModel:AddFields( "EEC05MASTER", , oStruZZ7, , , )


	oModel:SetDescription( "Log Alterações" )


	oModel:GetModel( "EEC05MASTER" ):SetDescription( "Log Alterações" )


	oModel:SetPrimaryKey({"ZZ7_FILIAL","ZZ7_CHAVE"})

Return oModel


Static Function ViewDef()

	Local oModel   := FWLoadModel( "MGFEEC05" )

	Local oStruZZ7 := FWFormStruct( 2, "ZZ7",, )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()


	oView:SetModel( oModel )


	oView:AddField( "VIEW_ZZ7", oStruZZ7, "EEC05MASTER" )


	oView:CreateHorizontalBox( "SUPERIOR" , 100 )


	oView:SetOwnerView( "VIEW_ZZ7", "SUPERIOR" )


Return oView
