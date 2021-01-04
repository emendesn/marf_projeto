#INCLUDE "TOTVS.CH"
#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'PARMTYPE.ch'

#DEFINE _Chr Chr(13)+Chr(10)

/*/
{Protheus.doc} MGFEEC24()
Browse EXP - Tela manutenção EXP

@author Joni Lima
@since 17/04/2017
@type User Function

@auteracao A. Carlos
@since 13/11/2019
Incuido função para gatilhar e bloquear o campo ZB8_INLAND

/*/
User function MGFEEC24()

	Local oMBrowse := nil
	Local aOldRot := iif(Type("aRotina")<>"U",aRotina,{})
	//RVBJ
	Private lValZWee	:= GetMv("MGF_EEC24B",,.F.) //Habilita validação cpo ZB8_ZWEEKD (Weed De)

	If Type("aRotina")<>"U"
		aRotina := {}
	EndIf

	DbSelectArea("ZB8")
	ZB8->(DbSetOrder(3))
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZB8")
	oMBrowse:SetDescription('EXP')

	oMBrowse:AddLegend("ZB8_MOTEXP = '1' ","YELLOW" ,'Aguardando Distribuição')
	oMBrowse:AddLegend("ZB8_MOTEXP = '5' ","WHITE"  ,'EXP Parcialmente Distribuida')
	oMBrowse:AddLegend("ZB8_MOTEXP = '6' ","GRAY"   ,'EXP Distribuida')
	oMBrowse:AddLegend("ZB8_MOTEXP = '4' ","BLUE"   ,'Pedido Exportação Parcialmente Gerado')
	oMBrowse:AddLegend("ZB8_MOTEXP = '2' ","GREEN"  ,'Pedido Exportação Gerado')
	oMBrowse:AddLegend("ZB8_MOTEXP = '3' ","RED"    ,'EXP Cancelada')
	oMBrowse:AddLegend("ZB8_MOTEXP = '7' ","PINK"   ,'Pedido de Venda Gerado')

	If IsInCallStack('U_MGFEEC19')  
		oMBrowse:SetMenuDef("MGFEEC24")
		oMBrowse:SetFilterDefault("ZB8_FILIAL == '" + ZZC->ZZC_FILIAL +  "' .and. ZB8_ORCAME == '" + ZZC->ZZC_ORCAME + "' ")
	EndIf

	oMBrowse:Activate()

	If Type("aRotina")<>"U"
		aRotina := aOldRot
	EndIf

return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 17/04/2017
Descrição / Objetivo: MenuDef Browse
=====================================================================================
*/
Static function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    	  		ACTION "PesqBrw"          	OPERATION 1                      	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"   	  		ACTION "VIEWDEF.MGFEEC24" 	OPERATION MODEL_OPERATION_VIEW   	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"       	  		ACTION "VIEWDEF.MGFEEC24" 	OPERATION MODEL_OPERATION_UPDATE 	ACCESS 0
	ADD OPTION aRotina TITLE "Cancelar"     	   		ACTION "U_M24CanZB" 	  	OPERATION 7 					 	ACCESS 0
	ADD OPTION aRotina TITLE "Gerar Pedido" 	  		ACTION "U_xMEEC24GP"	  	OPERATION 8 					 	ACCESS 0
	ADD OPTION aRotina TITLE "Certif.Sanitario"  		ACTION "U_EEC46B"         	OPERATION 6 					 	ACCESS 0
	ADD OPTION aRotina TITLE "Packing List"	  			ACTION "U_MGFEEC47"        	OPERATION 13 					 	ACCESS 0
	ADD OPTION aRotina TITLE "Proforma Invoice"	  		ACTION "U_MGFEEC21"       	OPERATION 10 					 	ACCESS 0
	ADD OPTION aRotina TITLE 'Shipping Instructions'	ACTION 'u_MGFECC14' 		OPERATION 9 						ACCESS 0
	ADD OPTION aRotina TITLE 'Documentos'				ACTION 'u_MGFEEC15' 		OPERATION 11 						ACCESS 0
	ADD OPTION aRotina TITLE 'Distribuir'				ACTION 'u_MGFEEC33' 		OPERATION 12						ACCESS 0
	ADD OPTION aRotina TITLE 'Conhecimento'				ACTION 'U_ZB8Recno'			OPERATION 14 						ACCESS 0
	ADD OPTION aRotina TITLE 'Adiantamento'				ACTION 'u_xAdiant24'		OPERATION 15 						ACCESS 0
	ADD OPTION aRotina TITLE 'Envia EXP ao TMS'			ACTION 'U_TMSENVEX'			OPERATION 16 						ACCESS 0
	ADD OPTION aRotina TITLE 'Despesas EXP'  			ACTION 'U_xSeekSc7'			OPERATION 17 						ACCESS 0

return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 17/04/2017
Descrição / Objetivo: Modelo de Dados
=====================================================================================
*/
Static function ModelDef()

	Local oStruZB8 := FWFormStruct( 1, 'ZB8')
	Local oStruZB9 := FWFormStruct( 1, 'ZB9')

	Local oModel := nil

	Local aAux := {}

//Roberto-----------------------------------------------------------------
	Local _aGrpuser := UsrRetgrp(RetCodusr())
	Local _cGrpposv := SuperGetMV("MGF_EXPPOS",.F.,' ')
	Local _cGrppcp  := SuperGetMV("MGF_ECC24B",.F.,' ')
	local oModel	:= nil
//EOF---------------------------------------------------------------------

	If IsInCallStack("U_M24CanZB")
		oStruZB8:SetProperty('*',MODEL_FIELD_WHEN, {||.F.})
		oStruZB8:SetProperty('ZB8_MOTCAN',MODEL_FIELD_OBRIGAT, .T.)
		oStruZB8:SetProperty('ZB8_MOTCAN',MODEL_FIELD_WHEN, {||.T.})
		oStruZB9:SetProperty('*',MODEL_FIELD_WHEN, {||.F.})
	EndIf

	//*************************************************************************************
	// GATILHO GENSET
	//*************************************************************************************

//Roberto-----------------------------------------------------------------
	If __cUserId $ _cGrpposv  
		aAux := FwStruTrigger('ZB8_DEST' ,;
		'ZB8_DEST' ,;
		'U_GENSE24("ZB8_DEST", M->ZB8_DEST)',;
		.F.,;
		'',;
		0,;
		'')
		oStruZB8:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
		aAux[2] , ; // [02] identificador (ID) do campo de destino
		aAux[3] , ; // [03] Bloco de c?digo de valida??o da execu??o do gatilho
		aAux[4] ) // [04] Bloco de c?digo de execu??o do gatilho
    EndIf
//EOF---------------------------------------------------------------------

	//**********************
	// ZB8_IMPORT
	//**********************
	aAux := FwStruTrigger('ZB8_IMPORT' ,;
	'ZB8_IMPORT' ,;
	'U_GENSE24("ZB8_IMPORT", M->ZB8_IMPORT)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	//**********************
	// ZB8_IMLOJA
	//**********************
	aAux := FwStruTrigger('ZB8_IMLOJA' ,;
	'ZB8_IMLOJA' ,;
	'U_GENSE24("ZB8_IMLOJA", M->ZB8_IMLOJA)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	//**********************
	// ZB8_ZTPROD
	//**********************
	aAux := FwStruTrigger('ZB8_ZTPROD' ,;
	'ZB8_ZTPROD' ,;
	'U_GENSE24("ZB8_ZTPROD", M->ZB8_ZTPROD)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho


	//**********************
	// ZB8_ZCODES
	//**********************
	aAux := FwStruTrigger('ZB8_ZCODES' ,;
	'ZB8_ZCODES' ,;
	'U_GENSE24("ZB8_ZCODES", M->ZB8_ZCODES)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	aAux := FwStruTrigger('ZB9_COD_I' ,;
	'ZB9_COD_I' ,;
	'U_GENSE24("ZB9_COD_I", M->ZB9_COD_I)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB9:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	aAux := FwStruTrigger('ZB9_FPCOD' ,;
	'ZB9_FPCOD' ,;
	'U_GENSE24("ZB9_FPCOD", M->ZB9_FPCOD)',;
	.F.,;
	'',;
	0,;
	'')

	oStruZB9:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	//*************************************************************************************
	// FIM - GATILHO GENSET
	//*************************************************************************************

   // Gatilho para Validação do Inland
	aAux := FwStruTrigger(			 	 ;
	'ZB8_INLAND' 		,;
	'ZB8_INLAND' 		,;
	'U_fxValInl(1)'		,;
	.F.					,;
	''					,;
	0					,;
	'')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) 	// [04] Bloco de código de execução do gatilho

	aAux := FwStruTrigger(			 	 ;
	'ZB8_INLAND' 		,;
	'ZB8_INLADS' 		,;
	'ZFL->ZFL_DESCRI'	,;
	.T.					,;
	'ZFL'				,;
	1					,;
	'xFilial("ZFL") + M->ZB8_INLAND')

	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) 	// [04] Bloco de código de execução do gatilho

	//Gatilho para As Filiais
	aAux := FwStruTrigger(			 	 ;
	'ZB8_FILVEN' 	,;
	'ZB8_FILVEN' 	,;
	'U_xM25GFil()'	,;
	.F.				,;
	''				,;
	0				,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) 	// [04] Bloco de código de execução do gatilho

//Roberto-----------------------------------------------------------------
	//Gatilho para As Filiais DESTINO ORIGEM
		aAux := FwStruTrigger( ;
		'ZB8_FILVEN' 	,;
		'ZB8_ORIGEM' 	,;
		'U_Deparax5()'  ,;
		.F.				,;
		''				,;
		0				,;
		'u_mgfcpcp24().AND. ZB8_VIA =="03" ')
		oStruZB8:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
		aAux[2] , ; // [02] identificador (ID) do campo de destino
		aAux[3] , ; // [03] Bloco de c?digo de valida??o da execu??o do gatilho
		aAux[4] ) 	// [04] Bloco de c?digo de execu??o do gatilho
