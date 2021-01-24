#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"


#define CRLF chr(13) + chr(10)

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC26
INTEGRACAO E-COMMERCE - Envio de tabelas de preços

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/   
user function MGFWSC26()

	conout('[MGFWSC26] Iniciando ambiente para exportação de tabela de preços para o commerce...')

	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

	runInteg26()

	RESET ENVIRONMENT

	conout('[MGFWSC26] Completou exportação de tabela de preços para o commerce...')

return

/*/
===========================================================================================================================
{Protheus.doc} MNUWSC26
Chamada via tela

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
user function MNUWSC26()

	//Valida se está executando a partir do cadastro de tabela de preços
	If alltrim(funname()) != "OMSA010" .AND. alltrim(funname()) != "MGFFAT94"
		msgalert("Rotina deve ser executada a partir do ações relacionadas do cadastro de tabela de preços!")
		Return
	Endif

	//Valida se tabela posicionada integra com commerce
	If DA0_XENVEC	!=	'1'
		msgalert("Tabela " + DA0->DA0_CODTAB + " - " + alltrim(DA0->DA0_DESCRI) + " não integra com Commerce!")
		Return
	Endif

	If MsgYesNo("Deseja integrar a tabela " + DA0->DA0_CODTAB + " - " + alltrim(DA0->DA0_DESCRI) + " com Commerce?")

		Reclock("DA0",.F.)
		DA0_XINTEC	:=	'0'
		DA0->(Msunlock())

		fwmsgrun(,{|| runInteg26(DA0->DA0_CODTAB)},"Aguarde processamento...","Aguarde processamento...")

	Else

		msgalert("Processo cancelado!")

	Endif

return


/*/
===========================================================================================================================
{Protheus.doc} runInteg26
Execução da integração

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function runInteg26(_ctabela)
	local cURLInteg			:= allTrim( superGetMv( "MGFECOM26A" , , "http://spdwvapl219:8200/protheus-produto/api/v1/pricelist" ) )
	local cURLUse			:= ""
	local oInteg			:= nil
	local cCodTab			:= ""
	local nDA0Recno			:= ""

	local cJson				:= ""
	local nStatuHttp		:= 0
	local aHeadStr			:= {}
	local cHeaderRet		:= ""
	local nTimeOut			:= 120

	local oJson				:= nil
	local nTotalList		:= 0
	local nCountList		:= 0
	local lPost				:= .F.

	local cTimeIni			:= ""
	local cTimeFin			:= ""
	local cTimeProc			:= ""
	local cHttpMetho		:= ""

	local aAreaTmp			:= {}
	Local nCntItens			:= 0
	Local lGerCab			:= .F.
	Local aDadExc			:= {}
	Local ni                := 0
	Local _acols            := {}
	Local _aheader          := {"Tabela","Cod","Produto","Preço","Status"}

	Default _ctabela 		:= ""

	aadd( aHeadStr, 'Content-Type: application/json')

	conout("[ECOM] - MGFWSC26- Selecionando listas de preço aptos a integrar com E-Commerce")

	_aprodutos := WSC26PRO(_ctabela) //Carrega dados para enviar integração

	If !empty(_ctabela) .and. QRYDA0->(EOF())
		msgalert("Tabela " + _ctabela + " não possui registros para integração!")
		Return
	Endif

	nCountList	:= 0
	nTotalList	:= 0
	Count to nTotalList

	QRYDA0->(DBGoTop())
	
	_ctab := QRYDA0->DA0_CODTAB

	//Para execução em tela mostra preços que serão enviados
	If !empty(_ctabela)

		while !QRYDA0->(EOF())

			aadd(_acols,{QRYDA0->DA0_CODTAB,QRYDA0->B1_COD,QRYDA0->B1_DESC,QRYDA0->DA1_PRCVEN * QRYDA0->B1_ZPESMED,""})

			QRYDA0->(Dbskip())

		Enddo

		If !U_MGListBox( "Preços a integrar - Deseja Continuar ?" , _aheader , _acols , .T. , 1 )  

			ApMsgInfo(OemToAnsi("Processo cancelado pelo usuário!"),OemToAnsi("FALHA"))
			Return

		Endif 

	Endif

	QRYDA0->(DBGoTop())

	while !QRYDA0->(EOF())

		//Controle para mandar apenas uma tabela com espaço de tempo para não pegar em processamento
		If _ctab != QRYDA0->DA0_CODTAB
			sleep(120000) // aguarda 2 minutos
		Endif
		
		conout("[ECOM] - MGFWSC26- Enviando tabela " + QRYDA0->DA0_CODTAB + "...")

		cCodTab := QRYDA0->DA0_CODTAB

		if QRYDA0->DA0_ZSTAEC <> "1"
			lPost := .T.
		else
			lPost := .F.
		endif

		nDA0Recno := QRYDA0->DA0RECNO

		If lPost //Post para Inclusão da Lista

			oJson					:= JsonObject():new()
			oJson['DA0_CODTAB']		:= QRYDA0->DA0_CODTAB
			oJson['DA0_DATDE']		:= left( dToC( sToD( QRYDA0->DA0_DATDE	) ) , 6 ) + "20" + right( dToC( sToD( QRYDA0->DA0_DATDE ) ) , 2 )  + " 00:00:00"
			oJson['DA0_DATATE']		:= left( dToC( sToD( QRYDA0->DA0_DATATE	) ) , 6 ) + "20" + right( dToC( sToD( QRYDA0->DA0_DATATE ) ) , 2 )  + " 23:59:59"

			oJson['DA0_DESCRI']		:= allTrim( QRYDA0->DA0_DESCRI )
			oJson['DA0_PRODUTOS']	:= {}

			oJson['flgcommit'] := .F.

			cTimeIni := time()

			nStatuHttp	:= 0
			cHeaderRet	:= ""
			cJson		:= ""
			cJson		:= oJson:toJson()

			cHttpMetho	:= "POST"
			cURLUse		:= ""
			cURLUse		:= cURLInteg

			httpQuote( cURLUse /*<cUrl>*/, cHttpMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

			nStatuHttp	:= httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [E-COM] [MGFWSC26] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC26] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC26] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC26] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC26] URL..........................: " + cURLUse)
			conout(" [E-COM] [MGFWSC26] HTTP Method..................: " + cHttpMetho)
			conout(" [E-COM] [MGFWSC26] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC26] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC26] * * * * * * * * * * * * * * * * * * * * ")


			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("DA0")								+ CRLF
				cUpdTbl += "	SET"													+ CRLF
				cUpdTbl += " 		DA0_XINTEC = '1', DA0_ZSTAEC = '1'"					+ CRLF
				cUpdTbl += " WHERE"														+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nDA0Recno ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

			endif

		EndIf

		//Contador de Itens para cada Lista de Preço
		nCntItens := 0
		lGerCab := .T.
		while !QRYDA0->(EOF()) .and. cCodTab == QRYDA0->DA0_CODTAB

			nCntItens ++//Contador dos Itens da Lista de preço
			nCountList++//Contador Total

			If lGerCab //Gera cabeçalho
				oJson					:= JsonObject():new()
				oJson['DA0_CODTAB']		:= QRYDA0->DA0_CODTAB
				oJson['DA0_DATDE']		:= left( dToC( sToD( QRYDA0->DA0_DATDE	) ) , 6 ) + "20" + right( dToC( sToD( QRYDA0->DA0_DATDE ) ) , 2 )  + " 00:00:00"
				oJson['DA0_DATATE']		:= left( dToC( sToD( QRYDA0->DA0_DATATE	) ) , 6 ) + "20" + right( dToC( sToD( QRYDA0->DA0_DATATE ) ) , 2 )  + " 23:59:59"
				oJson['DA0_DESCRI']		:= allTrim( QRYDA0->DA0_DESCRI )
				oJson['DA0_PRODUTOS']	:= {}
				lGerCab := .F.
			EndIf

			if nCountList == nTotalList
				oJson['flgcommit'] := .T.
			else
				oJson['flgcommit'] := .F.
			endif

			oJsonProd					:= JsonObject():new()
			oJsonProd['DA1_CODPROD']	:= allTrim( QRYDA0->DA1_CODPROD )

			If alltrim(QRYDA0->DA1DELETE) <> "*"
				oJsonProd['DA1_PRCVEN']		:= ( QRYDA0->DA1_PRCVEN * QRYDA0->B1_ZPESMED )
			Else
				oJsonProd['DA1_PRCVEN']		:= 0
				AADD(aDadExc,QRYDA0->DA1RECNO)
			EndIf

			aadd( oJson['DA0_PRODUTOS'] , oJsonProd )

			If nCntItens == nTotalList .or. nCntItens == 250 // QUANTIDADE DE PRODUTOS POR JSON

				if nCountList == nTotalList
					oJson['flgcommit'] := .T.
				else
					oJson['flgcommit'] := .F.
				endif

				nStatuHttp	:= 0
				cHeaderRet	:= ""
				cJson		:= ""
				cJson		:= oJson:toJson()
				cTimeIni := time()

				cHttpMetho	:= "PUT"
				cURLUse		:= ""
				cURLUse		:= cURLInteg + "/" + oJson['DA0_CODTAB']

				httpQuote( cURLUse /*<cUrl>*/, cHttpMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

				nStatuHttp	:= httpGetStatus()
				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )

				conout(" [E-COM] [MGFWSC26] * * * * * Status da integracao * * * * *")
				conout(" [E-COM] [MGFWSC26] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
				conout(" [E-COM] [MGFWSC26] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
				conout(" [E-COM] [MGFWSC26] Tempo de Processamento.......: " + cTimeProc)
				conout(" [E-COM] [MGFWSC26] URL..........................: " + cURLUse)
				conout(" [E-COM] [MGFWSC26] HTTP Method..................: " + cHttpMetho)
				conout(" [E-COM] [MGFWSC26] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
				conout(" [E-COM] [MGFWSC26] Envio........................: " + cJson)
				conout(" [E-COM] [MGFWSC26] * * * * * * * * * * * * * * * * * * * * ")

				_cresul := "Falha de envio " + allTrim( str( nStatuHttp ) ) 

				if nStatuHttp >= 200 .and. nStatuHttp <= 299

					cUpdTbl	:= ""

					cUpdTbl := "UPDATE " + retSQLName("DA0")								+ CRLF
					cUpdTbl += "	SET"													+ CRLF
					cUpdTbl += " 		DA0_XINTEC = '1', DA0_ZSTAEC = '1'"					+ CRLF
					cUpdTbl += " WHERE"														+ CRLF
					cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nDA0Recno ) ) + ""	+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

					For ni:= 1 To len(aDadExc)
						cUpdTbl	:= ""

						cUpdTbl := "UPDATE " + retSQLName("DA1")								+ CRLF
						cUpdTbl += "	SET"													+ CRLF
						cUpdTbl += " 		 DA1_XENEEC = '1'"									+ CRLF
						cUpdTbl += " WHERE"														+ CRLF
						cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( aDadExc[ni] ) ) + ""	+ CRLF

						if tcSQLExec( cUpdTbl ) < 0
							conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						endif

					next ni

					aDadExc := {}

				endif
				
				nCntItens := 0
				lGerCab := .T.

			Endif

			QRYDA0->(DBSkip())

		EndDo

		If !lGerCab

			if nCountList == nTotalList
				oJson['flgcommit'] := .T.
			else
				oJson['flgcommit'] := .F.
			endif

			nStatuHttp	:= 0
			cHeaderRet	:= ""
			cJson		:= ""
			cJson		:= oJson:toJson()
			cTimeIni := time()

			cHttpMetho	:= "PUT"
			cURLUse		:= ""
			cURLUse		:= cURLInteg + "/" + oJson['DA0_CODTAB']

			httpQuote( cURLUse /*<cUrl>*/, cHttpMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

			nStatuHttp	:= httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [E-COM] [MGFWSC26] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC26] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC26] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC26] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC26] URL..........................: " + cURLUse)
			conout(" [E-COM] [MGFWSC26] HTTP Method..................: " + cHttpMetho)
			conout(" [E-COM] [MGFWSC26] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC26] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC26] * * * * * * * * * * * * * * * * * * * * ")

			if nStatuHttp >= 200 .and. nStatuHttp <= 299

				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("DA0")								+ CRLF
				cUpdTbl += "	SET"													+ CRLF
				cUpdTbl += " 		DA0_XINTEC = '1', DA0_ZSTAEC = '1'"					+ CRLF
				cUpdTbl += " WHERE"														+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nDA0Recno ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

				For ni:= 1 To len(aDadExc)
					cUpdTbl	:= ""

					cUpdTbl := "UPDATE " + retSQLName("DA1")								+ CRLF
					cUpdTbl += "	SET"													+ CRLF
					cUpdTbl += " 		 DA1_XENEEC = '1'"									+ CRLF
					cUpdTbl += " WHERE"														+ CRLF
					cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( aDadExc[ni] ) ) + ""	+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

				next ni

				aDadExc := {}

			endif

		EndIf

		If QRYDA0->(EOF())
			Exit
		EndIf
	EndDo

	QRYDA0->(DBCloseArea())
	conout("[ECOM] - MGFWSC26- Completou exportação")

	If !empty(_ctabela)

		ApMsgInfo(OemToAnsi("Reenvio completado!"),OemToAnsi("SUCESSO"))

	Endif

	delClassINTF()
