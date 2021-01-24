#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#DEFINE CRLF chr(13) + chr(10)

/*
	Exportação de Pré Cálculo
*/
user function MGFEEC66()
	if getParam()
		//genArq()
		fwMsgRun( , { | oSay | genArq( oSay ) } , "Processando" , "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Tabela de Pré Cálculo"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq( oSay )
	local aArea		:= getArea()
	local cNameFile	:= "Pre_Calculo_" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""
	local nLast		:= 0
	local nLinAtu	:= 0

	if !existDir( allTrim( MV_PAR01 ) )
		msgAlert("Diretório inválido.")
		return
	endif

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())
			COUNT TO nLast
			QRYARQ->( DBGoTop() )

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			IF QRYARQ->ZED_TIPODE == 'A'
			  cStrCSV += "TABELA;DESPESA;DESC. DESPESA;TIPO PRODUTO;TIPO DESPESA;MOEDA;DESC. MOEDA;VALOR; VALOR MINIMO;VALOR MAXIMO;ORIGEM;DESC. PORTO;DESTINO;DESC. DESTINO;ARMADOR;DESC. ARMADOR" + CRLF
            ElseIF QRYARQ->ZED_TIPODE =='T'
			  cStrCSV += "TABELA;DESPESA;DESC. DESPESA;TERMINAL;DESC TERMINAL;PERIDO;DIAS PERIODO;VLR PERIODO;MOEDA;COBR.RETROATIVA;CONTAINER;PRE CALCULAR" + CRLF
            EndIF

			while !QRYARQ->(EOF())
				nLinAtu++

				oSay:cCaption := ( "Exportando item " + str( nLinAtu ) + " de " + str( nLast ) )

				processMessages()

				cStrCSV := ""
                IF QRYARQ->ZED_TIPODE == 'A'
					cStrCSV += xClean( allTrim( QRYARQ->ZED_CODIGO ) )	+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_CODDES ) )	+ ";"
					cStrCSV += xClean( allTrim( GetAdvFVal( "SYB","YB_DESCR",xFilial("SYB")+QRYARQ->ZEE_CODDES,1,"" ) ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_TIPOPR ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_TIPODE ) )		+ ";"
	
					//1-R$;2-US$;3-EUR;4-GBP
					if allTrim( QRYARQ->ZEE_MOEDA ) == "R$"
						cStrCSV += "1;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "US$"
						cStrCSV += "2;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "EUR"
						cStrCSV += "3;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "GBP"
						cStrCSV += "4;"
					endif
	
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_MOEDA ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_VALOR ) ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_VALMIN ) ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_VALMAX ) ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_ORIGEM ) )		+ ";"
					cStrCSV += xClean( allTrim( GetAdvFVal("SY9","Y9_DESCR",xFilial("SY9")+QRYARQ->ZEE_ORIGEM,2,"" ) ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_DESTIN ) )		+ ";"
					cStrCSV += xClean( allTrim( GetAdvFVal("SY9","Y9_DESCR",xFilial("SY9")+QRYARQ->ZEE_DESTIN,2,"" ) ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_ARMADO ) )		+ ";"
					cStrCSV += xClean( allTrim( GetAdvFVal( "SY5","Y5_NOME",xFilial("SY5")+QRYARQ->ZEE_ARMADO,1,"" ) ) )		+ ""
                ElseIF QRYARQ->ZED_TIPODE =='T'
					cStrCSV += xClean( allTrim( QRYARQ->ZED_CODIGO ) )	+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_CODDES ) )	+ ";"
					cStrCSV += xClean( allTrim( GetAdvFVal( "SYB","YB_DESCR",xFilial("SYB")+QRYARQ->ZEE_CODDES,1,"" ) ) )		+ ";"

					cStrCSV += xClean( allTrim( QRYARQ->ZEE_TERMIN ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_NOMTER ) )		+ ";"
					//cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_QTDDIA ) ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_PER ) ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_DIAPER ) ) )		+ ";"
					cStrCSV += xClean( allTrim( str( QRYARQ->ZEE_VLPER ) ) )		+ ";"
					if allTrim( QRYARQ->ZEE_MOEDA ) == "R$"
						cStrCSV += "1;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "US$"
						cStrCSV += "2;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "EUR"
						cStrCSV += "3;"
					elseif allTrim( QRYARQ->ZEE_MOEDA ) == "GBP"
						cStrCSV += "4;"
					endif
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_COB ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_CONT ) )		+ ";"
					cStrCSV += xClean( allTrim( QRYARQ->ZEE_PCALC ) )		+ ";"
                EndIF
                

				cStrCSV += CRLF

				fWrite(nHandle , cStrCSV )

				QRYARQ->(DBSkip())
			enddo
			msgInfo("Exportação gerada com sucesso.")
		else
			msgAlert("Não foram encontradas informações a serem exportadas.")
		endif
		QRYARQ->(DBCloseArea())
	endif

	fClose(nHandle)

	restArea(aArea)
return

//******************************************************
//******************************************************
static function xClean(cStr)
	cStr := StrTran(cStr, "'", "")
	cStr := StrTran(cStr, '"', '')
	cStr := StrTran(cStr, ";", "")
return cStr

//******************************************************
//******************************************************
static function getInfo()
	local cQryArq := ""

	cQryArq := "SELECT *" 	+ CRLF
	cQryArq += " FROM "			+ retSQLName("ZED") + " ZED" 			+ CRLF
	cQryArq += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE" 			+ CRLF
	cQryArq += " ON" 													+ CRLF
	cQryArq += " 		ZED.ZED_CODIGO	=	ZEE.ZEE_CODIGO" 			+ CRLF
	cQryArq += " 	AND	ZEE.D_E_L_E_T_	<>	'*'" 						+ CRLF
	cQryArq += " WHERE" 												+ CRLF
	cQryArq += " 	ZED.D_E_L_E_T_	<>	'*'" 							+ CRLF
	cQryArq += " ORDER BY ZED_CODIGO" 									+ CRLF

	memoWrite("C:\TEMP\MGFEEC66.sql", cQryArq)

	TcQuery cQryArq New Alias "QRYARQ"
return
