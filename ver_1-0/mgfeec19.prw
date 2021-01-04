#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TOPCONN.CH"

/*
===========================================================================================
Programa.:              MGFEEC19
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de Orcamento e aprovacao
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:
===========================================================================================
*/
User Function MGFEEC19()
	Private oBrowse
	Private aRotina := {}

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZC')
	oBrowse:SetDescription('Orcamento Exportacao Marfrig')
	oBrowse:AddLegend("ZZC_APROVA == '2' .AND. ZZC_ZDISTR <> '1'","WHITE" ,'Pendente')
	oBrowse:AddLegend("ZZC_APROVA == '1' ","GREEN" ,'Aprovado')
	oBrowse:AddLegend("ZZC_APROVA == '3' ","RED" ,'Reprovado')
	oBrowse:AddLegend("ZZC_APROVA == '4' ","BLUE" ,'EXP Gerada')
	oBrowse:AddLegend("ZZC_APROVA == '6' ","YELLOW" ,'Aguardando Aprovacao')
	oBrowse:AddLegend("ZZC_APROVA == '7' ","BLACK" ,'Distribuido')
	oBrowse:AddLegend("ZZC_APROVA == '2' .AND. ZZC_ZDISTR == '1'","ORANGE" ,'Aguardando Distribuicao')
	oBrowse:AddLegend("ZZC_APROVA == '8' ","PINK" ,'Cancelado')
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} EEC19M
Pontos de entrada MVC
@author leonardo.kume
@since 30/12/2016
@version 1.0
/*/
User Function EEC19M()
	Local xRet 			:= .T.
	Local oModel 		:= FwModelActive()
	Local nOperation 	:= 0
	Local lDistr		:= .F.
	Local lOK			:= .T.
	Local cOrcam		:= ""
	Local cMsg			:= ""
	Local cMotivo		:= ""
	Local aCampAlt		:= StrToKarr(SuperGetMv("MGF_EEC19",,"ZZC_ZQTDCO/ZZC_ZWEEKD/ZZC_ZWEEKA"),"/")
	Local nI			:= 0
	Local cAliasZC2		:= GetNextAlias()
	Local cPerg			:= "EEC19M"
	Local cParam 		:= If(Type("ParamIxb") = "A",ParamIxb[2],If(Type("ParamIxb") = "C",ParamIxb,""))

	local aArea		:= getArea()
	local aAreaZZC	:= ZZC->(getArea())
    local aAreaZZD	:= ZZD->(getArea())

	If cParam == "MODELPOS"

		nOperation := oModel:GetOperation()
		cOrcam		:= oModel:GetModel("EEC19MASTER"):GetValue("ZZC_ORCAME")

		if nOperation == MODEL_OPERATION_UPDATE .AND. ZZC->ZZC_APROVA $ "1/3/6/7"
			BeginSql Alias cAliasZC2
				SELECT SUM(ZC2.ZC2_QTDCON) TOTAL
				FROM %Table:ZC2% ZC2
				WHERE 	ZC2.D_E_L_E_T_ = ' ' AND
				ZC2.ZC2_FILIAL <> '99' AND
				ZC2.ZC2_ORCAME = %Exp:cOrcam%
			EndSql
	
			If !(cAliasZC2)->(Eof())
				lDistr := oModel:GetModel("EEC19MASTER"):GetValue("ZZC_ZQTDCO") == (cAliasZC2)->TOTAL
			EndIf
	
			If Select(cAliasZC2) > 0
				(cAliasZC2)->(DbCloseArea())
			EndIf

			If oModel:GetModel("EEC19MASTER"):GetValue("ZZC_APROVA") == "3"
				lOk := .F.
				cMsg += "Orcamento foi reprovado. "
			EndIf

			lOk := lOk .And. Len( oModel:GetModel("EEC19DETAIL"):GETLINESCHANGED() )  = 0
			cMsg += iif(!lOk,"Itens Alterados. " ,"")

			For nI := 1 To Len(aCampAlt)
				lOk := lOk .And. ZZC->(&(aCampAlt[nI])) == oModel:GetModel("EEC19MASTER"):GetValue(aCampAlt[nI])
				cMsg += iif(ZZC->(&(aCampAlt[nI])) <> oModel:GetModel("EEC19MASTER"):GetValue(aCampAlt[nI]),"Campo "+ aCampAlt[nI] + " alterado. " ,"")
			Next nI
	
			If !lOk
				While Empty(Alltrim(cMotivo))
					Pergunte(cPerg,.T.)
					cMotivo := MV_PAR01
				EndDo
				cMsg += cMotivo

				MGF19Alt(cMsg)
			EndIf
	
			RecLock("ZZC",.F.)
			If !lOk
				ZZC->ZZC_APROVA := iif(lDistr,"7","2")
			EndIf
	
			ZZC->ZZC_ZREVIS := dDataBase
			ZZC->(MsUnlock())
		EndIF
		If Select(cAliasZC2) > 0
			(cAliasZC2)->(DbCloseArea())
		EndIf
	EndIf

	restArea(aAreaZZD)
	restArea(aAreaZZC)
	restArea(aArea)
Return xRet

Static Function MenuDef()

	If Type("aRotina")=="U"
		Private aRotina := {}
	EndIf

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.MGFEEC19' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.MGFEEC19' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.MGFEEC19' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'			ACTION 'VIEWDEF.MGFEEC19'	OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Envia Aprovacao' 	ACTION 'U_GeraAprov(.F.)' 	OPERATION 13 ACCESS 0
	ADD OPTION aRotina TITLE 'Aprova'     		ACTION 'U_EEC19APR(.T.)' 	OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Reprova'    		ACTION 'U_EEC19APR(.F.)' 	OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprime'    		ACTION 'U_MGFEEC36' 		OPERATION 14 ACCESS 0
	ADD OPTION aRotina TITLE 'Historico'		ACTION 'U_MGFEEC12' 		OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Distribuicao'		ACTION 'U_MGF32CAL' 		OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE 'Gera EXP'			ACTION 'U_xMG19GEXP' 		OPERATION 11 ACCESS 0
	ADD OPTION aRotina TITLE 'Manutencao EXP'	ACTION 'U_MGFEEC24' 		OPERATION 12 ACCESS 0
	ADD OPTION aRotina TITLE 'Conhecimento'		ACTION 'U_ZZCRecno'			OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Cancelar'			ACTION 'U_EEC19CAN'			OPERATION 15 ACCESS 0


Return aRotina


Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZC := FWFormStruct( 1, 'ZZC')
	Local oStruZZD := FWFormStruct( 1, 'ZZD')
	Local oModel
	Local aAux := {}
	Local oStruUM  := FWFormStruct(1,'ZZD', {|cCampo| alltrim(cCampo) $ "ZZD_SLDINI,ZZD_UNIDAD,ZZD_PRECO" })
	Local oStruTC  := FWFormStruct( 1, 'ZZC', {|cCampo| alltrim(cCampo) $ "ZZC_FILIAL,ZZC_ZCONTA,ZZC_ZDCONT" })


	//*************************************************************************************
	// GATILHO GENSET
	//*************************************************************************************

	//**********************
	// ZZC_DEST
	//**********************
	aAux := FwStruTrigger("ZZC_DEST" ,;
		"ZZC_DEST" ,;
		"U_MGFGENSE('ZZC_DEST', M->ZZC_DEST)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	///01 ini
	//**********************
	// ZZC_ZFAMIL
	//**********************
	aAux := FwStruTrigger("ZZC_ZFAMIL" ,;
		"ZZC_ZFAMIL" ,;
		"U_MGFGENSE('ZZC_ZFAMIL', M->ZZC_ZFAMIL)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
	aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZC_SEGPRE" ,;
		"ZZC_SEGPRE" ,;
		"U_MGF19TRG(, .T.,M->ZZC_SEGPRE)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZC_ZQTDCO" ,;
		"ZZC_ZQTDCO" ,;
		"U_MGF19QTC(, .T.,M->ZZC_ZQTDCO)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	//**********************
	// ZZC_IMPORT
	//**********************
	aAux := FwStruTrigger("ZZC_IMPORT" ,;
		"ZZC_IMPORT" ,;
		"U_MGFGENSE('ZZC_IMPORT', M->ZZC_IMPORT)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	//**********************
	// ZZC_IMLOJA
	//**********************
	aAux := FwStruTrigger("ZZC_IMLOJA" ,;
		"ZZC_IMLOJA" ,;
		"U_MGFGENSE('ZZC_IMLOJA', M->ZZC_IMLOJA)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	//**********************
	// ZZC_ZTPROD
	//**********************
	aAux := FwStruTrigger("ZZC_ZTPROD" ,;
		"ZZC_ZTPROD" ,;
		"U_MGFGENSE('ZZC_ZTPROD', M->ZZC_ZTPROD)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho


	aAux := FwStruTrigger("ZZD_COD_I" ,;
		"ZZD_COD_I" ,;
		"U_MGFGENSE('ZZD_COD_I', M->ZZD_COD_I)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZD:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZC_ZQTDCO" ,;
		"ZZC_ZQTDCO" ,;
		"U_MGF19TPT(,M->ZZC_ZQTDCO)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZC_VIA" ,;
		"ZZC_VIA" ,;
		"U_MGFGENSE('ZZC_VIA', M->ZZC_VIA)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZD_SLDINI" ,;
		"ZZD_SLDINI" ,;
		"U_MGF19TPT(,M->ZZD_SLDINI)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZD:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZD_UNIDAD" ,;
		"ZZD_UNIDAD" ,;
		"U_MGF19TPT(,M->ZZD_UNIDAD)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZD:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZD_FPCOD" ,;
		"ZZD_FPCOD" ,;
		"U_MGFGENSE('ZZD_FPCOD', M->ZZD_FPCOD)",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZD:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	//*************************************************************************************
	// FIM - GATILHO GENSET
	//*************************************************************************************

	aAux := FwStruTrigger("ZZC_FORN" ,;
		"ZZC_FORN" ,;
		"U_M19Forn()",;
		.F.,;
		"",;
		0,;
		"")

	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger("ZZC_FOLOJA" ,;
		"ZZC_FORN" ,;
		"U_M19Forn()",;
		.F.,;
		"",;
		0,;
		"")
	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho


	//**********************
	// ZZC_MOEDA - WVN
	//**********************
	aAux := FwStruTrigger("ZZC_MOEDA" ,;
		"ZZC_ZMOEFR" ,;
		"M->ZZC_MOEDA",;
		.F.,;
		"",;
		0,;
		"")
	oStruZZC:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	FWMemoVirtual( oStruZZC,{ { 'ZZC_CODMEM' , 'ZZC_OBS' }, {'ZZC_CODOBP','ZZC_OBSPED'} , {'ZZC_DSCGEN','ZZC_GENERI'} } )

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC19M', /*bPreValidacao*/, {|oModel|xVldMdl(oModel)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC19MASTER', /*cOwner*/, oStruZZC, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC19DETAIL', 'EEC19MASTER', oStruZZD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC19SOMA', 'EEC19MASTER', oStruUM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddFields( 'EEC19TC', 'EEC19MASTER', oStruTC, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Orcamento Exportacao Marfrig' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC19MASTER' ):SetDescription( 'Orcamento Exportacao Marfrig' )

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "EEC19DETAIL", { { "ZZD_FILIAL", "XFILIAL('ZZD')" }, { "ZZD_ORCAME", "ZZC_ORCAME" } }, ZZD->( IndexKey( 1 ) ) )
	oModel:SetRelation( "EEC19TC", { { "ZZC_FILIAL", "XFILIAL('ZZC')" }, { "ZZC_ORCAME", "ZZC_ORCAME" } }, ZZC->( IndexKey( 1 ) ) )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZZC_FILIAL","ZZC_ORCAME"})

	oModel:AddCalc("EEC19CALC", "EEC19MASTER", "EEC19DETAIL", "ZZD_PRCINC", "ZZD__TOTSD", "COUNT", {||.T.}, ,"Total Itens")
	oModel:AddCalc("EEC19CALC", "EEC19MASTER", "EEC19DETAIL", "ZZD_PRCINC", "ZZD__TOTFS", "FORMULA", {||.T.},,"Total EXP",{|oModel| U_MGF19TRG(oModel,.f.) })
	oModel:AddCalc("EEC19CALC", "EEC19MASTER", "EEC19DETAIL", "ZZD_PRCINC", "ZZD__TOTQC", "FORMULA", {||.T.},,"Qtde. Containers",{|oModel| U_MGF19QTC(, .F.) })

	oModel:SetVldActivate({|oModel|xVldActive(oModel)})
	oModel:SetActivate({|oModel|xActive(oModel)})

	//Nao salvar dados da soma
	oModel:GetModel( 'EEC19SOMA' ):SetOptional(.T.)
	oModel:GetModel( 'EEC19SOMA' ):SetOnlyView(.T.)
	oModel:GetModel( 'EEC19SOMA' ):SetOnlyQuery(.T.)
	oModel:GetModel( 'EEC19TC' ):SetOptional(.T.)
	oModel:GetModel( 'EEC19TC' ):SetOnlyView(.T.)
	oModel:GetModel( 'EEC19TC' ):SetOnlyQuery(.T.)

	oModel:GetModel( 'EEC19SOMA' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'EEC19SOMA' ):SetNoUpdateLine( .T. )
	oModel:GetModel( 'EEC19SOMA' ):SetNoDeleteLine( .T. )

