#include "totvs.ch" 
#include "protheus.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFINT23

Faz comunicação com o Barramento via HTTP Post

@author gustavo.afonso
@since 07/12/2016


@type class
@sample
// Instancia o objeto
@sample

@sample
// Executa a integração
@sample
oWSSFA:sendByHttpPost()
/*/
class MGFINT23
	data cPostRet		as string
	data cURLPost		as string
	data cJson			as string
	data oObjToJson		as object
	data nTimeOut		as string
	data aHeadOut		as array// of string
	data cHeadRet		as string
	data oObjRet		as object
	data nStatuHttp		as integer
	data cTimeIni		as string
	data cTimeFin		as string
	data cTimeProc		as string
	data cIntegra		as string
	data cTypeInte		as string
	data cDetailInt		as string
	data nKeyRecord		as integer
	data cTblUpd		as string
	data cFieldUpd		as string
	data cValueUpd		as string
	data lOk			as boolean
	data cChave			as string
	data nStatus		as integer
	data lDeserialize  	as boolean
	data lConsultaEst  	as boolean
	data lMonitor       as boolean
	data lUseJson		as boolean
	data lNameClass		as boolean
	data lDelClsNam		as boolean
	data lLogInCons		as boolean

	method new() constructor	// construtor
	method logMonitor()				// gera log no Monitor de IntegraÃ§Ãµes
	method updtRecno()				// Atualiza registro da tabela caso seja aplicavel
	method serialJson()			// serializa oObjToJson
	method deSeriJson()			// deserializa objeto JSON
	method sendByHttpPost()		// envia atraves de http post
	method getProcTime()		// retorna o tempo de processamento
	
endclass

/*/{Protheus.doc} new

Construtor da Classe

@author gustavo.afonso
@since 07/12/2016

@param cURLPost, characters, URL a ser acessada.
@param oObjToJson, object, Objeto que sera serializado em formato JSON
@param nKeyRecord, numeric, Número do RECNO do registro a ser atualizado com o resultado da integração. Caso não possua enviar zero.
@param cTblUpd, characters, Tabela a ser atualizada com o resultado da integração. Ex. 'SA1'. Caso não possua enviar string em branco "".
@param cFieldUpd, characters, Campo da Tabela a ser atualizado com o resultado da integração. Ex. 'A1_XINTEGR'. Caso não possua enviar string em branco "".
@param cIntegra, characters, Código da Integração definido no cadastro SZ2
@param cTypeInte, characters, Código do Tipo da Integração definido no cadastro SZ3
@param cChave Chave do Monitor
@param llDeserialize, Lógico, deserializa o JSON
@param lConsultaEst, Lógico, Metodo é Consulta de estoque
@param lMonitor, Lógico, Integra com Monitor
@param lUseJson, Lógico, Se informado .F. não utiliza JSON na integração. Não obrigatório. DEFAULT .T.
@param lNameClass, Lógico, Se informado .T. o nome do objeto utilizado para gerar o JSON irá constar no JSON gerado. Não obrigatório. DEFAULT .F.
@param lDelClsNam, Lógico, Se informado .T. é removida a string '"_classname":' gerada no JSON. Apenas necessário caso o parâmetro lNameClass seja informado. Não obrigatório. DEFAULT .F.
@param lLogInCons, Lógico, Se informado .T. exibe mensagens de log de integração no console quando executado o método sendByHttpPost. Não obrigatório. DEFAULT .F.

@type method
/*/
method new(cURLPost, oObjToJson, nKeyRecord, cTblUpd, cFieldUpd, cIntegra, cTypeInte, cChave, lDeserialize, lConsultaEst, lMonitor, lUseJson, lNameClass, lDelClsNam, lLogInCons) class MGFINT23
	default nKeyRecord		:= 0
	default cTblUpd			:= ""
	default cFieldUpd		:= ""
	default cChave			:= ""
	default lDeserialize	:= .T.
	default lConsultaEst	:= .F.
	default lMonitor		:= .F.
	default lUseJson		:= .T.
	default lNameClass		:= .F.
	default lDelClsNam		:= .F.
	default lLogInCons		:= .F.

	::cPostRet		:= ""
	::cJson			:= ""
	::cURLPost		:= cURLPost
	::oObjToJson	:= oObjToJson
	::aHeadOut		:= {}
	::cHeadRet		:= ""
	::nTimeOut		:= getMv("MGF_SFATO")
	::cDetailInt	:= ""
	::nKeyRecord	:= nKeyRecord
	::cTblUpd		:= cTblUpd
	::cFieldUpd		:= cFieldUpd
	::cIntegra		:= cIntegra
	::cTypeInte 	:= cTypeInte
	::lOk			:= .F.
	::cChave 		:= cChave
	::lDeserialize	:= lDeserialize
	::lConsultaEst  := lConsultaEst
	::lMonitor      := lMonitor
	::lUseJson		:= lUseJson
	::lNameClass	:= lNameClass
	::lDelClsNam	:= lDelClsNam
	::lLogInCons	:= lLogInCons

return

/*/{Protheus.doc} serialJson

