#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} MGFINT65
Browse para monitoramento de Integração RH Evolution
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
User Function MGFINT65()

	Local aStruSZ1	:= {} //Estrutura da tabela de Aprovação SZ1
	Local cTmp		:= GetNextAlias()
	Local cAliasTmp
	Local aColumns	:= {}

	Local aIndice		:= {}
	Local aFieFilter	:= {}
	Local aFldSeek		:= {}
	Local aSeek			:= {}
	Local nX
	Local nI

	Private oBrowse
	Private cInsert
	Private cCampos	:= "" //Pega campos que são de contexto Real
	Private cQry	:= ""

	If Pergunte("MGFINT65",.T.)

		aStruSZ1	:= SZ1->(DBSTRUCT()) //Estrutura da tabela de LOG de integração SZ1
		cCampos		:= xCmpQry("SZ1") //Pega campos que são de contexto Real

		cQry 		:= xQryDads(cCampos)//Query para selecionar os dados

		aIndices	:= xIndQry("SZ1") //Indices para montagem do pesquisar
		cFieldBrw   := xCmpBrw("SZ1") + " , Z1_FILIAL" //campo que serão apresentados no browse

		aAdd(aStruSZ1, {'RECSZ1','N',10,0})

		//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
		oTmp := FWTemporaryTable():New( cTmp )

		//Defino os campos da tabela temporária
		oTmp:SetFields(aStruSZ1)

		//Adiciono o índice da tabela temporária
		For nX := 1 To Len(aIndices)

			aChave	:= StrToKarr(Alltrim(aindices[nX,2]),"+")
			cTmpIdx := "Tmp_Idx_" + StrZero(nX,2)

			oTmp:AddIndex(cTmpIdx,aChave)

			aFldSeek	:= {}

			For nI := 1 to Len(aChave)
				//nPosFld  := aScan( aStruSZ1, { |x| Alltrim(x[1]) == aChave[nI] })
				AADD(aFldSeek,{"",aStruSZ1[ni,2],aStruSZ1[ni,3],aStruSZ1[ni,4],PesqPict("SZ1",aStruSZ1[ni,1])})
			Next nI

			//Campos que irão compor o combo de pesquisa na tela principal
			Aadd(aSeek,{aIndices[nX,3],aFldSeek,nX, .T.})

		Next nX

		//Criação da tabela temporária no BD
		oTmp:Create()

		//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
		cTable := oTmp:GetRealName()

		//Preparo o comando para alimentar a tabela temporária
		cInsert := "INSERT INTO " + cTable + " (" + cCampos + " RECSZ1 ) " + cQry

		//Executo o comando para alimentar a tabela temporária
		Processa({|| TcSQLExec(cInsert)})

		//Campos que irão compor a tela de filtro
		For nI := 1 to Len(aStruSZ1)
			If aStruSZ1[nI,1] $ cCampos
				Aadd(aFieFilter,{aStruSZ1[nI,1],RetTitle(aStruSZ1[nI,1]), aStruSZ1[nI,2], aStruSZ1[nI,3] , aStruSZ1[nI,4],PesqPict("SZ1",aStruSZ1[ni,1])})
			Endif
		Next nI

		//Browse
		For nX := 1 To Len(aStruSZ1)
			If	aStruSZ1[nX][1] $ cFieldBrw
				AAdd(aColumns,FWBrwColumn():New())

				aColumns[Len(aColumns)]:SetData( &("{||"+aStruSZ1[nX][1]+"}") )
				aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruSZ1[nX][1]))
				aColumns[Len(aColumns)]:SetPicture(PesqPict("SZ1",aStruSZ1[nX][1]))
				aColumns[Len(aColumns)]:SetSize(aStruSZ1[nX][3])
				aColumns[Len(aColumns)]:SetDecimal(aStruSZ1[nX][4])

				If !Empty(GetSX3Cache(aStruSZ1[nX][1], "X3_CBOX"))
					aColumns[Len(aColumns)]:SetOptions(xRetCombX3(aStruSZ1[nX][1]))
				EndIf

			EndIf
		Next nX

		cAliasTmp := oTmp:GetAlias()

		oBrowse:= FWMBrowse():New()
		oBrowse:SetAlias( cAliasTmp )
		oBrowse:SetDescription( 'Log de Integração' )
		oBrowse:SetSeek(.T.,aSeek)
		oBrowse:SetTemporary(.T.)
		oBrowse:SetLocate()
		oBrowse:SetUseFilter(.T.)
		oBrowse:SetDBFFilter(.T.)
		oBrowse:SetFilterDefault( "" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
		oBrowse:SetFieldFilter(aFieFilter)
		oBrowse:DisableDetails()

		// Definição da legenda
		oBrowse:AddLegend( "Z1_STATUS =='1'", "ENABLE"    	, "Processo integrado com sucesso"     	)
		oBrowse:AddLegend( "Z1_STATUS <>'1'", "DISABLE"    	, "Processo com erro de integração"     )

		oBrowse:SetColumns(aColumns)

		oBrowse:Activate()

		oTmp:Delete()

	EndIf

Return

/*/{Protheus.doc} xRetCombX3
Função para Pegar os Dados de Combo
@type function

@param cCampo, String, Campo a ser tratado
@return aRet, Array, Descrição do combom em ordem

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xRetCombX3(cCampo)

	Local aRet := {}
	Local aRetX3 := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

	local ni

	For ni := 1 to Len(aRetX3)
		AADD(aRet,aRetX3[ni][1])
	Next ni

return aRet

/*/{Protheus.doc} xCmpQry
Função para Pegar os campos de contexto Reais
@type function

@param cxAlias, String, tabela a ser Pesquisada
@return cRet, String, Campos retornados

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xCmpQry(cxAlias)

	Local cRet := ""
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			X3_CAMPO
		FROM SX3010 X3
		WHERE
				X3.%NotDel%
		    AND X3.X3_ARQUIVO = %Exp:cxAlias%
		    AND X3.X3_CONTEXT IN (' ','R')
		ORDER BY X3_ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		cRet += (cNextAlias)->X3_CAMPO + ", "
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return cRet

/*/{Protheus.doc} xIndQry
Função para Pegar os indices da tabela
@type function

@param cxAlias, String, tabela a ser Pesquisada
@return aRet, array, Contem 3 posições {Indice,Chave,Descrição}

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xIndQry(cxAlias)

	Local aRet := {}
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			ORDEM,
			CHAVE,
			DESCRICAO
		FROM SIX010 IX
		WHERE
				IX.%NotDel%
		    AND IX.INDICE = %Exp:cxAlias%
		ORDER BY ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		AADD(aRet,{(cNextAlias)->ORDEM,(cNextAlias)->CHAVE,(cNextAlias)->DESCRICAO})
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return aRet

/*/{Protheus.doc} xCmpBrw
Função para Pegar campos de browse
@type function

@param cxAlias, String, tabela a ser Pesquisada
@return cRet, String, Contem os campos para serem apresentados no browse

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xCmpBrw(cxAlias)

	Local cRet := ""
	Local cNextAlias := GetNextAlias()

	BeginSql Alias cNextAlias

		SELECT
			X3_CAMPO
		FROM SX3010 X3
		WHERE
				X3.%NotDel%
		    AND X3.X3_ARQUIVO = %Exp:cxAlias%
		    AND X3.X3_CONTEXT IN (' ','R')
		    AND X3.X3_BROWSE = 'S'
		ORDER BY X3_ORDEM

	EndSql

	While (cNextAlias)->(!EOF())
		cRet += (cNextAlias)->X3_CAMPO + ", "
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return cRet

/*/{Protheus.doc} xQryDads
Função para Montar query que sera apresentada no browse
@type function

@param cCampos, String, Campos para serem retornados na Query
@return cRet, String, Query a ser executada para preenchimento do Browse

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xQryDads(cCampos)

	Local cQry := ""

	cQry := "SELECT " + cCampos
	cQry +=  " SZ1.R_E_C_N_O_ RECSZ1 "
	cQry +=  " FROM "+	RetSqlName("SZ1") + " SZ1 "

	If AllTrim(MV_PAR01) == AllTrim(GetMV("MGF_INT02F")) // RHRevolution
		If AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02G")) //Cadastros
			cQry += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SA1.R_E_C_N_O_ = SZ1.Z1_DOCRECN AND SA1.D_E_L_E_T_ = ' ' "

			If !Empty(MV_PAR08)
				cQry  += "   AND SA1.A1_NATUREZ = '" + Alltrim(MV_PAR08) + "'"
			EndIf
			If !Empty(MV_PAR09)
				cQry  += "   AND SA1.A1_CGC = '" + Alltrim(MV_PAR09) + "'"
			EndIf

			cQry += " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON SA2.R_E_C_N_O_ = SZ1.Z1_DOCRECN AND SA2.D_E_L_E_T_ = ' ' "

			If !Empty(MV_PAR09)
				cQry  += "   AND SA2.A2_CGC = '" + Alltrim(MV_PAR09) + "'"
			EndIf

		ElseIf AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02I")) //Titulos
			cQry  += "  LEFT JOIN " + RetSqlName("SE2") + " SE2 ON SE2.E2_FILIAL = SZ1.Z1_FILIAL AND SE2.R_E_C_N_O_ = SZ1.Z1_DOCRECN "
			If !Empty(MV_PAR09)
				cQry  += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.A2_COD = SE2.E2_FORNECE AND SA2.A2_LOJA = SE2.E2_LOJA  " // SZ1.Z1_FILIAL AND SE2.R_E_C_N_O_ = SZ1.Z1_DOCRECN "
			Endif
		EndIf
	EndIf

	cQry +=  " WHERE "
	cQry +=  " SZ1.D_E_L_E_T_ = ' ' "

	If !Empty(MV_PAR01)
		cQry  += "   AND Z1_INTEGRA = '"+alltrim(MV_PAR01)+ "'"
	Endif

	If !Empty(MV_PAR02)
		cQry  += "   AND Z1_TPINTEG = '"+MV_PAR02+"' "
	Endif

	If MV_PAR03 == 3
		cQry  += "   AND SZ1.Z1_STATUS  != '"+alltrim(str(MV_PAR03))+ "'"
	Else
		cQry  += "   AND SZ1.Z1_STATUS   = '"+alltrim(str(MV_PAR03))+ "'"
	Endif

	If AllTrim(MV_PAR01) == AllTrim(GetMV("MGF_INT02F")) // RHRevolution
		If AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02I")) //Titulos
			cQry  += "   AND SE2.D_E_L_E_T_ = ' ' "
		EndIf
	EndIf

	If !Empty(MV_PAR04) .AND. !Empty(MV_PAR05)
		cQry  += "   AND SZ1.Z1_FILIAL >= '"+alltrim(MV_PAR04)+"'"
		cQry  += "   AND SZ1.Z1_FILIAL <= '"+alltrim(MV_PAR05)+"'"
	Endif

	cQry  += "   AND SZ1.Z1_DTEXEC >= '" + dtos(MV_PAR06) + "' "
	cQry  += "   AND SZ1.Z1_DTEXEC <= '" + dtos(MV_PAR07) + "' "

	If AllTrim(MV_PAR01) == AllTrim(GetMV("MGF_INT02F")) // RHRevolution
		If AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02I")) //Titulos
			If !Empty(MV_PAR08)
				cQry  += "   AND SE2.E2_NATUREZ = '" + Alltrim(MV_PAR08) + "'"
			Endif
			If !Empty(MV_PAR09)
				cQry  += "   AND SA2.A2_CGC = '" + Alltrim(MV_PAR09) + "'"
				cQry  += "   AND SA2.D_E_L_E_T_ = ' ' "
			Endif
		EndIf
	EndIf

	If !Empty(MV_PAR10)
		cQry  += "   AND SZ1.Z1_DOCORI LIKE '%" + AllTrim(MV_PAR10) + "%'"
	Endif

Return cQry

/*/{Protheus.doc} MenuDef
Função para montar MenuDef
@type function

@return aRotina, Array, Opções do Menudef

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina Title "Atualização tela"		Action 'U_xMGF65AT()'							OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title "Exportação JSON"		Action 'U_xMG65Jso()'							OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Visualizar"       	Action 'U_xMGF65Vw()'  							OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title "Rastrear"       		Action 'U_xMGF65R()'  							OPERATION 2 ACCESS 0

Return aRotina

/*/{Protheus.doc} xMGF65Vw
Executa a visualização dos Registros de Integração
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
	User Function xMGF65Vw()

	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()

	dbSelectArea("SZ1")
	SZ1->(DbSetOrder(0))
	SZ1->(DbGoTo((cAlias)->RECSZ1))

	cFilAnt := (cAlias)->Z1_FILIAL

	FWExecView ("Log de Integração", "MGFINT65", MODEL_OPERATION_VIEW ,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ , /*bCancel*/ , /*cOperatId*/ ,/*cToolBar*/,/*oModelAct*/)

	cFilAnt := cFilBkp