Return oModel

/*/{Protheus.doc} ViewDef
Tratamento da tela do MVC
@author leonardo.kume
@since 30/12/2016
@version 1.0
@Alteracoes
	************
		2020/02/27
		RTASK0010784-Temperatura-Orcamento-Exp: Claudio Alves
		Foi alterada a tela para as seguintes propor��es: 45, 30, 25
	************
	
/*/

Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   	:= FWLoadModel( 'MGFEEC19' )
	// Cria a estrutura a ser usada na View
	Local oStruZZC 	:= FWFormStruct( 2, 'ZZC',,/*lViewUsado*/ )
	Local oStruZZD 	:= FWFormStruct( 2, 'ZZD',,/*lViewUsado*/ )
	Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'EEC19CALC') )
	Local oStruTC  := FWFormStruct( 2, 'ZZC', {|cCampo| alltrim(cCampo) $ "ZZC_ZDCONT" })

	Local oView
	Local cCampos := {}

	Local oStruUM  := FWFormStruct(2,'ZZD', {|cCampo| Alltrim(cCampo) $ "ZZD_SLDINI,ZZD_UNIDAD,ZZD_PRECO" })

	oStruUM:SetProperty('ZZD_SLDINI',MVC_VIEW_CANCHANGE, .F. )
	oStruTC:SetNoFolder()

	oStruZZD:RemoveField('ZZD_ORCAME')

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZC', oStruZZC, 'EEC19MASTER' )
	oView:AddGrid( 'DET_ZZD', oStruZZD, 'EEC19DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'EEC19CALC' )
	oView:AddGrid( 'VIEW_SOMA', oStruUM, 'EEC19SOMA' )
	oView:AddField( 'VIEW_TC', oStruTC, 'EEC19TC' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 45 )
	oView:CreateHorizontalBox( 'INFERIOR' , 30 )
	oView:CreateHorizontalBox( 'FIM' , 25 )

	oView:CreateFolder( 'Totais','FIM' )
	oView:AddSheet( 'Totais', 'ABA01', 'Total Orcamento' )
	oView:AddSheet( 'Totais', 'ABA02', 'Container' )
	oView:AddSheet( 'Totais', 'ABA03', 'Qtde p/ UM' )

	oView:CreateHorizontalBox( 'FIM01' , 100,,, 'Totais', 'ABA01' )
	oView:CreateHorizontalBox( 'FIM02' , 100,,, 'Totais', 'ABA02' )
	oView:CreateHorizontalBox( 'FIM03' , 100,,, 'Totais', 'ABA03' )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZC' , 'SUPERIOR' )
	oView:SetOwnerView( 'DET_ZZD'  , 'INFERIOR' )
	oView:SetOwnerView( 'VIEW_CALC', 'FIM01'     )
	oView:SetOwnerView( 'VIEW_TC', 'FIM02'     )
	oView:SetOwnerView( 'VIEW_SOMA', 'FIM03'     )
	oView:AddIncrementField('DET_ZZD', 'ZZD_SEQUEN' )

Return oView

Static Function xVldActive(oModel)
	Local nOperation := oModel:GetOperation()
	Local xRet := .t.
	If nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_DELETE
		xRet := ZZC->ZZC_APROVA $ "1/2/3/6/7"
		If !xRet
			If ZZC->ZZC_APROVA == "8"
				Help( ,, 'MGFEEC19-01',, 'Orcamento Cancelado', 1, 0 )
			Else
				Help( ,, 'MGFEEC19-03',, 'Orcamento j� tem EXP Gerada', 1, 0 )
			EndIf
		EndIf
	EndIf
Return xRet

User Function ZZCRecno()

	MsDocument("ZZC",ZZC->(Recno()),2)

Return .T.

/*/{Protheus.doc} GeraAprov
Gera registros na ZZG para enviar aprovacao
@author leonardo.kume
@since 30/12/2016
@version 1.0
/*/
User Function GeraAprov(lPergunta)
	Local _cNrOrca 	:= ''
	Local _cAprova 	:= ''
	Local _cNivel 	:= ''
	Local cNivelAt 	:= ''
	Local lFirst	:= .T.
	Local lLock 	:= .T.
	Local lEnvia 	:= .T.
	Local lRet	 	:= .T.
	Local cAlias 	:= GetNextAlias()
	Default lPergunta := .F.

	DbSelectArea("ZZG")
	ZZG->(DbSetOrder(1))
	DbSelectArea("ZZC")
	_cFilial	:= ZZC->ZZC_FILIAL
	_cNrOrca 	:= ZZC->ZZC_ORCAME // Numero do or�amento
	_cCliente 	:= ZZC->ZZC_IMPORT
	_cloja    	:= ZZC->ZZC_IMLOJA

	If lPergunta
		lEnvia := MsgYesNo("Solicita aprovacao?","Aprovacao")
	EndIF
	If lEnvia
		// 1=Aprovado;2=Pendente;3=Reprovado;4=EXP Gerada;A=Aguardando PCP Central;B=Aguardando PCP Local;C=Aguardando Diretoria;6=Aguardando Aprovacao;7=Distribuido
		If ZZC->ZZC_APROVA == "7"
			If Select(cAlias) > 0
				(cAlias)->(DbClosearea())
			Endif
			BeginSql Alias cAlias
				SELECT ZZG.R_E_C_N_O_ REC
				FROM %Table:ZZG% ZZG
				WHERE 	ZZG.D_E_L_E_T_ = ' ' AND
				ZZG.ZZG_FILIAL <> '99' AND
				ZZG.ZZG_NUMERO = %Exp:_cNrOrca% AND
				ZZG.ZZG_MSBLQL = '2'
			EndSql
			Begin Transaction
				While !(cAlias)->(Eof())
					ZZG->(DbGoTo((cAlias)->REC))
					Reclock("ZZG",.F.)
					ZZG->ZZG_MSBLQL := "1"
					ZZG->(MsUnlock())
					(cAlias)->(DbSkip())
				EndDo
			End Transaction
			If Select(cAlias) > 0
				(cAlias)->(DbClosearea())
			Endif
			BeginSql Alias cAlias
				SELECT  ZBY.ZBY_FILIAL ZZG_FILIAL,
				ZZC.ZZC_ORCAME ZZG_NUMERO,
				ZBY.ZBY_APROVA ZZG_APROVA,
				ZBY.ZBY_NIVEL  ZZG_NIVEL,
				'G'            ZZG_STATUS,
				'2'            ZZG_MSBLQL,
				ZC1.ZC1_VERSAO ZZG_VERSAO,
				ZZC.ZZC_FILIAL ZZG_FILORC
				FROM %Table:ZZC% ZZC
				INNER JOIN %Table:ZC2% ZC2
				ON  ZC2.%notDel% AND
				ZC2.ZC2_FILIAL = ZZC.ZZC_FILIAL AND
				ZC2.ZC2_ORCAME = ZZC.ZZC_ORCAME
				INNER JOIN %Table:ZC1% ZC1
				ON  ZC1.%notDel% AND
				ZC1.ZC1_FILIAL = ZC2.ZC2_FILDIS AND
				ZC1.ZC1_VERSAO = (SELECT MAX(ZBZ_VERSAO) FROM %Table:ZBZ% ZBZ WHERE ZBZ.%notDel% AND ZBZ.ZBZ_FILIAL = ZC2.ZC2_FILDIS)
				INNER JOIN %Table:ZBY% ZBY
				ON  ZBY.%notDel% AND
				ZBY.ZBY_FILIAL = ZC2.ZC2_FILDIS AND
				ZBY.ZBY_NIVEL = ZC1.ZC1_NIVEL
				WHERE   ZZC.%notDel% AND
				ZZC.ZZC_FILIAL = %Exp:_cFilial% AND
				ZZC.ZZC_ORCAME = %Exp:_cNrOrca% AND
				ZZC.ZZC_APROVA NOT IN ('1','3','4') AND
				ZZC.ZZC_ORCAME NOT IN ( SELECT ZZG.ZZG_NUMERO
				FROM %Table:ZZG% ZZG
				WHERE 	ZZG.D_E_L_E_T_ = ' ' AND
				ZZG.ZZG_FILIAL = ZBY.ZBY_FILIAL AND
				ZZG.ZZG_NUMERO = ZZC.ZZC_ORCAME AND
				ZZC.ZZC_FILIAL = ZZG_FILORC AND
				ZZG.ZZG_MSBLQL = '2' )
			EndSql
			If !(cAlias)->(Eof())
				Begin Transaction
					While !(cAlias)->(Eof())
						RecLock("ZZG",.T.)
						ZZG->ZZG_FILIAL := (cAlias)->ZZG_FILIAL
						ZZG->ZZG_NUMERO := (cAlias)->ZZG_NUMERO
						ZZG->ZZG_APROVA := (cAlias)->ZZG_APROVA
						ZZG->ZZG_NIVEL  := (cAlias)->ZZG_NIVEL
						ZZG->ZZG_STATUS := (cAlias)->ZZG_STATUS
						ZZG->ZZG_MSBLQL := (cAlias)->ZZG_MSBLQL
						ZZG->ZZG_VERSAO := (cAlias)->ZZG_VERSAO
						ZZG->ZZG_FILORC := (cAlias)->ZZG_FILORC
						ZZG->(MsUnlock())
						(cAlias)->(DbSkip())
					EndDo
					RecLock("ZZC",.F.)
					ZZC->ZZC_APROVA := "6"
					ZZC->(MsUnlock())
				End Transaction
				U_EEC19APR(.T.,lFirst)
			EndIf
		Else
			Help( ,, 'MGFEEC19-02',, 'Status do Orcamento nao permite envio de aprovacao.', 1, 0 )
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} MGF19Alt
//TODO Alteracao do or�amento
@author leonardo.kume
@since 23/10/2017
@version 6
@param cMsg, characters, Motivo alteracao
@type function
/*/
Static Function MGF19Alt(cMsg)
	Local cAliasZBY := GetNextAlias()
	Local lAlter	:= .T.
	Local cFilZZG 	:= iif(Substr(cFilAnt,1,2) == '02',cFilAnt,'010001')

	If Select(cAliasZBY) > 0
		(cAliasZBY)->(DbCloseArea())
	EndIF

	DbSelectArea("ZZG")
	ZZG->(DbSetOrder(1))
	If ZZG->(DbSeek(xFilial("ZZG")+ZZC->ZZC_ORCAME))
		While !ZZG->(Eof()) .and. ZZG->ZZG_NUMERO == ZZC->ZZC_ORCAME  //RAFAEL 19/12/2018
			RecLock("ZZG",.F.)
			ZZG->ZZG_STATUS := "C"
			ZZG->ZZG_MOTIVO := cMsg
			ZZG->(MsUnlock())
			ZZG->(DbSkip())
		EndDo
	EndIf



	BeginSql Alias cAliasZBY
		SELECT ZC1.ZC1_FILIAL, ZC1.ZC1_ORDEM, ZBY.ZBY_APROVA, ZC1.ZC1_NIVEL
		FROM %Table:ZBY% ZBY
		INNER JOIN %Table:ZC1% ZC1
		ON      ZC1.%notDel% AND
		ZC1.ZC1_FILIAL = ZBY.ZBY_FILIAL AND
		ZC1.ZC1_NIVEL = ZBY.ZBY_NIVEL AND
		ZC1.ZC1_VERSAO = (SELECT MAX(ZBZ_VERSAO) VERSAO
		FROM %Table:ZBZ% ZBZ
		WHERE   ZBZ.%NotDel% AND
		ZBZ.ZBZ_FILIAL = ZBY.ZBY_FILIAL)
		WHERE   ZBY.%NotDel% AND
		ZBY.ZBY_FILIAL = %Exp:cFilZZG%
	EndSql

	While !(cAliasZBY)->(Eof())
		nQuant := QuantFil((cAliasZBY)->ZC1_FILIAL,ZZC->ZZC_ORCAME)
		EnvAprov(UsrRetName((cAliasZBY)->ZBY_APROVA),UsrFullName((cAliasZBY)->ZBY_APROVA),UsrRetMail((cAliasZBY)->ZBY_APROVA),ZZC->ZZC_ORCAME,,cMsg,,lAlter,nQuant,(cAliasZBY)->ZC1_FILIAL)
		(cAliasZBY)->(DbSkip())
	EndDo
	(cAliasZBY)->(DbCloseArea())
Return


/*/{Protheus.doc} EEC19CAN
//TODO Cancela
@author leonardo.kume
@since 23/10/2017
@version 6
@type function

@Alteracoes
	************
		2020/02/17
		RTASK0010722-automatizar-campo-situacao-orcamento-exp: Claudio Alves
		autamatiza��o do campo de motivo de situacao quando o or�amento for cancelado.
	************

