#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM32
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              12/04/2017
Descricao / Objetivo:   Estrutura de Vendas
Doc. Origem:            GAP CRM20
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM32(cA1Cod, cA1Loj)

	private aSizeAdv	:= MsAdvSize(.F.)
	private aSizeWnd	:= {aSizeAdv[7],0,aSizeAdv[6],aSizeAdv[5]}
	private oDlg1
	private oFWLayer
	private oPanelUp1
	private oPanelDw1
	private oPanelUp2
	private oPanelDw2

	private oList1
	private oList2

	private aOri	:= {}
	private aDest	:= {}

	private nRadio	:= 0

	DEFINE FONT oFont Name "Arial" Size 012,016 //BOLD

	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Transferencia - Estrutura de Vendas") FROM aSizeWnd[1],aSizeWnd[2] TO aSizeWnd[3],aSizeWnd[4] PIXEL

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlg1 /*oOwner*/, .F. /*lCloseBtn*/)

		oFWLayer:AddLine( 'UP1'		/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'UP2'		/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DOWN1'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DOWN2'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)

		oFWLayer:AddCollumn( 'ALLUP1'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP1'	/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLUP2'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP2'	/*cIDLine*/)

		oFWLayer:AddCollumn( 'ALLDW1'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN1'/*cIDLine*/)	
		oFWLayer:AddCollumn( 'ALLDW2'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN2'/*cIDLine*/)

		oPanelUp1	:= oFWLayer:GetColPanel( 'ALLUP1', 'UP1'	)
		oPanelUp2	:= oFWLayer:GetColPanel( 'ALLUP2', 'UP2'	)
		oPanelDw1	:= oFWLayer:GetColPanel( 'ALLDW1', 'DOWN1'	)
		oPanelDw2	:= oFWLayer:GetColPanel( 'ALLDW2', 'DOWN2'	)

		@ 060, 005 SAY oSay1 PROMPT "Estrutura atual:"		SIZE 150, 015 FONT oFont COLOR CLR_HBLUE OF oPanelUp1	COLORS 0, 16777215 PIXEL

		@ 060, 005 SAY oSay2 PROMPT "Estrutura destino:"	SIZE 150, 015 FONT oFont COLOR CLR_HBLUE OF oPanelDw1	COLORS 0, 16777215 PIXEL
		@ 027, 150 BUTTON oBtnPesq1 PROMPT "Pesquisar"		SIZE 060, 015 OF oPanelDw1 PIXEL ACTION ( U_MGFCRM31(@aDest), oGrid2:setArray(aDest), oGrid2:GoTop(.T.) )

		aRadio := {}
		aadd(aRadio, "Duplicar")
		aadd(aRadio, "Apagar Origem")

		@ 027, 240 RADIO oRadio VAR nRadio 3D ITEMS aRadio[1],aRadio[2] SIZE 65,8 PIXEL OF oPanelDw1

		@ 027, 340 BUTTON oBtnPesq1 PROMPT "Transferir"		SIZE 060, 015 OF oPanelDw1 PIXEL ACTION ( execTransf(cA1Cod, cA1Loj, aDest[oGrid2:nAt,17], aDest[oGrid2:nAt,19]), oDlg1:end() )

		// ********
		// Origem:
		// ********

		aadd(aOri, {"", "", "","",;
					"", "", "","",;
					"", "", "","",;
					"", "", "","",;
					"", "", "",""})

		getStruOri()

		oGrid1 := fwBrowse():New()
		oGrid1:setDataArray()
		oGrid1:setArray(aOri)
		oGrid1:disableConfig()
		oGrid1:disableReport()
		oGrid1:setOwner(oPanelUp2)

		oGrid1:addColumn({"C�d. N�vel 1"		, {||aOri[oGrid1:nAt,1]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"N�vel 1"				, {||aOri[oGrid1:nAt,2]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. Representante"	, {||aOri[oGrid1:nAt,3]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"Representante"		, {||aOri[oGrid1:nAt,4]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. N�vel 2"		, {||aOri[oGrid1:nAt,5]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"N�vel 2"				, {||aOri[oGrid1:nAt,6]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. Representante"	, {||aOri[oGrid1:nAt,7]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"Representante"		, {||aOri[oGrid1:nAt,8]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. N�vel 3"		, {||aOri[oGrid1:nAt,9]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"N�vel 4"				, {||aOri[oGrid1:nAt,10]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. Representante"	, {||aOri[oGrid1:nAt,11]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"Representante"		, {||aOri[oGrid1:nAt,12]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. N�vel 4"		, {||aOri[oGrid1:nAt,13]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"N�vel 4"				, {||aOri[oGrid1:nAt,14]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. Representante"	, {||aOri[oGrid1:nAt,15]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"Representante"		, {||aOri[oGrid1:nAt,16]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. N�vel 5"		, {||aOri[oGrid1:nAt,17]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"N�vel 5"				, {||aOri[oGrid1:nAt,18]}	, "C",, 1, 100	,, .F.})
		oGrid1:addColumn({"C�d. Representante"	, {||aOri[oGrid1:nAt,19]}	, "C",, 1, 035	,, .F.})
		oGrid1:addColumn({"Representante"		, {||aOri[oGrid1:nAt,20]}	, "C",, 1, 100	,, .F.})

		oGrid1:activate(.T.)

		// ********
		// Destino:
		// ********

		aadd(aDest, {"", "", "","",;
			"", "", "","",;
			"", "", "","",;
			"", "", "","",;
			"", "", "",""})

		oGrid2 := fwBrowse():New()
		oGrid2:setDataArray()
		oGrid2:setArray(aDest)
		oGrid2:disableConfig()
		oGrid2:disableReport()
		oGrid2:setOwner(oPanelDw2)

		oGrid2:addColumn({"C�d. N�vel 1"		, {||aDest[oGrid2:nAt,1]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"N�vel 1"				, {||aDest[oGrid2:nAt,2]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. Representante"	, {||aDest[oGrid2:nAt,3]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"Representante"		, {||aDest[oGrid2:nAt,4]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. N�vel 2"		, {||aDest[oGrid2:nAt,5]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"N�vel 2"				, {||aDest[oGrid2:nAt,6]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. Representante"	, {||aDest[oGrid2:nAt,7]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"Representante"		, {||aDest[oGrid2:nAt,8]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. N�vel 3"		, {||aDest[oGrid2:nAt,9]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"N�vel 4"				, {||aDest[oGrid2:nAt,10]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. Representante"	, {||aDest[oGrid2:nAt,11]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"Representante"		, {||aDest[oGrid2:nAt,12]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. N�vel 4"		, {||aDest[oGrid2:nAt,13]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"N�vel 4"				, {||aDest[oGrid2:nAt,14]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. Representante"	, {||aDest[oGrid2:nAt,15]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"Representante"		, {||aDest[oGrid2:nAt,16]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. N�vel 5"		, {||aDest[oGrid2:nAt,17]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"N�vel 5"				, {||aDest[oGrid2:nAt,18]}	, "C",, 1, 100	,, .F.})
		oGrid2:addColumn({"C�d. Representante"	, {||aDest[oGrid2:nAt,19]}	, "C",, 1, 035	,, .F.})
		oGrid2:addColumn({"Representante"		, {||aDest[oGrid2:nAt,20]}	, "C",, 1, 100	,, .F.})

		oGrid2:activate(.T.)

	ACTIVATE MSDIALOG oDlg1
return

//******************************************************
// Executa transferencia
//******************************************************
static function execTransf(cA1Cod, cA1Loj, cNivel5, cVend5)

	/*
		aadd(aRadio, "Duplicar")
		aadd(aRadio, "Apagar Origem")
	*/

	if nRadio == 2
		eraseStruc(cA1Cod, cA1Loj) // Apaga da estrutura atual caso exista
	endif

	newStruct(cA1Cod, cA1Loj, cNivel5, cVend5) // Insere na nova estrutura
return

//******************************************************
// Apaga da estrutura atual caso exista
//******************************************************
static function eraseStruc(cA1Cod, cA1Loj)
	local cZBIRecno	:= ""
	local cQryArq	:= ""

	cQryArq += "SELECT ZBI.R_E_C_N_O_ ZBIRECNO"										+ CRLF
	cQryArq += "FROM " + retSQLName("ZBD") + " ZBD"									+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryArq += "ON"																	+ CRLF
	cQryArq += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO"								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryArq += "ON"																	+ CRLF
	cQryArq += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 							+ CRLF
	cQryArq += "ON" 																+ CRLF
	cQryArq += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 								+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 							+ CRLF
	cQryArq += "ON"	 																+ CRLF
	cQryArq += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION" 								+ CRLF

	cQryArq += "INNER JOIN " + retSQLName("ZBI") + " ZBI" 							+ CRLF
	cQryArq += "ON" 																+ CRLF
	cQryArq += "	ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV" 								+ CRLF

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

	cQryArq += "	AND	ZBI.ZBI_CLIENT	=	'" + cA1Cod	+ "'"						+ CRLF
	cQryArq += "	AND	ZBI.ZBI_LOJA	=	'" + cA1Loj	+ "'"						+ CRLF

	TcQuery cQryArq New Alias "QRYARQ"

	DBSelectArea("ZBI")

	while !QRYARQ->(EOF())
		cZBIRecno := ""
		cZBIRecno := QRYARQ->ZBIRECNO

		ZBI->( DBGoTop() )
		ZBI->( DBGoTo( cZBIRecno ) )

		recLock("ZBI", .F.)
			ZBI->(DBDelete())
		ZBI->(MSUnlock())

		QRYARQ->(DBSkip())
	enddo

	ZBI->(DBCloseArea())

	QRYARQ->(DBCloseArea())
return

//******************************************************
// Insere na nova estrutura
//******************************************************
static function newStruct(cA1Cod, cA1Loj, cNivel5, cVend5)
	DBSelectArea("ZBI")

	recLock("ZBI", .T.)
		ZBI->ZBI_FILIAL	:= xFilial("ZBI")
		ZBI->ZBI_CODIGO := GETSX8NUM("ZBI", "ZBI_CODIGO")
		ZBI->ZBI_DESCRI := "TRANSFERENCIA MANUAL"
		ZBI->ZBI_SUPERV := cNivel5
		ZBI->ZBI_REPRES := cVend5
		ZBI->ZBI_CLIENT := cA1Cod
		ZBI->ZBI_LOJA	:= cA1Loj
	ZBI->(MSUnlock())

	CONFIRMSX8()

	ZBI->(DBCloseArea())
return


//----------------------------------------------
//
//----------------------------------------------
static function getStruOri()
	local cQryStrOri	:= ""

	cQryStrOri += "SELECT"																+ CRLF
	cQryStrOri += "	ZBD_CODIGO CODIGO1, ZBD_DESCRI NIVEL1, ZBD_REPRES CODREPRES1," + CRLF
	cQryStrOri += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES1," + CRLF
	cQryStrOri += "	ZBE_CODIGO CODIGO2, ZBE_DESCRI NIVEL2, ZBE_REPRES CODREPRES2," + CRLF
	cQryStrOri += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBE.ZBE_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES2," + CRLF
	cQryStrOri += "	ZBF_CODIGO CODIGO3, ZBF_DESCRI NIVEL3, ZBF_REPRES CODREPRES3," + CRLF
	cQryStrOri += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBF.ZBF_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES3," + CRLF
	cQryStrOri += "	ZBG_CODIGO CODIGO4, ZBG_DESCRI NIVEL4, ZBG_REPRES CODREPRES4," + CRLF
	cQryStrOri += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBG.ZBG_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES4," + CRLF
	cQryStrOri += "	ZBH_CODIGO CODIGO5, ZBH_DESCRI NIVEL5, ZBH_REPRES CODREPRES5," + CRLF
	cQryStrOri += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBH.ZBH_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES5" + CRLF
	cQryStrOri += "FROM " + retSQLName("ZBD") + " ZBD"									+ CRLF
	cQryStrOri += "INNER JOIN " + retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryStrOri += "ON"																	+ CRLF
	cQryStrOri += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO"								+ CRLF
	cQryStrOri += "INNER JOIN " + retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryStrOri += "ON"																	+ CRLF
	cQryStrOri += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 								+ CRLF
	cQryStrOri += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 							+ CRLF
	cQryStrOri += "ON" 																+ CRLF
	cQryStrOri += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 								+ CRLF
	cQryStrOri += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 							+ CRLF
	cQryStrOri += "ON"	 																+ CRLF
	cQryStrOri += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION" 								+ CRLF
	cQryStrOri += "WHERE" 																+ CRLF
	cQryStrOri += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" 				+ CRLF
	cQryStrOri += "	AND	ZBD.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStrOri += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" 				+ CRLF
	cQryStrOri += "	AND	ZBE.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStrOri += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" 				+ CRLF
	cQryStrOri += "	AND	ZBF.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStrOri += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" 				+ CRLF
	cQryStrOri += "	AND	ZBG.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStrOri += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" 				+ CRLF
	cQryStrOri += "	AND	ZBH.D_E_L_E_T_	<>	'*'" 									+ CRLF

	TcQuery cQryStrOri New Alias "QRYSTRORI"

	aOri := {}
	if !QRYSTRORI->(EOF())
		aadd(aOri, {QRYSTRORI->CODIGO1, QRYSTRORI->NIVEL1, QRYSTRORI->CODREPRES1,QRYSTRORI->REPRES1,;
					QRYSTRORI->CODIGO2, QRYSTRORI->NIVEL2, QRYSTRORI->CODREPRES2,QRYSTRORI->REPRES2,;
					QRYSTRORI->CODIGO3, QRYSTRORI->NIVEL3, QRYSTRORI->CODREPRES3,QRYSTRORI->REPRES3,;
					QRYSTRORI->CODIGO4, QRYSTRORI->NIVEL4, QRYSTRORI->CODREPRES4,QRYSTRORI->REPRES4,;
					QRYSTRORI->CODIGO5, QRYSTRORI->NIVEL5, QRYSTRORI->CODREPRES5,QRYSTRORI->REPRES5	})
	else
		aadd(aOri, {"", "", "","",;
					"", "", "","",;
					"", "", "","",;
					"", "", "","",;
					"", "", "",""})
	endif

	QRYSTRORI->(DBCloseArea())
return

static function getStructs()
	local cQryStr	:= ""

	cQryStr += "SELECT"																+ CRLF
	cQryStr += "	ZBD_CODIGO CODIGO1, ZBD_DESCRI NIVEL1, ZBD_REPRES CODREPRES1," + CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES1," + CRLF
	cQryStr += "	ZBE_CODIGO CODIGO2, ZBE_DESCRI NIVEL2, ZBE_REPRES CODREPRES2," + CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBE.ZBE_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES2," + CRLF
	cQryStr += "	ZBF_CODIGO CODIGO3, ZBF_DESCRI NIVEL3, ZBF_REPRES CODREPRES3," + CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBF.ZBF_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES3," + CRLF
	cQryStr += "	ZBG_CODIGO CODIGO4, ZBG_DESCRI NIVEL4, ZBG_REPRES CODREPRES4," + CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBG.ZBG_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES4," + CRLF
	cQryStr += "	ZBH_CODIGO CODIGO5, ZBH_DESCRI NIVEL5, ZBH_REPRES CODREPRES5," + CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBH.ZBH_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES5," + CRLF
	cQryStr += "FROM " + retSQLName("ZBD") + " ZBD"									+ CRLF
	cQryStr += "INNER JOIN " + retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryStr += "ON"																	+ CRLF
	cQryStr += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO"								+ CRLF
	cQryStr += "INNER JOIN " + retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryStr += "ON"																	+ CRLF
	cQryStr += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 								+ CRLF
	cQryStr += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 							+ CRLF
	cQryStr += "ON" 																+ CRLF
	cQryStr += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 								+ CRLF
	cQryStr += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 							+ CRLF
	cQryStr += "ON"	 																+ CRLF
	cQryStr += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION" 								+ CRLF
	cQryStr += "WHERE" 																+ CRLF
	cQryStr += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" 				+ CRLF
	cQryStr += "	AND	ZBD.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStr += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" 				+ CRLF
	cQryStr += "	AND	ZBE.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStr += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" 				+ CRLF
	cQryStr += "	AND	ZBF.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStr += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" 				+ CRLF
	cQryStr += "	AND	ZBG.D_E_L_E_T_	<>	'*'" 									+ CRLF
	cQryStr += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" 				+ CRLF
	cQryStr += "	AND	ZBH.D_E_L_E_T_	<>	'*'" 									+ CRLF

	TcQuery cQryStr New Alias "QRYSTR"
return