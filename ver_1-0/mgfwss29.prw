#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
{Protheus.doc} MGFWSS29
Integra��o de Fornedores

@description
Este programa ir� preparar o Json na tabela ZH3 para integra��o de fornecedores.
Integra��o no cadastro de fornecedores - MGFIN81.PRW

@author Edson Bella Gon�alves
@since 10/11/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function
@table
	SA2 - Fornecedores
	ZH3 - controle de Integra��es via WS
@param
@return

@menu
@history
/*/

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS29_FORNECEDOR
	WSDATA A2_COD		AS STRING OPTIONAL
	WSDATA A2_LOJA		AS STRING OPTIONAL
	WSDATA A2_TIPO		AS STRING OPTIONAL
	WSDATA A2_NOME		AS STRING OPTIONAL
	WSDATA A2_ZDTNASC	AS STRING OPTIONAL
	WSDATA A2_ZNASCIO	AS STRING OPTIONAL
	WSDATA A2_ZTPENDE	AS STRING OPTIONAL
	WSDATA A2_CGC		AS STRING
	WSDATA A2_ZTPFORN   AS STRING OPTIONAL
	WSDATA A2_NREDUZ    AS STRING OPTIONAL
	WSDATA A2_END       AS STRING OPTIONAL
	WSDATA A2_BAIRRO    AS STRING OPTIONAL
	WSDATA A2_EST       AS STRING OPTIONAL
	WSDATA A2_COD_MUN   AS STRING OPTIONAL
	WSDATA A2_CEP       AS STRING OPTIONAL
	WSDATA A2_ENDCOMP   AS STRING OPTIONAL
	WSDATA A2_DDD       AS STRING OPTIONAL
	WSDATA A2_DDI       AS STRING OPTIONAL
	WSDATA A2_TEL       AS STRING OPTIONAL
//	WSDATA A2_PAISDES   AS STRING OPTIONAL
	WSDATA A2_PAIS      AS STRING OPTIONAL
	WSDATA A2_EMAIL     AS STRING OPTIONAL
	WSDATA A2_INSCR     AS STRING OPTIONAL
	WSDATA A2_CODPAIS   AS STRING OPTIONAL
	WSDATA A2_CNAE      AS STRING OPTIONAL
	WSDATA A2_ZOBSERV   AS STRING OPTIONAL
	WSDATA A2_TPESSOA   AS STRING OPTIONAL
	WSDATA A2_GRPTRIB   AS STRING OPTIONAL
	WSDATA A2_NATUREZ   AS STRING OPTIONAL
	WSDATA A2_CONTA     AS STRING OPTIONAL
	WSDATA A2_ZEMINFE   AS STRING OPTIONAL
	WSDATA A2_TIPORUR   AS STRING OPTIONAL
//	WSDATA A2_MSBLQL   	AS STRING OPTIONAL
	WSDATA A2_ZPROPRI   AS STRING OPTIONAL
	WSDATA A2_ZCCIR		AS STRING OPTIONAL
	WSDATA A2_ZNIRF		AS STRING OPTIONAL
	WSDATA A2_ZCAR		AS STRING OPTIONAL
	WSDATA A2_ZDDDCEL	AS STRING OPTIONAL
	WSDATA A2_ZCELULA	AS STRING OPTIONAL
	WSDATA A2_ZIDCRM	AS STRING OPTIONAL
	WSDATA ZH3_CODID	AS STRING OPTIONAL
	WSDATA CGCVINCULO	AS STRING OPTIONAL
//dados do banco
	WSDATA FIL_AGENCI	AS STRING optional
	WSDATA FIL_BANCO	AS STRING optional
	WSDATA FIL_CONTA	AS STRING optional
	WSDATA FIL_DVAGE	AS STRING optional
	WSDATA FIL_DVCTA	AS STRING optional
	WSDATA FIL_TIPCTA	AS STRING optional
	WSDATA FIL_TIPO		AS STRING optional
	WSDATA FIL_DETRAC	AS STRING optional
	WSDATA FIL_MOEDA 	AS STRING optional
	WSDATA FIL_MOVCTO	AS STRING optional
//
	WSDATA NEWUPD		AS STRING OPTIONAL //3-novo 4-altera��o
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS29_RETURN
	WSDATA 	id			AS STRING
	WSDATA	hash		AS STRING
	WSDATA	status		AS STRING
ENDWSSTRUCT

// Estrutura de dados. Montagem do Array para retorno fornecedor UPD
WSSTRUCT aRetUpdArray
	WSDATA ForUArray	AS Array OF WSS29_FORNECEDOR
ENDWSSTRUCT 

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS29 DESCRIPTION "Integra��o Fornecedor - tabela intermedi�ria" namespace "http://www.totvs.com.br/MGFWSS29"
	WSDATA fornecedor		AS WSS29_FORNECEDOR
	WSDATA response			AS WSS29_RETURN
	
	WSMETHOD insertOrUpdateFornecedor	DESCRIPTION "Inclus�o / Atualiza��o Fornecedor do Protheus - Ass�ncrono"
ENDWSSERVICE

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD insertOrUpdateFornecedor WSRECEIVE fornecedor WSSEND response WSSERVICE MGFWSS29

	setFunName( "MGFWSS29" )

	U_MFCONOUT( "[MGFWSS29] Integra��o Fornecedor - in�cio da gera��o ZH3")

	cJson := FWJsonSerialize(fornecedor,.T.,.T.)

	dbSelectArea("ZH3")
	RecLock("ZH3",.t.)

	ZH3->ZH3_HASH	:=fwUUIDv4()
	ZH3->ZH3_CODID	:=fornecedor:ZH3_CODID
	ZH3->ZH3_CODINT	:='008'
	ZH3->ZH3_CODTIN	:='018'
	ZH3->ZH3_REQUES :=cJson
	ZH3->ZH3_DTRECE	:=DtoC(date())
	ZH3->ZH3_HRRECE	:=time()
	ZH3->ZH3_RESULT	:='INSERIDO O JSON - MGFWSS29'
	ZH3->ZH3_STATUS	:='0' //pronto para integrar
	//ZH3->ZH3_RETURN - Retorno da Integra��o
	
	MsUnlock()

	::response:id				:=fornecedor:ZH3_CODID
	::response:hash				:=ZH3->ZH3_HASH
	::response:status			:=ZH3->ZH3_STATUS

	U_MFCONOUT( "[MGFWSS29] Integra��o Fornecedor - t�rmino da gera��o ZH3")

return .T.

/*
user Function _ebg()

	RpcSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); Else; RpcSetEnv( "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); endif


nHdl     := fCreate("SA2OBRIG")

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SA2")
While !Eof() .and. X3_ARQUIVO=="SA2"
 If X3OBRIGAT(X3_CAMPO)
	fWrite(nHdl, X3_CAMPO+" - "+X3_DESCRIC + CRLF)
 End
 dbSkip()
End

fClose("SA2OBRIG")
*/