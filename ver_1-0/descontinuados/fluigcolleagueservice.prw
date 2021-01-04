#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://spdwvapl168/webdesk/ECMColleagueService?wsdl
Gerado em        02/26/18 10:18:03
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _PIFCSIA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSECMColleagueServiceService
------------------------------------------------------------------------------- */

WSCLIENT WSECMColleagueServiceService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD getColleaguesMail
	WSMETHOD removeColleague
	WSMETHOD getSummaryColleagues
	WSMETHOD validateColleagueLogin
	WSMETHOD activateColleague
	WSMETHOD getSimpleColleague
	WSMETHOD getGroups
	WSMETHOD createColleague
	WSMETHOD updateColleague
	WSMETHOD createColleaguewithDependencies
	WSMETHOD getColleagueByLogin
	WSMETHOD getColleaguesCompressedData
	WSMETHOD getColleagues
	WSMETHOD updateColleaguewithDependencies
	WSMETHOD createColleagueWithMap
	WSMETHOD getColleague

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cusername                 AS string
	WSDATA   cpassword                 AS string
	WSDATA   ncompanyId                AS int
	WSDATA   cmail                     AS string
	WSDATA   oWSgetColleaguesMailresult AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   ccolleagueId              AS string
	WSDATA   cresult                   AS string
	WSDATA   oWSgetSummaryColleaguesresult AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWSgetSimpleColleagueresult AS ECMColleagueServiceService_colleagueDto
	WSDATA   oWSgetGroupscolab         AS ECMColleagueServiceService_groupDtoArray
	WSDATA   oWScreateColleaguecolleagues AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   cresultXML                AS string
	WSDATA   oWSupdateColleaguecolleagues AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWScreateColleaguewithDependenciescolleagues AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWScreateColleaguewithDependenciesgroups AS ECMColleagueServiceService_groupDtoArray
	WSDATA   oWScreateColleaguewithDependenciesworkflowRoles AS ECMColleagueServiceService_workflowRoleDtoArray
	WSDATA   oWSgetColleagueByLogincolleagueId AS ECMColleagueServiceService_colleagueDto
	WSDATA   oWSgetColleaguesresult    AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWSupdateColleaguewithDependenciescolleagues AS ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWSupdateColleaguewithDependenciesgroups AS ECMColleagueServiceService_groupDtoArray
	WSDATA   oWSupdateColleaguewithDependenciesworkflowRoles AS ECMColleagueServiceService_workflowRoleDtoArray
	WSDATA   ccolleagueXML             AS string
	WSDATA   oWSgetColleaguecolab      AS ECMColleagueServiceService_colleagueDtoArray

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSECMColleagueServiceService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20171130 NG] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSECMColleagueServiceService
	::oWSgetColleaguesMailresult := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWSgetSummaryColleaguesresult := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWSgetSimpleColleagueresult := ECMColleagueServiceService_COLLEAGUEDTO():New()
	::oWSgetGroupscolab  := ECMColleagueServiceService_GROUPDTOARRAY():New()
	::oWScreateColleaguecolleagues := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWSupdateColleaguecolleagues := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWScreateColleaguewithDependenciescolleagues := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWScreateColleaguewithDependenciesgroups := ECMColleagueServiceService_GROUPDTOARRAY():New()
	::oWScreateColleaguewithDependenciesworkflowRoles := ECMColleagueServiceService_WORKFLOWROLEDTOARRAY():New()
	::oWSgetColleagueByLogincolleagueId := ECMColleagueServiceService_COLLEAGUEDTO():New()
	::oWSgetColleaguesresult := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWSupdateColleaguewithDependenciescolleagues := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
	::oWSupdateColleaguewithDependenciesgroups := ECMColleagueServiceService_GROUPDTOARRAY():New()
	::oWSupdateColleaguewithDependenciesworkflowRoles := ECMColleagueServiceService_WORKFLOWROLEDTOARRAY():New()
	::oWSgetColleaguecolab := ECMColleagueServiceService_COLLEAGUEDTOARRAY():New()
Return