/*/
User Function EEC19CAN()
	local cPerg  	:= "MGFEEC19A"
	local cMotivo	:= ""
	local lRet		:= .T.

	If ZZC->ZZC_APROVA $ "1/2/3/6/7"
		If MsgYesNo("Deseja Realmente cancelar o or�amento?"+CRLF+"Uma vez cancelado nao sera mais permitido retornar")
			While Empty(Alltrim(cMotivo)) .AND. lRet
				lRet := Pergunte(cPerg,.t.)
				If lRet
					cMotivo := MV_PAR01
				EndIf
			EndDo
			If lRet
				RecLock("ZZC",.f.)
				ZZC->ZZC_APROVA :=	"8"
				ZZC->ZZC_ENDBEN :=	cMotivo
				ZZC->ZZC_MOTSIT :=	"0010"
				ZZC->ZZC_STTDES	:=	'CANCELADO'
				ZZC->(MsUnlock())
			EndIf
		EndIf
	Else
		Help( ,, 'MGFEEC19-04',, 'Orcamento j� tem EXP gerada ou esta cancelado', 1, 0 )
	EndIf

Return

/*/{Protheus.doc} EEC19APR
//TODO Rotina para aprovacao/Reprova��o de Or�amentos
@author leonardo.kume
@since 23/10/2017
@version 6
@param lAprov, logical, Se Aprova ou Reprova
@param lFirst, logical, Se � o primeiro envio de WF
@type function
/*/
User Function EEC19APR(lAprov,lFirst)
	Local _cAreaZZC := ZZC->(GetArea())
	Local _cAreaZZG := ZZG->(GetArea())
	Local _cAreaZC2 := ZC2->(GetArea())
	Local cNivel 	:= ""
	Local cMsg 		:= ""
	Local cReprov 	:= ""
	Local cPerg  	:= "MGFEEC19"
	Local cMotivo 	:= ""
	Local cAliasZZG := GetNextAlias()
	Local cOrdem 	:= ""
	Local cProx	 	:= ""
	Local cAprov 	:= RetCodUsr()
	Local lOk 		:= .F.
	Local cFilAtu	:= ""
	Local cPerg  	:= "MGFEEC19"
	Local lRet  	:= .T.
	Local nQuant  	:= 0

	Default lFirst := .F.

	DbSelectArea("ZZG")
	// Numero + Nivel
	DbSetOrder(3)
	DbSelectArea("ZZF")
	// Nivel + Usuario
	DbSetOrder(2)

	lOk 	:= .F.
	cOrdem 	:= ""

	If ZZC->ZZC_APROVA $ "2" .AND. ZZC->ZZC_ZDISTR == "1" .and. !lAprov// Pendente
		cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+" esta em fase de distribui��o e sera reprovado."+ CRLF
		While Empty(Alltrim(cMotivo)) .AND. lRet
			lRet := Pergunte(cPerg,.t.)
			If lRet
				cMotivo := MV_PAR01
			EndIf
		EndDo
		// Muda o status do or�amento para Reprovado
		If lRet
			ZZC->(RecLock("ZZC",.F.))
			ZZC->ZZC_APROVA := "3"
			ZZC->ZZC_ZDISTR := "2"
			ZZC->ZZC_END2BE	:= cMotivo
			ZZC->(MsUnlock())
			If GetMv("MGF_EEC19E",,.t.)//Habilita e-mail de reprova��o Distribuicao
				EnvAprov(UsrRetName(RetCodUsr()),"",GetMV("MGF_EEC19P",,"maila.catanozi@marfig.com.br"),ZZC->ZZC_ORCAME,.f.,cMotivo)
			EndiF
		EndIf
	ElseIf ZZC->ZZC_APROVA $ "2"
		cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+" ainda nao gerou alcada."+ CRLF
	ElseIf ZZC->ZZC_APROVA $ "1"// Aprovado
		cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+" j� aprovado."+ CRLF
	ElseIf ZZC->ZZC_APROVA $ "3"// Reprovado
		cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+" j� reprovado."+ CRLF
	ElseIf ZZC->ZZC_APROVA $ "6" // Na alcada de aprovacao
		If !lFirst //Primeiro envio de e-mail nao passa pela aprovacao
			cAliasZZG := GetNextAlias()
			If Select(cAliasZZG) > 0
				(cAliasZZG)->(DbCloseArea())
			EndIF
			//Aprovacao/Reprova��o do n�vel
			BeginSql Alias cAliasZZG
				SELECT ZZG.R_E_C_N_O_ REC, ZZG.ZZG_FILIAL, ZC1.ZC1_ORDEM, ZZG.ZZG_APROVA, ZZG.ZZG_NIVEL
				FROM %Table:ZZG% ZZG
				INNER JOIN %Table:ZC1% ZC1
				ON  ZC1.%notDel% AND
				ZC1.ZC1_VERSAO = ZZG.ZZG_VERSAO AND
				ZC1.ZC1_NIVEL = ZZG.ZZG_NIVEL AND
				ZC1.ZC1_FILIAL <> '99'
				WHERE   ZZG.%notDel% AND
				ZZG.ZZG_FILIAL <> '99' AND
				ZZG.ZZG_NUMERO = %Exp:ZZC->ZZC_ORCAME% AND
				ZZG.ZZG_FILORC = %Exp:ZZC->ZZC_FILIAL% AND
				ZZG.ZZG_MSBLQL IN ('2',' ') AND
				ZZG.ZZG_STATUS IN ('P') AND
				EXISTS( SELECT '*' FROM %Table:ZZG% ZZG1
				WHERE 	ZZG1.%NotDel% AND
				ZZG1.ZZG_NUMERO = ZZG.ZZG_NUMERO AND
				ZZG1.ZZG_FILORC = ZZG.ZZG_FILORC AND
				ZZG1.ZZG_FILIAL = ZZG.ZZG_FILIAL AND
				ZZG1.ZZG_NIVEL = ZZG.ZZG_NIVEL AND
				ZZG1.ZZG_MSBLQL IN ('2',' ') AND
				ZZG1.ZZG_APROVA = %Exp:cAprov%)
				ORDER BY ZZG.ZZG_FILIAL, ZC1.ZC1_ORDEM
			EndSql

			If !(cAliasZZG)->(Eof())//Se encontrar alcada
				Begin Transaction
					//Aprovacao/Reprova��o
					While !(cAliasZZG)->(Eof()) //.and. cOrdem == (cAliasZZG)->ZC1_ORDEM
						cFilAtu	:= (cAliasZZG)->ZZG_FILIAL
						cOrdem 	:= (cAliasZZG)->ZC1_ORDEM
						cNivel 	:= (cAliasZZG)->ZZG_NIVEL
						While cFilAtu	== (cAliasZZG)->ZZG_FILIAL .and. cOrdem == (cAliasZZG)->ZC1_ORDEM
							If  (cAliasZZG)->ZZG_APROVA == cAprov
								lOk := .T.
								ZZG->(DbGoTo((cAliasZZG)->REC))
								ZZG->(RecLock("ZZG",.F.))
								ZZG->ZZG_STATUS := iIf(lAprov,"A","R")
								ZZG->ZZG_DTAPRO := iif(lAprov,ddatabase,stod(""))
								ZZG->ZZG_HREJEI := Time()
								if !lAprov
									While Empty(Alltrim(cMotivo))
										Pergunte(cPerg,.T.)
										cMotivo := MV_PAR01
									EndDo
									ZZG->ZZG_MOTIVO := cMotivo
								EndIf
								ZZG->(MsUnlock())
								If !lAprov
									// Muda o status do or�amento para Reprovado
									ZZC->(RecLock("ZZC",.F.))
									ZZC->ZZC_APROVA := "3"
									ZZC->(MsUnlock())
								EndIf
								cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+iif(lAprov," aprovado"," reprovado")+" n�vel "+cNivel+"."+ CRLF
							Else //Outros registros do n�vel devem alterar para N - Aprovado/reprovado pelo n�vel
								ZZG->(DbGoTo((cAliasZZG)->REC))
								ZZG->(RecLock("ZZG",.F.))
								ZZG->ZZG_STATUS := "N"
								ZZG->(MsUnlock())
							EndIf
							(cAliasZZG)->(DbSkip())
						EndDo
					EndDo
				End Transaction
			Else
				cMsg += "Orcamento "+alltrim(ZZC->ZZC_ORCAME)+" nao tem alcada para o n�vel ou usuario nao tem acesso."+ CRLF
			EndIf
		EndIf

		If Select(cAliasZZG) > 0
			(cAliasZZG)->(DbCloseArea())
		EndIF

		//Envio de e-mail para n�veis anteriores caso reprovado
		cAliasZZG := GetNextAlias()
		If Select(cAliasZZG) > 0
			(cAliasZZG)->(DbCloseArea())
		EndIF
		If !lAprov
			ZZG->(DbSetOrder(1))

			BeginSql Alias cAliasZZG
				SELECT ZZG.R_E_C_N_O_ REC, ZC1.ZC1_FILIAL, ZC1.ZC1_ORDEM, ZZG.ZZG_STATUS, ZZG.ZZG_NIVEL, ZZG.ZZG_MOTIVO, ZZG.ZZG_APROVA
				FROM %Table:ZZG% ZZG
				INNER JOIN %Table:ZC1% ZC1
				ON  ZC1.%notDel% AND
				ZC1.ZC1_VERSAO = ZZG.ZZG_VERSAO AND
				ZC1.ZC1_NIVEL = ZZG.ZZG_NIVEL AND
				ZC1.ZC1_FILIAL <> '99'
				WHERE   ZZG.%notDel% AND
				ZZG.ZZG_NUMERO = %Exp:ZZC->ZZC_ORCAME% AND
				ZZG.ZZG_FILIAL <> '99' AND
				ZZG.ZZG_FILORC = %Exp:ZZC->ZZC_FILIAL% AND
				ZZG.ZZG_STATUS IN ('A','W','N') AND
				ZZG.ZZG_MSBLQL IN ('2',' ') AND
				ZC1.ZC1_ORDEM <> %Exp:cOrdem% AND
				EXISTS( SELECT '*' FROM %Table:ZZG% ZZG1
				WHERE 	ZZG1.%NotDel% AND
				ZZG1.ZZG_NUMERO = ZZG.ZZG_NUMERO AND
				ZZG1.ZZG_FILORC = ZZG.ZZG_FILORC AND
				ZZG1.ZZG_FILIAL = ZZG.ZZG_FILIAL AND
				ZZG1.ZZG_NIVEL = ZZG.ZZG_NIVEL AND
				ZZG1.ZZG_MSBLQL IN ('2',' ') AND
				ZZG1.ZZG_STATUS in ('A','R') AND
				ZZG1.ZZG_APROVA = %Exp:cAprov%)
				ORDER BY ZC1.ZC1_ORDEM
			EndSql

			If !(cAliasZZG)->(Eof())
				While !(cAliasZZG)->(Eof())
					nQuant := QuantFil((cAliasZZG)->ZC1_FILIAL,ZZC->ZZC_ORCAME) //ALTERADO RAFAEL 16/11/2018
					EnvAprov(UsrRetName(RetCodUsr()),UsrFullName((cAliasZZG)->ZZG_APROVA),UsrRetMail((cAliasZZG)->ZZG_APROVA),ZZC->ZZC_ORCAME,lAprov,cMotivo,,,nQuant,(cAliasZZG)->ZC1_FILIAL)
					(cAliasZZG)->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf

	If ZZC->ZZC_APROVA $ "6/7" .and. (lOk .or. lFirst)// Somente manda caso tenha tido aprovacao ou � primeiro e-mail
		If Select(cAliasZZG) > 0
			(cAliasZZG)->(DbCloseArea())
		EndIF

		//Envio de e-mail para pr�ximos n�veis
		cAliasZZG := GetNextAlias()
		If Select(cAliasZZG) > 0
			(cAliasZZG)->(DbCloseArea())
		EndIF

		BeginSql Alias cAliasZZG
			SELECT ZZG.ZZG_FILIAL, ZZG.R_E_C_N_O_ REC, ZC1.ZC1_ORDEM, ZZG.ZZG_APROVA, ZZG.ZZG_NIVEL, ZC1.ZC1_APROVA, ZC1.ZC1_WFTXT
			FROM %Table:ZZG% ZZG
			INNER JOIN %Table:ZC1% ZC1
			ON  ZC1.%notDel% AND
			ZC1.ZC1_VERSAO = ZZG.ZZG_VERSAO AND
			ZC1.ZC1_NIVEL = ZZG.ZZG_NIVEL AND
			ZC1.ZC1_FILIAL = ZZG.ZZG_FILIAL
			WHERE   ZZG.%notDel% AND
			ZZG.ZZG_FILIAL <> '99' AND
			ZZG.ZZG_NUMERO = %Exp:ZZC->ZZC_ORCAME% AND
			ZZG.ZZG_FILORC = %Exp:ZZC->ZZC_FILIAL% AND
			ZZG.ZZG_STATUS IN ('G') AND
			ZZG.ZZG_MSBLQL IN ('2',' ') AND
			NOT EXISTS( SELECT '*' FROM %Table:ZZG% ZZG1
			WHERE 	ZZG1.%NotDel% AND
			ZZG1.ZZG_FILIAL <> '99' AND
			ZZG1.ZZG_NUMERO = ZZG.ZZG_NUMERO AND
			ZZG1.ZZG_FILORC = ZZG.ZZG_FILORC AND
			ZZG1.ZZG_FILIAL = ZZG.ZZG_FILIAL AND
			ZZG1.ZZG_MSBLQL IN ('2',' ') AND
			ZZG1.ZZG_STATUS = 'P')
			ORDER BY ZZG.ZZG_FILIAL, ZC1.ZC1_ORDEM
		EndSql
		If !(cAliasZZG)->(Eof())
			Begin Transaction
				While !(cAliasZZG)->(Eof())
					cFilAtu := (cAliasZZG)->ZZG_FILIAL
					cProx := (cAliasZZG)->ZC1_ORDEM
					While !(cAliasZZG)->(Eof()) .and. cFilAtu == (cAliasZZG)->ZZG_FILIAL
						If Empty(Alltrim(cProx))
							cProx := (cAliasZZG)->ZC1_ORDEM
						EndIf
						ZZG->(DbGoTo((cAliasZZG)->REC))
						If cProx == (cAliasZZG)->ZC1_ORDEM
							Reclock("ZZG",.F.)
							If (cAliasZZG)->ZC1_APROVA == "1"
								ZZG->ZZG_STATUS := "P"
							Else
								ZZG->ZZG_STATUS := "W"
								cProx := ""
							EndIf
							ZZG->(MsUnlock())
							nQuant := QuantFil(ZZG->ZZG_FILIAL,ZZC->ZZC_ORCAME)
							EnvAprov(ZZG->ZZG_APROVA,UsrFullName(ZZG->ZZG_APROVA),UsrRetMail((cAliasZZG)->ZZG_APROVA),ZZC->ZZC_ORCAME,,(cAliasZZG)->ZC1_WFTXT,ZZG->ZZG_STATUS == "W",,nQuant, ZZC->ZZC_ORCAME)
						EndIf
						(cAliasZZG)->(dbSkip())
					EndDo
				EndDo
				If ZZC->ZZC_APROVA <> "6"
					ZZC->(RecLock("ZZC",.F.))
					ZZC->ZZC_APROVA := "6"
					ZZC->(MsUnlock())
				EndIf
				cMsg += "E-mails enviados com sucesso."+CRLF
			End Transaction
		EndIf

		If Select(cAliasZZG) > 0
			(cAliasZZG)->(DbCloseArea())
		EndIF

		BeginSql Alias cAliasZZG
			SELECT ZZG.R_E_C_N_O_ REC, ZC1.ZC1_ORDEM, ZZG.ZZG_APROVA, ZZG.ZZG_NIVEL, ZC1.ZC1_APROVA, ZC1.ZC1_WFTXT
			FROM %Table:ZZG% ZZG
			INNER JOIN %Table:ZC1% ZC1
			ON  ZC1.%notDel% AND
			ZC1.ZC1_VERSAO = ZZG.ZZG_VERSAO AND
			ZC1.ZC1_NIVEL = ZZG.ZZG_NIVEL
			WHERE   ZZG.%notDel% AND
			ZZG.ZZG_NUMERO = %Exp:ZZC->ZZC_ORCAME% AND
			ZZG.ZZG_FILORC = %Exp:ZZC->ZZC_FILIAL% AND
			ZZG.ZZG_STATUS IN ('G','P') AND
			ZZG.ZZG_MSBLQL IN ('2',' ')
			ORDER BY ZC1.ZC1_ORDEM
		EndSql
		If (cAliasZZG)->(Eof())
			ZZC->(RecLock("ZZC",.F.))
			ZZC->ZZC_APROVA := "1"
			ZZC->(MsUnlock())

			DBSELECTAREA("ZC2")//Alteracao Rafael 31/10/2018
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("ZC2")+ZZC->ZZC_ORCAME)
				WHILE ZC2->(!EOF()) .AND. ZC2->ZC2_ORCAME==ZZC->ZZC_ORCAME .AND. ZC2->ZC2_FILIAL==ZZC->ZZC_FILIAL
					DBSELECTAREA("ZZG")
					DBSETORDER(1)
					IF DBSEEK(ZC2->ZC2_FILDIS+ZC2->ZC2_ORCAME+"2")
						WHILE ZZG->(!EOF()) .AND. ZC2->ZC2_FILDIS==ZZG->ZZG_FILIAL .AND. ZC2->ZC2_ORCAME==ZZG->ZZG_NUMERO
							Reclock("ZZG",.F.)
							ZZG->ZZG_STATUS := "A"
							ZZG->ZZG_DTAPRO := DDATABASE
							ZZG->(MsUnlock())
							ZZG->(dbSkip())
						ENDDO
					ENDIF
					ZC2->(dbSkip())
				EndDo
			ENDIF
		EndIF
	EndIf

	If !Empty(Alltrim(cMsg))
		MsgInfo(cMsg,"*Aprovacao Orcamento*")
	Else
		MsgInfo("Erro ao tentar efetuar a aprovacao/reprova��o.","*Aprovacao Orcamento*")
	EndIf

	If Select(cAliasZZG) > 0
		(cAliasZZG)->(DbCloseArea())
	EndIF
	RestArea(_cAreaZC2)
	RestArea(_cAreaZZG)
	RestArea(_cAreaZZC)
Return(.T.)


/*/{Protheus.doc} EnvAprov
Monta e Envia e-mail de aprovacao
@author leonardo.kume
@since 30/12/2016
@version 1.0
@param _cAprova, char, Codigo Aprovador
@param _cNome, char, Nome Aprovador
@param _cEmail, char, Email Aprovador
@param _cListOrc, char, N�meros dos or�amentos para aprovar
@param lAprov, boolean, Se � aprovacao ou Reprova��o
@param cMotivo, char, motivo Reprova��o/ Workflow / Alteracao
@param lWF, boolean, Se � somente envio de workflow
@param lAlt, char, Se � alteracao
/*/
Static Function EnvAprov(_cAprova,_cNome,_cEmail,_cListOrc, lAprov,cMotivo,lWF,lAlt,nQuant,cFil)

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail

	Default lAprov 	:= .T.
	Default cMotivo := ""
	Default lWF		:= .f.
	Default lAlt	:= .f.
	Default nQuant	:= 0
	Default cFil	:= ""

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := alltrim(_cEmail)
	oMessage:cCc                    := ""
	oMessage:cSubject               := iif(lAlt,"Alteracao Orcamento",iif(lWF,"Workflow Orcamento",iif(lAprov,"Aprovacao de Or�amentos","Reprova��o de Or�amentos")))

	If lAlt
		oMessage:cBody := "<body><p />Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"<p />Orcamento "+alltrim(_cListOrc) +" "+cMotivo+"."
	ElseIf lWF
		oMessage:cBody := "<body><p />Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"<p />Orcamento "+alltrim(_cListOrc) +" "+cMotivo+"."
	ElseIf lAprov
		oMessage:cBody := "<body><p />Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"<p />Solicitamos aprovacao do(s) or�amento(s) "+alltrim(_cListOrc)
	Else
		oMessage:cBody := "<body><p />Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"<p />O Orcamento "+alltrim(_cListOrc) +" foi reprovado pelo "+alltrim(_cAprova)
		oMessage:cBody += CRLF+"<p />Motivo: "+ Alltrim(cMotivo)
	EndIF

	If nQuant > 0
		oMessage:cBody += CRLF + CRLF +"<ul><li>"+ Alltrim(Str(nQuant)) + " Distribu�dos.</li><ul>"
	EndIf
	oMessage:cBody += "</body>"

	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()


Return lRetMail



User Function EEC100Inc()
	Local aItens := {}
	Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo
	Local aCab := { {'EE7_FILIAL' ,'01' ,NIL},;
		{'EE7_PEDIDO' ,'100000000000005' ,NIL},; //
	{'EE7_CALCEM' ,'1' ,NIL},; //
	{'EE7_IMPORT' ,'000002' ,NIL},;
		{'EE7_IMLOJA' ,'01' ,NIL},;
		{'EE7_IMPODE' ,"IMPORTADOR" ,NIL},;
		{'EE7_FORN' ,'000002' ,NIL},;
		{'EE7_FOLOJA' ,'01' ,NIL},;
		{'EE7_CONDPA' ,'20/80' ,NIL},;
		{'EE7_DIASPA' ,901 ,NIL},;
		{'EE7_MPGEXP' ,'001' ,NIL},;
		{'EE7_INCOTE' ,'FOB' ,NIL},;
		{'EE7_MOEDA' ,'US$' ,NIL},;
		{'EE7_FRPPCC' ,'PP' ,NIL},;
		{'EE7_VIA' ,'01' ,NIL},;
		{'EE7_ORIGEM' ,'AGA' ,NIL},;
		{'EE7_DEST' ,'SSZ' ,NIL},;
		{'EE7_PAISET' ,'105' ,NIL},;
		{'EE7_IDIOMA' ,"INGLES-INGLES" ,NIL},;
		{'EE7_CODBOL' ,"NY" ,NIL},; //
	{'EE7_COND2 ' ,"CAD" ,NIL},; //
	{'EE7_DIAS2 ' ,45 ,NIL},; //
	{'EE7_INCO2 ' ,"CFR" ,NIL},; //
	{'EE7_INTERM' ,"1" ,NIL},; //
	{'EE7_CLIENT' ,"000002" ,NIL},; //
	{'EE7_EXPORT' ,"088190" ,NIL},; //
	{'EE7_CLLOJA' ,"01" ,NIL},; //
	{'EE7_EXLOJA' ,"01" ,NIL},; //
	{'EE7_PERC' ,10 ,NIL},; //
	{'EE7_TIPTRA' ,'1' ,NIL}}

	// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica da capa do bem
	Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsist�ncia na execucao da rotina
	aAdd(aItens,{{'EE8_COD_I' ,'000000' , NIL},;
		{'EE8_SEQUEN' ,"000001" , NIL},;
		{'EE8_FORN' ,'000002' , NIL},;
		{'EE8_FOLOJA' ,'01' , NIL},;
		{'EE8_SLDINI' , 6 , NIL},;
		{'EE8_PRCINC' , 10 , NIL},;//
	{'EE8_PRENEG' , 10 , NIL},;//
	{'EE8_PRCTOT' , 60 , NIL},;//
	{'EE8_EMBAL1' , '4' , NIL},;
		{'EE8_QE' , 10 , NIL},;
		{'EE8_PSLQUN' , 10 , NIL},;
		{'EE8_POSIPI' , "01011010" , NIL},;
		{'EE8_QTDEM1' , 6 , NIL},;//
	{'EE8_TES' , "501" , NIL},;//
	{'EE8_CF' , "7101" , NIL},;//
	{'EE8_PRECO' , 10 , NIL}})
	MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCab ,aItens, 3)
	If lMsErroAuto
		lRetorno := .F.
		MostraErro()
	Else
		lRetorno:=.T.
	EndIf
Return

User Function EEC19A(cParam)

	Local lRet := .T.
	Local nToler := 0
	Local cAliasEE8 := GetNextAlias()
	Local cQuery := ""

	If cParam == "VALIDA_ITEM"
		nToler := GetMv("MGF_19TOLE",, 10)

		cQuery += " SELECT EE8_SLDINI, D2_QUANT           			   "+CRLF
		cQuery += " FROM "+RetSqlName("EE8")+" EE8            		   "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5                "+CRLF
		cQuery += " ON 	C5.D_E_L_E_T_ = ' ' AND                        "+CRLF
		cQuery += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND        "+CRLF
		cQuery += " 	C5.C5_PEDEXP = EE8.EE8_PEDIDO                  "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("SD2")+" D2                "+CRLF
		cQuery += " ON 	D2.D_E_L_E_T_ = ' ' AND                        "+CRLF
		cQuery += " 	D2.D2_FILIAL = '"+xFilial("SD2")+"' AND        "+CRLF
		cQuery += " 	D2.D2_PEDIDO = C5.C5_NUM AND                   "+CRLF
		cQuery += " 	D2.D2_ITEMPV = EE8.EE8_FATIT                   "+CRLF
		cQuery += " WHERE 	EE8.D_E_L_E_T_ = ' ' AND                   "+CRLF
		cQuery += " 		EE8.EE8_FILIAL = '"+xFilial("EE8")+"' AND  "+CRLF
		cQuery += " 		EE8.EE8_PEDIDO = '"+M->EE9_PEDIDO+"'    	   "+CRLF

		// TcQuery cQuery New Alias cAliasEE8 //-- Monta a Query
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasEE8,.F.,.T.)

		While !(cAliasEE8)->(Eof())
			lRet := lRet .and. (cAliasEE8)->D2_QUANT <= ((cAliasEE8)->EE8_SLDINI+nToler) .AND. (cAliasEE8)->D2_QUANT >= ((cAliasEE8)->EE8_SLDINI - nToler)
			(cAliasEE8)->(DbSkip())
		EndDo
		If !lRet
			lRet := MsgYesNo("Quantidade fora do range de toler�ncia!"+CRLF+"Deseja continuar?")
		EndIf
	EndIf

Return lRet

User Function MGFE19A()
	Local lRet := .T.
	Local aAreaEE7 := EE7->(GetArea())
	Local aAreaSF2 := SF2->(GetArea())
	Local aAreaSC6 := SC6->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaAtu := GetArea()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

	If 	IsInCallStack("EECAE100") .and. cParam ==  "DETIP_ACTIVATE_DLG"
		DbSelectArea("EE7")
		EE7->(DbSetOrder(1))
		If EE7->(DbSeek(xFilial("EE7")+M->EE9_PEDIDO))
			DbSelectArea("EE8")
			EE8->(DbSetOrder(1))
			If EE8->(DbSeek(xFilial("EE8")+M->EE9_PEDIDO+M->EE9_SEQUEN))
				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial("SC6")+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
					DbSelectArea("SD2")
					SD2->(DbSetOrder(8))
					If SD2->(DbSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_ITEM))
						M->EE9_SLDINI := SD2->D2_QUANT
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	EE7->(RestArea(aAreaSD2))
	SC6->(RestArea(aAreaSC6))
	SF2->(RestArea(aAreaSF2))
	RestArea(aAreaAtu)

Return lRet

User Function CONSZB7()
	//VARIAVEIS LISTBOX
	Local cVar     := Nil
	Local oDlg     := Nil
	Local cTitulo  := "Cadastro de Regra de Exportacao"
	Local oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local oChk     := Nil
	Local _cQryZB7 := ""
	Local cEnter		:=	Chr(13)
	//VARIAVEIS MSSELECT

	Private DELETA := .T.
	Private _oCodigo   := Nil
	Private _oDescr     := Nil
	Private _oGrupo     := Nil
	Private _oDescGr    := Nil

	Private _cCodigo   := space(6)
	Private _cDescri    :=space(30)
	Private _cGrupo    :=space(4)
	Private _cDescGr   := space(30)
	Private _cMarca := ""
	Private _lOK	  := .T.
	Private lInverte  := .F.
	//VARIAVEIS DE TELA E CAMPO

	//VARIAVEIS LISTBOX
	Private lChk     := .F.
	Private oLbx := Nil
	Private aCol := {}
	Private lMark    := .F.
	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	// Privates das NewGetDados
	Private oGetDados1
	// Variaveis deste Form
	Private nX			:= 0
	//�����������������������������������Ŀ
	//� Variaveis da MsNewGetDados()      �
	//�������������������������������������
	// Vetor responsavel pela montagem da aHeader
	Private aCpoGDa       	:= {""}

	// Vetor com os campos que poderao ser alterados
	Private aAlter       	:= {""}
	Private nSuperior    	:= C(010)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
	Private nEsquerda    	:= C(005)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
	Private nInferior    	:= C(165)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
	Private nDireita     	:= C(390)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

	// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Private cLinhaOk     	:= "AllwaysTrue" //"U_MGLINOK"   	// Funcao executada para validar o contexto da linha atual do aCols
	Private cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Private cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.

	// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
	// segundo campo>+..."
	Private nFreeze      	:= 000              // Campos estaticos na GetDados.
	Private nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
	Private cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
	Private cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Private cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols

	// Objeto no qual a MsNewGetDados sera criada
	Private oWnd          	:= _oDlg
	Private aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader
	Private aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols
	Private _lLib           := .T.
	
	//tratativa da chamada se for mata103 ou mata140
	// Carrega aHead
	_aDbfRet	:=	{}
	AAdd( _aDbfRet, {"T_CODIGO"		    ,"C",6,00})
	AAdd( _aDbfRet, {"T_DESCRI"			,"C",60,00})

	_cArqNovo := CriaTrab(_aDbfRet,.T.)
	dbUseArea(.T.,,_cArqNovo,"TR1",.F.,.F.)

	AADD( aHead,{ "CODIGO"		        , "T_CODIGO" 	 ,"" 	 , 6, 00,'',""  , "C" , ""})
	AADD( aHead,{ "DECRICAO"	        , "T_DESCRI" 	 ,"" 	 , 30, 00,'',"" , "C" , ""})
	AADD( aHead,{ "GRUPO"	            , "T_GRUPO" 	 ,"" 	 , 4, 00,'',"" , "C" , ""})
	AADD( aHead,{ "DESC GRUP"	        , "T_DESGRU"     ,""	 , 30, 00,'',"" ,"C" ,""})
	AADD( aHead,{ "UNIDADE"	            , "T_UNIDAD"     ,""	 , 6, 00,'',"" ,"C" ,""})
	AADD( aHead,{ "DESC UNID"           , "T_DESCUN"     ,""	 , 30, 00,'',"" ,"C" ,""})

	If Select("TRBZB7") > 0
		dbselectArea("TRBZB7")
		dbCloseArea()
	EndIf
	_cQryZB7	+= " SELECT ZB7.ZB7_CODIGO CODIGO, ZB7.ZB7_DESCRI DESCRI, ZB7.ZB7_GRUPO GRUPO, ZB7.ZB7_DESGRU DESGRU, "
	_cQryZB7	+= " ZB7.ZB7_UNIDAD UNIDAD, ZB7.ZB7_DESCUN DESCUN ""
	_cQryZB7	+= " FROM "
	_cQryZB7	+=	RetSqlName("ZB7")+" ZB7 "
	_cQryZB7	+= " WHERE"
	_cQryZB7	+= " ZB7.D_E_L_E_T_ = ' '"
	_cQryZB7	+= " ORDER BY"
	_cQryZB7	+= " ZB7.ZB7_FILIAL,ZB7.ZB7_CODIGO "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,	_cQryZB7), 'TRBZB7', .F., .T.)
	//-- Carrega ACOLS
	dbSelectArea("TRBZB7")
	dbGoTop()
	DEFINE FONT oFont  	NAME "Arial" Size 9,12 BOLD //11,15 BOLD
	DEFINE FONT oFont1	NAME "Arial" Size 9,12 ////11,15
	DEFINE MSDIALOG _oDlg TITLE "Regras de Exportacao" FROM C(010),C(201) TO C(400),C(980) PIXEL
	Do While TRBZB7->(!Eof())
		aadd(aCol,{TRBZB7->CODIGO,TRBZB7->DESCRI,TRBZB7->GRUPO,TRBZB7->DESGRU,TRBZB7->UNIDAD,TRBZB7->DESCUN,.F.})
		TRBZB7->(DbSkip())
	Enddo

	@ C(180),C(340) Button "OK" Size C(037),C(012) Action (RetRegra(), _oDlg:End() )  PIXEL OF _oDlg

	oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,IIF(_lLib,GD_INSERT+GD_DELETE+GD_UPDATE,0),cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aCol)

	ACTIVATE MSDIALOG _oDlg CENTERED //ON INIT MOSTRAPG(oGetDados1)
	If Select("TR1") > 0
		dbselectArea("TR1")
		dbCloseArea()
	EndIf
Return(.T.)

/*/{Protheus.doc} RetRegra
//TODO Retorna a regra selecionada.
@author Eugenio Arcanjo
@since 06/04/2017
@version 1.0

