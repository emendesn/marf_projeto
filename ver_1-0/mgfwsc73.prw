#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )
/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSC73
IntegraÁ„o de Produtos Protheus x Selasforce

@description
Web Service de integraÁ„o de Produtos do Protheus com Salesforce
Consumido pelo Barramento para realizar a integraÁ„o.

@author Rogerio Almeida de Oliveira
@since 04/11/2019
@type Function

@table
    SB1 - Cadastro de Produtos
    ZC9 - Marca Comercial
    ZDA - Cadastro de Origem, etc.
@param
    N„o se aplica.
@return
    N„o se aplica.
@menu
    N„o se aplica.
@history
     04/11/2019 - CriaÁ„o da estrutura do Web Services
     07/11/2019 - CriaÁ„o da query que verifica a integraÁ„o do produto.
     10/12/2019 - Inclus„o de campo novo na query B1_XDCOMER, ajuste no filtro.
/*/

/*/
==============================================================================================================================================================================
{Protheus.doc} JOBWSC73()
Para ser chamado via JOB
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
user function JOBWSC73( cFilJob )

	U_MGFWSC73( { "01" , cFilJob } )

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MNUWSC73()
Para ser chamado em MENU
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
user function MNUWSC73()

	runInteg73()

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSC73()
Executar em Threads
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
user function MGFWSC73( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC73] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg73()

	RESET ENVIRONMENT
return

/*/
==============================================================================================================================================================================
{Protheus.doc} runInteg73()
Rotina de execuÁ„o da integraÁ„o
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
static function runInteg73( )

	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC73A" , , "https://spdwvapl203/processo-produto/api/v1/produtos/{id}" ) )
	local cURLUse		:= ""
	local cUpdSB1		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	 //Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integra??o.
	local cStaLog		:= "" // Codigo do Status da integraÁ„o, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de integraÁ„o
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC73C" , , "007" ) )//Cod. de busca na SZ3, Tabela Tipo de integraÁ„o --36

	local cHTTPRet		:= ""
	local xRetHttp		:= nil

	local cHeadHttp		:= ""

	private oJson		:= nil

	conout("[SALESFORCE] - MGFWSC73- Selecionando produtos aptos a integrar com SALESFORCE")

	loadProd() //Carregar os produtos aptos p/ integrar

	while !QRYSB1->(EOF())
        cIdInteg := ""
		cIdInteg := FWUUIDV4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := JsonObject():new()

		setJson()// Set produto atual

		cHttpMetho  := ""
		cURLUse	    := ""
		cJson	    := ""
		cJson	    := oJson:toJson()

		if !empty( cJson )

			cTimeIni := time()

			if QRYSB1->B1_XSTATSF == "S"

				cHttpMetho	:= "PATCH"
				cURLUse	    := strTran( cURLInteg , "{id}" , allTrim(QRYSB1->B1_COD ) )//AlteraÁ„o
			else
				cHttpMetho	:= "POST"
				cURLUse	:= strTran( cURLInteg , "/{id}" , "" ) //Inclus„o n„o enviar o B1_COD na URL, eliminar a tag {id}
			endif

			xRetHttp	:= nil
			xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHttpMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			nStatuHttp	:= 0
			nStatuHttp	:= 	httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [SALESFORCE] [MGFWSC73] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC73] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC73] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC73] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC73] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC73] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC73] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC73] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC73] Retorno......................: " + cHTTPRet 								)
			conout(" [SALESFORCE] [MGFWSC73] * * * * * * * * * * * * * * * * * * * * "									)

			varInfo( "xRetHttp" , xRetHttp )

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cStaLog  := "1"
				cErroLog := ""
				cUpdSB1	:= ""

				cUpdSB1 := "UPDATE " + retSQLName("SB1")										+ CRLF
				cUpdSB1 += "	SET"															+ CRLF
				cUpdSB1 += "	B1_XINTSFO = 'I' "												+ CRLF

				if cHttpMetho == "POST"
					cUpdSB1 +=	",	B1_XSTATSF = 'S' "                                          + CRLF
				endif

				cUpdSB1 += " WHERE"																+ CRLF
				cUpdSB1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSB1->SB1RECNO ) ) + ""	+ CRLF

				if tcSQLExec( cUpdSB1 ) < 0
					conout("N„o foi possÌvel executar UPDATE." + CRLF + tcSqlError())
					cErroLog := "N„o foi possÌvel executar UPDATE. " + tcSqlError()
					cStaLog  := "2" //Erro
				endif
			else
				cErroLog := "Erro - IntegraÁ„o retornou estatus Http diferente de sucesso!"
				cStaLog := "2"//Erro
			endif
		endif

		cHeadHttp := ""

		for nI := 1 to len( aHeadStr )
			cHeadHttp += aHeadStr[ nI ]
		next

		//GRAVAR LOG
		U_MGFMONITOR(							 ;
		cFilAnt	/*cFil*/		        		,;
		cStaLog /*cStatus*/		        		,;
		cCodInteg /*cCodint Z1_INTEGRA*/		,;
		cCodTpInt /*cCodtpint Z1_TPINTEG*/  	,;
		Iif(EMPTY(cErroLog),"Processamento realizado com sucesso!",cErroLog) /*cErro*/,;
		" " /*cDocori*/	         ,;
		cTimeProc	/*cTempo*/	 ,;
		cJson /*cJSON*/		     ,;
		QRYSB1->SB1RECNO /*nRecnoDoc*/,;
		cValToChar(nStatuHttp) /*cHTTP*/,;
		.F./*lJob*/		           ,;
		{}/*aFil*/		           ,;
		cIdInteg/*cUUID*/	       ,;
		iif(TYPE(xRetHttp) <> "U", xRetHttp, " ")/*cJsonR*/,;
		"S"/*cTipWsInt*/           ,;
		" "/*cJsonCB /*Z1_JSONCB*/ ,;
		" "/*cJsonRB /*Z1_JSONRB*/ ,;
		sTod("    /  /  ") /*dDTCallb /*Z1_DTCALLB*/,;
		" "/*cHoraCall /*Z1_HRCALLB*/,;
		" "/*cCallBac /*Z1_CALLBAC*/,;
		cURLUse /*cLinkEnv /*Z1_LINKENV*/,;
		" "																				/*cLinkRec Z1_LINKREC*/							,;
		cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
		cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)

		freeObj( oJson )

		QRYSB1->(DBSkip())
	enddo

	QRYSB1->(DBCloseArea())

	delClassINTF()
