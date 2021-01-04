#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC71
Integração com Salesforce - Para ser chamado em JOB
@description
Integração com Salesforce - Para ser chamado em JOB
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param

@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC71( cFilJob )

	U_MGFWSC71( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC71
Integração com Salesforce - Para ser chamado em MENU
@description
Integração com Salesforce - Para ser chamado em MENU
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC71()

	runInteg71()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC71
Integração de Clientes com Salesforce - Preparação de Ambiente
@description
Integração de Clientes com Salesforce - Preparação de Ambiente
@author TOTVS
@since 06/09/2019
@type Function
@table
	ZBD - DIRETORIA
	ZBE - NACIONAL
	ZBF - TATICA
	ZBG - REGIONAL
	ZBH - SUPERVISAO
	ZBI - ROTEIRO
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC71( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC71] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg71()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg71
Integração de Clientes com Salesforce
@description
Integração de Clientes com Salesforce
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
cCnpjCli - Caracter - CNPJ do cliente que será integrado, opcional
@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg71()
	//local cURLInteg		:= allTrim( superGetMv( "MGFWSC71A" , , "https://anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/b44b083c-0be1-4200-92a1-d1a890e07fbd/marfrig-experience-protheus-hierarquiavendas/1.0.4/m/papeis" ) )
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC71A" , , "http://spdwvapl203:1337/experience/protheus/hierarquia-vendas/api/v1/papeis" ) )
	local cURLUse		:= ""
	local cHTTPMetho	:= ""
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local xRetHttp		:= nil
	local nI			:= 0
	local aHierarqui	:= {}
	local aPapeis		:= {}
	local lStart2		:= .F.

	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "008" ) ) // SZ2 - SISTEMA
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC71C"		, , "010" ) ) // SZ3 - ENTIDADE

	local cHeadHttp		:= ""

	private oJson		:= nil
	private oJsonN		:= nil
	private oJsonRet	:= nil

	conout("[SALESFORCE] - MGFWSC71- Selecionando papeis SALESFORCE")

	getHierar1()

	// PRIMEIRO ENVIO - SEM ASSOCIACAO DE PAPEIS
	// oJson			:= nil
	// oJson			:= JsonObject():new()
	// oJson['PAPEIS']	:= {}

	while !QRYWSC71->(EOF())
        cIdInteg	:= ""
		cIdInteg	:= fwUUIDv4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		aPapeis	:= {}
		oJsonN	:= nil
		oJsonN	:= JsonObject():new()

		oJsonN['IDPAPEL']		:= allTrim( QRYWSC71->CODIGO				)
		oJsonN['NOMEPAPEL']		:= upper( allTrim( QRYWSC71->DESCRICAO )	)

		oJsonN['RECNO']			:= QRYWSC71->ZBXRECNO
		oJsonN['UID']			:= fwuuidv4( .T. )

		if !empty( QRYWSC71->IDEXTERNAL )
			oJsonN['IDEXTERNAL'] := allTrim( QRYWSC71->IDEXTERNAL )
		endif

		//aadd( oJson['PAPEIS'] , oJsonN )
		aadd( aPapeis , oJsonN )

		cJson	:= ""
		//cJson	:= oJson:toJson()
		cJson	:= fwJsonSerialize( aPapeis , .F. )

		if !empty( cJson )
			conout( cJson )

			cURLUse		:= cURLInteg
			cHTTPMetho	:= "POST"

			cTimeIni	:= time()
			cHeaderRet	:= ""
			xRetHttp	:= nil
			xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC71] [PAPEL] * * * * * * * * * * * * * * * * * * * * "									)

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				oJsonRet := nil

				//if fwJsonDeserialize( cTest, @oJsonRet )
				if fwJsonDeserialize( xRetHttp, @oJsonRet )
					conout( xRetHttp )

					for nI := 1 to len( oJsonRet )
						//oJsonRet[ nI ]:idPapelErp

						if oJsonRet[ nI ]:sucesso
							lStart2 := .T. // Envia segunda integracao para associacao entre os niveis
							updCodSfo( oJsonRet[ nI ]:idPapelErp , oJsonRet[ nI ]:idPapelCrm , QRYWSC71->TABELA , QRYWSC71->ZBXRECNO )
						endif
					next
				endif
			endif

			cHeadHttp := ""

			for nI := 1 to len( aHeadStr )
				cHeadHttp += aHeadStr[ nI ]
			next

			for nI := 1 to len( aPapeis )
				//GRAVAR LOG
				U_MGFMONITOR(																													 ;
				cFilAnt																										/* Filial */									,;
				iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "1" , "2" )											/* Status - 1-Suceso / 2-Erro*/					,;
				cCodInteg																									/* Integração */								,;
				cCodTpInt																									/* Tipo de integração */						,;
				iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "Processamento realizado com sucesso!" , xRetHttp )	/*cErro*/										,;
				" "																											/*cDocori*/										,;
				cTimeProc																									/* Tempo de processamento */					,;
				aPapeis[ nI ]:toJson()																						/* JSON */										,;
				aPapeis[ nI ]["RECNO"]																						/* RECNO do registro */							,;
				cValToChar( nStatuHttp )																					/* Status HTTP Retornado */						,;
				.F.																											/* Se precisar preparar ambiente enviar .T. */	,;
				{}																											/* Filial para preparar ambiente */				,;
				aPapeis[ nI ]["UID"]																						/* UUID */	     								,;
				iif( type( xRetHttp ) <> "U", xRetHttp, " ")																/* JSON de RETORNO */							,;
				"A"																											/*cTipWsInt*/									,;
				" "																											/*cJsonCB Z1_JSONCB*/							,;
				" "																											/*cJsonRB Z1_JSONRB*/							,;
				sTod("    /  /  ")																							/*dDTCallb Z1_DTCALLB*/							,;
				" "																											/*cHoraCall Z1_HRCALLB*/						,;
				" "																											/*cCallBac Z1_CALLBAC*/							,;
				cURLUse																										/*cLinkEnv Z1_LINKENV*/							,;
				" "																				/*cLinkRec Z1_LINKREC*/							,;
				cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
				cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
			next

		endif
		QRYWSC71->(DBSkip())
	enddo

	QRYWSC71->(DBCloseArea())

	xRetHttp	:= nil
	oJsonRet	:= nil
	oJsonN		:= nil
	aPapeis		:= {}

	if lStart2
		cCodTpInt		:= allTrim( superGetMv( "MGFWSC71D"		, , "011" ) ) // SZ3 - ENTIDADE

		getHierar2()

		// SEGUNDO ENVIO - ASSOCIANDO OS PAPEIS COM O ID SALESFORCE

		// oJson			:= nil
		// oJson			:= JsonObject():new()
		// oJson['PAPEIS']	:= {}

		while !QRYWSC71->(EOF())
			aPapeis := {}
			oJsonN := nil
			oJsonN := JsonObject():new()

			// IDPAPEL		-> CODIGO PROTHEUS CONCATENADO
			// IDEXTERNAL	-> ID SALESFORCE
			// PAPELPAI		-> ID SALESFORCE DO PAI
			// NOMEPAPEL	-> NOME DO FILHO

			//cQryHierar += " SELECT 2 TABELA ,
			//ZBE_XIDSFO PAPEL,
			//ZBD_XIDSFO PAI,
			//ZBE.R_E_C_N_O_ ZBXRECNO,
			//ZBE_DESCRI DESCRICAO"						+ CRLF

			oJsonN['IDPAPEL']		:= allTrim( QRYWSC71->PAPEL					)
			oJsonN['IDEXTERNAL']	:= allTrim( QRYWSC71->IDEXTERNAL			)
			oJsonN['PAPELPAI']		:= allTrim( QRYWSC71->PAI					)
			oJsonN['NOMEPAPEL']		:= upper( allTrim( QRYWSC71->DESCRICAO 	)	)

			oJsonN['RECNO']			:= QRYWSC71->ZBXRECNO
			oJsonN['UID']			:= fwuuidv4( .T. )

			aadd( aPapeis , oJsonN )

			cJson	:= ""
			//cJson	:= oJson:toJson()
			cJson	:= fwJsonSerialize( aPapeis , .F. )

			if !empty( cJson )
				cURLUse		:= cURLInteg
				cHTTPMetho	:= "POST"

				cTimeIni	:= time()
				cHeaderRet	:= ""
				xRetHttp	:= nil
				xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni , cTimeFin )
				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()

				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] * * * * * Status da integracao * * * * *"									)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Tempo de Processamento.......: " + cTimeProc 								)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] URL..........................: " + cURLUse 								)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] HTTP Method..................: " + cHTTPMetho								)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Envio........................: " + cJson 									)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] Retorno......................: " + xRetHttp								)
				conout(" [SALESFORCE] [MGFWSC71] [ASSOCIACAO] * * * * * * * * * * * * * * * * * * * * "									)

				oJsonRet := nil

				//if fwJsonDeserialize( cTest, @oJsonRet )
				if fwJsonDeserialize( xRetHttp, @oJsonRet )
					conout( xRetHttp )

					for nI := 1 to len( oJsonRet )
						//oJsonRet[ nI ]:idPapelErp

						if oJsonRet[ nI ]:sucesso
							updStatInt( QRYWSC71->IDEXTERNAL , QRYWSC71->TABELA , QRYWSC71->ZBXRECNO )
						endif
					next
				endif

				cHeadHttp := ""

				for nI := 1 to len( aHeadStr )
					cHeadHttp += aHeadStr[ nI ]
				next

				for nI := 1 to len( aPapeis )
					//GRAVAR LOG
					U_MGFMONITOR(																													 ;
					cFilAnt																										/* Filial */									,;
					iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "1" , "2" )											/* Status - 1-Suceso / 2-Erro*/					,;
					cCodInteg																									/* Integração */								,;
					cCodTpInt																									/* Tipo de integração */						,;
					iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "Processamento realizado com sucesso!" , xRetHttp )	/*cErro*/										,;
					" "																											/*cDocori*/										,;
					cTimeProc																									/* Tempo de processamento */					,;
					aPapeis[ nI ]:toJson()																						/* JSON */										,;
					aPapeis[ nI ]["RECNO"]																						/* RECNO do registro */							,;
					cValToChar( nStatuHttp )																					/* Status HTTP Retornado */						,;
					.F.																											/* Se precisar preparar ambiente enviar .T. */	,;
					{}																											/* Filial para preparar ambiente */				,;
					aPapeis[ nI ]["UID"]																						/* UUID */	     								,;
					iif( type( xRetHttp ) <> "U", xRetHttp, " ")																/* JSON de RETORNO */							,;
					"A"																											/*cTipWsInt*/									,;
					" "																											/*cJsonCB Z1_JSONCB*/							,;
					" "																											/*cJsonRB Z1_JSONRB*/							,;
					sTod("    /  /  ")																							/*dDTCallb Z1_DTCALLB*/							,;
					" "																											/*cHoraCall Z1_HRCALLB*/						,;
					" "																											/*cCallBac Z1_CALLBAC*/							,;
					cURLUse																										/*cLinkEnv Z1_LINKENV*/							,;
					" "																				/*cLinkRec Z1_LINKREC*/							,;
					cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
					cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
				next

			endif

			QRYWSC71->( DBSkip() )
		enddo

		QRYWSC71->(DBCloseArea())
	endif

	freeObj( oJson )
	freeObj( oJsonN )
	freeObj( oJsonRet )

	delClassINTF()
