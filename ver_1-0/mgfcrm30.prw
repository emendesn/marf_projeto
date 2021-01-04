#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM30
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              12/04/2017
Descricao / Objetivo:   Importa CSV
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM30()
	if getParam()
		//impArq()
		fwMsgRun(, {|| impArq() }, "Processando", "Aguarde. Processando arquivo..." )
	endif
	APMsgInfo("Importacao finalizada.")
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Selecione o arquivo"	, space(200), "@!"	, ""	, ""	, 070, .T., "Arquivos .CSV |*.CSV", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Estrutura de Vendas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function impArq()
	local nOpen			:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast			:= 0
	local cLinha		:= ""
	local nLinAtu		:= 0

	private aLinha		:= {}
	private cA1Cod		:= ""
	private cA1Loj		:= ""
	private nRecnoSA1	:= 0

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		if !msgYesNo("A importacao deste arquivo ira sobrepor a estrutura dos clientes. Deseja prosseguir?", "Alteracao de Estrutura de Vendas")
			return
		endif

		FT_FGOTOP()
		nLast := FT_FLastRec()
		FT_FGOTOP()

		while !FT_FEOF()
			nLinAtu++

			if nLinAtu > 1
				cLinha := ""
				cLinha := FT_FREADLN()
				aLinha := {}
				aLinha := strTokArr(cLinha, ";")

				if chkStruct()// Verifica estrutura de destino
					cA1Cod		:= ""
					cA1Loj		:= ""
					nRecnoSA1	:= 0
					if len(aLinha) == 8 // caso o arquivo contenha codigo e loja nulos
						if chkCustom() // Verifica s cliente existe
							eraseStruc()
							newStruct() // Insere na nova estrutura
						else
							// gera log
						endif
					endif
				else
					// gera log
				endif
			endif

			FT_FSKIP()
		enddo
	endif
return

//******************************************************
// Verifica estrutura de destino
//******************************************************
static function chkStruct()
	local lRet		:= .F.
	local cQryArq	:= ""

	cQryArq := "SELECT 1 "
	cQryArq += "FROM "+retSQLName("ZBI")+" ZBI "
	cQryArq += "WHERE "
	cQryArq += "ZBI_FILIAL = '"+xFilial("ZBI")+"' "
	cQryArq += "AND	ZBI.D_E_L_E_T_ <> '*' "
	cQryArq += "AND	ZBI_DIRETO = '"+padL(aLinha[1],6,"0")+"' "
	cQryArq += "AND	ZBI_NACION = '"+padL(aLinha[2],6,"0")+"' "
	cQryArq += "AND	ZBI_TATICA = '"+padL(aLinha[3],6,"0")+"' "
	cQryArq += "AND	ZBI_REGION = '"+padL(aLinha[4],6,"0")+"' "
	cQryArq += "AND	ZBI_SUPERV = '"+padL(aLinha[5],6,"0")+"' "
	cQryArq += "AND	ZBI_CODIGO = '"+padL(aLinha[6],6,"0")+"' "

	TcQuery cQryArq New Alias "QRYARQ"

	if !QRYARQ->(EOF())
		lRet := .T.
	endif

	QRYARQ->(DBCloseArea())
return lRet

//******************************************************
// Verifica s cliente existe
//******************************************************
static function chkCustom()
	local lRet		:= .F.
	local cQryArq	:= ""

	cQryArq += "SELECT SA1.R_E_C_N_O_ RECNOSA1, A1_COD, A1_LOJA"				+ CRLF
	cQryArq += " FROM " + retSQLName("SA1") + " SA1"							+ CRLF
	cQryArq += " WHERE"															+ CRLF
	//cQryArq += " 		SA1.A1_CGC		=	'" + allTrim(aLinha[7]) + "'"		+ CRLF
	cQryArq += " 		SA1.A1_COD		=	'" + padL(allTrim(aLinha[7])	, tamSx3("A1_COD")[1]	, "0") + "'"		+ CRLF
	cQryArq += " 	AND SA1.A1_LOJA		=	'" + padL(allTrim(aLinha[8])	, tamSx3("A1_LOJA")[1]	, "0") + "'"		+ CRLF
	cQryArq += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"			+ CRLF
	cQryArq += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF

	TcQuery cQryArq New Alias "QRYARQ"

	if !QRYARQ->(EOF())
		lRet		:= .T.
		cA1Cod		:= QRYARQ->A1_COD
		cA1Loj		:= QRYARQ->A1_LOJA
		nRecnoSA1	:= QRYARQ->RECNOSA1
	endif

	QRYARQ->(DBCloseArea())
