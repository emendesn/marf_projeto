#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MGFCOMBD
PROJETO ME - RITM0022412
Responsável pelo Cadastro de Família do CDM 
O campo que será alimentado no cadastro de produtos B1_MGFFAM
está como não obrigatório

@type property

@author Anderson Reis
@since 28/11/2019
@version P12
/*/


User Function MGFCOMBD()

	Local oMBrowse := nil
		 
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetCanSaveArea(.t.)
	

	oMBrowse:SetAlias("ZFN")
	oMBrowse:SetDescription('Cadastro de Familias')
		
	oMBrowse:Activate()
	
return nil

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFCOMBD" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFCOMBD" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFCOMBD" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFCOMBD" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina

Static Function ModelDef()

Local oStruZFN := FWFormStruct( 1, 'ZFN', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

oModel := MPFormModel():New('XMGFCOMBD', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'ZFNMASTER', /*cOwner*/, oStruZFN, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Cadastro de Familia' )

oModel:SetPrimaryKey({"ZFN_FILIAL","ZFN_CODFML"})

oModel:GetModel( 'ZFNMASTER' ):SetDescription( 'Cadastro de Familia' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFCOMBD' )
Local oStruZFN := FWFormStruct( 2, 'ZFN' )
Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZFN', oStruZFN, 'ZFNMASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZFN', 'TELA' )

Return oView

 

