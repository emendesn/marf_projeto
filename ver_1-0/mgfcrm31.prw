#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM31
Autor....:              Gustavo Ananias Afonso
Data.....:              12/04/2017
Descricao / Objetivo:   Estrutura de Venda - Lista todas
Doc. Origem:            GAP CRM20
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM31(aDest)
	local aSeek		:= {}
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local oDlg			:= nil
	local aArea			:= getArea()

	private oSxbStr		:= nil
	private aStructs	:= {}

	//Pesquisa que sera exibido
	aadd(aSeek,{"C�d. N�vel 1"	, { {"","C",6	,0,"C�d. N�vel 1"	,,} }})
	aadd(aSeek,{"N�vel 1"		, { {"","C",100	,0,"N�vel 1"		,,} }})

	aadd(aSeek,{"C�d. N�vel 2"	, { {"","C",6	,0,"C�d. N�vel 2"	,,} }})
	aadd(aSeek,{"N�vel 2"		, { {"","C",100	,0,"N�vel 2"		,,} }})

	aadd(aSeek,{"C�d. N�vel 3"	, { {"","C",6	,0,"C�d. N�vel 3"	,,} }})
	aadd(aSeek,{"N�vel 3"		, { {"","C",100	,0,"N�vel 3"		,,} }})

	aadd(aSeek,{"C�d. N�vel 4"	, { {"","C",6	,0,"C�d. N�vel 4"	,,} }})
	aadd(aSeek,{"N�vel 4"		, { {"","C",100	,0,"N�vel 4"		,,} }})

	aadd(aSeek,{"C�d. N�vel 5"	, { {"","C",6	,0,"C�d. N�vel 5"	,,} }})
	aadd(aSeek,{"N�vel 5"		, { {"","C",100	,0,"N�vel 5"		,,} }})

	getStructs()

	while !QRYSTR->(EOF())

		aadd(aStructs, {	QRYSTR->CODIGO1, QRYSTR->NIVEL1, QRYSTR->CODREPRES1, QRYSTR->REPRES1,;
							QRYSTR->CODIGO2, QRYSTR->NIVEL2, QRYSTR->CODREPRES2, QRYSTR->REPRES2,;
							QRYSTR->CODIGO3, QRYSTR->NIVEL3, QRYSTR->CODREPRES3, QRYSTR->REPRES3,;
							QRYSTR->CODIGO4, QRYSTR->NIVEL4, QRYSTR->CODREPRES4, QRYSTR->REPRES4,;
							QRYSTR->CODIGO5, QRYSTR->NIVEL5, QRYSTR->CODREPRES5, QRYSTR->REPRES5 })

		QRYSTR->(DBSkip())
	enddo

	QRYSTR->(DBCloseArea())

	DEFINE MSDIALOG oDlg TITLE 'Estruturas de Venda Destino' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oSxbStr := fwBrowse():New()
		oSxbStr:setDataArray()
		oSxbStr:setArray(aStructs)
		oSxbStr:disableConfig()
		oSxbStr:disableReport()
		oSxbStr:setOwner(oDlg)
		
		oSxbStr:setSeek(, aSeek)
