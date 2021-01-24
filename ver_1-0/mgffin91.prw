#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
   
/*   
=========================================================================================================
Programa.................: MGFFIN91
Autor:...................: Tarcisio Galeano
Data.....................: 23/03/2018
Descrição / Objetivo.....: Cadastro de sub grupos de clientes
Doc. Origem..............: GAP - CRE56
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado para F3 do campo A1_SUBGRP
=========================================================================================================
*/

User Function MGFFIN91()

	Local oMBrowse := nil
	
	dbselectArea('ZDV')
	ZDV->(dbSetOrder(1))
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZDV")
	oMBrowse:SetDescription('Cadastro Sub grupo clientes')
	oMBrowse:Activate()

Return

/*
=====================================================================================
Programa............: MenuDef
Autor:...................: Tarcisio Galeano
Data.....................: 23/03/2018
Descrição / Objetivo.....: Cadastro de sub grupos de clientes
Doc. Origem..............: GAP - CRE56
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado para F3 do campo A1_SUBGRP
=========================================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFIN91" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFIN91" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFIN91" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFIN91" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor:...................: Tarcisio Galeano
Data.....................: 23/03/2018
Descrição / Objetivo.....: Cadastro de sub grupos de clientes
Doc. Origem..............: GAP - CRE56
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado para F3 do campo A1_SUBGRP
=========================================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrZDV 	:= FWFormStruct(1,"ZDV")
	
	oModel := MPFormModel():New("XMGFFIN91", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("ZDVMASTER",/*cOwner*/,oStrZDV, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	oModel:SetDescription('Sub Grupos')
	oModel:SetPrimaryKey({"ZDV_FILIAL","ZDV_COD"})
	
Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor:...................: Tarcisio Galeano
Data.....................: 23/03/2018
Descrição / Objetivo.....: Cadastro de sub grupos de clientes
Doc. Origem..............: GAP - CRE56
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado para F3 do campo A1_SUBGRP
=========================================================================================================
*/
Static Function ViewDef()
	
	Local oView		:= Nil
	Local oModel	:= FWLoadModel( 'MGFFIN91' )
	Local oStrZDV	:= FWFormStruct( 2,"ZDV")
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_ZDV' , oStrZDV, 'ZDVMASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_ZDV', 'TELA' )
	
Return oView