Return

/*/{Protheus.doc} xMGF65AT
Função para atualização de Browse
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
User Function xMGF65AT()

	If Pergunte("MGFINT65",.T.)
		cQry	:= xQryDads(cCampos)
		//Preparo o comando para alimentar a tabela temporária
		cInsert := "INSERT INTO " + cTable + " (" + cCampos + " RECSZ1 ) " + cQry
		xMGIAtu()
	EndIf

Return

/*/{Protheus.doc} xMGIAtu
Executa limpeza da tabela e preenche com novos registros
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xMGIAtu()

	Local cAlias := oBrowse:Alias()

	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		RecLock((cAlias),.F.)
			(cAlias)->(DbDelete())
		(cAlias)->(MsUnLock())

		(cAlias)->(dbSkip())
	EndDo

	Processa({|| TcSQLExec(cInsert)})

	(cAlias)->(dbGoTop())

Return

/*/{Protheus.doc} xMG65Jso
Abre uma Dialog para apresentar o Json
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
User Function xMG65Jso()

	Local cAlias := oBrowse:Alias()

	Private cJSON := ''
	Private oDlg1
	Private oMGet1

	dbSelectArea("SZ1")
	SZ1->(DbSetOrder(0))
	SZ1->(DbGoTo((cAlias)->RECSZ1))

	cJSON  := SZ1->Z1_JSON
	oDlg1  := MSDialog():New( 075,297,575,759,"Json enviado",,,.F.,,,,,,.T.,,,.T. )
	oMGet1 := TMultiGet():New( 004,004,{|u| If(PCount()>0,cJSON:=u,cJSON)},oDlg1,216,232,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} ModelDef
Definições do Modelo de Dados
@type function

@return  	oModel, Objeto  do Tipo MPFORMMODEL, Modelo de Dados

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrSZ1 	:= FWFormStruct(1,"SZ1")

	oModel := MPFormModel():New("XMGFINT65",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SZ1MASTER",/*cOwner*/,oStrSZ1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Log Integração SZ1")
	oModel:SetPrimaryKey({"Z1_FILIAL","Z1_ID"})

