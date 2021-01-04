#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

#define CRLF chr(13) + chr(10)

static _aErr
/*
=====================================================================================
Programa.:              MGFWSS06
Autor....:              Gustavo Ananias Afonso
Data.....:              15/12/2017
Descricao / Objetivo:   WS para processar Retorno dos Clientes do SFA
Doc. Origem:            GAP
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
WSSTRUCT WSS06_REQ
	WSDATA recnosa1	as integer
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS06_RESP
	WSDATA status		as string
	WSDATA observacao	as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS06 DESCRIPTION "Retorno de Clientes de SFA" namespace "http://www.totvs.com.br/MGFWSS06"
	WSDATA clienteRequest	AS WSS06_REQ
	WSDATA clienteResponse	AS WSS06_RESP

	WSMETHOD atualizaClienteSFA		DESCRIPTION "Atualiza status do Cliente para Integrado com SFA"
	WSMETHOD atualizaEndEntregaSFA	DESCRIPTION "Atualiza status do Endereco de Entrega para Integrado com SFA"
ENDWSSERVICE

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD atualizaClienteSFA WSRECEIVE clienteRequest WSSEND clienteResponse WSSERVICE MGFWSS06
	local lOk		:= .T.
	local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	local cUpdSA1	:= ""

	::clienteResponse := WSClassNew( "WSS06_RESP")

	BEGIN SEQUENCE
		cUpdSA1 := "UPDATE " + retSQLName("SA1") + " SET A1_XINTEGX = 'I' WHERE R_E_C_N_O_ = " + allTrim( str( ::clienteRequest:recnosa1 ) )

		if tcSQLExec( cUpdSA1 ) < 0
			::clienteResponse:status		:= '0'
			::clienteResponse:observacao	:= 'Problema na atualizacao do cliente ' + allTrim( str( ::clienteRequest:recnosa1 ) ) + '. Erro: ' + tcSQLError()
		else
			::clienteResponse:status		:= '1'
			::clienteResponse:observacao	:= 'Cliente ' + allTrim( str( ::clienteRequest:recnosa1 ) ) + ' atualizado'
		endif
	RECOVER
		conout('[MGFWSS06] [SFA] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE		

	if valType(_aErr) == 'A'
		::clienteResponse:status		:= _aErr[1]
		::clienteResponse:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD atualizaEndEntregaSFA WSRECEIVE clienteRequest WSSEND clienteResponse WSSERVICE MGFWSS06
	local lOk		:= .T.
	local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	local cUpdSZ9	:= ""

	::clienteResponse := WSClassNew( "WSS06_RESP")

	BEGIN SEQUENCE
		cUpdSZ9 := "UPDATE " + retSQLName("SZ9") + " SET Z9_XINTEGX = 'I' WHERE R_E_C_N_O_ = " + allTrim( str( ::clienteRequest:recnosa1 ) )

		if tcSQLExec( cUpdSZ9 ) < 0
			::clienteResponse:status		:= '0'
			::clienteResponse:observacao	:= 'Problema na atualizacao do endereco entrega ' + allTrim( str( ::clienteRequest:recnosa1 ) ) + '. Erro: ' + tcSQLError()
		else
			::clienteResponse:status		:= '1'
			::clienteResponse:observacao	:= 'Endereco entrega ' + allTrim( str( ::clienteRequest:recnosa1 ) ) + ' atualizado'
		endif
	RECOVER
		conout('[MGFWSS06] [SFA] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE		

	if valType(_aErr) == 'A'
		::clienteResponse:status		:= _aErr[1]
		::clienteResponse:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function MyError(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	nQtd := iif(nQtd > 4,4,nQtd) //Retorna as 4 linhas 

	for ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( "[MGFWSS06] [SFA] Deu Erro " + oError:Description )
	_aErr := { '0', cEr }
	break

return .T.