WSMETHOD RESET WSCLIENT WSECMColleagueServiceService
	::cusername          := NIL 
	::cpassword          := NIL 
	::ncompanyId         := NIL 
	::cmail              := NIL 
	::oWSgetColleaguesMailresult := NIL 
	::ccolleagueId       := NIL 
	::cresult            := NIL 
	::oWSgetSummaryColleaguesresult := NIL 
	::oWSgetSimpleColleagueresult := NIL 
	::oWSgetGroupscolab  := NIL 
	::oWScreateColleaguecolleagues := NIL 
	::cresultXML         := NIL 
	::oWSupdateColleaguecolleagues := NIL 
	::oWScreateColleaguewithDependenciescolleagues := NIL 
	::oWScreateColleaguewithDependenciesgroups := NIL 
	::oWScreateColleaguewithDependenciesworkflowRoles := NIL 
	::oWSgetColleagueByLogincolleagueId := NIL 
	::oWSgetColleaguesresult := NIL 
	::oWSupdateColleaguewithDependenciescolleagues := NIL 
	::oWSupdateColleaguewithDependenciesgroups := NIL 
	::oWSupdateColleaguewithDependenciesworkflowRoles := NIL 
	::ccolleagueXML      := NIL 
	::oWSgetColleaguecolab := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSECMColleagueServiceService
Local oClone := WSECMColleagueServiceService():New()
	oClone:_URL          := ::_URL 
	oClone:cusername     := ::cusername
	oClone:cpassword     := ::cpassword
	oClone:ncompanyId    := ::ncompanyId
	oClone:cmail         := ::cmail
	oClone:oWSgetColleaguesMailresult :=  IIF(::oWSgetColleaguesMailresult = NIL , NIL ,::oWSgetColleaguesMailresult:Clone() )
	oClone:ccolleagueId  := ::ccolleagueId
	oClone:cresult       := ::cresult
	oClone:oWSgetSummaryColleaguesresult :=  IIF(::oWSgetSummaryColleaguesresult = NIL , NIL ,::oWSgetSummaryColleaguesresult:Clone() )
	oClone:oWSgetSimpleColleagueresult :=  IIF(::oWSgetSimpleColleagueresult = NIL , NIL ,::oWSgetSimpleColleagueresult:Clone() )
	oClone:oWSgetGroupscolab :=  IIF(::oWSgetGroupscolab = NIL , NIL ,::oWSgetGroupscolab:Clone() )
	oClone:oWScreateColleaguecolleagues :=  IIF(::oWScreateColleaguecolleagues = NIL , NIL ,::oWScreateColleaguecolleagues:Clone() )
	oClone:cresultXML    := ::cresultXML
	oClone:oWSupdateColleaguecolleagues :=  IIF(::oWSupdateColleaguecolleagues = NIL , NIL ,::oWSupdateColleaguecolleagues:Clone() )
	oClone:oWScreateColleaguewithDependenciescolleagues :=  IIF(::oWScreateColleaguewithDependenciescolleagues = NIL , NIL ,::oWScreateColleaguewithDependenciescolleagues:Clone() )
	oClone:oWScreateColleaguewithDependenciesgroups :=  IIF(::oWScreateColleaguewithDependenciesgroups = NIL , NIL ,::oWScreateColleaguewithDependenciesgroups:Clone() )
	oClone:oWScreateColleaguewithDependenciesworkflowRoles :=  IIF(::oWScreateColleaguewithDependenciesworkflowRoles = NIL , NIL ,::oWScreateColleaguewithDependenciesworkflowRoles:Clone() )
	oClone:oWSgetColleagueByLogincolleagueId :=  IIF(::oWSgetColleagueByLogincolleagueId = NIL , NIL ,::oWSgetColleagueByLogincolleagueId:Clone() )
	oClone:oWSgetColleaguesresult :=  IIF(::oWSgetColleaguesresult = NIL , NIL ,::oWSgetColleaguesresult:Clone() )
	oClone:oWSupdateColleaguewithDependenciescolleagues :=  IIF(::oWSupdateColleaguewithDependenciescolleagues = NIL , NIL ,::oWSupdateColleaguewithDependenciescolleagues:Clone() )
	oClone:oWSupdateColleaguewithDependenciesgroups :=  IIF(::oWSupdateColleaguewithDependenciesgroups = NIL , NIL ,::oWSupdateColleaguewithDependenciesgroups:Clone() )
	oClone:oWSupdateColleaguewithDependenciesworkflowRoles :=  IIF(::oWSupdateColleaguewithDependenciesworkflowRoles = NIL , NIL ,::oWSupdateColleaguewithDependenciesworkflowRoles:Clone() )
	oClone:ccolleagueXML := ::ccolleagueXML
	oClone:oWSgetColleaguecolab :=  IIF(::oWSgetColleaguecolab = NIL , NIL ,::oWSgetColleaguecolab:Clone() )