Return oModel

/*/{Protheus.doc} ViewDef
Definições da View para tela
@type function

@return  	oView, Objeto  do Tipo FWFORMVIEW, View da tela

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFINT65')

	Local oStrSZ7 	:= FWFormStruct( 2, "SZ1",nil)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SZ1' , oStrSZ7, 'SZ1MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SZ1', 'TELA' )

return oView

/*/{Protheus.doc} xMGF65R
Função de Rastreamento dos Registros
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
User Function xMGF65R()

	Local cAlias 	:= oBrowse:Alias()

	If (cAlias)->Z1_STATUS =='1'
		If AllTrim(MV_PAR01) == AllTrim(GetMV("MGF_INT02F")) // RHRevolution
			//If AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02G")) //Cadastros

			If "[SA1]" $ (cAlias)->Z1_ERRO
				xMGFVCli()
			ElseIf "[SA2]" $ (cAlias)->Z1_ERRO
				xMGFVFor()
			ElseIf "[SE2]" $ (cAlias)->Z1_ERRO
				xMGFVTit()
			EndIf

			/*If AVISO("Visualizar Cadastro", "Deseja Visualizar o Cadastro de?", { "Cliente", "Fornecedor" }, 1) == 1
					xMGFVCli()
				Else
					xMGFVFor()
				EndIf*/
			//ElseIf AllTrim(MV_PAR02) == AllTrim(GetMV("MGF_INT02I")) //Titulos
				//xMGFVTit()
			//EndIf
		Else
			MsgInfo("Rastrear so pode ser utilizado para Integrações do RH Evolution"," Aviso")
		EndIF
	Else
		MsgInfo("Só é Possivel verificar os itens que estão com Status Integrado"," Aviso")
	Endif
