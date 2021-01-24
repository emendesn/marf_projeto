#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa............: MGFFAT01
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Amarração Endereço de Entrega
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de entrada para chamada da amarração Endereço de Entrega
=====================================================================================
*/

User Function MGFFAT01()
	Local aRotAux := aRotina
	Local oBrowse
	Local cAreaSA1 := SA1->(GetArea())
	Local cAreaSZ9 := SZ9->(GetArea())
	aRotina := {}

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZ9')
	oBrowse:SetDescription('Amarração Cliente x Endereço de Entrega')
	oBrowse:setMenuDef("MGFFAT01")
	oBrowse:SetFilterDefault( "Z9_ZCLIENT=='"+SA1->A1_COD+"' .and. Z9_ZLOJA ='"+SA1->A1_LOJA+"'" )
	oBrowse:Activate()

	RestArea(cAreaSA1)
	RestArea(cAreaSZ9)
	aRotina := aRotAux
Return .T.

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar" 	ACTION "PesqBrw" 	OPERATION  1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.MGFFAT01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir' 	ACTION 'VIEWDEF.MGFFAT01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' 	ACTION 'VIEWDEF.MGFFAT01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	ACTION "VIEWDEF.MGFFAT01" OPERATION 5 ACCESS 0


Return aRotina


Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ9 := FWFormStruct( 1, 'SZ9')
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('FAT01M', /*bPreValidacao*/, , { |oModel| u_FAT01CMMT( oModel ) }, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'FAT01MASTER', /*cOwner*/, oStruSZ9, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Amarração Cliente x Endereço de Entrega' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'FAT01MASTER' ):SetDescription( 'Historico Aprovação' )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"Z9_FILIAL","Z9_ZCLIENT","Z9_ZLOJA"})

	oModel:SetVldActivate({|oModel| FAT01_Val_Alteracao(oModel)})


Return oModel


Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFAT01' )
	// Cria a estrutura a ser usada na View
	Local oStruSZ9 := FWFormStruct( 2, 'SZ9',,/*lViewUsado*/ )

	Local oView
	Local cCampos := {}


	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ9', oStruSZ9, 'FAT01MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZ9', 'SUPERIOR' )


Return oView


/*
=====================================================================================
Programa............: SomaIDEnd()
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Incrementa o campo Z9_ZIDEND - Id do Endereço
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function SomaIDEnd()
	// Salva areas de trabalho
	Local _cASA1 := SA1->(GetArea())
	Local _cASZ9 := SZ9->(GetArea())
	Local _cSeqID := ''

	DbSelectArea("SZ9")
	DbSetOrder(1)
	IF SZ9->(DbSeek(xFilial("SZ9")+SA1->A1_COD+SA1->A1_LOJA))
		While ! SZ9->(Eof()) .and. SZ9->Z9_ZCLIENT+SZ9->Z9_ZLOJA == SA1->A1_COD+SA1->A1_LOJA
			_cSeqID := SZ9->Z9_ZIDEND
			SZ9->(DbSkip())
		Enddo
		_cIdEnd := soma1(_cSeqID,TamSx3("Z9_ZIDEND")[1])
	Else
		_cIdEnd := strzero(1,TamSx3("Z9_ZIDEND")[1])
	Endif

	// Restaura areas
	RestArea(_cASA1)
	RestArea(_cASZ9)

Return _cIdEnd

User Function FAT01CMMT( oModel )

	// Salva areas de trabalho
	Local _cAltSA1 := SA1->(GetArea())
	Local _cAltSZ9 := SZ9->(GetArea())
	Local oModlSZ9 := oModel:GetModel("FAT01MASTER")
	Local nOperation := oModel:GetOperation()
	Local lRetAlt := nOperation == MODEL_OPERATION_UPDATE
	Local lRetInc := nOperation == MODEL_OPERATION_INSERT

	local cUpdSA1 := ""

	if !isInCallStack( "insertOrUpdateAddress" )
		// SE INCLUSAO / ALTERACAO / EXCLUSAO NAO FOR ORIGINADA DO SALESFORCE MARCA REGISTRO PARA ENVIO
		oModlSZ9:SetValue("Z9_XINTSFO", "P")
	endif

	DBSelectArea("SA1")
	SA1->( DBSetOrder( 1 ) ) //SA1	1	A1_FILIAL+A1_COD+A1_LOJA
	SA1->( DBGoTop() )
	if SA1->( DBSeek( xFilial("SA1") + oModlSZ9:getValue("Z9_ZCLIENT") + oModlSZ9:getValue("Z9_ZLOJA") ) )
		// Atualiza vendedor do cliente
		cUpdSA1 := ""
		cUpdSA1 := "UPDATE " + retSQLName("SA1")								+ CRLF
		cUpdSA1 += "	SET"													+ CRLF
		cUpdSA1 += " 		A1_XINTEGX	= 'P',"									+ CRLF // STATUS PARA O CLIENTE SER ENVIADO AO SFA
		cUpdSA1 += " 		A1_XINTEGR	= 'P',"									+ CRLF // STATUS PARA O CLIENTE SER ENVIADO AO TAURA
		cUpdSA1 += " 		A1_XINTECO	= '0',"									+ CRLF // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE
		cUpdSA1 += " 		A1_ZTAUVEZ	= 0"									+ CRLF
		cUpdSA1 += " WHERE"														+ CRLF
		cUpdSA1 += " 		R_E_C_N_O_ = " + allTrim( str( SA1->(RECNO()) ) )	+ CRLF

		if tcSQLExec( cUpdSA1 ) < 0
			conout("[FAT01CMMT] Não foi possível executar UPDATE." + CRLF + tcSqlError())
		endif

		cUpdSA1 := ""
		cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
		cUpdSA1 += "	SET"														+ CRLF
		cUpdSA1 += " 		A1_XINTSFO	= 'P'"										+ CRLF // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
		cUpdSA1 += " WHERE"															+ CRLF
		cUpdSA1 += " 		R_E_C_N_O_	=	" + allTrim( str( SA1->(RECNO()) ) )	+ CRLF
		cUpdSA1 += " 	AND A1_PESSOA	=	'J'"									+ CRLF // PARA O SALESFORCE ENVIA SOMENTE PESSOA JURIDICA

		if tcSQLExec( cUpdSA1 ) < 0
			conout("[FAT01CMMT] Não foi possível executar UPDATE." + CRLF + tcSqlError())
		endif
	endif

	//oModlSZ9:loadValue("Z9_XINTECO", "0")

   	// GAP CAD04 Inclusão
   	If lRetInc .And. findfunction("U_MGFINT39") .and. !isInCallStack( "insertOrUpdateAddress" ) // Caso seja endereço seja cadastrado pelo Salesforce não gera Grade de Aprovação
	    oModlSZ9:SetValue("Z9_MSBLQL", "1")
	Endif

   	// GAP CAD04 // Alteração
   	If lRetAlt .And. findfunction("U_MGFINT38")

	   	dbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(dbSeek('SZ9'))
		While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == 'SZ9'
		   	If X3USO(SX3->X3_USADO) .AND. !(SX3->X3_VISUAL $ ('V') ) .AND. (SX3->X3_CONTEXT <> "V"  )
		   	   CriaVar(SX3->X3_CAMPO)
		   	   &('M->'+SX3->X3_CAMPO) := oModlSZ9:GetValue(SX3->X3_CAMPO)
			EndIF
			SX3->(dbSkip())
		EndDo

		if !isInCallStack( "insertOrUpdateAddress" ) // Caso seja endereço seja alterado pelo Salesforce não gera Grade de Aprovação
	    	U_MGFINT38('SZ9','Z9')
			//oModlSZ9:SetValue("Z9_MSBLQL", "1")
		endif
	Endif

	//Grava campos do Model
	lRet := FWFormCommit( oModel )

	// GAP CAD04
	If lRetInc .And. findfunction("U_MGFINT39") .and. !isInCallStack( "insertOrUpdateAddress" ) // Caso seja endereço seja cadastrado pelo Salesforce não gera Grade de Aprovação
		U_MGFINT39(2,'SZ9','Z9_MSBLQL')
	Endif

	If lRetAlt .and. lRet
		If oModlSZ9:GetValue("Z9_ZROTEIR") == "N"
			oModlSZ9:SetValue("Z9_ZCROAD", "")
		ElseIf 	oModlSZ9:GetValue("Z9_ZROTEIR") == "S" .and. ;
		Empty(Alltrim(oModlSZ9:GetValue("Z9_ZCROAD")))
			cCRotaRet := U_Z9VLDROTA()

			// Ajusta o parâmetro
			//		PutMv("MGF_CODROT",cCRotaRet)
			PutMv("MGF_CODROT",Soma1(alltrim(cCRotaRet)))

			oModlSZ9:SetValue("Z9_ZCROAD", cCRotaRet)
		EndIf

		oModlSZ9:SetValue("Z9_ALROAD", "N")
		lRet := oModel:VldData()
		If lRet
			lRet := FWFormCommit( oModel )
		EndIf
	ElseIf lRetInc .and. lRet

		If oModlSZ9:GetValue("Z9_ZROTEIR") == "S"
			cCRotaRet := U_Z9VLDROTA()

			// Ajusta o parâmetro
			//		PutMv("MGF_CODROT",cCRotaRet)
			PutMv("MGF_CODROT",Soma1(alltrim(cCRotaRet)))

			oModlSZ9:SetValue("Z9_ZCROAD", cCRotaRet)
			oModlSZ9:SetValue("Z9_ALROAD", "N")
			lRet := oModel:VldData()
			If lRet
				lRet := FWFormCommit( oModel )
			EndIf
		Else
			oModlSZ9:SetValue("Z9_ZCROAD", "")
			lRet := oModel:VldData()
			If lRet
				lRet := FWFormCommit( oModel )
			EndIf
		EndIf

	EndIF

	// Restaura areas
	RestArea(_cAltSZ9)
	RestArea(_cAltSA1)

Return lRet

/*
=====================================================================================
Programa............: Z9VLDROTA()
Autor...............: Roberto Sidney
Data................: 12/09/2016
Descricao / Objetivo: Define a inicialização e manutenção do campo Z9_ZCROAD - Código de roteirização
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function Z9VLDROTA()
	Local cCodRotei := GetMv("MGF_CODROT") // Sequenci di codigo de roteirização
	//Local oModlSZ9 := oModel:GetModel("FAT01MASTER")
	cCRotaRet := ''    // Codigo de Roteirização

	_cGetSZ9 := SZ9->(GetArea())
	lRet := .T.

	// Na inclusão define o codigo do roteiro
	//if Inclui
	//	cCRotaRet := Soma1(alltrim(cCodRotei))
	cCRotaRet := alltrim(cCodRotei)
	/*Else
	cCRotaRet := oModlSZ9:GetValue("Z9_ZCROAD")
	Endif*/

	RestArea(_cGetSZ9)
Return(cCRotaRet)

/*
=====================================================================================
Programa............: VLDESTSZ9()
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Valida Estado
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function VLDESTSZ9()
	Local oModlSZ9 := nil//oModel:GetModel("FAT01MASTER")
	Local _cAreaSA1 := SA1->(GetArea())
	Local _cAreaSZ9 := SZ9->(GetArea())
	Local lRet := .T.

	If Type("oModel") == "U"
		oModel := FwModelActive()
	EndIf

	oModlSZ9 := oModel:GetModel("FAT01MASTER")

	If oModlSZ9:GetValue("Z9_ZCLIENT")  <> SA1->A1_COD
		Posicione("SA1",1,xFilial("SA1")+oModlSZ9:GetValue("Z9_ZCLIENT")+oModlSZ9:GetValue("Z9_ZLOJA"),"A1_EST")
	EndIf

	_cEstSA1 := SA1->A1_EST // Estado do cliente
	_cEstSZ9 := oModlSZ9:GetValue("Z9_ZEST")  // Estado informado na amarração

	// Verifica se o estado informado é igual ao do cliente
	if _cEstSZ9 <> _cEstSA1
		ShowHelpDlg("VLDESTSZ9", {"Estado não pode ser diferente do informado no cliente",""},3,;
		{"Utilize o estado("+alltrim(_cEstSA1)+").",""},3)
		lRet := .F.
	Endif

	RestArea(_cAreaSA1)
	RestArea(_cAreaSZ9)

Return(lRet)

/*
=====================================================================================
Programa............: RetEndXML()
Autor...............: Roberto Sidney
Data................: 14/09/2016
Descricao / Objetivo: Retorna para o arquivo XML o endereço de entrega conforme pedido de venda
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Função executada através dA rotina NFESEFA
=====================================================================================
*/
User Function RetEndXML(cCliente,cLoja,cCodEnd)

	Local cEnd := ""

	_cAreaSF2 := SF2->(GetArea())
	_cAreaSC5 := SC5->(GetArea())
	_cAreaSZ9 := SZ9->(GetArea())

	DbSelectArea("SZ9")
	SZ9->(dbsetOrder(1))
	IF SZ9->(DbSeek(xFilial("SZ9")+cCliente+cLoja+cCodEnd))
		_cCNPJSZ9 :=  if(len(alltrim(SZ9->Z9_ZCGC)) = 11, Transform(alltrim(SZ9->Z9_ZCGC),"@! 999.999.999-99"), Transform(SZ9->Z9_ZCGC,"@! 99.999.999.9999/99"))
		_cNomeSZ9 := Alltrim(SZ9->Z9_ZRAZEND)
		_cEndSZ9  := ALLTRIM(SZ9->Z9_ZENDER)
		_cBairSZ9 := ALLTRIM(SZ9->Z9_ZBAIRRO)
		_cCEPSZ9  := ALLTRIM(SZ9->Z9_ZCEP)
		_cMunSZ9  := ALLTRIM(SZ9->Z9_ZMUNIC)
		_cEstSZ9  := ALLTRIM(SZ9->Z9_ZEST)

		cEnd := "Endereço de Entrega: "+_cNomeSZ9
		cEnd += " CNPJ: "+_cCNPJSZ9
		cEnd +=  " Endereço: "+_cEndSZ9
		cEnd +=  " Bairro: "+_cBairSZ9
		cEnd +=  " CEP: "+_cCEPSZ9
		cEnd +=  " "+_cMunSZ9
		cEnd +=  "-"+_cEstSZ9
	Endif

	RestArea(_cAreaSF2)
	RestArea(_cAreaSC5)
	RestArea(_cAreaSZ9)

Return(cEnd)

User Function VldEndEntr()
	_cRotaCli := SA1->A1_ZCROAD
	_cAreaVld := GetArea()
	DbSelectArea("SZ9")
	dbSetOrder(2)
	_cChave := M->C5_CLIENTE+M->C5_LOJACLI+M->C5_ZCROAD
	if ! SZ9->(DbSeek(_cChave))
		IF Empty(_cRotaCli)
			ShowHelpDlg("CLIENTE", {"Codigo de roteirização não localizado.",""},3,;
			{"Verique o cadastro do cliente e amarração Local de Entrega",""},3)
			Return(.F.)
		Endif
	Endif

	RestArea(_cAreaVld)

	return

	********************************************************************
User Function FAT99ENT(aButtons)

	//Local aButtons := {} // botões a adicionar
	cAreaSA1 := SA1->(GetArea())
	// Permite a inclusão da chamada apenas na alteração
	if Altera
		AAdd(aButtons,{ 'NOTE'      ,{| |  U_MGFFAT01() }, 'Endereço de Entrega','Endereços' } )
	Endif
	RestArea(cAreaSA1)
	return

	********************************************************************
User Function MGFSZ9ID()

	Local aArea		:= GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSZ9  := SZ9->(GetArea())
	Local cCodRoad  := ""

	If Empty(M->C5_ZIDEND)
		dbSelectArea('SA1')
		SA1->(dbSetOrder(1)) //A1_FILIAl + A1_COD + A1_LOJA
		If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
			cCodRoad := SA1->A1_ZCROAD
		Endif
	Else
		dbSelectArea('SZ9')
		SZ9->(dbSetOrder(1)) // Z9_FILIAL + Z9_ZCLIENT + Z9_ZLOJA + Z9_ZIDEND
		If SZ9->(DbSeek(xFilial("SZ9")+M->C5_CLIENTE+M->C5_LOJACLI+M->C5_ZIDEND))
			cCodRoad := SZ9->Z9_ZCROAD
		Endif
	EndIf

	RestArea(aAreaSZ9)
	RestArea(aAreaSA1)
	RestArea(aArea)

return cCodRoad
**************************************************************************************************8
Static Function FAT01_Val_Alteracao(oModel)

Local lRet := .T.

If oModel:GetOperation() == MODEL_OPERATION_UPDATE
	IF SZ9->Z9_MSBLQL == '1'
	    lRet := .F.
		Help('',1,'Aviso',,'Não é possivel alterar, registro bloqueado !!',1,0)
	EndIf
EndIf

Return lRet