@type function
/*/
Static Function RetRegra()
	Local oModel  := FwModelActive()
	Local oStruZZD := oModel:GetModel("EEC19DETAIL")
	oStruZZD:SetValue("ZZD_XREGEX", acol[oGetDados1:obrowse:nat][6])
	oStruZZD:SetValue("ZZD_XREGEX", acol[oGetDados1:obrowse:nat][6])
Return

/*
=====================================================================================
Programa............: xMG19GEXP
Autor...............: Joni Lima
Data................: 18/04/2017
Descricao / Objetivo: Geracao de EXP
=====================================================================================
*/
User function xMG19GEXP()

	Local aArea := GetArea()
	Local cPerg	:= 'XMG19EXP'

	If ZZC->ZZC_APROVA == '1'
		If xM19ExZB8()
			If Pergunte(cPerg,.T.)
				Processa({||xGerEXP()},"Aguarde a geracao da EXP")
			EndIf
		Else
			Alert('J� Existe EXP gerada para esse Orcamento')
		EndIf

	Else
		Alert('Para geracao de Exp � necessario que o or�amento esteja Aprovado')
	EndIf

	RestArea(aArea)

return

/*
=====================================================================================
Programa............: xM19ExZB8
Autor...............: Joni Lima
Data................: 18/04/2017
Descricao / Objetivo: Verifica se Existe Exp Gerada para o Orcamento
=====================================================================================
*/
Static function xM19ExZB8()

	Local aArea 	:= GetArea()
	Local aAreaZB8	:= ZB8->(GetArea())

	Local lRet := .T.

	dbSelectArea('ZB8')
	ZB8->(dbSetOrder(1))//ZB8_FILIAL+ZB8_ORCAME

	If ZB8->(dbSeek(xFilial('ZB8') + ZZC->ZZC_ORCAME))
		lRet := .F.
	EndIf

	RestArea(aAreaZB8)
	RestArea(aArea)

