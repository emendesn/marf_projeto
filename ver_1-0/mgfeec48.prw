#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

/*
===========================================================================================
Programa.:              MGFEEC48
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de informacoes da Certificacao Sanitaria Sem Taura
Doc. Origem:            Exportacao Indireta
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEEC48()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZDX')
	oBrowse:SetDescription('Certificacao Sanitaria Sem Taura')
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MGFEEC48' OPERATION MODEL_OPERATION_UPDATE ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZDXM := FWFormStruct( 1, 'ZDX', ,/*lViewUsado*/ )
	Local oStruZDWD := FWFormStruct( 1, 'ZDW', ,/*lViewUsado*/ )

	Local oModel
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC48M', /*bPreValidacao*/, /*bPosValidacao*/, {|oModel|xCommit(oModel)}/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC48MASTER', /*cOwner*/, oStruZDXM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC48DETAIL', 'EEC48MASTER', oStruZDWD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//oModel:AddCalc("EEC48CALC", "EEC48MASTER", "EEC48DETAIL", "ZDW_TOTCAI", "ZZD__TOT", "SUM", {||.T.}, ,"Total Caixas")


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Certificacao Sanitaria Sem Taura' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC48MASTER' ):SetDescription( 'Certificacao Sanitaria' )

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "EEC48DETAIL", { { "ZDW_FILIAL", "xFilial('ZDW')" }, { "ZDW_PEDIDO", "ZDX_PEDIDO" } }, ZDW->( IndexKey( 1 ) ) )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZDW_FILIAL","ZDW_PEDIDO"})

//	oModel:SetActivate({|oModel|xActiv(oModel)})

Return oModel
/*
Static Function xActiv(oModel)

	Local oMdlZDW := oModel:GetModel('EEC48DETAIL')
	Local oMdlZDX := oModel:GetModel('EEC48MASTER')
	Local lRet := .t.

	oMdlZDX:LoadValue('ZDX_FILIAL',ZB8->ZB8_FILVEN)
	For ni := 1 to oMdlZDW:Length()
		oMdlZDW:GoLine(ni)
		oMdlZDW:LoadValue('ZDW_FILIAL',ZB8->ZB8_FILVEN)
	next ni
	oMdlZDW:GoLine(1)

Return lRet
*/
Static Function xCommit(oModel)

	Local oMdlZDW := oModel:GetModel('EEC48DETAIL')
	Local oMdlZDX := oModel:GetModel('EEC48MASTER')
	Local lRet := .t.

//	oMdlZDX:LoadValue('ZDX_FILIAL',ZB8->ZB8_FILVEN)
//	For ni := 1 to oMdlZDW:Length()
//		oMdlZDW:GoLine(ni)
//		oMdlZDW:LoadValue('ZDW_FILIAL',ZB8->ZB8_FILVEN)
//	next ni
//	oMdlZDW:GoLine(1)

	If oModel:VldData()
		FwFormCommit(oModel)
	Endif

Return lRet

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC48' )
	// Cria a estrutura a ser usada na View
	Local oStruZDXM := FWFormStruct( 2, 'ZDX', ,/*lViewUsado*/ )
	Local oStruZDWD := FWFormStruct( 2, 'ZDW', ,/*lViewUsado*/ )
	//Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'EEC48CALC') )
	//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
	Local oView
	Local cCampos := {}

	oStruZDWD:RemoveField('ZDW_PEDIDO')

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_EEC', oStruZDXM, 'EEC48MASTER' )
	oView:AddGrid( 'DET_EEC', oStruZDWD, 'EEC48DETAIL' )
	//oView:AddField( 'VIEW_CALC', oCalc1, 'EEC48CALC' )

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
Programa.:              EEC48B
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Abre visualizacao da tabela de Certificacao Sanitaria
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC48B()
	Local aAreaEE7 	:= GetArea()
	Local cAliasZDX := GetNextAlias()
	Local cQuery 	:= ""
	Local isEXP		:= IsIncallStack("U_MGFEEC24")
	Local hasFILVen	:= iif(isEXP,!Empty(Alltrim(ZB8->ZB8_FILVEN)),.T.)
	Local cPedido 	:= GetAdvFVal("EE7","EE7_PEDFAT",xFilial("EE7")+EEC->EEC_PEDREF,1,"")
	
	cPedido			:= iif(isEXP,ZB8->ZB8_PEDFAT,cPedido)

	If hasFILVen
		cQuery := " SELECT ZDX.R_E_C_N_O_ REC " + CRLF
		cQuery += " FROM "+RetSqlName("ZDX")+" ZDX " + CRLF
		cQuery += " WHERE	ZDX.D_E_L_E_T_ = ' ' AND " + CRLF
		cQuery += " 		ZDX.ZDX_FILIAL = '"+(Iif(isEXP,ZB8->ZB8_FILVEN,xFilial("EEC")))+"' AND " + CRLF
		cQuery += " 		ZDX.ZDX_PEDIDO = '"+cPedido+"' " + CRLF
		cQuery += " GROUP BY ZDX.R_E_C_N_O_ " + CRLF 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZDX)
	
		If !(cAliasZDX)->(Eof())
			DbSelectArea("ZDX")
			ZDX->(DbGoTo((cAliasZDX)->REC))
			FWExecView(iif(isEXP,ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP),EEC->EEC_PREEMB), "MGFEEC48", MODEL_OPERATION_UPDATE ,, {|| .T. } )
		Else
			FWExecView(iif(isEXP,ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP),EEC->EEC_PREEMB), "MGFEEC48", MODEL_OPERATION_INSERT ,, {|| .T. } )
		EndIf
	Else
		Alert("Certificacao Sanitaria ainda nao distribuida")
	EndIf

	RestArea(aAreaEE7)