//EOF---------------------------------------------------------------------

	aAux := FwStruTrigger('ZB8_FORN' ,;
	'ZB8_FORN' ,;
	'U_M25Forn()',;
	.F.,;
	'',;
	0,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho
	aAux := FwStruTrigger('ZB8_FOLOJA' ,;
	'ZB8_FOLOJA' ,;
	'U_M25Forn()',;
	.F.,;
	'',;
	0,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	aAux := FwStruTrigger('ZB8_FABR' ,;
	'ZB8_FABR' ,;
	'U_M25Forn()',;
	.F.,;
	'',;
	0,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho
	aAux := FwStruTrigger('ZB8_FALOJA' ,;
	'ZB8_FALOJA' ,;
	'U_M25Forn()',;
	.F.,;
	'',;
	0,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) // [04] Bloco de código de execução do gatilho

	//*************************************************************************************
	// Gatilho valor do frete - WVN
	//*************************************************************************************
	aAux := FwStruTrigger(			 	 ;
	'ZB8_FRREAL' 		,;
	'ZB8_FRPREV' 		,;
	'U_fValFrete()'		,;
	.F.					,;
	''					,;
	0					,;
	'')
	oStruZB8:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de código de validação da execução do gatilho
	aAux[4] ) 	// [04] Bloco de código de execução do gatilho
	//*************************************************************************************

	FWMemoVirtual( oStruZB8,{ { 'ZB8_CODMEM' , 'ZB8_OBS' }, {'ZB8_CODOBP','ZB8_OBSPED'} , {'ZB8_DSCGEN','ZB8_GENERI'} } )

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XMGFEEC24', /*bPreValidacao*/, /*bPosValidacao*/{|oModel|xVldMdl(oModel)}, {|oModel|xCommit(oModel)}/*bCommit*/, /*bCancel*/)

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields('ZB8MASTER', /*cOwner*/, oStruZB8, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	oModel:AddGrid("ZB9DETAIL","ZB8MASTER",oStruZB9, {|oMdlGrid,nLin,cOper,cField,cNewValue,cOldValue|xPVldLin(oMdlGrid,nLin,cOper,cField,cNewValue,cOldValue)}/*bLinePreValid*/,/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/)
	oModel:SetRelation("ZB9DETAIL",{ {"ZB9_FILIAL","xFilial('ZB9')"},{"ZB9_EXP", "ZB8_EXP"}, {"ZB9_ANOEXP","ZB8_ANOEXP"} , {"ZB9_SUBEXP","ZB8_SUBEXP"} },ZB9->(IndexKey(2)))

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZB8MASTER' ):SetDescription( 'EXP' )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"ZB8_FILIAL","ZB8_EXP"})

	oModel:AddCalc("EEC24CALC", "ZB8MASTER", "ZB9DETAIL", "ZB9_PRCINC", "ZB9__TOTSD", "COUNT", {||.T.}, ,"Total Itens")
	oModel:AddCalc("EEC24CALC", "ZB8MASTER", "ZB9DETAIL", "ZB9_SLDINI", "ZB9__TOTFQ", "SUM", {||.T.}, ,"Total Quant.")
	oModel:AddCalc("EEC24CALC", "ZB8MASTER", "ZB9DETAIL", "ZB9_PRCINC", "ZB9__TOTFS", "FORMULA", {||.T.},,"Total Exp",{|oModel| U_MGF24TRG(oModel,.f.) })

	oModel:SetVldActivate({|oModel|xVldAcivate(oModel)})
	oModel:SetActivate({|oModel|xActiv(oModel)})

return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 17/04/2017
Descrição / Objetivo: ViewDef Montagem
=====================================================================================
*/
Static function ViewDef()

	Local oModel := FwLoadModel('MGFEEC24')
	Local oView := nil
	Local oStrZB8 	:= FWFormStruct( 2, "ZB8" )
	Local oStrZB9 	:= FWFormStruct( 2, "ZB9" )
	Local oCalc1	:= oCalc1 := FWCalcStruct( oModel:GetModel( 'EEC24CALC') )

	Local ni		:= 0
	Local nPos		:= 5

	Local aFldZB8 := oStrZB8:GetFields()
	Local cFld	  := ""
	Local cFlsPos := "01"

	oStrZB8:SetProperty( 'ZB8_EXP' 	  , MVC_VIEW_ORDEM,'001')
	oStrZB8:SetProperty( 'ZB8_ANOEXP' , MVC_VIEW_ORDEM,'002')
	oStrZB8:SetProperty( 'ZB8_SUBEXP' , MVC_VIEW_ORDEM,'003')
	oStrZB8:SetProperty( 'ZB8_ORCAME' , MVC_VIEW_ORDEM,'004')

	For ni := 1 To Len(aFldZB8)
		cFld := AllTrim(aFldZB8[ni,1])
		If !(cFld $ "ZB8_EXP|ZB8_ANOEXP|ZB8_SUBEXP|ZB8_ORCAME" )
			cFlsPos := StrZero(nPos,3)
			oStrZB8:SetProperty( cFld , MVC_VIEW_ORDEM , cFlsPos )
			nPos++
		EndIf
	Next ni

	oStrZB9:RemoveField("ZB9_EXP")
	oStrZB9:RemoveField("ZB9_ANOEXP")
	oStrZB9:RemoveField("ZB9_SUBEXP")
	oStrZB9:RemoveField("ZB9_ORCAME")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZB8' , oStrZB8, 'ZB8MASTER' )
	oView:AddGrid( 'VIEW_ZB9' , oStrZB9, 'ZB9DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'EEC24CALC' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 40 )
	oView:CreateHorizontalBox( 'INFERIOR' , 50 )
	oView:CreateHorizontalBox( 'CALC' , 10 )

	oView:SetOwnerView( 'VIEW_ZB8', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZB9', 'INFERIOR' )
	oView:SetOwnerView( 'VIEW_CALC', 'CALC' )

	oView:AddIncrementField( 'VIEW_ZB9', 'ZB9_SEQUEN' )
	oView:SetViewAction( 'BUTTONOK' ,{ |oView| U_fEnvExpT( oView ) } )

return oView

/*
=====================================================================================
Programa............: xM24100C
Autor...............: Joni Lima
Data................: 17/04/2017
Descrição / Objetivo: Validações dos campos Em Geral
=====================================================================================
*/
User function xM24100C(cCampo,lMENSA,lOK)

	Local lRet:=.T.,cOldArea:=select(),cSK:="",cMenserr:="",cCOMPERR , nVar := 0 , cSeek:="", nRec:=0, nTaxa1 , nTaxa2
	Local nOrdSY9,nTotal := 0, i,;
		bTotal := {|| nTotal += If(lConvUnid,;
		(AvTransUnid(WorkIt->EE8_UNIDAD,WorkIt->EE8_UNPRC,WorkIt->EE8_COD_I,WorkIt->EE8_SLDINI,.F.)*;
		WorkIt->EE8_PRECO),WorkIt->(EE8_SLDINI*EE8_PRECO))}

	Local aORD:=SAVEORD({"SY9","SY6","EE9"}), lAux,  cTipmen:="",nFob:=0
	Local nA,nB,nC,nD, lAtuStatus := .t.
	Local cFil, cFilEx, cFilBr, aUnid
	Local cMsg, nSaldo, nTotalAEmb, nSldLC, nSldLCReais, cPreemb, aProdutos, lControlaPeso
	Local nPos := 0
	Local aAreaSYR := SYR->(GetArea())

	Local nTaxaSeguro := GetMv("MV_AVG0124",,10)
	Local aOrdEXJ := SaveOrd("EXJ") //MCF - 11/05/2015
	Default lMENSA:=.T.,lOK:=.F.

	Begin Sequence

		//DFS - 05/10/12 - Verifica o tipo da variavel
		If Type("lFaturado") <> "L"
			lFaturado := .F.
		EndIf

		Do Case

		Case cCampo = "ZB9_FABR"

			If !Empty(M->ZB9_FABR)
				SA2->(dbSetOrder(1))
				lAux := SA2->(dbSeek(xFilial("SA2")+M->ZB9_FABR+M->ZB9_FALOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA2",M->ZB9_FABR+IF(lAux,M->ZB9_FALOJA,""))

				If lRet
					M->ZB9_FALOJA := SA2->A2_LOJA
				EndIf
			EndIf

		Case cCampo = "ZB9_FORN"

			SA2->(dbSetOrder(1))
			lAux := SA2->(dbSeek(xFilial("SA2")+M->ZB9_FORN+M->ZB9_FOLOJA))

			// Verifica se o fornecedor esta cadastrado ...
			lRet := ExistCpo("SA2",M->ZB9_FORN+IF(lAux,M->ZB9_FOLOJA,""))

			If lRet
				M->ZB9_FOLOJA := SA2->A2_LOJA
			EndIf

		Case cCampo == "ZB8_CONDPA"   //RMD - 06/09/05 - Impede que seja incluido um pedido com uma condição de pag. inexistente
			If !ExistCpo("SY6",M->ZB8_CONDPA)
				lRet := .F.
				Break
			EndIf

		Case cCampo = "ZB8_FORN"
			SA2->(dbSetOrder(1))

			// NCF - 28/04/2014 - Tratamento para forçar a carga da variáel de memória do campo EE7_FOLOJA uma vez detectado que a rotina automática Enchauto não
			// está gatilhando a variável quando executado a executo a partir do adapter(EECAP100) de integração com o ERP Logix.
			If AVFLAGS("EEC_LOGIX") .And. Type("lEE7Auto") <> "U" .And. lEE7Auto
				If (nPosFornLj := aScan( aAutoCab, {|x| x[1] == "ZB8_FOLOJA"} ) ) > 0 .And. ValType(M->ZB8_FOLOJA) <> NIL .And. aAutocab[nPosFornLj][2] <> M->ZB8_FOLOJA
					M->ZB8_FOLOJA := aAutocab[nPosFornLj][2]
				EndIf
			EndIf

			lAux := SA2->(dbSeek(xFilial("SA2")+M->ZB8_FORN+M->ZB8_FOLOJA))

			// Verifica se o fornecedor esta cadastrado ...
			lRet := ExistCpo("SA2",M->ZB8_FORN+IF(lAux,M->ZB8_FOLOJA,""))

			If lRet
				M->ZB8_FOLOJA := SA2->A2_LOJA
			EndIf

		CASE cCAMPO $ "ZB8_VIA/ZB8_ORIGEM/ZB8_DEST/ZB8_TIPTRA"

			If ReadVar() == "M->ZB8_VIA" .OR. (Type("lGatVia") # "U" .AND. lGatVia)   // GFP - 27/05/2014
				nVar  := 1
				If SYR->YR_ORIGEM == M->ZB8_ORIGEM .AND. SYR->YR_VIA == M->ZB8_VIA .AND. SYR->YR_DESTINO == M->ZB8_DEST
					cSeek := M->ZB8_VIA+SYR->YR_ORIGEM+SYR->YR_DESTINO
				Else
					cSeek := M->ZB8_VIA
				EndIf	
			ElseIf ReadVar() == "M->ZB8_ORIGEM"
				nVar  := 2
				If SYR->YR_ORIGEM == M->ZB8_ORIGEM .AND. SYR->YR_VIA == M->ZB8_VIA .AND. SYR->YR_DESTINO == M->ZB8_DEST
					cSeek := M->ZB8_VIA+M->ZB8_ORIGEM+M->ZB8_DEST
				Else
					cSeek := M->ZB8_VIA+M->ZB8_ORIGEM
				EndIf
			ElseIf ReadVar() == "M->ZB8_DEST"
				nVar  := 3
				cSeek := M->ZB8_VIA+M->ZB8_ORIGEM+M->ZB8_DEST
			Else
				nVar  := 4
				cSeek := M->ZB8_VIA+M->ZB8_ORIGEM+M->ZB8_DEST+M->ZB8_TIPTRA
			EndIf
			If SYR->YR_VIA <> M->ZB8_VIA .OR. SYR->YR_ORIGEM <> M->ZB8_ORIGEM
				M->ZB8_ORIGEM := ""
			EndIf
			If SYR->YR_VIA <> M->ZB8_VIA .OR.  SYR->YR_DESTINO <> M->ZB8_DEST
				If !M->ZB8_VIA $ '01|02|03|' //18/02/2020
					M->ZB8_DEST := ""
				EndIf
			EndIf
			lREFRESH:=.T.

			Case cCampo == "ZB8_IMLOJA"
			EE9->(DbSetOrder(1))

			If !Empty(M->ZB8_IMPORT) .AND. !Empty(M->ZB8_IMLOJA)  // GFP - 27/05/2014
				cDestino := ""
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+M->ZB8_IMPORT+M->ZB8_IMLOJA))
					Do Case
					Case !Empty(SA1->A1_DEST_1)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_1,"YR_VIA")
					Case !Empty(SA1->A1_DEST_2)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_2,"YR_VIA")
					Case !Empty(SA1->A1_DEST_3)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_3,"YR_VIA")
					End Case
				EndIf
				If !Empty(cDestino) .And. Empty(M->ZB8_VIA) //MCF - 11/05/2015
					M->ZB8_VIA := AllTrim(cDestino)
					lGatVia := .T.
					u_xM24100C("ZB8_VIA")
					lGatVia := .F.
				EndIf
			EndIf

		Case cCampo = "ZB8_IMPORT"

			SA1->(dbSetOrder(1))
			lAux := SA1->(dbSeek(xFilial("SA1")+M->ZB8_IMPORT+M->ZB8_IMLOJA))

			// Verifica se o importador esta cadastrado ...
			lRet := ExistCpo("SA1",M->ZB8_IMPORT+IF(lAux,M->ZB8_IMLOJA,""))

			If lRet
				M->ZB8_IMLOJA := SA1->A1_LOJA // MCF - 30/10/2015
				M->ZB8_IMPODE := SA1->A1_NOME // GFP - 07/02/2014
			EndIf

			If lRET .AND. !Empty(SA1->A1_CONDPAG) .AND. ! lOK
				M->ZB8_CONDPA := SA1->A1_CONDPAG
				M->ZB8_DIASPA := SA1->A1_DIASPAG
				SY6->(DBSETORDER(1))
				SY6->(DBSEEK(XFILIAL("SY6")+M->EE7_CONDPA+STR(M->EE7_DIASPA,AVSX3("EE7_DIASPA",AV_TAMANHO),0)))
				M->ZB8_DESCPA := MSMM(SY6->Y6_DESC_P,50,1)
			EndIf

			If !Empty(M->ZB8_IMPORT) .AND. !Empty(M->ZB8_IMLOJA)  // GFP - 27/05/2014
				cVia := ""
			EndIf

		Case cCampo == "EE7_PEDIDO"
			If M->EE7_STATUS <> ST_RV .And. Left(AllTrim(M->EE7_PEDIDO), 1) == "*"
				MsgInfo("O No. do Pedido não pode conter *, como simbolo inicial. Definição reservada para Pedido especial com R.V. sem vinculação.", "Itens") //
				lRet := .F.
			EndIf

		Case cCampo == "EE7_DTPEDI"
			If M->EE7_DTPEDI > M->EE7_DTPROC
				Help(" ",1,"AVG0000083")
				lRet := .F.
			EndIf

		Case cCampo =="EE7_DTSLCR"
			If !Empty(M->EE7_DTSLCR) .AND. M->EE7_DTSLCR < M->EE7_DTPEDI
				HELP(" ",1,"AVG0000068")
				lRET:=.F.
			ELSEIf Empty(M->EE7_DTSLCR)
				If M->EE7_STATUS <> ST_RV
					M->EE7_STATUS:=ST_SC
					//atualizar descricao de status
					DSCSITEE7()
				EndIf
			EndIf

		Case cCampo =="EE7_DTSLAP"
			If !Empty(M->EE7_DTSLAP)
				If M->EE7_DTSLAP < M->EE7_DTPEDI
					MsgAlert("Data de Solicitação de Aprovação da Proforma não pode ser menor que a data de sua emissão!","AVISO")//HELP(" ",1,"AVG0000068")
					lRET:=.F.
				Else
					M->EE7_STATUS:= ST_AP ////Aguardando Aprovação da Proforma
				EndIf
			ELSEIf Empty(M->EE7_DTSLAP)
				M->EE7_STATUS:= ST_PB
			EndIf
			//atualizar descricao de status
			DSCSITEE7()

		Case cCampo =="EE7_DTAPPE"
			//atualizar status e validar se dt. aprv. proforma >=dt Pedido
			If Empty(M->EE7_DTAPPE)
				//If M->EE7_STATUS <> ST_CL //wfs - a aprovação do crédito ocorrerá no ERP
				If ( !Empty(M->EE7_DTSLAP) )
					M->EE7_STATUS:= ST_AP ////Aguardando Aprovação da Proforma
				ELSE
					M->EE7_STATUS:= ST_PB //Proforma em Edição //ST_CL
				EndIf
				DSCSITEE7()
				//EndIf
			ELSEIf M->EE7_DTAPPE < M->EE7_DTSLAP
				MsgAlert("Data de Aprovação da Proforma não pode ser menor que a data de Solicitação da Aprovação!","AVISO")//HELP(" ",1,"AVG0000069")
				lRET:=.F.
			ElseIf M->EE7_TOTITE==0
				HELP(" ",1,"AVG0000070")
				lRET:=.F.
			ElseIf M->EE7_DTAPPE < M->EE7_DTPEDI
				MsgAlert('Data de aprovação da Proforma não pode ser menor que a data de sua emissão!','AVISO')
				lRET := .F.
			ElseIf Empty(M->EE7_DTSLAP) .And. lAPROVAPF
				MsgAlert('Nao e possivel aprovar a Proforma uma vez que a data de solicitacao de aprovacao nao foi informada!','AVISO')
				lRET := .F.
			Else

				If !Inclui
					aOrdEE9 := SaveOrd("EE9",1)
					lAtuStatus := ! EE9->(dbSeek(xFilial()+M->EE7_PEDIDO))
					RestOrd(aOrdEE9,.T.)
				EndIf

				If M->EE7_STATUS == ST_PA
					lAtuStatus := .f.
				EndIf

				If lAtuStatus
					M->EE7_STATUS := ST_PA
				EndIf
				//atualizar descricao de status
				DSCSITEE7()
			EndIf

		CASE cCAMPO = "EE7_GPV"
			If M->EE7_GPV $ cNAO
				lREFRESH      := .T.
				If M->EE7_STATUS <> ST_RV
					M->EE7_STATUS := ST_SC //LRS 29/11/2013 - Trocado o Status para "aguardando solicitacao de credito"
					DSCSITEE7() //atualizar descricao de status
				EndIf
			EndIf
		CASE cCAMPO == "EE7_AMOSTR"

			If !lLibCredAuto
				cOpcao := AP102CboxAmo("M->EE7_AMOSTR")  // GFP - 03/11/2015
				If (cOpcao == "2")  // GFP - 03/11/2015
					If M->EE7_STATUS <> ST_RV
						If lIntegra
							M->EE7_STATUS:= ST_AF
						Else
							M->EE7_STATUS:=ST_CL
						EndIf
					EndIf
				EndIf
				If (cOpcao <> "2")  // GFP - 03/11/2015
					lREFRESH:=.T.
					M->EE7_DTSLCR:=M->EE7_DTPROC
					M->EE7_DTAPCR:=M->EE7_DTPROC

					// ** By JBJ - 28/08/01 - 10:59
					If M->EE7_STATUS <> ST_RV
						If (cOpcao == "4") .AND. lIntegra  // GFP - 03/11/2015
							M->EE7_STATUS:= ST_AF
						Else
							M->EE7_STATUS:=ST_CL
						EndIf
					EndIf
					// **

					//atualizar descricao de status
					DSCSITEE7()

				ELSEIf (nSelecao = 3) .or. (lALTERA .AND. !lAPROVA .AND. Empty(M->EE7_DTAPCR)) .or. (lALTERA .AND. !lAPROVAPF .AND. If(lIntPrePed,Empty(M->EE7_DTAPPE),.T.) )
					lREFRESH:=.T.

					If !lOk //Não limpa quando for gravação.
						M->EE7_DTSLCR := CriaVar("EE7_DTSLCR")
						M->EE7_DTAPCR := CriaVar("EE7_DTAPCR")
						If lIntPrePed
							M->EE7_DTSLAP := CriaVar("EE7_DTSLAP")
							M->EE7_DTAPPE := CriaVar("EE7_DTAPPE")
						EndIf
					EndIf

					// ** By JBJ - 28/08/01 - 11:13
					If M->EE7_STATUS <> ST_RV .AND. EE7->EE7_STATUS < ST_AE    // GFP - 24/10/2014
						If lIntegra .And. !lFaturado
							M->EE7_STATUS:=ST_AF
						ElseIf lFaturado //DFS - 08/11/10 - Inclusão de Status Faturado.
							M->EE7_STATUS:=ST_FA
						Else
							If Empty(M->EE7_DTSLCR)
								M->EE7_STATUS := ST_SC //Aguardando solicitacao de credito.
							Else
								M->EE7_STATUS := ST_LC //Aguardando liberacao de credito.
							EndIf
						EndIf
					EndIf
				EndIf
				// **

				//atualizar descricao de status
				DSCSITEE7()
			EndIf
		Case cCampo == "EE7_FRPREV"  //necessario lancar frete
			If Type("lEE7Auto") == "L" .And. !lEE7Auto
				SYJ->(DBSETORDER(1))
				SYJ->(DBSEEK(XFILIAL("SYJ")+M->EE7_INCOTE))
				If SYJ->YJ_CLFRETE $ cSim .and. M->EE7_FRPREV==0
					If AVFLAGS("EEC_LOGIX_PREPED") //05/05/2014 - Não permite gravar seguro zerado se incoterm prever Seguro
						lRet:=.F.                   //             e integração para envio do pedido ao ERP LOGIX estiver ativa
					Else
						lRet:=.T.
					EndIf
					HELP(" ",1,"AVG0000066",,"FRETE",2,1)
				ElseIf SYJ->YJ_CLFRETE $ cNao .AND. M->EE7_FRPREV#0
					lRet:=.F.
					M->EE7_FRPREV:=0
					HELP(" ",1,"AVG0000067",,"FRETE",2,1)
				EndIf
			Else
				lRet := .T.
			EndIf			
		Case cCampo == "ZB8_SEGPRE" .OR. cCampo == "ZB8_SEGURO"
			SYJ->(dbSetOrder(1))
			SYJ->(dbSeek(XFILIAL("SYJ")+M->ZB8_INCOTE))

			//ER - Utilização de Parametro para Calcular taxa de Seguro
			nTaxaSeguro := 1 + (nTaxaSeguro / 100)

			If cCampo == "ZB8_SEGURO"
				If ( M->ZB8_SEGURO#0 )
					If M->ZB8_PRECOA $ cSim

						If ZB8->(FieldPos("ZB8_DESSEG")) > 0 .And. M->ZB8_DESSEG == "1" //LRS - 11/09/2015
							nA := nTOTAL + M->ZB8_FRPREV - M->ZB8_DESCON
						Else
							nA := nTOTAL+M->ZB8_FRPREV
						EndIf

						nB := (M->ZB8_SEGURO/100) * nTaxaSeguro
						nC := 1 - nB
						nD := nA / nC

						If GetMv("MV_AVG0183", .F., .F.) //habilita o cálculo direto do seguro previsto (total x percentual do seguro)
							//WFS 28/07/2009 - Alterado como melhoria, conforme chamado 077797.
							M->ZB8_SEGPRE := ROUND(nA * nB,AVSX3("ZB8_SEGPRE",AV_DECIMAL))
						Else
							M->ZB8_SEGPRE := ROUND(nD-nA,AVSX3("ZB8_SEGPRE",AV_DECIMAL))
						EndIf
					Else
						M->ZB8_SEGPRE := ROUND(M->ZB8_TOTPED*nTaxaSeguro*(M->ZB8_SEGURO/100),AVSX3("ZB8_SEGPRE",AV_DECIMAL))
					EndIf
				Else
					If lMENSA .And. M->ZB8_TIPSEG == "1"
						M->ZB8_SEGPRE := 0
					EndIf

				EndIf
			ElseIf cCampo == "ZB8_SEGPRE"
				If lMensa .And. !lOk
					M->ZB8_SEGURO := 0
				EndIf
			EndIf

			If Type("lEE7Auto") == "L" .And. !lEE7Auto
				If SYJ->YJ_CLSEGUR $ cSim .and. (M->ZB8_SEGPRE==0.AND.M->ZB8_SEGURO==0)
					If AVFLAGS("EEC_LOGIX_PREPED") //05/05/2014 - Não permite gravar seguro zerado se incoterm prever Seguro
						lRet:=.F.                   //             e integração para envio do pedido ao ERP LOGIX estiver ativa
					Else
						lRet:=.T.
					EndIf
					If ( lMENSA )
						HELP(" ",1,"AVG0000066",,"SEGURO",2,1)
					EndIf
				ElseIf SYJ->YJ_CLSEGUR $ cNao .AND. (M->ZB8_SEGPRE#0.OR.M->ZB8_SEGURO#0)
					lRet:=.F.
					M->ZB8_SEGPRE:=0
					M->ZB8_SEGURO:=0
					If ( lMENSA )
						HELP(" ",1,"AVG0000067",,"SEGURO",2,1)
					EndIf
				EndIf
			Else
				lRet := .T.
			EndIf

		Case cCampo = "EE7_BENEF"
			If !Empty(M->EE7_BENEF)
				SA2->(dbSetOrder(1))
				lAux := SA2->(dbSeek(xFilial("SA2")+M->EE7_BENEF+M->EE7_BELOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA2",M->EE7_BENEF+IF(lAux,M->EE7_BELOJA,""))

				If lRet
					M->EE7_BELOJA := SA2->A2_LOJA
				EndIf
			EndIf

		Case cCampo = "EE7_CLIENT"
			If !Empty(M->EE7_CLIENT)
				SA1->(dbSetOrder(1))
				lAux := SA1->(dbSeek(xFilial("SA1")+M->EE7_CLIENT+M->EE7_CLLOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA1",M->EE7_CLIENT+IF(lAux,M->EE7_CLLOJA,""))

				If lRet
					M->EE7_CLLOJA := SA1->A1_LOJA
				EndIf
			Else
				If lIntermed
					/* by jbj - 24/06/04 17:44 - Com a rotina de off-shore ativa o cliente
					passa a ser obrigatório na filial do Brasil */
					If (M->EE7_INTERM $ cSim) .And.	(xFilial("EE7") == cFilBr)
							If Empty(M->EE7_CLIENT)
							MsgInfo("O campo '"+AvSx3("EE7_CLIENT",AV_TITULO)+"' na pasta '"+AvSx3("EE7_CLIENT",15)+"' deve ser "+ENTER+;
							"informado para processos com tratamentos de off-shore.","Atencao")
							lRet:=.f.
						EndIf
					Else
						lRet:=Vazio(M->EE7_CLIENT)
					EndIf
				Else
					lRet:=Vazio(M->EE7_CLIENT)
				EndIf
			EndIf

		Case cCampo = "EEN_IMPORT"
			If !Empty(M->EEN_IMPORT)
				// ** JPM 03/11/04 - alterações na validação de notifys
				// Verifica se o Notify esta cadastrado ...
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+M->EEN_IMPORT+IF(!Empty(M->EEN_IMLOJA),M->EEN_IMLOJA,"")))
					If !(SA1->A1_TIPCLI $ "3/4")
						MsgStop("O código informado não corresponde a um cliente do tipo " + BSCXBOX("A1_TIPCLI","3") + ".","Aviso" )// //
						lRet := .f.
					Else
						M->EEN_IMLOJA := SA1->A1_LOJA
					EndIf
				Else
					MsgStop("Notify não Cadastrado.","Aviso")// //
					lRet:=.f.
				EndIf
			EndIf

		Case cCampo = "EE7_MOTSIT"
			If !Empty(M->EE7_MOTSIT)
				// Verifica se a descrição esta cadastrada ...
				lRet := ExistCpo("EE4",M->EE7_MOTSIT)

				cTipmen := Posicione("EE4",1,xFilial("EE4")+M->EE7_MOTSIT,"EE4_TIPMEN")
				If lRet .And. (Val(SubStr(cTipmen,1,1))#1)
					Help(" ",1,"AVG0005072")// O item selecionado não é uma descrição valida
					lRet:= .F.
				EndIf
			EndIf
		Case cCampo = "EE8_PRECO"
			// ** By JBJ - 27/06/02 - 10:35 ...
			If !lCommodity
				lRet:=NaoVazio(M->EE8_PRECO)
			EndIf
			//RMD - 31/08/05
			If GetMv( "MV_EECFAT",,.F.) .And. AVSX3("EE8_PRECO",AV_DECIMAL) > AVSX3("C6_PRCVEN",AV_DECIMAL)
				cPreco := STR(M->EE8_PRECO,,AVSX3("EE8_PRECO",AV_DECIMAL))
				nDecimais := AVSX3("EE8_PRECO",AV_DECIMAL) - AVSX3("C6_PRCVEN",AV_DECIMAL)

				For i := 1 to nDecimais
					If !(SUBSTR(cPreco,-i,1) $ "0")
						lRet := .F.
						Exit
					EndIf
				Next
			EndIf

			If GetMv("MV_EECFAT",.F.,.F.) .And. nOpcI <> INC_DET
				If WorkIt->EE8_PRECO <> M->EE8_PRECO
					If IsFaturado(WorkIt->EE8_PEDIDO,WorkIt->EE8_SEQUEN)
						MsgInfo("Esse item possui NFs geradas no Faturamento. Para alterar o Preço Unitário estorne a NF","Atenção")//
						lRet := .F.
						Break
					EndIf
				EndIf
			EndIf

		Case cCampo=="EE7_TIPCOM"  //informar tipo de comissao
			If ! lOk
				If (Empty(M->EE7_TIPCOM) .AND. !Empty(M->EE7_TIPCVL) .AND. !Empty(M->EE7_VALCOM)) .OR. ;
						(Empty(M->EE7_TIPCOM) .AND. Empty(M->EE7_TIPCVL) .AND. !Empty(M->EE7_VALCOM)) .OR. ;
						(Empty(M->EE7_TIPCOM) .AND. !Empty(M->EE7_TIPCVL) .AND. Empty(M->EE7_VALCOM))
					lRet:=.F.
					HELP(" ",1,"AVG0000036")
				EndIf
			EndIf
		Case cCAMPO=="EE7_TIPCVL"  //informar tipo de valor de comissao
			If !lOk
				If (!Empty(M->EE7_TIPCOM) .AND. Empty(M->EE7_TIPCVL) .AND. !Empty(M->EE7_VALCOM)) .OR. ;
						(Empty(M->EE7_TIPCOM)  .AND. Empty(M->EE7_TIPCVL) .AND. !Empty(M->EE7_VALCOM)) .OR. ;
						(!Empty(M->EE7_TIPCOM) .AND. Empty(M->EE7_TIPCVL) .AND. Empty(M->EE7_VALCOM))
					lRet:=.F.
					HELP(" ",1,"AVG0000060")
				EndIf
			EndIf

			If M->EE7_TIPCVL = "3" .And. EE8->(FieldPos("EE8_PERCOM")) = 0
				MsgInfo("Opcao invalida. O campo EE8_PERCOM não existe na base !","Aviso") //
				lRet:=.f.
			EndIf

		Case cCAMPO=="EE7_VALCOM"  //informar comissao
			If (!Empty(M->EE7_TIPCOM) .AND. !Empty(M->EE7_TIPCVL) .AND. Empty(M->EE7_VALCOM)) .OR. ;
					(!Empty(M->EE7_TIPCOM) .AND. Empty(M->EE7_TIPCVL) .AND. Empty(M->EE7_VALCOM)) .OR. ;
					(Empty(M->EE7_TIPCOM) .AND. !Empty(M->EE7_TIPCVL) .AND. Empty(M->EE7_VALCOM))
				WorkAg->(dbGoTop())
				lRet:=.T.
				While !WorkAg->(Eof())
					If LEFT(WorkAg->EEB_TIPOAG,1)==CD_AGC  //agente a receber comissao
						lRet:=.F.
						Exit
					EndIf
					WorkAg->(DBSKIP(1))
				EndDo
				If !lRet
					HELP(" ",1,"AVG0000077")
				EndIf
			EndIf

			// ** By JBJ - 03/04/02 11:14
			If M->EE7_TIPCVL = "1"
				If M->EE7_VALCOM > 99.99
					MsgInfo("A porcentagem de comissão deve ser inferior a 100 %","Aviso") //
					Return .f.
				EndIf
			ElseIf M->EE7_TIPCVL = "2"
				nFob := (M->EE7_TOTPED+M->EE7_DESCON)-(M->EE7_FRPREV+M->EE7_FRPCOM+M->EE7_SEGPRE+;
					M->EE7_DESPIN+AvGetCpo("M->EE7_DESP1")+;
					AvGetCpo("M->EE7_DESP2"))
				If nFob > 0
					If M->EE7_VALCOM >= nFob
						MsgInfo("O valor da comissão deve ser inferior ao valor FOB.","Aviso")  //
						Return .f.
					EndIf
				EndIf
			EndIf
		Case cCAMPO=="EE7_LC_NUM"

			EEL->(DbSetOrder(1))

			If EEL->(DbSeek(xFilial("EEL")+M->EE7_LC_NUM)) .And. EECFlags("ITENS_LC")
				If Posicione("EE7",1,M->(EE7_FILIAL+EE7_PEDIDO),"EE7_LC_NUM") <> M->EE7_LC_NUM .And. EEL->EEL_FINALI $ cSim // Se a L/C estiver finalizada, não pode ser utilizada
					MsgStop("Esta Carta de Crédito já está finalizada. Sendo assim, não poderá ser utilizada.","Aviso") //
					lRet := .f.
					Break
				EndIf
			EndIf

			If lNRotinaLC .And. !EECFlags("ITENS_LC")// JPM - 28/12/04 - Nova Rotina de Carta de Crédito

				nRec := EE7->(RecNo())

				If !Empty(M->EE7_LC_NUM) .And. lRet

					EE9->(DbSetOrder(1))
					EEC->(DbSetOrder(1))
					nSaldo := 0
					nTotalAEmb := 0

					nRec2 := WorkIt->(RecNo())
					WorkIt->(DbGoTop())
					While WorkIt->(!EoF())
						nSaldo  := WorkIt->EE8_SLDATU
						cPreemb := ""
						If EE9->(dbSeek(xFilial("EE9")+M->EE7_PEDIDO+WorkIt->EE8_SEQUEN))
							While EE9->(!Eof()) .And. EE9->EE9_FILIAL == xFilial("EE9") .And.;
							EE9->EE9_PEDIDO == M->EE7_PEDIDO .And.;
							EE9->EE9_SEQUEN == WorkIt->EE8_SEQUEN
									If EE9->EE9_PREEMB <> cPreemb
									EEC->(DbSeek(xFilial("EEC")+EE9->EE9_PREEMB))
									cPreemb := EE9->EE9_PREEMB
								EndIf
								If Empty(EEC->EEC_DTEMBA) .And. If(lMultiOffShore,Empty(EEC->EEC_NIOFFS),.t.)
									nSaldo += EE9->EE9_SLDINI
								EndIf
								EE9->(DbSkip())
							EndDo
						EndIf

						If lConvUnid
							nTotalAEmb += AvTransUnid(WorkIt->EE8_UNIDAD, WorkIt->EE8_UNPRC,WorkIt->EE8_COD_I,;
							nSaldo,.F.)*WorkIt->(EE8_PRCUN-If(GetMv("MV_AVG0085",,.f.),EE8_VLDESC/EE8_SLDINI,0))
							WorkIt->(DbSkip())
						Else
							nTotalAEmb += nSaldo * WorkIt->(EE8_PRCUN-If(GetMv("MV_AVG0085",,.f.),EE8_VLDESC/EE8_SLDINI,0) )//Se o MV está ligado, o desconto não está sendo incluído no preço do item
							WorkIt->(DbSkip())
						EndIf
					EndDo
					WorkIt->(DbGoTo(nRec2))

					nTaxa1 := 1
					nTaxa2 := 1

					If EEL->EEL_MOEDA <> "R$ "
						nTaxa1 := BuscaTaxa(EEL->EEL_MOEDA,dDataBase)
					EndIf
					If M->EE7_MOEDA <> "R$ "
						nTaxa2 := BuscaTaxa(M->EE7_MOEDA,dDataBase)
					EndIf

					nSldLC := EEL->EEL_SLDEMB
					nSldLCReais := (EEL->EEL_SLDEMB * nTaxa1)
					lRet := (Round(nSldLCReais,2) >= Round(nTotalAEmb * nTaxa2,2))

					If !lRet
						//                     cMsg := STR0071+AllTrim(M->EE7_LC_NUM)+STR0072+AllTrim(M->EE7_MOEDA)+" "
						cMsg += AllTrim(Transf(nTotalAEmb,AvSx3("EE7_TOTPED",AV_PICTURE)))
						If M->EE7_MOEDA <> "R$ " .And. M->EE7_MOEDA <> EEL->EEL_MOEDA
							cMsg += " (R$ "+AllTrim(Transf(Round(nTotalAEmb * nTaxa2,2),;
							AvSx3("EE7_TOTPED",AV_PICTURE)))+")"
						EndIf
						//                     cMsg += STR0073+AllTrim(EEL->EEL_MOEDA)+" "
						cMsg += AllTrim(Transf(nSldLC,AvSx3("EEL_SLDEMB",AV_PICTURE)))
						If EEL->EEL_MOEDA <> "R$ " .And. M->EE7_MOEDA <> EEL->EEL_MOEDA
							cMsg += " (R$ " +AllTrim(Transf(Round(nSldLCReais,2),;
							AvSx3("EEL_SLDEMB",AV_PICTURE)))+")"
						EndIf
						cMsg += "."

						MsgStop(cMsg,"Aviso")
					EndIf

					EE7->(DbGoTo(nRec))

				EndIf

				If !lRet
					Break
				EndIf

			EndIf

			If !lOk .And. EECFlags("ITENS_LC")
				nRec := WorkIt->(RecNo())
				WorkIt->(DbGoTop())
				If !Ae107AtuIt()
					lRet := .f.
				EndIf

				WorkIt->(DbGoTo(nRec))
				oMsSelect:oBrowse:Refresh()
				If !lRet
					Break
				EndIf

			EndIf

		Case cCampo == "EE8_LC_NUM" // JPM - 15/07/05

			If !Empty(M->EE8_LC_NUM)
				If M->EE8_LC_NUM <> M->EE7_LC_NUM
					M->EE7_LC_NUM := CriaVar("EE7_LC_NUM")
				EndIf

				If Posicione("EEL",1,xFilial("EEL")+M->EE8_LC_NUM,"EEL_FINALI") $ cSim
					MsgStop("Esta Carta de Crédito já está finalizada. Sendo assim, não poderá ser utilizada.","Aviso") //
					lRet := .f.
					Break
				EndIf

				If EEL->EEL_CTPROD $ cNao //só valida se a L/C não controlar produtos. Se controla, esta validação é feita no preenchimento da sequência da L/C
					If !Ae107ValIt(OC_PE,If(nOPCI == INC_DET,WorkIt->(RecNo()),0) )
						lRet := .f.
						Break
					EndIf
				EndIf
			Else
				If !Empty(M->EE7_LC_NUM)
					M->EE7_LC_NUM := CriaVar("EE7_LC_NUM")
				EndIf
			EndIf

		Case cCAMPO == "EE8_SEQ_LC" // JPM - 19/07/05

			If !Empty(M->EE8_SEQ_LC)
				If Posicione("EXS",1,xFilial("EXS")+M->EE8_LC_NUM+M->EE8_SEQ_LC,"EXS_COD_I" ) <> M->EE8_COD_I
					MsgInfo("O Produto da Sequência de L/C informada não é igual ao Produto do item atual.","Aviso") //
					lRet := .f.
					Break
				EndIf

				If !Ae107ValIt(OC_PE,If(nOPCI == INC_DET,0,WorkIt->(RecNo())) )
					lRet := .f.
					Break
				EndIf
			EndIf

		CASE cCAMPO == "EE7_LICIMP"
			If ( M->EE7_EXLIMP $ cSim .AND. Empty(M->EE7_LICIMP))
				lRET:=.F.
				HELP(" ",1,"AVG0000073")
			EndIf
		CASE cCAMPO == "EE7_DTLIMP"
			If ( (M->EE7_EXLIMP $ cSim .OR. !Empty(M->EE7_LICIMP)).AND.Empty(M->EE7_DTLIMP) )
				lRET:=.F.
				HELP(" ",1,"AVG0000074")
			EndIf

		CASE cCAMPO == "EE7_CONSIG"
			// LCS - 19/09/2002 - TODA A CONSISTENCIA
			If ! Empty(M->EE7_CONSIG)
				If ! EXISTCPO("SA1",M->EE7_CONSIG+IF(!Empty(M->EE7_COLOJA),M->EE7_COLOJA,""))
					lRET := .F.
				ELSE
					SA1->(DBSETORDER(1))
					SA1->(DBSEEK(XFILIAL("SA1")+M->EE7_CONSIG+IF(!Empty(M->EE7_COLOJA),M->EE7_COLOJA,"")))
					If SA1->A1_TIPCLI # "2" .AND.;  // CONSIGNATARIO
						SA1->A1_TIPCLI # "4"         // TODOS
						*
						MSGINFO("Codigo invalido para Consignatario !","Atencao") //
						lRET := .F.
					EndIf
				EndIf
				If lRET
					AP100CRIT("EE7_MARCAC")
				EndIf
			EndIf
		Case cCampo == "EEB_TIPCVL"
			If lTratComis//JPM - 01/02/05 - Nova validação para não haver ag. de perc. p/ item e de Valor Fixo/Percentual no mesmo processo.
				nRec := WorkAg->(RecNo())
				WorkAg->(DbGoTop())
				While WorkAg->(!EoF())
					If M->EEB_TIPCVL = "3" // Comissão por item.
						If WorkAg->EEB_TIPCVL <> "3"
								MsgStop("Não podem haver agentes de percentual por item e agentes com outro tipo de valor de comissão em um mesmo processo.","Aviso")//
								lRet := .f.
						EndIf
					Else
						If WorkAg->EEB_TIPCVL = "3"
								MsgStop("Não podem haver agentes de percentual por item e agentes com outro tipo de valor de comissão em um mesmo processo.Já existe(m) agente(s) com o tipo do valor de comissão 'percentual por item'.","Aviso")//
								lRet := .f.
								M->EEB_VALCOM := 0 //MCF - 03/09/2015
						EndIf
					EndIf
					If !lRet
						WorkAg->(DbGoto(nRec))
						Break
					EndIf
					WorkAg->(DbSkip())
				EndDo
				WorkAg->(DbGoto(nRec))
			EndIf

			If M->EEB_TIPCVL = "3" // Comissão por item.
				MsgInfo("O percentual para este tipo de comissão, deve ser informado "+ENTER+;  //
				"na tela de edição de itens.","Aviso") // "Aviso" //
				M->EEB_VALCOM := 0 //MCF - 03/09/2015
			EndIf

	Case cCampo == "EEB_VALCOM"
		If Type("M->EE7_TOTPED") <> "U"
			cAlias := "EE7"
		Else
			cAlias := "EEC"
		EndIf

		If M->EEB_TIPCVL = "1"
			If M->EEB_VALCOM > 99.99
				MsgInfo("A porcentagem de comissão deve ser inferior a 100 %","Aviso") //
				lRet := .f.
			EndIf
		ElseIf M->EEB_TIPCVL = "2"
				nFob := EECFob(If(cAlias == "EE7",OC_PE,OC_EM))
			If nFob > 0
				If M->EEB_VALCOM >= nFob
						MsgInfo("O valor da comissão deve ser inferior ao valor FOB.","Aviso")  //
						Return .f.
				EndIf
			EndIf
		EndIf

		If lTratComis .And. !lOkAg //MCF - 11/01/2016
			AP100CRIT("EEB_TIPCVL")
		EndIf

		// Case cCampo == "EE8_CODAGE" - JPM - 02/06/05
	Case cCampo $ "EE8_CODAGE/EE8_TIPCOM"

		If !Empty(M->EE8_CODAGE)
			If WorkAg->(DbSeek(M->EE8_CODAGE+AvKey(CD_AGC+"-"+Tabela("YE",CD_AGC,.f.),"EEB_TIPOAG")+;
					If(EE8->(FieldPos("EE8_TIPCOM")) > 0,M->EE8_TIPCOM,"")))

					If WorkAg->EEB_TIPCVL = "1" // Percentual.
						M->EE8_PERCOM := WorkAg->EEB_VALCOM
						M->EE8_VLCOM  := Round(M->EE8_PRCINC*(M->EE8_PERCOM/100),2)

					ElseIf WorkAg->EEB_TIPCVL = "2" // Valor Fixo.
						M->EE8_PERCOM := 0
						M->EE8_VLCOM  := WorkAg->EEB_VALCOM

					Else // Percentual por item.
						M->EE8_PERCOM := 0
						M->EE8_VLCOM  := 0
					EndIf
				EndIf
			Else
				M->EE8_PERCOM := 0
				M->EE8_VLCOM  := 0
			EndIf

			// ** By JBJ - 28/08/03 - 15:27. (Validação do campo de flag para tratamento de OffShore).
		Case cCampo == "EE7_INTERM"

			If INCLUI
				Break
			EndIf

			Do Case
			Case ALTERA .And. EE7->EE7_INTERM == M->EE7_INTERM
				Break

			Case ALTERA .And. (EE7->EE7_INTERM <> M->EE7_INTERM) .And. (M->EE7_INTERM $ cSim)

				EE8->(DbSetOrder(1))
				EE8->(DbSeek(xFilial("EE8")+M->EE7_PEDIDO))
				While EE8->(!Eof()) .And. EE8->EE8_FILIAL == xFilial("EE8") .And.;
						EE8->EE8_PEDIDO == M->EE7_PEDIDO
					If EECFlags("COMMODITY") .Or. EECFlags("CAFE") // By JPP - 03/03/2008 - 16:30 - Não permitir transformar pedido normal em offshore quando existir fixação de preço.
						If !Empty(EE8->EE8_DTFIX)
							MsgInfo("Este processo possui fixação de Preço/RV, este campo não pode ser alterado. Estorne a fixação para alterar este campo.","Atenção") //
							lRet := .F.
							Break
						EndIf
					EndIf
					If EE8->EE8_SLDINI <> EE8->EE8_SLDATU
						MsgStop("Problema:"+ENTER+; //
						"Este processo foi lançado em fase de embarque na filial Brasil. Para que o sistema "+; //
						"gere o pedido na filial de off-shore, o embarque deverá ser eliminado na filial Brasil.","Atenção") //
						lRet:=.f.
						Break
					EndIf
					EE8->(DbSkip())
				EndDo
			EndCase
			// JPP - 11/01/05 - 10:15 - Na alteração do Pais é verificado se existe normas vinculadas a produtos.
		Case cCampo == "EE7_PAISET"
			If ! lOK
				AP100Normas(OC_PE)
			EndIf

		Case cCampo == "EE8_PERCOM"//LGS-26/12/2014 - Preciso validar antes e calcular se tiver zero pra que o valor da comissao seja calculado
			If M->EE8_PRCTOT == 0
				M->EE8_PRCTOT := M->(EE8_SLDINI * EE8_PRECO)
				M->EE8_PRCINC := M->(EE8_SLDINI * EE8_PRECO)
			EndIf

		Case cCampo == "EE8_VLCOM"  //LRS - 27/11/2014 - Validação para pegar a porcentagem calculada de acordo com o valor digitado
			If M->EE8_PRCTOT == 0   //LGS-26/12/2014 - Preciso validar antes e calcular se tiver zero pra que o valor da comissao seja calculado
				M->EE8_PRCTOT := M->(EE8_SLDINI * EE8_PRECO)
				M->EE8_PRCINC := M->(EE8_SLDINI * EE8_PRECO)
			EndIf

			If M->EE8_VLCOM > M->EE8_PRCINC
				MsgInfo("Valor da comissão maior que o valor total do item","Atenção") //
				lRet := .F.
			Else
				M->EE8_PERCOM:= Round(((M->EE8_VLCOM/M->EE8_PRCINC)*100),2)
			EndIf

			/*
			ER - 03/10/2006 às 15:00
			Para a utilização de Adiantamento, é necessário utilizar a rotina de "Pagamento Antecipado",
			portanto a Condição de Pagamento não deverá ter essa opção.
			*/
			SY6->(DbSetOrder(1))
			If SY6->(DbSeek(xFilial("SY6")+M->EE7_CONDPA))
				If SY6->Y6_TIPO = "3"
					For nPos := 1 To 10
						If SY6->&("Y6_DIAS_" + StrZero(nPos, 2)) < 0
							MsgStop("A condição de pagamento selecionada, contém uma ou mais parcelas de adiantamento. Informe uma condição de pagamento onde não haja parcelas de adiantamento.","Atenção")//)
							lRet := .F.
							Break
						EndIf
					Next
				EndIf
			EndIf

		Case cCampo == "EE7_DESSEG" //LRS - 11/09/2015
			AP100Crit("EE7_SEGURO")
		EndCase

	End Sequence

	RESTORD(aORD)
	dbselectarea(cOldArea)

Return lRet

/*
=====================================================================================
Programa............: MVLD24GLD
Autor...............: Joni Lima
Data................: 17/04/2017
Descrição / Objetivo: Validações dos campos Em Geral
=====================================================================================
*/
User function MVLD24GLD(cCAMPO)

	Local cCpoCont:= ""

	Local lRet    := .T.
	Local lReposic:= Type("SB1->B1_REPOSIC") <> "U"
	Local oModel := FwModelActive()

	BEGIN SEQUENCE
		//DFS - 19/07/2011 - Ponto de entrada para que, retire a validação dos campos desejados.
		DO CASE

			CASE cCAMPO="ZB9_QTDEM1"
				// GFP - 21/07/2012 - Inclusão de calculo de Quantidade na embalagem
				If !Empty(oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QTDEM1"))
					If (oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI") % oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QTDEM1")) != 0
						HELP(" ",1,"AVG0000637") //MsgStop("Quantidade informada não e multipla pela quantidade na Embalagem !","Aviso")
						oModel:GetModel("ZB9DETAIL"):SetValue("ZB9_QE",Int(oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI")/oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QTDEM1"))+1) //QUANT.NA EMBAL.
						lRet    := .T.
					Else
						oModel:GetModel("ZB9DETAIL"):SetValue("ZB9_QE",oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI")/oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QTDEM1")) //QUANT.NA EMBAL.
					EndIf
				EndIf
			CASE cCAMPO="ZB9_QE"
				If !Empty(oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QE"))
					If (oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI") % oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QE")) != 0
						HELP(" ",1,"AVG0000637") //MsgStop("Quantidade informada não e multipla pela quantidade na Embalagem !","Aviso")
						oModel:GetModel("ZB9DETAIL"):SetValue("ZB9_QTDEM1",Int(oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI")/oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QE"))+1) //QUANT.DE EMBAL.
						lRet    := .T.
					Else
						oModel:GetModel("ZB9DETAIL"):SetValue("ZB9_QTDEM1",oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_SLDINI")/oModel:GetModel("ZB9DETAIL"):GetValue("ZB9_QE")) //QUANT.DE EMBAL.
					EndIf
				EndIf

		ENDCASE

	ENDSEQUENCE

return lRET


/*/
{Protheus.doc} MGFEEC24()
Browse EXP - Tela manutenção EXP

@author A. Carlos
@since 12/11/2019
@type User Function

@auteracao 
@since
Função aplicada no When para bloquear o campo ZB8_INLAND conforme regra

/*/
User Function Bloq_Cpo()
Local lLock := .T.
local oModel		:= FWModelActive()
local oModelZB8		:= oModel:GetModel('ZB8MASTER')

If oModelZB8:getValue("ZB8_VIA") == "02" .OR. oModelZB8:getValue("ZB8_VIA") == "03" .OR. oModelZB8:getValue("ZB8_VIA") == "04"

	If oModelZB8:getValue("ZB8_INLAND") <> "01" 
	   Help('',1,'Campo INLAND',,' Só pode ser preenchido com "01" ',1,0)			
	   lLock := .F.
    EndIf

ELSEIf oModelZB8:getValue("ZB8_VIA") == "01" .AND. !Empty( oModelZB8:getValue("ZB8_ZNUMRE") )

	If !(oModelZB8:getValue("ZB8_INLAND") $ "01|02|03|") .OR. oModelZB8:getValue("ZB8_INLAND")=" " .OR. oModelZB8:getValue("ZB8_INLAND")="  "
	   Help('',1,'Campo INLAND',,' Só pode ser preenchido com "01, 02, 03" ',1,0)		   
	   lLock := .F.
    EndIf

ELSEIf oModelZB8:getValue("ZB8_VIA") == "01" .AND. Empty( oModelZB8:getValue("ZB8_ZNUMRE") )

		If !Empty(oModelZB8:getValue("ZB8_INLAND")) .OR. oModelZB8:getValue("ZB8_INLAND")=" " .OR. oModelZB8:getValue("ZB8_INLAND")="  "
		   Help('',1,'Campo INLAND',,' Só pode ser preenchido com "  " ',1,0)
           lLock := .F.
        EndIf
EndIf

If !Empty(oModelZB8:getValue("ZB8_INLAND")) .OR. oModelZB8:getValue("ZB8_INLAND")=" " .OR. oModelZB8:getValue("ZB8_INLAND")="  "
	Help('',1,'Campo INLAND',,' Só pode ser preenchido com "  " ',1,0)
	lLock := .F.
EndIf

Return(lLock)


/*/
{Protheus.doc} MGFEEC24()
Browse EXP - Tela manutenção EXP

@author A. Carlos
@since 12/11/2019
@type User Function

@auteracao
@since
Função aplicada no gatilho para limpar o campo ZB8_INLAND conforme regra
/*/
User Function Limpa_Cpo()
   If 	  M->ZB8_VIA = "02" .OR. M->ZB8_VIA = "03" .OR. M->ZB8_VIA = "04"
	   	  M->ZB8_INLAND := '01'
   ELSEIf M->ZB8_VIA="01" .AND. !Empty(M->ZB8_ZNUMRE)
	   	  If !(M->ZB8_INLAND $ "01|02|03|")
		     M->ZB8_INLAND := ' '
		  EndIf
   ELSEIf M->ZB8_VIA="01" .AND. Empty(M->ZB8_ZNUMRE)
		  M->ZB8_INLAND := '  '
   EndIf

Return(M->ZB8_INLAND)


/*
=====================================================================================
Programa............: xM25GFil
Autor...............: Joni Lima
Data................: 21/04/2017
Descrição / Objetivo: Gatilho para preenchimento das filiais na Linha
=====================================================================================
*/
User function xM25GFil()

	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	Local ni		:= 1
	Local cxFil		:= oMdlZB8:GetValue('ZB8_FILVEN')

	If !Empty(AllTrim(cxFil))
		For ni:=1 to oMdlZB9:Length()
			oMdlZB9:GoLine(ni)
			oMdlZB9:SetValue('ZB9_FILVEN',cxFil)
			oMdlZB9:SetValue('ZB9_FILENT',cxFil)
		Next ni
	EndIf

	oMdlZB9:GoLine(1)
	oView:Refresh()

return cxFil

/*/{Protheus.doc} M25Forn
//TODO Gatilho para preencher Fornecedor nos itens
@author leonardo.kume
@since 18/05/2017
@version 6

@type function
/*/
User function M25Forn(nOpc)

	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	Local ni		:= 1
	Local cForn		:= oMdlZB8:GetValue('ZB8_FORN')
	Local cLoja		:= oMdlZB8:GetValue('ZB8_FOLOJA')
	Local cFabr		:= oMdlZB8:GetValue('ZB8_FABR')
	Local cFLoja	:= oMdlZB8:GetValue('ZB8_FALOJA')

	Default nOpc := 1

	If !Empty(AllTrim(cForn)) .or. !Empty(AllTrim(cFabr))
		For ni:=1 to oMdlZB9:Length()
			oMdlZB9:GoLine(ni)
			If !Empty(AllTrim(cForn))
				oMdlZB9:SetValue('ZB9_FORN',cForn)
				oMdlZB9:SetValue('ZB9_FOLOJA',cLoja)
			EndIf
			If !Empty(AllTrim(cFabr))
				oMdlZB9:SetValue('ZB9_FABR',cFabr)
				oMdlZB9:SetValue('ZB9_FALOJA',cFLoja)
			EndIf
		Next ni
	EndIf

	oMdlZB9:GoLine(1)
	oView:Refresh()

return iif(nOpc,cForn,cFabr)

/*
=====================================================================================
Programa............: M24CanZB
Autor...............: Joni Lima
Data................: 21/04/2017
Descrição / Objetivo: Função para cancelamento da EXP
=====================================================================================
*/
User function M24CanZB()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

	If ZB8->ZB8_MOTEXP $ '1|5|6'
		FWExecView('Cancelamento EXP','MGFEEC24', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )

	    // Paulo da Mata - 26/05/2020 - Gera a integração em caso de cancleamento da EXP
	    If !Empty(ZB8->ZB8_INTTAU)
	       U_fEnvExpT()
	    EndIf   

	Else
		MsgInfo("Só é permitido o cancelamento de EXPs que estão Aguardando Distribuição/Distribuidas que não possuem pedido(s) gerado(s)","Atenção")//
	EndIf
Return

/*
=====================================================================================
Programa............: xVldAcivate
Autor...............: Joni Lima
Data................: 21/04/2017
Descrição / Objetivo: Validação da ativação do Modelo
=====================================================================================
*/
Static Function xVldAcivate(oModel)

	Local lRet := .T.

	If oModel:GetOperation() == MODEL_OPERATION_UPDATE

		If ZB8->ZB8_MOTEXP $ '2'
			lRet := .F.
			Help('',1,'Pedido Gerado',,'Pedido de Exportação ja foi Gerada',1,0)
		EndIf

		If ZB8->ZB8_MOTEXP $ '7'
			lRet := .F.
			Help('',1,'Pedido Gerado',,'Pedido de Venda ja foi Gerada',1,0)
		EndIf

		If ZB8->ZB8_MOTEXP == '3'
			lRet := .F.
			Help('',1,'EXP Cancelada',,'Essa EXP foi cancelada',1,0)
			If FindFunction("U_MGFEEC80")
				U_MGFEEC80()
			EndIf
		EndIf

	EndIf

	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		lRet := ! AllTrim(ZB8->ZB8_MOTEXP) $ "2/4"
		If !lRet
			Help(" ",1,"EXP com pedido",,'Essa EXP já tem pedido Gerado',1,0)
		EndIf
	EndIf

return lRet

/*
=====================================================================================
Programa............: xActiv
Autor...............: Joni Lima
Data................: 21/04/2017
Descrição / Objetivo: Ativação do Modelo
=====================================================================================
*/
Static Function xActiv(oModel)

	Local lRet := .T.
	Local oMdlZB8 := oModel:GetModel('ZB8MASTER')

	If IsInCallStack("U_M24CanZB")
		oMdlZB8:LoadValue('ZB8_MOTEXP','3')
		oMdlZB8:LoadValue('ZB8_STTDES','CANCELADO')
		oMdlZB8:LoadValue('ZB8_MOTSIT','0010')
	EndIf

	If oMdlZB8:GetOperation() <> MODEL_OPERATION_DELETE
		oMdlZB8:LoadValue('ZB8_ZREVIS',ddatabase)
		oMdlZB8:LoadValue('ZB8_ZHRINC',Time())
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMEEC24GP
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Função para Geração do Pedido Comex
=====================================================================================
*/
User Function xMEEC24GP()
	Local lOk
	Local _nValFrePr := ZB8->ZB8_FRPREV
	Local _nValReal  := ZB8->ZB8_FRREAL
	Local _vMoeForte := ZB8->ZB8_ZMOEFR
	Local _vVia	     := ZB8->ZB8_VIA
	Local _nTaXa     := 1
	
	If ZB8->ZB8_MOTEXP $ '6|4'
		// RVBJ
		If _vVia == '03' .And. _vMoeForte <> "BRL" 
			_nTaXa := POSICIONE("SYE",1,XFILIAL("SYE")+dtos(dDataBase)+_vMoeForte,"YE_TX_COMP")//04-03 Merge Wagner
			If _nTaxa <> 0
				If _nValReal == 0
					MsgAlert("Valor Real do Frete não localizado. O valor do frete não será convertido.","Atenção !!!")
				Else
					_nValFrePr := ( _nValReal / _nTaxa )	
				EndIf
			Else
				MsgAlert("Taxa da moeda não localizada. O valor do frete não será convertido.","Atenção !!!")
			EndIf

		EndIf

		If AllTrim(ZB8->ZB8_MOTSIT) $ AllTrim(SuperGetMv("MGF_EXPIND",,"0011"))
			GrvFRPREV(_nValFrePr, _nTaXa)
			Processa({|| xPedVen()},"Aguarde...","Gerando Pedido no Faturamento",.F.)
		Else
			lOk := ValidaZB8()
			If lOk
				GrvFRPREV(_nValFrePr, _nTaXa)
				Processa({|| xProsPed()},"Aguarde...","Gerando Pedido no Comex",.F.)
			EndIf
		EndIf
	Else
		Help(" ",1,"Atenção",,'Só é Possivel a geração de Pedidos para EXPs que estejam Distribuídas ou geradas parcialmente.',1,0)
	EndIf
return

/*
=====================================================================================
Programa............: xProsPed
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Processa Geração do Pedido Comex
=====================================================================================
*/
Static function xProsPed()

	Local lContExec  := .T.

	Local aAreaZB8 	:= ZB8->(GetArea())
	Local aAreaZB9 	:= ZB9->(GetArea())

	Local aFldZB8 	:= xPrepX3("ZB8")
	Local aFldZB9 	:= xPrepX3("ZB9")
	Local aFldEE7 	:= xPrepX3("EE7")
	Local aFldEE8 	:= xPrepX3("EE8")

	Local aDadZB8 	:= {xCarDad(aFldZB8,'ZB8')}//Prepara Cabeçalho ZB8
	Local aDadZB9 	:= {}
	Local aDadEE7 	:= {}
	Local aDadEE8 	:= {}
	Local afils		:= {}

	Local aPedDados := {}

	Local aCpBranco := {}
	Local aRet		:= {}

	Local cFilA := cFilAnt
	Local cFilB := AllTrim(ZB8->ZB8_FILVEN)//aCabec[AScan(aCabec,{|x| x[1] == "EE7_FILIAL"})][2]

	Local cxMsg 	:= ''
	Local cPed		:= ''
	Local lGrvStt	:= .T.
	Local lPedOk 	:= .F.
	Local nI		:= 0

	Local cSuc		:= ""

	ProcRegua(0)

	If !Empty(cFilB)

		//Prepara Itens ZB9
		dbSelectArea('ZB9')
		ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUENC
		If ZB9->(dbSeek(xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
			While ZB9->(!EOF()).and. ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
				IncProc()
				AADD(aDadZB9,xCarDad(aFldZB9,'ZB9'))
				ZB9->(dbSkip())
			EndDo
		EndIf

		//Prepara Cabeçalho do Pedido
		aDadEE7 := xDadCab(aFldEE7,aDadZB8,aFldZB8,@lContExec,@aCpBranco)

		//Preapra Itens do Pedido
		aDadEE8 := xDadItem(aFldEE8,aDadZB9,aFldZB9,@lContExec,@aCpBranco)

		aRet := StartJob("u_xMG24JBIC",GetEnvServer(),.T.,aDadEE7,aDadEE8,cFilB,{ZB8->ZB8_EXP,ZB8->ZB8_ANOEXP,ZB8->ZB8_SUBEXP,' ',ZB8->ZB8_ORCAME})

		If ExistPed(cFilB,ZB8->ZB8_EXP,ZB8->ZB8_ANOEXP,ZB8->ZB8_SUBEXP)
						
			RecLock('ZB8',.F.)
			ZB8->ZB8_MOTEXP  := '2'
			ZB8->(MsUnLock())
			DbSelectArea("EE7")
			EE7->(DbSetOrder(1))

			If EE7->(DbSeek(cFilB+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")))
				RecLock('EE7',.F.)
				EE7->EE7_ZOBSND := ZB8->ZB8_ZOBSND  //+ZB8->ZB8_ZOBS
				EE7->EE7_INCO2	:= ZB8->ZB8_INCO2
				EE7->EE7_DIAS2	:= ZB8->ZB8_DIAS2
				EE7->EE7_COND2	:= ZB8->ZB8_COND2
				// RVBJ
				EE7->EE7_ZINLAN	:= ZB8->ZB8_INLAND
				EE7->EE7_ZINLAD	:= ZB8->ZB8_INLADS
				EE7->(MsUnlock())
			EndIf

			If EE7->(DbSeek(GetMv("MV_AVG0024",,"900001")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")))
				RecLock('EE7',.F.)
				EE7->EE7_INCOTE	:= ZB8->ZB8_INCO2
				EE7->EE7_DIASPA	:= ZB8->ZB8_DIAS2
				EE7->EE7_CONDPA	:= ZB8->ZB8_COND2
				// RVBJ
				EE7->EE7_ZINLAN	:= ZB8->ZB8_INLAND
				EE7->EE7_ZINLAD	:= ZB8->ZB8_INLADS
				EE7->(MsUnlock())
			EndIf

			If ZB8->ZB8_ZHILTO == "1"
				If EE7->(DbSeek(cFilB+ZB8->ZB8_EXP+'H'+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")))
					RecLock('EE7',.F.)
					EE7->EE7_INCO2	:= ZB8->ZB8_INCO2
					EE7->EE7_DIAS2	:= ZB8->ZB8_DIAS2
					EE7->EE7_COND2	:= ZB8->ZB8_COND2
					EE7->(MsUnlock())
				EndIf
				If EE7->(DbSeek(GetMv("MV_AVG0024",,"900001")+ZB8->ZB8_EXP+'H'+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")))
					RecLock('EE7',.F.)
					EE7->EE7_INCOTE	:= ZB8->ZB8_INCO2
					EE7->EE7_DIASPA	:= ZB8->ZB8_DIAS2
					EE7->EE7_CONDPA	:= ZB8->ZB8_COND2
					EE7->(MsUnlock())
				EndIf
			EndIf
/*
			//WVN GRAVA NUMERO DO PEDIDO DE VENDAS NA EXP
			If EMPTY(ZB8->ZB8_PEDFAT)
				cQrySc5 := ' '
				cQrySc5 := "SELECT C5_FILIAL,C5_NUM,C5_PEDEXP"
				cQrySc5 += " FROM "+RetSqlname("SC5")+ " TSC5"
				cQrySc5 += " WHERE "
				cQrysc5 += "  TSC5.C5_FILIAL = '"+cFilB+"' AND"
				IF LEN(ALLTRIM(ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP))=9
					cQrysc5 += "  SUBSTR(TSC5.C5_PEDEXP,1,9)='"+ALLTRIM(ZB8->ZB8_EXP)+"' AND"
				ELSEIF LEN(ALLTRIM(ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP))=14
					cQrysc5 += "  SUBSTR(TSC5.C5_PEDEXP,1,14)='"+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP+"' AND"
				ELSEIF LEN(ALLTRIM(ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP))=11
					cQrysc5 += "  SUBSTR(TSC5.C5_PEDEXP,1,11)='"+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+"' AND"					
				ENDIF
				cQrySc5 += "  TSC5.D_E_L_E_T_ = ' ' "
				cQrySc5 := ChangeQuery(cQrySc5)
				dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQrySc5),"QRYSC5",.T.,.T.)
				QRYSC5->(dbGoTop())
				Count To nRegSc5
				QRYSC5->(dbGoTop())
				If nRegSc5 > 0 
					RecLock('ZB8',.F.)
					ZB8->ZB8_PEDFAT := QRYSC5->C5_NUM
					ZB8->(MSUNLOCK())
				ENDIF
				QRYSC5->(dbCloseArea())
				inkey(.1)
			ENDIF
*/
			//Salva Pedido ZB9
			dbSelectArea('ZB9')
			ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUENC
			If ZB9->(dbSeek(xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
				While ZB9->(!EOF()).and. ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
					If ZB8->ZB8_ZHILTO == "1"
						If ZB9->ZB9_ZHILTO == "1"
							cPed := AllTrim(ZB8->(ZB8_EXP+"H"+ZB8_ANOEXP+ZB8_SUBEXP))
						Else
							cPed := AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
						EndIf
					Else
						cPed := AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
					EndIf
					RecLock('ZB9',.F.)
					ZB9->ZB9_ZPEDID := cPed
					ZB9->(MsUnlock())
					ZB9->(dbSkip())
				EndDo
			EndIf
			cSuc := 'Pedido Gerado Com Sucesso: ' + aRet[2]
			
			ApMsgInfo(cSuc,"Pedido Gerado")
			_ltela := .f.
			//wvn 220720
			If cFilB $ GETMV("MGF_TMSEXP")	
				Processa({|| U_MGFEEC81( ZB8->ZB8_EXP, ZB8->ZB8_ANOEXP, ZB8->ZB8_SUBEXP, ZB8->ZB8_MOTEXP, ZB8->ZB8_TMSACA, _lTela, "01", cFilB  ) },"Processando","Aguarde........Enviando EXP ao TMS MultiSoftWare.",.F.)
			EndIf
			//
		Else
			If Valtype(aRet) == 'A' .and. len(aRet) > 1 .and. Valtype(aRet[2]) == "C"
				ShowError(AllTrim(aRet[2]))
			Else
				lGrvStt := ExPedido()
			EndIf
		EndIf

	Else

		cSuc += 'Pedidos gerados com sucesso: ' + CRLF

		aFils	:= {}
		//Prepara Itens ZB9
		dbSelectArea('ZB9')
		ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUENC
		If ZB9->(dbSeek(xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
			While ZB9->(!EOF()).and. ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP) .AND.;
					lContExec
				If !Empty(AllTrim(ZB9->ZB9_FILENT))
					If Empty(ZB9->ZB9_ZPEDID)
						cFilB := AllTrim(ZB9->ZB9_FILENT)
						nI := aScan(aFils, {|x| x[1] == cFilB})

						If nI == 0
							aAdd(aFils,{cFilB,{xCarDad(aFldZB9,'ZB9')}})
						Else
							aAdd(aFils[nI][2],xCarDad(aFldZB9,'ZB9'))
						EndIf
					EndIf
				Else
					lContExec := .F.
				EndIf
				ZB9->(dbSkip())
			EndDo
			If lContExec
				For nI := 1 to Len(aFils)
					cFilB := aFils[nI][1]
					aDadZB9 := {}
					aDadEE7 := {}
					aDadEE8 := {}

					// AADD(aDadZB9,xCarDad(aFldZB9,'ZB9'))
					aDadZB9 := aClone(aFils[nI][2])

					//Prepara Cabeçalho do Pedido
					aDadEE7 := xDadCab(aFldEE7,aDadZB8,aFldZB8,@lContExec,@aCpBranco)

					//Preapra Itens do Pedido
					aDadEE8 := xDadItem(aFldEE8,aDadZB9,aFldZB9,@lContExec,@aCpBranco)
					aRet := StartJob("u_xMG24JBIC",GetEnvServer(),.T.,aDadEE7,aDadEE8,cFilB,{ZB8->ZB8_EXP,ZB8->ZB8_ANOEXP,ZB8->ZB8_SUBEXP,ZB9->ZB9_SEQUEN,ZB8->ZB8_ORCAME})

					If ExistPed(cFilB,ZB8->ZB8_EXP,ZB8->ZB8_ANOEXP,ZB8->ZB8_SUBEXP)
						cSuc += xAtZB9(aDadZB9,aFldZB9,"ZB9_ZPEDID",aRet[2]) //Atualiza a Tabela ZB9 com o numero do pedido e Motna mensagem

						//verificar a gravação do dias pagto 90
						If EE7->(DbSeek(GetMv("MV_AVG0024",,"900001")+ aRet[2]))
							RecLock('EE7',.F.)
							EE7->EE7_INCOTE	:= ZB8->ZB8_INCO2
							EE7->EE7_DIASPA	:= ZB8->ZB8_DIAS2
							EE7->EE7_CONDPA	:= ZB8->ZB8_COND2
							EE7->(MsUnlock())
						EndIf

						If EE7->(DbSeek(cFilB + aRet[2]))
							RecLock('EE7',.F.)
							EE7->EE7_INCO2	:= ZB8->ZB8_INCO2
							EE7->EE7_DIAS2	:= ZB8->ZB8_DIAS2
							EE7->EE7_COND2	:= ZB8->ZB8_COND2
							EE7->(MsUnlock())
						EndIf

						lPedOk := .T.
					Else
						lGrvStt := .f.

						If Valtype(aRet) == 'A' .and. len(aRet) > 0
							cxMsg := AllTrim(aRet[2])
							ShowError(AllTrim(cxMsg))
						Else
							lGrvStt := ExPedido(cFilB,.f.)
						EndIf

						Exit
					EndIf

				Next nI
			Else
				ApMsgInfo("Existem itens que não estão com a filial Distribuída.","Pedidos Não Gerados")
			EndIf

		EndIf
		If lGrvStt
			RecLock('ZB8',.F.)
			ZB8->ZB8_MOTEXP  := '2'
			//ZB8->ZB8_PEDFAT  := SC5->C5_NUM //WVN
			ZB8->(MsUnLock())
			ApMsgInfo(cSuc,"Pedidos Gerados")
		ElseIf !(lGrvStt) .and. lPedOk
			RecLock('ZB8',.F.)
			ZB8->ZB8_MOTEXP := '4'
			ZB8->(MsUnLock())
			ApMsgInfo(cSuc,"Pedidos Gerados")
		EndIf
	EndIf

return

/*
=====================================================================================
Programa............: xMG24JBIC
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Prepara Ambiente para o Job
=====================================================================================
*/
User Function xMG24JBIC(aDadEE7,aDadEE8,cFilAtu,aRegist)

	Local aRet := {.F.,'Erro xMG24JBIC: Linha 1670'}
	Local lOk := .T.

	RpcSetType( 3 )

	//RpcSetEnv( '01' , cFilAtu )
	PREPARE ENVIRONMENT EMPRESA( '01' ) FILIAL ( cFilAtu ) MODULO ( 'EEC' ) TABLES "EE7", "EE8", "SX6"


	//Executa Execauto
	aRet :=  IncluirPed(aDadEE7,aDadEE8,aRegist,cFilAtu)

	If Valtype(aRet) == 'A' .and. len(aRet) > 0 .and. aRet[1]
		u_xAdic24()
	EndIf

	RESET ENVIRONMENT
	//RpcClearEnv()

return aRet

/*
=====================================================================================
Programa............: xPrepX3
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Carrega campos cadastrados na SX3
=====================================================================================
*/
Static function xPrepX3(cTab)

	Local aArea := GetArea()
	Local aRet 	:= {}

	//Pega Os Campos da SX3
	dbSelectArea('SX3')
	SX3->(dbSetOrder(1))//X3_ARQUIVO+X3_ORDEM

	If SX3->(dbSeek(cTab))
		While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == cTab
			If SX3->X3_CONTEXT <> 'V' .AND. !AllTrim(SX3->X3_CAMPO) $ "ZB8_DIAS2/ZB8_COND2/ZB8_INCO2"
				AADD(aRet,{AllTrim(SX3->X3_CAMPO),X3Obrigat(AllTrim(SX3->X3_CAMPO))})
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)

return aRet

/*
=====================================================================================
Programa............: xCarDad
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Carrega dados dos campos informados. obs.: tabela deve estar possicionada
=====================================================================================
*/
Static function xCarDad(aCpos,cTab)

	Local aArea := GetArea()
	Local aRet := {}

	Local cFld	:= ''
	Local xCtd	:= ''

	Local ni	:= 0

	for ni := 1 To Len(aCpos)
		If !AllTrim(aCpos[ni,1]) $ "ZB8_DIAS2/ZB8_COND2/ZB8_INCO2"
			cFld := cTab + '->' + AllTrim(aCpos[ni,1])//Monta o Campo
			xCtd := &(cFld)//Recupera o conteudo do Campo
			AADD(aRet,xCtd)//Adiciona no Array de Retorno do Registro
		EndIf
	next ni

	RestArea(aArea)

return aRet

/*
=====================================================================================
Programa............: xDadCab
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Prepara dados do cabeçalho para execauto de inclusão pedido comex
=====================================================================================
*/
Static function xDadCab(aFldEE7,aDadZB8,aFldZB8,lContExec,aCpBranco)

	Local aRet 	:= {}
	Local ni

	xConvFld(@aRet,aFldEE7,aDadZB8[1],'ZB8',aFldZB8,@lContExec,@aCpBranco)

return aRet

/*
=====================================================================================
Programa............: xDadItem
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Prepara dados dos itens para execauto de inclusão pedido comex
=====================================================================================
*/
Static function xDadItem(aFldEE8,aDadZB9,aFldZB9,lContExec,aCpBranco)

	Local aRet 	:= {}
	Local aItem	:= {}
	Local ni

	For ni:= 1 to len(aDadZB9)
		aItem :={}
		xConvFld(@aItem,aFldEE8,aDadZB9[ni],'ZB9',aFldZB9,@lContExec,@aCpBranco)
		AADD(aRet,aItem)
	next ni

return aRet

/*
=====================================================================================
Programa............: xConvFld
Autor...............: Joni Lima
Data................: 24/04/2017
Descrição / Objetivo: Converte campos da tabela carregada para um novo array com os campos da tabela informada
=====================================================================================
*/
Static Function xConvFld(aRet,aFld,aDadReg,cTab,aFldFor,lContExec,aCpBranco)

	Local ni
	Local nx
	Local cFld		:= ''
	Local nZB8Opx	:= 0

	for nx := 1 to len(aFld)//Percorre todos os campos da tabela que sera gerada
		cFld := cTab + SubStr( aFld[nx,1] , 4 , len(aFld[nx,1]) - 3 )//monsta campo da tabela que esta forncendo os dados
		nZB8Opx := aScan(aFldFor,{|x| x[1] == cFld})//encontra no "aHeader" o campo informado

		If nZB8Opx > 0//caso exista o campo
			If 	!(Empty(aDadReg[nZB8Opx]))// caracter, se estiver preenchido sera adicionado ao array para execauto
				AADD(aRet,{aFld[nx,1],aDadReg[nZB8Opx],nil})
			Else
				If aFld[nx,2]//Verifica se Obrigatorio
					lContExec := .F.
					AADD(aCpBranco,aFld[nx,1])
				EndIf
			EndIf
		EndIf
	next nx
return

/*
=====================================================================================
Programa............: xAtZB9
Autor...............: Joni Lima
Data................: 17/08/2018
Descrição / Objetivo: Atualiza Dados da ZB9 e Contrui a Mensagem para final do Processo
=====================================================================================
*/
Static Function xAtZB9(aDadZB9,aFldZB9,cFldAtu,xCont)

	Local aArea 	:= GetArea()
	Local aAreaZB9	:= ZB9->(GetArea())

	Local ni

	Local nPosFil		:= aScan(aFldZB9,{|x| x[1] == 'ZB9_FILIAL'	})
	Local nPosEXP		:= aScan(aFldZB9,{|x| x[1] == 'ZB9_EXP'		})
	Local nPosAnoEXP	:= aScan(aFldZB9,{|x| x[1] == 'ZB9_ANOEXP'	})
	Local nPosSubEXP	:= aScan(aFldZB9,{|x| x[1] == 'ZB9_SUBEXP'	})
	Local nPosSequen	:= aScan(aFldZB9,{|x| x[1] == 'ZB9_SEQUEN'	})

	Local cxFil			:= ""
	Local cExp			:= ""
	Local cAnoEXP		:= ""
	Local cSubExp		:= ""
	Local cSequen		:= ""

	Local cFld 			:= "ZB9->" + cFldAtu

	Local cRet			:= ""

	dbSelectArea("ZB9")
	ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUEN

	For ni:= 1 to len(aDadZB9)

		cxFil 	:= aDadZB9[ni][nPosFil]
		cExp	:= aDadZB9[ni][nPosEXP]
		cAnoEXP := aDadZB9[ni][nPosAnoEXP]
		cSubExp := aDadZB9[ni][nPosSubEXP]
		cSequen := aDadZB9[ni][nPosSequen]

		If ZB9->(dbSeek(cxFil + cExp + cAnoEXP + cSubExp + cSequen ))
			cRet := 'Seq. - ' + ZB9->ZB9_SEQUENC + " Ped. - " + xCont + CRLF
			RecLock('ZB9',.F.)
			&(cFld) := xCont
			ZB9->(MsUnlock())
		EndIf

	next ni

	RestArea(aAreaZB9)
	RestArea(aArea)
Return cRet

/*
=====================================================================================
Programa............: IncluirPed
Autor...............: Joni Lima
Data................: 21/04/2017
Descrição / Objetivo: Gera Pedido (Dadosee7,Dadosee8, Registro, Filial )
=====================================================================================
*/
Static Function IncluirPed(aCabec,aItens,aRegist,cFilAtu)

	Local lExecAuto := .T.//GetMv("MGF_EEC13E",,.T.)
	Local lRet 		:= .F.
	Local aCab 		:= {}
	Local aIt 		:= {}
	Local nI 		:= 0
	Local nY 		:= 0
	Local nPosPed 	:= 0
	Local nPos	  	:= 0
	Local cRet		:= ""
	Local cError := ""
	Local cVia 		:= ""
	Local cOrigem	:= ""
	Local cDest		:= ""
	Local aItensNH	:= {}
	Local aItensH	:= {}
	Local cMemoEE7  := ""
	Local nQtd := MLCount(EE7->EE7_ZOBSND)
	Local nK

	Local bError 	:= ErrorBlock( { |oError| MyError( oError , @cError) } )

	Private lMsHelpAuto := .T. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsistência na execução da rotina
	private lSched	:= .T.

	BEGIN SEQUENCE

		//Filiais
		nPos := aScan(aCabec,{|x| x[1] == "EE7_FILIAL"})
		If nPos <= 0
			aAdd(aCabec,{"EE7_FILIAL",xFilial('EE7'),Nil})
		Else
			aCabec[nPos][2] := xFilial('EE7')
		EndIf

		//Codigo do Pedido
		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_PEDIDO"})
		cRet := AllTrim(aRegist[1] + aRegist[2] + aRegist[3])
		cRet += IIF(!Empty(AllTrim(aRegist[4])) ,"("+SubStr(cFilAtu,5,2)+")" ,"")

		If nPosPed <= 0
			aAdd(aCabec,{"EE7_PEDIDO",cRet,Nil})
		Else
			aCabec[nPosPed][2] := cRet
		EndIf

		//Exp - Orcamento EE7_ZEXP,EE7_ZANOEX,EE7_ZSUBEX,EE7_ZSQEXP,EE7_ZORCAM
		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_ZEXP"})
		If nPosPed <= 0
			aAdd(aCabec,{"EE7_ZEXP",aRegist[1],Nil})
		Else
			aCabec[nPosPed][2] := aRegist[1]
		EndIf

		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_ZANOEX"})
		If nPosPed <= 0
			aAdd(aCabec,{"EE7_ZANOEX",aRegist[2],Nil})
		Else
			aCabec[nPosPed][2] := aRegist[2]
		EndIf

		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_ZSUBEX"})
		If nPosPed <= 0
			aAdd(aCabec,{"EE7_ZSUBEX",aRegist[3],Nil})
		Else
			aCabec[nPosPed][2] := aRegist[3]
		EndIf

		If !Empty(AllTrim(aRegist[4]))
			nPosPed := aScan(aCabec,{|x| x[1] == "EE7_ZSQEXP"})
			If nPosPed <= 0
				aAdd(aCabec,{"EE7_ZSQEXP",aRegist[4],Nil})
			Else
				aCabec[nPosPed][2] := aRegist[4]
			EndIf
		EndIf

		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_ZORCAM"})
		If nPosPed <= 0
			aAdd(aCabec,{"EE7_ZORCAM",aRegist[5],Nil})
		Else
			aCabec[nPosPed][2] := aRegist[5]
		EndIf

		//Datas
		nPos := aScan(aCabec,{|x| x[1] == "EE7_DTPEDI"})
		If nPos <= 0
			aAdd(aCabec,{"EE7_DTPEDI",dDataBase,Nil})
		Else
			aCabec[nPos][2] := dDataBase
		EndIf

		nPos := aScan(aCabec,{|x| x[1] == "EE7_DTPROC"})
		If nPos <= 0
			aAdd(aCabec,{"EE7_DTPROC",dDataBase,Nil})
		Else
			aCabec[nPos][2] := dDataBase
		EndIf

		For ni:=1 to Len(aItens)
			nPos := aScan(aItens[ni],{|x| x[1] == "EE8_FILIAL"})
			If nPos <= 0
				aAdd(aItens[ni],{"EE8_FILIAL",xFilial('EE8'),Nil})
			Else
				aItens[ni][nPos][2] := xFilial('EE8')
			EndIf
		next ni

		lSched	:= .T.

		cVia 	:= aCabec[aScan(aCabec,{|x| AllTrim(x[1]) == "EE7_VIA"})][2]
		cOrigem	:= aCabec[aScan(aCabec,{|x| AllTrim(x[1]) == "EE7_ORIGEM"})][2]
		cDest	:= aCabec[aScan(aCabec,{|x| AllTrim(x[1]) == "EE7_DEST"})][2]

		DbSelectArea("SYR")
		SYR->(DbSetOrder(1))
		SYR->(DbSeek(xFilial("SYR")+cVia+cOrigem+cDest))

		__CINTERNET := 'AUTOMATICO'

		If aCabec[aScan(aCabec,{|x| x[1] == "EE7_ZHILTO"})][2] == "1"

			SplitHilton(aItens,@aItensNH,@aItensH)
			If Len(aItensNH)>0
				MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCabec ,aItensNH, 3)
			EndIf,

			//Codigo do Pedido
			If Len(aItensH)>0
				nPosPed := aScan(aCabec,{|x| x[1] == "EE7_PEDIDO"})
				cRet := AllTrim(aRegist[1]+"H" + aRegist[2] + aRegist[3])
				cRet += IIF(!Empty(AllTrim(aRegist[4])) ,"("+SubStr(cFilAtu,5,2)+")" ,"")

				If nPosPed <= 0
					aAdd(aCabec,{"EE7_PEDIDO",cRet,Nil})
				Else
					aCabec[nPosPed][2] := cRet
				EndIf

				//Pedido Hilton
				MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCabec ,aItensH, 3)
			EndIf
		Else
			MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCabec ,aItens, 3)
		EndIf

		RECOVER
		Conout('Deu Problema na Execução' + ' Horas: ' + TIME() )
	END SEQUENCE

	ErrorBlock( bError )

	If lMsErroAuto .or. !Empty(cError)
		lRet := .F.
		If (!IsBlind()) // COM INTERFACE GRÁFICA
			cRet := iif(!Empty(cError),cError,MostraErro())
		Else // EM ESTADO DE JOB
			If !Empty(cError)
	            cRet := cError
			else
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)

		        cRet := PadC("Automatic routine ended with error", 80) + " Error: " + cError
			EndIf
		EndIf

	Else
		lRet := .T.
	EndIf

Return {lRet,cRet}

/*/{Protheus.doc} MGF24TRG
//TODO Gatilho para atualizar a soma total do Orçamento
@author leonardo.kume
@since 02/05/2017
@version 6
@param oModel, object, Model ativo
@param lAtual, logical, Atualiza itens e cabeçalho?
@type function
/*/
User Function MGF24TRG(oModel,lAtual)

	Local nRet	 	:= 0
	Local lOk		:= .T.
	Local nX		:= 0
	Local nLenPEA	:= 0

	Default oModel	:= FWModelActive()
	Default lAtual	:= .F.
	nLenPEA	:= oModel:GetModel( 'ZB9DETAIL'):Length()

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk
		nRet := 0
		For nX:=1 to nLenPEA
			nRet += oModel:GetModel( 'ZB9DETAIL'):GetValue("ZB9_PRECO",nX) * oModel:GetModel( 'ZB9DETAIL'):GetValue("ZB9_SLDINI",nX)
		Next nX
	EndIf

Return(nRet)

/*
=====================================================================================
Programa............: xPVldLin
Autor...............: Joni Lima
Data................: 03/05/2017
Descrição / Objetivo: Pré Validação da Linha
=====================================================================================
*/
static function xPVldLin(oMdlGrid,nLin,cOper,cField,cNewValue,cOldValue)

	Local lRet := .T.
	Local cPed	:= oMdlGrid:GetValue('ZB9_ZPEDID')

	If !Empty(AllTrim(cPed))
		lRet := .F.
		Help( ,, 'MGFEEC24-Existe Pedido',, 'Pedido já gerado para esse Item', 1, 0 )
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xCommit
Autor...............: Joni Lima
Data................: 03/05/2017
Descrição / Objetivo: Commit do Modelo de Dados (Atualiza Status da EXP)
=====================================================================================
*/
static Function xCommit(oModel)
	Local lRet			:= .T.
	Local oMdlZB8		:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9		:= oModel:GetModel('ZB9DETAIL')
	Local ni
	Local lNenhm		:= .T.
	Local lTotAte		:= .T.

	Local _cZB8_EXP		:= oMdlZB8:GetValue('ZB8_EXP')
	Local _ZB8ANOEXP	:= oMdlZB8:GetValue('ZB8_ANOEXP')
	Local _ZB8SUBEXP	:= oMdlZB8:GetValue('ZB8_SUBEXP')
	Local _ZB8TMSACA	:= oMdlZB8:GetValue('ZB8_TMSACA')
	Local _cZB8_MOTE	:= oMdlZB8:GetValue('ZB8_MOTEXP')
	Local _lTela 		:= .F.

	If !(IsInCallStack("U_M24CanZB")) .and. oMdlZB8:GetOperation() <> MODEL_OPERATION_DELETE//Se não for cancelamento

		//Verifica se todos não Foram preenchidos
		For ni := 1 to oMdlZB9:Length()
			oMdlZB9:GoLine(ni)
			If !Empty(oMdlZB9:GetValue("ZB9_FILENT"))
				lNenhm := .F.
			EndIf
		next ni

		//caso tenha algum preenchido verifica se estão todos preenchidos ou parcialmente
		If oMdlZB8:GetValue('ZB8_MOTEXP') == '7'
			lRet := .T.
		ElseIf !lNenhm
			For ni := 1 to oMdlZB9:Length()
				oMdlZB9:GoLine(ni)
				If Empty(oMdlZB9:GetValue("ZB9_FILENT"))
					lTotAte := .F.
					Exit
				EndIf
			next ni

			If lTotAte
				oMdlZB8:LoadValue('ZB8_MOTEXP','6')//Distribuida
			Else
				oMdlZB8:LoadValue('ZB8_MOTEXP','5')//Distribuida Parcialmente
			EndIf
		Else
			oMdlZB8:LoadValue('ZB8_MOTEXP','1')//Aguardando Distribuição
		EndIf
	EndIf

	//Gravação comum do commit
	If oModel:VldData()
		FwFormCommit(oModel)
		oModel:DeActivate()

		U_MGFDT15()
		U_TMSENVEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela, 1 )
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
return lRet

/*
=====================================================================================
Programa............: xVldMdl
Autor...............: Joni Lima
Data................: 03/05/2017
Descrição / Objetivo: Valida Modelo de Dados
=====================================================================================
*/
static function xVldMdl(oModel)

	Local lRet 		:= .T.
	Local cRet 		:= ""
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')
	Local cOrcam	:= oMdlZB8:GetValue('ZB8_ORCAME')

	Local _lMEEC24C := GetMv("MGF_EEC24C",,.T.) //Habilita validação cpo ZB8_ZMUNDI Cidade de Divisa. Precisa replicar p/ EE7
	Local _cZB8ZMUND:= ""//Cidade de Divisa. Precisa replicar p/ EE7
	
	Local nExpQtd	:= 0
	Local nOrcQtd		:= xQtdOrc(cOrcam)//Quantidade Original do Orçamento
	Local nMax		:= SuperGetMV("MGF_EEC24P",.F. , 5)
	Local ni		:= 1
	Local lValFret	:= GetMv("MGF_24FRT",,.T.) //Desliga validações do frete e seguro

	nOrcQtd := nOrcQtd * (1 + ( nMax / 100 )) //Calcula maxima quantidade permitida para EXP

	//Soma quantidade da EXP
	For ni := 1 to oMdlZB9:Length()
		oMdlZB9:GoLine(ni)
		nExpQtd += oMdlZB9:GetValue("ZB9_SLDINI")
	next ni

	If nExpQtd > nOrcQtd
		lRet := .F.
		Help( ,, 'MGFEEC24-Quantidade',, 'Quantidade dos produtos da EXP ultrapassou o máximo permitido', 1, 0 )
	EndIf

	If lRet
		lRet := U_fxValInl(2)
	EndIf

	If lRet
		lRet := fxRetInland(oModel)
	EndIf

	//Habilita validação cpo ZB8_ZMUNDI Cidade de Divisa. Precisa replicar p/ EE7
	If _lMEEC24C .And. !(IsInCallStack("U_M24CanZB"))
		_cZB8ZMUND:= oMdlZB8:GetValue('ZB8_ZMUNDI')//Cidade de Divisa. Precisa replicar p/ EE7
		If Empty(_cZB8ZMUND)
			lRet := .F.
			MsgStop("Favor inserir o código da cidade de divisa da EXP.","Atenção")
		EndIf
	EndIf

return lRet

/*
=====================================================================================
Programa............: xQtdOrc
Autor...............: Joni Lima
Data................: 03/05/2017
Descrição / Objetivo: Quantidade do Orçamento
=====================================================================================
*/
static function xQtdOrc(cOrcam)

	Local aArea 	:= GetArea()
	Local aAreaZZC	:= ZZC->(GetArea())
	Local aAreaZZD	:= ZZD->(GetArea())

	Local nQtd := 0

	dbSelectArea('ZZC')
	ZZC->(dbSetOrder(1))//ZZC_FILIAL+ZZC_ORCAME

	dbSelectArea('ZZD')
	ZZD->(dbSetOrder(1))//ZZD_FILIAL+ZZD_ORCAME+ZZD_SEQUEN

	If ZZC->(dbSeek(xFilial('ZZC') + cOrcam))
		If ZZD->(dbSeek(xFilial('ZZD') + cOrcam))
			While ZZD->(!EOF()) .and. ZZD->(ZZD_FILIAL + ZZD_ORCAME) == xFilial('ZZC') + cOrcam
				nQtd += ZZD->ZZD_SLDINI
				ZZD->(dbSkip())
			EndDo
		EndIf
	EndIf

	RestArea(aAreaZZD)
	RestArea(aAreaZZC)
	RestArea(aArea)

return nQtd

/*
=====================================================================================
Programa............: xM25CUN
Autor...............: Joni Lima
Data................: 04/05/2017
Descrição / Objetivo: Calculo Segunda unidade de Medida
=====================================================================================
*/
User function xM25CUN(cTp)

	Local aArea 	:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())

	Local nQtd := 0

	Local oModel 	:= FwModelActive()
	//Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	Local cProd		:= oMdlZB9:GetValue('ZB9_COD_I')
	Local nValor	:= 0
	Local nFatConv 	:= 0
	Local cTipCon	:= ''

	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))//B1_FILIAL+B1_COD

	If SB1->(dbSeek(xFilial('SB1') + cProd))
		nFatConv := SB1->B1_CONV
		cTipCon	 := SB1->B1_TIPCONV
	EndIf

	If (nFatConv > 0) .and. !(Empty(cTipCon))

		If cTp == "1"
			nValor := oMdlZB9:GetValue('ZB9_SLDINI')
			If !(Empty(nValor))
				If cTipCon == "M"
					nQtd := nValor * nFatConv
				Else
					nQtd := nValor / nFatConv
				EndIf
			Else
				nQtd := oMdlZB9:GetValue('ZB9_ZQT2UM')
			EndIf
		Else
			nValor := oMdlZB9:GetValue('ZB9_ZQT2UM')
			If !(Empty(nValor))
				If cTipCon == "M"
					nQtd := nValor / nFatConv
				Else
					nQtd := nValor * nFatConv
				EndIf
			Else
				nQtd := oMdlZB9:GetValue('ZB9_SLDINI')
			EndIf
		EndIf
	Else
		If cTp == "1"
			nQtd := oMdlZB9:GetValue('ZB9_ZQT2UM')
		Else
			nQtd := oMdlZB9:GetValue('ZB9_SLDINI')
		EndIf
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

return nQtd

/*
=====================================================================================
Programa............: xM25V2U
Autor...............: Joni Lima
Data................: 04/05/2017
Descrição / Objetivo: Valor Segunda Unidade de Medida
=====================================================================================
*/
User function xM25V2U()

	Local nValor := 0

	Local oModel 	:= FwModelActive()
	//Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	If !Empty(oMdlZB9:GetValue('ZB9_ZQT2UM'))
		nValor := oMdlZB9:GetValue('ZB9_PRCINC') / oMdlZB9:GetValue('ZB9_ZQT2UM')
	EndIf

return nValor

Static Function MyError(oError, cError )
	cError := "Erro na rotina automática : ERROR DESCRIPTION" + oError:Description + 'ERROR STACK' + oError:ERRORSTACK
	Conout( cError + " - MGFEEC24 - ERRO" )
	BREAK
Return Nil

	**********************************************************************************************************************
/*
=====================================================================================
Programa............: xM24GDT
Autor...............: Marcelo Carneiro
Data................: 24/05/2017
Descrição / Objetivo: Gatilho da data de Entrega
IIF(findfunction("U_xM24GDT"),U_xM24GDT(),M->ZB9_DTENTR)
=====================================================================================
*/
User function xM24GDT()

	Local dData := ''

	Local oModel 	:= FwModelActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	If !Empty(oMdlZB8:GetValue('ZB8_ZDTESD'))
		dData := oMdlZB8:GetValue('ZB8_ZDTESD')
	Else
		dData := oMdlZB9:GetValue('ZB9_DTENTR')
	EndIf

return dData


/*/{Protheus.doc} xM24CAN
//TODO Função para retornar saldo na EXP
@author leonardo.kume
@since 02/06/2017
@version 6

@type function
/*/
User function xM24CAN()

	Local cAliasZB9 := ""
	Local aAliasZB8	:= {}
	Local aAliasZB9	:= {}
	Local lOk	:= .F.

	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

	If 	cParam ==  "PE_EXC"//"PE_DEL_WORK"//ESTORNO_PEDIDO //"CANCELA"
		cAliasZB9 	:= GetNextAlias()
		aAliasZB8	:= ZB8->(GetArea())
		aAliasZB9	:= ZB9->(GetArea())
		lOk			:= .F.

		//Se não tiver mais nenhum EE7 com essas EXPS
		BeginSql Alias cAliasZB9
			SELECT '*' EXIST
			FROM %Table:EE7% EE7
			WHERE 	EE7.%notDel% AND
				EE7_FILIAL 	= %xFilial:EE7% AND
				EE7_ZEXP		= %Exp:EE7->EE7_ZEXP% AND
				EE7_ZSUBEX	= %Exp:EE7->EE7_ZSUBEX% AND
				EE7_ZANOEX	= %Exp:EE7->EE7_ZANOEX% AND
				EE7.R_E_C_N_O_	<> %Exp:EE7->(Recno())%
			EndSql
			If (cAliasZB9)->(Eof())
				(cAliasZB9)->(DbCloseArea())
				//Traz todos os itens das EXPs com esse número de Pedido
				BeginSql Alias cAliasZB9
					SELECT ZB9.R_E_C_N_O_ RECZB9, ZB8.R_E_C_N_O_ RECZB8
					FROM %Table:ZB9% ZB9
						INNER JOIN %Table:ZB8% ZB8
						ON 		ZB8.%notDel% AND
						ZB8_FILIAL = %xFilial:ZB8% AND
						ZB8_EXP	   = ZB9_EXP AND
						ZB8_SUBEXP = ZB9_SUBEXP AND
						ZB8_ANOEXP = ZB9_ANOEXP
					WHERE 	ZB9.%notDel% AND
						ZB9_FILIAL 	= %xFilial:ZB9% AND
						ZB9_EXP		= %Exp:EE7->EE7_ZEXP% AND
						ZB9_SUBEXP	= %Exp:EE7->EE7_ZSUBEX% AND
						ZB9_ANOEXP	= %Exp:EE7->EE7_ZANOEX% AND
						ZB9_ZPEDID	= %Exp:EE7->EE7_PEDIDO%
					EndSql
					While !(cAliasZB9)->(Eof())
						lOk	:= .T.
						DbSelectArea("ZB9")
						ZB9->(DbGoTo((cAliasZB9)->RECZB9))
						RecLock("ZB9",.F.)
						ZB9->ZB9_ZPEDID := ""
						ZB9->(MsUnlock())
						ZB8->(DbGoTo((cAliasZB9)->RECZB8))
						(cAliasZB9)->(DbSkip())
					EndDo
					(cAliasZB9)->(DbCloseArea())
					//Traz todos as EXPs e altera o status
					BeginSql Alias cAliasZB9
						SELECT ZB9.R_E_C_N_O_ RECZB9, ZB8.R_E_C_N_O_ RECZB8
						FROM %Table:ZB9% ZB9
							INNER JOIN %Table:ZB8% ZB8
							ON 		ZB8.%notDel% AND
							ZB8_FILIAL = %xFilial:ZB8% AND
							ZB8_EXP	   = ZB9_EXP AND
							ZB8_SUBEXP = ZB9_SUBEXP AND
							ZB8_ANOEXP = ZB9_ANOEXP
						WHERE 	ZB9.%notDel% AND
							ZB9_FILIAL 	= %xFilial:ZB9% AND
							ZB9_EXP		= %Exp:EE7->EE7_ZEXP% AND
							ZB9_SUBEXP	= %Exp:EE7->EE7_ZSUBEX% AND
							ZB9_ANOEXP	= %Exp:EE7->EE7_ZANOEX% AND
							ZB9_ZPEDID	<> ' '
						EndSql
						If (cAliasZB9)->(Eof())
							RecLock("ZB8",.F.)
							ZB8->ZB8_MOTEXP := iif(ZB8->ZB8_MOTEXP == '2','6','4')
							ZB8->ZB8_PEDFAT := SPACE(06)  //wvn 220720
							ZB8->(MsUnlock())
						EndIf
					EndIf
					(cAliasZB9)->(DbCloseArea())
					ZB8->(RestArea(aAliasZB8))
					ZB9->(RestArea(aAliasZB9))
				EndIf
				return .t.

/*
=====================================================================================
Programa............: xLetLSeq
Autor...............: Joni Lima
Data................: 30/05/2017
Descrição / Objetivo: Encontra a Letra Apartir de uma String contendo um numero
=====================================================================================
*/
Static function xLetLSeq(cNum)

	Local cRet 		:= ''
	Local cLtrEsq	:= ''
	Local cLtrDir	:= ''

	Local nNum := val(cNum) - 1

	cLtrEsq := Char( INT(nNum / 26) + 65 )
	cLtrDir := Char( INT(MOD(nNum,26)) + 65 )

	cRet := cLtrEsq + cLtrDir

return cRet

/*
=====================================================================================
Programa............: xMGF24Mot
Autor...............: Joni Lima
Data................: 30/05/2017
Descrição / Objetivo: Realiza a Validação do Campo ZB8_MOTSIT
=====================================================================================
*/
User function xMGF24Mot()

	Local cIdioma := IIF(!Empty(FwFldGet("ZB8_IDIOMA")),FwFldGet("ZB8_IDIOMA"),"")

return ExistCpo("EE4",FwFldGet("ZB8_MOTSIT") + '1-Descricao de Situacao  ' )


/*/{Protheus.doc} xHas24
//TODO Está na geração de pedido via job?
@author leonardo.kume
@since 04/06/2017
@version 6

@type function
/*/
User Function ValidZB8(nOpc)

	Local lRet := .t.
	If nOpc == 1
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_CONSIG+IF(!Empty(M->ZB8_COLOJA),M->ZB8_COLOJA,"")),1,1) $ "2/4"
			ApMsgAlert("Consignee não existe.")
			lRet := .F.
		EndIf
	ElseIf nOpc == 2
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_ZIMSAN+IF(!Empty(M->ZB8_ZLJSAN),M->ZB8_ZLJSAN,"")),1,1) $ "2/4"
			ApMsgAlert("Importador Sanitário não existe.")
			lRet := .F.
		EndIf
	ElseIf nOpc == 3
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_ZNOTIF+IF(!Empty(M->ZB8_ZLJNOT),M->ZB8_ZLJNOT,"")),1,1) $ "2/4"
			ApMsgAlert("Notify não existe.")
			lRet := .F.
		EndIf
	ElseIf nOpc == 4
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_CONSIG+IF(!Empty(M->ZB8_COLOJA),M->ZB8_COLOJA,"")),1,1) $ "2/4"
			ApMsgAlert("Consignee não existe.")
			lRet := .F.
		EndIf
	ElseIf nOpc == 5
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_ZIMSAN+IF(!Empty(M->ZB8_ZLJSAN),M->ZB8_ZLJSAN,"")),1,1) $ "2/4"
			ApMsgAlert("Importador Sanitário não existe.")
			lRet := .F.
		EndIf
	ElseIf nOpc == 6
		If !SUBSTR(GetAdvFVal("SA1","A1_TIPCLI",XFILIAL("SA1")+M->ZB8_ZNOTIF+IF(!Empty(M->ZB8_ZLJNOT),M->ZB8_ZLJNOT,"")),1,1) $ "2/4"
			ApMsgAlert("Notify não existe.")
			lRet := .F.
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} xAdic24
//TODO Rotina para gerar cadastros adicionais Pedido de Exportação
@author leonardo.kume
@since 13/06/2017
@version 6