Serialza o objeto oObjToJson que será enviado para a integração

@author gustavo.afonso
@since 07/12/2016

@type method
/*/
method serialJson() class MGFINT23
	local cJson := ""

	if ::lNameClass
		cJson := fwJsonSerialize(::oObjToJson, .T., .T.)
	else
		cJson := fwJsonSerialize(::oObjToJson, .F., .T.)
	endif

	if ::lDelClsNam
		cJson := strTran(cJson, '"_classname":')
	endif

	If IsInCallStack("U_MGFFT41T")
		cJson := StrTran(cJson,"FILIAL"						,"Filial")
		cJson := StrTran(cJson,"NUMERONOTAFISCAL"			,"NumeroNotaFiscal")
		cJson := StrTran(cJson,"SERIENOTAFISCAL"			,"SerieNotaFiscal")
		cJson := StrTran(cJson,"CAMINHOCOMPLETONOTAFISCAL"	,"CaminhoCompletoNotaFiscal")
		cJson := StrTran(cJson,"REENVIO"	                ,"Reenvio")
	ElseIf IsInCallStack("U_MGFTAE25") .OR. IsInCallStack("U_MGFTAP13")
		cJson := StrTran(cJson,"CHAVEUID"		,"ChaveUID")
		cJson := StrTran(cJson,"MENSAGEM"		,"Mensagem")
		cJson := StrTran(cJson,"SUCESSO"		,"Sucesso")
		cJson := StrTran(cJson,"CHAVES"	     	,"Chaves")
	ElseIf IsInCallStack("U_MGFTAP18") 
		cJson := StrTran(cJson,"FILIAL"		    ,"Filial")
		cJson := StrTran(cJson,"DATAINICIO"		,'DataInicio')
		cJson := StrTran(cJson,"DATAFINAL"		,"DataFinal")

	ElseIf IsInCallStack("U_XWSC23") .or. IsInCallStack("U_MGFWSC23") 
		cJson := StrTran(cJson,'"ORDEMEMBARQUE",'	    ,  '"ORDEMEMBARQUE": {')
		cJson := StrTran(cJson,'"CTE",'		            ,  '"CTE": {')
		cJson := StrTran(cJson,'"DESTINATARI",')
		cJson := StrTran(cJson,'"DOCUMENTO",')
		cJson := StrTran(cJson,'"SUBDOC",')
		cJson := StrTran(cJson,'"QUANTIDADECARGA",')
		cJson := StrTran(cJson,'"SUBQUANTIDADECARGA",')
		cJson := StrTran(cJson,'"REMETENT",')
		cJson := StrTran(cJson,'}],"FILIAL":', '}}],"FILIAL":')
		cJson := StrTran(cJson,'"REMETENTE":['  , '"REMETENTE":')
		cJson := StrTran(cJson,'],"TIPOCTE":"Normal"' , ',"TIPOCTE":"Normal"')
		cJson += '}'
	elseif isInCallStack("U_MGFWSC24") .or. isInCallStack("U_MNUWSC24")
		cJson := strTran( cJson, 'B1COD'		, 'b1Cod'		)
		cJson := strTran( cJson, 'B1ZCCATEG'	, 'b1Zccateg'	)
		cJson := strTran( cJson, 'B1DESC'		, 'b1Desc'		)
		cJson := strTran( cJson, 'b1CodSKU'		, 'b1CodSku'	)
		cJson := strTran( cJson, 'ZZUDESCRI'	, 'zzuDescri'	)
		cJson := strTran( cJson, 'ZDADESCRI'	, 'zdaDescri'	)
		cJson := strTran( cJson, 'B1ZCONSER'	, 'b1Zconser'	)
		cJson := strTran( cJson, 'B1POSIPI'		, 'b1PosIpi'	)
		cJson := strTran( cJson, 'B1ZULDPR'		, 'b1Zuldpr'	)
		cJson := strTran( cJson, 'B1ZMESES'		, 'b1Zmeses'	)
		cJson := strTran( cJson, 'B1ZEAN13'		, 'b1Zean13'	)
		cJson := strTran( cJson, 'B5EMB1'		, 'b5Emb1'		)
		cJson := strTran( cJson, 'DA1PRCVEN'	, 'da1Prcven'	)
		cJson := strTran( cJson, 'B1MSBLQL'		, 'b1Msblql'	)
	Else
		cJson := Strtran(cJson,"\\","")
	EndIf
	
	if !empty(cJson)
		::cJson := cJson
	else
		conout("Erro na Serialização do Json! Verifique objeto oObjToJson.")
	endif
		
return

/*/{Protheus.doc} deSeriJson