return

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
static function updCodSfo( cIDPapel , cIDSalesfo , nTabela , nZBXRecno )
	local cCodHierar	:= ""
	local cUpdHieraq	:= ""

	cCodHierar	:= strTran( cIDPapel , "P" ) // REMOVE O CARACTER 'P' DOS CODIGOS

	do case
		case nTabela == 1 // ZBD - Diretoria
			cUpdHieraq := "UPDATE " + retSQLName( "ZBD" ) + " SET ZBD_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBD_CODIGO 																		= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 2 // ZBE - Nacional
			cUpdHieraq := "UPDATE " + retSQLName( "ZBE" ) + " SET ZBE_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBE_DIRETO || ZBE_CODIGO 															= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 3 // ZBF - Tatica
			cUpdHieraq := "UPDATE " + retSQLName( "ZBF" ) + " SET ZBF_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBF_DIRETO || ZBF_NACION || ZBF_CODIGO												= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 4 // ZBG - Regional
			cUpdHieraq := "UPDATE " + retSQLName( "ZBG" ) + " SET ZBG_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBG_DIRETO || ZBG_NACION || ZBG_TATICA || ZBG_CODIGO								= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 5 // ZBH - Supervisao
			cUpdHieraq := "UPDATE " + retSQLName( "ZBH" ) + " SET ZBH_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBH_DIRETO || ZBH_NACION || ZBH_TATICA || ZBH_REGION || ZBH_CODIGO					= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 6 // ZBI - Roteiro
			cUpdHieraq := "UPDATE " + retSQLName( "ZBI" ) + " SET ZBI_XIDSFO = '" + allTrim( cIDSalesfo ) + "' WHERE ZBI_DIRETO || ZBI_NACION || ZBI_TATICA || ZBI_REGION || ZBI_SUPERV || ZBI_CODIGO	= '" + cCodHierar + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
	endcase

	if !empty( cUpdHieraq )
		if tcSQLExec( cUpdHieraq ) < 0
			conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
		endif
	endif
