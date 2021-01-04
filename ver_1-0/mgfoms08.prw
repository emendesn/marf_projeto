#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MGFOMS08 (Histórico de Origem/Destino)
Criação de rotina para para gravar historico nas alterações "de origem destino" do fonte MGFOMS087.

@description
Nesta historico deverá constar todos os campos pertinentes na tela.

@author Henrique Vidal Santos
@since 27/08/2019

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	DAK - Cargas                        
	ZEK - Historico Origem x Destino     

@param
@return

@menu
	Sigaoms - OMSA200.PRW Outras acções
/*/

User function MGFOMS08(_cFilCrg, _cNumCrg, _cSeqCrg)

	Private oBrowse3
	Private aRotina := MenuDef()
	
	Default 	_cFilCrg	:=	"" 
	Default	_cNumCrg	:= 	""
	Default	_cSeqCrg	:=	""
	
	If Alltrim(FunName()) == "OMSA200"	
		_cFilCrg	:=	DAK->DAK_FILIAL 
		_cNumCrg	:= 	DAK->DAK_COD
		_cSeqCrg	:=	DAK->DAK_SEQCAR
	EndIf 

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('ZEK')
	oBrowse3:SetDescription('Histórico de Origem/Destino')
	
	If !Empty(_cFilCrg) .And. !Empty(_cNumCrg) .And. !Empty(_cSeqCrg)
		oBrowse3:SetFilterDefault("ZEK->ZEK_FILIAL = '" + _cFilCrg + "' .AND. ZEK->ZEK_COD = '" + _cNumCrg + "' .AND. ZEK->ZEK_SEQCAR = '" + _cSeqCrg + "'  ")
	EndIf 
	
	oBrowse3:Activate()

return NIL

Static function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.MGFOMS08' 	OPERATION 2 ACCESS 0
	
Return aRotina

Static Function ModelDef()
	
	Local oStruZEK := FWFormStruct( 1, 'ZEK')
	Local oModel

	oModel := MPFormModel():New('XMGFOMS08',/**/ , , , /*bCancel*/ )

	oModel:AddFields( 'ZEKMASTER', /*cOwner*/, oStruZEK, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetPrimaryKey({"ZEK_FILIAL","ZEK_COD"})

	oModel:SetDescription( 'Histórico de Origem/Destino' )	
	
	oModel:GetModel( 'ZEKMASTER' ):SetDescription( 'Histórico de Origem/Destino' )

Return oModel

Static Function ViewDef()

	Local oStruZEK := FWFormStruct( 2, 'ZEK') 
	Local oModel   := FWLoadModel( 'MGFOMS08' )
	Local oView

	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZEK', oStruZEK, 'ZEKMASTER' )

Return oView