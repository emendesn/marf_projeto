#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa.:              MGFOMS09
Autor....:              Rafael Garcia
Data.....:              14/11/2019
Descricao / Objetivo:   Integração PROTHEUS x Multiembarcador - Integrar Ctes eNFse Emitidos
Doc. Origem:			RTASK0010450
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFOMS09()
local cURLPost		:= ""
local cURL			:= ""
local cJson 		:= ""
local aHeadOut		:= {}
local nTimeOut		:= 120
local xPostRet		:= ""
local nStatuHttp	:= 0
local cHeadRet		:= ""
local cTimeIni		:= ""
local cTimeFin		:= ""
local cTimeProc		:= ""

	If !ExisteSx6("MGF_OMS09")
		CriarSX6("MGF_OMS09", "C", "URL Reenvio de Documento Multisoftware", "http://spdwvapl203:1337/processo/cte/api/v2/OEReferencia/{OEReferencia}/IntegrarCTEsNFSe" )
	EndIf
	cURLPost   := alltrim(SuperGetMv('MGF_OMS09' , NIL, ''))

	If MSGYESNO("Confirma integrar os documentos CTes e Nfes emitidos da carga:"+DAK->DAK_COD+"?")
		aadd( aHeadOut, 'Content-Type: application/json')
		cJson := '{"Unidade":"'+DAK->DAK_FILIAL+'"}'
		cURL:=strTran( cURLPost, "{OEReferencia}", ALLTRIM(DAK->DAK_XOEREF) )		
		cTimeIni := time()
		xPostRet := httpQuote( cURL /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		conout(" [MGFOMS09] * * * * * Status da integracao * * * * *")
		conout(" [MGFOMS09] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [MGFOMS09] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [MGFOMS09] Tempo de Processamento.......: " + cTimeProc )
		conout(" [MGFOMS09] URL..........................: " + cURL)
		conout(" [MGFOMS09] HTTP Method..................: " + "GET" )
		conout(" [MGFOMS09] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [MGFOMS09] Retorno......................: " + allTrim( xPostRet ) )
		conout(" [MGFOMS09] * * * * * * * * * * * * * * * * * * * * ")

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			Alert("Solicitacao enviada com sucesso!")
		else 
			Alert("Erro no envio da solicitacao, enviar novamente!")	
		endif	
	ENDIF	

return
