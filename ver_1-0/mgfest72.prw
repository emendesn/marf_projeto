#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "fwbrowse.ch"
#include "tbiconn.ch"
#include 'fwmvcdef.ch'
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include 'DIRECTRY.CH'

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa............: MGFEST72
Autor...............: Wagner Neves
Data................: 29/04/2020
Descricao / Objetivo: Aprovacao das SA de EPI
Solicitante.........: Cliente
Uso.................: 
Obs.................: Aprovacoes
Data................: 29/04/2020
=====================================================================================
*/
User Function MGFEST72()

	Local cAlias := "ZG6"
	Private _cNivel     := ' '
	Private cCadastro   := "Aprovacao de SA - Controle de EPI"
	Private aRotina     := {}
	Private aIndexNF    := {}
	Private cFiltro     := ''
	Private bFiltraBrw  := ''
	Private aCores      := {}

	If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial esta autorizada ao tratamento de EPI
		MsgAlert("Esta filial nao esta habilitada para executar essa rotina-MGFEST72","MGF_EPIFIL")
		Return
	ENDIF

	//Verificar nivel do aprovador
	_wArea := GetArea()
	ZG5->(DbSetOrder(2))
	If ZG5->(DbSeek(xFilial("ZG5")+__cUserId))
		_cNivel := ZG5->ZG5_NIVEL
	EndIf
	RestArea(_wArea)
	//

	AADD(aRotina,{"Pesquisar"   ,   "PesqBrw"       ,0,1})
	AADD(aRotina,{"Visualiza"   ,   "AxVisual"  	,0,2})
	AADD(aRotina,{"Aprovar SA"  ,   "u_Est72Apr()"  ,0,3})
	AADD(aRotina,{"Rejeitar SA" ,   "u_Est72Rej()"  ,0,4})
	AADD(aRotina,{"Legenda"     ,   "U_Est72Leg()"  ,0,6})

	AADD(aCores,{"ZG6_STATUS ==' ' ","BR_AZUL" })
	AADD(aCores,{"ZG6_STATUS =='A' ","BR_VERDE" })
	AADD(aCores,{"ZG6_STATUS =='R' ","BR_VERMELHO" })

	dbSelectArea(cAlias)
	dbSetOrder(1)


	cFiltro  += "  ZG6_USUAPR == '"+__cUserId+"'"
	cFiltro  += "  .AND. ZG6_FILIAL == '"+ cFilAnt+"'"
	cFiltro  += "  .AND. ZG6_NIVEL == '"+ _cNivel+"'"
	cFiltro  += "  .AND. ZG6_STATUS =' '"

	bFiltraBrw  := {|| FilBrowse('ZG6',@aIndexNF,@cFiltro,.T.) }

	Eval(bFiltraBrw)

	//mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
	MBrowse(06, 01, 22, 75, cAlias,,,,,, aCores,,,,,,,,, 60000, {|| o := GetMBrowse(), o:GoBottom(), o:GoTop(), o:Refresh() })

Return

User Function Est72Leg()

	Local aLegenda := {}
	AADD(aLegenda,{"BR_AZUL"     ,"SA Pendente de Aprovacao." })
	AADD(aLegenda,{"BR_VERDE"    ,"SA Aprovada." })
	AADD(aLegenda,{"BR_VERMELHO" ,"SA Rejeitada" })
	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

User Function Est72Apr()
	Local lChkSerEsp	:= .F.
	Local lGrv := .F.
	Local cQryEst71		:= ""
	Local cQryEst71A	:= ""
	Local cQryEst72		:= ""
	Local cQryEst73		:= ""
	Local cMatFun 		:= ZG6->ZG6_ZMATFU

