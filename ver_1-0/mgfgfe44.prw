#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE44	
Autor....:              Rafael Garcia
Data.....:              02/04/2019
Descricao / Objetivo:   Integracao PROTHEUS x MultiEmbarcador
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2 - envio cancelamento
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS para Integracao de dados - envio cancelamento
=====================================================================================
*/

//Chamada multifiliais
User Function mGFE44()

Local _afiliais := {}
Local _cfiliais := ""
Local _ni := 1

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'


conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC44] Iniciada execução multifiliais de cancelamento CTE para barramento - ' +  dToC(dDataBase) + " - " + time())

_cfiliais := supergetmv("MV_GFE44FIL",,"010002,010003,010005,010007,010012,010013,010015,010016,010041,010042,010043,010044,010045,010048,010050,010053,010054,010056,010059,010063,010064,010066,010067,010068")
_afiliais := strtokarr2(_cfiliais,",")

Do while _ni <= len(_afiliais)
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC44]] ------------------------------------------------------------------------------------------------------------------------')
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC44]] Iniciando execução de cancelamento CTE para barramento para filial ' + _afiliais[_ni] + ' - ' +  dToC(dDataBase) + " - " + time())
	cfilant := _afiliais[_ni]
	cempant := substr(_afiliais[_ni],1,2)
	runInteg44()
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC44]] Completou execução de cancelamento CTE para barramento para filial ' + _afiliais[_ni] + ' - ' +  dToC(dDataBase) + " - " + time())
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC44]] ------------------------------------------------------------------------------------------------------------------------')
	_ni++

Enddo

RESET ENVIRONMENT


Return

//Chamada via Menu
user function XWSGFE44()

	runInteg44()

Return 

//-------------------------------------------------------------------
// Chamada via Schedule
user function MGFGFE44(cPar1,cPar2 )


	PREPARE ENVIRONMENT EMPRESA cPar1 FILIAL cPar2

	conout('[MGFWSC44] Iniciada Threads para a empresa' + allTrim(cPar2 ) + ' - ' + dToC(dDataBase) + " - " + time())

	runInteg44()

	RESET ENVIRONMENT

return