Return

/*/{Protheus.doc} xMGFVTit
Função para visualização dos titulos
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xMGFVTit()

	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local cAlias 	:= oBrowse:Alias()
	Local cFilBkp := cFilAnt

	dbSelectArea("SE2")
	SE2->(dbSetOrder(0))

	cFilAnt := (cAlias)->Z1_FILIAL

	SE2->(dbGoto((cAlias)->Z1_DOCRECN))

	U_MGFCOM34()

	cFilAnt := cFilBkp
	RestArea(aAreaSE2)
	RestArea(aArea)

Return

/*/{Protheus.doc} xMGFVCli
Função para visualização de Clientes Mata030
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xMGFVCli()

	Local aArea 		:= GetArea()
	Local aAreaSA1 		:= SA1->(GetArea())
	Local cAlias 		:= oBrowse:Alias()
	//Local cFilBkp 		:= cFilAnt
	Local nReg	  		:= 0

	Private cCadastro  := "Clientes"
	Private aMemos     := {}
	Private bFiltraBrw := {|| Nil}
	Private aRotina
	Private aRotAuto   := Nil
	Private aCpoAltSA1 := {} // Vetor usado na gravacao do historico de alteracoes
	Private aCpoSA1    := {} // Vetor usado na gravacao do historico de alteracoes
	Private lCGCValido := .F. // Variavel usada na validacao do CNPJ/CPF (utilizando o Mashup)
	Private l030Auto   := .F. // Variavel usada para saber se é rotina automática
	Private cFilAux	  := cFilAnt // Variavel utilizada no FINC010

	//cFilAnt := (cAlias)->Z7_FILIAL

	dbSelectArea("SA1")
	SA1->(DbSetOrder(0))

	SA1->(dbGoTo((cAlias)->Z1_DOCRECN))

	nReg := SA1->(Recno())
	A030Visual("SA1",nReg,2)

	//cFilAnt := cFilBkp

	RestArea(aAreaSA1)
	RestArea(aArea)

