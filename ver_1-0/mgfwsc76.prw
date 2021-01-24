#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#Include "XMLXFUN.CH"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} MGFWSC76
Integração com Salesforce Hierarquia de Vendas
@description
Integração de Clientes x Vendedor
@author Rogerio Almeida de Oliveira
@since 12/12/2019
@type Function
@table
 SA1 - Clientes
 SA3 - Vendedores
 ZBJ - Clientes Estrutura de Vendas
@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/

/*/
==============================================================================================================================================================================
{Protheus.doc} JOBWSC76()
Para ser chamado via JOB
@type function
@author Rogerio Almeida
@since 12/12/2019
@version P12
/*/
user function JOBWSC76( cFilJob )

	U_MGFWSC76( { "01" , cFilJob } )

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MNUWSC76()
Para ser chamado via Menu
@type function
@author Rogerio Almeida
@since 12/12/2019
@version P12
/*/
user function MNUWSC76()

	runInteg76()

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSC76()
Executar em Threads
@type function
@author Rogerio Almeida
@since 12/12/2019
@version P12
/*/
user function MGFWSC76( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC76] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg76()

	RESET ENVIRONMENT
return

/*/
==============================================================================================================================================================================
{Protheus.doc} runInteg76()
Rotina de execução da integração
@type function
@author Rogerio Almeida
@since 12/12/2019
@version P12
/*/
static function runInteg76()

	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC76A" , , "http://spdwvapl203:1337/experience/protheus/hierarquia-vendas/api/v1/hierarquias-venda" ) )
	local cHTTPMetho	:= ""
	local cUpdZBJ		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local xRetHttp		:= nil
	local nMaxItens     := 0
	local nCountIten    := 0
    local aJson         := {} //Array de Json
	local oJson	        := nil

	local nI			:= 0

	//Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integração
    local cStaLog		:= "" // Codigo do Status da integração, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC76C"		, , "013" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração

	local cHeadHttp		:= ""

	conout("[SALESFORCE] - MGFWSC76- Selecionando Clientes x Vendedores aptos a integrar com SALESFORCE")

	getRegs( ) // Retornar registros aptos p/ integração

	nMaxItens   := superGetMv( "MGFWSC76B" , , 200 )

	while  !QRYWSC76->(EOF())

		aJson := {}
		oJson := nil
		oJson := JsonObject():new()

		cZBJRecno	:= ""
		nCountIten	:= 0
		while !QRYWSC76->(EOF()) .AND. nCountIten < nMaxItens

			nCountIten++
			cZBJRecno	+= allTrim( str( QRYWSC76->ZBJRECNO ) ) +  ","

			Aadd(aJson,JsonObject():new())

			aJson[nCountIten] ['VENDEDOR']					:= alltrim(QRYWSC76->A3_COD)     //Vendedor
			aJson[nCountIten] ['DIRETORIA_VENDEDOR']		:= alltrim(QRYWSC76->ZBD_REPRES)
			aJson[nCountIten] ['DIRETORIA_DESCRICAO']		:= alltrim(QRYWSC76->ZBD_DESCRI)
			aJson[nCountIten] ['NACIONAL_VENDEDOR']			:= alltrim(QRYWSC76->ZBE_REPRES)
			aJson[nCountIten] ['NACIONAL_DESCRICAO']		:= alltrim(QRYWSC76->ZBE_DESCRI)
			aJson[nCountIten] ['TATICA_VENDEDOR']			:= alltrim(QRYWSC76->ZBF_REPRES)
			aJson[nCountIten] ['TATICA_DECRICAO']			:= alltrim(QRYWSC76->ZBF_DESCRI)
			aJson[nCountIten] ['REGIONAL_VENDEDOR']			:= alltrim(QRYWSC76->ZBG_REPRES)
			aJson[nCountIten] ['REGIONAL_DESCRICAO']		:= alltrim(QRYWSC76->ZBG_DESCRI)
			aJson[nCountIten] ['SUPERVISAO_VENDEDOR']		:= alltrim(QRYWSC76->ZBH_REPRES)
			aJson[nCountIten] ['SUPERVISAO_DESCRICAO']		:= alltrim(QRYWSC76->ZBH_DESCRI)
			aJson[nCountIten] ['ROTEIRO_DESCRICAO']			:= alltrim(QRYWSC76->ZBI_DESCRI) //Papel do Vendedor
			aJson[nCountIten] ['ID_EXTERNAL_CLIENTE']		:= alltrim(QRYWSC76->A1_COD) + alltrim(QRYWSC76->A1_LOJA)
			aJson[nCountIten] ['ID_EXTERNAL_HIERARQUIA']	:= alltrim(QRYWSC76->A1_COD) + alltrim(QRYWSC76->A1_LOJA)  + alltrim(QRYWSC76->A3_COD)
			aJson[nCountIten] ['CHAVE_HIERARQUIA']			:= alltrim(QRYWSC76->ZBD_REPRES) + alltrim(QRYWSC76->ZBE_REPRES) + alltrim(QRYWSC76->ZBF_REPRES) + alltrim(QRYWSC76->ZBG_REPRES) + alltrim(QRYWSC76->ZBH_REPRES) + alltrim(QRYWSC76->A3_COD) //Ultimo nível é o vendedor, poderia ser passado o ZBI_REPRES
			aJson[nCountIten] ["UID"]						:= fwUUIDv4( .T. )
			aJson[nCountIten] ["RECNO"]						:= QRYWSC76->ZBJRECNO
			aJson[nCountIten] ['EXCLUIR']                   := iif( empty( QRYWSC76->ZBJDELETED ), .F., .T.)

			QRYWSC76->(DBSkip())
		enddo

		cJson := fwJsonSerialize(aJson, .T., .T.)  //Serializar o array de Json

		if !empty( cJson )

			cTimeIni	:= time()
			cHTTPMetho	:= "POST"

			//Enviar os dados solicitados no Header
			cIdInteg := ""
			cIdInteg := FWUUIDV4()

			aHeadStr := {}

			aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
			aadd( aHeadStr , 'Content-Type: application/json'  )
			aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

			xRetHttp	:= nil
			xRetHttp	:= httpQuote( cURLInteg /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [SALESFORCE] [MGFWSC76] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC76] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC76] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC76] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC76] URL..........................: " + cURLInteg 								)
			conout(" [SALESFORCE] [MGFWSC76] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC76] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC76] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC76] * * * * * * * * * * * * * * * * * * * * "									)

			varInfo( "xRetHttp" , xRetHttp )

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
			    //Inicializar variáveis.
			    cStaLog  := "1"
				cErroLog := ""
				cUpdZBJ	:= ""

				cUpdZBJ := "UPDATE " + retSQLName("ZBJ")										+ CRLF
				cUpdZBJ += "	SET"															+ CRLF
				cUpdZBJ += "	ZBJ_INTSFO = 'I' "												+ CRLF

				cUpdZBJ += " WHERE"																+ CRLF
				cUpdZBJ += " 		R_E_C_N_O_ IN ("+ left( cZBJRecno , len(cZBJRecno)-1 )+")"  + CRLF

				if tcSQLExec( cUpdZBJ ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					cErroLog := "Não foi possível executar UPDATE. "+ tcSqlError()
					cStaLog  := "2" //Erro
				endif
			else
				cErroLog := "Erro - Integração retornou estatus Http diferente de sucesso!"
				cStaLog := "2"//Erro
			endif

			cHeadHttp := ""

			for nI := 1 to len( aHeadStr )
				cHeadHttp += aHeadStr[ nI ]
			next

			for nI := 1 to len( aJson )
				//GRAVAR LOG
				U_MGFMONITOR(																													 ;
				cFilAnt																			/* Filial */									,;
				cStaLog																			/* Status - 1-Suceso / 2-Erro*/					,;
				cCodInteg																		/* Integração */								,;
				cCodTpInt																		/* Tipo de integração */						,;
				iif( empty( cErroLog ) , "Processamento realizado com sucesso!" , cErroLog )	/*cErro*/										,;
				" "																				/*cDocori*/										,;
				cTimeProc																		/* Tempo de processamento */					,;
				aJson[ nI ]:toJson()															/* JSON */										,;
				aJson[ nI ]["RECNO"]															/* RECNO do registro */							,;
				cValToChar( nStatuHttp )														/* Status HTTP Retornado */						,;
				.F.																				/* Se precisar preparar ambiente enviar .T. */	,;
				{}																				/* Filial para preparar ambiente */				,;
				aJson[ nI ]["UID"]																/* UUID */	     								,;
				iif( type( xRetHttp ) <> "U", xRetHttp, " ")									/* JSON de RETORNO */							,;
				"A"																				/*cTipWsInt*/									,;
				" "																				/*cJsonCB Z1_JSONCB*/							,;
				" "																				/*cJsonRB Z1_JSONRB*/							,;
				sTod("    /  /  ")																/*dDTCallb Z1_DTCALLB*/							,;
				" "																				/*cHoraCall Z1_HRCALLB*/						,;
				" "																				/*cCallBac Z1_CALLBAC*/							,;
				cURLInteg																		/*cLinkEnv Z1_LINKENV*/							,;
				" "																				/*cLinkRec Z1_LINKREC*/							,;
				cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
				cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
			next
		endif

	enddo
	QRYWSC76->(DBCloseArea())
	delClassINTF()
return

/*/
==============================================================================================================================================================================
{Protheus.doc} getRegs()
Seleciona os registros para exportação
@type function
@author Rogerio Almeida
@since 13/12/2019
@version P12
/*/
static function getRegs( )
	local cQRYWSC76 := ""

	cQRYWSC76 += "SELECT "															+ CRLF
	cQRYWSC76 += "ZBD_REPRES, "														+ CRLF
	cQRYWSC76 += "ZBD_DESCRI, "														+ CRLF
	cQRYWSC76 += "ZBE_REPRES,  "													+ CRLF
	cQRYWSC76 += "ZBE_DESCRI, "														+ CRLF
	cQRYWSC76 += "ZBF_REPRES,  "													+ CRLF
	cQRYWSC76 += "ZBF_DESCRI,  "													+ CRLF
	cQRYWSC76 += "ZBG_REPRES, "													    + CRLF
	cQRYWSC76 += "ZBG_DESCRI,  "													+ CRLF
	cQRYWSC76 += "ZBH_REPRES,  "													+ CRLF
    cQRYWSC76 += "ZBH_DESCRI,  "													+ CRLF
	cQRYWSC76 += "ZBI_REPRES,  "													+ CRLF
	cQRYWSC76 += "ZBI_DESCRI,  "													+ CRLF
	cQRYWSC76 += "A1_COD, "													        + CRLF
	cQRYWSC76 += "A1_LOJA, "												        + CRLF
	cQRYWSC76 += "A3_COD, " 													    + CRLF
	cQRYWSC76 += "A3_NOME, "													    + CRLF
	cQRYWSC76 += "A1_LOJA, "													    + CRLF
	cQRYWSC76 += "ZBJ.R_E_C_N_O_ ZBJRECNO, " 									    + CRLF
	cQRYWSC76 += "ZBJ.D_E_L_E_T_ ZBJDELETED " 									    + CRLF
	cQRYWSC76 += "FROM  "	+ retSQLName("ZBD")+ " ZBD " /*--DIRETORIA*/			+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBE")+ " ZBE " /*--NACIONAL*/  			+ CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "    ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO "    			                + CRLF
	cQRYWSC76 += "AND ZBE.ZBE_FILIAL =	'" + xFilial("ZBE") + "'"					+ CRLF
	cQRYWSC76 += "AND ZBE.D_E_L_E_T_ <> '*' "									    + CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBF")+ " ZBF " /*--TATICA*/				+ CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "    ZBE.ZBE_CODIGO = ZBF.ZBF_NACION "							    + CRLF
	cQRYWSC76 += "AND ZBE.ZBE_DIRETO = ZBF.ZBF_DIRETO "								+ CRLF
	cQRYWSC76 += "AND ZBF.ZBF_FILIAL = '" + xFilial("ZBF") + "'"					+ CRLF
	cQRYWSC76 += "AND ZBF.D_E_L_E_T_ <> '*' "								    	+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBG")+ " ZBG " /*--REGIONAL*/           + CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "      ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA"							+ CRLF
	cQRYWSC76 += "AND	ZBF.ZBF_NACION = ZBG.ZBG_NACION"							+ CRLF
	cQRYWSC76 += "AND	ZBF.ZBF_DIRETO = ZBG.ZBG_DIRETO" 							+ CRLF
	cQRYWSC76 += "AND ZBG.ZBG_FILIAL = '" + xFilial("ZBG") + "'"					+ CRLF
	cQRYWSC76 += "AND ZBG.D_E_L_E_T_ <> '*' "										+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBH")+ " ZBH" /*--SUPERVISAO*/		    + CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "      ZBG.ZBG_CODIGO = ZBH.ZBH_REGION " 							+ CRLF
	cQRYWSC76 += "AND	ZBG.ZBG_TATICA = ZBH.ZBH_TATICA "							+ CRLF
	cQRYWSC76 += "AND	ZBG.ZBG_NACION = ZBH.ZBH_NACION "							+ CRLF
	cQRYWSC76 += "AND	ZBG.ZBG_DIRETO = ZBH.ZBH_DIRETO "							+ CRLF
	cQRYWSC76 += "AND ZBH.ZBH_FILIAL = '" + xFilial("ZBH") + "'"					+ CRLF
	cQRYWSC76 += "AND ZBH.D_E_L_E_T_ <> '*' "										+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBI")+ " ZBI" /*--ROTEIRO*/             + CRLF
	cQRYWSC76 += "ON"                  												+ CRLF
	cQRYWSC76 += "      ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV "							+ CRLF
	cQRYWSC76 += "AND	ZBH.ZBH_REGION = ZBI.ZBI_REGION "							+ CRLF
	cQRYWSC76 += "AND	ZBH.ZBH_TATICA = ZBI.ZBI_TATICA "							+ CRLF
	cQRYWSC76 += "AND	ZBH.ZBH_NACION = ZBI.ZBI_NACION "							+ CRLF
	cQRYWSC76 += "AND	ZBH.ZBH_DIRETO = ZBI.ZBI_DIRETO "							+ CRLF
	cQRYWSC76 += "AND ZBI.ZBI_FILIAL = '" + xFilial("ZBI") + "'"					+ CRLF
	cQRYWSC76 += "AND ZBI.D_E_L_E_T_ <> '*' "										+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("ZBJ")+ " ZBJ"/*--CLI EST DE VENDAS*/    + CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "      ZBI.ZBI_CODIGO = ZBJ.ZBJ_ROTEIR "					        + CRLF
	cQRYWSC76 += "AND	ZBI.ZBI_SUPERV = ZBJ.ZBJ_SUPERV "							+ CRLF
	cQRYWSC76 += "AND	ZBI.ZBI_REGION = ZBJ.ZBJ_REGION "							+ CRLF
	cQRYWSC76 += "AND	ZBI.ZBI_TATICA = ZBJ.ZBJ_TATICA "							+ CRLF
	cQRYWSC76 += "AND	ZBI.ZBI_NACION = ZBJ.ZBJ_NACION "							+ CRLF
	cQRYWSC76 += "AND	ZBI.ZBI_DIRETO = ZBJ.ZBJ_DIRETO "							+ CRLF
	cQRYWSC76 += "AND ZBJ.ZBJ_FILIAL   = '" + xFilial("ZBJ") + "'"					+ CRLF
	// cQRYWSC76 += "AND ZBJ.D_E_L_E_T_ <> '*' "										+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("SA1")+ "  SA1" /*--CLIENTES*/           + CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "    SA1.A1_XIDSFOR  <> ' ' " /*--Somente integrados c/ Salesforce*/+ CRLF
	cQRYWSC76 += "AND SA1.A1_LOJA     =  ZBJ.ZBJ_LOJA "								+ CRLF
	cQRYWSC76 += "AND SA1.A1_COD      =  ZBJ.ZBJ_CLIENT " 							+ CRLF
	cQRYWSC76 += "AND SA1.A1_FILIAL   = '" + xFilial("SA1") + "'"					+ CRLF
	cQRYWSC76 += "AND SA1.D_E_L_E_T_  <> '*' " 										+ CRLF

	cQRYWSC76 += "INNER JOIN "+ retSQLName("SA3")+ " SA3" /*--VENDEDORES*/			+ CRLF
	cQRYWSC76 += "ON"																+ CRLF
	cQRYWSC76 += "    SA3.A3_XINTSFO  =	'I' " /*--Somente integrados c/ Salesforce*/+ CRLF
	cQRYWSC76 += "AND SA3.A3_COD      = ZBJ.ZBJ_REPRES "							+ CRLF
	cQRYWSC76 += "AND SA3.A3_FILIAL   = '" + xFilial("SA3") + "'"					+ CRLF
	cQRYWSC76 += "AND SA3.D_E_L_E_T_ <> '*' "										+ CRLF
	cQRYWSC76 += "WHERE "															+ CRLF
	cQRYWSC76 += "ZBJ.ZBJ_INTSFO   = 'P' "	    								    + CRLF
	cQRYWSC76 += "AND SA1.A1_EST  != 'EX' "											+ CRLF //WVN 09/11/2020
	cQRYWSC76 += "AND ZBD.ZBD_FILIAL  	  = '" + xFilial("ZBD") + "'"				+ CRLF
	cQRYWSC76 += "AND ZBD.D_E_L_E_T_ <> '*' "                                       + CRLF
	cQRYWSC76 += "ORDER BY SA3.A3_COD, SA1.A1_COD, SA1.A1_LOJA, ZBJDELETED DESC "	+ CRLF

	conout("[MGFWSC76] [SALESFORCE] " + cQRYWSC76)

	tcQuery cQRYWSC76 New Alias "QRYWSC76"
return