// Aprovacao ADM
	If _cNivel == 'A'
		cQryEst71 := ' '
		cQryEst71 := "SELECT COUNT( * ) E71COUNT"				        +CRLF
		cQryEst71 += " FROM " + RetSqlName("ZG6") + " ZG6"		        +CRLF
		cQryEst71 += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst71 += "  AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"      +CRLF
		cQryEst71 += "	AND ZG6_NIVEL	=	'A' "                       +CRLF
		cQryEst71 += "	AND ZG6_STATUS  = '1'"                          +CRLF
		cQryEst71 += " 	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst71 += " 	AND ZG6.D_E_L_E_T_ = ' ' "
		TcQuery cQryEst71 New Alias "QRYEST71"
		If QRYEST71->E71COUNT = 0
			lChkSerEsp := .T.
		Else
			Help(NIL, NIL, "Aprovacao Administrativa", NIL, "A Aprovacao Administrativa j� foi realizada para esta SA.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"SA j� liberada pela �rea Administrativa"})
			QRYEST71->(DbCloseArea())
			Return
		EndIf
		QRYEST71->(DbCloseArea())
	EndIf

// Aprovacao TEC
	If _cNivel == 'T'
		cQryEst72 := ' '
		cQryEst72 := "SELECT COUNT( * ) E72COUNT"				        +CRLF
		cQryEst72 += " FROM " + RetSqlName("ZG6") + " ZG6"		        +CRLF
		cQryEst72 += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst72 += "  AND ZG6_ITEM  	=	'" + ZG6->ZG6_ITEM+"'"       +CRLF
		cQryEst72 += "	AND ZG6_NIVEL	=	'A' "                       +CRLF
		cQryEst72 += "	AND ZG6_STATUS  = '1'"                          +CRLF
		cQryEst72 += " 	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst72 += " 	AND ZG6.D_E_L_E_T_ = ' ' "
		TcQuery cQryEst72 New Alias "QRYEST72"
		If QRYEST72->E72COUNT > 0
			lChkSerEsp := .T.
		Else
			Help(NIL, NIL, "Aprovacao T�cnica", NIL, "A Aprovacao T�cnica somente podera ser feita apos a aprovacao Administrativa.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Aguarde a aprovacao Administrativa"})
			QRYEST72->(DbCloseArea())
			Return
		EndIf
		QRYEST72->(DbCloseArea())

// Verifica se ja foi feita aprovacao t�cnica para essa SA
		cQryEst73 := ' '
		cQryEst73 := "SELECT COUNT( * ) E73COUNT"				        +CRLF
		cQryEst73 += " FROM " + RetSqlName("ZG6") + " ZG6"		        +CRLF
		cQryEst73 += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst73 += "  AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"     +CRLF
		cQryEst73 += "	AND ZG6_NIVEL	=	'T' "                       +CRLF
		cQryEst73 += "	AND ZG6_STATUS  = '1'"                          +CRLF
		cQryEst73 += " 	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst73 += " 	AND ZG6.D_E_L_E_T_ = ' ' "
		TcQuery cQryEst73 New Alias "QRYEST73"
		If QRYEST73->E73COUNT = 0
			lChkSerEsp := .T.
		Else
			Help(NIL, NIL, "Aprovacao T�cnica", NIL, "A Aprovacao T�cnica j� foi realizada para esta SA.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"SA j� liberada pela �rea T�cnica"})
			QRYEST73->(DbCloseArea())
			Return
		EndIf
		QRYEST73->(DbCloseArea())
	EndIf
	ZG6->(Reclock("ZG6",.F.))
	ZG6->ZG6_USRLIB :=  SUBS(ZG6->ZG6_NOMAPR,1,30) //__cUserId
	ZG6->ZG6_DATLIB := dDataBase
	ZG6->ZG6_HORLIB := Time()
	If _cNivel == 'A' //Admin
		ZG6->ZG6_STATUS := '1'
		lGrv := .t.
	ElseIf _cNivel == 'T'  //Tecnico
		ZG6->ZG6_STATUS := '2'
		lGrv := .t.
	EndIf
	ZG6->(MsUnlock())

	_cChave := ZG6->ZG6_PRODUT + ZG6->ZG6_NUM + ZG6->ZG6_ITEM
	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+_cChave))
		SCP->(Reclock("SCP"))
		If _cNivel == 'A' //Admin
			SCP->CP_ZSTATUS := '01'
			lGrv := .t.
		ElseIf _cNivel == 'T'  //Tecnico
			SCP->CP_ZSTATUS := '02'
			//SCP->CP_STATSA  := 'L'
			lGrv := .t.
		EndIf
		SCP->(MsUnlock())
	ENDIF

	If _cNivel == "A" .And. lGrv
		cQryEst71A := "UPDATE " + RetSqlName("ZG6")  		            +CRLF
		cQryEst71A += "SET ZG6_STATUS  = 'X'"                           +CRLF
		cQryEst71A += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst71A += " AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"      +CRLF
		cQryEst71A += "	AND ZG6_NIVEL	=	'A' "                       +CRLF
		cQryEst71A += "	AND ZG6_STATUS  = ' '"                          +CRLF
		cQryEst71A += "	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQryEst71A) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		ENDIF
	ElseIf _cNivel == "T" .And. lGrv
		cQryEst71A := "UPDATE " + RetSqlName("ZG6")  		            +CRLF
		cQryEst71A += "SET ZG6_STATUS  = 'X'"                           +CRLF
		cQryEst71A += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst71A += " AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"      +CRLF
		cQryEst71A += "	AND ZG6_NIVEL	=	'T' "                       +CRLF
		cQryEst71A += "	AND ZG6_STATUS  = ' '"                          +CRLF
		cQryEst71A += "	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQryEst71A) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		ENDIF
	EndIf

	If _cNivel == "A"
		MsgInfo("Solicita��o ao Armaz�m "+ZG6->ZG6_NUM+" Item : "+ZG6->ZG6_ITEM+" aprovada com sucesso pela �rea Administrativa.","SA Aprovada!!!")
	EndIf

	If _cNivel == "T" .And. lGrv