return

/*/
==============================================================================================================================================================================
{Protheus.doc} loadProd()
Seleciona os produtos para exportaÁ„o
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
static function loadProd()
	Local lFilQry	:= superGetMv( "MGFWSC73D" , , .T.)
	Local cTipoSB1	:= allTrim( superGetMv( "MGFWSC73E" , , "'PP', 'ME' , 'PA'") )
	Local cQrySB1	:= ""

	cQrySB1 := "SELECT "														+ CRLF
	cQrySB1 += " B1_XSTATSF, "      											+ CRLF //Status Salesforce S=SIM;N=NùO
	cQrySB1 += " B1_COD, "      												+ CRLF
	cQrySB1 += " B1_DESC, "     												+ CRLF
	cQrySB1 += " B1_MSBLQL, "  						    						+ CRLF
	cQrySB1 += " B1_POSIPI, "													+ CRLF
	cQrySB1 += " YD_DESC_P, "													+ CRLF// --Ref
	cQrySB1 += " B1_ZCONSER, "													+ CRLF
	cQrySB1 += " B1_ZEAN13, "													+ CRLF
	cQrySB1 += " B1_ZMESES, "													+ CRLF
	cQrySB1 += " B1_ZVLDPR, "													+ CRLF
	cQrySB1 += " B1_ZCCATEG, "													+ CRLF
	cQrySB1 += " B1_ZMARCAC, "													+ CRLF
	cQrySB1 += " ZC9_DESCRI, "													+ CRLF//--Ref
	cQrySB1 += " B1_ZORIGEM, "													+ CRLF
	cQrySB1 += " ZDA_DESCR, "													+ CRLF// --Ref
	cQrySB1 += " B1_ZGRUPO, "													+ CRLF
	cQrySB1 += " ZDB_DESCR, "													+ CRLF// --Ref
	cQrySB1 += " B1_ZSUBGRP, "													+ CRLF
	cQrySB1 += " ZDC_DESCR,"													+ CRLF// --Ref
	cQrySB1 += " B1_ZFAMILI, "													+ CRLF
	cQrySB1 += " ZDD_DESCR, "													+ CRLF// --Ref
	cQrySB1 += " B1_ZGERENC, "													+ CRLF
	cQrySB1 += " B1_ZNEGOC, "													+ CRLF
	cQrySB1 += " ZDF_DESCR, "													+ CRLF// --Ref
	cQrySB1 += " B1_ZCARCAC, "													+ CRLF
	cQrySB1 += " ZDG_DESCR, "													+ CRLF// --Ref
	cQrySB1 += " B1_XDCOMER, "													+ CRLF// --Ref
	cQrySB1 += " B1_TIPO					,"									+ CRLF// --Ref
	cQrySB1 += " X5_DESCRI		TIPO_DESC	,"									+ CRLF// --Ref
	cQrySB1 += " SB1.R_E_C_N_O_	SB1RECNO"										+ CRLF
	cQrySB1 += " FROM "			+ retSQLName("SB1") + " SB1"					+ CRLF

	cQrySB1 += " LEFT JOIN  "	+ retSQLName("SX5") + " SX5"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += "         SX5.X5_CHAVE    =   SB1.B1_TIPO"						+ CRLF
	cQrySB1 += "     AND SX5.X5_TABELA   =   '02'"								+ CRLF
	cQrySB1 += "     AND SX5.X5_FILIAL   =   '" + xFilial("SX5") + "'"								+ CRLF
	cQrySB1 += "     AND SX5.D_E_L_E_T_  =   ' '"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZC9") + " ZC9"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZC9.ZC9_CODIGO	=	SB1.B1_ZMARCAC"						+ CRLF
	cQrySB1 += " 	AND	ZC9.ZC9_FILIAL	=	'" + xFilial("ZC9") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZC9.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDA") + " ZDA"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDA.ZDA_COD		=	SB1.B1_ZORIGEM"						+ CRLF
	cQrySB1 += " 	AND	ZDA.ZDA_FILIAL	=	'" + xFilial("ZDA") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDA.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("SYD") + " SYD"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		SYD.YD_TEC		=	SB1.B1_POSIPI "						+ CRLF
	cQrySB1 += " 	AND	SYD.YD_FILIAL	=	'" + xFilial("SYD") + "'"			+ CRLF
	cQrySB1 += " 	AND	SYD.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDG") + " ZDG"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDG.ZDG_COD		=	SB1.B1_ZCARCAC"						+ CRLF
	cQrySB1 += " 	AND	ZDG.ZDG_FILIAL	=	'" + xFilial("ZDG") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDG.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDB") + " ZDB"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDB.ZDB_COD		=	SB1.B1_ZGRUPO"						+ CRLF
	cQrySB1 += " 	AND	ZDB.ZDB_FILIAL	=	'" + xFilial("ZDB") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDB.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDC") + " ZDC"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDC.ZDC_COD		=	SB1.B1_ZSUBGRP"						+ CRLF
	cQrySB1 += " 	AND	ZDC.ZDC_FILIAL	=	'" + xFilial("ZDC") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDC.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDD") + " ZDD"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDD.ZDD_COD		=	SB1.B1_ZFAMILI"						+ CRLF
	cQrySB1 += " 	AND	ZDD.ZDD_FILIAL	=	'" + xFilial("ZDD") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDD.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDF") + " ZDF"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDF.ZDF_COD		=	SB1.B1_ZNEGOC"						+ CRLF
	cQrySB1 += " 	AND	ZDF.ZDF_FILIAL	=	'" + xFilial("ZDF") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDF.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " WHERE"															+ CRLF
  //cQrySB1 += " 		SB1.B1_XINTECO	=	'0'"								+ CRLF // Integrado E-Commerce	-> 0=Nao;1=Sim
	cQrySB1 += " 		SB1.B1_XINTSFO	=	'P'"								+ CRLF // Integrado Salesforce	-> P=Pendente;I=Integrado;E=Erro
 //cQrySB1 += " 	AND	SB1.B1_XENVECO	=	'1'"								+ CRLF // Envia E-Commerce		-> 0=Nao;1=Sim
    cQrySB1 += " 	AND	SB1.B1_XENVSFO	=	'S'"								+ CRLF // Envia Salesforce		-> N=Nao;S=Sim

	if lFilQry //Se .T. filtrar produtos menores que 500.000
		cQrySB1 += " 	AND	SB1.B1_COD		<	'500000'"						+ CRLF // Produtos acima de 500mil nao serao integrados
	endif

	if !empty( cTipoSB1 )
		cQrySB1 += " 	AND	SB1.B1_TIPO IN (" + cTipoSB1 + ")"					+ CRLF
	endif

	cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"			+ CRLF
	cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"								+ CRLF

	conout("[MGFWSC73] [SALES] " + cQrySB1)

	tcQuery cQrySB1 New Alias "QRYSB1"
return

/*/
==============================================================================================================================================================================
{Protheus.doc} loadProd()
Carrega o produtoo
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
static function setJson()

	if QRYSB1->B1_XSTATSF <> "S"       //Diferente de "S" Inclus„o, envio no Body
		oJson["id"	]				:= allTrim( QRYSB1->B1_COD	)
	endif

	oJson["descricao"	]			:= encodPro(allTrim( QRYSB1->B1_DESC) )
	oJson["descricaoComercial"	]	:= encodPro(allTrim(QRYSB1->B1_XDCOMER) )
	oJson["ativo"	]			    := iif( QRYSB1->B1_MSBLQL == "2", .T. , .F. )
	oJson["sistemaOrigem"	]	    := allTrim("Protheus")
	oJson["EAN13"	]	            := IIF(QRYSB1->B1_ZEAN13 == 0,"",Alltrim(cValToChar(QRYSB1->B1_ZEAN13))) //Campo String no barramento, solicitado convers„o 10/12/19

	//TIPO
	oJsonTipo := nil
	oJsonTipo := JsonObject():new()
	oJsonTipo["id"	]	    	    := allTrim( QRYSB1->B1_TIPO		)
	oJsonTipo["descricao"	]   	:= allTrim( QRYSB1->TIPO_DESC	)
	oJson["tipo" ]                	:= oJsonTipo

	//ORIGEM
	oJsonOrigem := nil
	oJsonOrigem := JsonObject():new()
	oJsonOrigem["id"	]	        := allTrim( QRYSB1->B1_ZORIGEM )
	oJsonOrigem["descricao"	]   	:= allTrim( QRYSB1->ZDA_DESCR )
	oJson["origem" ]                := oJsonOrigem

	//CONSERVACAO
	oJsonConservacao := nil
	oJsonConservacao := JsonObject():new()
	oJsonConservacao["descricao" ]	:= allTrim(xDescTipo(allTrim( QRYSB1->B1_ZCONSER),"B1_ZCONSER","")) // 0=Outros;1=Resfriado;2=Congelado;3=In Natura
	oJson["conservacao" ]           := oJsonConservacao

	//VIDAUTIL
	oJasonVidaUtil := nil
	oJasonVidaUtil := JsonObject():new()
	oJasonVidaUtil["quantidade" ]   := QRYSB1->B1_ZVLDPR
	oJasonVidaUtil["unidade" ]      := allTrim(xDescTipo(allTrim(QRYSB1->B1_ZMESES),"B1_ZMESES",""))  //1=Dias;2=Meses;3=Anos
	oJson["vidaUtil" ] 		        := oJasonVidaUtil

	//NCM
	oJsonNCM := nil
	oJsonNCM := JsonObject():new()
	oJsonNCM["codigo"]              := allTrim( QRYSB1->B1_POSIPI )
	oJsonNCM["descricao"]           := allTrim( QRYSB1->YD_DESC_P )
	oJson["NCM"]                    := oJsonNCM

	//FAMILIA
	oJsonFamilia := nil
	oJsonFamilia := JsonObject():new()
	oJsonFamilia["id"	]			:= allTrim( QRYSB1->B1_ZFAMILI )
	oJsonFamilia["descricao" ]		:= allTrim( QRYSB1->ZDD_DESCR )
	oJson["familia"]                := oJsonFamilia

	//NEGOCIO
	oJsonNegocio := nil
	oJsonNegocio := JsonObject():new()
	oJsonNegocio["id"	]	        := allTrim( QRYSB1->B1_ZNEGOC )
	oJsonNegocio["descricao" ]	    := allTrim( QRYSB1->ZDF_DESCR )
    oJson["negocio"]                := oJsonNegocio

	//MARCA
	oJsonMarca := nil
	oJsonMarca := JsonObject():new()
	oJsonMarca["id"	]	            := allTrim( QRYSB1->B1_ZMARCAC )
	oJsonMarca["descricao"	]	    := allTrim( QRYSB1->ZC9_DESCRI )
	oJson["marca"]                  := oJsonMarca

	//GRUPO
	oJsonGrupo := nil
	oJsonGrupo := JsonObject():new()
	oJsonGrupo["id"	]	            := allTrim( QRYSB1->B1_ZGRUPO  )
	oJsonGrupo["descricao"	]	    := allTrim( QRYSB1->ZDB_DESCR  )
	oJson["grupo"]                  := oJsonGrupo

	//SUBGRUPO
	oJsonSubgrupo := nil
	oJsonSubgrupo := JsonObject():new()
	oJsonSubgrupo["id"	]			:= allTrim( QRYSB1->B1_ZSUBGRP )
	oJsonSubgrupo["descricao"	]	:= allTrim( QRYSB1->ZDC_DESCR)
	oJson["subgrupo"]               := oJsonSubgrupo

