#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM35
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              19/04/2017
Descricao / Objetivo:   Cadastro de Clientes - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              a
=====================================================================================
*/
user function MGFCRM35()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBJ')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Cliente')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM35'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM35'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM35'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM35'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBJ := FWFormStruct( 1, 'ZBJ', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM35MDL', /*bPreValidacao*/, {| oModel | CRM35POS( oModel ) }/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBJMASTER', /*cOwner*/, oStruZBJ, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Cliente' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBJMASTER' ):SetDescription( 'Dados de Cliente' )

	oModel:SetPrimaryKey({})

	//oStruZBJ:SetProperty('ZBJ_ROTEIR'	, MODEL_FIELD_NOUPD	, .T.)
	//oStruZBJ:SetProperty('ZBJ_REPRES', MODEL_FIELD_WHEN,{|| .T. })

	oStruZBJ:SetProperty('ZBJ_ROTEIR'	, MODEL_FIELD_WHEN,{|| .T. })
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM35' )
	// Cria a estrutura a ser usada na View
	Local oStruZBJ := FWFormStruct( 2, 'ZBJ' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBJ', oStruZBJ, 'ZBJMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBJ', 'TELA' )

	if oModel:getOperation() == MODEL_OPERATION_UPDATE
		oStruZBJ:SetProperty('ZBJ_ROTEIR'		, MVC_VIEW_CANCHANGE	, .T.)

		oStruZBJ:SetProperty('ZBJ_CLIENT'	, MVC_VIEW_CANCHANGE	, .F.)
		oStruZBJ:SetProperty('ZBJ_LOJA'		, MVC_VIEW_CANCHANGE	, .F.)
	endif
Return oView

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function CRM35POS( oModel )
	local nOpcChk	:= 0
	local lRet		:= .T.
	local oModel	:= FWModelActive()
	local oModelZBJ	:= oModel:GetModel('ZBJMASTER')
	local nOper		:= oModel:getOperation()
	local cQryZBJ	:= ""

	local oDlg
	local oFWLayer
	local oPanel1
	local oPanel2
	local oBtn1
	local oBtn2
	local oBtn3
	local oMemo
	local cRotei
	local aCoors	:= 	FWGetDialogSize( oMainWnd )

	local aArea		:= getArea()
	local aAreaZBI	:= ZBI->(getArea())

	local cUpdZBJ	:= ""
	local cDelZBJ	:= ""

	DBSelectArea("ZBI")

	if nOper == MODEL_OPERATION_INSERT .OR. nOper == MODEL_OPERATION_UPDATE
		cQryZBJ := "SELECT *"																	+ CRLF
		cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"										+ CRLF
		cQryZBJ += " WHERE"																		+ CRLF
		cQryZBJ += "		ZBJ.ZBJ_REPRES	=	'" + oModelZBJ:getValue("ZBJ_REPRES")	+ "'"	+ CRLF
		cQryZBJ += "	AND	ZBJ.ZBJ_LOJA	=	'" + oModelZBJ:getValue("ZBJ_LOJA")		+ "'"	+ CRLF
		cQryZBJ += "	AND	ZBJ.ZBJ_CLIENT	=	'" + oModelZBJ:getValue("ZBJ_CLIENT")	+ "'"	+ CRLF
		cQryZBJ += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'"						+ CRLF
		cQryZBJ += "	AND	ZBJ.ZBJ_ROTEIR	=	'" + oModelZBJ:getValue("ZBJ_ROTEIR")	+ "'"	+ CRLF
		cQryZBJ += "	AND	ZBJ.D_E_L_E_T_	<>	'*'"											+ CRLF

		TcQuery cQryZBJ New Alias "QRYZBJ"

		if !QRYZBJ->(EOF())
			Help( ,, 'MGFCRM27',, 'Este Cliente já está cadastrado neste Roteiro.', 1, 0 )
			lRet := .F.
		endif

		QRYZBJ->(DBCloseArea())

		if lRet
			cQryZBJ := "SELECT *"																	+ CRLF
			cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"										+ CRLF
			cQryZBJ += " WHERE"																		+ CRLF
			cQryZBJ += "		ZBJ.ZBJ_LOJA	=	'" + oModelZBJ:getValue("ZBJ_LOJA")		+ "'"	+ CRLF
			cQryZBJ += "	AND	ZBJ.ZBJ_CLIENT	=	'" + oModelZBJ:getValue("ZBJ_CLIENT")	+ "'"	+ CRLF
			cQryZBJ += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'"						+ CRLF
			cQryZBJ += "	AND	ZBJ.ZBJ_REPRES	<>	'" + oModelZBJ:getValue("ZBJ_REPRES")	+ "'"	+ CRLF
			cQryZBJ += "	AND	ZBJ.D_E_L_E_T_	<>	'*'"											+ CRLF
			cQryZBJ += " ORDER BY ZBJ_ROTEIR"														+ CRLF

			memoWrite("C:\TEMP\CRM35_GETZBJ.sql", cQryZBJ)

			TcQuery cQryZBJ New Alias "QRYZBJ"

			if !QRYZBJ->(EOF())

				cRotei := "Este cliente está cadastrado no(s) Roteiro(s) abaixo:" + CRLF + CRLF
				while !QRYZBJ->(EOF())
					ZBI->(DBGoTop())
					//ZBI - INDICE 3 - ZBI_FILIAL+ZBI_DIRETO+ZBI_NACION+ZBI_TATICA+ZBI_REGION+ZBI_SUPERV+ZBI_CODIGO
					cRotei	+= QRYZBJ->ZBJ_ROTEIR + ' - ' + allTrim( posicione("ZBI", 3, xFilial("ZBI") + QRYZBJ->( ZBJ_DIRETO + ZBJ_NACION + ZBJ_TATICA + ZBJ_REGION + ZBJ_SUPERV + ZBJ_ROTEIR ), "ZBI_DESCRI" ) ) + CRLF
					QRYZBJ->(DBSkip())
				enddo

				DEFINE MSDIALOG oDlg TITLE 'Cliente já cadastrado' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL STYLE DS_MODALFRAME

					oFWLayer := FWLayer():New()
					oFWLayer:Init( oDlg /*oOwner*/, .F. /*lCloseBtn*/)

					oFWLayer:AddLine( 'UP'		/*cID*/, 80 /*nPercHeight*/, .F. /*lFixed*/)
					oFWLayer:AddLine( 'DOWN'	/*cID*/, 20 /*nPercHeight*/, .F. /*lFixed*/)

					oFWLayer:AddCollumn( 'ALLUP'		/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP'		/*cIDLine*/)
					oFWLayer:AddCollumn( 'ALLDOWN'		/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN'		/*cIDLine*/)

					oPanel1	:= oFWLayer:GetColPanel( 'ALLUP'	, 'UP'		)
					oPanel2	:= oFWLayer:GetColPanel( 'ALLDOWN'	, 'DOWN'	)

					@ 005,005 GET oMemo VAR cRotei MEMO SIZE 325,100 OF oPanel1 PIXEL

					@ 005, 050 BUTTON oBtn1 PROMPT "Duplicar"	SIZE 060, 015 OF oPanel2 PIXEL ACTION ( nOpcChk := 1, oDlg:end() )
					@ 005, 150 BUTTON oBtn2 PROMPT "Transferir"	SIZE 060, 015 OF oPanel2 PIXEL ACTION ( nOpcChk := 2, oDlg:end() )
					@ 005, 250 BUTTON oBtn3 PROMPT "Abortar"	SIZE 060, 015 OF oPanel2 PIXEL ACTION ( nOpcChk := 3, oDlg:end() )

				ACTIVATE MSDIALOG oDlg CENTER

				if oModel:getOperation() == MODEL_OPERATION_INSERT
					if nOpcChk == 1
						lRet := .T.
					elseif nOpcChk == 2
						lRet := .T.
						QRYZBJ->(DBGoTop())
						while !QRYZBJ->(EOF())
							eraseStruc(QRYZBJ->ZBJ_CLIENT,QRYZBJ->ZBJ_LOJA,QRYZBJ->ZBJ_ROTEIR)
							QRYZBJ->(DBSkip())
						enddo
					elseif nOpcChk == 3
						Help( ,, 'MGFCRM27',, 'Cadastro abortado.', 1, 0 )
						lRet := .F.
					elseif nOpcChk == 0
						Help( ,, 'MGFCRM27',, 'Necessario informar uma acao.', 1, 0 )
						lRet := .F.
					endif
				elseif oModel:getOperation() == MODEL_OPERATION_UPDATE
					if nOpcChk == 1
						keepZBJ()
					elseif nOpcChk == 2
						lRet := .T.
					elseif nOpcChk == 3
						Help( ,, 'MGFCRM27',, 'Cadastro abortado.', 1, 0 )
						lRet := .F.
					elseif nOpcChk == 0
						Help( ,, 'MGFCRM27',, 'Necessario informar uma acao.', 1, 0 )
						lRet := .F.
					endif
				endif
			endif

			QRYZBJ->(DBCloseArea())

			if lRet
				///Atualiza vendedor SA1
				DbSelectArea("SA1")
				DbSetorder(1)
				If DbSeek(XFILIAL("SA1")+oModelZBJ:getValue("ZBJ_CLIENT")+oModelZBJ:getValue("ZBJ_LOJA"))
					recLock( 'SA1',.F. )
						SA1->A1_VEND	:= oModelZBJ:getValue("ZBJ_REPRES")
						SA1->A1_XINTEGX	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SFA
						SA1->A1_XINTECO	:= '0' // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE

						if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
							SA1->A1_XINTSFO	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
						endif

					msUnlock()
				endif

				//Tratamento Hierarquia Cliente x Vendedor Salesforce - ALT e UPD
				if nOper <> MODEL_OPERATION_INSERT .or. nOper <> MODEL_OPERATION_DELETE
					oModel:setValue('ZBJMASTER' , 'ZBJ_INTSFO' , 'P' )

					// Cria o novo registro antes da delecao
					keepZBJ()

					// ATUALIZA TODOS OS VENDEDORES - CASO CLIENTE ESTEJA EM MAIS DE UMA CARTEIRA
					cUpdZBJ	:= ""
					cUpdZBJ := "UPDATE " + retSQLName("ZBJ")											+ CRLF
					cUpdZBJ += " SET ZBJ_INTSFO = 'P'"													+ CRLF
					cUpdZBJ += " WHERE"																	+ CRLF
					cUpdZBJ += "		ZBJ_LOJA	=	'" + oModelZBJ:getValue("ZBJ_LOJA")		+ "'"	+ CRLF
					cUpdZBJ += "	AND	ZBJ_CLIENT	=	'" + oModelZBJ:getValue("ZBJ_CLIENT")	+ "'"	+ CRLF
					cUpdZBJ += "	AND	ZBJ_FILIAL	=	'" + xFilial("ZBJ")						+ "'"	+ CRLF
					cUpdZBJ += "	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

					if tcSQLExec( cUpdZBJ ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					else
						recLock("ZBJ", .F.)
							ZBJ->(DBDelete())
						ZBJ->(MSUnlock())
					endif
				else
					recLock( "ZBJ" , .F. )
						ZBJ->ZBJ_INTSFO := 'P'
					ZBJ->( msUnlock() )

					// ATUALIZA TODOS OS VENDEDORES - CASO CLIENTE ESTEJA EM MAIS DE UMA CARTEIRA
					cUpdZBJ	:= ""
					cUpdZBJ := "UPDATE " + retSQLName("ZBJ")							+ CRLF
					cUpdZBJ += " SET ZBJ_INTSFO = 'P'"									+ CRLF
					cUpdZBJ += " WHERE"													+ CRLF
					cUpdZBJ += "		ZBJ_LOJA	=	'" + ZBJ->ZBJ_LOJA		+ "'"	+ CRLF
					cUpdZBJ += "	AND	ZBJ_CLIENT	=	'" + ZBJ->ZBJ_CLIENT	+ "'"	+ CRLF
					cUpdZBJ += "	AND	ZBJ_FILIAL	=	'" + xFilial("ZBJ")		+ "'"	+ CRLF
					cUpdZBJ += "	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

					if tcSQLExec( cUpdZBJ ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif
				endif
			endif
		endif

	elseif nOper == MODEL_OPERATION_DELETE
		//Tratamento Hierarquia Cliente x Vendedor Salesforce - DELETE
		cDelZBJ	:= ""
		cDelZBJ := "UPDATE " + retSQLName("ZBJ")										   + CRLF
		cDelZBJ += " SET ZBJ_INTSFO = 'P'  "											   + CRLF
		cDelZBJ += " WHERE"															       + CRLF
		cDelZBJ += "		ZBJ_LOJA	=	'" + oModelZBJ:getValue("ZBJ_LOJA")		+ "'"  + CRLF
		cDelZBJ += "	AND	ZBJ_CLIENT	=	'" + oModelZBJ:getValue("ZBJ_CLIENT")	+ "'"  + CRLF
		cDelZBJ += "	AND	ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'"					   + CRLF
		cDelZBJ += "	AND	ZBJ_REPRES	=	'" + oModelZBJ:getValue("ZBJ_REPRES")	+ "'"  + CRLF
		cDelZBJ += "	AND	D_E_L_E_T_	<>	'*'"										   + CRLF

		memoWrite("C:\TEMP\CRM35_cDelZBJ.sql", cDelZBJ)
		if tcSQLExec( cDelZBJ ) < 0
			conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		endif
	endif

	restArea(aAreaZBI)
	restArea(aArea)
return lRet

//-------------------------------------------------------
// Duplica o cadastro da ZBJ - APENAS NA ALTERACAO
//-------------------------------------------------------
static function keepZBJ()
	local nRecnoZBJ		:= ZBJ->(RECNO())
	local cZBJFilial	:= ZBJ->ZBJ_FILIAL
	local cZBJRepres	:= ZBJ->ZBJ_REPRES
	local cZBJClient	:= ZBJ->ZBJ_CLIENT
	local cZBJLoja		:= ZBJ->ZBJ_LOJA
	local cZBJRoteir	:= ZBJ->ZBJ_ROTEIR
	local cZBJDireto	:= ZBJ->ZBJ_DIRETO
	local cZBJNacion	:= ZBJ->ZBJ_NACION
	local cZBJTatica	:= ZBJ->ZBJ_TATICA
	local cZBJRegion	:= ZBJ->ZBJ_REGION
	local cZBJSuperv	:= ZBJ->ZBJ_SUPERV

	recLock("ZBJ", .T.)
		ZBJ->ZBJ_FILIAL		:= cZBJFilial
		ZBJ->ZBJ_REPRES		:= cZBJRepres
		ZBJ->ZBJ_CLIENT		:= cZBJClient
		ZBJ->ZBJ_LOJA		:= cZBJLoja
		ZBJ->ZBJ_ROTEIR		:= cZBJRoteir
		ZBJ->ZBJ_DIRETO		:= cZBJDireto
		ZBJ->ZBJ_NACION		:= cZBJNacion
		ZBJ->ZBJ_TATICA		:= cZBJTatica
		ZBJ->ZBJ_REGION		:= cZBJRegion
		ZBJ->ZBJ_SUPERV		:= cZBJSuperv
		ZBJ->ZBJ_INTSFO		:= "P"
	ZBJ->(msUnlock())
return

//******************************************************
// Apaga da estrutura atual caso exista
//******************************************************
static function eraseStruc(cA1Cod, cA1Loj, cRoteiro)
	local nZBJRecno	:= ""
	local cQryArq	:= ""

	cQryArq += "SELECT ZBJ.R_E_C_N_O_ ZBJRECNO"										+ CRLF
	/*
	cQryArq += "FROM " + retSQLName("ZBD") + " ZBD"									+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryArq += "ON"																	+ CRLF
	cQryArq += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO"								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryArq += "ON"																	+ CRLF
	cQryArq += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 								+ CRLF
	cQryArq += "AND	ZBE.ZBE_DIRETO = ZBF.ZBF_DIRETO" 								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 							+ CRLF
	cQryArq += "ON" 																+ CRLF
	cQryArq += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 								+ CRLF
	cQryArq += "AND	ZBF.ZBF_NACION = ZBG.ZBG_NACION" 								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 							+ CRLF
	cQryArq += "ON"	 																+ CRLF
	cQryArq += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION" 								+ CRLF
	cQryArq += "AND	ZBG.ZBG_TATICA = ZBH.ZBH_TATICA"								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBI") + " ZBI" 							+ CRLF
	cQryArq += "ON" 																+ CRLF
	cQryArq += "	ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV" 								+ CRLF
	cQryArq += "AND	ZBH.ZBH_REGION = ZBI.ZBI_REGION"								+ CRLF
	*/

	cQryArq += StaticCall(MGFCRM16,QryNivSelEV,.F.)

	cQryArq += "INNER JOIN " + retSQLName("ZBJ") + " ZBJ"	+ CRLF
	cQryArq += "ON" 										+ CRLF
//	cQryArq += "	ZBJ.ZBJ_REPRES = ZBI.ZBI_REPRES"		+ CRLF
	cQryArq += "    ZBJ.ZBJ_ROTEIR = ZBI.ZBI_CODIGO" 								+ CRLF
    /*
	cQryArq += "WHERE" 																+ CRLF
	cQryArq += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" 				+ CRLF
	cQryArq += "	AND	ZBD.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" 				+ CRLF
	cQryArq += "	AND	ZBE.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" 				+ CRLF
	cQryArq += "	AND	ZBF.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" 				+ CRLF
	cQryArq += "	AND	ZBG.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" 				+ CRLF
	cQryArq += "	AND	ZBH.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'" 				+ CRLF
	cQryArq += "	AND	ZBI.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryArq += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" 				+ CRLF
	cQryArq += "	AND	ZBJ.D_E_L_E_T_	<>	'*'" 									+ CRLF
    */

   	cQryArq += StaticCall(MGFCRM16,QryNivWheEV,.T.)

	cQryArq += "	AND	ZBJ.ZBJ_CLIENT	=	'" + cA1Cod	+ "'"						+ CRLF
	cQryArq += "	AND	ZBJ.ZBJ_LOJA	=	'" + cA1Loj	+ "'"						+ CRLF
	//cQryArq += "	AND	ZBJ.ZBJ_ROTEIR	=	'" + cRoteiro + "'"						+ CRLF

	TcQuery cQryArq New Alias "QRYARQ"

	DBSelectArea("ZBJ")

	while !QRYARQ->(EOF())
		nZBJRecno := ""
		nZBJRecno := QRYARQ->ZBJRECNO

		ZBJ->( DBGoTop() )
		ZBJ->( DBGoTo( nZBJRecno ) )

		recLock("ZBJ", .F.)
			ZBJ->(DBDelete())
		ZBJ->(MSUnlock())

		QRYARQ->(DBSkip())
	enddo

	ZBJ->(DBCloseArea())

	QRYARQ->(DBCloseArea())
return

User Function REPRES()
Local lRet := .T.
Local cAliasR := ""

cAliasR	:= GetNextAlias()
cQuery := " SELECT ZBJ_REPRES "
cQuery += " FROM " + RetSqlName("ZBJ") + " ZBJ "
cQuery += " WHERE ZBJ.ZBJ_FILIAL = '" + XFILIAL("ZBJ") + "'"
cQuery += " AND ZBJ.ZBJ_CLIENT = '"+ M->C5_CLIENTE + "'"
cQuery += " AND ZBJ.ZBJ_LOJA = '" + M->C5_LOJACLI + "'"
cQuery += " AND ZBJ.ZBJ_REPRES = '" + M->C5_VEND1 + "'"
cQuery += " AND ZBJ.D_E_L_E_T_=' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasR, .F., .T.)

If (cAliasR)->(eof())
	lRet := .F.
	MsgAlert(" Não existe amarraçao desse representante para esse cliente na estrutura de vendas!")
EndIf

(cAliasR)->(DBCloseArea())
Return lRet