Return oClone

// WSDL Method getColleaguesMail of Service WSECMColleagueServiceService

WSMETHOD getColleaguesMail WSSEND cusername,cpassword,ncompanyId,cmail WSRECEIVE oWSgetColleaguesMailresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleaguesMail xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mail", ::cmail, cmail , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getColleaguesMail>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleaguesMail",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetColleaguesMailresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method removeColleague of Service WSECMColleagueServiceService

WSMETHOD removeColleague WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE cresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:removeColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:removeColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"removeColleague",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getSummaryColleagues of Service WSECMColleagueServiceService

WSMETHOD getSummaryColleagues WSSEND ncompanyId WSRECEIVE oWSgetSummaryColleaguesresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getSummaryColleagues xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getSummaryColleagues>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getSummaryColleagues",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetSummaryColleaguesresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method validateColleagueLogin of Service WSECMColleagueServiceService

WSMETHOD validateColleagueLogin WSSEND ncompanyId,ccolleagueId,cpassword WSRECEIVE cresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:validateColleagueLogin xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:validateColleagueLogin>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"validateColleagueLogin",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method activateColleague of Service WSECMColleagueServiceService

WSMETHOD activateColleague WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE cresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:activateColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:activateColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"activateColleague",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getSimpleColleague of Service WSECMColleagueServiceService

WSMETHOD getSimpleColleague WSSEND cusername,cpassword WSRECEIVE oWSgetSimpleColleagueresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getSimpleColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getSimpleColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleague",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetSimpleColleagueresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueDto",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getGroups of Service WSECMColleagueServiceService

