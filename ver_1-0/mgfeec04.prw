#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa.:              MGFEEC04
Autor....:              Luis Artuso
Data.....:              27/10/16
Descricao / Objetivo:   Chamada da rotina principal
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFEEC04()

	fMVCBrowse()

Return

/*
=====================================================================================
Programa.:              fMVCBrowse
Autor....:              Luis Artuso
Data.....:              27/10/16
Descricao / Objetivo:   Browse da tela de cadastro de motivos
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Manutenção do Cadastro de Motivos
=====================================================================================
*/
Static Function fMVCBrowse()

	Local oMBrowse
	Local cAliasZZ6		:=	""
	Local cDescr		:=	""

	cAliasZZ6	:= "ZZ6"

	dbSelectArea(cAliasZZ6)

	cDescr		:= "Cadastro de Motivos"

	oMBrowse	:=	FWmBrowse():New()

	oMBrowse:SetAlias(cAliasZZ6)

	oMBrowse:SetDescription(cDescr)

	oMBrowse:Activate()

Return

/*
=====================================================================================
Programa.:              MenuDef
Autor....:              Luis Artuso
Data.....:              27/10/16
Descricao / Objetivo:
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFEEC04" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFEEC04" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFEEC04" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFEEC04" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

/*
=====================================================================================
Programa.:              ModelDef
Autor....:              Luis Artuso
Data.....:              27/10/16
Descricao / Objetivo:
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function ModelDef()

	Local oStruZZ6
	Local oModel
	Local bPreValid
	Local bPosValid
	Local bCommit
	Local bCancel
	Local nOp			:= 0
	Local cAliasZZ6		:= ""
	Local cFilZZ6		:= ""
	Local cMaster		:= ""

	bPreValid	:= NIL
	bPosValid	:= NIL
	bCommit		:= NIL
	bCancel		:= NIL

	oStruZZ6	:= FwFormStruct(1 , "ZZ6")

	oModel := MPFormModel():New("XMGFEEC04" , bPreValid , bPosValid , bCommit , bCancel )

	oModel:AddFields("ZZ6MASTER" , "" , oStruZZ6)

	oModel:SetPrimaryKey({xFilial("ZZ6") , "ZZ6_CODIGO"})

Return oModel

/*
=====================================================================================
Programa.:              ViewDef
Autor....:              Luis Artuso
Data.....:              27/10/16
Descricao / Objetivo:
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function ViewDef()

	Local oModel
	Local oView
	Local oStruZZ6

	oModel		:= FWLoadModel("MGFEEC04")
	oView		:= FWFormView():New()
	oStruZZ6	:= FwFormStruct(2 , "ZZ6")

	oView:SetModel( oModel )

	oView:AddField('VIEW_CABMAST', oStruZZ6 ,'ZZ6MASTER')
	//oView:AddGrid('VIEW_DETSZU',oModel,'SZUDETAIL' )

	oView:CreateHorizontalBox('SUPERIOR',100)
	//oView:CreateHorizontalBox('INFERIOR',80)

	oView:SetOwnerView('VIEW_CABMAST','SUPERIOR')
	//oView:SetOwnerView('VIEW_DETSZU','INFERIOR')

Return oView