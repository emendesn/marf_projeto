#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
/*/
=====================================================================================
{Protheus.doc} MGFGFE54
Cadastro de Exceo regra Desconto Convenincia

@description
Cadastro de Exceo regra Desconto Convenincia
Manuteno no Cadastro

@autor Antonio Carlos
@since 17/10/2019
@type function
@table
ZF4 - Exc Pedido Desc Conv

@menu
GFE-Atualizaes-MARFRIG
=====================================================================================
/*/
User Function MGFGFE54()

	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZF4")
	oMBrowse:SetDescription('Exceção Regra Desconto Conveniência')

	oMBrowse:AddLegend("ZF4_ATIVO=='1'", "GREEN", "Ativo"  )
	oMBrowse:AddLegend("ZF4_ATIVO=='2'", "RED"  , "Inativo")

	oMBrowse:Activate()

Return


Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"           	OPERATION 1    ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFGFE54"  	OPERATION 2    ACCESS 0           //MODEL_OPERATION_VIEW
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFGFE54"  	OPERATION 3    ACCESS 0           //MODEL_OPERATION_INSERT
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFGFE54"  	OPERATION 4    ACCESS 0           //MODEL_OPERATION_UPDATE
	ADD OPTION aRotina TITLE "Ativa/Desativa"	ACTION "u_ZF4ATVDES" 		OPERATION 4    ACCESS 0           //MODEL_OPERATION_UPDATE

Return(aRotina)


Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZF4 	:= FWFormStruct(1,"ZF4")

	oModel := MPFormModel():New("XMGFGFE54",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZF4MASTER",/*cOwner*/,oStrZF4, /*bPreValid*/, {||MGFGFE54V(oModel)}/*bPosValid*/, /*bCarga*/ )
	
	oModel:SetDescription('Exceção Regra Desconto Conveniência')
	oModel:SetPrimaryKey({"ZF4_FILIAL","ZF4_TPPED","ZF4_DESCP","ZF4_DTINC"})

Return oModel


Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFGFE54')
	Local oStrZF4 	:= FWFormStruct( 2, "ZF4",)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZF4' , oStrZF4, 'ZF4MASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 80 )
	oView:CreateHorizontalBox( 'INFERIOR' , 20 )

	oView:SetOwnerView( 'VIEW_ZF4', 'SUPERIOR' )

Return oView

USER FUNCTION ZF4ATVDES

	Reclock("ZF4",.f.)
	
	If  ZF4->ZF4_ATIVO == "1"
		ZF4->ZF4_ATIVO := "2"
	Else
		ZF4->ZF4_ATIVO := "1"
	EndIf

	ZF4->(MsUnlock())

RETURN

Static Function MGFGFE54V(oModel)

	Local lRet 	  := .T.
	Local oMdlZF4 := oModel:GetModel('ZF4MASTER')
	Local _cCp1	  := ""
	Local _cCp2	  := ""
	Local _cCp3	  := ""
	Local _cCp4	  := ""
	Local _cCab	  := "Falta de conteúdo"
	Local _cDes	  := "Necessário o preencimento de um dos seguintes campos : [Tipo pedido], [CNPJ Fornecedor] , [Placa] e [Tipo Oper] "
	Local _cSol	  := "Preencher com conteúdo um dos seguintes campos : [Tipo pedido] , [CNPJ Fornecedor] , [Placa] e [Tipo Oper] "

	_cCp1 := oMdlZF4:GetValue('ZF4_TPPED')
	_cCp2 := oMdlZF4:GetValue('ZF4_CNPJFO')
	_cCp3 := oMdlZF4:GetValue('ZF4_PLACA')
    _cCp4 := oMdlZF4:GetValue('ZF4_CDTPOP')

	If Empty(_cCp1) .And. Empty(_cCp2) .And. Empty(_cCp3) .And. Empty(_cCp4)
		Help(NIL, NIL, _cCab, NIL, _cDes, 1, 0, NIL, NIL, NIL, NIL, NIL, {_cSol})
		lRet := .F.
	EndIf

Return lRet

/*/{Protheus.doc} GATGFE54

Gatilho para carga do nome do fornecedor

@type function
@author Paulo da Mata
@since 27/04/2020
@version P12.1.17
@return Nil
/*/
User Function GATGFE54

Local cCnpjFr := FwFldGet("ZF4_CNPJFO")
Local cEstFor := POSICIONE("SA2",3,XFILIAL("SA2")+cCnpjFr,"A2_EST")
Local cRazSoc := ""

If !Empty(cCnpjFr) 
   
   If cEstFor != "EX"
      cRazSoc := POSICIONE("SA2",3,XFILIAL("SA2")+cCnpjFr,"A2_NOME")
   EndIf

EndIf

Return(cRazSoc)