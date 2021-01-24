#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFINB3
Autor...............: Joni Lima
Data................: 26/11/2018
Descrição / Objetivo: Cadastro Administradora
Doc. Origem.........: Contrato - E-commerce Oracle
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para cadastro de Administraora
=====================================================================================
*/
User Function MGFFINB3()
	Local oMBrowse := nil
	
	oMBrowse:= FWmBrowse():New()
	
	oMBrowse:SetAlias("ZEC")
	oMBrowse:SetDescription("Cadastro de Administradora")
	
	oMBrowse:Activate()
	
Return oMBrowse

/*
=====================================================================================
Programa............: MenuDef
Descrição / Objetivo: MenuDef da rotina
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"		ACTION "VIEWDEF.MGFFINB3" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"			ACTION "VIEWDEF.MGFFINB3" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"			ACTION "VIEWDEF.MGFFINB3" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"			ACTION "VIEWDEF.MGFFINB3" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Obs.................: Definição do Modelo de Dados para cadastro da Administradora Financeira
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrZEC 	:= FWFormStruct(1,"ZEC")

	oModel := MPFormModel():New("XMGFFINB3",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZECMASTER",/*cOwner*/,oStrZEC, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Administradora Financeira")
	oModel:SetPrimaryKey({"ZEC_FILIAL","ZEC_CODIGO"})
	
Return oModel

/*
=====================================================================================
Programa............: ViewDef
Obs.................: Definição da View de Dados para cadastro da Administradora Financeira
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView
	Local oModel  	:= FWLoadModel('MGFFINB3')
	
	Local oStrZEC 	:= FWFormStruct( 2, "ZEC",)	

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZEC' , oStrZEC, 'ZECMASTER' )
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	oView:SetOwnerView( 'VIEW_ZEC', 'SUPERIOR' )
	
Return oView