Return

/*/{Protheus.doc} xMGFVFor
Função para visualização de Fornecedores Mata020
@type function

@author Joni Lima do Carmo
@since 08/07/2019
@version P12
/*/
Static Function xMGFVFor()

	Local aArea 		:= GetArea()
	Local aAreaSA2 		:= SA2->(GetArea())
	Local cAlias 		:= oBrowse:Alias()
	//Local cFilBkp 		:= cFilAnt
	Local nReg	  		:= 0

	Local bPre			:= {|nOpc| If(nOpc == 5,RegToMemory("SA2",.F.,.F.),),aFornNovo[1]:=M->A2_COD}
	Local bOK         	:= {|nOpc| IIF(fCanAvalSA2(nOpc-2),(aFornNovo[2]:=M->A2_COD,Iif(aFornNovo[2]!=aFornNovo[1] .And. __lSx8 .And. !(nOpc == 3 .And. l020Auto),RollBackSx8(),.T.),.T.),.F.)}
	Local bTTS			:= {|nOpc| FAvalSa2(nOpc-2), aFornNovo[2]:=M->A2_COD}
	Local bNoTTS		:= {|nOpc| fVariavel(nOpc-2) .And. fPosIncFor(nOpc)}

	Private cCadastro		:= OemtoAnsi("Fornecedores")
	Private aRotina			:= {}//MenuDef(.T.)
	Private aRotAuto		:= Nil
	Private lTMSOPdg		:= AliasInDic('DEG') .And. SuperGetMV('MV_TMSOPDG',,'0') == '2'
	Private lPyme			:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)
	Private aMemos			:= {}
	Private lIntLox			:= GetMV("MV_QALOGIX") == "1"
	Private aCpoAltSA2		:= {}	// vetor usado na gravacao do historico de alteracoes
	Private lCGCValido		:= .F.	// Variavel usada na validacao do CNPJ/CPF (utilizando o Mashup)
	Private aCmps			:= {}
	Private aPreCols		:= {}
	Private aCols			:= {}
	Private aHeader			:= {}
	Private cCodFor			:= ""
	Private cCodLoj			:= ""
	Private l020Auto		:= .F.//ValType(xRotAuto) == "A"
	Private aParam			:= {bPre,bOK,bTTS,bNoTTS}
	Private aFornNovo		:={"",""}

	aadd(aRotina,{ "Pesquisar"	, "AxPesqui"	, 0, 1}) //Pesquisar
	aadd(aRotina,{ "Visualizar"	, "A020Visual"	, 0, 2}) //Visualizar
	aadd(aRotina,{ "Incluir"	, "A020Inclui"	, 0, 3}) //Incluir
	aadd(aRotina,{ "Alterar"	, "A020Altera"	, 0, 4}) //Alterar
	aadd(aRotina,{ "Excluir"	, "A020Deleta"	, 0, 5}) //Excluir

	dbSelectArea("SA2")
	SA2->(DbSetOrder(0))

	SA2->(dbGoTo((cAlias)->Z1_DOCRECN))

	nReg := SA2->(Recno())
	A020Visual("SA2",nReg,2)

	//cFilAnt := cFilBkp

	RestArea(aAreaSA2)
	RestArea(aArea)

Return