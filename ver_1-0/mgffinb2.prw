#include 'protheus.ch'
#include 'parmtype.ch'
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
=====================================================================================
Programa............: MGFFINB2
Autor...............: Joni Lima
Data................: 26/11/2018
Descrição / Objetivo: Caução E-Commerce
Doc. Origem.........: Contrato - E-commerce Oracle
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de controle do Caução
=====================================================================================
*/
User Function MGFFINB2()

	Local oMBrowse := nil

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZE6")
	oMBrowse:SetDescription('Caução E-commerce')

	oMBrowse:AddLegend( "ZE6_STATUS == '0'"	, "YELLOW"	, "Caução Aberto"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '1'"	, "BLUE"	, "Titulo Gerado"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '2'"	, "GREEN"	, "Titulo Baixado"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '3'"	, "RED"		, "ERRO"											)
	oMBrowse:AddLegend( "ZE6_STATUS == '4'"	, "PINK"	, "Pagamento autorizado - Aguardando conciliação"	)
	oMBrowse:AddLegend( "ZE6_STATUS == '5'"	, "ORANGE"	, "Estornado"										)

	oMBrowse:Activate()

return

/*
=====================================================================================
Programa............: MenuDef
Descrição / Objetivo: MenuDef da rotina
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFFINB2" OPERATION MODEL_OPERATION_VIEW   ACCESS 0

Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Obs.................: Definição do Modelo de Dados para cadastro do Caução
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZE6 	:= FWFormStruct(1,"ZE6")

	oModel := MPFormModel():New("XMGFFINB2",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZE6MASTER",/*cOwner*/,oStrZE6, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Caução E-Commerce")
	oModel:SetPrimaryKey({"ZE6_FILIAL","ZE6_PEDIDO"})

Return oModel

/*
=====================================================================================
Programa............: ViewDef
Obs.................: Definição da View de Dados para cadastro do Caução
=====================================================================================
*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFFINB2')

	Local oStrZE6 	:= FWFormStruct( 2, "ZE6",)	

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZE6' , oStrZE6, 'ZE6MASTER' )
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	oView:SetOwnerView( 'VIEW_ZE6', 'SUPERIOR' )

Return oView