return lRet

//******************************************************
// Apaga da estrutura atual caso exista
//******************************************************
static function eraseStruc()
	local nZBJRecno	:= ""
	local cQryArq	:= ""
	local aArea		:= getArea()
	local aAreaSA1	:= SA1->(getArea())

	cQryArq += "SELECT ZBJ.R_E_C_N_O_ ZBJRECNO "										+ CRLF
	cQryArq += "FROM "+retSQLName("ZBI")+" ZBI "
	cQryArq += "INNER JOIN " + retSQLName("ZBJ") + " ZBJ "	+ CRLF
	cQryArq += "ON " 										+ CRLF
	cQryArq += "	ZBJ.ZBJ_REPRES = ZBI.ZBI_REPRES "		+ CRLF
	cQryArq += "AND ZBJ.ZBJ_ROTEIR = ZBI.ZBI_CODIGO " 		+ CRLF
	cQryArq += "AND	ZBJ.ZBJ_CLIENT	=	'" + cA1Cod	+ "' "						+ CRLF
	cQryArq += "AND	ZBJ.ZBJ_LOJA	=	'" + cA1Loj	+ "' "						+ CRLF
	cQryArq += "AND ZBJ_FILIAL = '"+xFilial("ZBJ")+"' "
	cQryArq += "AND	ZBJ.D_E_L_E_T_ <> '*' "
	cQryArq += "WHERE "
	cQryArq += "ZBI_FILIAL = '"+xFilial("ZBI")+"' "
	cQryArq += "AND	ZBI.D_E_L_E_T_ <> '*' "

	TcQuery cQryArq New Alias "QRYARQ"

	DBSelectArea("ZBJ")

	while !QRYARQ->(EOF())
		nZBJRecno := 0
		nZBJRecno := QRYARQ->ZBJRECNO

		if nZBJRecno > 0
			ZBJ->( DBGoTop() )
			ZBJ->( DBGoTo( nZBJRecno ) )

			recLock("ZBJ", .F.)
				ZBJ->ZBJ_INTSFO := "P" //Tratamento Hierarquia Cliente x Vendedor Salesforce
				ZBJ->(DBDelete())
			ZBJ->(MSUnlock())
		endif

		DBSelectArea("SA1")

		if nRecnoSA1 > 0
			SA1->( DBGoTop() )
			SA1->( DBGoTo( nRecnoSA1 ) )

			// Atualiza vendedor do cliente
			SA1->( recLock( "SA1", .F. ) )
			SA1->A1_XINTEGX	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SFA
			SA1->A1_XINTECO	:= '0' // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE

			if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
				SA1->A1_XINTSFO	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
			endif

			SA1->( msUnlock() )
		endif

		QRYARQ->(DBSkip())
	enddo

	ZBJ->(DBCloseArea())

	QRYARQ->(DBCloseArea())

	restArea(aAreaSA1)
	restArea(aArea)
return

