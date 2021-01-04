#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

/*
===========================================================================================
Programa.:              MGFEEC46
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de informacoes da Certificacao Sanitaria na EXP
Doc. Origem:            Exportacao Indireta
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEEC46()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZDT')
	oBrowse:SetDescription('Certificacao Sanitaria EXP')
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MGFEEC46' OPERATION MODEL_OPERATION_UPDATE ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZDTM := FWFormStruct( 1, 'ZDT', ,/*lViewUsado*/ )
	Local oStruZZRD := FWFormStruct( 1, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_PEDIDO ,ZZR_ITEM,ZZR_LACRE,ZZR_SIFPED,'+;
	'ZZR_SIF,ZZR_SIFPRD,ZZR_TOTCAI,ZZR_CARGA,ZZR_SEQ,ZZR_EXP,ZZR_ANOEXP,ZZR_SUBEXP,ZZR_SEQUEN,ZZR_VLREST,ZZR_TOTEST,ZZR_QUANT,ZZR_PRODUT,ZZR_DESCRI' } ,/*lViewUsado*/ )

	Local oModel
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC46M', /*bPreValidacao*/, /*bPosValidacao*/, {|oModel|xCommit(oModel)}/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC46MASTER', /*cOwner*/, oStruZDTM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC46DETAIL', 'EEC46MASTER', oStruZZRD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//oModel:AddCalc("EEC46CALC", "EEC46MASTER", "EEC46DETAIL", "ZZR_TOTCAI", "ZZD__TOT", "SUM", {||.T.}, ,"Total Caixas")


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Certificacao Sanitaria' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC46MASTER' ):SetDescription( 'Certificacao Sanitaria' )

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "EEC46DETAIL", { { "ZZR_FILIAL", "ZDT_FILIAL" }, { "ZZR_PEDIDO", "ZDT_PEDIDO" } }, ZZR->( IndexKey( 1 ) ) )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZZR_FILIAL","ZZR_PEDIDO"})

//	oModel:SetActivate({|oModel|xActiv(oModel)})

Return oModel
/*
Static Function xActiv(oModel)

	Local oMdlZZR := oModel:GetModel('EEC46DETAIL')
	Local oMdlZDT := oModel:GetModel('EEC46MASTER')
	Local lRet := .t.

	oMdlZDT:LoadValue('ZDT_FILIAL',ZB8->ZB8_FILVEN)
	For ni := 1 to oMdlZZR:Length()
		oMdlZZR:GoLine(ni)
		oMdlZZR:LoadValue('ZZR_FILIAL',ZB8->ZB8_FILVEN)
	next ni
	oMdlZZR:GoLine(1)

Return lRet
*/
Static Function xCommit(oModel)

	Local oMdlZZR := oModel:GetModel('EEC46DETAIL')
	Local oMdlZDT := oModel:GetModel('EEC46MASTER')
	Local lRet := .t.

//	oMdlZDT:LoadValue('ZDT_FILIAL',ZB8->ZB8_FILVEN)
//	For ni := 1 to oMdlZZR:Length()
//		oMdlZZR:GoLine(ni)
//		oMdlZZR:LoadValue('ZZR_FILIAL',ZB8->ZB8_FILVEN)
//	next ni
//	oMdlZZR:GoLine(1)

	If oModel:VldData()
		FwFormCommit(oModel)
	Endif

