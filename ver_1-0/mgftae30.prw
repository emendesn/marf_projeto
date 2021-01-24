#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} MGFTAE30
Web Service Client para verificação de Status da AR (Aviso de Recebimento no Taura)
@description
Web Service Client para verificação de Status da AR (Aviso de Recebimento no Taura)
@author Natanael Filho
@since 30/06/2020
@type Function
@table ZZH, Cabeçalho AR
@table ZZI, Item AR
@param cFilial, Caracter, Filial que será usada
@param cAR, Caracter, Código do AR
@param aProdJus, Array, Código do produto e Codigo da justificativa de todas as linhas do AR
@return aRetTaura, Array, Retorno do Wevservice Taura
@menu
 Sem menu

 Examplo de Json
	{
  "itens": [
    {
      "idProduto": "5351",
      "idJustificativa": "000041"
    },
    {
      "idProduto": "5352",
      "idJustificativa": "000041"
    }
  ]
}

/*/
User Function MGFTAE30(cFilAR,cAR,aProJus)

	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/devolucao
	
	local lAtivInt		:= SuperGetMv("MGF_TAE30A",.T.,.T.) //Parâmetro para habilitar a integração com o Taura.
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "e1cf4d95-6bc0-4e74-9a4c-788c4ae5a52b" ) )
	local cURL			:= allTrim( superGetMv( "MGFTAE30B" , , "http://spdwvapl203:1462/processo-ar/api/v1/devolucao/{idEmpresa}/motivo/{idAR}" ) )
	local cHTTPMetho	:= ""
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""

	local oJsoncab		:= nil
	local oJsonRet		:= nil
	local cItens		:= " "


	local cHeadHttp		:= ""

	Local aRetTaura		:= {}

	
	If !lAtivInt //Retorna o array vazio se a integração estiver desabilitada.
		Return aRetTaura
	EndIf

	cIdInteg	:= fwUUIDv4()
	cHTTPMetho	:= "PUT"

	cURL := StrTran(cURL,"{idEmpresa}",cFilAR)
	cURL := StrTran(cURL,"{idAR}",cAR)

	aadd( aHeadStr , 'Content-Type: application/json'  )
	aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )	
	
	oJsonCab 	:= jsonObject():new()
	oJsonCab["itens"]	:= {}

	//Monta a Tag de Itens
	For nCount := 1 to Len(aProJus)
		oJsonItem		:= jsonObject():new()
		oJsonItem["idProduto"]			:= aProJus[nCount,1]
		oJsonItem["idJustificativa"]	:= aProJus[nCount,2]
		aadd(oJsonCab["itens"],oJsonItem)
		freeObj( oJsonItem )
	Next nCount

	cJson	:= oJsonCab:toJson()
	freeObj( oJsonCab )
	
	
	cTimeIni	:= time()
	cHttpRet	:= httpQuote( cURL /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, @cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni , cTimeFin )
	nStatuHttp	:= httpGetStatus()


	//Validar retorno do Webservice
	cHttpRet	:= If(ValType(cHttpRet)=="U"," ",Alltrim(cHttpRet))

	conout(" [TAURA] [MGFTAE30] * * * * * Status da integracao AR * * * * *"									)
	conout(" [TAURA] [MGFTAE30] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
	conout(" [TAURA] [MGFTAE30] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
	conout(" [TAURA] [MGFTAE30] Tempo de Processamento.......: " + cTimeProc 								)
	conout(" [TAURA] [MGFTAE30] URL..........................: " + cURL 								)
	conout(" [TAURA] [MGFTAE30] HTTP Method..................: " + cHTTPMetho								)
	conout(" [TAURA] [MGFTAE30] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
	conout(" [TAURA] [MGFTAE30] Envio........................: " + cJson 									)
	conout(" [TAURA] [MGFTAE30] Retorno......................: " + cHttpRet 								)
	conout(" [TAURA] [MGFTAE30] * * * * * * * * * * * * * * * * * * * * "									)

	//Recupera o Json de retorno para adicionar ao Array de retorno da Função
	If nStatuHttp >= 200 .AND. nStatuHttp <= 299
		oJsonRet := jsonObject():new()
		oJsonRet:FromJson(cHttpRet)

		Aadd(aRetTaura,oJsonRet:GetJsonObject("status"))
		Aadd(aRetTaura,oJsonRet:GetJsonObject("mensagem"))
	ElseIf Empty(cHttpRet)
		Aadd(aRetTaura,2) //Rejeição
		Aadd(aRetTaura,"Erro de conexão com o Servidor." + CRLF + cURL)		
	Else
		Aadd(aRetTaura,2) //Rejeição
		Aadd(aRetTaura,"Erro de validação Taura: " + CRLF + cHttpRet)
	EndIf

return aRetTaura


/*/{Protheus.doc} User Function testTAR30
	Teste da rotina para debug
	@since 10/08/2020
	/*/

User Function testTAR30()

	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	//Consulta se o AR pode ser alterado no Taura.
	U_MGFTAE30("010015"/*Filial*/,"000015"/*AR*/,{{"837493847","JUSEIRJ"},{"0002355","JUSJJEURTI"}}/*{{Produtos,Justificativa},{Produtos,Justificativa}}*/)

	RESET ENVIRONMENT

	
Return