return

/*/
===========================================================================================================================
{Protheus.doc} WSC26PRO
Seleciona os produtos para exportação
@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function WSC26PRO(_ctabela)

	local cQryDA0 := ""
	Local aTabNot			:= {}

	cQryDA0 := "SELECT"															+ CRLF
	cQryDA0 += " B1_COD							,"								+ CRLF
	cQryDA0 += " B1_DESC						,"								+ CRLF
	cQryDA0 += " B1_ZPESMED						,"								+ CRLF
	cQryDA0 += " DA0_ZSTAEC						,"								+ CRLF
	cQryDA0 += " DA0.R_E_C_N_O_ DA0RECNO		,"								+ CRLF
	cQryDA0 += " DA1.R_E_C_N_O_ DA1RECNO		,"								+ CRLF
	cQryDA0 += " DA1.D_E_L_E_T_ DA1DELETE		,"								+ CRLF
	cQryDA0 += " DA0_CODTAB		,"												+ CRLF
	cQryDA0 += " DA1_CODPRO		,"												+ CRLF
	cQryDA0 += " DA0_DATDE		,"												+ CRLF
	cQryDA0 += " DA0_DATATE		,"												+ CRLF
	cQryDA0 += " DA1_PRCVEN		,"												+ CRLF
	cQryDA0 += " DA0_DESCRI"													+ CRLF
	cQryDA0 += " FROM "			+ retSQLName("DA0") + " DA0"					+ CRLF
	cQryDA0 += " INNER JOIN "	+ retSQLName("DA1") + " DA1"					+ CRLF
	cQryDA0 += " ON"															+ CRLF
	cQryDA0 += " 		DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
	cQryDA0 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'"			+ CRLF
	cQryDA0 += " INNER JOIN "	+ retSQLName("SB1") + " SB1"					+ CRLF
	cQryDA0 += " ON"															+ CRLF
	cQryDA0 += " 		DA1.DA1_CODPRO	=	SB1.B1_COD"							+ CRLF
	cQryDA0 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"			+ CRLF
	cQryDA0 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryDA0 += " 	LEFT JOIN ZA4010 ZA4"										+ CRLF
 	cQryDA0 += " 	ON"															+ CRLF
 	cQryDA0 += " 		ZA4.ZA4_CODIGO	=	SB1.B1_ZCCATEG"						+ CRLF
 	cQryDA0 += " 	AND	ZA4.ZA4_FILIAL	=	'      '"							+ CRLF
 	cQryDA0 += " 	AND	ZA4.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryDA0 += " WHERE"															+ CRLF
	cQryDA0 += " 		DA0.DA0_XENVEC	=	'1'"								+ CRLF // Envia E-Commerce		-> 0=Nao;1=Sim
	cQryDA0 += "    AND SB1.B1_ZSTATEC = '1' "									+ CRLF //Só manda produtos já cadastrados no commerce
	cQryDA0 += "    AND ZA4.ZA4_CODIGO	>	' '"								+ CRLF                               
	cQryDA0 += "    AND SB1.B1_ZLINHA > ' ' "									+ CRLF
	cQryDA0 += " 	AND	DA1.DA1_XENEEC	<>	'1' "								+ CRLF
	cQryDA0 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'"			+ CRLF
	cQryDA0 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryDA0 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryDA0 += " 	AND	DA1.DA1_PRCVEN > 1	   "								+ CRLF

	//Para execução manual só roda tabela selecionada
	If !empty(_ctabela)
		cQryDA0 += " 	AND DA0.DA0_CODTAB = '" + alltrim(_ctabela) + "' "  + CRLF
	Endif

	cQryDA0 += " ORDER BY DA0_CODTAB,SB1.B1_COD"											+ CRLF

	tcQuery cQryDA0 New Alias "QRYDA0"

return

/*/
===========================================================================================================================
{Protheus.doc} MontaIn
Monta In para a Query
@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
Static Function MontaIn(aSelFil)
	Local cRet := ""
	Local ni		:= 0

	For ni := 1 to len(aSelFil)
		aSelFil[ni] := StrTran(aSelFil[ni],"'","") // Retiro as aspas simples, para evitar erros na query
	Next

	If ! empty(aSelFil)
		cRet := " ( "
		For ni := 1 to len(aSelFil)
			cRet += "'" + aSelFil[ni] + "', "
		Next
		cRet := Subs(cRet,1, Len(cRet)-2) + " ) "
	Endif

Return cRet