@type function
/*/
User Function xAdic24()
	Local cCompl 	:= ""
	Local lRet 		:= .T.
	Local nComis	:= 0
	Local nMoeda	:= 0
	Local lRelck	:= .T.

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(XFILIAL("SA1")+EE7->EE7_ZNOTIF+EE7->EE7_ZLJNOT))
		cCompl := AllTrim(SA1->A1_BAIRRO)
		If !Empty(AllTrim(SA1->A1_MUN))
			cCompl += IIF(!Empty(cCompl)," - ","")+AllTrim(SA1->A1_BAIRRO)
		EndIf
		If !Empty(AllTrim(SA1->A1_CEP))
			cCompl += IIF(!Empty(cCompl)," - ","")+AllTrim(SA1->A1_CEP)
		EndIf
		If !Empty(AllTrim(SA1->A1_ESTADO))
			cCompl += IIF(!Empty(cCompl)," - ","")+AllTrim(SA1->A1_ESTADO)
		EndIf
		If !Empty(AllTrim(SA1->A1_PAIS))
			cCompl += IIF(!Empty(cCompl)," - ","")+AllTrim(GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+SA1->A1_PAIS,1,""))
		EndIf
		DbSelectArea("EEN")
		EEN->(DbSetOrder(1))
		lRelck := EEN->(DbSeek(xFilial("EEN")+PADR(EE7->EE7_PEDIDO,20)+"P"+SA1->A1_COD+SA1->A1_LOJA))
		RecLock("EEN",!lRelck)
		EEN->EEN_FILIAL := xFilial("EEN")
		EEN->EEN_PROCES := EE7->EE7_PEDIDO
		EEN->EEN_OCORRE := "P"
		EEN->EEN_IMPORT := SA1->A1_COD
		EEN->EEN_IMLOJA := SA1->A1_LOJA
		EEN->EEN_IMPODE := SA1->A1_NOME
		EEN->EEN_ENDIMP := SA1->A1_END
		EEN->EEN_END2IM := cCompl
		EEN->(MsUnlock())
	EndIf
	DbSelectArea("SY5")
	SY5->(DbSetOrder(1))
	If SY5->(DbSeek(XFILIAL("SY5")+EE7->EE7_ZARMAD))
		DbSelectArea("EEB")
		EEB->(DbSetOrder(1))
		lRelck := EEB->(DbSeek(xFilial("EEB")+PADR(EE7->EE7_PEDIDO,20)+"P"+SY5->Y5_COD+SY5->Y5_TIPOAGE+"2"))
		RecLock("EEB",!lRelck)
		EEB->EEB_FILIAL := xFilial("EET")
		EEB->EEB_CODAGE := SY5->Y5_COD
		EEB->EEB_PEDIDO := EE7->EE7_PEDIDO
		EEB->EEB_TIPOAG := SY5->Y5_TIPOAGE
		EEB->EEB_NOME	:= SY5->Y5_NOME
		EEB->EEB_OCORRE := "P"
		EEB->EEB_TIPCOM := "2"
		EEB->EEB_TIPCVL := "1"
		EEB->EEB_FORNEC := SY5->Y5_FORNECE
		EEB->EEB_LOJAF	:= SY5->Y5_LOJAF
		EEB->(MsUnlock())
	EndIf
	DbSelectArea("SY5")
	SY5->(DbSetOrder(1))
	If SY5->(DbSeek(XFILIAL("SY5")+EE7->EE7_XAGEMB))
		DbSelectArea("EEB")
		EEB->(DbSetOrder(1))
		lRelck := EEB->(DbSeek(xFilial("EEB")+PADR(EE7->EE7_PEDIDO,20)+"P"+SY5->Y5_COD+SY5->Y5_TIPOAGE+"2"))
		RecLock("EEB",!lRelck)
		EEB->EEB_FILIAL := xFilial("EET")
		EEB->EEB_CODAGE := SY5->Y5_COD
		EEB->EEB_PEDIDO := EE7->EE7_PEDIDO
		EEB->EEB_TIPOAG := SY5->Y5_TIPOAGE
		EEB->EEB_NOME	:= SY5->Y5_NOME
		EEB->EEB_OCORRE := "P"
		EEB->EEB_TIPCOM := "2"
		EEB->EEB_TIPCVL := "1"
		EEB->EEB_FORNEC := SY5->Y5_FORNECE
		EEB->EEB_LOJAF	:= SY5->Y5_LOJAF
		EEB->(MsUnlock())
	EndIf

	DbSelectArea("SY5")
	SY5->(DbSetOrder(1))
	If SY5->(DbSeek(xFilial("SY5")+EE7->EE7_ZAGENT))

		DbSelectArea("ZB8")
		DbSetOrder(3)
		DbSeek(xFilial("ZB8")+Padr(AllTrim(EE7->EE7_ZEXP),9)+EE7->EE7_ZANOEX+EE7->EE7_ZSUBEX)

		If ZB8->ZB8_TIPCOM = "1" // Percentual.
			nComis  := Round(EE7->EE7_TOTPED*(ZB8->ZB8_VALCOM/100),2)
		ElseIf ZB8->ZB8_TIPCOM = "2" // Valor Fixo.
			nComis  := ZB8->ZB8_VALCOM
		Else // Percentual por item.
			nComis  := 0
		EndIf

		DbSelectArea("EEB")
		EEB->(DbSetOrder(1))
		lRelck := EEB->(DbSeek(xFilial("EEB")+PADR(EE7->EE7_PEDIDO,20)+"P"+SY5->Y5_COD+SY5->Y5_TIPOAGE+"2"))

		RecLock("EEB",!lRelck)
		EEB->EEB_FILIAL := xFilial("EEB")
		EEB->EEB_CODAGE := EE7->EE7_ZAGENT
		EEB->EEB_PEDIDO	:= EE7->EE7_PEDIDO
		EEB->EEB_TIPOAG	:= SY5->Y5_TIPOAGE
		EEB->EEB_NOME 	:= SY5->Y5_NOME
		EEB->EEB_TXCOMI := 0
		EEB->EEB_OCORRE := "P"
		EEB->EEB_TIPCOM := ZB8->ZB8_TIPCOM
		EEB->EEB_TIPCVL := ZB8->ZB8_TIPCVL
		EEB->EEB_VALCOM := ZB8->ZB8_VALCOM
		EEB->EEB_FOBAGE := EE7->EE7_TOTPED
		EEB->EEB_TOTCOM := nComis
		EEB->EEB_REFAGE := ZB8->ZB8_REFAGE
		EEB->EEB_FORNEC := SY5->Y5_FORNECE
		EEB->EEB_LOJAF  := SY5->Y5_LOJAF
		EEB->(MsUnlock())

		DbSelectArea("EE8")
		DbSetOrder(1)
		If DbSeek(xFilial("EE8")+Padr(AllTrim(EE7->EE7_PEDIDO),20))
			While !EE8->(Eof()) .AND. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO .AND. EE7->EE7_FILIAL == EE8->EE8_FILIAL
				RecLock("EE8",.F.)
				EE8->EE8_FILIAL := xFilial("EEN")
				EE8->EE8_CODAGE := EE7->EE7_ZAGENT
				EE8->EE8_PERCOM := ZB8->ZB8_VALCOM
				EE8->EE8_VLCOM 	:= EE8->EE8_PRCTOT * (ZB8->ZB8_VALCOM / 100)
				EE8->EE8_TIPCOM := ZB8->ZB8_TIPCOM
				EE8->(MsUnlock())
				EE8->(DbSkip())
			EndDo
		EndIf
	EndIf

	If EE7->EE7_ZVL > 0
		nMoeda := GetAdvFVal("SYQ","YQ_MOEFAT",xFilial("SYQ")+EE7->EE7_MOEDA,1,0)
		nMoeda := xMoeda(EE7->EE7_ZVL,nMoeda,1,ddatabase,8)
		RecLock("EEQ",.T.)
		EEQ->EEQ_FILIAL := xFilial("EEQ")
		EEQ->EEQ_PREEMB := EE7->EE7_PEDIDO
		EEQ->EEQ_EVENT	:= "602"
		EEQ->EEQ_PARC	:= "01"
		EEQ->EEQ_VCT	:= ddatabase
		EEQ->EEQ_MOEDA	:= EE7->EE7_MOEDA
		EEQ->EEQ_VL		:= EE7->EE7_ZVL
		EEQ->EEQ_DTCE	:= EE7->EE7_ZDTCE
		EEQ->EEQ_DECAM	:= "2"
		EEQ->EEQ_TX		:= nMoeda
		EEQ->EEQ_EQVL	:= nMoeda * EE7->EE7_ZVL
		EEQ->EEQ_FASE	:= "P"
		EEQ->EEQ_TIPO	:= "A"
		EEQ->EEQ_SALDO 	:= EE7->EE7_ZVL
		EEQ->EEQ_IMPORT := EE7->EE7_IMPORT
		EEQ->EEQ_IMLOJA	:= EE7->EE7_IMLOJA
		EEQ->EEQ_TP_CON	:= "1"
		EEQ->EEQ_CONTMV	:= "1"
		EEQ->EEQ_HVCT	:= EE7->EE7_ZDTCE
		EEQ->EEQ_MODAL	:= "1"
		EEQ->EEQ_MOTIVO	:= "NOR"

		EEQ->(MsUnlock())
	EndIf

Return lRet

Static Function ShowError(cMemo)
	Local oDlg
	Local cMemo
	Local cFile    :=""
	Local oFont

	DEFINE FONT oFont NAME "Courier New" SIZE 7,14   //6,15

	DEFINE MSDIALOG oDlg TITLE "Erro ao gerar Pedido de Exportação" From 3,0 to 340,550 PIXEL

	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 267,145 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,230 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga

	ACTIVATE MSDIALOG oDlg CENTER

Return

/*/{Protheus.doc} xM24GFam
//TODO Preenchimento da familia Grupo e tipo de produto na linha do orçamento
@author leonardo.kume
@since 25/08/2017
@version 6