return lRet

/*
=====================================================================================
Programa............: xGerEXP
Autor...............: Joni Lima
Data................: 18/04/2017
Descricao / Objetivo: Geracao de EXP
=====================================================================================
*/
Static function xGerEXP()
	Local aArea 	:= GetArea()
	Local aAreaZZC	:= ZZC->(GetArea())
	Local aAreaZZD	:= ZZD->(GetArea())
	Local aCPOZZC 	:= {}
	Local aCPOZZD 	:= {}
	Local aDadZZC 	:= {}
	Local aDadZZD 	:= {}
	Local aDadIZZD  := {}
	Local cChavOrc	:= xFilial('ZZD') + ZZC->ZZC_ORCAME
	Local nPos		:= 0
	Local ni
	Local nx
	Local nQuant	:= IIF(ZZC->ZZC_ZQTDCO<=0,1,ZZC->ZZC_ZQTDCO)
	Local aNumer	:= {}
	Local cNum		:= ""
	Local cSub		:= ""
	Local lGeraSub := MV_PAR01 == 1
	Local cPerg := "MGFEEC15"
	Local cResp := ""

	Pergunte(cPerg,.T.)
	cResp := MV_PAR01

	ProcRegua(0)
	IncProc()

	aCPOZZC := xGerArX3('ZZC')//Cabecalho Orcamento
	aCPOZZD := xGerArX3('ZZD')//Itens Orcamento

	aDadZZC := {xPreenDad(aCPOZZC,'ZZC')} //Carrega Dados cabecalho Possicionado

	dbSelectArea('ZZD')
	ZZD->(dbSetOrder(1))//ZZD_FILIAL+ZZD_ORCAME+ZZD_SEQUEN

	//Carerga itens
	If ZZD->(dbSeek(cChavOrc))
		While ZZD->(!EOF()) .and. ZZD->(ZZD_FILIAL + ZZD_ORCAME) == cChavOrc
			aDadIZZD := xPreenDad(aCPOZZD,'ZZD')//Carrega Dados Item possicionado
			AADD(aDadZZD,aDadIZZD) //Adiciona no array com total de Itens
			ZZD->(dbSkip())
		EndDo
	EndIf

	//Tratamento de Dados
	xTratDad(@aCPOZZC,@aCPOZZD,@aDadZZC,@aDadZZD,nQuant,@aNumer)

	If lGeraSub
		cNum := GetSXENum('ZB8','ZB8_EXP')
	EndIf
	cExps := ""

	Begin Transaction
		//Realiza Inclusao
		for ni:= 1 to nQuant

			If lGeraSub
				cSub := StrZero(ni,3,0)
			Else
				cNum := GetSXENum('ZB8','ZB8_EXP')
			EndIf

			xInc(aCPOZZC,aDadZZC,'ZB8',cNum,cSub)
			xInc(aCPOZZD,aDadZZD,'ZB9',cNum,cSub)

			If !lGeraSub
				ConfirmSx8()
			EndIf

			cExps += CRLF+cNum+iif(!empty(alltrim(cSub)),"/"+cSub,"")

			//Cria documentos na ZZJ
			U_InsZZJ15(cResp)

			//Envia e-mail para a �rea de PCP Local


		next ni

		//Altera Status para "EXP Gerada"
		RecLock("ZZC",.F.)
		ZZC->ZZC_APROVA := '4'
		ZZC->(MsUnlock())

	End Transaction

	If lGeraSub
		ConfirmSx8()
	EndIf

	MailPcpLoc()

	ApMsgInfo( cExps, 'Exp(s) geradas:' )


	RestArea(aAreaZZD)
	RestArea(aAreaZZC)
	RestArea(aArea)

return

Static function xTratDad(aCpoZZC,aCpoZZD,aDadZZC,aDadZZD,nQtd,aNumer)
	Local cCod 		:= ''
	Local nPosQtd 	:= aScan(aCpoZZC,{|x| Alltrim(x) == Alltrim('ZZC_ZQTDCO')})

	//Tratamento Quantidade
	for nx := 1 to Len(aDadZZC)
		aDadZZC[nx,nPosQtd] := 1
	next nx

