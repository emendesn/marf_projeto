#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
/*/
=====================================================================================
{Protheus.doc} MGFEEC72|
Cadastro de Inland

@description
Cadastro de Inland
Manutencao no Cadastro

@autor Cl�udio Alves
@since 21/10/2019
@type function 
@table
ZFM - Cadastro Regras Inland 
 
@menu
 Easy Export Control-Atualizacoes-ESPECIFICO MARFRIG-Cadastro Regras Inland
 
=====================================================================================
/*/
User Function MGFEEC72()

	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZFM")
	oMBrowse:SetDescription('Cadastro Regras Inland')

	oMBrowse:Activate()
Return


Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFEEC72" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFEEC72" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFEEC72" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFEEC72" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)


Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZFM 	:= FWFormStruct(1,"ZFM")
	Local bPosVld	:= {|oModel|PosVld(oModel)}

	oModel := MPFormModel():New("XMGFEEC72",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZFMMASTER",/*cOwner*/,oStrZFM, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Cadastro Regras Inland")
	oModel:SetPrimaryKey({"ZFM_FILIAL","ZFM_CODIGO"})
	
Return oModel


Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFEEC72')
	Local oStrZFM 	:= FWFormStruct( 2, "ZFM",)
	
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZFM' , oStrZFM, 'ZFMMASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	// oView:CreateHorizontalBox( 'INFERIOR' , 80 )

	oView:SetOwnerView( 'VIEW_ZFM', 'SUPERIOR' )

Return oView
