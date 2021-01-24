#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFTAE31
Rotina para a integração para receber o Json gerado pelo sistema Taura do titulo de antecipação financeira para a transportadora
@type function
@author Paulo da Mata
@since 20/07/2020
@version 1.0
/*/

WSSTRUCT FTAE31_ANTCAB

	WSDATA E2_EMISSAO   as String
	WSDATA E2_FILIAL    as String
	WSDATA E2_NATUREZ 	as String
	WSDATA E2_NUM	    as String
	WSDATA ACAO 	    as String
	WSDATA CNPJ 		as String
	
ENDWSSTRUCT

WSSTRUCT FTAE31_ANTITEM
	WSDATA E2_PARCELA   as String
	WSDATA E2_VENCTO    as String
	WSDATA E2_VENCREA   as String
	WSDATA E2_VALOR     as Float
ENDWSSTRUCT	

WSSTRUCT FTAE31_ANTECIPA
	WSDATA CAB  as FTAE31_ANTCAB
	WSDATA ITEM	as array of FTAE31_ANTITEM
ENDWSSTRUCT

WSSTRUCT FTAE31_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE31 DESCRIPTION "Importação - Antecipação Financeira para Transportadora" NameSpace "http://www.totvs.com.br/MGFTAE31"
	WSDATA WSANTECIPA as FTAE31_ANTECIPA
	WSDATA WSRETORNO  as FTAE31_RETORNO

	WSMETHOD GravarAntecipa DESCRIPTION "Importação - Antecipação Financeira para Transportadora"	
ENDWSSERVICE

WSMETHOD GravarAntecipa WSRECEIVE WSANTECIPA WSSEND WSRETORNO WSSERVICE MGFTAE31

	Local nY        := 0

	Local aItParc   := {}
	Local aItens    := {}

	Private aRetorno := {}

	// Preenche o array aItens para criar os campos do titulo com dados do JSON
	aItens := {}

	For nY := 1 to Len(::WSANTECIPA:ITEM)

		aItParc := {}

		AADD(aItParc, ::WSANTECIPA:ITEM[nY]:E2_PARCELA)						// 1 - PARCELA    
		AADD(aItParc, StoD(::WSANTECIPA:ITEM[nY]:E2_VENCTO))				// 2 - VENCIMENTO
		AADD(aItParc, DataValida(StoD(::WSANTECIPA:ITEM[nY]:E2_VENCREA)))	// 3 - VENCIMENTO REAL
		AADD(aItParc, ::WSANTECIPA:ITEM[nY]:E2_VALOR)						// 4 - VALOR

		AADD(aItens, aItParc)

	Next nY

	aRetorno := U_MGFTAE33(::WSANTECIPA:CAB:E2_FILIAL,;
					      ::WSANTECIPA:CAB:E2_NATUREZ,;
					      ::WSANTECIPA:CAB:E2_NUM,;
					      ::WSANTECIPA:CAB:ACAO,;
					      ::WSANTECIPA:CAB:CNPJ,;
					      StoD(::WSANTECIPA:CAB:E2_EMISSAO),;
					      aItens)

	If Empty(aRetorno)
		AADD(aRetorno ,"2")
		AADD(aRetorno,'Erro indeterminado.')
	EndIf

	::WSRETORNO := WSClassNew( "FTAE31_RETORNO")
	::WSRETORNO:STATUS  := aRetorno[1]
	::WSRETORNO:MSG	    := aRetorno[2]

Return .T.
