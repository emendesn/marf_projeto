#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
/*/{Protheus.doc} xTestTAE17
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function xTestTAE17
	RpcSetType(3)
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif

	U_MGFTAE17("010003","181672-305","3","","")

Return

User Function MGFTAE17(cFilAbate,cNumPed,cStat,cDoc,cSer)

	Local cURLPost		:= GetMV("MGF_TAE10", .F. ,"")
	Local oWSTAE17		:= Nil
	Local bRet          := .F.
	Private oStatus	    := Nil
	Private cFilAb       := cFilAbate
	Private cNum_pedido	:= cNumPed
	Private cStatus		:= cStat
	Private cNum_doc	:= cDoc
	Private cSerie      := cSer

	IF Empty(Alltrim(cNum_doc))
		cStatus := "3"
	EndIF

	oStatus := nil
	oStatus := AE17_STATUSPEDIDO():new()
	oStatus:setDados()
	ostatus:item
	oWSTAE17 := nil
	oWSTAE17 := MGFINT53():new(cURLPost, oStatus,0, "", "", AllTrim(GetMv("MGF_MONI01")),"018",cFilAbate+"-"+Alltrim(cNumPed)+"-"+cStat, .F. , .F. , .T.  )

	StaticCall(MGFTAC01,ForcaIsBlind,oWSTAE17)
	IF oWSTAE17:lOk
		IF oWSTAE17:nStatus == 1
			bRet := .T.
		Else
			Iif(FindFunction("APMsgAlert"), APMsgAlert(oWSTAE17:cDetailInt,), MsgAlert(oWSTAE17:cDetailInt,))
		EndIF
	EndIF


Return bRet


Class AE17_STATUSPEDIDO
	Data applicationArea AS ApplicationArea
	Data Filial AS String
	Data Num_pedido AS String
	Data Status AS String
	Data Num_doc AS String
	Data Serie AS String

	Method New()
	Method setDados()
EndClass

Method new( ) Class AE17_STATUSPEDIDO
	self:applicationArea	:= ApplicationArea():new()
Return

Method setDados( ) Class AE17_STATUSPEDIDO

	Self:Filial		  := cFilAb
	Self:Num_pedido	  := Alltrim(cNum_pedido)
	Self:Status		  := Alltrim(cStatus)
	Self:Num_doc	  := Alltrim(cNum_doc)
	Self:Serie        := Alltrim(cSerie)

Return