return

/*
=====================================================================================
Programa............: xGerArX3
Autor...............: Joni Lima
Data................: 18/04/2017
Descricao / Objetivo: Carrega os campos da SX3
=====================================================================================
*/
Static function xGerArX3(cTab)

	Local aArea 	:= GetArea()
	Local aRet := {}

	//Pega Os Campos da SX3
	dbSelectArea('SX3')
	SX3->(dbSetOrder(1))//X3_ARQUIVO+X3_ORDEM
	If SX3->(dbSeek(cTab))
		While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == cTab

			If SX3->X3_CONTEXT <> 'V'
				AADD(aRet,SX3->X3_CAMPO)
			EndIf

			SX3->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)

return aRet

/*
=====================================================================================
Programa............: xPreenDad
Autor...............: Joni Lima
Data................: 18/04/2017
Descricao / Objetivo: Carrega dados de uma tabela em array na Ordem dos Campos
=====================================================================================
*/
Static function xPreenDad(aCpos,cTab)
	Local aArea := GetArea()
	Local aRet := {}
	Local cFld	:= ''
	Local xCtd	:= ''
	Local ni	:= 0

	for ni := 1 To Len(aCpos)
		cFld := cTab + '->' + AllTrim(aCpos[ni])//Monta o Campo
		xCtd := &(cFld)//Recupera o conteudo do Campo
		AADD(aRet,xCtd)//Adiciona no Array de Retorno do Registro
	next ni
	RestArea(aArea)

return aRet


/*/
	{Protheus.doc} xInc
	Inclusao da EXP

	@description
	Realiza a Inclusao de um registro segundo os campos e o acols informado

	@autor Joni Lima
	@since 18/04/2017
	@type function
	@table
	ZZC - Orcamento de Exportacao
	ZB8 - Exp

	@menu

	@Updates
	2020-02-17 - Claudio Alves
	feature/RTASK0010722-automatizar-campo-situacao-orcamento-exp
	Automatiza��o do preenchimento do campo ZB8->ZB8_INLAND a partir da regra
	em que se a via de transporte for diferente de '01' entao o campo
	ZB8->ZB8_INLAND deve ser preenchido com '01' e o campo fica travado.

/*/
Static function xInc(aCpos,aDados,cTab,cCod,cSub)
	local aArea 	:= GetArea()
	local cFld		:= ''
	local ni
	local nx

	for nx := 1 to Len(aDados)
		RecLock(cTab,.T.)
		for ni:=1 to len(aCpos)  //alterado Rafael 26102018
			if !Empty(aDados[nx,ni])
				cFld := cTab + Alltrim(SubStr(aCpos[ni],4,Len(aCpos[ni])-3))//Monta Campo da Nova Tabela
				if FieldPos(cFld) > 0 //Verifica se o campo Existe
					cFld := cTab +'->'+ cFld
					&(cFld) := aDados[nx,ni]
				EndIf
			EndIf
		next ni

		//Tratamento para Codigo
		If cTab == 'ZB8'
			ZB8->ZB8_EXP	:= cCod
			ZB8->ZB8_ANOEXP := Right(Str(YEAR(dDataBase)),2)
			if ZB8->ZB8_VIA $ "02|03|04"
				ZB8->ZB8_INLAND	:= '01'
			endif
			If !Empty(cSub)
				ZB8->ZB8_SUBEXP := cSub
			EndIf
			ZB8->ZB8_MOTEXP := '1'
			ZB8->ZB8_ZHRINC	:= Time()
			ZB8->ZB8_DTPROC := ddatabase
			ZB8->ZB8_ZREVIS := ddatabase
		ElseIf cTab == 'ZB9'
			ZB9->ZB9_EXP	:= cCod
			ZB9->ZB9_ANOEXP := Right(Str(YEAR(dDataBase)),2)
			If !Empty(cSub)
				ZB9->ZB9_SUBEXP := cSub
			EndIf
		EndIf

		//Campo Quantidade na Embalagem deve ser igual a Quantidade
		If cTab == 'ZB9'
			ZB9->ZB9_QE := ZB9->ZB9_SLDINI
		EndIf

		(cTab)->(MsUnLock())
	next nx

	RestArea(aArea)

Return

/*/{Protheus.doc} MGEEC19
//TODO Inclui tabela no conhecimento
@author leonardo.kume
@since 18/04/2017
@version 6
@param aRet, array, descricao
@type function
/*/
user function MGEEC19(aRet)

	AADD( aRet, { "ZZC", { "ZZC_ORCAME"}, { || xFilial("ZZC") + ZZC->ZZC_ORCAME} } )

return aRet

/*/{Protheus.doc} MGF19QTC
//TODO Gatilho para atualizar a soma total do Orcamento
@author leonardo.kume
@since 02/05/2017
@version 6
@param oModel, object, Model ativo
@param lAtual, logical, Atualiza itens e cabecalho?
@type function
/*/
User Function MGF19QTC(oModel,lAtual,nValor)

	Local nRet	 	:= 0
	Local lOK	 	:= .T.

	Default oModel	:= FWModelActive()
	Default lAtual	:= .F.
	Default nValor	:= 0

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk
		nRet := oModel:GetModel( 'EEC19MASTER'):GetValue("ZZC_ZQTDCO")
	EndIf
	If lAtual
		oModel:GetModel("EEC19CALC"):SetValue("ZZD__TOTQC",nRet)
		nRet := nValor
	EndIf

Return(nRet)


/*/{Protheus.doc} MGF19TRG
//TODO Gatilho para atualizar a soma total do Orcamento
@author leonardo.kume
@since 02/05/2017
@version 6
@param oModel, object, Model ativo
@param lAtual, logical, Atualiza itens e cabecalho?
@type function
/*/
User Function MGF19TRG(oModel,lAtual,nValor)

	Local oStrV		:= NIL
	Local oStrM		:= NIL
	Local nRet	 	:= 0
	Local nDec		:= 0
	Local lOk		:= .T.
	Local nX		:= 0
	Local nLenPEA	:= 0

	Default oModel	:= FWModelActive()
	Default lAtual	:= .F.
	Default nValor	:= 0
	nLenPEA	:= oModel:GetModel( 'EEC19DETAIL'):Length()

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk
		If !oModel:GetModel( 'EEC19MASTER'):GetValue("ZZC_PRECOA") $ "2/ "
			nRet := oModel:GetModel( 'EEC19MASTER'):GetValue("ZZC_SEGPRE") //oModel:GetModel( 'EEC19MASTER'):GetValue("ZZC_FRPREV")+
		EndIf
		//		nRet := 0
		For nX:=1 to nLenPEA
			If !oModel:GetModel("EEC19DETAIL"):IsDeleted(nX)
				nRet += oModel:GetModel( 'EEC19DETAIL'):GetValue("ZZD_PRECO",nX)*oModel:GetModel( 'EEC19DETAIL'):GetValue("ZZD_SLDINI",nX)
			EndIf
		Next nX
	EndIf

	If lAtual
		oModel:GetModel("EEC19CALC"):SetValue("ZZD__TOTFS",nRet)
		nRet := nValor
	EndIf

Return(nRet)

/*/{Protheus.doc} MGF19TPT
//TODO Gatilho para atualizar a soma total do Orcamento
@author leonardo.kume
@since 02/05/2017
@version 6
@param oModel, object, Model ativo
@param lAtual, logical, Atualiza itens e cabecalho?
@type function
/*/
User Function MGF19TPT(oModel,nValor)

	Local oStrV		:= NIL
	Local oStrM		:= NIL
	Local lRet	 	:= .T.
	Local nAtu		:= 0
	Local nDec		:= 0
	Local lOk		:= .T.
	Local nX		:= 0
	Local ni		:= 0
	Local nLenPEA	:= 0
	Local aUnidad	:= {}
	Local oMdlDet	:= nil
	Local oMdlSoma	:= nil
	Local nLinhaAtu := 0
	Local nNewLine	:= 0
	Local nQtdCont	:= 0

	Default oModel	:= FWModelActive()
	Default nValor	:= 0
	oMdlDet		:= oModel:GetModel("EEC19DETAIL")
	oMdlSoma	:= oModel:GetModel("EEC19SOMA")
	nLenPEA		:= oMdlDet:Length()

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk .AND. (	oModel:GetOperation() == MODEL_OPERATION_UPDATE .or. oModel:GetOperation() == MODEL_OPERATION_VIEW .OR.;
			oModel:GetOperation() == MODEL_OPERATION_INSERT)
		nQtdCont	:= oModel:GetModel("EEC19MASTER"):GetValue("ZZC_ZQTDCO")
		nRet := 0
		For nX:=1 to nLenPEA
			If !oMdlDet:IsDeleted(nX)
				nAtu := aScan(aUnidad,{|x| x[1] == oMdlDet:GetValue("ZZD_UNIDAD",nX)})
				If nAtu == 0
					aAdd(aUnidad,{oMdlDet:GetValue("ZZD_UNIDAD",nX), oMdlDet:GetValue("ZZD_SLDINI",nX), oMdlDet:GetValue("ZZD_SLDINI",nX) * nQtdCont})
				Else
					aUnidad[nAtu][2] += oMdlDet:GetValue("ZZD_SLDINI",nX)
					aUnidad[nAtu][3] := aUnidad[nAtu][2] * nQtdCont
				EndIf
			EndIf
		Next nX

		oMdlSoma:SetNoInsertLine( .F. )
		oMdlSoma:SetNoUpdateLine( .F. )
		oMdlSoma:SetNoDeleteLine( .F. )
		oMdlSoma:ClearData()
		For nX := 1 to Len(aUnidad)
			If  !oMdlSoma:IsEmpty()

				oMdlSoma:GoLine(oMdlSoma:Length())
				nLinhaAtu := oMdlSoma:GetLine()
				nNewLine := oMdlSoma:AddLine(.t.)
				If nNewLine == nLinhaAtu
					lRet := .F.
				EndIf
				oMdlSoma:GoLine( nNewLine )

			Else
				oMdlSoma:ClearData()
			Endif
			oMdlSoma:LoadValue("ZZD_SLDINI",aUnidad[nX,2])
			oMdlSoma:LoadValue("ZZD_PRECO",aUnidad[nX,3])
			oMdlSoma:LoadValue("ZZD_UNIDAD",aUnidad[nX,1])
		Next nX

		oMdlSoma:GoLine(1)

	EndIf

Return nValor
/*
=====================================================================================
Programa............: xM19CUN
Autor...............: Joni Lima
Data................: 04/05/2017
Descricao / Objetivo: Calculo Segunda unidade de Medida
=====================================================================================
*/
User function xM19CUN(cTp)

	Local aArea 	:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())

	Local nQtd := 0

	Local oModel 	:= FwModelActive()
	Local oMdlZZC	:= oModel:GetModel('EEC19MASTER')
	Local oMdlZZD	:= oModel:GetModel('EEC19DETAIL')

	Local cProd		:= oMdlZZD:GetValue('ZZD_COD_I')
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
			nValor := oMdlZZD:GetValue('ZZD_SLDINI')
			If !(Empty(nValor))
				If cTipCon == "M"
					nQtd := nValor * nFatConv
				Else
					nQtd := nValor / nFatConv
				EndIf
			Else
				nQtd := oMdlZZD:GetValue('ZZD_ZQT2UM')
			EndIf
		Else
			nValor := oMdlZZD:GetValue('ZZD_ZQT2UM')
			If !(Empty(nValor))
				If cTipCon == "M"
					nQtd := nValor / nFatConv
				Else
					nQtd := nValor * nFatConv
				EndIf
			Else
				nQtd := oMdlZZD:GetValue('ZZD_SLDINI')
			EndIf
		EndIf
	Else
		If cTp == "1"
			nQtd := oMdlZZD:GetValue('ZZD_ZQT2UM')
		Else
			nQtd := oMdlZZD:GetValue('ZZD_SLDINI')
		EndIf
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

return nQtd

/*
=====================================================================================
Programa............: xActive
Autor...............: Joni Lima
Data................: 04/05/2017
Descricao / Objetivo: Utilizado na ativa��o, quando inclusao/copia sera alterado o status para pendente
=====================================================================================
*/
Static Function xActive(oModel)

	Local oMdlZAC	:= oModel:GetModel('EEC19MASTER')

	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		oMdlZAC:LoadValue('ZZC_APROVA','2')
		oMdlZAC:LoadValue('ZZC_ZANOOR',SUBSTR(STR(YEAR(DDATABASE),4,0),3,2))
		oMdlZAC:LoadValue('ZZC_DTPROC',ddatabase)
		oMdlZAC:LoadValue('ZZC_ZREVIS',stod(""))
		oMdlZAC:LoadValue('ZZC_ZHRINC',Time())
		IF oMdlZAC:GETVALUE('ZZC_INTERM')=="1" //RAFAEL 09/11/2018
			oMdlZAC:LoadValue('ZZC_CONDPA',GETMV("MGF_CONDOF"))
			oMdlZAC:LoadValue('ZZC_COND2',"")
		ELSE
			oMdlZAC:LoadValue('ZZC_CONDPA',"")
			oMdlZAC:LoadValue('ZZC_COND2',"")
		ENDIF
	ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
		oMdlZAC:LoadValue('ZZC_ZREVIS',ddatabase)
	EndIf

	U_MGF19TPT(oModel)

