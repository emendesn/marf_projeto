#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
/*/
=====================================================================================
{Protheus.doc} MGFGFE53
Cadastro de Regra Desconto Conveniência

@description
Cadastro de Regra para Desconto de Conveniência
Manutenção no Cadastro

@autor Antonio Carlos
@since 17/10/2019
@type function
@table
ZF3 - Regra Desc Conv

@menu
GFE-Atualizações-MARFRIG
=====================================================================================
/*/

User Function MGFGFE53()

	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZF3")
	oMBrowse:SetDescription('Regra Desconto Conveniência')

	oMBrowse:AddLegend("ZF3_ATIVO=='1'", "GREEN", "Ativo"  )
	oMBrowse:AddLegend("ZF3_ATIVO=='2'", "RED"  , "Inativo")

	oMBrowse:Activate()

Return


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          	OPERATION 1    ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFGFE53" 	OPERATION 2    ACCESS 0           //MODEL_OPERATION_VIEW
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFGFE53" 	OPERATION 3    ACCESS 0           //MODEL_OPERATION_INSERT
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFGFE53" 	OPERATION 4    ACCESS 0           //MODEL_OPERATION_UPDATE
	ADD OPTION aRotina TITLE "Ativa/Desativa"	ACTION "U_ZF3ATVDES" 		OPERATION 4    ACCESS 0           //MODEL_OPERATION_UPDATE

Return(aRotina)


Static Function ModelDef()

	Local oModel  := Nil
	Local oStrZF3 := FWFormStruct(1,"ZF3")

	oModel := MPFormModel():New('XMGFGFE53', /*bPreValidacao*/, {||MGFGFE53V(oModel)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	oModel:AddFields("ZF3MASTER",/*cOwner*/,oStrZF3, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Regra Desconto Conveniencia")
	oModel:SetPrimaryKey({"ZF3_FILIAL","ZF3_TIPOM","ZF3_CNPJFO","ZF3_TIPOV"})

Return oModel


Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFGFE53')
	Local oStrZF3 	:= FWFormStruct( 2, "ZF3",)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZF3' , oStrZF3, 'ZF3MASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 80 )
	oView:CreateHorizontalBox( 'INFERIOR' , 20 )

	oView:SetOwnerView( 'VIEW_ZF3', 'SUPERIOR' )

Return oView

USER FUNCTION ZF3ATVDES
	
	Reclock("ZF3",.f.)
	
	If ZF3->ZF3_ATIVO == "1"
	   ZF3->ZF3_ATIVO := "2"
	Else
	   ZF3->ZF3_ATIVO := "1"
	EndIf
	
	ZF3->(MsUnlock())

RETURN

Static Function MGFGFE53V(oModel)

	Local lRet 	  := .T.
	Local oMdlZF3 := oModel:GetModel('ZF3MASTER')
	Local _cCp1	  := ""
	Local _cCp2	  := ""
	Local _cCp3	  := ""

	_cCp1 := oMdlZF3:GetValue('ZF3_TIPOV')
	_cCp2 := oMdlZF3:GetValue('ZF3_CNPJFO')
	_cCp3 := oMdlZF3:GetValue('ZF3_CDTPOP')

	If Empty(_cCp1) .AND. Empty(_cCp2) .And. Empty(_cCp3)
		lRet := MsgNoYes("A T E N Ç Ã O:  Risco de descontos indevidos nos títulos de pagamentos com relação aos campos: [Tp Veiculo], [CNPJ Fornec] e [Tipo Oper]. CONTINUA?")
	EndIf

Return lRet

/*/{Protheus.doc} GATGFE53

Gatilho para carga do nome do fornecedor

@type function
@author Paulo da Mata
@since 27/04/2020
@version P12.1.17
@return Nil
/*/
User Function GATGFE53

Local cCnpjFr := FwFldGet("ZF3_CNPJFO")
Local cEstFor := POSICIONE("SA2",3,XFILIAL("SA2")+cCnpjFr,"A2_EST")
Local cRazSoc := ""

If !Empty(cCnpjFr) 
   
   If cEstFor != "EX"
      cRazSoc := POSICIONE("SA2",3,XFILIAL("SA2")+cCnpjFr,"A2_NOME")
   EndIf

EndIf

Return(cRazSoc)