Return


/*
===========================================================================================
Programa.:              EEC48RET
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Retorna informacao do campo passado
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC48RET(cCampo)

	Local cRet := ""
	Local aArea 	:= GetArea()
	Local aAreaAux 	:= {}
	Local oModel	:= FwModelActive()

	If Alltrim(cCampo) $ "ZDX_NRNF "
		aAreaAux := SD2->(GetArea())
		If U_EEC48POS("SD2")//Posiciona EX9
			cRet := SD2->D2_DOC
		EndIf
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDX_SERIE"
		aAreaAux := SD2->(GetArea())
		If U_EEC48POS("SD2")//Posiciona EX9
			cRet := SD2->D2_SERIE
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDX_DTNF"
		aAreaAux := SD2->(GetArea())
		If U_EEC48POS("SD2")//Posiciona EX9
			cRet := SD2->D2_EMISSAO
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDX_TXTB"
		aAreaAux := SC5->(GetArea())
		If U_EEC48POS("SC5") .and. U_EEC48POS("SF2") 
			cRet := xMoeda(1,SC5->C5_MOEDA,SF2->F2_MOEDA,SF2->F2_EMISSAO,4)
		Endif
		RestArea(aAreaAux)	
	ElseIf Alltrim(cCampo) $ "ZDX_PRCTOT"
		aAreaAux := ZB8->(GetArea())
		cRet := 0
		If !IsInCallStack("U_MGFEEC24")
			DbSelectArea("EE9")
			DbSetOrder(2)
			DbSeek(xFilial("EE9")+EEC->EEC_PREEMB)  
			cRet := 0
			While EE9->(EE9_FILIAL+EE9_PREEMB) == EEC->(EEC_FILIAL+EEC_PREEMB) .AND. !EEC->(Eof())
				cRet += EE9->(EE9_SLDINI*EE9_PRECO)
				EE9->(DbSkip())
			EndDo
		Else
			DbSelectArea("ZB9")
			DbSetOrder(2)
			DbSeek(ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
			cRet := 0
			While ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP) .AND. !ZB9->(Eof())
				cRet += ZB9->(ZB9_SLDINI*ZB9_PRECO)
				ZB9->(DbSkip())
			EndDo
		EndIf
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZDW_TOTEST"
		cRet := ZDW->ZDW_VLREST*U_EEC48RET("ZDW_QUANT")
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
User Function EEC48POS(cAlias,lPos)

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
			lRet := SC5->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZDW->ZDW_ITEM)))
		EndIf
	ElseIf Alltrim(cAlias) $ "SD2"
		DbSelectArea("SD2")
		SD2->(DbSetOrder(8))
		lRet := SD2->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZDW->ZDW_ITEM)))
	ElseIf Alltrim(cAlias) $ "SF2"
		DbSelectArea("SD2")
		SD2->(DbSetOrder(8))
		lRet := SD2->(DbSeek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT+ALLTRIM(ZDW->ZDW_ITEM)))
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
Programa.:              EEC48GRV
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Grava Informacao na tabela informacoes passadas pelo TAURA.
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function My48GRV()
	Local cPedido := "000001"
	Local aCampos := {}
	aAdd(aCampos,{"EX9","EX9_LACRE","123456"})
	aAdd(aCampos,{"EEC","EEC_DTESTU",STOD("20160201")})

	U_EEC48GRV(cPedido,aCampos)

Return
User Function v48GRV(cPedido,aCampos)

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