return .T.


/*
=====================================================================================
Programa............: xM19V2U
Autor...............: Joni Lima
Data................: 04/05/2017
Descricao / Objetivo: Valor Segunda Unidade de Medida
=====================================================================================
*/
User function xM19V2U()
	Local nValor := 0
	Local oModel 	:= FwModelActive()
	Local oMdlZZC	:= oModel:GetModel('EEC19MASTER')
	Local oMdlZZD	:= oModel:GetModel('EEC19DETAIL')

	If !Empty(oMdlZZD:GetValue('ZZD_ZQT2UM'))
		nValor := oMdlZZD:GetValue('ZZD_PRCINC') / oMdlZZD:GetValue('ZZD_ZQT2UM')
	EndIf

return nValor

/*/{Protheus.doc} M19Forn
//TODO Gatilho para os itens do Fornecedor.
@author leonardo.kume
@since 18/05/2017
@version 6

@type function
/*/
User function M19Forn()
	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZZC	:= oModel:GetModel('EEC19MASTER')
	Local oMdlZZD	:= oModel:GetModel('EEC19DETAIL')
	Local ni		:= 1
	Local cForn		:= oMdlZZC:GetValue('ZZC_FORN')
	Local cLoja		:= oMdlZZC:GetValue('ZZC_FOLOJA')

	If !Empty(Alltrim(cForn))
		For ni:=1 to oMdlZZD:Length()
			oMdlZZD:GoLine(ni)
			oMdlZZD:SetValue('ZZD_FORN',cForn)
			oMdlZZD:SetValue('ZZD_FOLOJA',cLoja)
		Next ni
	EndIf

	oMdlZZD:GoLine(1)
	oView:Refresh()

return cForn

Static Function MailPcpLoc()
	Local cEmail := ""
	Local lOk := .T.

	DbSelectArea("ZZG")
	ZZG->(DbSetOrder(1))
	ZZG->(DbSeek(xFilial("ZZG")+ZZC->ZZC_ORCAME+"2"))
	While !ZZG->(Eof()) .and. xFilial("ZZG")+ZZC->ZZC_ORCAME == ZZG->(ZZG_FILIAL+ZZG_NUMERO)
		If ZZG->ZZG_MSBLQL == "2" .AND. ZZG->ZZG_NIVEL $ "1/2"
			cEmail := GetAdvFVal("ZZF","ZZF_EMAIL",xFilial("ZZF")+ZZG->ZZG_APROVA,1,"")
			lOk := lOk .and. EnvMail(cEmail,"Orcamento Gerado","EXPs do Orcamento "+ZZC->ZZC_ORCAME+" foram geradas e estao aguardando a distribui��o.") == ""
		EndIf
		ZZG->(dbSkip())
	EndDo
	If lOk
		ApMsgAlert("E-mails enviados com sucesso.")
	Else
		ApMsgAlert("E-mails nao foram enviados")
	EndIf
Return lOk

Static Function EnvMail(cTo,cSubject,cTexto)
	Local oMail, oMessage
	Local nErro		:= 0
	Local cRetMail 	:= ""
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		Alert(cErrMail)
		oMail:SMTPDisconnect()
		cRetMail += "Erro "+ oMail:GetErrorString(nErro)
		Return cRetMail
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			cRetMail += "Erro "+ oMail:GetErrorString(nErro)
			Return cRetMail
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cTo
	oMessage:cCc                    := ""
	oMessage:cSubject               := cSubject

	oMessage:cBody := cTexto

	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		Alert(cErrMail)
		oMail:SMTPDisconnect()
		cRetMail += "Erro "+ oMail:GetErrorString(nErro)
		Return cRetMail
	Else
		cRetMail := ""
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()


Return cRetMail

/*/{Protheus.doc} ValidIdioma
//TODO Validacao do campo Idioma
@author leonardo.kume
@since 02/06/2017
@version 6

@type function
/*/
User Function ValidIdioma(cConteudo)
	Local lOk := .F.

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))

	If SX5->(DbSeek(xFilial("SX5")+"ID"+cConteudo))
		lOk := ALLTRIM(Substr(cConteudo,1,6)) == ALLTRIM(SX5->X5_CHAVE) .AND. ALLTRIM(Substr(cConteudo,8,len(cConteudo)-8)) == ALLTRIM(SX5->X5_DESCRI)
	EndIf

Return lOk

/*/{Protheus.doc} xM19GFam
//TODO Preenchimento da familia Grupo e tipo de produto na linha do or�amento
@author leonardo.kume
@since 25/08/2017
@version 6

@type function
/*/
User function xM19GFam(cValor,nOpc)
	Local oModel 	:= FwModelActive()
	Local oView		:= FwViewActive()
	Local oMdlZZC	:= oModel:GetModel('EEC19MASTER')
	Local oMdlZZD	:= oModel:GetModel('EEC19DETAIL')
	Local oMdlTC	:= oModel:GetModel('EEC19TC')

	Local ni		:= 1
	Local aFamilia	:= {oMdlZZC:GetValue('ZZC_ZTPROD'),;
		oMdlZZC:GetValue('ZZC_ZFAMIL'),;
		oMdlZZC:GetValue('ZZC_ZNEGOC'),;
		oMdlZZC:GetValue('ZZC_ZDTPRO'),;
		oMdlZZC:GetValue('ZZC_ZDTPRE'),;
		oMdlZZC:GetValue('ZZC_ZDCONT'),;
		oMdlZZC:GetValue('ZZC_TES'),;
		oMdlZZC:GetValue('ZZC_CF'),;
		oMdlZZC:GetValue('ZZC_OPER'),;
		oMdlZZC:GetValue('ZZC_PERC')}

	Default nOpc := 0

	For ni:=1 to oMdlZZD:Length()
		oMdlZZD:GoLine(ni)
		If !Empty(Alltrim(aFamilia[1])) .OR. nOpc == 1
			oMdlZZD:SetValue('ZZD_FPCOD',ALLTRIM(aFamilia[1]))
		EndIf
		If !Empty(Alltrim(aFamilia[2])) .OR. nOpc == 2
			oMdlZZD:SetValue('ZZD_DPCOD',ALLTRIM(aFamilia[2]))
		EndIf
		If !Empty(Alltrim(aFamilia[3])) .OR. nOpc == 3
			oMdlZZD:SetValue('ZZD_GPCOD',ALLTRIM(aFamilia[3]))
		EndIf
		If !Empty(aFamilia[4]).OR. nOpc == 4
			oMdlZZD:LoadValue('ZZD_ZDTPRO',aFamilia[4])
		EndIf
		If !Empty(aFamilia[5]).OR. nOpc == 5
			oMdlZZD:LoadValue('ZZD_ZDTPRE',aFamilia[5])
		EndIf
		If !Empty(aFamilia[6]).OR. nOpc == 6
			oMdlTC:LoadValue('ZZC_ZDCONT',aFamilia[6])
		EndIf
		If !Empty(aFamilia[7]).OR. nOpc == 7
			oMdlZZD:LoadValue('ZZD_TES',aFamilia[7])
		EndIf
		If !Empty(aFamilia[8]).OR. nOpc == 8
			oMdlZZD:LoadValue('ZZD_CF',aFamilia[8])
		EndIf
		If !Empty(aFamilia[9]).OR. nOpc == 9
			oMdlZZD:LoadValue('ZZD_OPER',aFamilia[9])
		EndIf
		If aFamilia[10] > 0 .OR. nOpc == 10
			If oMdlZZC:GetValue('ZZC_INTERM') == "1"
				If oMdlZZD:GetValue('ZZD_PRENEG') > 0
					oMdlZZD:LoadValue('ZZD_PRECO',oMdlZZD:GetValue('ZZD_PRENEG')-(oMdlZZD:GetValue('ZZD_PRENEG')*aFamilia[10]/100))
				EndIf
			ElseIf oMdlZZC:GetValue('ZZC_INTERM') == "2"
				If oMdlZZD:GetValue('ZZD_PRENEG') > oMdlZZD:GetValue('ZZD_PRECO')
					oMdlZZD:LoadValue('ZZD_PRECO',oMdlZZD:GetValue('ZZD_PRENEG'))
					oMdlZZD:LoadValue('ZZD_PRENEG',0)
				Else
					oMdlZZD:LoadValue('ZZD_PRENEG',0)
				EndIF
			EndIf
		EndIf

	Next ni

	oMdlZZD:GoLine(1)
	oView:Refresh()

return cValor

//------------------------------------------------------------------
/*/{Protheus.doc} MGFGENSE
Gatilho para os campos na linha de itens 
ZZC_DEST, ZZC_ZFAMIL, ZZC_IMPORT, ZZC_IMLOJA, ZZD_COD_I, ZZC_VIA, ZZD_FPCOD
@author leonardo.kume
@since 25/08/2017
@version 6
@type function

@Alteracoes
	************
		2020/02/27
		RTASK0010784-Temperatura-Orcamento-Exp: Claudio Alves
		Automatiza��o do preenchimento do campo de Temperatura de Conserva��o.
		Nao permitir que itens com tipos de conserva��o sejam inseridos no mesmo or�amento.
		///01 -- CODIGO PARA ACHAR AS ALTERA��ES NO PROGRAMA
	************
/*/

