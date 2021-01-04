#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} MGFCOMB8
Browse onde pode ser clamado a relação de tipo de veiculo com  suas classificações (DUT vs ZEG)
@type function

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
User Function MGFCOMB8()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("DUT")
	oMBrowse:SetDescription('Tipo Veiculo Vs Classificacao')

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
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	//ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	//ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFCOMB8" OPERATION MODEL_OPERATION_DELETE ACCESS 0

	return(aRotina)


	/*/{Protheus.doc} ModelDef
	Definições do Modelo de Dados
	@type function

	@return  	oModel, Objeto  do Tipo MPFORMMODEL, Modelo de Dados

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrDUT 	:= FWFormStruct(1,"DUT")
	Local oStrZEG 	:= FWFormStruct(1,"ZEG")

	oModel := MPFormModel():New("XMGFCOMB8",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("DUTMASTER",/*cOwner*/,oStrDUT, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZEGDETAIL","DUTMASTER",oStrZEG, /*bLinePreValid*/,/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:SetRelation("ZEGDETAIL",{{"ZEG_FILIAL","xFilial('ZEG')"},{"ZEG_TIPVEI", "DUT_TIPVEI"}},ZEG->(IndexKey(1)))

	oModel:GetModel( "ZEGDETAIL" ):SetUniqueLine({"ZEG_CODCLA"})

	oModel:SetDescription("Tipo Veiculo vs Classificao")
	oModel:SetPrimaryKey({"DUT_FILIAL","DUT_TIPVEI"})

	oModel:GetModel( 'DUTMASTER' ):SetOnlyView( .T. ) //Não Pode alterar nenhum dado
	oModel:GetModel( 'DUTMASTER' ):SetOnlyQuery( .T. )//Não grava nada na tabela

	oModel:GetModel( 'ZEGDETAIL' ):SetOptional( .T. )//Deixa a Grid como Opcional

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
	Local oModel  	:= FWLoadModel('MGFCOMB8')

	Local cFldZEG 	:= "ZEG_TIPVEI" //Campo(s) que não serão apresentados na VIEW

	Local oStrDUT 	:= FWFormStruct( 2, "DUT",)
	Local oStrZEG 	:= FWFormStruct( 2, "ZEG",{|cCampo|!(AllTrim(cCampo) $ cFldZEG)})

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_DUT' , oStrDUT, 'DUTMASTER' )
	oView:AddGrid( 'VIEW_ZEG'  , oStrZEG, 'ZEGDETAIL' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
	oView:CreateHorizontalBox( 'INFERIOR' , 80 )

	oView:SetOwnerView( 'VIEW_DUT', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZEG', 'INFERIOR' )

	oStrDUT:SetProperty('*', MVC_VIEW_CANCHANGE, .F.)

	Return oView