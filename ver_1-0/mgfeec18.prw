#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

/*
===========================================================================================
Programa.:              MGFEEC18
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de informacoes da Certificacao Sanitaria
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEEC18()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZR')
	oBrowse:SetDescription('Certificacao Sanitaria')
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFEEC18' OPERATION 2 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZRM := FWFormStruct( 1, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_FILIAL, ZZR_PEDCAR, ZZR_PEDIDO, ZZR_OBSERV, ZZR_PERDE, ZZR_PERATE, ZZR_PRCTOT, ZZR_MATADO, ZZR_PRODUC, ZZR_TIPCOM, ZZR_DESCOM' },/*lViewUsado*/ )
	Local oStruZZRD := FWFormStruct( 1, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_FILIAL,ZZR_ITEM,ZZR_CONTNR,ZZR_LACRE,ZZR_TIPO,ZZR_DTESTU,ZZR_SIFPED,ZZR_TIPPED,'+;
	'ZZR_SIF,ZZR_SIFPRD,ZZR_PSLQUN,ZZR_PSBRUN,ZZR_TOTCAI,ZZR_CARGA,ZZR_SEQ,ZZR_EXP,ZZR_ANOEXP,ZZR_SUBEXP,ZZR_SEQUEN,ZZR_LACRE1,ZZR_LACRE2,ZZR_PRODUT,'+;
	'ZZR_DESCRI,ZZR_PESOL,ZZR_PESOB' } ,/*lViewUsado*/ )
	Local oModel
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC18M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	//oModel := MPFormModel():New('COMP011MODEL', /*bPreValidacao*/, { |oMdl| COMP011POS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC18MASTER', /*cOwner*/, oStruZZRM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC18DETAIL', 'EEC18MASTER', oStruZZRD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:AddCalc("EEC18CALC", "EEC18MASTER", "EEC18DETAIL", "ZZR_TOTCAI", "ZZD__TOT", "SUM", {||.T.}, ,"Total Caixas")


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Certificacao Sanitaria' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC18MASTER' ):SetDescription( 'Certificacao Sanitaria' )

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "EEC18DETAIL", { { "ZZR_FILIAL", "XFILIAL('ZZR')" }, { "ZZR_PEDIDO", "ZZR_PEDIDO" } }, ZZR->( IndexKey( 1 ) ) )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZZR_FILIAL","ZZR_PEDIDO"})

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC18' )
	// Cria a estrutura a ser usada na View
	Local oStruZZRM := FWFormStruct( 2, 'ZZR',{ |x| ALLTRIM(x) $ 'ZZR_FILIAL, ZZR_PEDCAR, ZZR_PEDIDO, ZZR_OBSERV, ZZR_PERDE, ZZR_PERATE, ZZR_PRCTOT,  ZZR_MATADO, ZZR_PRODUC, ZZR_TIPCOM, ZZR_DESCOM' },/*lViewUsado*/ )
	Local oStruZZRD := FWFormStruct( 2, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_FILIAL,ZZR_ITEM,ZZR_CONTNR,ZZR_LACRE,ZZR_TIPO,ZZR_DTESTU,ZZR_SIFPED,ZZR_TIPPED,'+;
	'ZZR_PESOL,ZZR_PESOB,ZZR_SIF,ZZR_SIFPRD,ZZR_PSLQUN,ZZR_PSBRUN,ZZR_TOTCAI,ZZR_CARGA,ZZR_SEQ,ZZR_EXP,ZZR_ANOEXP,ZZR_SUBEXP,ZZR_SEQUEN,ZZR_LACRE1,'+;
	'ZZR_LACRE2,ZZR_PRODUT,ZZR_DESCRI' },/*lViewUsado*/ )
	Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'EEC18CALC') )
	//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
	Local oView
	Local cCampos := {}

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_EEC', oStruZZRM, 'EEC18MASTER' )
	oView:AddGrid( 'DET_EEC', oStruZZRD, 'EEC18DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'EEC18CALC' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 45 )
	oView:CreateHorizontalBox( 'INFERIOR' , 45 )
	oView:CreateHorizontalBox( 'CALC' , 10 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_EEC', 'SUPERIOR' )
	oView:SetOwnerView( 'DET_EEC', 'INFERIOR' )
	oView:SetOwnerView( 'VIEW_CALC', 'CALC' )


	//oView:SetViewAction( 'BUTTONOK'    , { |o| Help(,,'HELP',,'Acao de Confirmar ' + o:ClassName(),1,0) } )
	//oView:SetViewAction( 'BUTTONCANCEL', { |o| Help(,,'HELP',,'Acao de Cancelar '  + o:ClassName(),1,0) } )
Return oView

/*
===========================================================================================
Programa.:              EEC18A
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Inclusao de botao na Manutencao do Embarque
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC18A(aButtons)

	/*Local cRet := ""
	Local aArea := {}

	If cParam == "BUTTON_REMESSA" 

	aArea := GetArea()
	aadd(aButtons,{"Certif.Sanitaria",{|| U_EEC18B()},"Certif.Sanitaria"})
	RestArea(aArea)
	EndIf
	*/
	aadd(aButtons,{"Certif.Sanitaria","U_EEC18B",0,1,0})

Return aButtons


/*
===========================================================================================
Programa.:              EEC18B
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Abre visualizasao da tabela de Certificacao Sanitaria
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC18B()
	Local aAreaEEC := GetArea()
	Local cAliasEE7 := GetNextAlias()
	Local cQuery 	:= ""
	Local cTipoPed 	:= ""
	Local aPedido	:= {}
	Local nI		:= 0

	cQuery := " SELECT ZZR.ZZR_PEDIDO, ZZR.R_E_C_N_O_ REC " + CRLF
	cQuery += " FROM "+RetSqlName("EE9")+" EE9 " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("EE7")+" EE7 " + CRLF
	cQuery += " ON	EE7.D_E_L_E_T_ = ' ' AND " + CRLF
	cQuery += " 	EE7.EE7_FILIAL = '"+xFilial("EE7")+"' AND " + CRLF
	cQuery += " 	EE7.EE7_PEDIDO = EE9.EE9_PEDIDO " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("ZZR")+" ZZR " + CRLF
	cQuery += " ON	ZZR.D_E_L_E_T_ = ' ' AND " + CRLF
	cQuery += " 	ZZR.ZZR_FILIAL = '"+xFilial("ZZR")+"' AND " + CRLF
	cQuery += " 	EE7.EE7_PEDFAT = ZZR.ZZR_PEDIDO " + CRLF
	cQuery += " WHERE 	EE9.D_E_L_E_T_ = ' ' AND " + CRLF
	cQuery += " 		EE9.EE9_FILIAL = '"+xFilial("EE9")+"' AND " + CRLF
	cQuery += " 		EE9.EE9_PREEMB = '"+EEC->EEC_PREEMB+"' AND " + CRLF
	cQuery += " 		EE9.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " GROUP BY ZZR.ZZR_PEDIDO, ZZR.R_E_C_N_O_ " + CRLF 
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasEE7)

	If !(cAliasEE7)->(Eof())
		While !(cAliasEE7)->(Eof())
			If aScan(aPedido,{|x| x[1] == (cAliasEE7)->ZZR_PEDIDO } ) == 0 
				aAdd(aPedido, {(cAliasEE7)->ZZR_PEDIDO, (cAliasEE7)->REC })
			EndIf
			(cAliasEE7)->(DbSkip())
		EndDo
		If Len(aPedido) > 1
			MsgInfo("Esse embarque tem mais de um pedido, serao abertos o certificado sanitario dos pedidos em sequ�ncia.")
		Endif
		For nI := 1 to Len(aPedido)
			DbSelectArea("ZZR")
			DbGoTo(aPedido[nI][2])
			FWExecView("Certificacao Sanitaria", "MGFEEC18", MODEL_OPERATION_VIEW ,, {|| .T. } )
		Next nI
	Else
		cTipoPed := GetAdvFVal("EE7","EE7_ZTIPPE",xFilial("EE7")+EEC->EEC_PEDREF,1,"")
		cTipoPed := GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+cTipoPed,1,"")
		If cTipoPed == "N"
			U_EEC48B()
		Else
			Alert("Certificacao Sanitaria ainda nao importada do TAURA")
		EndIf
	EndIf

	RestArea(aAreaEEC)
Return


/*
===========================================================================================
Programa.:              EEC18RET
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Retorna informacao do campo passado
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function EEC18RET(cCampo)

	Local cRet := ""
	Local aArea 	:= GetArea()
	Local aAreaAux 	:= {}

	If Alltrim(cCampo) $ "ZZR_CONTNR"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := EX9->EX9_CONTNR
		EndIf
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_TIPO"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := EX9->EX9_TIPO
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_TIPCOM"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := EX9->EX9_TIPCOM
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_DESCOM"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet :=Posicione("SX5",1,xFilial("SX5")+"C3"+EX9->EX9_TIPCOM,"X5_DESCRI")
		Endif
		RestArea(aAreaAux)	
	ElseIf Alltrim(cCampo) $ "ZZR_DTESTU"
		cRet := EEC->EEC_DTESTU
	ElseIf Alltrim(cCampo) $ "ZZR_OBSERV"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := E_MSMM(EX9->EX9_OBS,60)
		EndIF
	ElseIf Alltrim(cCampo) $ "ZZR_TIPPED"
		aAdd(aAreaAux,SC5->(GetArea()))
		aAdd(aAreaAux,EE7->(GetArea()))
		If U_EEC18POS("SC5")//Posiciona EX9
			cRet := SC5->C5_TIPO
		EndIf
		RestArea(aAreaAux[1])
		RestArea(aAreaAux[2])
	ElseIf Alltrim(cCampo) $ "ZZR_PSLQUN"
		aAreaAux := EE9->(GetArea())
		If U_EEC18POS("EE9")//Posiciona EX9
			cRet := EE9->EE9_PSLQTO//EE9->EE9_PSLQUN
		Else
			cRet := 0 
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_PSBRUN"
		aAreaAux := EE9->(GetArea())
		If U_EEC18POS("EE9")//Posiciona EX9
			cRet := EE9->EE9_PSBRTO//EE9->EE9_PSBRUN
		Else 
			cRet := 0 
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_PRCTOT"
		aAreaAux := EE9->(GetArea())
		If U_EEC18POS("EE9",.F.) //Posiciona EX9
			cRet := 0
			While xFilial("EE9")+EEC->EEC_PREEMB == EE9->(EE9_FILIAL+EE9_PREEMB)
				cRet += EE9->EE9_PRCTOT
				EE9->(DbSkip())
			EndDo
		Else 
			cRet := 0 
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_QUANT"
		aAreaAux := EE9->(GetArea())
		If U_EEC18POS("EE9",.F.) //Posiciona EX9
			cRet := 0
			While xFilial("EE9")+EEC->EEC_PREEMB == EE9->(EE9_FILIAL+EE9_PREEMB)
				cRet += EE9->EE9_PRCTOT
				EE9->(DbSkip())
			EndDo
		Else 
			cRet := 0 
		Endif
		RestArea(aAreaAux)
	ElseIf Alltrim(cCampo) $ "ZZR_LACRE1"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := EX9->EX9_LACRE
		Endif
		RestArea(aAreaAux)	
	ElseIf Alltrim(cCampo) $ "ZZR_LACRE2"
		aAreaAux := EX9->(GetArea())
		If U_EEC18POS("EX9")//Posiciona EX9
			cRet := EX9->EX9_ZLACRE
		Endif
		RestArea(aAreaAux)	
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
User Function EEC18POS(cAlias,lPos)

	Local lRet := .f.
	Default lPos := .t.

	If Alltrim(cAlias) $ "EX9"
		DbSelectArea("EX9")
		DbSetOrder(1)
		lRet := DbSeek(xFilial("EX9")+EEC->EEC_PREEMB)
	ElseIf Alltrim(cAlias) $ "SC5"
		DbSelectArea("EE7")
		DbSetOrder(1)
		lRet := DbSeek(xFilial("EE7")+EEC->EEC_PEDREF)
		If lRet
			DbSelectArea("SC5")
			DbSetOrder(1)
			lRet := DbSeek(xFilial("SC6")+EE7->EE7_PEDFAT)
		EndIf
	ElseIf Alltrim(cAlias) $ "EE9"
		DbSelectArea("EE7")
		DbSetOrder(1)
		lRet := DbSeek(xFilial("EE7")+EEC->EEC_PEDREF)
		If lRet
			DbSelectArea("EE8")
			DbSetOrder(1)
			EE8->(DbGoTop())
			lRet := DbSeek(xFilial("EE8")+EE7->EE7_PEDIDO)
			While lRet .and. !EE8->(EoF()) .AND. EE7->EE7_PEDIDO == EE8->EE8_PEDIDO
				If ALLTRIM(EE8->EE8_FATIT) == ALLTRIM(ZZR->ZZR_ITEM) .OR. !lPos
					DbSelectArea("EE9")
					DbSetOrder(1)
					EE9->(DbGoTop())
					lRet := DbSeek(xFilial("EE9")+EE7->EE7_PEDIDO+iif(lPos,EE8->EE8_SEQUEN,""))
					Exit
				EndIf
				EE8->(DbSkip())
			EndDo
		EndIf
	EndIf

Return lRet

/*
===========================================================================================
Programa.:              EEC18GRV
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Grava Informacao na tabela informacoes passadas pelo TAURA.
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function My18GRV()
	Local cPedido := "000001"
	Local aCampos := {}
	aAdd(aCampos,{"EX9","EX9_LACRE","123456"})
	aAdd(aCampos,{"EEC","EEC_DTESTU",STOD("20160201")})

	U_EEC18GRV(cPedido,aCampos)

Return
User Function EEC18GRV(cPedido,aCampos)

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
	
	// inserido em 28/07/18, pois estava dando erro de 'max tables = 1024' na integracao de carga de pedido do taura, devido ao alias temporario nao estar sendo fechado
	(cAliasEE7)->(dbCloseArea())

Return lRet