Return lRet

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC46' )
	// Cria a estrutura a ser usada na View
	Local oStruZDTM := FWFormStruct( 2, 'ZDT', ,/*lViewUsado*/ )
	Local oStruZZRD := FWFormStruct( 2, 'ZZR', { |x| ALLTRIM(x) $ ' ZZR_PEDIDO ,ZZR_ITEM,ZZR_LACRE,ZZR_SIFPED,'+;
	'ZZR_SIF,ZZR_SIFPRD,ZZR_TOTCAI,ZZR_CARGA,ZZR_SEQ,ZZR_EXP,ZZR_ANOEXP,ZZR_SUBEXP,ZZR_SEQUEN,ZZR_VLREST,ZZR_TOTEST,ZZR_QUANT,ZZR_PRODUT,ZZR_DESCRI' } ,/*lViewUsado*/ )
	//Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'EEC46CALC') )
	//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
	Local oView
	Local cCampos := {}

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_EEC', oStruZDTM, 'EEC46MASTER' )
	oView:AddGrid( 'DET_EEC', oStruZZRD, 'EEC46DETAIL' )
	//oView:AddField( 'VIEW_CALC', oCalc1, 'EEC46CALC' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 50 )
	oView:CreateHorizontalBox( 'INFERIOR' , 50 )
	//oView:CreateHorizontalBox( 'CALC' , 10 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_EEC', 'SUPERIOR' )
	oView:SetOwnerView( 'DET_EEC', 'INFERIOR' )
	//oView:SetOwnerView( 'VIEW_CALC', 'CALC' )


	//oView:SetViewAction( 'BUTTONOK'    , { |o| Help(,,'HELP',,'Acao de Confirmar ' + o:ClassName(),1,0) } )
	//oView:SetViewAction( 'BUTTONCANCEL', { |o| Help(,,'HELP',,'Acao de Cancelar '  + o:ClassName(),1,0) } )
Return oView


