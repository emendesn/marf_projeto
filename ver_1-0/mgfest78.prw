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
Programa............: MGFEST78
Autor...............: Wagner Neves
Data................: 29/04/2020
Descricao / Objetivo: Aprovação das SA Embalagens
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Aprovações
Data................: 28/05/2020
=====================================================================================
*/
User Function MGFEST78()
	Local cAlias := "ZGC"
	Private _cNivel     := ' '
	Private cCadastro   := "Aprovação de SA - Embalagens"
	Private aRotina     := {}
	Private aIndexNF    := {}
	Private cFiltro     := ''
	Private bFiltraBrw  := ''
	Private aCores      := {}
	// Definição do parametro MGF_EST76A
//	If !ExisteSx6("MGF_EST76A")
//		CriarSX6("MGF_EST76A", "L", "Permite o processamento da integração embalagens.", ".F." )
//	EndIf
	_lEst76       := GetMv("MGF_EST76A")   // Ativa ou não execução da rotina

	If ! _lEST76
		Return
	Endif

//    If !ExisteSx6("MGF_EST76F")
//		CriarSX6("MGF_EST76F", "C", "Filiais autorizadas a consultar a quantidade de embalagem.", "010003" )
//	EndIf
	_lFilAutorizada := GetMv("MGF_EST76F")  
	iF ! cFilAnt $_lFilAutorizada
		Return
	EndIf
	
	//Verificar nivel do aprovador
	_wArea := GetArea()
	ZGB->(DbSetOrder(2))
	If ZGB->(DbSeek(xFilial("ZGB")+__cUserId))
		_cNivel := ZGB->ZGB_NIVEL
	EndIf
	RestArea(_wArea)
	//

	AADD(aRotina,{"Pesquisar"   ,   "PesqBrw"       ,0,1})
	AADD(aRotina,{"Visualiza"   ,   "AxVisual"  	,0,2})
	AADD(aRotina,{"Aprovar SA"  ,   "u_EST78Apr()"  ,0,3})
	AADD(aRotina,{"Rejeitar SA" ,   "u_EST78Rej()"  ,0,4})
	AADD(aRotina,{"Legenda"     ,   "U_EST78Leg()"  ,0,6})

	AADD(aCores,{"ZGC_STATUS =='7' ","BR_AZUL" })
	AADD(aCores,{"ZGC_STATUS =='A' ","BR_VERDE" })
	AADD(aCores,{"ZGC_STATUS =='R' ","BR_VERMELHO" })

	dbSelectArea(cAlias)
	dbSetOrder(1)

	cFiltro  += "  ZGC_USUAPR == '"+__cUserId+"'"
	cFiltro  += "  .AND. ZGC_FILIAL == '"+ cFilAnt+"'"
	cFiltro  += "  .AND. ZGC_NIVEL == '"+ _cNivel+"'"
	cFiltro  += "  .AND. ZGC_STATUS ='7'"

	bFiltraBrw  := {|| FilBrowse('ZGC',@aIndexNF,@cFiltro,.T.) }

	Eval(bFiltraBrw)

	//mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
	MBrowse(06, 01, 22, 75, cAlias,,,,,, aCores,,,,,,,,, 60000, {|| o := GetMBrowse(), o:GoBottom(), o:GoTop(), o:Refresh() })

Return

User Function EST78Leg()

	Local aLegenda := {}
	AADD(aLegenda,{"BR_AZUL"     ,"SA Pendente de Aprovação." })
	AADD(aLegenda,{"BR_VERDE"    ,"SA Aprovada." })
	AADD(aLegenda,{"BR_VERMELHO" ,"SA Rejeitada" })
	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

