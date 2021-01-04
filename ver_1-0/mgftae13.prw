#include "totvs.ch"                                                 
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE13
Autor....:              Marcelo Carneiro         
Data.....:              21/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio Pedido Abate - Parte WS Server consumir o Metodo GravarAbate
==========================================================================================================
*/

WSSTRUCT FTAE13_PEDMESTRE
	WSDATA ACAO              as String
	WSDATA FILIAL            as String
	WSDATA NUM_PEDIDO        as String
	WSDATA COD_FORNECEDOR    as String
	WSDATA LOJA              as String      
	WSDATA CNPJ_FORNECEDOR   as String
	WSDATA CODEXP_FORNECEDOR as String
	WSDATA DAT_EMISSAO       as String
	WSDATA DAT_PROD_ABATE    as String
	WSDATA VAL_DESCONTO      as Float
	WSDATA VAL_ACRESCIMO     as Float
	WSDATA NUM_GTA           as String
	WSDATA DATA_VENCIMENTO   as String
	WSDATA VAL_DUPLICATA     as Float 
	WSDATA FAVORECIDO        as String
	WSDATA LOJAFAV           as String
	WSDATA BANCO             as String
	WSDATA AGENCIA           as String
	WSDATA CONTA             as String
	WSDATA ID_FAZENDA  		 as String                            
	WSDATA TIPO_CONTA        as String OPTIONAL  
ENDWSSTRUCT

WSSTRUCT FTAE13_PEDITEM
	WSDATA ITEM       as String
	WSDATA COD_PROD   as String
	WSDATA QUANT_CAB  as Float
	WSDATA QUANT_KG   as Float
	WSDATA VAL_TOTAL  as Float
	WSDATA VAL_ARROBA as Float
ENDWSSTRUCT

WSSTRUCT FTAE13_MAPA
	WSDATA NUM_SEMADE    as String
	WSDATA NUM_MAPA      as String
	WSDATA VAL_TOT_INC   as Float
	WSDATA VAL_IDATERRA  as Float
ENDWSSTRUCT


WSSTRUCT FTAE13_PEDIDO
	WSDATA CAB	    as FTAE13_PEDMESTRE
	WSDATA ITEM		as array of FTAE13_PEDITEM
	WSDATA MAPA		as array of FTAE13_MAPA
ENDWSSTRUCT

WSSTRUCT FTAE13_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE13 DESCRIPTION "Importação Pedido de Abate de Gado" NameSpace "http://www.totvs.com.br/MGFTAE13"
	WSDATA WSPEDIDO	 as FTAE13_PEDIDO
	WSDATA WSRETORNO as FTAE13_RETORNO

	WSMETHOD GravarAbate DESCRIPTION "Importação Pedido de Abate de Gado"	
ENDWSSERVICE

WSMETHOD GravarAbate  WSRECEIVE WSPEDIDO WSSEND WSRETORNO WSSERVICE MGFTAE13
Local aITEM    := {}            
Local aMAPA    := {}
Local aLine    := {}
Local nI       := 0 
Private aRetorno := {}
                      
aITEM := {}
For nI := 1 To Len(::WSPEDIDO:ITEM)
	aLine := {}
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:ITEM)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:COD_PROD)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:QUANT_CAB)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:QUANT_KG)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:VAL_TOTAL)
	AAdd(aLine, ::WSPEDIDO:ITEM[nI]:VAL_ARROBA)
	AAdd(aITEM, aLine)
Next NI

aMAPA := {}
For nI := 1 To Len(::WSPEDIDO:MAPA)
	aLine := {}
	AAdd(aLine, ::WSPEDIDO:MAPA[nI]:NUM_SEMADE)
	AAdd(aLine, ::WSPEDIDO:MAPA[nI]:NUM_MAPA)
	AAdd(aLine, ::WSPEDIDO:MAPA[nI]:VAL_TOT_INC)
	AAdd(aLine, ::WSPEDIDO:MAPA[nI]:VAL_IDATERRA)
	AAdd(aMAPA, aLine)
Next NI

aRetorno :=  U_MGFTAE14(::WSPEDIDO:CAB:ACAO,;            
                        ::WSPEDIDO:CAB:FILIAL,;          
						::WSPEDIDO:CAB:NUM_PEDIDO,;      
	                    ::WSPEDIDO:CAB:COD_FORNECEDOR,;  
						::WSPEDIDO:CAB:LOJA,;            
						::WSPEDIDO:CAB:DAT_EMISSAO,;     
						::WSPEDIDO:CAB:DAT_PROD_ABATE,;
						::WSPEDIDO:CAB:VAL_DESCONTO,;    
						::WSPEDIDO:CAB:VAL_ACRESCIMO,;   
						::WSPEDIDO:CAB:NUM_GTA,;         
						::WSPEDIDO:CAB:DATA_VENCIMENTO,; 
						::WSPEDIDO:CAB:VAL_DUPLICATA,;   
						::WSPEDIDO:CAB:FAVORECIDO,;      
						::WSPEDIDO:CAB:LOJAFAV,;      
						::WSPEDIDO:CAB:BANCO,;           
						::WSPEDIDO:CAB:AGENCIA,;         
						::WSPEDIDO:CAB:CONTA,;			 
						aITEM,;
						aMapa,;
						::WSPEDIDO:CAB:CNPJ_FORNECEDOR ,;
						::WSPEDIDO:CAB:CODEXP_FORNECEDOR,;
						::WSPEDIDO:CAB:ID_FAZENDA,;
						::WSPEDIDO:CAB:TIPO_CONTA)

::WSRETORNO := WSClassNew( "FTAE13_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

Return .T.