//-------------------------------------------------------------------
static function runInteg44()
	local cURLPost			:= allTrim(getMv("MGF_GFE44"))
	local cURL			:= ""		
	local cJson 		:= ""
	local aHeadOut		:= {}
	local nTimeOut		:= 120		
	local xPostRet		:= ""	
	local nStatuHttp	:= 0
	local cHeadRet		:= ""
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cQuery :=" "

	QWSGFE44() // CRIAR FUNCAO QUE RETORNA A QUERY DOS REGISTRO

	aadd( aHeadOut, 'Content-Type: application/json')

	while !QRYDAI->(EOF()) 

		cJson := '{"ProtocoloIntegracaoCarga":"'+ alltrim(QRYDAI->DAI_XPROTO)+'",'
		cJson += '"MotivoDoCancelamento":"Cancelamento da NF '+alltrim(QRYDAI->DAI_NFISCA)+' serie '+alltrim(QRYDAI->DAI_SERIE)+'",'
		cJson += '"UsuarioERPSolicitouCancelamento":"'+alltrim(QRYDAI->DAI_XUCANC)+'",'
		cJson += '"Filial":"'+QRYDAI->DAK_FILIAL+'"}'

		cURL:=strTran( cURLPost, "{NumeroOrdemEmbarque}",ALLTRIM(QRYDAI->DAI_COD) )
		cURL:=strTran( cURL, "{NumeroPedido}", ALLTRIM(QRYDAI->DAI_PEDIDO) )
		cTimeIni := time()
		xPostRet := httpQuote( cURL /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		conout(" [MGFGFE44] * * * * * Status da integracao * * * * *")
		conout(" [MGFGFE44] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [MGFGFE44] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [MGFGFE44] Tempo de Processamento.......: " + cTimeProc )
		conout(" [MGFGFE44] URL..........................: " + cURL)
		conout(" [MGFGFE44] HTTP Method..................: " + "POST" )
		conout(" [MGFGFE44] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [MGFGFE44] Envio........................: " + allTrim( cJson ) )
		conout(" [MGFGFE44] Retorno......................: " + allTrim( xPostRet ) )
		conout(" [MGFGFE44] * * * * * * * * * * * * * * * * * * * * ")

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
	
			cQuery := " UPDATE " + RetSqlname("DAK") + " "
			cQuery += " SET 	DAK_XINTME = 'P',"
			cQuery += " DAK_XOPEME = 'C'"
			cQuery += " WHERE DAK_FILIAL = '" + QRYDAI->DAK_FILIAL + "' "
			cQuery += "	AND DAK_XOEREF = '" + QRYDAI->DAI_COD + "' "
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQuery)

			cQuery := " UPDATE " + RetSqlname("DAI") 
			cQuery += " SET 	DAI_XINTME = 'P',"
			cQuery += " DAI_XOPEME = 'C'"
			cQuery += " WHERE DAI_FILIAL = '" + QRYDAI->DAK_FILIAL + "' "
			cQuery += " AND DAI_COD IN ( SELECT DISTINCT(DAI.DAI_COD) "	
			cQuery += " FROM "+retSQLName("DAI")+" DAI"
			cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
			cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
			cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
			cQuery += " AND DAK.D_E_L_E_T_      <>  '*'"					+CRLF	
			cQuery += " WHERE DAI.DAI_FILIAL = '" + QRYDAI->DAK_FILIAL + "' "
			cQuery += "	AND DAK.DAK_XOEREF = '" + QRYDAI->DAI_COD + "' "
			cQuery += "	AND DAI.D_E_L_E_T_ <> '*' )"
			cQuery += "	AND D_E_L_E_T_ <> '*' "			
			TcSqlExec(cQuery)
			QRYDAI->(DBSKIP())
		ENDIF

	

		QRYDAI->(DBSKIP())

	enddo
	IF SELECT("QRYDAI") > 0
		QRYDAI->( dbCloseArea() )
	ENDIF   

return

//-------------------------------------------------------------------
// Seleciona Notas a serem enviadas
//-------------------------------------------------------------------
static function QWSGFE44()

	local cQry := ""

	cQry := " select DAK.DAK_FILIAL,"							+CRLF
	cQry += " DAI.DAI_XPROTO, "									+CRLF	
	cQry += " DAI.DAI_NFISCA, "									+CRLF
	cQry += " DAI.DAI_SERIE, "									+CRLF
	cQry += " DAI.DAI_COD, "									+CRLF
	cQry += " DAI.DAI_PEDIDO, "									+CRLF		
	cQry += " DAI_XUCANC "										+CRLF		
	cQry += " FROM "+retSQLName("DAK")+" DAK"					+CRLF
	cQry += " INNER JOIN  "+retSQLName("DAI")+" DAI"			+CRLF	
	cQry += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQry += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
	cQry += " AND DAK.D_E_L_E_T_      <>  '*'"					+CRLF	
	cQry += " INNER JOIN "+ retSQLName("SF2") +" SF2"			+CRLF
	cQry += " ON DAI.DAI_NFISCA=SF2.F2_DOC"						+CRLF
	cQry += " AND DAI.DAI_SERIE= SF2.F2_SERIE"					+CRLF
	cQry += " AND SF2.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"					+CRLF
	cQry += " AND SF2.F2_XSTCANC='S'"							+CRLF
	cQry += " WHERE	"											+CRLF
	cQry += " DAI.DAI_XPROTO <> ' ' "							+CRLF
	cQry += " AND DAI.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND DAI.DAI_XINTME =' '"							+CRLF	
	cQry += " AND DAI.DAI_XOPEME ='C'"							+CRLF
	cQry += " AND DAK.DAK_FILIAL ='"+XFILIAL("DAK")+"'"			+CRLF

	IF SELECT("QRYDAI") > 0
		QRYDAI->( dbCloseArea() )
	ENDIF   
	TcQuery changeQuery(cQry) New Alias "QRYDAI"
return


