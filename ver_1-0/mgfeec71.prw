#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
/*/
=====================================================================================
{Protheus.doc} MGFEEC71
Cadastro de Inland

@description
Cadastro de Inland
Manutencao no Cadastro

@autor Cláudio Alves
@since 21/10/2019
@type function 
@table
ZFL - Cadastro Inland 
 
@menu
 Easy Export Control-Atualizacoes-ESPECIFICO MARFRIG-Cadastro Inland
 
=====================================================================================
/*/
User Function MGFEEC71()

	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZFL")
	oMBrowse:SetDescription('Cadastro Inland')

	oMBrowse:Activate()
Return


Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFEEC71" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFEEC71" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFEEC71" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFEEC71" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)


Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZFL 	:= FWFormStruct(1,"ZFL")
	Local bPosVld	:= {|oModel|PosVld(oModel)}

	oModel := MPFormModel():New("XMGFEEC71",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZFLMASTER",/*cOwner*/,oStrZFL, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Cadastro Inland")
	oModel:SetPrimaryKey({"ZFL_FILIAL","ZFL_CODIGO"})
	
Return oModel


Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFEEC71')
	Local oStrZFL 	:= FWFormStruct( 2, "ZFL",)
	
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZFL' , oStrZFL, 'ZFLMASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	// oView:CreateHorizontalBox( 'INFERIOR' , 80 )

	oView:SetOwnerView( 'VIEW_ZFL', 'SUPERIOR' )

Return oView