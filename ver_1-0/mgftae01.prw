#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE01
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio Pedido de Compra de Gado - Parte WS Server consumir o Metodo Gerar Pedido
================================================/==========================================================
*/

WSSTRUCT FTAE01_PEDMESTRE
	WSDATA C7_ACAO	   as String
	WSDATA C7_FILIAL   as String
	WSDATA C7_NUM	   as String
	WSDATA C7_EMISSAO  as String
	WSDATA C7_FORNECE  as String
	WSDATA C7_LOJA     as String
	WSDATA C7_CNPJ     as String
	WSDATA C7_CODEXP   as String
    WSDATA C7_COND     as String      
    WSDATA ID_FAZENDA  as String      
ENDWSSTRUCT

WSSTRUCT FTAE01_PEDITEM
	WSDATA C7_ITEM    as String
	WSDATA C7_PRODUTO as String
	WSDATA C7_QUANT   as float
	WSDATA C7_PRECO   as float
	WSDATA C7_DATPRF  as String
ENDWSSTRUCT

WSSTRUCT FTAE01_PEDIDO
	WSDATA CAB	    as FTAE01_PEDMESTRE
	WSDATA ITEM		as array of FTAE01_PEDITEM
ENDWSSTRUCT

WSSTRUCT FTAE01_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE01 DESCRIPTION "Importação Pedido de Compra de Gado" NameSpace "http://www.totvs.com.br/MGFTAE01"
	WSDATA WSPEDIDO	 as FTAE01_PEDIDO
	WSDATA WSRETORNO as FTAE01_RETORNO

	WSMETHOD GravarPedido DESCRIPTION "Importação Pedido de Compra de Gado"	
ENDWSSERVICE

WSMETHOD GravarPedido WSRECEIVE WSPEDIDO WSSEND WSRETORNO WSSERVICE MGFTAE01
Local aITEM    := {}
Local aLine    := {}
Local nI       := 0 
Private aRetorno := {}
                      
aITEM := {}
For nI := 1 To Len(::WSPEDIDO:ITEM)
	aLine := {}
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:C7_ITEM)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:C7_PRODUTO)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:C7_QUANT)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:C7_PRECO)
	AAdd(aLine, STOD(::WSPEDIDO:ITEM[nI]:C7_DATPRF))
	AAdd(aITEM, aLine)
Next NI

aRetorno :=  U_MGFTAE02(::WSPEDIDO:CAB:C7_ACAO,;
                        ::WSPEDIDO:CAB:C7_NUM,; 
						STOD(::WSPEDIDO:CAB:C7_EMISSAO),;
	                    ::WSPEDIDO:CAB:C7_FORNECE,;
						::WSPEDIDO:CAB:C7_LOJA,;
						::WSPEDIDO:CAB:C7_COND,;
						::WSPEDIDO:CAB:C7_FILIAL,;
						aITEM,;
						::WSPEDIDO:CAB:C7_CNPJ ,;
						::WSPEDIDO:CAB:C7_CODEXP,;
						::WSPEDIDO:CAB:ID_FAZENDA)

::WSRETORNO := WSClassNew( "FTAE01_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

Return .T.



