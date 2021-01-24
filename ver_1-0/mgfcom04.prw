#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFCOM04
Autor...............: Joni Lima
Data................: 20/12/2016
Descrição / Objetivo: Cadastro de Gestores Financeiros
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Cadastro de Gestores Financeiros
=====================================================================================
*/
User Function MGFCOM04()
	
	Local oMBrowse := nil
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("FRP")
	oMBrowse:SetDescription("Cadastro de Gestores Financeiros")
	
	oMBrowse:Activate()
	
Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descrição / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFCOM04" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFCOM04" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFCOM04" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFCOM04" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Consulta Lim."  ACTION "FA003CONSULTA()"  OPERATION 8 					 ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descrição / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Modelo de Dados para cadastro de Gestores Financeiros
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrFRP 	:= FWFormStruct(1,"FRP")	
	
	oModel := MPFormModel():New("XMGFCOM04",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("FRPMASTER",/*cOwner*/,oStrFRP, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	
	oModel:SetDescription("Gestores Financeiros")
	//oModel:SetPrimaryKey({"ZA1_FILIAL","ZA1_NIVEL"})	
	
Return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descrição / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição da visualização da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView := nil
	Local oModel  	:= FWLoadModel('MGFCOM04')
	
	Local oStrFRP 	:= FWFormStruct( 2, "FRP")
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_FRP' , oStrFRP, 'FRPMASTER' )
	
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	oView:SetOwnerView( 'VIEW_FRP', 'SUPERIOR' )
	
Return oView
