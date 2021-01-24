#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#Include "XMLXFUN.CH"

#define CRLF chr( 13 ) + chr( 10 )
/*/
=============================================================================
{Protheus.doc} MGFWSC81
Integração com Salesforce Dados Financeiros
@description
Integração Histórico de Títulos em Aberto
@author Rogerio Almeida de Oliveira
@since 10/01/2020
@type Function
@table
 SA1 - Clientes
 SE1 - Contas a Receber
 @param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/

/*/
==============================================================================================================================================================================
{Protheus.doc} JOBWSC81()
Para ser chamado via JOB
@type function
@author Rogerio Almeida
@since 10/01/2020
@version P12
/*/
user function JOBWSC81( cFilJob )

	U_MGFWSC81( { "01" , cFilJob } )

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MNUWSC81()
Para ser chamado via Menu
@type function
@author Rogerio Almeida
@since 10/01/2020
@version P12
/*/
user function MNUWSC81()

	runInteg81()

return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSC81()
Executar em Threads
@type function
@author Rogerio Almeida
@since 10/01/2020
@version P12
/*/
user function MGFWSC81( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC81] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg81()

	RESET ENVIRONMENT
return

/*/
==============================================================================================================================================================================
{Protheus.doc} runInteg81()
Rotina de execução da integração
@type function
@author Rogerio Almeida
@since 10/01/2020
@version P12
/*/
static procedure runInteg81()

	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC81A" , , "https://spdwvapl203:443/processo-financeiro/api/v1/historicos-pagamentos/lote" ) )
	local cHTTPMetho	:= ""
	local cUpdSE1		:= ""
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
    local aJson         := {}
	local oJson	        := nil
	local oJsonStat  	:= nil
	local cSE1Recno     := ""
	local cIdStat       := "" //Id Status Retornado na query
	local cStPerm       := "" //Status permitidos
	local aRetMet       := {} //Retorno da function de status
	local cUUID         := ""

	//Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integração
    local cStaLog		:= "" // Codigo do Status da integração, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC81F" , , "008" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração

	local cHeadHttp		:= ""
	local nI

	conout("[SALESFORCE] - MGFWSC81- Selecionando Titulos aptos a integrar com SALESFORCE")

	getRegs( ) // Retornar registros aptos p/ integração

	nMaxItens   := superGetMv( "MGFWSC81B" , , 200 )

	while  !QRYWSC81->(EOF())

		aJson := {}
		oJson := nil
		oJson := JsonObject():new()

		cSE1Recno	:= ""
		nCountIten	:= 0
		while !QRYWSC81->(EOF()) .AND. nCountIten < nMaxItens

			cIdStat := ""
            aRetMet := {}

			aRetMet := getStatus() //Retorna status
			cIdStat := Iif(len(aRetMet) >0, cValtoChar(aRetMet[1]), "9")
			cStPerm := superGetMv( "MGFWSC81C" , , "1/2/3/8" )

			If cIdStat $ cStPerm

				nCountIten++
			    cSE1Recno	+= allTrim( str( QRYWSC81->SE1RECNO ) ) +  ","

				Aadd(aJson,JsonObject():new())

				aJson[nCountIten] ['numeroTitulo']   	    := alltrim(QRYWSC81->E1_NUM)
				aJson[nCountIten] ['parcela']   			:= VAL(QRYWSC81->E1_PARCELA)
				aJson[nCountIten] ['saldoReceber']          := QRYWSC81->E1_SALDO
				aJson[nCountIten] ['vencimento']            := left( fwTimeStamp( 3 , sToD( QRYWSC81->E1_VENCREA ) ) , 10 )
				aJson[nCountIten] ['emissao']               := left( fwTimeStamp( 3 , sToD( QRYWSC81->E1_EMISSAO ) ) , 10 )

				oJsonStat := nil
				oJsonStat := JsonObject():new()
				oJsonStat ['id']	:= Val(cIdStat)
				oJsonStat ['descricao']	:= Iif(len(aRetMet) >0, ALLTRIM(aRetMet[2]), " ")

				aJson[nCountIten] ['status']                := oJsonStat
				aJson[nCountIten] ['cnpjCliente']           := alltrim(QRYWSC81->A1_CGC)
				aJson[nCountIten] ['codigoCliente']         := alltrim(QRYWSC81->A1_COD)
				aJson[nCountIten] ['lojaCliente']           := alltrim(QRYWSC81->A1_LOJA)
				aJson[nCountIten] ['filial']                := alltrim(QRYWSC81->E1_FILIAL)
				aJson[nCountIten] ['pedido']                := alltrim(QRYWSC81->E1_PEDIDO)

				aJson[nCountIten] ["UID"]					:= fwUUIDv4( .T. )
				aJson[nCountIten] ["RECNO"]					:= QRYWSC81->SE1RECNO
            endIf
			QRYWSC81->(DBSkip())
		enddo

		cJson := fwJsonSerialize(aJson, .T., .T.)  //Serializar o array de Json

		if !empty( cJson ) .And. ALLTRIM(cJson) <> "[]"

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

			conout(" [SALESFORCE] [MGFWSC81] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC81] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC81] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC81] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC81] URL..........................: " + cURLInteg 								)
			conout(" [SALESFORCE] [MGFWSC81] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC81] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC81] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC81] * * * * * * * * * * * * * * * * * * * * "									)

			varInfo( "xRetHttp" , xRetHttp )

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
			    cStaLog  := "1"
				cErroLog := ""

				begin transaction

					cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
					cUpdSE1 += "	SET"															+ CRLF
					cUpdSE1 += "	E1_XINTSFO = 'I' "												+ CRLF

					cUpdSE1 += " WHERE"																+ CRLF
					cUpdSE1 += " 		R_E_C_N_O_ IN ("+ left( cSE1Recno , len(cSE1Recno)-1 )+")"  + CRLF

					if tcSQLExec( cUpdSE1 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						cErroLog := "Não foi possível executar UPDATE. "+ tcSqlError()
						cStaLog  := "2" //Erro
						DisarmTransaction()
					endif
					
				end transaction

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
	QRYWSC81->(DBCloseArea())
	delClassINTF()
return

/*/
==============================================================================================================================================================================
{Protheus.doc} getRegs()
Seleciona os registros para exportação
@type function
@author Rogerio Almeida
@since 09/01/2020
@version P12
/*/
static procedure getRegs( )

	Local dDtINI  := SuperGetMV('MGFWSC81D', ,StoD('20191201'))
	Local cTipos  := SuperGetMv( "MGFWSC81E" , , "NF/JR/RA")
	Local lFilPes := superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica
	Local QRYWSC81 := ""

	QRYWSC81 := "SELECT "													    + CRLF
	QRYWSC81 += " E1_FILIAL, "      											+ CRLF
	QRYWSC81 += " E1_NUM, "      											    + CRLF
	QRYWSC81 += " E1_PARCELA, "     											+ CRLF
	QRYWSC81 += " E1_EMISSAO, "  						    					+ CRLF
	QRYWSC81 += " E1_VENCREA, "												    + CRLF
	QRYWSC81 += " E1_VENCTO, "												    + CRLF
	QRYWSC81 += " E1_VALOR, "													+ CRLF
	QRYWSC81 += " E1_STATUS, "					            					+ CRLF
	QRYWSC81 += " E1_SALDO, "   						  		                + CRLF
	QRYWSC81 += " E1_VALLIQ, "								                 	+ CRLF
	QRYWSC81 += " E1_BAIXA, "									                + CRLF
	QRYWSC81 += " E1_TIPO, "									                + CRLF
	QRYWSC81 += " E1_PEDIDO, "								                    + CRLF
	QRYWSC81 += " A1_COD, "								                        + CRLF
	QRYWSC81 += " A1_LOJA, "								                    + CRLF
	QRYWSC81 += " A1_CGC, "								                        + CRLF
	QRYWSC81 += " SE1.R_E_C_N_O_  SE1RECNO,  "	  							    + CRLF
	QRYWSC81 += " E1_NUMBOR ,  "								                + CRLF
	QRYWSC81 += " E1_SDACRES,  "								                + CRLF
	QRYWSC81 += " E1_ACRESC,   "				     				            + CRLF
	QRYWSC81 += " E1_SITUACA,   "			     				                + CRLF
	QRYWSC81 += " SE1.D_E_L_E_T_  SE1DELETE "		   			                + CRLF

	QRYWSC81 += " FROM " + retSQLName("SE1") + " SE1"							+ CRLF

	QRYWSC81 += " INNER JOIN " + retSQLName("SA1") + " SA1"						+ CRLF
	QRYWSC81 += " ON"															+ CRLF
	QRYWSC81 += "   SE1.E1_CLIENTE  = A1_COD AND "			 				   	+ CRLF
	QRYWSC81 += "   SE1.E1_LOJA = A1_LOJA    AND "		 				   		+ CRLF
	QRYWSC81 += "   SA1.D_E_L_E_T_ <> '*'    AND "		 				   		+ CRLF

	if lFilPes
		QRYWSC81 += "   SA1.A1_PESSOA = 'J' 	 AND "		 			        + CRLF
	endIf

	QRYWSC81 += "   SA1.A1_EST <> 'EX'       AND "				 				+ CRLF
	QRYWSC81 += "   SA1.A1_XIDSFOR  <> ' '   AND "		 				      	+ CRLF
	QRYWSC81 += "   SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"	                + CRLF

	QRYWSC81 += " WHERE"														+ CRLF
	QRYWSC81 += " 	E1_FILIAL	=	'" + xFilial("SE1") + "'"			        + CRLF
	QRYWSC81 += " 	AND E1_XINTSFO = 'P' "     				    			    + CRLF
	QRYWSC81 += "   AND E1_TIPO IN "+FormatIn(cTipos,"/")                       + CRLF
    //Filtrar a data inicial da integração
    QRYWSC81 += " 	AND E1_EMISSAO >= '" + DTOS(dDtINI) + "'"       		    + CRLF


	QRYWSC81 += "	AND"	+ CRLF
	QRYWSC81 += "	("	+ CRLF

	// Baixado parcialmente
	QRYWSC81 += "		( ROUND( E1_SALDO , 2 ) + ROUND( E1_SDACRES , 2 ) <> ROUND( E1_VALOR , 2 ) + ROUND( E1_ACRESC , 2 ) ) "	+ CRLF

	QRYWSC81 += "		OR"	+ CRLF

	// Título baixado
	QRYWSC81 += "		( ROUND( E1_SALDO , 2 ) = 0 )"	+ CRLF

	QRYWSC81 += "		OR"	+ CRLF

	// Título em aberto
	QRYWSC81 += "		( E1_SALDO > 0 )"	+ CRLF

	QRYWSC81 += "	)"	+ CRLF

	conout("[MGFWSC81] [SALES] " + QRYWSC81)

	tcQuery QRYWSC81 New Alias "QRYWSC81"
return


/*/
==============================================================================================================================================================================
{Protheus.doc} getStatus()
Retorna o status de acordo com a regra do Protheus
@type function
@author Rogerio Almeida
@since 20/01/2020
@version P12
/*/
static function getStatus( )
//Referencia --> Fonte FINALEG
Local aRetorno := {}

DO CASE
      CASE ROUND(QRYWSC81->E1_SALDO,2) = 0
       // BR_VERMELHO
	   aAdd(aRetorno,3)
	   aAdd(aRetorno,"Título baixado")
	  CASE !Empty(QRYWSC81->E1_NUMBOR) .And. (ROUND(QRYWSC81->E1_SALDO,2) # ROUND(QRYWSC81->E1_VALOR,2))
       // BR_CINZA
	   aAdd(aRetorno,6)
	   aAdd(aRetorno,"Título baixado parcialmente e em bordero")
      CASE  ALLTRIM(QRYWSC81->E1_TIPO) == "RA" .And. ROUND(QRYWSC81->E1_SALDO,2) > 0 .And. !FXAtuTitCo()
	   // BR_BRANCO
	   aAdd(aRetorno,5)
	   aAdd(aRetorno,"Adiantamento com saldo")
      CASE !Empty(QRYWSC81->E1_NUMBOR)
	   // BR_PRETO
	   aAdd(aRetorno,4)
	   aAdd(aRetorno,"Título em borderô")
      CASE ROUND(QRYWSC81->E1_SALDO,2) + ROUND(QRYWSC81->E1_SDACRES,2) # ROUND(QRYWSC81->E1_VALOR,2) + ROUND(QRYWSC81->E1_ACRESC,2) .And. !FXAtuTitCo()
       // BR_AZUL
	   aAdd(aRetorno,2)
	   aAdd(aRetorno,"Baixado parcialmente")
	  CASE ROUND(QRYWSC81->E1_SALDO,2) == ROUND(QRYWSC81->E1_VALOR,2) .And. ALLTRIM(QRYWSC81->E1_SITUACA) == "F"
	   // BR_AMARELO
	   aAdd(aRetorno,7)
	   aAdd(aRetorno,"Adiantamento de Imp. Bx. com saldo")
	  CASE ALLTRIM(QRYWSC81->SE1DELETE)  == "*"
	   // DELETADO
	   aAdd(aRetorno,8)
	   aAdd(aRetorno,"Registro deletado no ERP")
      OTHERWISE
	   // BR_VERDE
	   aAdd(aRetorno,1)
	   aAdd(aRetorno,"Título em aberto")
      ENDCASE

return aRetorno