// Envia para o RH
		fEnviaRh(cMatFun)
	ENDIF
RETURN

User Function Est72Rej()
	Local lGrv := .F.
	Local cRejeita      := .F.
	Local lChkSerEsp	:= .F.
	Local cQryEst71		:= ""
	Local cQryEst72		:= ""

	If _cNivel == 'T'
		cQryEst72 := "SELECT COUNT( * ) E72COUNT"				        +CRLF
		cQryEst72 += " FROM " + RetSqlName("ZG6") + " ZG6"		        +CRLF
		cQryEst72 += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst72 += "	AND ZG6_NIVEL 	=	'A' "                       +CRLF
		cQryEst72 += "	AND ZG6_STATUS  = '1'"                          +CRLF
		cQryEst72 += " 	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst72 += " 	AND ZG6.D_E_L_E_T_ = ' ' "

		TcQuery cQryEst72 New Alias "QRYEST72"
		If QRYEST72->E72COUNT > 0
			lChkSerEsp := .T.
		Else
			Help(NIL, NIL, "Rejeicao T�cnica", NIL, "A rejeicao T�cnica somente podera ser feita apos a Aprovacao Administrativa.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Aguarde a aprovacao Administrativa"})
			QRYEST72->(DbCloseArea())
			Return
		EndIf
		QRYEST72->(DbCloseArea())
	EndIf
	ZG6->(Reclock("ZG6",.F.))
	ZG6->ZG6_USRLIB :=  SUBS(ZG6->ZG6_NOMAPR,1,30)  //__cUserId
	ZG6->ZG6_DATLIB := dDataBase
	ZG6->ZG6_HORLIB := Time()
	If _cNivel == 'A' //Admin
		ZG6->ZG6_STATUS := '3'
		lGrv := .T.
	ElseIf _cNivel == 'T'  //Tecnico
		ZG6->ZG6_STATUS := '4'
		lGrv := .T.
	EndIf
	ZG6->(MsUnlock())

	_cChave := ZG6->ZG6_PRODUT + ZG6->ZG6_NUM + ZG6->ZG6_ITEM
	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+_cChave))
		SCP->(Reclock("SCP"))
		If _cNivel == 'A' //Admin
			SCP->CP_ZSTATUS := '03'
			SCP->CP_STATSA  := 'B'
			lGrv := .T.
		ElseIf _cNivel == 'T'  //Tecnico
			SCP->CP_ZSTATUS := '04'
			SCP->CP_STATSA  := 'B'
			lGrv := .T.
		EndIf
		SCP->(MsUnlock())
	ENDIF

	If _cNivel == "A" .And. lGrv
		cQryEst71A := "UPDATE " + RetSqlName("ZG6")  		            +CRLF
		cQryEst71A += "SET ZG6_STATUS  = 'X'"                           +CRLF
		cQryEst71A += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst71A += " AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"      +CRLF
		//cQryEst71A += "	AND ZG6_NIVEL	=	'A' "                   +CRLF
		cQryEst71A += "	AND ZG6_STATUS  = ' '"                          +CRLF
		cQryEst71A += "	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQryEst71A) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		ENDIF
	ElseIf _cNivel == "T" .And. lGrv
		cQryEst71A := "UPDATE " + RetSqlName("ZG6")  		            +CRLF
		cQryEst71A += "SET ZG6_STATUS  = 'X'"                           +CRLF
		cQryEst71A += " WHERE ZG6_NUM  	=	'" + ZG6->ZG6_NUM+"'"       +CRLF
		cQryEst71A += " AND ZG6_ITEM 	=	'" + ZG6->ZG6_ITEM+"'"      +CRLF
		cQryEst71A += "	AND ZG6_NIVEL	=	'T' "                       +CRLF
		cQryEst71A += "	AND ZG6_STATUS  = ' '"                          +CRLF
		cQryEst71A += "	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
		cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQryEst71A) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		ENDIF
	EndIf
	MsgInfo("Solicita��o ao Armaz�m "+ZG6->ZG6_NUM+" Item : "+ZG6->ZG6_ITEM+" rejeitada com sucesso pela �rea "+IIf(_cNivel="A","Administrativa","T�cnica")+".","SA Rejeitada!!!")