@type function
/*/
User function xM24GFam(cValor,nOpc)

	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9	:= oModel:GetModel('ZB9DETAIL')

	Local ni		:= 1
	Local aFamilia	:= {oMdlZB8:GetValue('ZB8_ZTPROD'),;
		oMdlZB8:GetValue('ZB8_ZFAMIL'),;
		oMdlZB8:GetValue('ZB8_ZNEGOC'),;
		oMdlZB8:GetValue('ZB8_ZDTPRO'),;
		oMdlZB8:GetValue('ZB8_ZDTPRE'),;
		oMdlZB8:GetValue('ZB8_OPER'),;
		oMdlZB8:GetValue('ZB8_DTPREM'),;
		oMdlZB8:GetValue('ZB8_DTENTR'),;
		oMdlZB8:GetValue('ZB8_TES'),;
		oMdlZB8:GetValue('ZB8_CF'),;
		oMdlZB8:GetValue('ZB8_PERC')}

	Default nOpc := 0


	For ni:=1 to oMdlZB9:Length()
		oMdlZB9:GoLine(ni)
		If !Empty(AllTrim(aFamilia[1])) .OR. nOpc == 1
			oMdlZB9:SetValue('ZB9_FPCOD',AllTrim(aFamilia[1]))
		EndIf
		If !Empty(AllTrim(aFamilia[2])) .OR. nOpc == 2
			oMdlZB9:SetValue('ZB9_DPCOD',AllTrim(aFamilia[2]))
		EndIf
		If !Empty(AllTrim(aFamilia[3])) .OR. nOpc == 3
			oMdlZB9:SetValue('ZB9_GPCOD',AllTrim(aFamilia[3]))
		EndIf
		If !Empty(aFamilia[4]) .OR. nOpc == 4
			oMdlZB9:SetValue('ZB9_ZDTMIN',aFamilia[4])
		EndIf
		If !Empty(aFamilia[5]) .OR. nOpc == 5
			oMdlZB9:SetValue('ZB9_ZDTMAX',aFamilia[5])
		EndIf
		If !Empty(AllTrim(aFamilia[6])) .OR. nOpc == 6
			oMdlZB9:SetValue('ZB9_OPER',AllTrim(aFamilia[6]))
		EndIf
		If !Empty(aFamilia[7]) .OR. nOpc == 7
			oMdlZB9:SetValue('ZB9_DTPREM',aFamilia[7])
		EndIf
		If !Empty(aFamilia[8]) .OR. nOpc == 8
			oMdlZB9:SetValue('ZB9_DTENTR',aFamilia[8])
		EndIf
		If !Empty(AllTrim(aFamilia[9])) .OR. nOpc == 9
			oMdlZB9:SetValue('ZB9_TES',AllTrim(aFamilia[9]))
		EndIf
		If !Empty(AllTrim(aFamilia[10])) .OR. nOpc == 10
			oMdlZB9:SetValue('ZB9_CF',AllTrim(aFamilia[10]))
		EndIf
		If aFamilia[11] > 0 .OR. nOpc == 11
			If oMdlZB8:GetValue('ZB8_INTERM') == "1"
				If oMdlZB9:GetValue('ZB9_PRENEG') > 0
					oMdlZB9:LoadValue('ZB9_PRECO',oMdlZB9:GetValue('ZB9_PRENEG')-(oMdlZB9:GetValue('ZB9_PRENEG')*aFamilia[11]/100))
				EndIf
			ElseIf oMdlZB8:GetValue('ZB8_INTERM') == "2"
				If oMdlZB9:GetValue('ZB9_PRENEG') > oMdlZB9:GetValue('ZB9_PRECO')
					oMdlZB9:LoadValue('ZB9_PRECO',oMdlZB9:GetValue('ZB9_PRENEG'))
					oMdlZB9:LoadValue('ZB9_PRENEG',0)
				Else
					oMdlZB9:LoadValue('ZB9_PRENEG',0)
				EndIf
			EndIf
		EndIf
	Next ni

	oMdlZB9:GoLine(1)
	oView:Refresh()

return cValor

/*/{Protheus.doc} xM24GFam
//TODO Preenchimento da familia Grupo e tipo de produto na linha do orçamento
@author leonardo.kume
@since 25/08/2017
@version 6

