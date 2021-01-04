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
Programa.:              MGFWSS08
Autor....:              Eduardo A. Donato
Data.....:              26/03/2019
Descricao / Objetivo:   WS para retornar informações 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
c5_nota  c5_serie  c5_pedexp     c5_filial   c5_num   c5_cliente  c5_lojacli
000000887  200     EXP00047017   020001      065560   000620      01
eec_pedref    eec_filial           eec_import  eec_imloja   EEC_VIA EEC_ORIGEM
EXP00047017   020001                                          '01'  Y9_DESCR
=====================================================================================
*/
// Estrutura de dados. Montagem do Array de requisição
WSSTRUCT aReqExpData
	WSDATA idNFS			as string
	WSDATA idPedido			as string
	WSDATA idCarga			as string
ENDWSSTRUCT

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetExpData
	WSDATA idNFS			as string
	WSDATA idPedido			as string
	WSDATA idCarga			as string
	WSDATA cPedExp			as string
	WSDATA cViaTr			as string	
	WSDATA cDVia			as string	
	WSDATA cOrigem			as string	
	WSDATA cDOrigem			as string	
	WSDATA cDPais			as string	
//	WSDATA cDestino			as string	
//	WSDATA cDescDestino		as string	
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetExpArray
	WSDATA ExpArray	AS Array OF aRetExpData
ENDWSSTRUCT 

WSSERVICE MGFWSS08 DESCRIPTION "Consulta ERP" namespace "http://www.totvs.com.br/MGFWSS08"

	WSDATA aReqExp AS aReqExpData	
	WSDATA aRetExp AS aRetExpArray

	WSMETHOD enviaDadosExp		DESCRIPTION "Envia dados Ordem Embarque / EXP"		
ENDWSSERVICE

WSMETHOD enviaDadosExp WSRECEIVE aReqExp WSSEND aRetExp WSSERVICE MGFWSS08

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local oExpRet

	BEGIN SEQUENCE

		cAliasTrb := GetNextAlias()

		cQ := " SELECT C5_FILIAL, C5_NUM, F2_CARGA, F2_DOC, C5_NOTA, C5_SERIE, C5_PEDEXP, C5_CLIENTE, C5_LOJACLI, EE7_VIA, YQ_DESCR , EE7_ORIGEM, RTrim(Y9_DESCR)||'-'||Y9_ESTADO UF, YA_DESCR PAIS FROM "+RetSqlName("SF2")+" SF2"
		cQ += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL = F2_FILIAL AND C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5_CLIENTE = F2_CLIENTE AND C5_LOJACLI = F2_LOJA AND SC5.D_E_L_E_T_ = ' '"
		cQ += " INNER JOIN "+RetSqlName("EE7")+" EE7 ON EE7_FILIAL = C5_FILIAL AND C5_PEDEXP = EE7_PEDIDO AND EE7_PEDFAT = C5_NUM AND EE7.D_E_L_E_T_ = ' ' "
		cQ += " LEFT JOIN "+RetSqlName("SYQ")+" SYQ ON SYQ.D_E_L_E_T_ = ' ' AND YQ_VIA = EE7_VIA"
		cQ += " LEFT JOIN "+RetSqlName("SY9")+" SY9 ON SY9.D_E_L_E_T_ = ' ' AND Y9_SIGLA = EE7_ORIGEM"
		cQ += " LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ = ' ' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI"
		cQ += " LEFT JOIN "+RetSqlName("SYA")+" SYA ON SYA.D_E_L_E_T_ = ' ' AND A1_PAIS = YA_CODGI"

		cQ += " WHERE 1=1 and SF2.D_E_L_E_T_ = ' '"
		If !Empty(aReqExp:idNFS)
			cQ += " AND F2_DOC = '"+ aReqExp:idNFS +"' "		
		EndIf
		If !Empty(aReqExp:idPedido)
			cQ += " AND C5_NUM = '"+ aReqExp:idPedido +"' "		
		EndIf
		If !Empty(aReqExp:idCarga)
			cQ += " AND F2_CARGA = '"+ aReqExp:idCarga +"' "		
		EndIf

		Conout("[MGFWSS08] - Consulta EXP")
		Conout(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		

		// Cria a instância de retorno ( WSDATA aRetExp AS aRetExpArray )
		::aRetExp := WSClassNew( "aRetExpArray")

		// inicializa a propriedade da estrutura de retorno
		// WSDATA ExpArray	AS Array OF aRetExpData
		::aRetExp:ExpArray := {}

		While (cAliasTrb)->(!Eof())
			// Cria e alimenta uma nova instancia do cliente
			oExpRet :=  WSClassNew( "aRetExpData" )
			oExpRet:idNFS			:= (cAliasTrb)->F2_DOC
			oExpRet:idPedido		:= (cAliasTrb)->C5_NUM
			oExpRet:idCarga			:= (cAliasTrb)->F2_CARGA
			oExpRet:cPedExp			:= (cAliasTrb)->C5_PEDEXP
			oExpRet:cViaTr			:= (cAliasTrb)->EE7_VIA
			oExpRet:cDVia			:= (cAliasTrb)->YQ_DESCR
			oExpRet:cOrigem			:= (cAliasTrb)->EE7_ORIGEM
			oExpRet:cDOrigem		:= (cAliasTrb)->UF
			oExpRet:cDPais			:= (cAliasTrb)->PAIS

			AAdd( ::aRetExp:ExpArray, oExpRet )
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	

		if Len(::aRetExp:ExpArray) == 0
			SetSoapFault("enviaDadosExp", "Status:2 -Observação: Não há Dados Exp")
			lRet		:= .F.
		EndIf


		RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	if valType(_aErr) == 'A'
		SetSoapFault("enviaDadosExp", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

//-------------------------------------------------------
//-------------------------------------------------------
static function MyError(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	nQtd := iif(nQtd > 4,4,nQtd) //Retorna as 4 linhas 

	for ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( oError:Description + " Deu Erro" )
	_aErr := {'0',cEr}
	break

return .T. 