User Function EST78Apr()
	Local lChkSerEsp	:= .F.
	Local lGrv			:= .F.
	Local cQryEst71A	:= ""

	ZGC->(Reclock("ZGC",.F.))
	ZGC->ZGC_USRLIB :=  ZGC->ZGC_NOMAPR
	ZGC->ZGC_DATLIB := dDataBase
	ZGC->ZGC_HORLIB := Time()
	ZGC->ZGC_STATUS := '8'
	ZGC->(MsUnlock())

	_cChave := ZGC->ZGC_PRODUT + ZGC->ZGC_NUM + ZGC->ZGC_ITEM
	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+_cChave))
		SCP->(Reclock("SCP"))
		SCP->CP_ZSTATUS := '08'  //Aprovado
		lGrv := .t.
		SCP->(MsUnlock())
	ENDIF

	If _cNivel == "G" .And. lGrv
		cQryEst71A := "UPDATE " + RetSqlName("ZGC")  		            +CRLF
		cQryEst71A += "SET ZGC_STATUS  = 'X'"                           +CRLF
		cQryEst71A += " WHERE ZGC_NUM  	=	'" + ZGC->ZGC_NUM+"'"       +CRLF
		cQryEst71A += " AND ZGC_ITEM 	=	'" + ZGC->ZGC_ITEM+"'"      +CRLF
		cQryEst71A += "	AND ZGC_NIVEL	=	'G' "                       +CRLF
		cQryEst71A += "	AND ZGC_STATUS  = '7'"                          +CRLF
		cQryEst71A += "	AND ZGC_FILIAL	=	'" + xFilial("ZGC") + "'"   +CRLF
		cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQryEst71A) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		ENDIF
	EndIf
	MsgInfo("Solicitação ao Armazém "+ZGC->ZGC_NUM+" Item : "+ZGC->ZGC_ITEM+" aprovada com sucesso pela Gerencia Industrial.","SA Aprovada!!!")
RETURN

User Function EST78Rej()
	Local lGrv := .F.
	Local cRejeita      := .F.
	Local lChkSerEsp	:= .F.
	Local cQryEst71		:= ""

	ZGC->(Reclock("ZGC",.F.))
	ZGC->ZGC_USRLIB := ZGC->ZGC_NOMAPR 
	ZGC->ZGC_DATLIB := dDataBase
	ZGC->ZGC_HORLIB := Time()
	ZGC->ZGC_STATUS := '9' // 9 = rejeitado
	lGrv := .T.
	ZGC->(MsUnlock())

	_cChave := ZGC->ZGC_PRODUT + ZGC->ZGC_NUM + ZGC->ZGC_ITEM
	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+_cChave))
		SCP->(Reclock("SCP"))
		SCP->CP_ZSTATUS := '09' //Rejeitado
		SCP->CP_STATSA  := 'B'
		lGrv := .T.
		SCP->(MsUnlock())
	ENDIF
	cQryEst71A := "UPDATE " + RetSqlName("ZGC")  		            +CRLF
	cQryEst71A += "SET ZGC_STATUS  = 'X'"                           +CRLF
	cQryEst71A += " WHERE ZGC_NUM  	=	'" + ZGC->ZGC_NUM+"'"       +CRLF
	cQryEst71A += " AND ZGC_ITEM 	=	'" + ZGC->ZGC_ITEM+"'"      +CRLF
	cQryEst71A += "	AND ZGC_NIVEL	=	'G' "                       +CRLF
	cQryEst71A += "	AND ZGC_STATUS  = '7'"                          +CRLF
	cQryEst71A += "	AND ZGC_FILIAL	=	'" + xFilial("ZGC") + "'"   +CRLF
	cQryEst71A += "	AND D_E_L_E_T_ = ' ' "
	IF (TcSQLExec(cQryEst71A) < 0)
		bContinua   := .F.
		MsgStop(TcSQLError())
	ENDIF
	MsgInfo("Solicitação ao Armazém "+ZGC->ZGC_NUM+" Item : "+ZGC->ZGC_ITEM+" rejeitada com sucesso pela Gerencia Industrial.","SA Rejeitada!!!")
Return