return

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
static function updStatInt( cIDSalesfo , nTabela , nZBXRecno )
	local cUpdHieraq	:= ""

	do case
		case nTabela == 1 // ZBD - cIDSalesfo
			cUpdHieraq := "UPDATE " + retSQLName( "ZBD" ) + " SET ZBD_INTSFO = 'I' WHERE ZBD_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 2 // ZBE - Nacional
			cUpdHieraq := "UPDATE " + retSQLName( "ZBE" ) + " SET ZBE_INTSFO = 'I' WHERE ZBE_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 3 // ZBF - Tatica
			cUpdHieraq := "UPDATE " + retSQLName( "ZBF" ) + " SET ZBF_INTSFO = 'I' WHERE ZBF_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 4 // ZBG - Regional
			cUpdHieraq := "UPDATE " + retSQLName( "ZBG" ) + " SET ZBG_INTSFO = 'I' WHERE ZBG_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 5 // ZBH - Supervisao
			cUpdHieraq := "UPDATE " + retSQLName( "ZBH" ) + " SET ZBH_INTSFO = 'I' WHERE ZBH_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
		case nTabela == 6 // ZBI - Roteiro
			cUpdHieraq := "UPDATE " + retSQLName( "ZBI" ) + " SET ZBI_INTSFO = 'I' WHERE ZBI_XIDSFO = '" + allTrim( cIDSalesfo ) + "' AND D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = " + allTrim( str( nZBXRecno ) )
	endcase

	if !empty( cUpdHieraq )
		if tcSQLExec( cUpdHieraq ) < 0
			conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
		endif
	endif
