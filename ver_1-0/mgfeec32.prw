#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc} mgfeec32
//TODO Programa gerado para Distribuição de Orçamento de Exportação
GAP 047
@author leonardo.kume
@since 03/10/2017
@version 6

@type function
/*/
user function mgfeec32()
Local oBrowse

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZZC' )
oBrowse:SetDescription( 'Distribuicao Orçamento' )
oBrowse:setMenuDef('MGFEEC32')
oBrowse:Activate()


Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.MGFEEC32' OPERATION 4 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZZC := FWFormStruct( 1, 'ZZC', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZZD := FWFormStruct( 1, 'ZZD', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZC2 := FWFormStruct( 1, 'ZC2', /*bAvalCampo*/, /*lViewUsado*/ )
Local oModel

oStruZC2:RemoveField("ZC2_ORCAME")

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'EEC32', {|oMdl| MGF32PRE(oMdl)}/*bPreValidacao*/, {|oMdl| MGF32VLD(oMdl)}/*bPosValidacao*/, {|oMdl| MGF32COM(oMdl)} /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New( 'COMP021M', /*bPreValidacao*/, { | oMdl | COMP021POS( oMdl ) } , /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZZCMASTER', /*cOwner*/, oStruZZC )

// Adiciona ao modelo uma estrutura de formulário de edição por grid
oModel:AddGrid( 'ZZDDETAIL', 'ZZCMASTER', oStruZZD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
oModel:AddGrid( 'ZC2DETAIL', 'ZZCMASTER', oStruZC2, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
//oModel:AddGrid( 'ZA2DETAIL', 'ZA1MASTER', oStruZA2, /*bLinePre*/,  { | oMdlG | COMP021LPOS( oMdlG ) } , /*bPreVal*/, /*bPosVal*/ )

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation( 'ZZDDETAIL', { { 'ZZD_FILIAL', 'xFilial( "ZZD" )' }, { 'ZZD_ORCAME', 'ZZC_ORCAME' } }, ZZD->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZC2DETAIL', { { 'ZC2_FILIAL', 'xFilial( "ZC2" )' }, { 'ZC2_ORCAME', 'ZZC_ORCAME' } }, ZC2->( IndexKey( 1 ) ) )

// Liga o controle de nao repeticao de linha
oModel:GetModel( 'ZC2DETAIL' ):SetUniqueLine( { 'ZC2_FILDIS' } )

// Indica que é opcional ter dados informados na Grid
oModel:GetModel( 'ZZDDETAIL' ):SetOptional(.T.)
oModel:GetModel( 'ZZDDETAIL' ):SetOnlyView(.T.)

//Adiciona chave Primária
oModel:SetPrimaryKey({"ZZC_FILIAL","ZZC_ORCAME"})

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Distribuicao de Orçamento' )

oModel:AddCalc("EEC19CALC", "ZZCMASTER", "ZC2DETAIL", "ZC2_QTDCON", "ZC2__QTTOT", "SUM", {||.T.}, ,"Total Distribuido")
//oModel:AddCalc("EEC19CALC", "ZZCMASTER", "ZC2DETAIL", "ZZC_ORCAME", "ZC2__QTCON", "FORMULA", {||.T.},,"Qtd.Container",{|oModel| U_MGF32QTD(oModel) })


Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'MGFEEC32' )
Local oView

Local oStruZZC 	:= FWFormStruct( 2, 'ZZC',{ |x| ALLTRIM(x) $ 'ZZC_FILIAL, ZZC_ORCAME, ZZC_IMPORT, ZZC_IMLOJA, ZZC_IMPODE, ZZC_ZQTDCO, ZZC_DEST, ZZC_DSCDES, ZZC_ZCONTA, ZZC_ZDCONT, ZZC_ZTPROD, ZZC_ZDTPPR' },/*lViewUsado*/ )
Local oStruZZD 	:= FWFormStruct( 2, 'ZZD',{ |x| ALLTRIM(x) $ 'ZZD_SEQUEN, ZZD_COD_I, ZZD_DESC, ZZD_SLDINI, ZZD_UNIDAD, ZZD_PRECO ' },/*lViewUsado*/ )
Local oStruZC2 	:= FWFormStruct( 2, 'ZC2' )
Local oCalc1 	:= FWCalcStruct( oModel:GetModel( 'EEC19CALC') )

	oStruZZC:SetNoFolder()
	oStruZZC:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
	oStruZC2:RemoveField("ZC2_ORCAME")
// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZZC', oStruZZC, 'ZZCMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid(  'VIEW_ZZD', oStruZZD, 'ZZDDETAIL' )
oView:AddGrid(  'VIEW_ZC2', oStruZC2, 'ZC2DETAIL' )
oView:AddField(  'VIEW_CALC', oCalc1, 'EEC19CALC' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'CENTRAL1', 30 )
oView:CreateHorizontalBox( 'CENTRAL2', 30 )
oView:CreateHorizontalBox( 'INFERIOR', 10 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZZC', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZZD', 'CENTRAL1' )
oView:SetOwnerView( 'VIEW_ZC2', 'CENTRAL2' )
oView:SetOwnerView( 'VIEW_CALC', 'INFERIOR' )

// Define campos que terao Auto Incremento
//oView:AddIncrementField( 'VIEW_ZA2', 'ZA2_ITEM' )

// Liga a Edição de Campos na FormGrid
//oView:SetViewProperty( 'VIEW_ZA2', "ENABLEDGRIDDETAIL", { 50 } )

Return oView

/*/{Protheus.doc} MGF32VLD
//TODO Validação do Model
@author leonardo.kume
@since 03/10/2017
@version 6
@param oModel, object, Model Ativo
@type function
/*/
Static Function MGF32VLD(oModel)

	Local aArea	 	:= GetArea()
	Local lOk		:= .T.

	Default oModel	:= FWModelActive()

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk
		lOk := oModel:GetModel( 'ZZCMASTER'):GetValue("ZZC_ZQTDCO") == oModel:GetModel( 'EEC19CALC'):GetValue("ZC2__QTTOT")
	EndIf

	If !lOk
		Help(,,'Quantidade Inválida',,'A soma da quantidade distribuída deve ser igual a quantidade de containers.',1,0)
	EndIf

Return(lOk)

/*/{Protheus.doc} MGF32PRE
//TODO Validação se é possível distribuir
@author leonardo.kume
@since 03/10/2017
@version 6
@param oModel, object, Model Ativo
@type function
/*/
Static Function MGF32PRE(oModel)

	Local aArea	 	:= GetArea()
	Local lOk		:= .T.

	Default oModel	:= FWModelActive()

	If oModel==NIL .or. !oModel:IsActive()
		RestArea(aArea)
		lOK := .F.
	EndIf

	If lOk
		lOk := oModel:GetModel( 'ZZCMASTER'):GetValue("ZZC_APROVA") $ "7"
		lOk := lOk .or. oModel:GetModel( 'ZZCMASTER'):GetValue("ZZC_APROVA") $ "2" .and. oModel:GetModel( 'ZZCMASTER'):GetValue("ZZC_ZDISTR") $ "1"
	EndIf

	If !lOk
		Help(,,'Status Inválido',,'O orçamento só poderá ser distribuído no Status Aguardando Distribuição ou Distribuído.',1,0)
	EndIf

Return(lOk)

/*/{Protheus.doc} MGF32COM
//TODO Commit do Model
@author leonardo.kume
@since 16/10/2017
@version 6
@return boolean, retorna se grava model
@param oModel, object, descricao
@type function
/*/
Static Function MGF32COM(oModel)
	Local lRet 			:= .T.
	Local cAliasZBY		:= ""
	Local cOrcame		:= ""
	Local cQtdFiliais	:= ""
	Local cFilDis 		:= ""
	Local nI 			:= 0

	If oModel:VldData()
		FwFormCommit(oModel)

		For nI := 1 To oModel:GetModel("ZC2DETAIL"):LENGTH()

			cQtdFiliais := Alltrim(Str( oModel:GetModel("ZC2DETAIL"):GetValue("ZC2_QTDCON",nI) ))
			cOrcame 	:= Alltrim( oModel:GetModel("ZZCMASTER"):GetValue("ZZC_ORCAME",nI) )
			cFilDis 	:= Alltrim( oModel:GetModel("ZC2DETAIL"):GetValue("ZC2_FILDIS",nI) )
			cAliasZBY	:= GetNextAlias()

			BeginSql Alias cAliasZBY

			SELECT  ZBY.ZBY_FILIAL,
					ZBY.ZBY_APROVA
			FROM %Table:ZBX% ZBX
			INNER JOIN %Table:ZBY% ZBY
			ON  ZBY.%notDel% AND
				ZBY.ZBY_FILIAL = ZBX.ZBX_FILIAL AND
				ZBY.ZBY_NIVEL = ZBX.ZBX_NIVEL
			WHERE  	ZBX.%notDel% AND
					ZBX.ZBX_FILIAL = %Exp:cFilDis% AND
					ZBX.ZBX_DNIVEL LIKE '%LOCAL%'
			ORDER BY ZBY.ZBY_FILIAL, ZBY.ZBY_APROVA

			EndSql

			While !(cAliasZBY)->(Eof())
				Processa({|| EnvAprov(Alltrim(UsrFullName((cAliasZBY)->ZBY_APROVA)),Alltrim(UsrRetMail((cAliasZBY)->ZBY_APROVA)),cOrcame,cQtdFiliais)}, 'Enviando e-mail distribuição para '+Alltrim(UsrFullName((cAliasZBY)->ZBY_APROVA)) )
				//EnvAprov(Alltrim(UsrFullName((cAliasZBY)->ZBY_APROVA)),Alltrim(UsrRetMail((cAliasZBY)->ZBY_APROVA)),cOrcame,cQtdFiliais)
				(cAliasZBY)->(DbSkip())
			EndDo

			(cAliasZBY)->(DbCloseArea())

		Next nI

		oModel:DeActivate()
		RecLock("ZZC",.F.)
		ZZC->ZZC_APROVA := "7"
		ZZC->(MsUnlock())

	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
Return lRet

/*/{Protheus.doc} MGF32CAL
//TODO Chamada para a rotina de alteração via menu
@author leonardo.kume
@since 03/10/2017
@version 6

@type function
/*/
User Function MGF32CAL()
	FWExecView("Distribuição Orçamento", "MGFEEC32", MODEL_OPERATION_UPDATE ,,  )
Return .T.


Static Function EnvAprov(_cNome,_cEmail,_cListOrc,_cQtdCont)

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

	// _cEmail	:= "leonardo.kume@totvs.com.br"

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
		//		Alert(cErrMail)
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
	oMessage:cSubject               := "Distribuição de Orçamento"

		oMessage:cBody := "<HTML><BODY><P>Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"O(s) seguinte(s) Orçamento(s) foi(foram) distribuído(s) para sua unidade: </P>"
		oMessage:cBody += CRLF+"<P><UL><LI>Orçamento "+alltrim(_cListOrc)+" - "+_cQtdCont+" container(s).</LI></UL></P>"
		oMessage:cBody += "</BODY></HTML>"

	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//		Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		//		msgalert("E-mails para os  orçamento(s) "+alltrim(_cListOrc) + " enviada com sucesso.")
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()


Return lRetMail