@type function
/*/
User function xM241Fam(cValor,nOpc)

	Local ni		:= WORKIT->(Recno())
	Local aFamilia	:= {M->EE7_ZTPROD,;
		M->EE7_ZFAMIL,;
		M->EE7_ZNEGOC}

	Default nOpc := 0

	WORKIT->(DbGoTop())
	While !WORKIT->(Eof())
		If !Empty(AllTrim(aFamilia[1]))  .OR. nOpc == 1
			WORKIT->EE8_FPCOD := AllTrim(aFamilia[1])
		EndIf
		If !Empty(AllTrim(aFamilia[2])) .OR. nOpc == 2
			WORKIT->EE8_DPCOD := AllTrim(aFamilia[2])
		EndIf
		If !Empty(AllTrim(aFamilia[3])) .OR. nOpc == 3
			WORKIT->EE8_GPCOD := AllTrim(aFamilia[3])
		EndIf
		WORKIT->(DbSkip())
	EndDo

return cValor

/*/{Protheus.doc} xM24GFam
//TODO Preenchimento da familia Grupo e tipo de produto na linha do orçamento
@author leonardo.kume
@since 25/08/2017
@version 6

@type function
/*/
User function xM242Fam(cValor,nOpc)

	Local ni		:= WORKIP->(Recno())
	Local aFamilia	:= {M->EEC_ZTPROD,;
		M->EEC_ZFAMIL,;
		M->EEC_ZNEGOC}

	Default nOpc := 0

	WORKIP->(DbGoTop())
	While !WORKIP->(Eof())
		If !Empty(AllTrim(aFamilia[1])) .or. nOpc == 1
			WORKIP->EE9_FPCOD := AllTrim(aFamilia[1])
		EndIf
		If !Empty(AllTrim(aFamilia[1])) .or. nOpc == 1
			WORKIP->EE9_ZDTPPR := GetAdvFVal("SYC","YC_NOME",xFilial("SYC")+M->EEC_IDIOMA+AllTrim(aFamilia[1]),4,"")
		EndIf
		If !Empty(AllTrim(aFamilia[2])) .or. nOpc == 2
			WORKIP->EE9_GPCOD := AllTrim(aFamilia[2])
		EndIf
		If !Empty(AllTrim(aFamilia[2])).or. nOpc == 2
			WORKIP->EE9_ZDFAMI := GetAdvFVal("EEH","EEH_NOME",xFilial("EEH")+M->EEC_IDIOMA+AllTrim(aFamilia[2]),1,"")
		EndIf
		If !Empty(AllTrim(aFamilia[3])) .or. nOpc == 3
			WORKIP->EE9_DPCOD := AllTrim(aFamilia[3])
		EndIf
		If !Empty(AllTrim(aFamilia[3])).or. nOpc == 3
			WORKIP->EE9_ZNNEGO := GetAdvFVal("EEG","EEG_NOME",xFilial("EEG")+M->EEC_IDIOMA+AllTrim(aFamilia[3]),1,"")
		EndIf
		WORKIP->(DbSkip())
	EndDo

return cValor

//------------------------------------------------------------------
// Gatilho para GENSET
//------------------------------------------------------------------
user function GENSE24(cFldAt, xValDef)
	local xRetDef		:= xValDef
	local cSY9Genset	:= "" //Porto
	local cSA1Genset	:= "" // Cliente
	local cSYCGenset	:= "" //familia
	local cSB1Gense		:= "" ////Produto
	local cSYCGense2	:= "" //FAMILIA
	local cSYQGense		:= "" //VIA
	local cZBMGenset	:= "" //
	local cMotGenset	:= ""
	Local oModel		:= FwModelActive()
	Local oMdlZB8		:= oModel:GetModel('ZB8MASTER')
	Local oMdlZB9		:= oModel:GetModel('ZB9DETAIL')
	Local nAtu			:= oMdlZB9:getline()

	oMdlZB8:setValue("ZB8_ZGENSE", "N")
	oMdlZB8:setValue("ZB8_ZMTGEN", "")

	cSY9Genset	:= getAdvFVal( "SY9", "Y9_ZGENSET"	, xFilial("SY9") + oMdlZB8:getValue("ZB8_DEST")										, 2, "" ) // DESTINO
	cSA1Genset	:= getAdvFVal( "SA1", "A1_ZGENSET"	, xFilial("SA1") + oMdlZB8:getValue("ZB8_IMPORT") + oMdlZB8:getValue("ZB8_IMLOJA")	, 1, "" ) // CLIENTE
	cSYCGenset	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + oMdlZB8:getValue("ZB8_ZTPROD")									, 1, "" ) // FAMILIA CABECALHO
	cZBMGenset	:= getAdvFVal( "ZBM", "ZBM_ZGENSE"	, xFilial("ZBM") + oMdlZB8:GetValue("ZB8_ZCODES")									, 1, "" ) // LOCAL ESTUFAGEM
	cSYQGenset	:= getAdvFVal( "SYQ", "YQ_ZGENSET"	, xFilial("SYQ") + oMdlZB8:GetValue("ZB8_VIA")									, 1, "" ) // LOCAL ESTUFAGEM

	/*
	Importador e Familia
	ou
	Porto e Familia
	ou
	Produto e Familia
	*/

	If cSYCGenset == "S"
		cMotGenset += "Familia " + left( AllTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + oMdlZB8:getValue("ZB8_ZTPROD"), 1, "" ) ), 15 )	+ " "
	EndIf

	If cSA1Genset == "S" .AND. cSYCGenset == "S" // Importador e Familia
		oMdlZB8:setValue("ZB8_ZGENSE", "S")
		cMotGenset += "Cliente " + left( AllTrim( getAdvFVal( "SA1", "A1_NOME", xFilial("SA1") + oMdlZB8:getValue("ZB8_IMPORT") + oMdlZB8:getValue("ZB8_IMLOJA")	, 1, "" ) ), 15 )	+ " "
	EndIf

	// Valdir solicitou que o porto seja somente considerado na empresa 01 e retirar regra com familia
	If cSY9Genset == "S" .and. Substr(cFilAnt,1,2) == "01" //.AND. cSYCGenset == "S" // Porto e Familia
		oMdlZB8:setValue("ZB8_ZGENSE", "S")
		cMotGenset += "Destino " + left( AllTrim( getAdvFVal( "SY9", "Y9_DESCR"	, xFilial("SY9") + oMdlZB8:getValue("ZB8_DEST"), 2, "" ) ) ,15 ) + " "
	EndIf

	If cZBMGenset == "S" .AND. cSYCGenset == "S" // Local Estufagem e Familia
		oMdlZB8:setValue("ZB8_ZGENSE", "S")
		cMotGenset += "Local Estufagem " + left( AllTrim( getAdvFVal( "ZBM", "ZBM_DESCRI"	, xFilial("ZBM") + oMdlZB8:GetValue("ZB8_ZCODES"), 1, "" ) ), 15 )				+ " "
	EndIf

	for nI := 1 to oMdlZB9:length()
		oMdlZB9:goLine(nI)
		oMdlZB9:setValue("ZB9_ZGENSE", "N")

		cSB1Gense	:= ""
		cSYCGense2	:= ""

		cSB1Gense	:= getAdvFVal( "SB1", "B1_ZGENSET"	, xFilial("SB1") + oMdlZB9:GetValue( "ZB9_COD_I" )	, 1, "" ) // PRODUTO
		cSYCGense2	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + oMdlZB9:GetValue("ZB9_FPCOD")	, 1, "" ) // FAMILIA ITEM

		If cSB1Gense == "S"
			oMdlZB9:LoadValue('ZB9_ZGENSE', 'S')
		EndIf

		If cSB1Gense == "S" .AND. cSYCGense2 == "S"
			cMotGenset += "Item " + AllTrim( oMdlZB9:GetValue( "ZB9_COD_I" ) )
			cMotGenset += " e familia " + left( AllTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + oMdlZB9:getValue("ZB9_FPCOD"), 1, "" ) ), 15 ) + " "

			oMdlZB8:setValue("ZB8_ZGENSE", "S")
		EndIf
		If cSB1Gense == "S" .AND. cSYQGenset == "S"
			cMotGenset += "Item " + AllTrim( oMdlZB9:GetValue( "ZB9_COD_I" ) )
			cMotGenset += " e Via " + left( AllTrim( getAdvFVal( "SYQ", "YQ_DESCR"	, xFilial("SYC") + oMdlZB8:getValue("ZB8_VIA"), 1, "" ) ), 15 ) + " "

			oMdlZB8:setValue("ZB8_ZGENSE", "S")
		EndIf
	next

	If oMdlZB8:getValue("ZB8_ZGENSE") == "S" .AND. !Empty(cMotGenset)
		oMdlZB8:setValue("ZB8_ZMTGEN", left(cMotGenset, TAMSX3("ZB8_ZMTGEN")[1])	)
	EndIf

	oMdlZB9:GoLine(nAtu)