return

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
static function getHierar1()
	local cQryHierar := ""

	cQryHierar := ""
	cQryHierar += " SELECT ZBD_XIDSFO IDEXTERNAL, 1 TABELA , 'P' || ZBD_CODIGO CODIGO , ZBD_DESCRI DESCRICAO																											, ZBD.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBD") + " ZBD WHERE ZBD.D_E_L_E_T_ = ' ' AND ZBD_FILIAL = '" + xFilial("ZBD") + "' AND ZBD_INTSFO = 'P'"	+ CRLF
	cQryHierar += " UNION ALL" 																																																																															+ CRLF
	cQryHierar += " SELECT ZBE_XIDSFO IDEXTERNAL, 2 TABELA , 'P' || ZBE_DIRETO || 'P' || ZBE_CODIGO CODIGO , ZBE_DESCRI DESCRICAO																						, ZBE.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBE") + " ZBE WHERE ZBE.D_E_L_E_T_ = ' ' AND ZBE_FILIAL = '" + xFilial("ZBE") + "' AND ZBE_INTSFO = 'P'"	+ CRLF
	cQryHierar += " UNION ALL" 																																																																															+ CRLF
	cQryHierar += " SELECT ZBF_XIDSFO IDEXTERNAL, 3 TABELA , 'P' || ZBF_DIRETO || 'P' || ZBF_NACION || 'P' || ZBF_CODIGO CODIGO , ZBF_DESCRI DESCRICAO																	, ZBF.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBF") + " ZBF WHERE ZBF.D_E_L_E_T_ = ' ' AND ZBF_FILIAL = '" + xFilial("ZBF") + "' AND ZBF_INTSFO = 'P'"	+ CRLF
	cQryHierar += " UNION ALL" 																																																																															+ CRLF
	cQryHierar += " SELECT ZBG_XIDSFO IDEXTERNAL, 4 TABELA , 'P' || ZBG_DIRETO || 'P' || ZBG_NACION || 'P' || ZBG_TATICA || 'P' || ZBG_CODIGO CODIGO , ZBG_DESCRI DESCRICAO											, ZBG.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBG") + " ZBG WHERE ZBG.D_E_L_E_T_ = ' ' AND ZBG_FILIAL = '" + xFilial("ZBG") + "' AND ZBG_INTSFO = 'P'"	+ CRLF
	cQryHierar += " UNION ALL" 																																																																															+ CRLF
	cQryHierar += " SELECT ZBH_XIDSFO IDEXTERNAL, 5 TABELA , 'P' || ZBH_DIRETO || 'P' || ZBH_NACION || 'P' || ZBH_TATICA || 'P' || ZBH_REGION || 'P' || ZBH_CODIGO CODIGO , ZBH_DESCRI DESCRICAO						, ZBH.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBH") + " ZBH WHERE ZBH.D_E_L_E_T_ = ' ' AND ZBH_FILIAL = '" + xFilial("ZBH") + "' AND ZBH_INTSFO = 'P'" + CRLF
	cQryHierar += " UNION ALL" 																																																																															+ CRLF
	cQryHierar += " SELECT ZBI_XIDSFO IDEXTERNAL, 6 TABELA , 'P' || ZBI_DIRETO || 'P' || ZBI_NACION || 'P' || ZBI_TATICA || 'P' || ZBI_REGION || 'P' || ZBI_SUPERV || 'P' || ZBI_CODIGO CODIGO , ZBI_DESCRI DESCRICAO	, ZBI.R_E_C_N_O_ ZBXRECNO FROM " + retSQLName("ZBI") + " ZBI WHERE ZBI.D_E_L_E_T_ = ' ' AND ZBI_FILIAL = '" + xFilial("ZBI") + "' AND ZBI_INTSFO = 'P'"	+ CRLF
	cQryHierar += " ORDER BY TABELA"																																																																													+ CRLF

	conout("[MGFWSC71] [SALESFORCE] [getHierar1] " + cQryHierar)

	tcQuery cQryHierar new alias "QRYWSC71"
