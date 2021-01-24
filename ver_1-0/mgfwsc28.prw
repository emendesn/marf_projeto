#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
	INTEGRACAO E-COMMERCE
	PESO MEDIO
*/

//-------------------------------------------------------------------
// Para ser chamado em JOB
//-------------------------------------------------------------------
user function JOBWSC28(cFilJob)

	U_MGFWSC28({,"01",cFilJob})
Return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MNUWSC28()

	runInteg28()

Return

//-------------------------------------------------------------------
user function MGFWSC28( aEmpX )
	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

		conout(' [E-COM] [MGFWSC28] Iniciada Threads para a empresa' + allTrim( aEmpX[3] ) + ' - ' + dToC(dDataBase) + " - " + time())

		runInteg28()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
static function runInteg28()
	local cURLGet		:= allTrim( superGetMv( "MGFECOM28A" , , "http://spdwvsvc001/Homologacao/DC/API.WsIntegracaoShape/api/v0/Produto/PesoMedio" ) )
	local cGetRet		:= ""
	local cHeadRet		:= ""
	local bError 		:= ErrorBlock( { |oError| errorWSC27( oError ) } )
	local cUpdSB1		:= ""
	local oObjRet		:= nil

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	local cPesoMedio	:= ""

	local cUpdDA0		:= ""

	getSB1()

	while !QRYSB1->(EOF())

		BEGIN SEQUENCE
			//httpGet( < cUrl >, [ cGetParms ], [ nTimeOut ], [ aHeadStr ], [ @cHeaderGet ] )
			cGetRet		:= ""
			cHeadRet	:= ""
			cTimeIni	:= time()
			cGetRet		:= httpGet( cURLGet, "idProduto=" + allTrim( QRYSB1->B1_COD ), , , @cHeadRet )

			nStatuHttp	:= httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [E-COM] [MGFWSC28] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC28] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC28] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC28] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC28] URL..........................: " + cURLGet + "/" + "idProduto=" + allTrim( QRYSB1->B1_COD ) )
			conout(" [E-COM] [MGFWSC28] HTTP Method..................: " + "GET")
			conout(" [E-COM] [MGFWSC28] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC28] Retorno......................: " + cGetRet)
			conout(" [E-COM] [MGFWSC28] * * * * * * * * * * * * * * * * * * * * ")

			if !empty( cGetRet ) .and. nStatuHttp >= 200 .and. nStatuHttp <= 299
				oObjRet := nil
				if fwJsonDeserialize(cGetRet, @oObjRet)
					if valType( oObjRet ) == "A"
						if len( oObjRet ) > 0
							if oObjRet[1]:PESOMEDIO > 0
								cPesoMedio += "PRODUTO " + allTrim( QRYSB1->B1_COD ) + " PESO MEDIO " + allTrim( str( oObjRet[1]:PESOMEDIO ) ) + CRLF
							endif

							cUpdSB1 := ""
							cUpdSB1 := "UPDATE " + retSQLName("SB1")									+ CRLF
							cUpdSB1 += "	SET"														+ CRLF
							cUpdSB1 += " 		B1_ZPESMED = " + allTrim( str( oObjRet[1]:PESOMEDIO ) )	+ CRLF
							cUpdSB1 += " WHERE"															+ CRLF
							cUpdSB1 += " 		R_E_C_N_O_ = " + str( QRYSB1->B1RECNO )					+ CRLF

							if tcSQLExec( cUpdSB1 ) < 0
								conout(" [E-COM] [MGFWSC28] Não foi possível executar UPDATE." + CRLF + tcSqlError())
							else
								conout(" [E-COM] [MGFWSC28] Peso médio do produto " + allTrim( QRYSB1->B1_COD ) + " atualizado com sucesso")
							endif
						endif
					endif
				else
					conout(" [E-COM] [MGFWSC28] Erro na deserialização...")
				endif
			else
				conout(" [E-COM] [MGFWSC28] httpGet Failed.")
				varinfo(" [E-COM] [MGFWSC28] Header", cHeadRet)
			endif

			//cHtmlPage := Httpget('http://www.servidor.com.br/funteste.asp','Id=' + Escape('123') + '&Nome=' + Escape('Ana Silva'))
			//cHtmlPage := Httpget('http://www.servidor.com.br/funteste.asp?Id=123&Nome=Teste')
			//cHtmlPage := Httpget('http://www.servidor.com.br/funteste.asp','Id=' + Escape('123') + '&Nome=' + Escape('Ana Silva'))
			//cUrl := 'http://localhost/webinfo.apw'cPAram1 := 'Teste de Parametro 01-02'cPAram2 := '#reserva#'cPAram3 := '1+2+3'cUrl += '?Par01=' + escape(cPAram1) + '&PAr02=' + escape(cPAram2) + '&Par03=' + escape(cPAram3)// O conteudo de cUrl deverá ser "http://localhost/webinfo.apw?Par01=Teste%20de%20Parametro%2001-02&PAr02=%23reserva%23&Par03=1%2B2%2B3" , próprio para a monyahem de um link .
			/*
			cUrl := 'http://localhost/webinfo.apw'
			cPAram1 := 'Teste de Parametro 01-02'
			cPAram2 := '#reserva#'
			cPAram3 := '1+2+3'
			cUrl += '?Par01=' + escape(cPAram1) + '&PAr02=' + escape(cPAram2) + '&Par03=' + escape(cPAram3)
			*/
			// O conteudo de cUrl deverá ser "http://localhost/webinfo.apw?Par01=Teste%20de%20Parametro%2001-02&PAr02=%23reserva%23&Par03=1%2B2%2B3" , próprio para a monyahem de um link .
		RECOVER
			Conout(' [E-COM] [MGFWSC28] [ECOM] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
		END SEQUENCE

		// Grava json
		//memoWrite("C:\TEMP\ESTOQUE.JSON", oInteg:cJson)

		freeObj( oObjRet )

		QRYSB1->(DBSkip())
	enddo

	QRYSB1->(DBCloseArea())

	if !empty( cPesoMedio )
		memoWrite("C:\TEMP\PESO_MEDIO.txt", cPesoMedio)
	endif

	// Atualiza Lista de Preço para ser enviada ao E-Commerce
	cUpdDA0 := "UPDATE " + retSQLName("DA0")						+ CRLF	
	cUpdDA0 += "	SET"											+ CRLF
	cUpdDA0 += " 		DA0_XINTEC = '0'"							+ CRLF
	cUpdDA0 += " WHERE"												+ CRLF
	cUpdDA0 += " 		DA0_XENVEC	=	'1'"						+ CRLF
	cUpdDA0 += " 	AND	DA0_FILIAL	=	'" + xFilial("DA0")	+ "'"	+ CRLF
	cUpdDA0 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

	if tcSQLExec( cUpdDA0 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif

	delClassINTF()
return

//-------------------------------------------------------
//-------------------------------------------------------
static function errorWSC27(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	// fwTimeStamp(1) -> aaaammddhhmmss

	//memoWrite("\ECOM_MGFWSC28_" + fwTimeStamp(1) + ".log", cEr)
	conout( cEr )

	_aErr := { '0', cEr }
return .T.

//------------------------------------------------------
// Seleciona produtos em estoque
//------------------------------------------------------
static function getSB1()
	local cQrySB1	:= ""

	cQrySB1 := "SELECT B1_COD, R_E_C_N_O_ B1RECNO"						+ CRLF
	cQrySB1 += " FROM " + retSQLName("SB1") + " SB1"					+ CRLF
	cQrySB1 += " WHERE"													+ CRLF
	cQrySB1 += " 		SB1.B1_COD		<=	'500000'"					+ CRLF
	cQrySB1 += " 	AND	SB1.B1_COD		<>	'000000'"					+ CRLF
	cQrySB1 += " 	AND	SB1.B1_MSBLQL	=	'2'"						+ CRLF
	cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1")	+ "'"	+ CRLF
	cQrySB1 += " 	AND	SB1.B1_XENVECO = '1' "							+ CRLF
	cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"						+ CRLF

	conout(" [E-COM] [MGFWSC28] " + cQrySB1)

	TcQuery cQrySB1 New Alias "QRYSB1"
return
