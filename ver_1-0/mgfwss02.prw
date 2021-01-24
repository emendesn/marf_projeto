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
Programa.:              MGFWSS02
Autor....:              Gustavo Ananias Afonso
Data.....:              30/09/2016
Descricao / Objetivo:   WS para importação de Pedido de Vendas para o Protheus
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
WSSTRUCT CABECALHOSC5
	WSDATA filial		as string
	WSDATA tipo			as string
	WSDATA cliente		as string
	WSDATA tpped		as string
	WSDATA idTablet		as string //Leo- Informação virá do tablet
	WSDATA vend			as string
	WSDATA enderent		as string
	WSDATA condpagto	as integer
	WSDATA tabelapreco	as integer
	WSDATA dtEntrega	as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT ITEMSC6
	WSDATA item			as string
	WSDATA produto		as string
	WSDATA quantidade	as float
	WSDATA preco		as float
	WSDATA dtMin		as string
	WSDATA dtMax		as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT PEDIDO
	WSDATA cabecalho	as CABECALHOSC5
	WSDATA itens		as array of ITEMSC6
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT RETORNO
	WSDATA status		as string
	WSDATA observacao	as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT CONSULTA_REQUISICAO
	WSDATA filial	as string
	WSDATA idSFA	as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT CONSULTA_RETORNO
	WSDATA idSFA				as string
	WSDATA pedidoProtheus		as string
	WSDATA status				as string
	WSDATA obs					as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS02 DESCRIPTION "Importação de Pedido de Venda" namespace "http://www.totvs.com.br/MGFWSS02"
	WSDATA pedido			as PEDIDO
	WSDATA retorno			as RETORNO
	WSDATA helloRequest		as string
	WSDATA helloReponse		as string
	WSDATA idsfa			as string
	WSDATA consultaResponse	AS CONSULTA_RETORNO
	WSDATA consultaRequest	AS CONSULTA_REQUISICAO

	WSMETHOD importaPedidoVenda		DESCRIPTION "Importa Pedido de Venda para o Protheus"
	WSMETHOD consultaPedidoVenda	DESCRIPTION "Consulta status do Pedido de Venda enviado ao Protheus"
ENDWSSERVICE

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD consultaPedidoVenda WSRECEIVE consultaRequest WSSEND consultaResponse WSSERVICE MGFWSS02
	local cFilReq	:= left( allTrim( ::consultaRequest:filial )	, tamSX3("ZC5_FILIAL")[1]	) // garante o tamanho do campo para fazer o seek
	local cIDSFA	:= left( allTrim( ::consultaRequest:idSFA )		, tamSX3("ZC5_IDSFA")[1]	)

	::consultaResponse := WSClassNew( "CONSULTA_RETORNO")

	DBSelectArea( "ZC5" )
	ZC5->( DBSetOrder( 1 ) )
	if ZC5->( DBSeek( cFilReq + cIDSFA ) )
		::consultaResponse:idSFA			:= cIDSFA
		::consultaResponse:pedidoProtheus	:= ZC5->ZC5_PVPROT
		::consultaResponse:status			:= ZC5->ZC5_STATUS
		::consultaResponse:obs				:= ZC5->ZC5_OBS
	else
		::consultaResponse:idSFA			:= cIDSFA
		::consultaResponse:pedidoProtheus	:= ""
		::consultaResponse:status			:= "4"
		::consultaResponse:obs				:= "ID enviado nao encontrado"
	endif

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD importaPedidoVenda WSRECEIVE pedido WSSEND retorno WSSERVICE MGFWSS02

local lOk		:= .T.

setFunName( "MGFWSS02" )

DBSelectArea( "ZC5" )
DBSelectArea( "ZC6" )

ZC5->( DBSetOrder( 1 ) )

::retorno := WSClassNew( "RETORNO" )

U_MFCONOUT("[MGFWSS02] [SFA] Recebida requisicao - IDTABLET: " + ::pedido:cabecalho:idTablet)