return

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
static function getHierar2()
	local cQryHierar	:= ""
	local cPaiDefaul	:= allTrim( superGetMv( "MGFWSC71B" , , "00E1D000000ggnyUAA" ) )

	cQryHierar := ""
	// ZBD - Diretoria
	//cQryHierar += " SELECT 1 TABELA , ZBD_XIDSFO PAPEL, ' ' PAI, ZBD.R_E_C_N_O_ ZBXRECNO"	+ CRLF
	cQryHierar += " SELECT 1 TABELA , ZBD_XIDSFO IDEXTERNAL, '" + cPaiDefaul + "' PAI, ZBD.R_E_C_N_O_ ZBXRECNO, ZBD_DESCRI DESCRICAO, 'P' || ZBD_CODIGO PAPEL"						+ CRLF
	cQryHierar += " FROM " 			+ retSQLName("ZBD") + " ZBD"							+ CRLF
	cQryHierar += " WHERE"																	+ CRLF
	cQryHierar += " 		ZBD.D_E_L_E_T_	=	' '"										+ CRLF
	cQryHierar += " 	AND ZBD_FILIAL		=	'" + xFilial("ZBD") + "'"					+ CRLF
	cQryHierar += " 	AND ZBD_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBD_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " UNION ALL"																+ CRLF
	// ZBE - Nacional
	cQryHierar += " SELECT 2 TABELA , ZBE_XIDSFO IDEXTERNAL, ZBD_XIDSFO PAI, ZBE.R_E_C_N_O_ ZBXRECNO, ZBE_DESCRI DESCRICAO, 'P' || ZBE_DIRETO || 'P' || ZBE_CODIGO PAPEL"						+ CRLF
	cQryHierar += " FROM "			+ retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryHierar += " INNER JOIN "	+ retSQLName("ZBD") + " ZBD"							+ CRLF
	cQryHierar += " ON"																		+ CRLF
	cQryHierar += " 		ZBD.ZBD_CODIGO	=	ZBE.ZBE_DIRETO"								+ CRLF
	cQryHierar += " 	AND	ZBD.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBD_FILIAL		= 	'" + xFilial("ZBD") + "'"					+ CRLF
	cQryHierar += " 	AND ZBD_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " WHERE"																	+ CRLF
	cQryHierar += " 		ZBE.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBE_FILIAL		= 	'" + xFilial("ZBE") + "'"					+ CRLF
	cQryHierar += " 	AND ZBE_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBE_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " UNION ALL"																+ CRLF
	// ZBF - Tatica
	cQryHierar += " SELECT 3 TABELA , ZBF_XIDSFO IDEXTERNAL, ZBE_XIDSFO PAI, ZBF.R_E_C_N_O_ ZBXRECNO, ZBF_DESCRI DESCRICAO, 'P' || ZBF_DIRETO || 'P' || ZBF_NACION || 'P' || ZBF_CODIGO PAPEL"						+ CRLF
	cQryHierar += " FROM "			+ retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryHierar += " INNER JOIN "	+ retSQLName("ZBE") + " ZBE"							+ CRLF
	cQryHierar += "	ON" 																	+ CRLF
	cQryHierar += "			ZBE.ZBE_CODIGO	= 	ZBF.ZBF_NACION" 							+ CRLF
	cQryHierar += "		AND	ZBE.ZBE_DIRETO	= 	ZBF.ZBF_DIRETO" 							+ CRLF
	cQryHierar += " 	AND	ZBE.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBE_FILIAL		= 	'" + xFilial("ZBE") + "'"					+ CRLF
	cQryHierar += " 	AND ZBE_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " WHERE"	 																+ CRLF
	cQryHierar += " 		ZBF.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBF_FILIAL		= 	'" + xFilial("ZBF") + "'"					+ CRLF
	cQryHierar += " 	AND ZBF_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBF_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " UNION ALL"																+ CRLF
	// ZBG - Regional
	cQryHierar += " SELECT 4 TABELA , ZBG_XIDSFO IDEXTERNAL, ZBF_XIDSFO PAI, ZBG.R_E_C_N_O_ ZBXRECNO, ZBG_DESCRI DESCRICAO, 'P' || ZBG_DIRETO || 'P' || ZBG_NACION || 'P' || ZBG_TATICA || 'P' || ZBG_CODIGO PAPEL"						+ CRLF
	cQryHierar += " FROM "			+ retSQLName("ZBG") + " ZBG"							+ CRLF
	cQryHierar += " INNER JOIN "	+ retSQLName("ZBF") + " ZBF"							+ CRLF
	cQryHierar += "	ON" 																	+ CRLF
	cQryHierar += "			ZBF.ZBF_CODIGO	= 	ZBG.ZBG_TATICA" 							+ CRLF
	cQryHierar += "		AND	ZBF.ZBF_NACION	= 	ZBG.ZBG_NACION" 							+ CRLF
	cQryHierar += "		AND	ZBF.ZBF_DIRETO	= 	ZBG.ZBG_DIRETO"								+ CRLF
	cQryHierar += " 	AND	ZBF.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBF_FILIAL		= 	'" + xFilial("ZBF") + "'"					+ CRLF
	cQryHierar += " 	AND ZBF_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += "	WHERE"																	+ CRLF
	cQryHierar += " 		ZBG.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBG_FILIAL		= 	'" + xFilial("ZBG") + "'"					+ CRLF
	cQryHierar += " 	AND ZBG_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBG_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " UNION ALL"																+ CRLF
	// ZBH - Supervisao
	cQryHierar += " SELECT 5 TABELA , ZBH_XIDSFO IDEXTERNAL, ZBG_XIDSFO PAI, ZBH.R_E_C_N_O_ ZBXRECNO, ZBH_DESCRI DESCRICAO, 'P' || ZBH_DIRETO || 'P' || ZBH_NACION || 'P' || ZBH_TATICA || 'P' || ZBH_REGION || 'P' || ZBH_CODIGO PAPEL"						+ CRLF
	cQryHierar += " FROM "			+ retSQLName("ZBH") + " ZBH"							+ CRLF
	cQryHierar += " INNER JOIN "	+ retSQLName("ZBG") + " ZBG"							+ CRLF
	cQryHierar += "	ON"																		+ CRLF
	cQryHierar += "			ZBG.ZBG_CODIGO	= 	ZBH.ZBH_REGION"								+ CRLF
	cQryHierar += "		AND	ZBG.ZBG_TATICA	= 	ZBH.ZBH_TATICA"								+ CRLF
	cQryHierar += "		AND	ZBG.ZBG_NACION	= 	ZBH.ZBH_NACION"								+ CRLF
	cQryHierar += "		AND	ZBG.ZBG_DIRETO	= 	ZBH.ZBH_DIRETO" 							+ CRLF
	cQryHierar += " 	AND	ZBG.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBG_FILIAL		= 	'" + xFilial("ZBG") + "'"					+ CRLF
	cQryHierar += " 	AND ZBG_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " WHERE" 																	+ CRLF
	cQryHierar += " 		ZBH.D_E_L_E_T_	= 	' '" 										+ CRLF
	cQryHierar += " 	AND ZBH_FILIAL		= 	'" + xFilial("ZBH") + "'"					+ CRLF
	cQryHierar += " 	AND ZBH_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBH_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " UNION ALL" 																+ CRLF
	// ZBI - Roteiro

	cQryHierar += " SELECT 6 TABELA , ZBI_XIDSFO IDEXTERNAL, ZBH_XIDSFO PAI, ZBI.R_E_C_N_O_ ZBXRECNO, ZBI_DESCRI DESCRICAO, 'P' || ZBI_DIRETO || 'P' || ZBI_NACION || 'P' || ZBI_TATICA || 'P' || ZBI_REGION || 'P' || ZBI_SUPERV || 'P' || ZBI_CODIGO PAPEL"						+ CRLF
	//cQryHierar += " SELECT 6 TABELA , ZBI_XIDSFO PAPEL, ZBH_XIDSFO PAI, ZBI.R_E_C_N_O_ ZBXRECNO"						+ CRLF
	cQryHierar += " FROM "			+ retSQLName("ZBI") + " ZBI"		 					+ CRLF
	cQryHierar += " INNER JOIN "	+ retSQLName("ZBH") + " ZBH" 							+ CRLF
	cQryHierar += "	ON" 																	+ CRLF
	cQryHierar += " 		ZBI.ZBI_SUPERV	= 	ZBH.ZBH_CODIGO" 							+ CRLF
	cQryHierar += "		AND	ZBI.ZBI_REGION	= 	ZBH.ZBH_REGION"								+ CRLF
	cQryHierar += "		AND	ZBI.ZBI_TATICA	= 	ZBH.ZBH_TATICA"								+ CRLF
	cQryHierar += " 	AND	ZBI.ZBI_NACION	= 	ZBH.ZBH_NACION" 							+ CRLF
	cQryHierar += " 	AND	ZBI.ZBI_DIRETO	= 	ZBH.ZBH_DIRETO" 							+ CRLF
	cQryHierar += " 	AND	ZBI.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBI_FILIAL		= 	'" + xFilial("ZBI") + "'"					+ CRLF
	cQryHierar += " 	AND ZBH_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " WHERE" 																	+ CRLF
	cQryHierar += " 		ZBI.D_E_L_E_T_	= 	' '"										+ CRLF
	cQryHierar += " 	AND ZBI_FILIAL		= 	'" + xFilial("ZBI") + "'"					+ CRLF
	cQryHierar += " 	AND ZBI_XIDSFO		<>	' '"										+ CRLF
	cQryHierar += " 	AND ZBI_INTSFO		=	'P'"										+ CRLF

	cQryHierar += " ORDER BY TABELA"														+ CRLF

	conout("[MGFWSC71] [SALESFORCE] [getHierar2] " + cQryHierar)

	tcQuery cQryHierar new alias "QRYWSC71"
return