/*
===========================================================================================
Programa.:              EEC46B
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Abre visualizacao da tabela de Certificacao Sanitaria
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC46B()
	Local aAreaZB8 := GetArea()
	Local cAliasZZR := GetNextAlias()
	Local cQuery := ""

	cQuery := " SELECT ZZR.R_E_C_N_O_ REC " + CRLF
	cQuery += " FROM "+RetSqlName("ZZR")+" ZZR " + CRLF
	cQuery += " WHERE	ZZR.D_E_L_E_T_ = ' ' AND " + CRLF
	cQuery += " 		ZZR.ZZR_FILIAL = '"+Alltrim(ZB8->ZB8_FILVEN)+"' AND " + CRLF
	cQuery += " 		ZZR.ZZR_PEDIDO = '"+ZB8->ZB8_PEDFAT+"' " + CRLF
	cQuery += " GROUP BY ZZR.R_E_C_N_O_ " + CRLF 
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZR)

	If !(cAliasZZR)->(Eof())
		DbSelectArea("ZDT")
		ZDT->(DbSetOrder(1))
		If !ZDT->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT))
			Reclock("ZDT",.T.)
			ZDT->ZDT_FILIAL := ZB8->ZB8_FILVEN
			ZDT->ZDT_PEDIDO := ZB8->ZB8_PEDFAT
			ZDT->(Msunlock())
		EndIf
		FWExecView("Certificacao Sanitaria", "MGFEEC46", MODEL_OPERATION_UPDATE ,, {|| .T. } )
	Else
		cTipoPed := GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")
		If cTipoPed == "N"
			U_EEC48B()
		Else
			Alert("Certificacao Sanitaria ainda nao importada do TAURA")
		EndIf
	EndIf

	RestArea(aAreaZB8)
Return


/*
===========================================================================================
Programa.:              EEC46RET
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Retorna informacao do campo passado
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC46RET(cCampo)

	Local cRet := ""
	Local aArea 	:= GetArea()
	Local aAreaAux 	:= {}
	Local oModel	:= FwModelActive()

	If Alltrim(cCampo) $ "ZDT_NRNF "
		aAreaAux := SD2->(GetArea())
		If U_EEC46POS("SD2")//Posiciona EX9
			cRet := SD2->D2_DOC
		EndIf
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDT_SERIE"
		aAreaAux := SD2->(GetArea())
		If U_EEC46POS("SD2")//Posiciona EX9
			cRet := SD2->D2_SERIE
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDT_DTNF"
		aAreaAux := SD2->(GetArea())
		If U_EEC46POS("SD2")//Posiciona EX9
			cRet := SD2->D2_EMISSAO
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDT_TXTB"
		aAreaAux := SC5->(GetArea())
		If U_EEC46POS("SC5") .and. U_EEC46POS("SF2") 
			cRet := xMoeda(1,SC5->C5_MOEDA,SF2->F2_MOEDA,SF2->F2_EMISSAO,4)
		Endif
		RestArea(aAreaAux)	
	ElseIf Alltrim(cCampo) $ "ZZR_QUANT"
		aAreaAux := ZB8->(GetArea())
		cRet := 0
		If U_EEC46POS("ZB9")
			While ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
				If Alltrim(ZB9->ZB9_FATIT) == Alltrim(ZZR->ZZR_ITEM)
					cRet := ZB9->ZB9_SLDINI
				EndIf
				ZB9->(DbSkip())
			EndDo
		EndIf
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_TOTEST"
		cRet := ZZR->ZZR_VLREST*U_EEC46RET("ZZR_QUANT")
	EndIf

	RestArea(aArea)

Return cRet


/*
===========================================================================================
Programa.:              EEC1POS
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Posiciona no registro da tabela informada
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC46POS(cAlias,lPos)

	Local lRet := .f.
	Default lPos := .t.

	If Alltrim(cAlias) $ "SC5"
		DbSelectArea("SC5")
		DbSetOrder(1)
		lRet := DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT)
	ElseIf Alltrim(cAlias) $ "SC6"
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		lRet := SC5->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT))
		If lRet
			DbSelectArea("SC6")
			SC6->(DbsetOrder(1))
			lRet := SC5->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZZR->ZZR_ITEM)))
		EndIf
	ElseIf Alltrim(cAlias) $ "SD2"
		DbSelectArea("SD2")
		SD2->(DbSetOrder(8))
		lRet := SD2->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZZR->ZZR_ITEM)))
	ElseIf Alltrim(cAlias) $ "SF2"
		DbSelectArea("SD2")
		SD2->(DbSetOrder(8))
		lRet := SD2->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZZR->ZZR_ITEM)))
		If lRet
			DbSelectArea("SF2")
			SF2->(DbsetOrder(1))
			lRet := SF2->(DbSeek(ZB8->ZB8_FILVEN+SD2->D2_DOC+SD2->D2_SERIE))
		EndIf
	ElseIf Alltrim(cAlias) $ "ZB9"
		DbSelectArea("ZB9")
		ZB9->(DbSetOrder(2))
		lRet := ZB9->(DbSeek(ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
	EndIf

Return lRet

/*
===========================================================================================
Programa.:              EEC46GRV
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Grava Informacao na tabela informacoes passadas pelo TAURA.
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function My46GRV()
	Local cPedido := "000001"
	Local aCampos := {}
	aAdd(aCampos,{"EX9","EX9_LACRE","123456"})
	aAdd(aCampos,{"EEC","EEC_DTESTU",STOD("20160201")})

	U_EEC46GRV(cPedido,aCampos)

Return
User Function v46GRV(cPedido,aCampos)

	Local aAreaEEC := GetArea()
	Local cAliasEE7 := GetNextAlias()
	Local cQuery := ""
	Local cRet := ""
	Local nI := 0
	Local lRet := .T.

	cQuery := " SELECT EE7.R_E_C_N_O_ REC " + CRLF
	cQuery += " FROM "+RetSqlName("EE7")+" EE7 " + CRLF
	cQuery += " WHERE	EE7.D_E_L_E_T_ = ' ' AND " + CRLF
	cQuery += "			EE7.EE7_FILIAL = "+xFilial("EE7")+" AND " + CRLF
	cQuery += " 		EE7.EE7_PEDFAT = '"+cPedido+"' " + CRLF
	cQuery += " GROUP BY EE7.R_E_C_N_O_ " + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasEE7)

	If !(cAliasEE7)->(Eof())
		DbSelectArea("EE7")
		EE7->(DbGoTo((cAliasEE7)->REC))
		DbSelectArea("EE9")
		EE9->(DbSetOrder(1))
		EE9->(DbSeek(xFilial("EE9")+EE7->EE7_PEDIDO))
		DbSelectArea("EX9")
		EX9->(DbSetOrder(1))
		EX9->(DbSeek(xFilial("EX9")+EE9->EE9_PREEMB))
		DbSelectArea("EEC")
		EEC->(DbSetOrder(1))
		EEC->(DbSeek(xFilial("EEC")+EE9->EE9_PREEMB))
		If !EE7->(Eof()) .And. !EE9->(Eof()) .And. !EX9->(Eof()) .And. !EEC->(Eof())	
			For nI := 1 to Len(aCampos)

				RecLock(aCampos[nI][1],.F.)
				&(aCampos[nI][1]+"->"+aCampos[nI][2]) := aCampos[nI][3]
				(aCampos[nI][1])->(MsUnlock())

			Next nI
		EndIf
	EndIf

Return lRet