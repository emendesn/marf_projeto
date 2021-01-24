#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "Ap5Mail.ch"

//

/*/{Protheus.doc} MGFFAT61
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param nThreadAtu, numeric, descricao
@param nLimThread, numeric, descricao
@param cEmpX, characters, descricao
@param cFilX, characters, descricao
@type function
/*/
User Function MGFFAT61(nThreadAtu,nLimThread,cEmpX,cFilX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", cEmpX, cFilX,,,,, { } ); Else; RpcSetEnv( cEmpX, cFilX,,,,, { } ); endif

	conout("[MGFWSC04] Iniciada Threads para a empresa" + allTrim( cFilX ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg61( nThreadAtu, nLimThread )

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return


static function runInteg61( nThreadAtu, nLimThread )
	local cURLPost		:= allTrim(getMv("MGF_SFA04"))
	local oWSSFA		:= nil
	local lRet			:= .T.
	private oPrice		:= nil
	private nPrice		:= nil

	priceToSFA( nThreadAtu, nLimThread )

	while !QRYZC8->(EOF())
		oPrice := nil
		oPrice := priceSFA():new()

		oPrice:setPrice()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oPrice ,,, , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA04T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()


		memoWrite("C:\TEMP\LISTA_PRECO.JSON", oWSSFA:cJson)

		QRYZC8->(DBSkip())
	enddo

	QRYZC8->(DBCloseArea())
return




static function priceToSFA( nThreadAtu, nLimThread )
	local cQryZC8	:= ""

	cQryZC8 += " SELECT *"																	+ chr(13) + chr(10)
	cQryZC8 += " FROM "																		+ chr(13) + chr(10)
	cQryZC8 += " ("																			+ chr(13) + chr(10)
	cQryZC8 += " 	SELECT COUNT(*) OVER(PARTITION BY ZC8_FILIAL) QTD_REC,"					+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_ROWNUM		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_FILIAL		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CODTPE		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CLIENT		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CODTAB		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CODPRO		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_ESTADO		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_DATDE		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_DATATE		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_PRCVEN		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_VALDES		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CODFIL		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_DESCRI		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_CODVEN		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	ZC8_REGIAO		,"														+ chr(13) + chr(10)
	cQryZC8 += " 	D_E_L_E_T_ ZC8DEL"														+ chr(13) + chr(10)
	cQryZC8 += " FROM " + retSQLName("ZC8") + " ZC8"										+ chr(13) + chr(10)
	cQryZC8 += " WHERE ZC8_FILIAL = '" + xFilial("ZC8") + "'"								+ chr(13) + chr(10)
	cQryZC8 += " )"																			+ chr(13) + chr(10)
	cQryZC8 += " WHERE"																		+ chr(13) + chr(10)
	cQryZC8 += "	ZC8_ROWNUM BETWEEN "																						+ chr(13) + chr(10)
	cQryZC8 += "	( ( " + allTrim( str( nThreadAtu ) ) + " - 1 ) * ( QTD_REC / " + allTrim(str(nLimThread)) + " ) ) + 1"		+ chr(13) + chr(10)
	cQryZC8 += "	AND"																										+ chr(13) + chr(10)
	cQryZC8 += 		allTrim( str( nThreadAtu ) ) + " *( QTD_REC / " + allTrim( str( nLimThread ) ) + " )"						+ chr(13) + chr(10)

	conout( cQryZC8 )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQryZC8)), "QRYZC8" , .F. , .T. )
return
