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

	conout( '[MGFFINBN] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

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
static function runFINBN()
	local aAreaX		:= getArea()

	//----------------------------------------------------------
	// INCLUI OU ATUALIZA ZF7 CASO TENHA ALTERAÇÃO FINANCEIRA NO CADASTRO DO CLIENTE OU NO LIMITE DE CREDITO ( V_LIMITES_CLIENTE )
	//----------------------------------------------------------
	updateZF7()

	restArea( aAreaX )
return



//----------------------------------------------------------
//  INCLUI OU ATUALIZA ZF7 CASO TENHA ALTERAÇÃO FINANCEIRA NO CADASTRO DO CLIENTE OU NO LIMITE DE CREDITO ( V_LIMITES_CLIENTE )
//----------------------------------------------------------
static function updateZF7()
	Local cNextAlias := GetNextAlias()
	Local aQuery := {}
	Local nTotal := 0
	Local nRegAtu	:= 1 //Registro sendo processado
	Local lNovoReg	:= .F.	//Precisa incluir novo registro na ZF7

//Gera cusrsos com os registros alterados

BeginSQL Alias cNextAlias

	SELECT
		ZF7.R_E_C_N_O_ AS RECNO,
		TOTAL_PEDIDOS,
		TITULOS_ATRASADOS,
		LIMITE_CREDITO,
		LIMITE_UTILIZADO,
		COD_CLIENTE,
		LOJA_CLIENTE,
		A1_COD,
		A1_LOJA,
		A1_METR,
		A1_NROCOM,
		A1_NROPAG,
		A1_ULTCOM,
		A1_PAGATR,
		A1_MSALDO,
		A1_MCOMPRA,
		A1_SALDUP,
		A1_ATR,
		A1_VACUM,
		A1_MATR,
		A1_MAIDUPL 
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
		( A1_XIDSFOR <> ' ' OR
		SA1.A1_ZCDECOM <> ' ' OR
		SA1.A1_ZCDEREQ <> ' ' )AND
		(ZF7.ZF7_TOTPVB <> V_LIMITE.TOTAL_PEDIDOS OR
		ZF7.ZF7_TITATB <> V_LIMITE.TITULOS_ATRASADOS OR
		ZF7.ZF7_LCB <> V_LIMITE.LIMITE_CREDITO OR
		ZF7.ZF7_UTILIB <> V_LIMITE.LIMITE_UTILIZADO OR
		ZF7_METRB <> SA1.A1_METR OR
		ZF7_NROCOB <> SA1.A1_NROCOM OR
		ZF7_NROPAB <> SA1.A1_NROPAG OR
		ZF7_ULTCOB <> SA1.A1_ULTCOM OR
		ZF7_PAGATB <> SA1.A1_PAGATR OR
		ZF7.ZF7_MSALDB <> SA1.A1_MSALDO OR
		ZF7.ZF7_MCOMPB <> SA1.A1_MCOMPRA OR
		ZF7.ZF7_SALDUB <> SA1.A1_SALDUP OR
		ZF7.ZF7_ATRB <> SA1.A1_ATR OR
		ZF7.ZF7_VACUMB <> SA1.A1_VACUM OR
		ZF7.ZF7_MATRB <> SA1.A1_MATR OR
		ZF7.ZF7_MAIDUB <> SA1.A1_MAIDUPL OR
		ZF7.R_E_C_N_O_ IS NULL )
	ORDER BY
		RECNO

EndSQL

Count To nTotal
aQuery := GetLastQuery()

(cNextAlias)->(dbGoTop())

DbSelectArea("ZF7")

While !(cNextAlias)->(eof())

	If (cNextAlias)->RECNO > 0
		//Posicionará no registro correto
		ZF7->(dbGoto((cNextAlias)->RECNO))
	Else
		lNovoReg := .T. //Precisa incluir novo registro na ZF7
	EndIf

	RecLock("ZF7",lNovoReg)
		If lNovoReg
			ZF7->ZF7_COD := (cNextAlias)->A1_COD
			ZF7->ZF7_LOJA := (cNextAlias)->A1_LOJA
		EndIf
		ZF7->ZF7_MSALDB := (cNextAlias)->A1_MSALDO
		ZF7->ZF7_MCOMPB := (cNextAlias)->A1_MCOMPRA
		ZF7->ZF7_SALDUB := (cNextAlias)->A1_SALDUP
		ZF7->ZF7_ATRB := (cNextAlias)->A1_ATR
		ZF7->ZF7_VACUMB := (cNextAlias)->A1_VACUM
		ZF7->ZF7_MATRB := (cNextAlias)->A1_MATR
		ZF7->ZF7_MAIDUB := (cNextAlias)->A1_MAIDUPL
		ZF7->ZF7_LCB := (cNextAlias)->LIMITE_CREDITO
		ZF7->ZF7_UTILIB := (cNextAlias)->LIMITE_UTILIZADO
		ZF7->ZF7_HASHB := fwUUIDv4()
		ZF7->ZF7_METRB := (cNextAlias)->A1_METR
		ZF7->ZF7_NROCOB := (cNextAlias)->A1_NROCOM
		ZF7->ZF7_NROPAB := (cNextAlias)->A1_NROPAG
		ZF7->ZF7_ULTCOB := STOD((cNextAlias)->A1_ULTCOM)
		ZF7->ZF7_TOTPVB := (cNextAlias)->TOTAL_PEDIDOS
		ZF7->ZF7_PAGATB := (cNextAlias)->A1_PAGATR
		ZF7->ZF7_TITATB := (cNextAlias)->TITULOS_ATRASADOS
	MsUnlock()
	(cNextAlias)->(DbSkip())
	nRegAtu++
EndDo



	conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF72] " + aQuery[2] ) //Query executada
	conout( "[MGFFINBN] [SALESFORCE] [UPDATEZF72] Quantidade de registros " + Alltrim(Str(nTotal,10))) //Query executada

	(cNextAlias)->(DbClosearea())
	ZF7->(DbClosearea())

return