return

/*/
==============================================================================================================================================================================
{Protheus.doc} loadProd()
Carrega o Descritivo de acordo com a regra
@type function
@author Rogerio Almeida
@since 04/11/2019
@version P12
/*/
Static Function xDescTipo(cChave, cCampo, cConteudo)
    Local aArea       := GetArea()
    Local aCombo      := {}
    Local nAtual      := 1
    Local cDescri     := ""
    Default cChave    := ""
    Default cCampo    := ""
    Default cConteudo := ""

    //Se o campo e o conte˙do estiverem em branco, ou a chave estiver em branco, n„o h· descriÁ„o a retornar
    If (Empty(cCampo) .And. Empty(cConteudo)) .Or. Empty(cChave)
        cDescri := ""
    Else
        //Se tiver campo
        If !Empty(cCampo)
            aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

            //Percorre as posiÁıes do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descriÁ„o
                If cChave == aCombo[nAtual][2]
                    cDescri := aCombo[nAtual][3]
                EndIf
            Next

        //Se tiver conte˙do
        ElseIf !Empty(cConteudo)
            aCombo := StrTokArr(cConteudo, ';')

            //Percorre as posiÁıes do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descriÁ„o
                If cChave == SubStr(aCombo[nAtual], 1, At('=', aCombo[nAtual])-1)
                    cDescri := SubStr(aCombo[nAtual], At('=', aCombo[nAtual])+1, Len(aCombo[nAtual]))
                EndIf
            Next
        EndIf
    EndIf

    RestArea(aArea)
Return cDescri


/*/
==============================================================================================================================================================================
{Protheus.doc} encodPro()
Realiza a formataÁ„o correta para caracteres Especiais
@type function
@author Rogerio Almeida
@since 06/02/2020
@version P12
/*/
Static Function encodPro(cStrPro)
	Local nQtdMemo := 0
	Local cDesc    := ""

    if !empty(cStrPro)
    	nQtdMemo := mlCount(cStrPro)

		for nI :=1 to nQtdMemo
			cDesc += encodeUTF8( memoLine(cStrPro, , nI ) )
		next
	endif

Return cDesc