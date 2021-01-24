#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
/*/{Protheus.doc} xTTAE18
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function xTTAE18
	RpcSetType(3)
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif

	U_MGFTAE18("010003","0000022")

Return

User Function MGFTAE18(vFILAR,vNum_AR)

	Local cURLPost		:= GetMV("MGF_TAE11", .F. ,"")
	Local oWSTAE18		:= Nil
	Local lRet          := .F.
	Private oStatus	    := Nil
	Private cFILAR		:= vFILAR
	Private cNum_AR    	:= vNum_AR

	oStatus := nil
	oStatus := AE18_STATUSAR():new()
	oStatus:setDados()
	oWSTAE18 := nil
	oWSTAE18 := MGFINT53():new(cURLPost, oStatus,0, "", "", AllTrim(GetMv("MGF_MONI01")),"017",vFILAR+"-"+ vNum_AR, .F. , .F. , .T.  )
	StaticCall(MGFTAC01,ForcaIsBlind,oWSTAE18)
	IF oWSTAE18:lOk .AND.  oWSTAE18:nStatus == 1
		lRet := .T.
	EndIF

Return lRet


Class AE18_STATUSAR
	Data applicationArea AS ApplicationArea
	Data Filial AS String
	Data Num_AR AS String

	Method New()
	Method setDados()
EndClass

Method new( ) Class AE18_STATUSAR
	self:applicationArea	:= ApplicationArea():new()
Return

Method setDados( ) Class AE18_STATUSAR

	Self:Filial		  := cFILAR
	Self:Num_AR	      := cNum_AR

Return