return xRetDef

/*/{Protheus.doc} SplitHilton
//TODO Divide os itens do pedido para Hilton e Não Hilton
@author leonardo.kume
@since 12/11/2017
@version 6
@return retorna se foi criado itens para Hilton e Não Hilton
@param aItens, array, Todos os itens da EXP
@param aItensNH, array, Itens Não Hilton
@param aItensH, array, Itens Hilton
@type function
/*/
Static Function SplitHilton(aItens,aItensNH,aItensH)

	Local nHilton 	:= aScan(aItens[1] ,{|x| x[1] == "EE8_ZHILTO"})
	Local nI		:= 0

	aItensNH 	:= {}
	aItensH 	:= {}

	If nHilton > 0
		For nI := 1 To Len (aItens)
			nHilton 	:= aScan(aItens[nI] ,{|x| x[1] == "EE8_ZHILTO"})
			If aItens[nI][nHilton][2] == "1"//Hilton
				aAdd(aItensH,aClone(aItens[ni]))
			Else
				aAdd(aItensNH,aClone(aItens[ni]))
			EndIf
		Next nI
	EndIf

Return Len(aItensNH)>0 .and. Len(aItensH)>0


/*/{Protheus.doc} xPedVen
//TODO Geração de Pedido de Venda
@author leonardo.kume
@since 25/01/2018
@version 6
@return Se PV gerado.

@type function
/*/
Static function xPedVen()
    local cError     := ''
	Local lContExec  := .T.

	Local aAreaZB8 	:= ZB8->(GetArea())
	Local aAreaZB9 	:= ZB9->(GetArea())

	Local aFldZB8 	:= xPrepX3("ZB8")
	Local aFldZB9 	:= xPrepX3("ZB9")
	Local aFldEE7 	:= xPrepX3("EE7")
	Local aFldEE8 	:= xPrepX3("EE8")

	Local aCabec	:= {}
	Local aItens	:= {}
	Local aItem		:= {}

	Local aPedDados := {}

	Local aCpBranco := {}
	Local aRet		:= {}

	Local cFilA := cFilAnt
	Local cFilB := AllTrim(ZB8->ZB8_FILVEN)//aCabec[AScan(aCabec,{|x| x[1] == "EE7_FILIAL"})][2]

	Local cxMsg 	:= ''
	Local cPed		:= ''
	Local lGrvStt	:= .T.
	Local lPedOk 	:= .F.
	Local cI		:= "01"
	Local nPV  := Space(06)
	Local cObs := " "
	Local cSuc := " "

	Private aRet	:= .F.

	ProcRegua(0)

    //Reserva o número do Pedido de Vendas
	nPV := GetSxeNum("SC5","C5_NUM")

	//Função Converte Memo em Caracter
	cObs := ZB8->(ZB8_ZOBSND)  // + ZB8_ZOBS

	If !Empty(cFilB)

		aadd(aCabec,{"C5_FILIAL"   	,cFilB,Nil})
		aadd(aCabec,{"C5_NUM"   	,nPV,Nil})
		aadd(aCabec,{"C5_TIPO" 		,"N",Nil})
		aadd(aCabec,{"C5_CLIENTE"	,ZB8->ZB8_IMPORT,Nil})
		aadd(aCabec,{"C5_LOJACLI"	,ZB8->ZB8_IMLOJA,Nil})
		aadd(aCabec,{"C5_LOJAENT"	,ZB8->ZB8_IMLOJA,Nil})
		Posicione("SA1",1,xFilial("SA1")+ZB8->(ZB8_IMPORT+ZB8_IMLOJA),"A1_NOME")
		aadd(aCabec,{"C5_XNOMECLI"	,SA1->A1_NOME,Nil})
		aadd(aCabec,{"C5_XENDENT"	,SA1->A1_END,Nil})
		aadd(aCabec,{"C5_MSBLQL"	,"2",Nil})
		aadd(aCabec,{"C5_CLIENT"	,ZB8->ZB8_IMPORT,Nil})
		aadd(aCabec,{"C5_TIPOCLI"	,"X",Nil})
		aadd(aCabec,{"C5_CONDPAG"	,GetAdvFVal("SY6","Y6_MDPGEXP",xFilial("SY6")+ZB8->ZB8_CONDPA,1,""),Nil})
		aadd(aCabec,{"C5_ZOBSND"	,AllTrim(cObs),Nil})   //era ZB8->(ZB8_ZOBSND + ZB8_ZOBS)
		aadd(aCabec,{"C5_ZTIPPED"	,ZB8->ZB8_ZTIPPE,Nil})
		aadd(aCabec,{"C5_TABELA"	,ZB8->ZB8_TABELA,Nil})
		aadd(aCabec,{"C5_TPFRETE"	,ZB8->ZB8_ZFREFA,Nil})
		aadd(aCabec,{"C5_FRETE"		,ZB8->ZB8_FRPREV,Nil})
		aadd(aCabec,{"C5_SEGURO"	,ZB8->ZB8_SEGPRE,Nil})

		Begin Transaction
			//Prepara Itens ZB9
			dbSelectArea('ZB9')
			ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUENC
			If ZB9->(dbSeek(xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
				While ZB9->(!EOF()).and. ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
					IncProc()
					aItem := {}
					cI := SOMA1(cI)
					aadd(aItem,{"C6_ITEM",cI,Nil})
					aadd(aItem,{"C6_PRODUTO",ZB9->ZB9_COD_I,Nil})
					Posicione("SB1",1,xFilial("SB1")+ZB9->ZB9_COD_I,"B1_DESC")
					aadd(aItem,{"C6_DESCRI",SB1->B1_DESC,Nil})
					aadd(aItem,{"C6_UM",SB1->B1_UM,Nil})
					aadd(aItem,{"C6_QTDVEN",ZB9->ZB9_SLDINI,Nil})
					aadd(aItem,{"C6_PRCVEN",ZB9->ZB9_PRECO,Nil})
					aadd(aItem,{"C6_PRUNIT",ZB9->ZB9_PRECO,Nil})
					aadd(aItem,{"C6_TES",ZB9->ZB9_TES,Nil})
					aadd(aItem,{"C6_CF",ZB9->ZB9_CF,Nil})
					aadd(aItens,aItem)
					RecLock("ZB9",.F.)
					ZB9->ZB9_FATIT	:= cI
					ZB9->(MsUnlock())
					ZB9->(dbSkip())
				EndDo
			EndIf

			aRet := StartJob("u_xGerVen",GetEnvServer(),.T.,aCabec,aItens,cFilB)

			If !aRet[1]
				RecLock("ZB8",.F.)
				ZB8->ZB8_PEDFAT := aRet[2]
				ZB8->ZB8_MOTEXP	:= "7"
				ZB8->(MsUnlock())				
				cSuc := 'Pedido Gerado Com Sucesso: ' + aRet[2]

				U_TMSENVEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela, 1 )
				
				ApMsgInfo(cSuc,"Pedido Gerado")
			Else
				DisarmTransaction()
				If (!IsBlind()) // COM INTERFACE GRÁFICA
				MostraErro()
			    Else // EM ESTADO DE JOB
			        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

			        ConOut(PadC("Automatic routine ended with error", 80))
			        ConOut("Error: "+ cError)
			    EndIf
			EndIf
		End Transaction
	EndIf

return

//Gera o pedido na filial distribuida
User Function xGerVen(aCabec,aItens,cFil)

	Local aRet		:= {}
	Private lMsErroAuto := .f.
	Private lMsHelpAuto	:= .f.

	RpcSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA( '01' ) FILIAL ( cFil ) MODULO ( 'EEC' ) TABLES "EE7", "EE8", "SX6"

	MATA410(aCabec,aItens,3)

	aAdd(aRet,lMsErroAuto)
	aAdd(aRet,SC5->C5_NUM)

	RESET ENVIRONMENT

Return aRet

User Function EEC24CAD()

	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

	If 	cParam ==  "MARKS"
		cMemo := GetAdvFVal("ZB8","ZB8_MARCAC",xFilial("ZB8")+M->(PADR(EE7_ZEXP,9)+EE7_ZANOEX+EE7_ZSUBEX),3,"")
	EndIf

return cMemo

User Function IsExport(cNum)
	Local lRet := .f.
	Local cAliasZB8 := GetNextAlias()

	BeginSQL Alias cAliasZB8
		SELECT '*' EXIST
		FROM %Table:ZB8%
		WHERE 	%NotDel% AND
			ZB8_FILIAL = %xFilial:ZB8% AND
			ZB8_PEDFAT = %Exp:cNum% AND
			ZB8_EXP <> ' ' AND
			ZB8_ANOEXP <> ' '
		EndSQL

		lRet := !(cAliasZB8)->(Eof())


		Return lRet


/*/{Protheus.doc} ZB8Recno
//TODO Conhecimento EXP
@author leonardo.kume
@since 12/04/2018
@version 6

@type function
/*/
User Function ZB8Recno()

	MsDocument("ZB8",ZB8->(Recno()),2)

Return .T.

/*/{Protheus.doc} ValidaZB8
//TODO Valida informações da ZB8
@author leonardo.kume
@since 12/04/2018
@version 6
@return boolean, retorno se inclui pedido

@type function
/*/
Static Function ValidaZB8()

	Local aAreaZB8 	:= ZB8->(GetArea())
	Local aAreaZB9 	:= ZB9->(GetArea())
	Local lFrete	:= .F.
	Local lSeguro	:= .F.
	Local lRet		:= .T.
	Local cRet		:= ""
	Local lValInt	:= GetMv("MGF_24INT",,.T.) //Desliga validações do Offshore
	Local lValFret	:= GetMv("MGF_24FRT",,.T.) //Desliga validações do frete e seguro

	Local _lMEEC24C := GetMv("MGF_EEC24C",,.T.) //Habilita validação cpo ZB8_ZMUNDI Cidade de Divisa. Precisa replicar p/ EE7

	If lValZWee	.AND.	ZB8->ZB8_ZWEEKD == "  /    "	// RVBJ
		lRet := .F.
		cRet += iif(!Empty(Alltrim(cRet)),CRLF,"")
		cRet += "Week De na aba PCP nao esta preenchido."
	EndIf

//-- Inicio Valida Dados Offshore
	If lValInt
		If ZB8->ZB8_INTERM == "1"
			DbSelectArea("ZB9")
			ZB9->(DbSetOrder(2))
			If ZB9->(DbSeek(xFilial("ZB9")+AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))))
				While !ZB9->(Eof()) .and. ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_SUBEXP+ZB8_ANOEXP) == ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_SUBEXP+ZB9_ANOEXP)
					lRet := lRet .And. ZB9->ZB9_PRENEG > 0
					If ZB9->ZB9_PRENEG <= 0
						cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
						cRet += "Item "+ ZB9->ZB9_SEQUEN+" está com preço negociado em branco."
					EndIf
					ZB9->(DbSkip())
				EndDo
			EndIf
			If Empty(AllTrim(ZB8->ZB8_CLIENT)) .OR. Empty(AllTrim(ZB8->ZB8_CLLOJA))
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "Cliente na aba Intermediação não está preenchido."
			Else
				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				If !SA1->(DbSeek(xFilial("SA1")+ZB8->ZB8_CLIENT+ZB8->ZB8_CLLOJA))
					lRet := .F.
					cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
					cRet += "Cliente "+ZB8->ZB8_CLIENT+" Loja "+ZB8->ZB8_CLLOJA+" aba Intermediação não existe."
				EndIf
			EndIf
			If Empty(AllTrim(ZB8->ZB8_INCO2))
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "Incoterm na aba Intermediação não está preenchido."
			EndIf
			If Empty(AllTrim(ZB8->ZB8_COND2))
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "Cond.Pagto. na aba Intermediação não está preenchido."
			EndIf
			If Empty(AllTrim(ZB8->ZB8_EXPORT)) .OR. Empty(AllTrim(ZB8->ZB8_EXLOJA))
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "Cod.Export. na aba Intermediação não está preenchido."
			Else
				DbSelectArea("SA2")
				SA2->(DbSetOrder(1))
				If !SA2->(DbSeek(xFilial("SA1")+ZB8->ZB8_EXPORT+ZB8->ZB8_EXLOJA))
					lRet := .F.
					cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
					cRet += "Fornecedor "+ZB8->ZB8_EXPORT+" Loja "+ZB8->ZB8_EXLOJA+" aba Intermediação não existe."
				EndIf
			EndIf
			If ZB8->ZB8_PERC <= 0
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "% OffShore na aba Intermediação está zerado."
			EndIf
		EndIf
	EndIf
//-- Fim Valida Dados Incoterm
	DbSelectArea("SYF")
	DbSetOrder(1)
	If GetAdvFVal("SYF","YF_MOEFAT",xFilial("SYF")+ZB8->ZB8_MOEDA,1,0) == 0
		lRet := .F.
		cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
		cRet += "Moeda Negociada não tem equivalente para o Faturamento."
	EndIf