//******************************************************
// Insere na nova estrutura
//******************************************************
static function newStruct()
	local aArea			:= getArea()
	local aAreaSA1		:= SA1->(getArea())
	local cRepresZBI	:= getVendor()[1]
	local cUpdTbl		:= ""

	ZBJ->( recLock( "ZBJ", .T. ) )
		ZBJ->ZBJ_FILIAL	:= xFilial("ZBJ")
		ZBJ->ZBJ_DIRETO := padL(aLinha[1],6,"0")
		ZBJ->ZBJ_NACION := padL(aLinha[2],6,"0")
		ZBJ->ZBJ_TATICA := padL(aLinha[3],6,"0")
		ZBJ->ZBJ_REGION := padL(aLinha[4],6,"0")
		ZBJ->ZBJ_SUPERV := padL(aLinha[5],6,"0")
		ZBJ->ZBJ_ROTEIR := padL(aLinha[6],6,"0")
		ZBJ->ZBJ_REPRES := cRepresZBI
		ZBJ->ZBJ_CLIENT := cA1Cod
		ZBJ->ZBJ_LOJA	:= cA1Loj
		ZBJ->ZBJ_INTSFO := "P" //Tratamento Hierarquia Cliente x Vendedor Salesforce
	ZBJ->( msUnlock() )

	// STATUS PARA O VENDEDOR SER ENVIADO AO SALESFORCE
	cUpdTbl	:= ""

	cUpdTbl := "UPDATE " + retSQLName("SA3")				+ CRLF
	cUpdTbl += "	SET"									+ CRLF
	cUpdTbl += " 		A3_XINTSFO = 'P'"					+ CRLF
	cUpdTbl += " WHERE"										+ CRLF
	cUpdTbl += " 		A3_COD = '" + ZBJ->ZBJ_REPRES + "'"	+ CRLF

	if tcSQLExec( cUpdTbl ) < 0
		conout( "Nao  foi possivel executar UPDATE." + CRLF + tcSqlError() )
	endif
	// FIM - STATUS PARA O VENDEDOR SER ENVIADO AO SALESFORCE

	DBSelectArea("SA1")

	if nRecnoSA1 > 0
		SA1->( DBGoTop() )
		SA1->( DBGoTo( nRecnoSA1 ) )

		// Atualiza vendedor do cliente
		SA1->( recLock( "SA1", .F. ) )
			SA1->A1_VEND	:= cRepresZBI
			SA1->A1_XINTEGX	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SFA
			SA1->A1_XINTECO	:= '0' // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE

			if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
				SA1->A1_XINTSFO	:= 'P' // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
			endif
		SA1->( msUnlock() )
	endif

	restArea(aAreaSA1)
	restArea(aArea)
return

//******************************************************
// Pega vendedor
//******************************************************
static function getVendor()
	local aVendor	:= {}
	local cQryArq	:= ""

	//cQryArq += "SELECT ZBI_REPRES "													+ CRLF
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
	*/
    /*
	cQryArq += StaticCall(MGFCRM16,QryNivSelEV,.F.)
	cQryArq += StaticCall(MGFCRM16,QryNivWheEV,.F.)

	cQryArq += "	AND	ZBD.ZBD_CODIGO	=	'" + padL(aLinha[1]	, 6, "0")	+ "'"	+ CRLF
	cQryArq += "	AND	ZBE.ZBE_CODIGO	=	'" + padL(aLinha[2]	, 6, "0")	+ "'"	+ CRLF
	cQryArq += "	AND	ZBF.ZBF_CODIGO	=	'" + padL(aLinha[3]	, 6, "0")	+ "'"	+ CRLF
	cQryArq += "	AND	ZBG.ZBG_CODIGO	=	'" + padL(aLinha[4] , 6, "0")	+ "'"	+ CRLF
	cQryArq += "	AND	ZBH.ZBH_CODIGO	=	'" + padL(aLinha[5] , 6, "0")	+ "'"	+ CRLF
	cQryArq += "	AND	ZBI.ZBI_CODIGO	=	'" + padL(aLinha[6] , 6, "0")	+ "'"	+ CRLF
	*/

	cQryArq += "SELECT ZBI_REPRES "													+ CRLF
	cQryArq += "FROM "+retSQLName("ZBI")+" ZBI "
	cQryArq += "WHERE "
	cQryArq += "ZBI_FILIAL = '"+xFilial("ZBI")+"' "
	cQryArq += "AND	ZBI.D_E_L_E_T_ <> '*' "
	cQryArq += "AND	ZBI_DIRETO = '"+padL(aLinha[1],6,"0")+"' "
	cQryArq += "AND	ZBI_NACION = '"+padL(aLinha[2],6,"0")+"' "
	cQryArq += "AND	ZBI_TATICA = '"+padL(aLinha[3],6,"0")+"' "
	cQryArq += "AND	ZBI_REGION = '"+padL(aLinha[4],6,"0")+"' "
	cQryArq += "AND	ZBI_SUPERV = '"+padL(aLinha[5],6,"0")+"' "
	cQryArq += "AND	ZBI_CODIGO = '"+padL(aLinha[6],6,"0")+"' "

	TcQuery cQryArq New Alias "QRYARQ"

	if !QRYARQ->(EOF())
		aAdd(aVendor,QRYARQ->ZBI_REPRES)
	endif

	QRYARQ->(DBCloseArea())
return aVendor
