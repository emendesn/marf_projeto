// PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBFINBN
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@description
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@author TOTVS
@since 14/02/2020
@type Function
@table

@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBFINBN( cFilJob )

	U_MGFFINBN( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUFINBN
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@description
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@author TOTVS
@since 14/02/2020
@type Function
@table

@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUFINBN()

	runFINBN()
	//U_MGFFINBN( {"01","010001"} )

return

/*/
=============================================================================
{Protheus.doc} MGFFINBN
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@description
PROCESSAMENTO DO DELTA DOS DADOS FINANCEIROS
@author TOTVS
@since 14/02/2020
@type Function
@table
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFFINBN( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFFINBN] Iniciada Threads para a empresa - (' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() + ')' )

	runFINBN()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runFINBN
Integração de Clientes com Salesforce
@description
Integração de Clientes com Salesforce
@author TOTVS
@since 14/02/2020
@type Function
@table
@param
@return
 Sem retorno
@menu
 Sem menu
/*/
static procedure runFINBN()
	local aAreaX := getArea()

	//----------------------------------------------------------
	// INCLUI OU ATUALIZA ZF7 CASO TENHA ALTERAÇÃO FINANCEIRA NO CADASTRO DO CLIENTE OU NO LIMITE DE CREDITO ( V_LIMITES_CLIENTE )
	//----------------------------------------------------------
	updateZF7()

	restArea( aAreaX )
return



//----------------------------------------------------------
//  INCLUI OU ATUALIZA ZF7 CASO TENHA ALTERAÇÃO FINANCEIRA NO CADASTRO DO CLIENTE OU NO LIMITE DE CREDITO ( V_LIMITES_CLIENTE )
//----------------------------------------------------------
static procedure updateZF7()
	Local cNextAlias := GetNextAlias()
	Local aQuery     := {}
	Local nTotal     := 0
	Local nRegAtu	 := 1 //Registro sendo processado
	Local lNovoReg	 := .F.	//Precisa incluir novo registro na ZF7

	Local nHH, nMM , nSS, nMS, nMSIni, nMSFim

    nMS := seconds()
	nHH := int(nMS/3600)
	nMS -= (nHH*3600)
	nMM := int(nMS/60)
	nMS -= (nMM*60)
	nSS := int(nMS)
	nMSIni := (nMs - nSS)*1000

//Gera cusrsos com os registros alterados

BeginSQL Alias cNextAlias

	SELECT
		ZF7.R_E_C_N_O_ AS RECNO,
		TOTAL_PEDIDOS,
		TITULOS_ATRASADOS,
		LIMITE_CREDITO,
		LIMITE_UTILIZADO,
		( LIMITE_CREDITO - LIMITE_UTILIZADO ) as LIMITE_DISPONIVEL,
		COD_CLIENTE,
		LOJA_CLIENTE,
		SA1.A1_COD,
		SA1.A1_LOJA,
		SA1.A1_LC,
		round( SA1.A1_METR, 2 ) as A1_METR,
		SA1.A1_NROCOM,
		SA1.A1_NROPAG,
		SA1.A1_ULTCOM,
		round( SA1.A1_PAGATR, 2 ) as A1_PAGATR,
		round( SA1.A1_MSALDO, 2 ) as A1_MSALDO,
		round( SA1.A1_MCOMPRA, 2 ) as A1_MCOMPRA,
		SA1.A1_SALDUP,
		round( SA1.A1_ATR, 2 ) as A1_ATR,
		round( SA1.A1_VACUM, 2 ) as A1_VACUM,
		SA1.A1_MATR,
		round( SA1.A1_MAIDUPL, 2 ) as A1_MAIDUPL
	FROM
		%table:SA1010% SA1
			INNER JOIN V_LIMITES_CLIENTE V_LIMITE
			ON SA1.A1_LOJA = V_LIMITE.LOJA_CLIENTE AND
			SA1.A1_COD = V_LIMITE.COD_CLIENTE
				LEFT JOIN %table:ZF7010% ZF7
				ON ZF7.ZF7_LOJA = V_LIMITE.LOJA_CLIENTE AND
				ZF7.ZF7_COD = V_LIMITE.COD_CLIENTE AND
				ZF7.%notDel%
	WHERE
		SA1.%notDel% AND
		( SA1.A1_XIDSFOR <> ' ' OR
		  SA1.A1_ZCDECOM <> ' ' OR
		  SA1.A1_ZCDEREQ <> ' ' ) AND
		( ZF7.ZF7_TOTPVB <> V_LIMITE.TOTAL_PEDIDOS OR
		round( ZF7.ZF7_TITATB, 2 ) <> round( SA1.A1_PAGATR, 2 ) OR                  // ZF7.ZF7_TITATB <> V_LIMITE.TITULOS_ATRASADOS OR
		ZF7.ZF7_LCB <> SA1.A1_LC OR
		ZF7.ZF7_TLICRE <> V_LIMITE.LIMITE_CREDITO OR
		ZF7.ZF7_UTILIB <> V_LIMITE.LIMITE_UTILIZADO OR
		round( ZF7.ZF7_METRB, 2 ) <> round(SA1.A1_METR, 2 ) OR
		ZF7.ZF7_NROCOB <> SA1.A1_NROCOM OR
		ZF7.ZF7_NROPAB <> SA1.A1_NROPAG OR
		ZF7.ZF7_ULTCOB <> SA1.A1_ULTCOM OR
		round( ZF7.ZF7_PAGATB, 2 ) <> round( SA1.A1_ATR, 2 ) OR
		round( ZF7.ZF7_MSALDB, 2 ) <> round( SA1.A1_MSALDO, 2 ) OR
		round( ZF7.ZF7_MCOMPB, 2 ) <> round( SA1.A1_MCOMPRA,2 ) OR
		ZF7.ZF7_SALDUB <> SA1.A1_SALDUP OR
		ZF7.ZF7_ATRB <> SA1.A1_ATR OR
		round( ZF7.ZF7_VACUMB,2) <> round(SA1.A1_VACUM, 2) OR
		ZF7.ZF7_MATRB <> SA1.A1_MATR OR
		round( ZF7.ZF7_MAIDUB, 2) <> round(SA1.A1_MAIDUPL,2) OR
		ZF7.R_E_C_N_O_ IS NULL ) AND
		SA1.A1_EST <> 'EX'

	ORDER BY
		RECNO

EndSQL

nMS := seconds()
nHH := int(nMS/3600)
nMS -= (nHH*3600)
nMM := int(nMS/60)
nMS -= (nMM*60)
nSS := int(nMS)
nMSFim := (nMs - nSS)*1000

Count To nTotal
aQuery := GetLastQuery()

(cNextAlias)->(dbGoTop())
DbSelectArea("ZF7")

if nTotal > 0

	conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF7] -" + aQuery[2] ) //Query executada
	conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF7] Tempo de execucao da query : " + Alltrim(Str( nMSFim - nMSIni, 10) + 'ms')) //Tempo de execucao da query e Milesegundos
	conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF7] Quantidade de registros : " + Alltrim(Str(nTotal,10))) //Total de registros Processados
	conout( '[MGFFINBN] [SALESFORCE] [UPDATEZF7] Inicio Gravacao - (' + dToC(dDataBase) + ' - ' + time() + ')') //Data e hora do inicio da gravacao

	While !(cNextAlias)->(eof())

		If (cNextAlias)->RECNO > 0
			//Posicionará no registro correto
			ZF7->(dbGoto((cNextAlias)->RECNO))
			lNovoReg := .F.//Somente altera o registro na ZF7
		Else
			lNovoReg := .T. //Precisa incluir novo registro na ZF7
		EndIf

		begin transaction		

			if RecLock("ZF7", lNovoReg ) // ,, .F., IsBlind() )
					If lNovoReg
						ZF7->ZF7_COD := (cNextAlias)->A1_COD
						ZF7->ZF7_LOJA := (cNextAlias)->A1_LOJA
					EndIf
					ZF7->ZF7_MSALDB := (cNextAlias)->A1_MSALDO
					ZF7->ZF7_MCOMPB := (cNextAlias)->A1_MCOMPRA
					ZF7->ZF7_SALDUB := (cNextAlias)->A1_SALDUP
					ZF7->ZF7_ATRB   := (cNextAlias)->A1_ATR
					ZF7->ZF7_VACUMB := (cNextAlias)->A1_VACUM
					ZF7->ZF7_MATRB  := (cNextAlias)->A1_MATR
					ZF7->ZF7_MAIDUB := (cNextAlias)->A1_MAIDUPL
					ZF7->ZF7_ZVALAB := U_MGFFATB3((cNextAlias)->A1_COD,(cNextAlias)->A1_LOJA, .T.)
					ZF7->ZF7_LCB    := (cNextAlias)->A1_LC
					ZF7->ZF7_UTILIB := (cNextAlias)->LIMITE_UTILIZADO
					ZF7->ZF7_HASHB  := fwUUIDv4()
					ZF7->ZF7_METRB  := (cNextAlias)->A1_METR
					ZF7->ZF7_NROCOB := (cNextAlias)->A1_NROCOM
					ZF7->ZF7_NROPAB := (cNextAlias)->A1_NROPAG
					ZF7->ZF7_ULTCOB := STOD((cNextAlias)->A1_ULTCOM)
					ZF7->ZF7_TOTPVB := (cNextAlias)->TOTAL_PEDIDOS
					ZF7->ZF7_PAGATB := (cNextAlias)->A1_ATR
					ZF7->ZF7_TITATB := (cNextAlias)->A1_PAGATR // (cNextAlias)->TITULOS_ATRASADOS

					ZF7->ZF7_DTAPRO := dtoc( dDatabase ) + '-' + time() // Data e hr do processamento

					ZF7->ZF7_TLICRE := (cNextAlias)->LIMITE_CREDITO
					ZF7->ZF7_TLIUTI := (cNextAlias)->LIMITE_UTILIZADO
					ZF7->ZF7_TLIDIS := (cNextAlias)->LIMITE_DISPONIVEL
				ZF7->( MsUnlock() )
			else
				DisarmTransaction()
				conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF7] Operacao : " + iif( lNovoReg, '[Incluir]', '[Alterar]' ) )
				conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF7] Recno : " + Alltrim(Str((cNextAlias)->RECNO,10)))
			endif

		end transaction

		(cNextAlias)->(DbSkip())
		nRegAtu++
	EndDo

	conout( '[MGFFINBN] [SALESFORCE] [UPDATEZF7] Final Gravacao - (' + dToC(dDataBase) + ' - ' + time() + ')') //Data e hora do termino da gravacao

EndIf

(cNextAlias)->(DbClosearea())
ZF7->(DbClosearea())

return
