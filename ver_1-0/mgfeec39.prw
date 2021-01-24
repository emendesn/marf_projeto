#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'

/*
=====================================================================================
Programa............: MGFEEC39
Autor...............: Joni Lima
Data................: 20/11/2017
Descrição / Objetivo: Cadastro Courier
Doc. Origem.........: Contrato - GAP COMEX 035
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Cadastro Courier
=====================================================================================
*/
User Function MGFEEC39()

	Local oMBrowse := nil

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZC7")
	oMBrowse:SetDescription('Courier')

	oMBrowse:Activate()

return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 20/11/2017
Descrição / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP COMEX 035
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCOM39" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFCOM39" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCOM39" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFCOM39" OPERATION MODEL_OPERATION_DELETE ACCESS 0

return (aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 20/11/2017
Descrição / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP COMEX 035
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Modelo de Dados para cadastro Courier
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrEEC	:= FWFormStruct(1,"EEC")
	Local oStrZC7	:= FWFormStruct(1,"ZC7")

	oStrEEC:SetProperty( '*' , MODEL_FIELD_OBRIGAT,.F.)

	oModel := MPFormModel():New("XMGFCOM39",/*bPreValidacao*/,/*bPosVld*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )	

	oModel:AddFields("EECMASTER",/*cOwner*/,oStrEEC, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZC7DETAIL","EECMASTER",oStrZC7, /*bLinePreValid*/,/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:SetRelation("ZC7DETAIL",{{"ZC7_FILIAL","xFilial('ZC7')"},{"ZC7_PREEMB", "EEC_PREEMB"}},ZC7->(IndexKey(1)))

	oModel:GetModel( 'EECMASTER' ):SetOnlyView(.T.)
	oModel:GetModel( 'ZC7DETAIL' ):SetOptional(.T.)

	oModel:SetDescription("Courier")
	oModel:SetPrimaryKey({"ZC7_FILIAL","ZC7_PREEMB","ZC7_CODCOU"})

Return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 19/12/2016
Descrição / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP COMEX 035
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição da visualização da tela
=====================================================================================
*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFEEC39')	

	Local oStrEEC 	:= FWFormStruct( 2, "EEC")	
	Local oStrZC7 	:= FWFormStruct( 2, "ZC7")

	oStrZC7:RemoveField("ZC7_PREEMB")

	oView := FWFormView():New()
	oView:SetModel(oModel)			

	oView:AddField( 'VIEW_EEC' , oStrEEC, 'EECMASTER' )
	oView:AddGrid(  'VIEW_ZC7' , oStrZC7, 'ZC7DETAIL' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 40 )
	oView:CreateHorizontalBox( 'INFERIOR' , 60 )

	oView:SetOwnerView( 'VIEW_EEC', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZC7', 'INFERIOR' )

Return oView

/*
=====================================================================================
Programa............: xMGF39Men
Autor...............: Joni Lima
Data................: 21/11/2017
Descrição / Objetivo: Botão para inclisão de Courier
Doc. Origem.........: Contrato - GAP COMEX 035
=====================================================================================
*/
User Function xMGF39Men(cTipo)

	If cTipo == "BUTTON_REMESSA" .and. lALTERA
		aAdd(aButtons, {"EDIT" /*"ALT_CAD"*/, {|| U_xMGF39EVW()}, "Courier"}) //"Alterar"
	EndIf

Return

/*
=====================================================================================
Programa............: xMGF39EVW
Autor...............: Joni Lima
Data................: 21/11/2017
Descrição / Objetivo: Execução de View
Doc. Origem.........: Contrato - GAP COMEX 035
=====================================================================================
*/
User Function xMGF39EVW() 

	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

	FWExecView("Courier", "MGFEEC39", MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )

return

User Function xMGF39I(cTipo)
	Local aAreaWI := {}
	Public nTotRX  := 0

	Private oSayZValor, oGetPsZRe

	If IsInCallStack("EECAE100")
		If cTipo == "ROD_CAPA_EMB"
			aAreaWI := WORKIP->(GetArea())
			WORKIP->(DbGoTop())

			While !WORKIP->(Eof())
				nTotRX += WORKIP->EE9_ZTOTRX
				WORKIP->(DbSkip())
			EndDo

			@ nL3,nC5 SAY oSayZValor VAR "Total ReExportacao" PIXEL SIZE 50,7 OF oPanel2//oRodape//"Peso Bruto "
			@ nL3,nC6 MSGET oGetPsZRe  VAR nTotRX PICTURE PesqPict("EE9","EE9_ZTOTRX") SIZE 65,6 RIGHT PIXEL WHEN .F. /*VALID (Positivo() .And. AllwaysTrue(AvExecGat("EE9_PSBRTO")))*/ OF oPanel2//oRodape

			WORKIP->(RestArea(aAreaWI))

			If Type("aObjs[2]:oBrowse") = "O" // testa, pois quando é dado o end da dialog, o oBrowse não existe mais.
				aObjs[2]:oBrowse:Refresh() //Atualiza os dados do browse da GetDados
			EndIf

			If Type("aObjs[3]:oBrowse") = "O" // testa, pois quando é dado o end da dialog, o oBrowse não existe mais.
				aObjs[3]:oBrowse:Refresh() //Atualiza os dados do browse da GetDados
			EndIf
		EndIf
	EndIf

Return

/*/{Protheus.doc} xMGF39t
//TODO Atualiza valores para Total Reimportação
@author leonardo.kume
@since 21/12/2017
@version 6
@return Boolean, sempre true
@param cTipo, characters, ponto de entrada
@type function
/*/
User Function xMGF39t(cTipo)
	Local lRet := .T.
	
//	If Type("aObjs[2]:oBrowse") = "O" .OR. Type("aObjs[3]:oBrowse") = "O"
//		MSGSTOP(cTipo)
//	EndIF
	
	If cTipo == "VALIDA_ITEM"
		If Select("WORKOPOS")
			aAreaWI := WORKOPOS->(GetArea())
			WORKOPOS->(DbGoTop())
	
			nTotRX := 0 //Variavel Private
			While !WORKOPOS->(Eof())
				If WORKOPOS->EE9_SEQUEN <> M->EE9_SEQUEN //.and. WORKIP->EE9_SEQEMB <> M->EE9_SEQEMB
					nTotRX += WORKOPOS->EE9_ZTOTRX
				EndIf
				WORKOPOS->(DbSkip())
			EndDo
	
			nTotRX += M->EE9_ZTOTRX
			
			WORKOPOS->(RestArea(aAreaWI))
			
			If Type("aObjs[2]:oBrowse") = "O" // testa, pois quando é dado o end da dialog, o oBrowse não existe mais.
				aObjs[2]:oBrowse:Refresh() //Atualiza os dados do browse da GetDados
			EndIf
	
			If Type("aObjs[3]:oBrowse") = "O" // testa, pois quando é dado o end da dialog, o oBrowse não existe mais.
				aObjs[3]:oBrowse:Refresh() //Atualiza os dados do browse da GetDados
			EndIf
		EndIf
	EndIf
	

Return lRet

/*/{Protheus.doc} xMGF39v
//TODO Mensagem quando campo Offshore Cancelado Ativo para apagar Embarque na empresa 90
@author leonardo.kume
@since 21/12/2017
@version 6
@param cParam, characters, ponto de entrada
@return boolean, sempre true
@type function
/*/
User Function xMGF39v(cParam)
	Local lRet 		:= .t.
	Local aAreaEEC 	:= EEC->(GetArea())
	Local cEmbarque := EEC->EEC_PREEMB
	Local cOffCanc	:= EEC->EEC_ZOFFCA
	Local aDados 	:= {EEC->EEC_ZCONDP ,;
						EEC->EEC_ZDIASP ,;
						EEC->EEC_ZINCOT ,;
						EEC->EEC_ZDEST  ,;
						EEC->EEC_ZFRPRE ,;
						EEC->EEC_ZSEGPR ,;
						EEC->EEC_ZETA   ,;
						EEC->EEC_ZETD   ,;
						EEC->EEC_ZEMBAR ,;
						EEC->EEC_ZBOOK  ,;
						EEC->EEC_ZZIMSA ,;
						EEC->EEC_ZZLJSA ,;
						EEC->EEC_ZIMPOR ,;
						EEC->EEC_ZIMLOJ ,;
						EEC->EEC_ZCONSI ,;
						EEC->EEC_ZCOLOJ ,;	
						EEC->EEC_ZREEXP,;
						EEC->EEC_ZFRETE,;
						EEC->EEC_ZSEGUR}	

	If 	IsInCallStack("EECAE100") .and. cParam ==  "GRV_CPOS_CUSTOM"
		DbSelectArea("EEC")
		DbSetOrder(1)
		If DbSeek(xFilial("EEC","900001")+cEmbarque)
			If cOffCanc == "1"
					MsgInfo("É necessário cancelar o embarque na empresa Offshore.","Atenção")
			EndIf
			RecLock("EEC",.F.)
				EEC->EEC_ZCONDP := aDados[1]
				EEC->EEC_ZDIASP := aDados[2]
				EEC->EEC_ZINCOT := aDados[3]
				EEC->EEC_ZDEST  := aDados[4]
				EEC->EEC_ZFRPRE := aDados[5]
				EEC->EEC_ZSEGPR := aDados[6]
				EEC->EEC_ZETA   := aDados[7]
				EEC->EEC_ZETD   := aDados[8]
				EEC->EEC_ZEMBAR := aDados[9]
				EEC->EEC_ZBOOK  := aDados[10]
				EEC->EEC_ZZIMSA := aDados[11]
				EEC->EEC_ZZLJSA := aDados[12]
				EEC->EEC_ZIMPOR := aDados[13]
				EEC->EEC_ZIMLOJ := aDados[14]
				EEC->EEC_ZCONSI := aDados[15]
				EEC->EEC_ZCOLOJ := aDados[16]
				EEC->EEC_ZREEXP := aDados[17]
				EEC->EEC_FRPREV := aDados[18]
				EEC->EEC_ZFRETE := aDados[18]
				EEC->EEC_SEGPRE := aDados[19]
				EEC->EEC_ZSEGUR := aDados[19]
			EEC->(MsUnlock())
		EndIf
	EndIf
	
	EEC->(RestArea(aAreaEEC))

Return lRet