Return


Static Function fEnviaRh(cMatFun)
	Local cHeadRet	   := ""
	Local cUrlFun	   := GetMv("MGF_EPIURL",,"http://spdwvapl203:1685/epi/api/consulta/mapa?matricula=")
	Local aHeadOut	   := {}
	Local nTimeOut	   := 120
	Private _cProdRh   := ''
	Private _cMatFun  := cMatFun
	Private _cUrlPost := GetMv("MGF_EPIFUN",,"http://spdwvapl203:1685/epi/api/equipamento/individual")

	aadd( aHeadOut, 'Content-Type: application/json')
	cUrl		:= cUrlFun+Alltrim(cMatFun)+"&codEquipSupr="+ ALLTRIM(SCP->CP_PRODUTO)
	xPostRet 	:= httpQuote( cUrl/*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
	oFuncionario := nil
	if fwJsonDeserialize( xPostRet, @oFuncionario)
		If Len(oFuncionario) > 0
			_cProdRh  := Alltrim(oFuncionario[1]:codequip)
		EndIf
	EndIf
	//-----| Fazendo a comunica��o com o Barramento |-----\\

	oObjRet 	:= nil
	oCarga 		:= nil
	oWSEST72 	:= nil
	ocarga 		:= EST72CARGA():new()
	ocarga:setDados()
	oWSEST72	:= MGFINT23():new(_cURLPost, ocarga,0, "", "", "", "","","", .T. )
	oWSEST72:lLogInCons := .T.
	_cSavcInt	:= Nil
	_cSavcInt	:= __cInternet
	__cInternet	:= "AUTOMATICO"
	oWSEST72:SendByHttpPost()
	__cInternet := _cSavcInt
	If oWSEST72:lOk
		If fwJsonDeserialize(oWSEST72:cPostRet , @oObjRet)
			EST72GRVLOG()
			MsgInfo("Solicita��o ao Armaz�m aprovada com sucesso pela �rea T�cnica. SA enviada para o RH solicitando aprovacao.","SA Aprovada-T�cnica !!!")
		Else
			MsgAlert("Erro no envio da SA para aprovacao do RH. A aprovacao T�CNICA nao foi realizada. Favor verificar se j� nao foi enviado para o RH uma SA com a mesma matr�cula e produto na data de hoje.","Atencao !!!")
			EST72GRVLOG()
			EST72ROLAPR()
		EndIf
	Else
		MsgAlert("Erro na comunica��o com o RH para envio da SA para aprovacao. Aprovacao T�CNICA nao foi realizada. Favor verificar com a TI se o barramento esta ativo.","Atencao !!!")
		EST72GRVLOG()
		EST72ROLAPR()
	EndIf

Return

Static Function EST72GRVLOG()
	ZG7->(dbSetOrder(1))
	Reclock("ZG7",.T.)
	ZG7->ZG7_FILIAL		:= xFilial("ZG7")
	ZG7->ZG7_DATA 		:= dDataBase
	ZG7->ZG7_HORA 		:= oWSEST72:ctimeini
	ZG7->ZG7_USUENV		:= __cUserId+"-"+Alltrim(UsrFullName(__cUserId))
	ZG7->ZG7_NUMSA 		:= ZG6->ZG6_NUM
	ZG7->ZG7_JASENV 	:= oWSEST72:cjson
	ZG7->ZG7_JASRET 	:= CVALTOCHAR(fwJsonDeserialize(oWSEST72:cPostRet , @oObjRet))
	ZG7->ZG7_STARET	 	:= oWSEST72:cPostRet
	ZG7->ZG7_URLPOS    := _curlpost
	ZG7->ZG7_STAENV 	:= cValtoChar(httpGetStatus())
	ZG7->ZG7_PROD		:= ZG6->ZG6_PRODUT
	ZG7->ZG7_TEMPO 		:= oWSEST72:ctimeproc
	ZG7->(MsUnlock())
Return

Static Function EST72ROLAPR()

// voltando a aprovacao
	cZg6Num := ZG6->ZG6_NUM
	cZg6Item:= ZG6->ZG6_ITEM
	cQryEst72X := "UPDATE " + RetSqlName("ZG6")  		            +CRLF
	cQryEst72X += "SET ZG6_STATUS  = ' ',ZG6_USRLIB=' ',ZG6_HORLIB=' ',ZG6_DATLIB=' '" +CRLF
	cQryEst72X += " WHERE ZG6_NUM  	=	'" + cZg6Num+"'"       +CRLF
	cQryEst72X += " AND ZG6_ITEM 	=	'" + cZg6Item+"'"      +CRLF
	cQryEst72X += "	AND ZG6_NIVEL	=	'T' "                       +CRLF
	cQryEst72X += "	AND ZG6_FILIAL	=	'" + xFilial("ZG6") + "'"   +CRLF
	cQryEst72X += "	AND D_E_L_E_T_ = ' ' "
	IF (TcSQLExec(cQryEst72X) < 0)
		bContinua   := .F.
		MsgStop(TcSQLError())
	ENDIF

	cQryEst72Z := "UPDATE " + RetSqlName("SCP")  		            +CRLF
	cQryEst72Z += "SET CP_ZSTATUS   = '01'" +CRLF
	cQryEst72Z += " WHERE CP_NUM  	=	'" + cZG6Num+"'"       +CRLF
	cQryEst72Z += " AND CP_ITEM  	=	'" + cZG6Item+"'"       +CRLF
	cQryEst72Z += " AND CP_ZSTATUS   = '02'" +CRLF
	cQryEst72Z += "	AND CP_FILIAL	=	'" + xFilial("SCP") + "'"   +CRLF
	cQryEst72Z += "	AND D_E_L_E_T_ = ' ' "
	IF (TcSQLExec(cQryEst72Z) < 0)
		bContinua   := .F.
		MsgStop(TcSQLError())
	ENDIF

RETURN

/*/
	{Protheus.doc} EST72CARGA
	Faz comunica��o com o Barramento via HTTP Post.

	@author Wagner Neves
	@since 05/05/2020
	@type Class
	@param
	@return
/*/
	Class EST72CARGA
		Data applicationArea   			as ApplicationArea

		Data dataAprov					as String
		Data codEquip					as String
		Data matricula					as String
		Data qtdAprov					as Float
		Data nroReqErp					as String
		Data dataRegErp					as String
		Data usuarioErp					as String
		Data codEquipSupr				as String

		Method New()
		Method setDados()
	EndClass

/*/
	{Protheus.doc} ,EST72CARGA->new
	Contrutor de Classe.

	@author Wagner Neves
	@since 05/05/2020

	@type Method
	@param
	@return
/*/
Method new() Class EST72CARGA
	self:applicationArea := ApplicationArea():new()
return

/*/
	{Protheus.doc} EST72CARGA -> setDados
	Metodo para pegar Matricula do Funcion�rio
	@author Wagner Neves
	@since 05/05/2020
	@type Method
	@param
	@return
/*/
Method SetDados() Class EST72CARGA
	Self:dataAprov		:= SUBS(DTOS(ZG6->ZG6_DATLIB),1,4)+"-"+SUBS(DTOS(ZG6->ZG6_DATLIB),5,2)+"-"+SUBS(DTOS(ZG6->ZG6_DATLIB),7,2)+" "+SUBS(ZG6->ZG6_HORLIB,1,5)
	Self:codEquip		:= Alltrim(_cProdRh)
	Self:matricula		:= VAL(SCP->CP_ZMATFUN)
	Self:qtdAprov		:= SCP->CP_QUANT
	Self:nroReqErp		:= Alltrim(SCP->CP_NUM)
	Self:dataRegErp		:= SUBS(DTOS(SCP->CP_EMISSAO),1,4)+"-"+SUBS(DTOS(SCP->CP_EMISSAO),5,2)+"-"+SUBS(DTOS(SCP->CP_EMISSAO),7,2)+" "+SUBS(ZG6->ZG6_HORLIB,1,5) // "2020-05-01 12:10"
	//DTOS(SCP->CP_EMISSAO)
	Self:usuarioErp		:= SUBS(ZG6->ZG6_USRLIB,1,30)
	Self:codEquipSupr	:= ALLTRIM(SCP->CP_PRODUTO)
Return