//-- Inicio Valida Frete e Seguro
	If lValFret
		DbSelectArea("SYJ")
		SYJ->(DbSetOrder(1))
		If SYJ->(DbSeek(xFilial("SYJ")+ZB8->ZB8_INCOTE))
			lFrete	:= SYJ->YJ_CLFRETE == "1"
			lSeguro	:= SYJ->YJ_CLSEGUR == "1"
			If lFrete
				lRet := lRet .And. ZB8->ZB8_FRPREV > 0
				If ZB8->ZB8_FRPREV <= 0
					cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
					cRet += "O Incoterm "+ZB8->ZB8_INCOTE+" digitado prevê lançamento de FRETE"
				EndIf
			EndIf
			If lSeguro
				lRet := lRet .And. (ZB8->ZB8_SEGPRE > 0 .OR. ZB8->ZB8_SEGURO > 0)
				If ZB8->ZB8_SEGPRE <= 0 .and. ZB8->ZB8_SEGURO <= 0
					cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
					cRet += "O Incoterm "+ZB8->ZB8_INCOTE+" digitado prevê lançamento de SEGURO"
				EndIf
			EndIf
		Else
			lRet := .F.
			cRet += "O Incoterm não encotrado"
		EndIf

		//Incoterm
		If ZB8->ZB8_INTERM == "1"
			If SYJ->(DbSeek(xFilial("SYJ")+ZB8->ZB8_INCO2))
				lFrete	:= SYJ->YJ_CLFRETE == "1"
				lSeguro	:= SYJ->YJ_CLSEGUR == "1"
				If lFrete
					lRet := lRet .And. ZB8->ZB8_ZFRETE > 0
					If ZB8->ZB8_ZFRETE <= 0
						cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
						cRet += "O Incoterm da Intermediação "+ZB8->ZB8_INCO2+" digitado prevê lançamento de FRETE"
					EndIf
				EndIf
				If lSeguro
					lRet := lRet .And. ZB8->ZB8_ZSEGUR > 0
					If ZB8->ZB8_ZSEGUR <= 0
						cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
						cRet += "O Incoterm da Intermediação "+ZB8->ZB8_INCO2+" digitado prevê lançamento de SEGURO"
					EndIf
				EndIf
			Else
				lRet := .F.
				cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
				cRet += "O Incoterm da Intermediação não encotrado"
			EndIf
		EndIf
	EndIf
//--- Fim valida Frete e seguro

//---Habilita validação cpo ZB8_ZMUNDI Cidade de Divisa. Precisa replicar p/ EE7
	If _lMEEC24C .And. !(IsInCallStack("U_M24CanZB"))
		If ZB8->(Empty(ZB8_ZMUNDI))
			lRet := .F.
			cRet += iif(!Empty(AllTrim(cRet)),CRLF,"")
			cRet += "Favor inserir o código da cidade de divisa da EXP."
		EndIf
	EndIf
//---Fim validação cpo ZB8_ZMUNDI

	If !Empty(AllTrim(cRet))
		ShowError(AllTrim(cRet))
	EndIf

	ZB8->(RestArea(aAreaZB8))
	ZB9->(RestArea(aAreaZB9))

Return lRet

/*/{Protheus.doc} xAdiant24
//TODO Adiantamento Cliente
@author leonardo.kume
@since 12/04/2018
@version 6
@type function

Obs.: referente a RTASK
/*/
User Function xAdiant24()

	Local aArea		:= GetArea()
	Local lOffShore	:=	Iif(ZB8->ZB8_INTERM=="2",.F.,MsgYesNo("EXP OffShore : Adiantamento na Empresa 90 ? ","Processo OffShore !!"))
	Local cFilBkp	:=	cFilAnt
	Local aAreaSM0	:=	""

	If (lOffShore)	// RVBJ
		
		DbSelectArea("EE7")
		EE7->(DbSetOrder(1))
		
		cFilAnt		:=	"900001"
		aAreaSM0	:=	SM0->( GetArea() )
		
		SM0->(DbSeek("01"+cFilAnt)) //é utilizado o 01, por grupo de empresas, caso necessário rotina pode ser adaptada
		
		If EE7->(DbSeek(XFILIAL("EE7")+ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))))
			AP100ADIAN()
		Else
			ApMsgAlert("Processo de Exportação (EE7) não existe.")
		Endif
		
		cFilAnt	:=	cFilBkp
		RestArea(aAreaSM0)

	Else

		DbSelectArea("SA1")
		DbSetOrder(1)
		SA1->(DbSeek(xFilial("SA1")+ZB8->ZB8_IMPORT+ZB8->ZB8_IMLOJA))
		AC100ADIAN()
	
	Endif

	RestArea(aArea)

Return