/*
		SetSeek
		Habilita a utiliza��o da pesquisa de registros no Browse
		
		@param   bAction Code-Block executado para a pesquisa de registros, caso nao seja informado sera utilizado o padrao
		@param   aOrder  Estrutura do array
						[n,1] Titulo da pesquisa
						[n,2,n,1] LookUp
						[n,2,n,2] Tipo de dados
						[n,2,n,3] Tamanho
						[n,2,n,4] Decimal
						[n,2,n,5] Titulo do campo
						[n,2,n,6] Mascara
						[n,2,n,7] Nome Fisico do campo - Opcional - � ajustado no programa
						[n,3] Ordem da pesquisa
						[n,4] Exibe na pesquisa 
*/


		
		oSxbStr:addColumn({"C�d. N�vel 1"			, {||aStructs[oSxbStr:nAt,1]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"N�vel 1"				, {||aStructs[oSxbStr:nAt,2]}	, "C", , 1, 25	})
		oSxbStr:addColumn({"C�d. Representante"		, {||aStructs[oSxbStr:nAt,3]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"Representante"			, {||aStructs[oSxbStr:nAt,4]}	, "C", , 1, 25	})

		oSxbStr:addColumn({"C�d. N�vel 2"			, {||aStructs[oSxbStr:nAt,5]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"N�vel 2"				, {||aStructs[oSxbStr:nAt,6]}	, "C", , 1, 25	})
		oSxbStr:addColumn({"C�d. Representante"		, {||aStructs[oSxbStr:nAt,7]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"Representante"			, {||aStructs[oSxbStr:nAt,8]}	, "C", , 1, 25	})

		oSxbStr:addColumn({"C�d. N�vel 3"			, {||aStructs[oSxbStr:nAt,9]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"N�vel 4"				, {||aStructs[oSxbStr:nAt,10]}	, "C", , 1, 25	})
		oSxbStr:addColumn({"C�d. Representante"		, {||aStructs[oSxbStr:nAt,11]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"Representante"			, {||aStructs[oSxbStr:nAt,12]}	, "C", , 1, 25	})

		oSxbStr:addColumn({"C�d. N�vel 4"			, {||aStructs[oSxbStr:nAt,13]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"N�vel 4"				, {||aStructs[oSxbStr:nAt,14]}	, "C", , 1, 25	})
		oSxbStr:addColumn({"C�d. Representante"		, {||aStructs[oSxbStr:nAt,15]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"Representante"			, {||aStructs[oSxbStr:nAt,16]}	, "C", , 1, 25	})
		
		oSxbStr:addColumn({"C�d. N�vel 5"			, {||aStructs[oSxbStr:nAt,17]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"N�vel 5"				, {||aStructs[oSxbStr:nAt,18]}	, "C", , 1, 25	})
		oSxbStr:addColumn({"C�d. Representante"		, {||aStructs[oSxbStr:nAt,19]}	, "C", , 1, 10	})
		oSxbStr:addColumn({"Representante"			, {||aStructs[oSxbStr:nAt,20]}	, "C", , 1, 25	})

		oSxbStr:setDoubleClick( { || setVars(@aDest), oDlg:end() } )
		oSxbStr:activate(.T.)

		//enchoiceBar(oDlg, { || setVars(), oDlg:end() } , { || cGetCdArma := "", oDlg:end() })
	ACTIVATE MSDIALOG oDlg CENTER

	restArea(aArea)
return (.T.)

static function setVars(aDest)

	aDest := {}

	aadd(aDest, {	aStructs[oSxbStr:nAt,1]	, aStructs[oSxbStr:nAt,2]	, aStructs[oSxbStr:nAt,3]	, aStructs[oSxbStr:nAt,4]	,;
					aStructs[oSxbStr:nAt,5]	, aStructs[oSxbStr:nAt,6]	, aStructs[oSxbStr:nAt,7]	, aStructs[oSxbStr:nAt,8]	,;
					aStructs[oSxbStr:nAt,9]	, aStructs[oSxbStr:nAt,10]	, aStructs[oSxbStr:nAt,11]	, aStructs[oSxbStr:nAt,12]	,;
					aStructs[oSxbStr:nAt,13], aStructs[oSxbStr:nAt,14]	, aStructs[oSxbStr:nAt,15]	, aStructs[oSxbStr:nAt,16]	,;
					aStructs[oSxbStr:nAt,17], aStructs[oSxbStr:nAt,18]	, aStructs[oSxbStr:nAt,19]	, aStructs[oSxbStr:nAt,20]	})

return

//-------------------------------------------------
//-------------------------------------------------
static function getStructs()
	local cQryStr	:= ""

	cQryStr += "SELECT"																+ CRLF
	cQryStr += "	ZBD_CODIGO CODIGO1, ZBD_DESCRI NIVEL1, ZBD_REPRES CODREPRES1,"	+ CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES1," + CRLF
	cQryStr += "	ZBE_CODIGO CODIGO2, ZBE_DESCRI NIVEL2, ZBE_REPRES CODREPRES2,"	+ CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES2," + CRLF
	cQryStr += "	ZBF_CODIGO CODIGO3, ZBF_DESCRI NIVEL3, ZBF_REPRES CODREPRES3,"	+ CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES3," + CRLF
	cQryStr += "	ZBG_CODIGO CODIGO4, ZBG_DESCRI NIVEL4, ZBG_REPRES CODREPRES4,"	+ CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES4," + CRLF
	cQryStr += "	ZBH_CODIGO CODIGO5, ZBH_DESCRI NIVEL5, ZBH_REPRES CODREPRES5,"	+ CRLF
	cQryStr += "	(SELECT A3_NOME FROM SA3010 SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES5" + CRLF
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