#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMBROWSE.CH'  
#INCLUDE 'FWMVCDEF.CH'     

/*/{Protheus.doc} MGFGFE63
Tela de consulta dos XML's do CTE

@type function
@author Paulo da Mata
@since 17/03/2020
@version P12.1.17
@return Nil
/*/

User Function MGFGFE63

	Local lRet  := .T.
	Local aArea := ZFV->(GetArea())
	Private oBrowse
	Private cChaveAux := ""

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZFV')
	oBrowse:SetDescription("Tela de LOG XML CTe")
	oBrowse:Activate()

    RestArea(aArea)

Return

Static Function MenuDef()

	Local aRotina := {}
 
 	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 		  OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MGFGFE63" OPERATION 2 ACCESS 0

Return aRotina


Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1 := FWFormStruct(2, 'ZFV')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('Formulario' , oStr1,'CamposZFV' )
	oView:CreateHorizontalBox( 'PAI', 100)
	oView:SetOwnerView('Formulario','PAI')
	oView:EnableTitleView('Formulario' , 'Tela de LOG XML CTe' )	
	oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})
	oView:SetCloseOnOk({||.T.})
	
Return oView

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct( 1, 'ZFV', /*bAvalCampo*/,/*lViewUsado*/ )
	
	oModel := MPFormModel():New('XmlCte', /*bPreValidacao*/, , /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )
	oModel:SetDescription('Tela de LOG XML CTe')
	oStr1:SetProperty('ZFV_FILIAL' , MODEL_FIELD_WHEN,{|| .F. })
	oModel:addFields('CamposZFV',,oStr1,{|oModel|MGF001T(oModel)},,)
	oModel:SetPrimaryKey({'ZFV_FILIAL', 'ZFV_PROTOC', 'ZFV_ORDEMB' })
	oModel:getModel('CamposZFV'):SetDescription('TabelaZFV')
	
Return oModel

Static Function MGF001T( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposZFV' )
	
	cChaveAux := ZFV->ZFV_FILIAL

Return(lRet)