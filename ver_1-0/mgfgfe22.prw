#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

user function MGFGFE22()

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDL")
	oMBrowse:SetDescription("Dados para emissão CT-e")
	
	oMBrowse:AddLegend("ZDL_STATUS=='2'", "RED"   , "Não Enviado"  )
	oMBrowse:AddLegend("ZDL_STATUS=='1'", "GREEN" , "Enviado"      )
		
	oMBrowse:Activate()
	
return oMBrowse

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE22" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Retransmitir"	  ACTION "U_XWSC23()"		OPERATION MODEL_OPERATION_INSERT ACCESS 0
	//ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE22" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE22" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
 

Static Function ModelDef()

Local oStruZDL := FWFormStruct( 1, 'ZDL', /*bAvalCampo*/,/*lViewUsado*/ )

Local oModel

oModel := MPFormModel():New('XMGFGFE22', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
oModel:AddFields( 'ZDLMASTER', /*cOwner*/, oStruZDL, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Dados para emissão CT-e' )

oModel:SetPrimaryKey({"ZDL_FILIAL"})

oModel:GetModel( 'ZDLMASTER' ):SetDescription( 'Dados para emissão CT-e' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFGFE22' )

Local oStruZDL := FWFormStruct( 2, 'ZDL' )

Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZDL', oStruZDL, 'ZDLMASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZDL', 'TELA' )

Return oView
	
return