Deserializa objeto de retorno

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method deSeriJson() class MGFINT23
	local nI		:= 0
	local oObjRet	:= nil
	Local nStatus 	:= 0
	Local cMensagem	:= ""
	Local _lnovproc := isincallstack("MGFWSC05F")
		
	::lOk := .F.
	::nStatus := 0
	
	IF ::lConsultaEst .and. ((!(::nStatuHttp == 400 .or. ::nStatuHttp >= 500) .and. ::nStatuHttp != 10049) .OR. !_lnovproc )
		::lOk := .T.
		::cDetailInt := "Consulta Realizada com Sucesso: "
	Elseif _lnovproc .AND. !empty(::cPostRet) .and. (::nStatuHttp == 400 .or. ::nStatuHttp >= 500)  // bad request
		::cDetailInt := ::cPostRet
		::lOk := .F.
	Elseif _lnovproc .AND. empty(::cPostRet) .and. (::nStatuHttp == 400 .or. ::nStatuHttp >= 500)  // bad request
		::cDetailInt := "Falha de acesso ao " + ::cURLPost + " com código " + alltrim(str(::nStatuHttp))
		::lOk := .F.
	Elseif _lnovproc .AND. ::nStatuHttp == 10049  //falha de conexão
		::cDetailInt := "Falha de acesso ao " + ::cURLPost
		::lOk := .F.
	Else
		IF !empty(::cPostRet) .and. (::nStatuHttp >= 200 .and. ::nStatuHttp <= 299) .And. !( IsIncallstack("U_MGFFAT41") .Or. FunName()=="MGFFAT43" ) 

			if 'status' $ lower(::cPostRet) .and. 'mensagem' $ lower(::cPostRet)
				// tratamento para nao deserealizar o objeto, pois estah ocorrendo erro
				// Access Violation in function TWINDOW:ACTIVATE on FWCREATECLASS(XMLXFUN.PRW)
				// na funcao padrao, em alguns casos
				If !::lDeserialize
					// verifica se veio algum caracter depois do status, para no caso de nao vir nada, nao carregar a variavel nStatus com conteudo errado
					If At("mensagem",Lower(::cPostRet)) -  At("status",Lower(::cPostRet)) >= 11
						// carrega status
						If (nPos := At("status",Lower(::cPostRet))) > 0
							nStatus := Val(Subs(::cPostRet,nPos+8,1))
						Endif
						// carrega mensagem
						If (nPos := At("mensagem",Lower(::cPostRet))) > 0
							cMensagem := Subs(::cPostRet,nPos+10)
						Endif
						// retira o ultimo caracter "}" do Json, do final da string
						If !Empty(cMensagem)
							cMensagem := Subs(cMensagem,1,Len(cMensagem)-1)
						Endif
						If nStatus == 1
							::cDetailInt := "Integrado com sucesso"
							::lOk := .T.
						Else
							::cDetailInt := cMensagem
						Endif
						::nStatus := nStatus
					Endif
					
				Elseif fwJsonDeserialize(::cPostRet, @oObjRet)
					if 'result' $ ::cPostRet .and. 'ok' $ ::cPostRet
						::cDetailInt := "Integrado com sucesso"
						::lOk := .T.
					elseIf 'detail' $ ::cPostRet
						if fwJsonDeserialize(::cPostRet, @oObjRet)
							// sucesso
							if valtype(oObjRet:detail:ns2MarfrigSoapException:errorMessageCause) == "C"
								::cDetailInt := oObjRet:detail:ns2MarfrigSoapException:errorMessageCause
							elseif valtype(oObjRet:detail:ns2MarfrigSoapException:errorMessageCause) == "A"
								for nI := 1 to len(oObjRet:detail:ns2MarfrigSoapException:errorMessageCause)
									::cDetailInt += oObjRet:detail:ns2MarfrigSoapException:errorMessageCause[nI] + CRLF
								next
							endif
						else
							// erro
							::cDetailInt := "Não foi possível converter a mensagem. Mensagem original: " + ::cPostRet
						endif
						
					elseIf oObjRet:status == 1
						::cDetailInt := "Integrado com sucesso"
						::lOk := .T.
					ElseIf oObjRet:status == 2
						if valtype(oObjRet:mensagem) == "C"
							::cDetailInt := oObjRet:mensagem
						elseif valtype(oObjRet:mensagem) == "A"
							for nI := 1 to len(oObjRet:mensagem)
								::cDetailInt += oObjRet:mensagem[nI] + CRLF
							next
						endif
					EndIf
					::nStatus := oObjRet:status
				Else
					::cDetailInt := "Não foi possível converter a mensagem. Mensagem original: " + ::cPostRet
				EndIf
			else
				// erro
				::cDetailInt := "Não foi possível converter a mensagem. Mensagem original: " + ::cPostRet
			endif
		ElseIf ( IsIncallstack("U_MGFFAT41") .Or. FunName()=="MGFFAT43" ) 
		 	IF ::nStatuHttp >= 200 .and. ::nStatuHttp <= 299
				::cDetailInt := "Integrado com sucesso"
				::lOk := .T.                                
			EndIF
		Elseif !empty(::cPostRet) .and. ::nStatuHttp == 400 // bad request
			::cDetailInt := ::cPostRet
			::lOk := .F.
		else
			::cDetailInt := "Nenhuma mensagem de retorno retornada."
		endif
	EndIF
	