//------------------------------------------------------------------
user function MGFGENSE(cFldAt, xValDef)
	local xRetDef		:=	xValDef
	local cCampGat		:=	cFldAt
	local cSY9Genset	:=	"" //Porto
	local cSA1Genset	:=	"" //Cliente
	local cSYCGenset	:=	"" //familia
	local cSYCConser	:=	"" //Temperatura de Conserva��o
	local cSYCResfri	:=	"" //Temperatura Resfriado
	local cSY9Conser	:=	"" //Temperatura de Conserva��o
	local cSY9Resfri	:=	"" //Temperatura Resfriado
	local cSYQGenset	:=	"" //Via
	local cSB1Gense		:=	"" //Produto
	local cSB1TpCons	:=	"" //Tipo de Conserva��o
	local _cDestRes		:=	"" //Destino Resfriado
	local _cDestCon		:=	"" //Destino Congelado
	local _cDestDry		:=	"" //Destino Dry
	local _cFamiRes		:=	"" //Familia Resfriado
	local _cFamiCon		:=	"" //Familia Congelado
	local _cFamiDry		:=	"" //Familia Dry
	local _cTpConser	:=	"" //Tipo de Conserva��o
	local _aTempPadr	:=	{} //Array oara temperaturas padrao
	local cSYCGense2	:=	"" //Familia2
	local cMotGenset	:=	""
	local oView			:=	FwViewActive()
	local oModel 		:=	FwModelActive()
	local oMdlZZC		:=	oModel:GetModel('EEC19MASTER')
	local oMdlZZD		:=	oModel:GetModel('EEC19DETAIL')
	local nAtu			:=	oMdlZZD:GetLine()
	local _cChaveInd	:=	''
	oMdlZZC:setValue("ZZC_ZGENSE", "N")
	oMdlZZC:setValue("ZZC_ZMTGEN", "")

	/*
	Importador e Familia
	ou
	Porto e Familia
	ou
	Produto e Familia
	*/

	///01 ini
	if !ExisteSx6("MGF_EEC19A")
		CriarSX6("MGF_EEC19A", "C", "Temperatura padrao Resfriado",'-1.40' )
	endif
	if !ExisteSx6("MGF_EEC19B")
		CriarSX6("MGF_EEC19B", "CL", "Temperatura padrao Congelado",'-18.00' )
	endif
	if !ExisteSx6("MGF_EEC19C")
		CriarSX6("MGF_EEC19C", "C", "Temperatura padrao In Natura",'DRY' )
	endif

	_aTempPadr	:=	{superGetMV("MGF_EEC19A", ,'-1.40'), superGetMV("MGF_EEC19B", ,'-18.00'), superGetMV("MGF_EEC19C", ,'DRY')}
	_cChaveInd	:=	xFilial("SYR") + oMdlZZC:getValue("ZZC_DEST")
	_cDestRes	:=	getAdvFVal( "SYR", "YR_ZTEMPRF"	, _cChaveInd, 4, "" ) // DESTINO
	_cDestCon	:=	getAdvFVal( "SYR", "YR_ZTEMPCG"	, _cChaveInd, 4, "" ) // DESTINO
	_cDestDry	:=	getAdvFVal( "SYR", "YR_ZTEMPDY"	, _cChaveInd, 4, "" ) // DESTINO

	_cChaveInd	:=	xFilial("SYC") + oMdlZZC:GetValue("ZZC_IDIOMA") + oMdlZZC:GetValue("ZZC_ZFAMIL")
	_cFamiRes	:=	getAdvFVal( "EEH", "EEH_ZTEMPC"	, _cChaveInd , 1, "" ) // Temperatura Congelado
	_cFamiCon	:=	getAdvFVal( "EEH", "EEH_ZTEMPR"	, _cChaveInd , 1, "" ) // Temperatura Resfriado
	_cFamiDry	:=	getAdvFVal( "EEH", "EEH_ZTEMPD"	, _cChaveInd , 1, "" ) // Temperatura Resfriado
	_cTpConser	:=	oMdlZZC:getValue("ZZC_CONSER")
	///01 fim

	cSY9Genset	:=	getAdvFVal( "SY9", "Y9_ZGENSET"	, xFilial("SY9") + oMdlZZC:getValue("ZZC_DEST"), 2, "" ) // DESTINO
	cSA1Genset	:=	getAdvFVal( "SA1", "A1_ZGENSET"	, xFilial("SA1") + oMdlZZC:getValue("ZZC_IMPORT") + oMdlZZC:getValue("ZZC_IMLOJA")	, 1, "" ) // CLIENTE
	cSYCGenset	:=	getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + oMdlZZC:getValue("ZZC_ZTPROD")									, 1, "" ) // FAMILIA CABECALHO
	cSYQGenset	:=	getAdvFVal( "SYQ", "YQ_ZGENSET"	, xFilial("SYQ") + oMdlZZC:getValue("ZZC_VIA")										, 1, "" ) // VIA CABECALHO


	if cSYCGenset == "S"
		cMotGenset += "Familia " + left( allTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + oMdlZZC:getValue("ZZC_ZTPROD"), 1, "" ) ), 15 )	+ " "
	endif

	if cSA1Genset == "S" .AND. cSYCGenset == "S" // Importador e Familia
		oMdlZZC:setValue("ZZC_ZGENSE", "S")
		cMotGenset += "Cliente " + left( allTrim( getAdvFVal( "SA1", "A1_NOME", xFilial("SA1") + oMdlZZC:getValue("ZZC_IMPORT") + oMdlZZC:getValue("ZZC_IMLOJA")	, 1, "" ) ), 15 )	+ " "
	endif

	// Valdir solicitou que o porto seja somente considerado na empresa 01 e retirar regra com familia
	if cSY9Genset == "S" .and. Substr(cFilAnt,1,2) == "01" //.AND. cSYCGenset == "S" // Porto e Familia
		oMdlZZC:setValue("ZZC_ZGENSE", "S")
		cMotGenset += "Destino " + left( allTrim( getAdvFVal( "SY9", "Y9_DESCR"	, xFilial("SY9") + oMdlZZC:getValue("ZZC_DEST"), 2, "" ) ) , 15 ) + " "
	endif


	for nI := 1 to oMdlZZD:length()
		oMdlZZD:goLine(nI)
		oMdlZZD:setValue("ZZD_ZGENSE", "N")

		cSB1Gense	:= ""
		cSYCGense2	:= ""

		cSB1Gense	:= getAdvFVal( "SB1", "B1_ZGENSET"	, xFilial("SB1") + oMdlZZD:GetValue( "ZZD_COD_I" )	, 1, "" ) // PRODUTO
		cSYCGense2	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + oMdlZZD:GetValue("ZZD_FPCOD")	, 1, "" ) // FAMILIA ITEM

		///01 ini
		if cCampGat == 'ZZD_COD_I'
			if nI == 1
				_cTpConser := ' '
			endif
			if !oMdlZZD:IsDeleted(nI)
				cSB1TpCons	:= getAdvFVal( "SB1", "B1_ZCONSER"	, xFilial("SB1") + oMdlZZD:GetValue( "ZZD_COD_I" )	, 1, "" ) // PRODUTO
				if empty(_cTpConser)
					_cTpConser := cSB1TpCons
					oMdlZZC:setValue("ZZC_CONSER", cSB1TpCons)
				endif
				if _cTpConser != cSB1TpCons
					alert("Nao � permitido incluir este item, pois o tipo de conserva��o � diferente do item anterior")
					oMdlZZD:LoadValue('ZZD_COD_I', ' ')
					oMdlZZD:LoadValue('ZZD_DESC', ' ')
					return ""
				endif
			endif
		endif
		///01 fim

		if cSB1Gense == "S"
			oMdlZZD:LoadValue('ZZD_ZGENSE', 'S')
		endif

		if cSB1Gense == "S" .AND. cSYCGense2 == "S"
			cMotGenset += "Item " + allTrim( oMdlZZD:GetValue( "ZZD_COD_I" ) )
			cMotGenset += " e familia " + left( allTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + oMdlZZD:getValue("ZZD_FPCOD"), 1, "" ) ), 15 ) + " "
			oMdlZZC:setValue("ZZC_ZGENSE", "S")
		endif
		if cSB1Gense == "S" .AND. cSYQGenset == "S"
			cMotGenset += "Item " + allTrim( oMdlZZD:GetValue( "ZZD_COD_I" ) )
			cMotGenset += " e Via " + left( allTrim( getAdvFVal( "SYQ", "YQ_DESCR"	, xFilial("SYQ") + oMdlZZC:getValue("ZZC_VIA"), 1, "" ) ), 15 ) + " "
			oMdlZZC:setValue("ZZC_ZGENSE", "S")
		endif
	next

	if oMdlZZC:getValue("ZZC_ZGENSE") == "S" .AND. !empty(cMotGenset)
		oMdlZZC:setValue("ZZC_ZMTGEN", left(cMotGenset, TAMSX3("ZZC_ZMTGEN")[1])	)
	endif

	///01 ini
	if !empty(_cTpConser)
		if cCampGat == "ZZC_DEST"
			if empty(ZZC_ZTEMPE)
				do case
				case _cTpConser == '1'
					if empty(_cDestRes)
						oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiRes),_aTempPadr[1],_cFamiRes))
					else
						oMdlZZC:setValue("ZZC_ZTEMPE", _cDestRes)
					endif
				case _cTpConser == '2'
					if empty(_cDestCon)
						oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiCon),_aTempPadr[2],_cFamiCon))
					else
						oMdlZZC:setValue("ZZC_ZTEMPE", _cDestCon)
					endif
				case _cTpConser == '3'
					if empty(_cDestDry)
						oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiDry),_aTempPadr[3],_cFamiDry))
					else
						oMdlZZC:setValue("ZZC_ZTEMPE", _cDestDry)
					endif
				endcase
			else
				if MSGYESNO( 'A temperatura pode ser alterada, favor observar!!!' , 'ALTERACAO DE TEMPERATURA' )
					do case
					case _cTpConser == '1'
						if empty(_cDestRes)
							oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiRes),_aTempPadr[1],_cFamiRes))
						else
							oMdlZZC:setValue("ZZC_ZTEMPE", _cDestRes)
						endif
					case _cTpConser == '2'
						if empty(_cDestCon)
							oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiCon),_aTempPadr[2],_cFamiCon))
						else
							oMdlZZC:setValue("ZZC_ZTEMPE", _cDestCon)
						endif
					case _cTpConser == '3'
						if empty(_cDestDry)
							oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiDry),_aTempPadr[3],_cFamiDry))
						else
							oMdlZZC:setValue("ZZC_ZTEMPE", _cDestDry)
						endif
					endcase
				endif
			endif
		else
			do case
			case _cTpConser == '1'
				if empty(_cDestRes)
					oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiRes),_aTempPadr[1],_cFamiRes))
				else
					oMdlZZC:setValue("ZZC_ZTEMPE", _cDestRes)
				endif
			case _cTpConser == '2'
				if empty(_cDestCon)
					oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiCon),_aTempPadr[2],_cFamiCon))
				else
					oMdlZZC:setValue("ZZC_ZTEMPE", _cDestCon)
				endif
			case _cTpConser == '3'
				if empty(_cDestDry)
					oMdlZZC:setValue("ZZC_ZTEMPE", iif(empty(_cFamiDry),_aTempPadr[3],_cFamiDry))
				else
					oMdlZZC:setValue("ZZC_ZTEMPE", _cDestDry)
				endif
			endcase
		endif
	endif
	///01 fim

	oMdlZZD:goLine(nAtu)
	oView:Refresh()
return xRetDef

/*
=====================================================================================
Programa............: xMGF19Mot
Autor...............: Joni Lima
Data................: 30/05/2017
Descricao / Objetivo: Realiza a Validacao do Campo ZZC_MOTSIT
=====================================================================================
*/
User function xMGF19Mot()

	Local cIdioma := IIF(!EMPTY(FwFldGet("ZZC_IDIOMA")),FwFldGet("ZZC_IDIOMA"),"")

return ExistCpo("EE4",FwFldGet("ZZC_MOTSIT") + '1-Descricao de Situacao  ' )

/*
=====================================================================================
Programa............: xVldMdl
Autor...............: Leo Kume
Data................: 27-09-2018
Descricao / Objetivo: Valida o Model para nao salvar sem os campos
=====================================================================================
*/
static function xVldMdl(oModel)

	Local lRet 		:= .T.
	Local oMdlZZC	:= oModel:GetModel('EEC19MASTER')
	Local oMdlZZD	:= oModel:GetModel('EEC19DETAIL')
	Local cOrcam	:= oMdlZZC:GetValue('ZZC_ORCAME')
	Local aAreaZZC 	:= ZZC->(GetArea())
	Local aAreaZZD 	:= ZZD->(GetArea())
	Local lFrete	:= .F.
	Local cRet		:= ""
	Local lValInt	:= GetMv("MGF_24INT",,.T.) //Desliga validacoes do Offshore
	Local lValFret	:= GetMv("MGF_24FRT",,.T.) //Desliga validacoes do frete e seguro

	//-- Inicio Valida Frete e Seguro
	If lValFret .AND. lRet
		DbSelectArea("SYJ")
		SYJ->(DbSetOrder(1))
		If SYJ->(DbSeek(xFilial("SYJ")+oMdlZZC:GetValue("ZZC_INCOTE")))
			lFrete	:= SYJ->YJ_CLFRETE == "1"
			IF lFrete
				If oMdlZZC:GetValue("ZZC_ZFRTON") <= 0
					cRet += iif(!Empty(Alltrim(cRet)),CRLF,"")
					cRet += "O Incoterm "+oMdlZZC:GetValue("ZZC_INCOTE")+" digitado prev� lan�amento de FRETE P/ Ton"
					lRet := .F.
				EndIf
			EndIf
		EndIf
		If oMdlZZC:GetValue("ZZC_INTERM") == '1' .AND. lRet
			If SYJ->(DbSeek(xFilial("SYJ")+oMdlZZC:GetValue("ZZC_INCO2")))
				lFrete	:= SYJ->YJ_CLFRETE == "1"
				IF lFrete
					If oMdlZZC:GetValue("ZZC_ZFRTON") <= 0
						cRet += iif(!Empty(Alltrim(cRet)),CRLF,"")
						cRet += "O Incoterm "+oMdlZZC:GetValue("ZZC_INCO2")+" na intermedia��o digitado prev� lan�amento de FRETE P/ Ton"
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf

		//Valida se foi informado valor por tonelada quando nao h� necessidade devido ao Incoterm
		If !lFrete .AND. lRet .AND. oMdlZZC:GetValue("ZZC_ZFRTON") > 0
			lRet := .F.
			cRet += iif(!Empty(Alltrim(cRet)),CRLF,"")
			cRet += "O Incoterm "+oMdlZZC:GetValue("ZZC_INCOTE")+" digitado NAO prev� lan�amento de FRETE P/ Ton"
		EndIf

	EndIf
	//--- Fim valida Frete e seguro
	If !lRet
	    If !Empty(cRet) // Paulo da Mata - 29/05/2020 - S� ativa o HELP quando a variavel cRet estiver preenchida.
		   HELP(" ",1,"Frete",,Alltrim(cRet),2,1)
		EndIf   
	EndIf

	if lRet // operacao offShore Rafael 24/10/2018
		if oMdlZZC:GetValue("ZZC_INTERM") == "1" .AND. EMPTY(oMdlZZC:GetValue("ZZC_COND2"))
			// Paulo da Mata - 27/05/2020 - Alterado o fluxo da condicao
		   	HELP(" ",1,"Operacao OffShore",,"Obrigatorio o preenchimento da Cond. de Pagto na aba Intermedia��o",2,1)
   		   	lRet := .F.
		ENDIF
	ENDIF

	ZZC->(RestArea(aAreaZZC))
	ZZD->(RestArea(aAreaZZD))

return lRet

//Verifica a quantidade de filiais distribuida
Static Function QuantFil(cFil,cOrc)

	Local cAliasZC2 := GetNextAlias()
	Local nQuant	:= 0

	BeginSql Alias cAliasZC2
		SELECT ZC2.ZC2_QTDCON
		FROM %Table:ZC2% ZC2
		WHERE 	ZC2.%NotDel% AND
		ZC2.ZC2_FILIAL = %xFilial:ZC2% AND
		ZC2.ZC2_FILDIS = %Exp:cFil% AND
		ZC2.ZC2_ORCAME = %Exp:cOrc%

	EndSql

	If !(cAliasZC2)->(Eof())
		nQuant := (cAliasZC2)->ZC2_QTDCON
	EndIf

return nQuant