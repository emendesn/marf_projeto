#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMBROWSE.CH'  
#INCLUDE 'FWMVCDEF.CH'     

/*/{Protheus.doc} MGFFATB8 (nome da Função)
	Breve descrição... Tela para consulta de pedidos deletados 

	@description
	Tela de consulta para pedidos deletados 

	@author Fabio Costa
	@since 22/08/2019

	@version P12.1.017
	@country Brasil
	@language Português

	@type XXXXXXXX  ("Function" para Funções, "Class" para Classes, "Method" para Métodos, "Property" para Propriedades de classes, "Variable" para Variáveis
	@table 

	@param
	@return

	@menu

	@history
	PRB0040215-Eliminação-de-residuos-PV
/*/

User function MGFFATB8()

	Local oBrowse
	Private aRotina := Menudef()
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZEI')
	oBrowse:SetDescription("Consulta Pedidos de Vendas Deletados")
	oBrowse:AddLegend("ZEI->ZEI_FILIAL <> ''  ","RED"    ,"Pedido deletado." )
	oBrowse:Activate()
	
Return NIL

Static Function ModelDef()

	Local oModel
	Local oStruZEI := FWFormStruct( 1, "ZEI")

	oModel := MPFormModel():New('xPedDel', /*bPreValidacao*/, /*bPreValidacao*/, /*bCommit*/, /*bCancel*/ )
	oModel:AddFields( 'ZEIMASTER', /* cOwner */, oStruZEI)
	oModel:SetPrimaryKey({'ZEI_FILIAL','ZEI_PEDIDO','ZEI_CLIENT','ZEI_LOJA'})
	oModel:SetDescription("Consulta Pedidos de Vendas Deletados")
	oModel:GetModel( 'ZEIMASTER' ):SetDescription( "Consulta Pedidos de Vendas Deletados"  )

Return(oModel)

Static Function ViewDef()

	Local oModel	:= ModelDef() 
	Local oView		:= FWFormView():New()
	Local oStruZEI	:= FWFormStruct(2, 'ZEI')

	oView:SetModel(oModel)
	oView:AddField('VIEW_ZEI' ,oStruZEI,'ZEIMASTER')
	oView:CreateHorizontalBox('TELA', 100)
	oView:SetOwnerView('VIEW_ZEI','TELA')

Return(oView)

Static Function MenuDef()

	Local aRotina := {}
 
 	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFATB8" OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'        ACTION 'u_xLeg1()'        OPERATION 6 ACCESS 0
		
Return aRotina

User Function xleg1()
	Local aLegenda := {}
	AADD(aLegenda,{"BR_VERMELHO" ,"Pedidos deletados." })
	BrwLegenda("Pedidos deletados" , "Status", aLegenda)
Return