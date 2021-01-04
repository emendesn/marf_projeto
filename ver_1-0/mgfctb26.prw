#include 'protheus.ch'
#include 'parmtype.ch'
#include "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFCTB26
Autor...............: Joni Lima
Data................: 29/01/2016
Descricao / Objetivo: Cadastro de Limite de Usuarios
Doc. Origem.........: Contrato - GAP GRADE ERP para contabil
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro de Limite de Usuarios
=====================================================================================
*/
user function MGFCTB26()

	Local oMBrowse := nil

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZCU")
	oMBrowse:SetDescription('Limite Usuarios')

	oMBrowse:Activate()

Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 29/01/2019
Descricao / Objetivo: MenuDef da rotina
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCTB26" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFCTB26" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCTB26" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFCTB26" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 29/01/2019
Descricao / Objetivo: ModelDef
Obs.................: Definicao do Modelo de Dados para cadastro de limite Usuarios
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZCU 	:= FWFormStruct(1,"ZCU")
	
	oModel := MPFormModel():New("XMGFCTB26",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZCUMASTER",/*cOwner*/,oStrZCU, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	
	oModel:SetDescription("Limite Usuario")
	oModel:SetPrimaryKey({"ZCU_FILIAL","ZCU_CDUSER"})
	
return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 29/01/2019
Descricao / Objetivo: ViewDef
Obs.................: Definicao da visualizasao da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView
	Local oModel  	:= FWLoadModel('MGFCTB26')

	Local oStrZCU 	:= FWFormStruct( 2, "ZCU")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZCU' , oStrZCU, 'ZCUMASTER' )
	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZCU', 'TELA' )
	
Return oView

/*
=====================================================================================
Programa............: xMC26Som
Autor...............: Joni Lima
Data................: 29/01/2019
Obs.................: Realiza Soma no Saldo do Usuario
=====================================================================================
*/
User Function xMC26Som(cxFil,cxUser,nValor)
	
	Local aArea 	:= GetArea()
	Local aAreaZCU	:= ZCU->(GetArea())
	
	dbSelectArea("ZCU")
	ZCU->(dbSetOrder(1))//ZCU_FILIAL+ZCU_CDUSER
	
	If ZCU->(dbSeek(cxFil + cxUser))
		RecLock("ZCU",.F.)
			ZCU->ZCU_SALDO := ZCU->ZCU_SALDO + nValor 
		ZCU->(MsUnLock())
	EndIf
	
	RestArea(aAreaZCU)
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMC26Som
Autor...............: Joni Lima
Data................: 29/01/2019
Obs.................: Realiza Subtra��o no Saldo do Usuario
=====================================================================================
*/
User Function xMC26Sub(cxFil,cxUser,nValor)

	Local aArea 	:= GetArea()
	Local aAreaZCU	:= ZCU->(GetArea())
	
	dbSelectArea("ZCU")
	ZCU->(dbSetOrder(1))//ZCU_FILIAL+ZCU_CDUSER
	
	If ZCU->(dbSeek(cxFil + cxUser))
		RecLock("ZCU",.F.)
			ZCU->ZCU_SALDO := ZCU->ZCU_SALDO - nValor 
		ZCU->(MsUnLock())
	EndIf
	
	RestArea(aAreaZCU)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMC26Gat
Autor...............: Joni Lima
Data................: 29/01/2019
Obs.................: Gatilho para o campo ZCU_LIMITE
=====================================================================================
*/
User Function xMC26Gat()

	Local nRet := 0
	local nLimite := 0
	Local nSaldo  := 0
	
	Local oModel := FwModelActive()
	Local oMdlZCU := oModel:GetModel("ZCUMASTER")
	
	If  oModel:GetOperation() == MODEL_OPERATION_INSERT
		nRet := oMdlZCU:GetValue('ZCU_LIMITE')
	Else
		
		nLimite := ZCU->ZCU_LIMITE
		nSaldo	:= ZCU->ZCU_SALDO
		
		If nLimite <> oMdlZCU:GetValue('ZCU_LIMITE')
			nRet := oMdlZCU:GetValue('ZCU_LIMITE') - (nLimite - nSaldo)//nSaldo + (oMdlZCU:GetValue('ZCU_LIMITE') - nSaldo)
		Else
			nRet := nSaldo
		EndIf
		
	EndIf

return nRet

/*
=====================================================================================
Programa............: xMC26Val
Autor...............: Joni Lima
Data................: 29/01/2019
Obs.................: Validacao para o campo ZCU_LIMITE
=====================================================================================
*/
User Function xMC26Val(oMdlZCU,cFld,xValue)
	
	Local oModel := oMdlZCU:GetModel()
	Local lRet 		:= .T.

	local nLimite := 0
	Local nSaldo  := 0
	
	If  oModel:GetOperation() <> MODEL_OPERATION_INSERT
		nLimite := ZCU->ZCU_LIMITE
		nSaldo	:= ZCU->ZCU_SALDO		
		If nLimite <> nSaldo
			If !(xValue >= (nLimite - nSaldo)) 
				lRet := .F.
				oMdlZCU:GetModel():SetErrorMessage(oMdlZCU:GetId(),cFld,oMdlZCU:GetModel():GetId(),cFld,cFld,;
					"Limite nao pode ser inferior ao saldo que j� esta sendo utilizado : R$ " + alltrim(str(nLimite - nSaldo)), "Para essa manutencao favor realizar exclusao ou aprovacao dos itens desse usuario que estao em aberto")
			EndIf
		EndIf
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMC26Sal
Autor...............: Joni Lima
Data................: 01/02/2019
Obs.................: Realiza Verificacao se o usuario possui saldo para fazer o lan�amento
=====================================================================================
*/
User Function xMC26Sal(cxFil,cxUser,nValor)

	Local aArea 	:= GetArea()
	Local aAreaZCU
	Local lRet		:= .T.
	Local cUsDireto		:= SuperGetMV("MGF_CTB25A",.F.,"000000")
	Local cEmpDireto	:= SuperGetMV("MGF_CTB25B",.F.,"02/") //Grupo de empresas que nao passaram pela grade de aprovacao.
	Local cxUser		:= Alltrim(RetCodUsr())

	If !(cxUser $ cUsDireto .OR. cEmpAnt $ cEmpDireto)  //Verifica se usuario ou Grupo de empresa passa direto
	
		aAreaZCU	:= ZCU->(GetArea()) //Natanael, 25/Jul/2019: Coloquei o GetArea dentro do IF para nao gerar erro nos grupo que nao possui o dicion�rio criado.

		dbSelectArea("ZCU")
		ZCU->(dbSetOrder(1))//ZCU_FILIAL+ZCU_CDUSER
	
		If ZCU->(dbSeek(cxFil + cxUser))
			lRet := ZCU->ZCU_SALDO >= nValor
			If !lRet
				MSGALERT( 'O Seu usuario nao tem Saldo para fazer esse Lancamento', 'Usuario sem Saldo Suficiente' )
			EndIf
		EndIf

		RestArea(aAreaZCU)

	else
		lRet := .T.
	EndIf
	RestArea(aArea)

Return lRet