//Verifica se há outra instância gravando o mesmo idsfa
If mayiusecode(alltrim(::pedido:cabecalho:idTablet))

	if !ZC5->( DBSeek( allTrim( pedido:cabecalho:filial ) + left( ::pedido:cabecalho:idTablet, tamSx3("ZC5_IDSFA")[1] ) ) )
		BEGIN TRANSACTION
			if recLock("ZC5", .T.)
				U_MFCONOUT("Gravando ZC5 do pedido " + ::pedido:cabecalho:idTablet)
				ZC5->ZC5_FILIAL	:= allTrim(pedido:cabecalho:filial)
				ZC5->ZC5_CLIENT	:= pedido:cabecalho:cliente
				ZC5->ZC5_TABELA	:= pedido:cabecalho:tabelapreco
				ZC5->ZC5_CONDPG	:= pedido:cabecalho:condpagto
				ZC5->ZC5_ZTIPPE	:= pedido:cabecalho:tpPed
				ZC5->ZC5_ZTIPOP	:= allTrim( getMv( "MGF_SFATIP" ) ) //"BJ"
				ZC5->ZC5_VENDED	:= pedido:cabecalho:vend

				ZC5->ZC5_ORIGEM := U_MGFINT68( 2 , funName() )

				if !empty( pedido:cabecalho:dtEntrega )
					ZC5->ZC5_DTENTR	:= sToD( allTrim( pedido:cabecalho:dtEntrega ) )
				endif

				if val( pedido:cabecalho:enderent ) > 0
					ZC5->ZC5_ZIDEND	:=  strZero( val( pedido:cabecalho:enderent ) , 9 )
				endif

				ZC5->ZC5_STATUS	:= "1" // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

				ZC5->ZC5_IDSFA	:= ::pedido:cabecalho:idTablet
				ZC5->ZC5_HRRECE	:= time() // Hr Recebido
				ZC5->ZC5_DTRECE	:= date()

				ZC5->ZC5_INTEGR	:= "P" // Apos gerado pedido e retornado ao SFA muda para Integrado

				ZC5->( msUnlock() )

				for nI := 1 to len(pedido:itens)
					if recLock("ZC6", .T.)
						U_MFCONOUT("Gravando ZC6 item " + pedido:itens[ nI ]:item + " do pedido " + ::pedido:cabecalho:idTablet)
						ZC6->ZC6_FILIAL	:= allTrim(pedido:cabecalho:filial)
						ZC6->ZC6_ITEM	:= pedido:itens[ nI ]:item
						ZC6->ZC6_PRODUT	:= alltrim( pedido:itens[ nI ]:produto )
						ZC6->ZC6_QTDVEN	:= pedido:itens[ nI ]:quantidade
						ZC6->ZC6_PRCVEN	:= pedido:itens[ nI ]:preco
						ZC6->ZC6_OPER	:= allTrim( getMv( "MGF_SFATIP" ) )//"BJ"
						ZC6->ZC6_IDSFA	:= ::pedido:cabecalho:idTablet
						ZC6->ZC6_PRCLIS	:= 0

						if !empty( pedido:itens[ nI ]:dtMin )
							ZC6->ZC6_DTMINI	:= sToD( pedido:itens[ nI ]:dtMin )
						endif

						if !empty( pedido:itens[ nI ]:dtMax )
							ZC6->ZC6_DTMAXI	:= sToD( pedido:itens[ nI ]:dtMax )
						endif

						ZC6->( msUnlock() )
					else
						Disarmtransaction()
						U_MFCONOUT("Falha de gravação na ZC6 para o pedido  " + ::pedido:cabecalho:idTablet)
						::retorno:status		:= '0'
						::retorno:observacao	:= 'Erro gravacao dos itens  (Tabela ZC6)'

						lOk := .F.
						exit
					endif
				next

				if lOk
					U_MFCONOUT("Pedido gravado com sucesso para o pedido " + ::pedido:cabecalho:idTablet)
					::retorno:status		:= '1'
					::retorno:observacao	:= 'Pedido recebido'
				endif

			else
				U_MFCONOUT("Falha de gravação na ZC5 para o pedido " + ::pedido:cabecalho:idTablet)
				Disarmtransaction()
				::retorno:status		:= '0'
				::retorno:observacao	:= 'Erro gravacao do cabecalho (Tabela ZC5)'
			endif
		END TRANSACTION
	else
		U_MFCONOUT("Pedido já existente, retornando sucesso para o pedido " + ::pedido:cabecalho:idTablet)
		::retorno:status		:= '1'
		::retorno:observacao	:= 'Pedido recebido'
	endif

	if valType(_aErr) == 'A'
		::retorno:status		:= _aErr[1]
		::retorno:observacao	:= _aErr[2]
	endif

	Leave1Code(alltrim(::pedido:cabecalho:idTablet))

else
	
	U_MFCONOUT("Já existe gravação em andamento para o pedido  " + ::pedido:cabecalho:idTablet)
	::retorno:status		:= '0'
	::retorno:observacao	:= "Já existe gravacao em andamento para o pedido  " + ::pedido:cabecalho:idTablet

Endif


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

	conout( "[MGFWSS02] [SFA] Deu Erro " + oError:Description )
	_aErr := { '0', cEr }
	break

return .T.