WSMETHOD getGroups WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE oWSgetGroupscolab WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getGroups xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getGroups>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"get Groups",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetGroupscolab:SoapRecv( WSAdvValue( oXmlRet,"_COLAB","groupDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createColleague of Service WSECMColleagueServiceService

WSMETHOD createColleague WSSEND cusername,cpassword,ncompanyId,oWScreateColleaguecolleagues WSRECEIVE cresultXML WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:createColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagues", ::oWScreateColleaguecolleagues, oWScreateColleaguecolleagues , "colleagueDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:createColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"createCollegue",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresultXML         :=  WSAdvValue( oXmlRet,"_RESULTXML","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method updateColleague of Service WSECMColleagueServiceService

WSMETHOD updateColleague WSSEND cusername,cpassword,ncompanyId,oWSupdateColleaguecolleagues WSRECEIVE cresultXML WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:updateColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagues", ::oWSupdateColleaguecolleagues, oWSupdateColleaguecolleagues , "colleagueDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:updateColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"updateColleague",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresultXML         :=  WSAdvValue( oXmlRet,"_RESULTXML","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createColleaguewithDependencies of Service WSECMColleagueServiceService

WSMETHOD createColleaguewithDependencies WSSEND cusername,cpassword,ncompanyId,oWScreateColleaguewithDependenciescolleagues,oWScreateColleaguewithDependenciesgroups,oWScreateColleaguewithDependenciesworkflowRoles WSRECEIVE cresultXML WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:createColleaguewithDependencies xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagues", ::oWScreateColleaguewithDependenciescolleagues, oWScreateColleaguewithDependenciescolleagues , "colleagueDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("groups", ::oWScreateColleaguewithDependenciesgroups, oWScreateColleaguewithDependenciesgroups , "groupDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("workflowRoles", ::oWScreateColleaguewithDependenciesworkflowRoles, oWScreateColleaguewithDependenciesworkflowRoles , "workflowRoleDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:createColleaguewithDependencies>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"createColleaguewithDependencies",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresultXML         :=  WSAdvValue( oXmlRet,"_RESULTXML","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getColleagueByLogin of Service WSECMColleagueServiceService

WSMETHOD getColleagueByLogin WSSEND cusername,cpassword WSRECEIVE oWSgetColleagueByLogincolleagueId WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleagueByLogin xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getColleagueByLogin>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleagueByLogin",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetColleagueByLogincolleagueId:SoapRecv( WSAdvValue( oXmlRet,"_COLLEAGUEID","colleagueDto",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getColleaguesCompressedData of Service WSECMColleagueServiceService

WSMETHOD getColleaguesCompressedData WSSEND cusername,cpassword,ncompanyId WSRECEIVE cresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleaguesCompressedData xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getColleaguesCompressedData>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleaguesCompressedData",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getColleagues of Service WSECMColleagueServiceService

WSMETHOD getColleagues WSSEND cusername,cpassword,ncompanyId WSRECEIVE oWSgetColleaguesresult WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleagues xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getColleagues>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleagues",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetColleaguesresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method updateColleaguewithDependencies of Service WSECMColleagueServiceService

WSMETHOD updateColleaguewithDependencies WSSEND cusername,cpassword,ncompanyId,oWSupdateColleaguewithDependenciescolleagues,oWSupdateColleaguewithDependenciesgroups,oWSupdateColleaguewithDependenciesworkflowRoles WSRECEIVE cresultXML WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:updateColleaguewithDependencies xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagues", ::oWSupdateColleaguewithDependenciescolleagues, oWSupdateColleaguewithDependenciescolleagues , "colleagueDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("groups", ::oWSupdateColleaguewithDependenciesgroups, oWSupdateColleaguewithDependenciesgroups , "groupDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("workflowRoles", ::oWSupdateColleaguewithDependenciesworkflowRoles, oWSupdateColleaguewithDependenciesworkflowRoles , "workflowRoleDtoArray", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:updateColleaguewithDependencies>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"updateColleaguewithDependencies",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresultXML         :=  WSAdvValue( oXmlRet,"_RESULTXML","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createColleagueWithMap of Service WSECMColleagueServiceService

WSMETHOD createColleagueWithMap WSSEND cusername,cpassword,ccolleagueXML WSRECEIVE cresultXML WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:createColleagueWithMap xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueXML", ::ccolleagueXML, ccolleagueXML , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:createColleagueWithMap>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"createColleagueWithMap",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::cresultXML         :=  WSAdvValue( oXmlRet,"_RESULTXML","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getColleague of Service WSECMColleagueServiceService

WSMETHOD getColleague WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE oWSgetColleaguecolab WSCLIENT WSECMColleagueServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleague xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.,.F.) 
cSoap += "</q1:getColleague>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleague",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	"http://spdwvapl168/webdesk/ECMColleagueService")

::Init()
::oWSgetColleaguecolab:SoapRecv( WSAdvValue( oXmlRet,"_COLAB","colleagueDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure colleagueDtoArray

WSSTRUCT ECMColleagueServiceService_colleagueDtoArray
	WSDATA   oWSitem                   AS ECMColleagueServiceService_colleagueDto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_colleagueDtoArray
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_colleagueDtoArray
	::oWSitem              := {} // Array Of  ECMColleagueServiceService_COLLEAGUEDTO():New()
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_colleagueDtoArray
	Local oClone := ECMColleagueServiceService_colleagueDtoArray():NEW()
	oClone:oWSitem := NIL
	If ::oWSitem <> NIL 
		oClone:oWSitem := {}
		aEval( ::oWSitem , { |x| aadd( oClone:oWSitem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_colleagueDtoArray
	Local cSoap := ""
	aEval( ::oWSitem , {|x| cSoap := cSoap  +  WSSoapValue("item", x , x , "colleagueDto", .F. , .T., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueServiceService_colleagueDtoArray
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSitem , ECMColleagueServiceService_colleagueDto():New() )
  			::oWSitem[len(::oWSitem)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure colleagueDto

WSSTRUCT ECMColleagueServiceService_colleagueDto
	WSDATA   lactive                   AS boolean OPTIONAL
	WSDATA   ladminUser                AS boolean OPTIONAL
	WSDATA   narea1Id                  AS int OPTIONAL
	WSDATA   narea2Id                  AS int OPTIONAL
	WSDATA   narea3Id                  AS int OPTIONAL
	WSDATA   narea4Id                  AS int OPTIONAL
	WSDATA   narea5Id                  AS int OPTIONAL
	WSDATA   ccolleagueId              AS string OPTIONAL
	WSDATA   ccolleagueName            AS string OPTIONAL
	WSDATA   ccolleaguebackground      AS string OPTIONAL
	WSDATA   ncompanyId                AS long OPTIONAL
	WSDATA   ccurrentProject           AS string OPTIONAL
	WSDATA   cdefaultLanguage          AS string OPTIONAL
	WSDATA   cdialectId                AS string OPTIONAL
	WSDATA   cecmVersion               AS string OPTIONAL
	WSDATA   lemailHtml                AS boolean OPTIONAL
	WSDATA   cespecializationArea      AS string OPTIONAL
	WSDATA   cextensionNr              AS string OPTIONAL
	WSDATA   lgedUser                  AS boolean OPTIONAL
	WSDATA   cgroupId                  AS string OPTIONAL
	WSDATA   lguestUser                AS boolean OPTIONAL
	WSDATA   chomePage                 AS string OPTIONAL
	WSDATA   clogin                    AS string OPTIONAL
	WSDATA   cmail                     AS string OPTIONAL
	WSDATA   nmaxPrivateSize           AS float OPTIONAL
	WSDATA   nmenuConfig               AS int OPTIONAL
	WSDATA   lnominalUser              AS boolean OPTIONAL
	WSDATA   cpasswd                   AS string OPTIONAL
	WSDATA   cphotoPath                AS string OPTIONAL
	WSDATA   nrowId                    AS int OPTIONAL
	WSDATA   csessionId                AS string OPTIONAL
	WSDATA   nusedSpace                AS float OPTIONAL
	WSDATA   cvolumeId                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_colleagueDto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_colleagueDto
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_colleagueDto
	Local oClone := ECMColleagueServiceService_colleagueDto():NEW()
	oClone:lactive              := ::lactive
	oClone:ladminUser           := ::ladminUser
	oClone:narea1Id             := ::narea1Id
	oClone:narea2Id             := ::narea2Id
	oClone:narea3Id             := ::narea3Id
	oClone:narea4Id             := ::narea4Id
	oClone:narea5Id             := ::narea5Id
	oClone:ccolleagueId         := ::ccolleagueId
	oClone:ccolleagueName       := ::ccolleagueName
	oClone:ccolleaguebackground := ::ccolleaguebackground
	oClone:ncompanyId           := ::ncompanyId
	oClone:ccurrentProject      := ::ccurrentProject
	oClone:cdefaultLanguage     := ::cdefaultLanguage
	oClone:cdialectId           := ::cdialectId
	oClone:cecmVersion          := ::cecmVersion
	oClone:lemailHtml           := ::lemailHtml
	oClone:cespecializationArea := ::cespecializationArea
	oClone:cextensionNr         := ::cextensionNr
	oClone:lgedUser             := ::lgedUser
	oClone:cgroupId             := ::cgroupId
	oClone:lguestUser           := ::lguestUser
	oClone:chomePage            := ::chomePage
	oClone:clogin               := ::clogin
	oClone:cmail                := ::cmail
	oClone:nmaxPrivateSize      := ::nmaxPrivateSize
	oClone:nmenuConfig          := ::nmenuConfig
	oClone:lnominalUser         := ::lnominalUser
	oClone:cpasswd              := ::cpasswd
	oClone:cphotoPath           := ::cphotoPath
	oClone:nrowId               := ::nrowId
	oClone:csessionId           := ::csessionId
	oClone:nusedSpace           := ::nusedSpace
	oClone:cvolumeId            := ::cvolumeId
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_colleagueDto
	Local cSoap := ""
	cSoap += WSSoapValue("active", ::lactive, ::lactive , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("adminUser", ::ladminUser, ::ladminUser , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("area1Id", ::narea1Id, ::narea1Id , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("area2Id", ::narea2Id, ::narea2Id , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("area3Id", ::narea3Id, ::narea3Id , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("area4Id", ::narea4Id, ::narea4Id , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("area5Id", ::narea5Id, ::narea5Id , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ::ccolleagueId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("colleagueName", ::ccolleagueName, ::ccolleagueName , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("colleaguebackground", ::ccolleaguebackground, ::ccolleaguebackground , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("companyId", ::ncompanyId, ::ncompanyId , "long", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("currentProject", ::ccurrentProject, ::ccurrentProject , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("defaultLanguage", ::cdefaultLanguage, ::cdefaultLanguage , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dialectId", ::cdialectId, ::cdialectId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ecmVersion", ::cecmVersion, ::cecmVersion , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("emailHtml", ::lemailHtml, ::lemailHtml , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("especializationArea", ::cespecializationArea, ::cespecializationArea , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("extensionNr", ::cextensionNr, ::cextensionNr , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("gedUser", ::lgedUser, ::lgedUser , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("groupId", ::cgroupId, ::cgroupId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("guestUser", ::lguestUser, ::lguestUser , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("homePage", ::chomePage, ::chomePage , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("login", ::clogin, ::clogin , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("mail", ::cmail, ::cmail , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("maxPrivateSize", ::nmaxPrivateSize, ::nmaxPrivateSize , "float", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("menuConfig", ::nmenuConfig, ::nmenuConfig , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nominalUser", ::lnominalUser, ::lnominalUser , "boolean", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("passwd", ::cpasswd, ::cpasswd , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("photoPath", ::cphotoPath, ::cphotoPath , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("rowId", ::nrowId, ::nrowId , "int", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sessionId", ::csessionId, ::csessionId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("usedSpace", ::nusedSpace, ::nusedSpace , "float", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("volumeId", ::cvolumeId, ::cvolumeId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueServiceService_colleagueDto
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lactive            :=  WSAdvValue( oResponse,"_ACTIVE","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::ladminUser         :=  WSAdvValue( oResponse,"_ADMINUSER","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::narea1Id           :=  WSAdvValue( oResponse,"_AREA1ID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::narea2Id           :=  WSAdvValue( oResponse,"_AREA2ID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::narea3Id           :=  WSAdvValue( oResponse,"_AREA3ID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::narea4Id           :=  WSAdvValue( oResponse,"_AREA4ID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::narea5Id           :=  WSAdvValue( oResponse,"_AREA5ID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::ccolleagueId       :=  WSAdvValue( oResponse,"_COLLEAGUEID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ccolleagueName     :=  WSAdvValue( oResponse,"_COLLEAGUENAME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ccolleaguebackground :=  WSAdvValue( oResponse,"_COLLEAGUEBACKGROUND","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ncompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","long",NIL,NIL,NIL,"N",NIL,"xs") 
	::ccurrentProject    :=  WSAdvValue( oResponse,"_CURRENTPROJECT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cdefaultLanguage   :=  WSAdvValue( oResponse,"_DEFAULTLANGUAGE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cdialectId         :=  WSAdvValue( oResponse,"_DIALECTID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cecmVersion        :=  WSAdvValue( oResponse,"_ECMVERSION","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lemailHtml         :=  WSAdvValue( oResponse,"_EMAILHTML","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cespecializationArea :=  WSAdvValue( oResponse,"_ESPECIALIZATIONAREA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cextensionNr       :=  WSAdvValue( oResponse,"_EXTENSIONNR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lgedUser           :=  WSAdvValue( oResponse,"_GEDUSER","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cgroupId           :=  WSAdvValue( oResponse,"_GROUPID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lguestUser         :=  WSAdvValue( oResponse,"_GUESTUSER","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::chomePage          :=  WSAdvValue( oResponse,"_HOMEPAGE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::clogin             :=  WSAdvValue( oResponse,"_LOGIN","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cmail              :=  WSAdvValue( oResponse,"_MAIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nmaxPrivateSize    :=  WSAdvValue( oResponse,"_MAXPRIVATESIZE","float",NIL,NIL,NIL,"N",NIL,"xs") 
	::nmenuConfig        :=  WSAdvValue( oResponse,"_MENUCONFIG","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::lnominalUser       :=  WSAdvValue( oResponse,"_NOMINALUSER","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cpasswd            :=  WSAdvValue( oResponse,"_PASSWD","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cphotoPath         :=  WSAdvValue( oResponse,"_PHOTOPATH","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nrowId             :=  WSAdvValue( oResponse,"_ROWID","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::csessionId         :=  WSAdvValue( oResponse,"_SESSIONID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nusedSpace         :=  WSAdvValue( oResponse,"_USEDSPACE","float",NIL,NIL,NIL,"N",NIL,"xs") 
	::cvolumeId          :=  WSAdvValue( oResponse,"_VOLUMEID","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure groupDtoArray

WSSTRUCT ECMColleagueServiceService_groupDtoArray
	WSDATA   oWSitem                   AS ECMColleagueServiceService_groupDto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_groupDtoArray
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_groupDtoArray
	::oWSitem              := {} // Array Of  ECMColleagueServiceService_GROUPDTO():New()
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_groupDtoArray
	Local oClone := ECMColleagueServiceService_groupDtoArray():NEW()
	oClone:oWSitem := NIL
	If ::oWSitem <> NIL 
		oClone:oWSitem := {}
		aEval( ::oWSitem , { |x| aadd( oClone:oWSitem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_groupDtoArray
	Local cSoap := ""
	aEval( ::oWSitem , {|x| cSoap := cSoap  +  WSSoapValue("item", x , x , "groupDto", .F. , .T., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueServiceService_groupDtoArray
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSitem , ECMColleagueServiceService_groupDto():New() )
  			::oWSitem[len(::oWSitem)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure workflowRoleDtoArray

WSSTRUCT ECMColleagueServiceService_workflowRoleDtoArray
	WSDATA   oWSitem                   AS ECMColleagueServiceService_workflowRoleDto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_workflowRoleDtoArray
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_workflowRoleDtoArray
	::oWSitem              := {} // Array Of  ECMColleagueServiceService_WORKFLOWROLEDTO():New()
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_workflowRoleDtoArray
	Local oClone := ECMColleagueServiceService_workflowRoleDtoArray():NEW()
	oClone:oWSitem := NIL
	If ::oWSitem <> NIL 
		oClone:oWSitem := {}
		aEval( ::oWSitem , { |x| aadd( oClone:oWSitem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_workflowRoleDtoArray
	Local cSoap := ""
	aEval( ::oWSitem , {|x| cSoap := cSoap  +  WSSoapValue("item", x , x , "workflowRoleDto", .F. , .T., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure groupDto

WSSTRUCT ECMColleagueServiceService_groupDto
	WSDATA   ncompanyId                AS long OPTIONAL
	WSDATA   cfoo                      AS string OPTIONAL
	WSDATA   cgroupDescription         AS string OPTIONAL
	WSDATA   cgroupId                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_groupDto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_groupDto
	::cfoo                 := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_groupDto
	Local oClone := ECMColleagueServiceService_groupDto():NEW()
	oClone:ncompanyId           := ::ncompanyId
	oClone:cfoo                 := IIf(::cfoo <> NIL , aClone(::cfoo) , NIL )
	oClone:cgroupDescription    := ::cgroupDescription
	oClone:cgroupId             := ::cgroupId
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_groupDto
	Local cSoap := ""
	cSoap += WSSoapValue("companyId", ::ncompanyId, ::ncompanyId , "long", .F. , .T., 0 , NIL, .F.,.F.) 
	aEval( ::cfoo , {|x| cSoap := cSoap  +  WSSoapValue("foo", x , x , "string", .F. , .T., 0 , NIL, .F.,.F.)  } ) 
	cSoap += WSSoapValue("groupDescription", ::cgroupDescription, ::cgroupDescription , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("groupId", ::cgroupId, ::cgroupId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueServiceService_groupDto
	Local oNodes2 :=  WSAdvValue( oResponse,"_FOO","string",{},NIL,.T.,"S",NIL,"xs") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ncompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","long",NIL,NIL,NIL,"N",NIL,"xs") 
	aEval(oNodes2 , { |x| aadd(::cfoo ,  x:TEXT  ) } )
	::cgroupDescription  :=  WSAdvValue( oResponse,"_GROUPDESCRIPTION","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cgroupId           :=  WSAdvValue( oResponse,"_GROUPID","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure workflowRoleDto

WSSTRUCT ECMColleagueServiceService_workflowRoleDto
	WSDATA   ncompanyId                AS long OPTIONAL
	WSDATA   cfoo                      AS string OPTIONAL
	WSDATA   croleDescription          AS string OPTIONAL
	WSDATA   croleId                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueServiceService_workflowRoleDto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueServiceService_workflowRoleDto
	::cfoo                 := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT ECMColleagueServiceService_workflowRoleDto
	Local oClone := ECMColleagueServiceService_workflowRoleDto():NEW()
	oClone:ncompanyId           := ::ncompanyId
	oClone:cfoo                 := IIf(::cfoo <> NIL , aClone(::cfoo) , NIL )
	oClone:croleDescription     := ::croleDescription
	oClone:croleId              := ::croleId
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueServiceService_workflowRoleDto
	Local cSoap := ""
	cSoap += WSSoapValue("companyId", ::ncompanyId, ::ncompanyId , "long", .F. , .T., 0 , NIL, .F.,.F.) 
	aEval( ::cfoo , {|x| cSoap := cSoap  +  WSSoapValue("foo", x , x , "string", .F. , .T., 0 , NIL, .F.,.F.)  } ) 
	cSoap += WSSoapValue("roleDescription", ::croleDescription, ::croleDescription , "string", .F. , .T., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("roleId", ::croleId, ::croleId , "string", .F. , .T., 0 , NIL, .F.,.F.) 
Return cSoap


