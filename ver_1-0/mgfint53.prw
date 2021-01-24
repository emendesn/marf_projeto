#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFINT53

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
class MGFINT53
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
	data lErro500		as boolean
	

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
method new(cURLPost, oObjToJson, nKeyRecord, cTblUpd, cFieldUpd, cIntegra, cTypeInte, cChave, lDeserialize, lConsultaEst, lMonitor, lUseJson, lNameClass, lDelClsNam, lLogInCons) class MGFINT53
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
method serialJson() class MGFINT53
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
		//MemoWrite("C:\TEMP\MGFFT41T-"+DTOS(Date())+StrTran(Time(),":")+".TXT",cJson)
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
		cJson += '}'
	Elseif IsInCallStack("MGFFAT8T")
		cJson := StrTran(cJson,"XML"						,"xml")
	Else 
		cJson := Strtran(cJson,"\\","")
	EndIf
	
	if !empty(cJson)
		::cJson := cJson
	else
		conout("Erro na Serialização do Json! Verifique objeto oObjToJson.")
	endif
	
	//MakeDir("c:\temp")
	//MemoWrite("c:\temp\"+FunName()+"_"+::cChave+"_"+StrTran(Time(),":","")+".txt",cJson)
	//If IsInCallStack("U_TMSJASPV") .or. IsInCallStack("U_TMSJASEX")
	//	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName()+"_"+::cChave+"_"+StrTran(Time(),":","")+".txt",cJson)
	//Endif
	
return

/*/{Protheus.doc} deSeriJson

Deserializa objeto de retorno

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method deSeriJson() class MGFINT53
	local nI		:= 0
	local oObjRet	:= nil
	Local nStatus 	:= 0
	Local cMensagem	:= ""                        
	
	::lOk      := .F.
	::nStatus  := 0
	::lErro500 := .F. 

	IF ::nStatuHttp == 500
		::lErro500 := .T. 
    EndIF
    
	IF ::lConsultaEst
		::lOk := .T.
		::cDetailInt := "Consulta Realizada com Sucesso: "
	Else
		If ::nStatuHttp == 201 .OR. ::nStatuHttp == 200
			::cDetailInt := "Integrado com sucesso"
			::lOk        := .T.  
			::nStatus    := 1
			IF fwJsonDeserialize(::cPostRet, @oObjRet) //fwJsonDeserialize(oObjRet, @oObjRet)
				IF Type("VALTYPE(oObjRet:STATUS") <> "U" .and. VALTYPE(oObjRet:STATUS) == 'N'
					::nStatus    := oObjRet:STATUS
				EndIF
			EndIF
		Elseif ::nStatuHttp == 412 .OR. ::nStatuHttp == 422 .OR. ::nStatuHttp == 400 .OR. ::nStatuHttp == 404 .OR. ::nStatuHttp == 500
			If  'mensagem' $ lower(::cPostRet)
				If !::lDeserialize
					nPos      := At("mensagem",Lower(::cPostRet))
					cMensagem := Subs(::cPostRet,nPos+10)
					cMensagem := Subs(cMensagem,1,Len(cMensagem)-1)
					::cDetailInt := cMensagem
					IF ::nStatuHttp == 412 .OR. ::nStatuHttp == 422 .OR. ::nStatuHttp == 400
					    ::lOk        := .T.
					Else 
					    ::lOk        := .F.
					EndIF
					::nStatus    := 2
				EndIF
			Endif	
			If !::lOk .and. ::nStatus == 0
				::nStatus    := 2
			Endif
			If Empty(::cDetailInt)
				::cDetailInt := ::cPostRet
			Endif	
		Else 
			::cDetailInt := "Retorno não catalogado : HTTP : "+Alltrim(STR(::nStatuHttp))
			::lOk        := .F.              
			::nStatus    := 2
		Endif
	EndIF
	
return

/*/{Protheus.doc} sendByHttpPost