return

/*/{Protheus.doc} sendByHttpPost

Realiza a integração

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method sendByHttpPost() class MGFINT23
	if ::lUseJson
		::serialJson()
	endif

	::cHeadRet		:= ""
	::aHeadOut		:= {}

	aadd(::aHeadOut,'Content-Type: application/json')

	::cTimeIni		:= time()
	::cPostRet		:= httpPost(::cURLPost,, ::cJson, ::nTimeOut, ::aHeadOut, @::cHeadRet)
	::cTimeFin		:= time()
	::cTimeProc		:= elapTime(::cTimeIni, ::cTimeFin)
	
	::nStatuHttp	:= httpGetStatus()

	if ::lUseJson
		::deSeriJson()
	endif

	if ::lLogInCons
		conout(" [MGFINT23] * * * * * Status da integracao * * * * *")
		conout(" [MGFINT23] Inicio.......................: " + ::cTimeIni + " - " + dToC(dDataBase))
		conout(" [MGFINT23] Fim..........................: " + ::cTimeFin + " - " + dToC(dDataBase))
		conout(" [MGFINT23] Tempo de Processamento.......: " + ::cTimeProc)
		conout(" [MGFINT23] URL..........................: " + ::cURLPost)
		conout(" [MGFINT23] Status Http (200 a 299 ok)...: " + allTrim( str( ::nStatuHttp ) ) )
		conout(" [MGFINT23] LOK..........................: " + iif(::lOk, ".T.", ".F."))
		conout(" [MGFINT23] Envio........................: " + ::cJson)
		conout(" [MGFINT23] Retorno......................: " + ::cPostRet)
		conout(" [MGFINT23] * * * * * * * * * * * * * * * * * * * * ")
	endif

	::logMonitor()

	if !empty(::cTblUpd) .and. ::lOk
		::updtRecno()
	endif
return

/*/{Protheus.doc} getProcTime

Retorna tempo de processamento

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method getProcTime() class MGFINT23
return ::cTimeProc

/*/{Protheus.doc} logMonitor

Grava log da integração no Monitor de Integrações após o processamento.

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method logMonitor() class MGFINT23
	local cStatusInt	:= ""
	local cErro	:= ""
	
	if ::nStatuHttp >= 200 .and. ::nStatuHttp <= 299
		// sucesso
		cStatusInt	:= "1"
	else
		// erro
		cStatusInt	:= "2"
	endif
	
	cErro := ::cDetailInt
	
	IF  ::lMonitor
		U_MGFMONITOR( cFilant   ,;
		cStatusInt,;
		::cIntegra ,; //cCodint
		::cTypeInte ,;//cCodtpint
		cErro	,;
		::cChave ,; //cDocori
		::cTimeProc ,;//cTempo
		::cJson ,;
		::nKeyRecord) // recno documento de origem
	EndIF
return

/*/{Protheus.doc} updtRecno

Atualiza registro da tabela caso seja aplicavel

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method updtRecno() class MGFINT23
	local cUpd := ""
	
	If !IsInCallStack("U_MGFFAT41") .And. !FunName()=="MGFFAT43"
		// sucesso
		cUpd := "UPDATE " + retSQLName(::cTblUpd)			+ CRLF
		cUpd += " SET " + ::cFieldUpd + " = 'I'"			+ CRLF
		cUpd += " WHERE R_E_C_N_O_ = " + str(::nKeyRecord)	+ CRLF
		
		
		tcSQLExec(cUpd)
	Else
		RecLock("ZBS",.F.)
		ZBS->ZBS_ITAURA := "I"
		If IsInCallStack("U_MGFFAT41")
			ZBS->ZBS_DTHREN	:= FWTimeStamp(2)
		ElseIf FunName()=="MGFFAT43"
			ZBS->ZBS_DTHRRT	:= FWTimeStamp(2)
			ZBS->ZBS_CODUSR	:= __cUserID
			ZBS->ZBS_NOMUSR	:= Subs(cUsuario,7,15)
		EndIf
		ZBS->( msUnlock() )
	EndIf
return