/*/{Protheus.doc} ExPedido
//TODO Tentativa de gravação caso retorne erro e o pedido foi gravado
@author leonardo.kume
@since 12/04/2018
@version 6
@type function
@param cFilB, caracter, filial
@param lStatus, boolean, status.
/*/
Static Function ExPedido(cFilB,lStatus)

	Local lGravPedido	:= .F.
	Default cFilB		:= ZB8->ZB8_FILVEN
	Default lStatus		:= .T.

	DbSelectArea("EE7")
	EE7->(DbSetOrder(1))
	If EE7->(DbSeek(cFilB+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")+IIF(!lStatus,"("+SubStr(ZB8->ZB8_FILVEN,5,2)+")","") ))
		RecLock('EE7',.F.)
		EE7->EE7_INCO2	:= ZB8->ZB8_INCO2
		EE7->EE7_DIAS2	:= ZB8->ZB8_DIAS2
		EE7->EE7_COND2	:= ZB8->ZB8_COND2
		EE7->(MsUnlock())
		lGravPedido	:= .T.
	EndIf
	If EE7->(DbSeek(GetMv("MV_AVG0024",,"900001")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")+IIF(!lStatus,"("+SubStr(ZB8->ZB8_FILVEN,5,2)+")","")))
		RecLock('EE7',.F.)
		EE7->EE7_INCOTE	:= ZB8->ZB8_INCO2
		EE7->EE7_DIASPA	:= ZB8->ZB8_DIAS2
		EE7->EE7_CONDPA	:= ZB8->ZB8_COND2
		EE7->(MsUnlock())
	EndIf
	If ZB8->ZB8_ZHILTO == "1"
		If EE7->(DbSeek(cFilB+ZB8->ZB8_EXP+'H'+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")+IIF(!lStatus,"("+SubStr(ZB8->ZB8_FILVEN,5,2)+")","")))
			RecLock('EE7',.F.)
			EE7->EE7_INCO2	:= ZB8->ZB8_INCO2
			EE7->EE7_DIAS2	:= ZB8->ZB8_DIAS2
			EE7->EE7_COND2	:= ZB8->ZB8_COND2
			EE7->(MsUnlock())
			lGravPedido	:= .T.
		EndIf
		If EE7->(DbSeek(GetMv("MV_AVG0024",,"900001")+ZB8->ZB8_EXP+'H'+ZB8->ZB8_ANOEXP+IIF(!Empty(AllTrim(ZB8->ZB8_SUBEXP)),ZB8->ZB8_SUBEXP,"")+IIF(!lStatus,"("+SubStr(ZB8->ZB8_FILVEN,5,2)+")","")))
			RecLock('EE7',.F.)
			EE7->EE7_INCOTE	:= ZB8->ZB8_INCO2
			EE7->EE7_DIASPA	:= ZB8->ZB8_DIAS2
			EE7->EE7_CONDPA	:= ZB8->ZB8_COND2
			EE7->(MsUnlock())
		EndIf
	EndIf

	If lStatus
		If lGravPedido
			//Salva Pedido ZB9
			dbSelectArea('ZB9')
			ZB9->(dbSetOrder(2))//ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP+ZB9_SEQUENC
			If ZB9->(dbSeek(xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
				While ZB9->(!EOF()).and. ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == xFilial('ZB9') + ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
					If ZB8->ZB8_ZHILTO == "1"
						If ZB9->ZB9_ZHILTO == "1"
							cPed := AllTrim(ZB8->(ZB8_EXP+"H"+ZB8_ANOEXP+ZB8_SUBEXP))
						Else
							cPed := AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
						EndIf
					Else
						cPed := AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
					EndIf
					RecLock('ZB9',.F.)
					ZB9->ZB9_ZPEDID := cPed
					ZB9->(MsUnlock())
					ZB9->(dbSkip())
				EndDo
			EndIf

			RecLock('ZB8',.F.)
			ZB8->ZB8_MOTEXP := '2'
			ZB8->(MsUnLock())

			cSuc := 'Pedido Gerado Com Sucesso: ' + aRet[2]
			ApMsgInfo(cSuc,"Pedido Gerado")
		Else
			cSuc := 'Ocorreu algum problema executar o Execauto chamar o Adm do Sistema, Fonte:MGFEEC24'
			ShowError(AllTrim(cSuc))
		EndIf
	EndIf
Return

/*/{Protheus.doc} ExistPed
//TODO Verifica se o pedido foi gravado
@author leonardo.kume
@since 12/04/2018
@version 6
@type function
@param cFilB, caracter, filial
@param lStatus, boolean, status.
/*/
Static Function ExistPed(cFilVen,cExp,cAnoExp,cSubExp)

	Local aAreaEE7 	:= EE7->(GetArea())
	Local cAliasEE7 := GetNextAlias()
	Local lRet 		:= .f.

	BeginSql Alias cAliasEE7
		SELECT '*'
		FROM %Table:EE7%
		WHERE 	%NotDel% AND
			EE7_FILIAL = %Exp:cFilVen% AND
			EE7_ZEXP = %Exp:cExp% AND
			EE7_ZANOEX = %Exp:cAnoExp% AND
			EE7_ZSUBEX = %Exp:cSubExp%
		EndSQL

		lRet := !(cAliasEE7)->(Eof())

		EE7->(RestArea(aAreaEE7))

		Return lRet

/*/{Protheus.doc} isHilton
//TODO Verifica se o pedido tem itens Hilton
@author leonardo.kume
@since 28/09/2018
@version 6
@type function
@param cProduto, caracter, codigo produto
/*/
User Function isHilton(cProduto,cTipo)
	Local aArea := getArea()
	Local aAreaSB1 := SB1->(GetArea())
	Local oModel := FwModelActive()

	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto)
		If "HILTON" $ SB1->B1_DESC
			If cTipo == '1'
				oModel:GetModel("ZB8MASTER"):SetValue("ZB8_ZHILTO","1")
			Else
				oModel:GetModel("EEC19MASTER"):SetValue("ZZC_ZHILTO","1")
			EndIf
		EndIf
	EndIf

	SB1->(RestArea(aAreaSB1))
	RestArea(aArea)

Return cProduto

/*/{Protheus.doc} TMSENVEX
//TODO Envia para o TMS via JASON a EXP informada nos parametos. Se os parametros estiverem vazio, envia o registro ZB8 sobre o qual estiver posicionado.
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param _cZB8_EXP, caracter, m-> ou SZ8->ZB8_EXP
@param _ZB8ANOEXP, caracter, m-> ou SZ8->ZB8_ANOEXP
@param _ZB8SUBEXP, caracter, m-> ou SZ8->ZB8_SUBEXP
@param _cZB8_MOTE, caracter, m-> ou SZ8->ZB8_MOTEXP
@param _ZB8TMSACA, caracter, m-> ou SZ8->_ZB8_TMSACA
@param _lTela,     boolean,  deve receber nil, para não abrir tela. Ou receber .T. para abrir uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, Alteração ou Cancelamento )
/*/

User Function TMSENVEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela, _cOrig )
	Local aArea			:= GetArea()
	Local aAreaZB8		:= ZB8->(GetArea())
	Local _oZB8_EXP
	Local _oZB8_ANOEXP
	Local _oZB8_SUBEXP
	Local oZB8TMSACA
	local aButtons		:= {{"WEB",{|| U_TMSSELEX(oDlg2)},OemtoAnsi("Transmitir Varias EXPs ao TMS"),OemtoAnsi("Transmitir Varias EXPs ao TMS")}}	//Envio do Pedido  ao TMS Transwide
	Local oDlg2			:= ""
	local _aRet			:=	{}

	default _cOrig 	:=	0
	_aRet := bloqTrfTms()
	If _cOrig == 0
		If _aRet[4] > 60
			Help(NIL, NIL, _aRet[1], NIL, _aRet[2], 1, 0, NIL, NIL, NIL, NIL, NIL, {_aRet[3]})
			ZB8->(RestArea(aAreaZB8))
			RestArea(aArea)
			Return
		EndIf
	else
		If ZB8->ZB8_TMSACA $ 'I|A'
			If _aRet[4] > 60
				Help(NIL, NIL, _aRet[1], NIL, _aRet[2], 1, 0, NIL, NIL, NIL, NIL, NIL, {_aRet[3]})
				ZB8->(RestArea(aAreaZB8))
				RestArea(aArea)
				Return
			EndIf
		EndIf
	EndIf
	If !Empty(ZB8->ZB8_ZCODES) .AND. GetAdvFVal("ZBM","ZBM_TMS",xFilial("ZBM")+ZB8->ZB8_ZCODES,1,"") == "S"	// POSICIONE("ZBM",1,XFILIAL("ZBM")+ZB8->ZB8_ZCODES,"ZBM_TMS") == "S"

		If Empty(_cZB8_EXP) .or. _cZB8_EXP == Alias()		// Chamado pelo menu de contexto
			_cZB8_EXP	:= ZB8->ZB8_EXP
			_ZB8ANOEXP	:= ZB8->ZB8_ANOEXP					//If Empty(_ZB8ANOEXP)
			_ZB8SUBEXP	:= ZB8->ZB8_SUBEXP					//If Empty(_ZB8SUBEXP)
			_cZB8_MOTE	:= ZB8->ZB8_MOTEXP					//If _cZB8_MOTE
			_ZB8TMSACA	:= ZB8->ZB8_TMSACA					//Deixo-a vazia, para defini-la conforme conteudo da base de dados
		EndIf

		If ZB8->ZB8_MOTEXP == "3"							// EXP Cancelada
			_ZB8TMSACA	:= "C"

		ElseIf _ZB8TMSACA == " " 		// Se receber _ZB8TMSACA por parametro, utilizo o seu conteudo. Se estiver vazio leio a base de dados e uso a logica abaixo
			_ZB8TMSACA	:= "I"

		ElseIf ZB8->ZB8_TMSACA == "I" .OR. ZB8->ZB8_TMSACA == "A"
			_ZB8TMSACA	:= "A"

		Else
			If _lTela
				_ZB8TMSACA	:= "?"		// Na tela, se houver um caracter inesperado neste campo, insiro o caracter "?", qe deve ser substituido por "I","A" ou "C"
			Else
				_ZB8TMSACA	:= "I"		// No Processamento, se houver um caracter inesperado, Substituo-o por "I"
			EndIf
		EndIf

		If ValType(_lTela) <> "L" .or. _lTela		// Se _lTela for .F., Empty(_lTela) retorna .F.
			_lTela	:= .T.
		EndIf
		_cFilTmsMs := NIL //cFilant 220720
		
// WVN - Tratamento para TMS Multisoftware
		QRYFIL := GetNextAlias()
		BeginSql Alias QRYFIL
			SELECT  
				ZB8_ZCODES,ZBM_CODIGO,ZBM_CODCLI,ZBM_LOJCLI,A1_COD,A1_LOJA,A1_CGC,M0_CGC,M0_CODFIL
			FROM 
				%Table:ZB8% TZB8
				INNER JOIN %Table:ZBM% TZBM ON TZBM.ZBM_CODIGO=TZB8.ZB8_ZCODES 
				INNER JOIN %Table:SA1% TSA1 ON TSA1.A1_COD=TZBM.ZBM_CODCLI AND TSA1.A1_LOJA=TZBM.ZBM_LOJCLI 
				INNER JOIN SYS_COMPANY TSM0 ON TSM0.M0_CGC = TSA1.A1_CGC 
			WHERE 
				TZB8.ZB8_EXP = %EXP:ZB8->ZB8_EXP% 
			AND TZB8.ZB8_ZCODES = %EXP:ZB8->ZB8_ZCODES% 
			AND TZB8.%notdel% 
			AND TSA1.%notdel% 											 
			AND TZBM.%notdel% 											 
			AND TSM0.%notdel% 	
		ENDSQL
		(QRYFIL)->(DbGoTop())	
		_cFilTmsMs := alltrim((QRYFIL)->M0_CODFIL)
		/* 22072020
		IF _cFilTmsMs = NIL
			_cFilTmsMs := ZB8->ZB8_FILVEN
		ENDIF
		*/
		If _cFilTmsMs $ GETMV("MGF_TMSEXP")	
			_lTela := .F.		
		ENDIF
			/*
		Else
			MSGYESNO("A filial desta EXP será enviada pela Transwide ","Confirma Envio pela Transwide ?")
			ZB8->(RestArea(aAreaZB8))
			RestArea(aArea)
			Return
			*/
		//EndIf
		If _lTela

			DEFINE 	MSDIALOG oDlg2 TITLE "EXP a ser enviada ao TMS Transwide" From 0,0 to 350,400 of oMainWnd PIXEL
			@ 35,005 SAY   "EXP:"              SIZE 100,8                                                PIXEL OF oDlg2
			@ 35,100 MSGET _oZB8_EXP           VAR _cZB8_EXP  WHEN .F. PICTURE "@!" SIZE 55,8  F3 "ZB8" PIXEL OF oDlg2
			@ 55,005 SAY   "ANO EXP:"          SIZE 100,8                                                PIXEL OF oDlg2
			@ 55,100 MSGET _oZB8_ANOEXP        VAR _ZB8ANOEXP WHEN .F. PICTURE "@!" SIZE 55,8            PIXEL OF oDlg2
			@ 75,005 SAY   "SUB EXP"           SIZE 100,8                                                PIXEL OF oDlg2
			@ 75,100 MSGET _oZB8_SUBEXP        VAR _ZB8SUBEXP WHEN .F. PICTURE "@!" SIZE 55,8            PIXEL OF oDlg2
			@ 95,005 SAY   "Ação (I=Incluido, A=Alterado ou C=Cancelado)" SIZE 150,8                                         PIXEL OF oDlg2
			@ 95,135 MSGET oZB8TMSACA          VAR _ZB8TMSACA          PICTURE "@!" SIZE 10,8 Valid U_TMSVLEXP(_cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela )  PIXEL OF oDlg2

			_oZB8_EXP:Enable()
			_oZB8_ANOEXP:Enable()
			_oZB8_SUBEXP:Enable()
			oZB8TMSACA:Enable()

			ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar(oDlg2, ;
				{|| If (    U_TMSVLEXP( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela) , ;
				U_TMSEXJA(  _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela ,oDlg2) , .T. ) } ,;
				{|| oDlg2:End()} , ,aButtons )

		Else

			//If  U_TMSVLEXP( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela)
			If  U_TMSVLEXP( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela)
				U_TMSJASEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela,_cFilTmsMs)
			EndIf

		EndIf
	Else
		If _lTela
			MsgStop("Não será feita a integração com o TMS, pois o campo local de estufagem não está preenchido com local indicado para efetuar esta integração. ")
		EndIf
	EndIf

	ZB8->(RestArea(aAreaZB8))
	RestArea(aArea)
Return


/*/
	{Protheus.doc} bloqTrfTms
	(Função para retornar um bloqueio quando for integrar EXP com mais de 60 dias)
	@type  Static Function
	@author Cláudio Alves
	@since 14/01/2020
	@return _nDias, numerico, qtde de dias
/*/
Static Function bloqTrfTms()
	local _cTitulo		:=	'Integração Protheus vs TMS'
	local _cProble		:=	' '
	local _mensagem		:=	''
	local _aMsg		:=	{}
	local _nDias		:=	0
	local _cDias		:=	''
	local _nQtdeDias	:=	0
	local _dDias		:=	cTod('  /  /    ')
	local _x			:=	0
	local _aCampos		:=	{'ZB8->ZB8_ZDTEST','ZB8->ZB8_ZDTTRA','ZB8->ZB8_ZDELDR','ZB8->ZB8_ZDTDEC'}
	local _aNomes		:=	{'Dt.Estuf.PCP','Transb/Armaz','Dt DeadLine','DeadL Carga'}
	If !ExisteSx6("MGF_EEC24A")
		CriarSX6("MGF_EEC24A", "N", "Qtde de Dias para bloqueio da transferência", '60')
	EndIf

	_nQtdeDias := superGetMV("MGF_EEC24A", , 60)
	_cProble	:=	'Registros com mais de ' + AllTrim(str(_nQtdeDias)) + ' Dias'
	_mensagem	:=	'Os Campos abaixo estão mais de ' + AllTrim(str(_nQtdeDias)) + ' dias' + _Chr

	for _x := 1 to len(_aCampos)
		_dDias := &(_aCampos[_x])
		If !Empty(_dDias)
			If date() - _dDias > _nQtdeDias
				_nDias += date() - _dDias
				_cDias := AllTrim(str(date() - _dDias))
				_mensagem	+= _aNomes[_x] + ' com ' + _cDias + ' dias' + _Chr
			EndIf
		else
			_mensagem	+= _aNomes[_x] + ' está em branco ' + _Chr
			_nDias += 0
		EndIf
	next
	_aMsg = {_cTitulo, _cProble, _mensagem, _nDias}
	Return _aMsg


//{Protheus.doc} U_TMSEXJA
// 	chama a rotina que envia a EXP e depois fecha a ODLG
//@author Geronimo Benedito Alves
//@since 27/09/18
User Function TMSEXJA ( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela ,oDlg2  )
	U_TMSJASEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela, _cFilTmsMs  )
	oDlg2:End()
Return

/*/{Protheus.doc} TMSVLEXP
//TODO Valida o EXP + ano + SUb e a ação informada.  Se for exclusão, deve encontrar o EXP cancelado. Caso contrario, NÃO deve encontrar o EXP cancelado
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param _cZB8_EXP,  caracter, m-> ou SZ8->ZB8_EXP
@param _ZB8ANOEXP, caracter, m-> ou SZ8->ZB8_ANOEXP
@param _ZB8SUBEXP, caracter, m-> ou SZ8->ZB8_SUBEXP
@param _cZB8_MOTE, caracter, m-> ou SZ8->ZB8_MOTEXP
@param _ZB8TMSACA, caracter, m-> ou SZ8->ZB8_TMSACA
@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão)
/*/
User Function TMSVLEXP( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _ZB8TMSACA, _lTela )
	Local aArea		:= GetArea()
	Local _lRet		:= .T.

	If _ZB8TMSACA $ "IAC"

		DbSelectArea("ZB9")
		DbSetOrder(2)
		DbSeek(xFilial("ZB9") + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP )				// Posiciona na tabela ZB9

		DbSelectArea("ZB8")
		DbSetOrder(3)
		If !DbSeek(xFilial("ZB8") + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP )
			If _lTela
				MsgStop("Não foi encontrado nesta filial ("+ xFilial("ZB8") +") o EXP, ANO, SUB EXP : " + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP , "Aviso")
			EndIf
			_lRet	:= .F.
		Else
			If _ZB8TMSACA == "C"
				If ZB8_MOTEXP <> '3'
					If _lTela
						MsgStop("Esta EXP não está cancelada. Informação de EXP cancelada não será enviada ao TMS TransWide a EXP, ANO, SUB EXP : "  + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP, "Aviso")
					EndIf
					_lRet	:= .F.
				EndIf

			Else

				If ZB8_MOTEXP == '3'
					If _lTela
						MsgStop("Esta EXP foi cancelada. Informação de EXP "+ IIf(_ZB8TMSACA == "I", "Incluida", "Alterada")  +" não será enviada ao TMS TransWide a EXP, ANO, SUB EXP : "  + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP, "Aviso")
					EndIf
					_lRet	:= .F.
				EndIf
			EndIf
		EndIf

	Else
		If _lTela
			MsgStop("O campo ação foi preenchido com " + _ZB8TMSACA + ", que é invalido. O conteudo valido é I, A ou C. Inclusão, Alteração ou Cancelameno. não será enviada ao TMS TransWide a EXP, ANO, SUB EXP : "  + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP, "Aviso")
		EndIf
		_lRet	:= .F.

	EndIf

	RestArea(aArea)
Return _lRet


/*/{Protheus.doc} TMSSELEX
//Seleciona EXPs conforme os parametros recebidos, e os transmite ao TMS
@author Geronimo Benedito Alves
@since 13/10/18
@version 1
@type function
/*/

User function TMSSELEX(oDlg2)
	Local aArea			:= GetArea()
	Local cAliasTrb		:= GetNextAlias()
	Local _nInterval	:= 30
	Local _nContaReg	:= 0
	Local _aParambox	:= {}
	Local _aRet			:= {}

	aAdd(_aParambox,{1,"EXP Inicial a Transmitir ao TMS"	,Space(tamSx3("ZB8_EXP")[1])	,""	,""										,""	,"",050,.F.})
	aAdd(_aParambox,{1,"EXP Final   a Transmitir ao TMS"	,Space(tamSx3("ZB8_EXP")[1])	,""	,"U_VLFIMMAI(MV_PAR01,MV_PAR02,'EXP')"	,""	,"",050,.F.})
	aAdd(_aParambox,{1,"ANO das EXPs a Transmitir a TMS"	,Space(tamSx3("ZB8_ANOEXP")[1])	,""	,""										,""	,"",050,.F.})


	lRet := ParamBox(_aParambox, "EXPs à exportar ao TMS Transwide", @_aRet	,,	,,	,,	,,.T.,.T. )	// Executa funcao PARAMBOX p/ obter os parametros da query que gerará exportará as EXPs

	If lRet

		_cQuery := "  SELECT ZB8_EXP ,ZB8_ANOEXP ,ZB8_SUBEXP ,ZB8_MOTEXP ,ZB8_TMSACA FROM " + RetSqlName("ZB8") +  " ZB8 " +CRLF
		_cQuery += "      INNER JOIN " + RetSqlName("ZBM") +  " ZBM ON ZBM_FILIAL = '" +XFILIAL("ZBM")+ "' AND  ZB8_ZCODES = ZBM_CODIGO "
		_cQuery += "      WHERE  ZB8_FILIAL = '"+ XFILIAL("ZB8") +"' "
		_cQuery += "             AND ZB8_EXP    BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  +CRLF
		_cQuery += "             AND ZB8_ANOEXP = '" + _aRet[3] + "' "   +CRLF
		_cQuery += "             AND ZB8_ZCODES <> '      ' "   +CRLF
		_cQuery	+= "  	         AND ZB8.D_E_L_E_T_ = ' ' "
		_cQuery += "  ORDER BY ZB8_EXP ,ZB8_ANOEXP ,ZB8_SUBEXP "

		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
		(cAliasTrb)->(dbGoTop())

		While (cAliasTrb)->(!Eof())
			_nContaReg++
			(cAliasTrb)->(dbSkip())
		EndDo

		If _nContaReg == 0
			MsgStop("Não foram encontradas EXPs para os parâmetros acima")
		Else
			If MsgYesNo("Confirma a Transmissão de " + AllTrim(str(_nContaReg)) + " EXPs ao TMS Transwide ? ","Transmissão de EXP ao TMS!!")
				(cAliasTrb)->(dbGoTop())
				While (cAliasTrb)->(!Eof())
					If (cAliasTrb)->ZB8_MOTEXP == "3"		// EXP Cancelada
						_ZB8TMSACA	:= "C"
					ElseIf (cAliasTrb)->ZB8_TMSACA == " " 		// Se receber _ZB8TMSACA por parametro, utilizo o seu conteudo. Se estiver vazio leio a base de dados e uso a logica abaixo
						_ZB8TMSACA	:= "I"
					ElseIf (cAliasTrb)->ZB8_TMSACA == "I" .OR. ZB8->ZB8_TMSACA == "A"
						_ZB8TMSACA	:= "A"
					Else
						_ZB8TMSACA	:= "I"		// No Processamento, se houver um caracter inesperado, Substituo-o por "I"
					EndIf

					MsgRun("Aguarde, Transmitindo ao TMS a EXP : " + ZB8_EXP +"_"+ ZB8_ANOEXP 	,,{ || U_TMSJASEX( ZB8_EXP, ZB8_ANOEXP, ZB8_SUBEXP, ZB8_MOTEXP, _ZB8TMSACA, nil, nil) })

					(cAliasTrb)->(dbSkip())
				EndDo
			EndIf
		EndIf

		(cAliasTrb)->(dbCloseArea())

		// Se o usuario informou os parametros de selecao do processamento, depois do processamento, fecho todas as janelas e volto ao browse
		If Valtype(oDlg2) == "O"
			oDlg2:End()					// Fecho a tela anterior, de digitação dos parâmetros de envio de um OV por vez
		EndIf

	EndIf

	RestArea(aArea)
Return


/*/{Protheus.doc} fxRetInland
//Retorno Inland
@author Cláudio Alves
@since 23/10/2019
@version 1
@type static function
/*/
static function fxRetInland(oModel)
	local _cRet		:= '|'
	local _lRet		:=	.T.
	local _cFim		:=  CHR(13) + CHR(10)
	local oMdlZB8	:=	oModel:GetModel('ZB8MASTER')
	local _cVia		:=	oMdlZB8:getValue("ZB8_VIA")
	local _cNumre	:=	oMdlZB8:getValue("ZB8_ZNUMRE")
	local _cInland	:=	oMdlZB8:getValue("ZB8_INLAND")

	dbSelectArea('ZFL')
	ZFL->(dbSetOrder(1))
	ZFL->(dbGoTop())
	While !(ZFL->(EOF()))
		_cRet += ZFL->ZFL_CODIGO + '|'
		ZFL->(dbSkip())
	EndDo

	//regra 01 - VIA 2-3-4 ENTÃO INLAND = '01'
	If _cVia $ '02|03|04' .AND. _lRet
		If _cInland != '01' .OR. M->ZB8_INLAND != '01'
			_lRet := .F.
			Help( ,, 'REGRAS INLAND',, ;
				+ 'Código de Inland inválido ou diferente de 01.';
				, 1, 0,NIL,NIL,NIL,NIL,NIL, ;
				{;
				'Verifique a Via de Transporte. ' + _cFim ;
				+ 'Caso a Via de Transporte seja (02, 03 ou 04)' + _cFim ;
				+ 'O Código do Inland deve ser 01' + _cFim ;
				+ 'Independente se o Numero de Reserva' + _cFim ;
				+ 'estiver em branco ou não.' ;
				})
		EndIf
	EndIf

	//regra 02 - VIA 1 e Num Reserva em Branco ENTÃO INLAND deve ser branco
	If _cVia == '01' .and. Empty(AllTrim(_cNumre)) .AND. _cInland<>'  ' .AND. _lRet
		If !(Empty(AllTrim(_cInland)))
			_lRet := .F.
			Help( ,, 'REGRAS INLAND',, ;
				+ 'Código de Inland inválido ou diferente de Branco.' ;
				, 1, 0,NIL,NIL,NIL,NIL,NIL, ;
				{ ;
				'Verifique a Via de Transporte e o Número de Reserva. ' + _cFim ;
				+ 'Para Via de Transporte igual a 01 ' + _cFim;
				+ 'e o número de reserva em branco, ' + _cFim;
				+ 'o código do inland deve estar em branco também.';
				} )
		EndIf
	EndIf

	//regra 03 - VIA 1 e Num Reserva diferente de Branco ENTÃO INLAND deve ser preenchido
	If _cVia == '01' .and. !(Empty(AllTrim(_cNumre))) .AND. _lRet
		If !(AllTrim(_cInland)) $ '01|02|03|'
			_lRet := .F.
			Help( ,, 'REGRAS INLAND',, ;
				+ 'Código de Inland inválido ou em branco.' ;
				, 1, 0,NIL,NIL,NIL,NIL,NIL, ;
				{ ;
				_cFim + 'Verifique a Via de Transporte e o Número de Reserva. ' + _cFim;
				+ 'Para Via de Transporte igual a 01 ' + _cFim;
				+ 'e o número de reserva diferente de branco, ' + _cFim;
				+ 'o código do inland deve ser um código válido.' + _cFim;
				+ 'Os códigos Válidos São: ' + strTran(_cRet, '|', ' ');
				} )
		EndIf
	EndIf


return _lRet

/*/{Protheus.doc} fxValInl
//Valida o inland informado
@author Cláudio Alves
@since 23/10/2019
@version 1
@type user function
/*/
user function fxValInl(_cOrigem)
	local _cRet		:=	''
	local _lRet		:=	.T.
	local oModel 	:=	FwModelActive()
	local oView		:=	FwViewActive()
	local oMdlZB8	:=	oModel:GetModel('ZB8MASTER')
	local _cFamilia	:=	oMdlZB8:GetValue('ZB8_ZTPROD')
	local _cFamiDsc	:=	oMdlZB8:GetValue('ZB8_ZDTPPR')
	local _cGrpFami	:=	oMdlZB8:GetValue('ZB8_ZFAMIL')
	local _cDscFami	:=	oMdlZB8:GetValue('ZB8_ZDFAMI')
	local _cCodPais	:=	oMdlZB8:GetValue('ZB8_PAISET')
	local _cDscPais	:=	oMdlZB8:GetValue('ZB8_ZDPAIS')
	local _cCInland	:=	oMdlZB8:GetValue('ZB8_INLAND')
	local _cContine	:=	''
	local _aInland	:=	{}
	local xi		:=	0
	local _cFim		:=  CHR(13) + CHR(10)
	local _aContine	:=	{'America', 'Europa', 'Africa', 'Asia', 'Oceania', 'Antartida'}


  If !Empty(AllTrim(_cCInland)) .or. !Empty(AllTrim(M->ZB8_INLAND)) .or. _cCInland == 'zy'
		SYA->(dbSetOrder(1))
		SYA->(dbSeek(xFilial('SYA') + _cCodPais))
		_cContine := AllTrim(SYA->YA_ZCDMCON)

		dbSelectArea('ZFM')
		ZFM->(dbSetOrder(3))
		ZFM->(dbGoTop())

		While !(ZFM->(EOF()))
			If (Empty(AllTrim(ZFM->ZFM_ZTPROD)) .or. AllTrim(ZFM->ZFM_ZTPROD) == AllTrim(_cFamilia))
				aadd(_aInland, ;
					{;
					iif(Empty(ZFM->ZFM_ZTPROD), 'todos', ZFM->ZFM_ZTPROD), ;
					ZFM->ZFM_ZFAMIL, ;
					ZFM->ZFM_CONTIN, ;
					ZFM->ZFM_PAIS, ;
					ZFM->ZFM_INLAND, ;
					0;
					})
			EndIf
			ZFM->(dbSkip())
		EndDo

		If len(_aInland) >= 1
			for xi := 1 to len(_aInland)
				If (Empty(AllTrim(_aInland[xi][2])) .or. AllTrim(_aInland[xi][2]) == AllTrim(_cGrpFami))
					_aInland[xi][6] += 1
				EndIf
			next

			for xi := 1 to len(_aInland)
				If (Empty(AllTrim(_aInland[xi][3])) .or. AllTrim(_aInland[xi][3]) == AllTrim(_cContine)) ;
						.and. _aInland[xi][6] == 1
					_aInland[xi][6] += 1
				EndIf
			next

			for xi := 1 to len(_aInland)
				If (Empty(AllTrim(_aInland[xi][4])) .or. AllTrim(_aInland[xi][4]) == AllTrim(_cCodPais)) ;
						.and. _aInland[xi][6] == 2
					_aInland[xi][6] += 1
				EndIf
			next

			for xi := 1 to len(_aInland)
				If _aInland[xi][6] == 3
					if(Empty(AllTrim(_aInland[xi][5])) .or. AllTrim(_aInland[xi][5]) == AllTrim(_cCInland))
						_cRet := AllTrim(_cCInland)
						exit
					else
						_cRet := 'Fora'
					EndIf
				EndIf
			next
		else
			_cRet := AllTrim(_cCInland)
		EndIf

		If _cRet == 'Fora'
			msgAlert('Código de Inland informado é invalido.' + _cFim;
				+'Verifique os seguintes campos: ' + _cFim ;
				+ 'Tipo de Produto: ' + AllTrim(_cFamilia) + ' - ' + AllTrim(_cFamiDsc) + _cFim ;
				+ 'Familia Produto: ' + AllTrim(_cGrpFami) + ' - ' + AllTrim(_cDscFami) + _cFim ;
				+ 'Continente: ' + _aContine[val(_cContine)] + _cFim ;
				+ 'País: ' + AllTrim(_cCodPais) + ' - ' + AllTrim(_cDscPais) + _cFim ;
				+ 'É preciso ter uma regra para esses dados.', 'REGRAS INLAND')
			oMdlZB8:SetValue('ZB8_INLAND', 'zy')
			oView:Refresh()
			oMdlZB8:SetValue('ZB8_INLAND', '  ')
			oView:Refresh()
		EndIf

	else

		oMdlZB8:SetValue('ZB8_INLAND', '  ')
		oView:Refresh()

	EndIf

	oView:Refresh()
return iif(_cOrigem == 1, _cRet, _lRet)


/*/
	{Protheus.doc} fValFrete
	(Função para retornar o valor do frete convertido em outra moeda quando a via de transporte for igual a 03-rodoviario
	@type  User Function
	@author Wagner Neves
	@since 28/01/2020
	@return _nValFrePr, numérico, valor do frete em outra moeda
/*/

User function fValFrete() 

	Local oModel 	 := FwModelActive()
	Local oView		 := FwViewActive()
	Local oMdlZB8	 := oModel:GetModel('ZB8MASTER')
	Local _nValFrePr := oMdlZB8:GetValue('ZB8_FRPREV')
	Local _nValReal  := oMdlZB8:GetValue('ZB8_FRREAL')
	Local _vMoeForte := oMdlZB8:GetValue('ZB8_ZMOEFR')
	Local _vVia	     := oMdlZB8:GetValue('ZB8_VIA')
	Local _nTaXa     := 1
	
	// Via 03-Rodoviário
	If _vVia == '03' .And. _vMoeForte <> "BRL" 
		_nTaXa := POSICIONE("SYE",1,XFILIAL("SYE")+dtos(dDataBase)+_vMoeForte,"YE_TX_COMP")//04-03 Merge Wagner
		If _nTaxa <> 0
			_nValFrePr := ( _nValReal / _nTaxa )	
		Else
			MsgAlert("Taxa da moeda não localizada. O valor do frete não será convertido.","Atenção !!!")
		EndIf
		oMdlZB8:SetValue('ZB8_FRPREV',_nValFrePr)
	EndIf
    oView:Refresh()
return _nValFrePr


/*/{Protheus.doc} Deparax5()
//RETORNAR A DESCRICAO DO SX5 PARA O GATILHO
@author ROBERTO R. MEZZALIRA
@since 12/12/2019
@version 1
@type user function
/*/
User Function Deparax5()
Local oModel 	:=	FwModelActive()
Local oView		:=	FwViewActive()
Local oMdlZB8	:=	oModel:GetModel('ZB8MASTER')
Local _cDesx5	:=  oMdlZB8:GetValue('ZB8_ORIGEM')  // "  "
Local _cVia   	:=	oMdlZB8:GetValue('ZB8_VIA')
Local _cFilven	:=	oMdlZB8:GetValue('ZB8_FILVEN')

If _cVia == '03'
	_cDesx5:=  GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"Z2"+_cFilven,1,"")	//AllTrim(POSICIONE("SX5",XFILIAL(SX5)+"Z2"+_cFilven,"X5_DESCRI" ))	
	_cDesx5:=  AllTrim(_cDesx5)
EndIf	

return(_cDesx5)

/*/{Protheus.doc} mgfcpcp24()
//HABILITA O GATILHO PARA O GRUPO  PCP
@author ROBERTO R. MEZZALIRA
@since 16/12/2019
@version 1
@type user function
/*/
User Function mgfcpcp24()
Local _lok:= .F.
Local _cGrppcp  := SuperGetMV("MGF_ECC24B",.F.,'000000/000442')
Local _aGrpuser := UsrRetgrp(RetCodusr())

If __cUserId $ _cGrppcp  
	_lok:= .T.
EndIf	

return(_lok)


/*/{Protheus.doc} mgfecpv24()
//HABILITA O GATILHO PARA O GRUPO  POS VENDA
@author ROBERTO R. MEZZALIRA
@since 16/12/2019
@version 1
@type user function
/*/
User Function mgfecpv24()
Local _lok:= .F.
Local _cGrpposv := SuperGetMV("MGF_ECC24A",.F.,'000063')
Local _aGrpuser := UsrRetgrp(RetCodusr())

If __cUserId $ _cGrpposv 
	_lok:= .T.
EndIf	

return(_lok)


/*/{Protheus.doc} VMGFEVIA
//TODO Gatilho para preencher Fornecedor nos itens
@author ROBERTO R. MEZZALIRA
@since 16/12/2019
@version 1

@type function
/*/
User function VMGFEVIA()

	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local _cVia		:= oMdlZB8:GetValue('ZB8_VIA')
	Local _lOk      := .F.

	If _cVia =='03'
		 _lOk  := .T.
	EndIf 
	
return _lOk

/*
======================================================================================================
Programa............: GrvFRPREV
Autor...............: Renato Junior
Data................: 27/03/2020
Descrição / Objetivo: Grava CAmpo ZB8_FRPREV somente se Via = 03 rodoviario a taxa virá diferente de 1
======================================================================================================
*/
Static function GrvFRPREV(nValFrePr, nTaXa)
	If nTaXa	<>	1	.and.	nValFrePr > 0
		RecLock('ZB8',.F.)
		ZB8->ZB8_FRPREV:=	nValFrePr
		ZB8->(MsUnLock())
	EndIf
Return Nil

/*/{Protheus.doc} FENVEXPT
//TODO Envia dados da EXP para o TAURA
@author Paulo da Mata
@since 07/05/2020
@version 1

@type function
/*/
User Function fEnvExpT()

	Local cUrl 		 := AllTrim("http://spdwvapl203:1451/processo-exportacao/api/v1/empresa/"+AllTrim(ZB8->ZB8_FILVEN)+"/exp/"+ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP))
	Local cMsgErro	 := ""
	Local cHeadRet 	 := ""
	Local aHeadOut	 := {}

	Local cJson		 := ""
	Local oJson		 := Nil
	Local xPostRet	 := Nil
	Local oDetRet 	 := nil
    Local nTimeOut	 := 120
	Local cTimeIni	 := ""
	Local cTimeProc	 := ""
	Local nStatuHttp := 0

	// Variáveis para gravação do mointor de integração
	Local cCdIntEx   := SuperGetMV("MGF_EEC24F",,"001")
	Local cCdTipEx   := SuperGetMV("MGF_EEC24G",,"019")
	
	Local cChave 	 := ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
	Local cCdLxi     := Posicione("SA1",1,xFilial("SA1")+ZB8->(ZB8_IMPORT+ZB8_IMLOJA),"A1_ZCODMGF")
	Local cCdLxt     := Posicione("SA1",1,xFilial("SA1")+ZB8->(ZB8_ZCLIET+ZB8_ZLJAET),"A1_ZCODMGF")

	If 		Empty(ZB8->ZB8_FILVEN)
	   		ApMsgAlert(OemToAnsi("O campo [FILIAL PEDID] está vazio. Para este processo, ele deve estar preeenchido"),OemToAnsi("ATENÇÃO"))
	   		Return
	ElseIf 	ZB8->ZB8_MOTEXP $ "2/3/7"
	   		ApMsgAlert(OemToAnsi("exportação já processada, em faturamento ou cancelada."),OemToAnsi("ATENÇÃO"))
	   		Return
	EndIf

	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'Accept-Charset: utf-8' )
	
	oJson							:= JsonObject():new()

	oJson['numExp']					:= AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
	oJson['dataCriacao']			:= AllTrim(SubStr(DtoS(Date()),1,4)+"-"+SubStr(DtoS(Date()),5,2)+"-"+SubStr(DtoS(Date()),7,2))
	oJson['numExp']					:= AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
	oJson['idCliente']				:= If(Empty(cCdLxt),AllTrim(ZB8->(ZB8_ZCLIET+"|"+ZB8_ZLJAET)),cCdLxt)
	oJson['idImportador']			:= If(Empty(cCdLxi),AllTrim(ZB8->(ZB8_IMPORT+"|"+ZB8_IMLOJA)),cCdLxi)
	oJson['traceCode']				:= AllTrim(ZB8->ZB8_ZTRCOD)
	oJson['traceCodeReligioso']		:= AllTrim(ZB8->ZB8_ZTRCDR)
	oJson['halal']					:= If(ZB8->ZB8_ZHALAL=="S",.T.,.F.)
	_cObsTaura := AllTrim(Posicione("ZZC",1,xFilial("ZZC")+ZB8->ZB8_ORCAME,"ZZC_ZOBSND"))+AllTrim(ZB8->ZB8_ZOBS)
	oJson['observacoes']			:= Subs(_cObsTaura,1,150) //AllTrim(Posicione("ZZC",1,xFilial("ZZC")+ZB8->ZB8_ORCAME,"ZZC_ZOBSND"))+AllTrim(ZB8->ZB8_ZOBS)
	oJson['status']					:= If(ZB8->ZB8_MOTEXP=="3","Cancelada","Normal")
	oJson['itens'] 					:= {}

	ZB9->(dbSetOrder(2))

	If ZB9->(dbSeek(cChave))

	   While xFilial("ZB9")+ZB9->(ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == cChave .And. ZB9->(!Eof())
	   			  
		  oJsonItem				  := JsonObject():new()

		  oJsonItem['idEmpresa']  := AllTrim(ZB9->ZB9_FILVEN)
		  oJsonItem['idProduto']  := AllTrim(ZB9->ZB9_COD_I)
		  oJsonItem['quantidade'] := ZB9->ZB9_SLDINI
		  oJsonItem['valor'] 	  := ZB9->ZB9_PRECO

		  aadd( oJson['itens'] , oJsonItem )

		  ZB9->(dbSkip())
	   
	   EndDo

	EndIf   	  

	cJson	:= ""
	cJson	:= oJson:toJson()
		
	If !Empty( cJson )
		xPostRet := httpQuote( cUrl 		/*<cUrl>*/		,;
		                       "PUT" 		/*<cMethod>*/	,;
							   				/*[cGETParms]*/	,;
							   cJson		/*[cPOSTParms]*/,;
							   nTimeOut 	/*[nTimeOut]*/	,; 
							   aHeadOut 	/*[aHeadStr]*/	,; 
							   @cHeadRet 	/*[@cHeaderRet]*/ )
		fwJsonDeserialize( xPostRet, @oDetRet )
	EndIf	

	cTimeIni := time()

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= Time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	U_MFCONOUT(" * * * * * Status da integracao * * * * *"								 )
	U_MFCONOUT(" Inicio.......................: " + cTimeIni + " - " + DtoC( dDataBase ) )
	U_MFCONOUT(" Fim..........................: " + cTimeFin + " - " + DtoC( dDataBase ) )
	U_MFCONOUT(" Tempo de Processamento.......: " + cTimeProc 							 )
	U_MFCONOUT(" URL..........................: " + cUrl								 )
	U_MFCONOUT(" HTTP Method..................: " + "PUT" 								 )
	U_MFCONOUT(" Status Http (200 a 299 ok)...: " + AllTrim( str( nStatuHttp ) ) 		 )
	U_MFCONOUT(" cJson........................: " + AllTrim( cJson ) 					 )
	U_MFCONOUT(" Retorno......................: " + AllTrim( xPostRet ) 			  	 )
	U_MFCONOUT(" * * * * * * * * * * * * * * * * * * * * "								 )

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",cJson)

    If Valtype(xPostRet) == 'C'
	   cMsgErro := xPostRet
    EndIf

	freeObj( oJson )

	If 	!Empty(cMsgErro)
	   	ApMsgInfo(OemToAnsi(AllTrim(cMsgErro)),OemToAnsi("ATENÇÃO"))
	Else   
		ZB8->(RecLock("ZB8",.f.))
		ZB8->ZB8_INTTAU := If(!Empty(ZB8->ZB8_INTTAU),"I","A")
		ZB8->(MsUnLock())
	EndIf

	// Salvar os dados no monitor de integração	- Parte 1 - SZ3 - TABELA DE TIPO DE INTEGRACAO
	If SZ3->(!dbSeek(xFilial("SZ3")+cCdIntEx+cCdTipEx))
		RecLock("SZ3",.T.)
		SZ3->Z3_FILIAL  := xFilial("SZ3")
		SZ3->Z3_CODINTG := cCdIntEx
		SZ3->Z3_CODTINT := cCdTipEx
		SZ3->Z3_TPINTEG := 'Integracao EXP Taura'
		SZ3->Z3_EMAIL	:= ''
		SZ3->Z3_FUNCAO	:= ''
		MsUnlock()
	EndIf

	// Salvar os dados no monitor de integração	- Parte 2 - SZ1 - MONITOR DE INTEGRACOES
	U_MGFMONITOR(	ZB8->ZB8_FILVEN																							,;
					If(nStatuHttp >= 200 .And. nStatuHttp <= 299,"1","2")													,;
					cCdIntEx 																								,;
					cCdTipEx 																								,;
					If(nStatuHttp >= 200 .And. nStatuHttp <= 299,"Processamento realizado com sucesso!",AllTrim(xPostRet)) 	,;
					ZB8->ZB8_EXP 																							,;
					cTimeProc																								,;
					cJson 																									,;
  					" "														                								,;
					cValToChar(nStatuHttp) 																					,;
					.F.																										,;
					{}																										,;
 					" " 																    								,;
					If(TYPE(xPostRet) <> "U", xPostRet, " ")																,;
					If(!Empty(ZB8->ZB8_INTTAU),"I","A")																		,;
					" "																										,;
					" "																										,;
					StoD(Space(08)) 																						,;
					" "																										,;
					" "																										,;
        			cUrl     																								,;
					" " 																									)
	
	delClassINTF()

	freeObj( oJson )

	ApMsgInfo(OemToAnsi("Exportação completada com sucesso"),OemToAnsi("ATENÇÃO"))

Return

/*/{Protheus.doc} xM25fil
//TODO Gatilho para preencher o nome da filial
@author Paulo da Mata
@since 15/06/2020
@version  

@type function
/*/

User function xM25fil()

	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZB8	:= oModel:GetModel('ZB8MASTER')
	Local cCodFil	:= oMdlZB8:GetValue('ZB8_FILVEN')
	Local cNomFil   := ""
	Local cQuery    := ""

	If !Empty(AllTrim(cCodFil))

	   cQuery := "SELECT * FROM SYS_COMPANY "
	   cQuery += "WHERE D_E_L_E_T_= ' ' " 
	   cQuery += "AND M0_CODFIL = '" +cCodFil+ "' "
	    
	   cQuery := ChangeQuery(cQuery)

	   dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	   cNomFil := TRB->M0_FILIAL
	
	EndIf

	TRB->(dbCloseArea())

	oView:Refresh()

Return cNomFil