Realiza a integração

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method sendByHttpPost() class MGFINT53
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
		conout(" [MGFINT53] * * * * * Status da integracao * * * * *")
		conout(" [MGFINT53] Inicio.......................: " + ::cTimeIni + " - " + dToC(dDataBase))
		conout(" [MGFINT53] Fim..........................: " + ::cTimeFin + " - " + dToC(dDataBase))
		conout(" [MGFINT53] Tempo de Processamento.......: " + ::cTimeProc)
		conout(" [MGFINT53] URL..........................: " + ::cURLPost)
		conout(" [MGFINT53] Status Http .................: " + allTrim( str( ::nStatuHttp ) ) )
		conout(" [MGFINT53] LOK..........................: " + iif(::lOk, ".T.", ".F."))
		conout(" [MGFINT53] Envio........................: " + substr(::cJson,1,100))
		conout(" [MGFINT53] Retorno......................: " + ::cPostRet)
		conout(" [MGFINT53] * * * * * * * * * * * * * * * * * * * * ")
	endif

	If (IsInCallStack("U_TMSJASPV") .or. IsInCallStack("U_TMSJASEX") ) .and. Date() < ctod("31/01/19")
		_cMSGLOG :=  " [MGFINT53] Status Http .................: " + allTrim( str( ::nStatuHttp ) ) + "|||"
		_cMSGLOG +=  " [MGFINT53] LOK..........................: " + iif(::lOk, ".T.", ".F.") + "|||"
		_cMSGLOG +=  " [MGFINT53] Envio........................: " + ::cJson + "|||"
		_cMSGLOG +=  " [MGFINT53] Retorno......................: " + ::cPostRet + "|||"
		If IsInCallStack("U_TMSJASPV")
			conout("********* INTEGRACAO PROTHEUS X TMS - PV")
		Else
			conout("********* INTEGRACAO PROTHEUS X TMS - EXP")
		Endif			
		conout( _cMSGLOG )
		//MemoWrite( GetTempPath(.T.) + "AAA_LOG_" + FunName()+"_"+::cChave+"_"+StrTran(Time(),":","")+".txt",_cMSGLOG)
	Endif

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
method getProcTime() class MGFINT53
return ::cTimeProc

/*/{Protheus.doc} logMonitor

Grava log da integração no Monitor de Integrações após o processamento.

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method logMonitor() class MGFINT53
	local cStatusInt	:= ""
	local cErro	:= ""
	     
	::nStatus
	/*if ::nStatuHttp >= 200 .and. ::nStatuHttp <= 299
		// sucesso
		cStatusInt	:= "1"
	else
		// erro
		cStatusInt	:= "2"
	endif
	  */
	cStatusInt	:= Alltrim(STR(::nStatus))  
	cErro := ::cDetailInt
	
	IF  ::lMonitor
		//cFil      ,cStatus   , cCodint               ,cCodtpint                 ,cErro    ,cDocori                                                , cTempo
		U_MGFMONITOR( cFilant   ,;
		cStatusInt,;
		::cIntegra ,; //cCodint
		::cTypeInte ,;//cCodtpint
		cErro	,;
		::cChave ,; //cDocori
		::cTimeProc ,;//cTempo
		::cJson ,;
		::nKeyRecord,; //recno documento de origem
		Alltrim(STR(::nStatuHttp))) // Http
	EndIF
return

/*/{Protheus.doc} updtRecno

Atualiza registro da tabela caso seja aplicavel

@author gustavo.afonso
@since 07/12/2016


@type method
/*/
method updtRecno() class MGFINT53
	local cUpd := ""
	
	If !IsInCallStack("U_MGFTAFA8") .And. !FunName()=="MGFFAT43"
		// sucesso
		cUpd := "UPDATE " + retSQLName(::cTblUpd)			+ CRLF
		cUpd += " SET " + ::cFieldUpd + " = 'I'"			+ CRLF
		cUpd += " WHERE R_E_C_N_O_ = " + str(::nKeyRecord)	+ CRLF
		
		tcSQLExec(cUpd)
	Else     
	    dbSelectArea('ZBS')
	    ZBS->( dbSetOrder(1))
		ZBS->( dbGoTo( ::nKeyRecord ) )

		RecLock("ZBS",.F.)
		ZBS->ZBS_ITAURA := "I"               
		ZBS->ZBS_DTHREN	:= FWTimeStamp(2)
		/*ZBS->ZBS_STATUS := "S" //Alterado Carneiro 10/18 
		If IsInCallStack("U_MGFFAT41")
			ZBS->ZBS_DTHREN	:= FWTimeStamp(2)
		ElseIf FunName()=="MGFFAT43"
			ZBS->ZBS_DTHRRT	:= FWTimeStamp(2)
			ZBS->ZBS_CODUSR	:= __cUserID
			ZBS->ZBS_NOMUSR	:= Subs(cUsuario,7,15)
		EndIf */
		ZBS->( msUnlock() )
	EndIf
return
