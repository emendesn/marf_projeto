#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFAT26
Autor...............: Joni Lima
Data................: 26/10/2016
Descricao / Objetivo: Cadastro de Classificacao de Perda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro de Classificacao de Perda
=====================================================================================
*/
User Function MGFFAT26()

	Local oMBrowse := nil
	
	dbselectArea('ZZ5')
	ZZ5->(dbSetOrder(1))
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZZ5")
	oMBrowse:SetDescription('Cadastro Classificacao de Perda')
	oMBrowse:Activate()

Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 26/10/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFAT26" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFAT26" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFAT26" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFAT26" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 26/10/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro Classificacao de Perda
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrZZ5 	:= FWFormStruct(1,"ZZ5")
	
	oModel := MPFormModel():New("XMGFFAT26", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("ZZ5MASTER",/*cOwner*/,oStrZZ5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	oModel:SetDescription('Classificacao Perdas')
	oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"})
	
Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 26/10/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizacao da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView		:= Nil
	Local oModel	:= FWLoadModel( 'MGFFAT26' )
	Local oStrZZ5	:= FWFormStruct( 2,"ZZ5")
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_ZZ5' , oStrZZ5, 'ZZ5MASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_ZZ5', 'TELA' )
	
Return oView
