#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} MGFCOMB8
Browse onde pode ser clamado a Tela para Amarração de Loja (C1E)
@type function

@author Joni Lima do Carmo
@since 25/06/2019
@version P12
/*/
User Function MGFCOMB9()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("C1E")
	oMBrowse:SetDescription('FIlias Loja')

	oMBrowse:SetOnlyFields( { 'C1E_FILTAF', 'C1E_NOME', 'C1E_ZLOJA' } )

	oMBrowse:Activate()

Return

	/*/{Protheus.doc} MenuDef
	Menu com as opções do browse
	@type function

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCOMB9" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	//ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCOMB9" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_DELETE ACCESS 0

return(aRotina)


	/*/{Protheus.doc} ModelDef
	Definições do Modelo de Dados
	@type function

	@return  	oModel, Objeto  do Tipo MPFORMMODEL, Modelo de Dados

	@author Joni Lima do Carmo
	@since 25/06/2019
	@version P12
	/*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrC1E 	:= FWFormStruct(1,"C1E")

	oStrC1E:SetProperty( '*' , MODEL_FIELD_OBRIGAT ,.F.)
	oStrC1E:SetProperty( '*' , MODEL_FIELD_VALID   ,{||.T.})

	oModel := MPFormModel():New("XMGFCOMB9",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("C1EMASTER",/*cOwner*/,oStrC1E, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Filial Loja")
	//	oModel:SetPrimaryKey({"DUT_FILIAL","DUT_TIPVEI"})

Return oModel

	/*/{Protheus.doc} ViewDef
	Definições da View para tela
	@type function

	@return  	oView, Objeto  do Tipo FWFORMVIEW, View da tela

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFCOMB9')

	Local cFldC1E 	:= "C1E_FILTAF,C1E_NOME,C1E_ZLOJA" //Campo(s) que não serão apresentados na VIEW

	Local oStrC1E 	:= FWFormStruct( 2, "C1E",{|cCampo|(AllTrim(cCampo) $ cFldC1E)})

	oStrC1E:SetProperty( 'C1E_FILTAF' , MVC_VIEW_CANCHANGE,.F.)
	oStrC1E:SetProperty( 'C1E_NOME'   , MVC_VIEW_CANCHANGE,.F.)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_C1E' , oStrC1E, 'C1EMASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )

	oView:SetOwnerView( 'VIEW_C1E', 'SUPERIOR' )

Return oView

/*/{Protheus.doc} xMGFB9Lib
	Verifica as Validações que serão adcionadas nas tabelas SA1 e SA2
	@type function

	@param		cxTab, tabela que sera recebida na função
	@return  	xRet, COnteudo para o campo A1_ZAUTAPR

	@author Joni Lima do Carmo
	@since 28/06/2019
	@version P12
/*/
User Function xMGFB9Lib(cxTab)

	Local aArea	:= GetArea()

	Local xRet := ""

	If cxTab == "SA1"
		If M->A1_ZTPRHE == "F"
			//01 = CDM
			xRet := xAtuFld("01",cxTab)

			//02 = Fiscal
			xRet := xAtuFld("02",cxTab)

			//03 = Contabil
			xRet := xAtuFld("03",cxTab)

			//04 = Financeiro
			If xEncMont()
				xRet := xAtuFld("04",cxTab)
			EndIf
		EndIf
	ElseIf cxTab == "SA2"
		If M->A2_ZTPRHE == "F"
			//01 = CDM
			xRet := xAtuFld("01",cxTab)

			//02 Fiscal
			xRet := xAtuFld("02",cxTab)

			//03 = Contabil
			xRet := xAtuFld("03",cxTab)
		ENDIF
	EndIf

	RestArea(aArea)

Return xRet

Static Function xAtuFld(cRegra,cxTab)

	Local cRet 		:= ""
	Local aRegra	:= {}

	If cxTab == "SA1"
		cRet := Alltrim(M->A1_ZAUTAPR)
	ElseIf cxTab == "SA2"
		cRet := Alltrim(M->A2_ZAUTAPR)
	EndIf

	If !( cRegra $ cRet )
		If !Empty(cRet)
			cRet += "|"
		EndIf
		cRet += cRegra
		If cxTab == "SA1"
			M->A1_ZAUTAPR := cRet
		ElseIf cxTab == "SA2"
			M->A2_ZAUTAPR := cRet
		EndIf
	EndIf

Return cRet

Static Function xEncMont()

	Local aArea 	:= GetArea()
	Local aAreaC1E	:= C1E->(GetArea())

	Local lRet := .F.

	dbSelectArea("C1E")
	C1E->(dbSetOrder(3))//C1E_FILIAL+C1E_FILTAF+C1E_ATIVO
	If C1E->(dbSeek(xFilial("C1E") + M->A1_ZCFIL ))
		If C1E->C1E_ZLOJA == "S"
			lRet := .T.
		EndIf
	EndIf
	RestArea(aAreaC1E)
	RestArea(aArea)

Return lRet