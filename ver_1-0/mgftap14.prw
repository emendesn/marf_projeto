#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP14
Gravação de Resultado de Processamento na Tabela ZZE

@author Atilio Amarilla
@since 08/03/2017 
@type Função  
/*/   
User Function MGFTAP14(_cuuid,cStatus,cIdProc,cIdSeq,cMsgErr,cMsgArq, cNumOrd,cNumDoc,cDtProc,cHrProc,cFunName)

	Local _lRetloc	:= .T.
	Local nTamOP	:= TamSX3("ZZE_OP")[1] // TamSX3("C2_NUM")[1]+TamSX3("C2_ITEM")[1]+TamSX3("C2_SEQUEN")[1]
	Local cDirLog	:= GetMv("MGF_TAP02H",,"\TAURA\PRD\LOG\")	// Path de gravação de logs
	Local cArqLog, __cNewArea, cQry, cUpd
	Default _cuuid  := ""

	cNumOrd	:= IIF(cNumOrd==NIL,Space(Len(nTamOP)), Stuff( Space( nTamOP ) , 1 , Len(AllTrim(cNumOrd)) , AllTrim(cNumOrd) ) )
	cNumDoc	:= IIF(cNumDoc==NIL,Space(Len(TamSX3("D3_DOC")[1])), Stuff( Space( TamSX3("D3_DOC")[1] ) , 1 , Len(AllTrim(cNumDoc)) , AllTrim(cNumDoc) ) )
	cDtProc	:= IIF(cDtProc==NIL,Space(8),cDtProc)
	cHrProc := IIF(cHrProc==NIL,Space(8),cHrProc)
	cMsgErr	:= IIF(cMsgErr==NIL,Len(TamSX3("ZZE_DESCER")[1]), Stuff( Space( TamSX3("D3_OP")[1] ) , 1 , Len(cMsgErr) , cMsgErr ) )
	cMsgArq	:= IIF(cMsgArq==NIL,"",cMsgArq)
	cFunName:= IIF(cFunName==NIL,FunName(),cFunName)

	dbSelectArea("ZZE")

	cQry := "SELECT R_E_C_N_O_ ZZE_RECNO "+CRLF
	cQry += "FROM "+RetSqlName("ZZE")+" "+CRLF
	cQry += "WHERE D_E_L_E_T_ = ' ' "+CRLF

	If empty(_cuuid)

		cQry += "	AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "+CRLF
		cQry += "	AND ZZE_IDPROC = '"+cIdProc+"' "+CRLF
		cQry += "	AND ZZE_IDSEQ = '"+cIdSeq+"' "+CRLF

	Else

		cQry += "	AND ZZE_CHAVEU = '"+alltrim(cuuid)+"' "+CRLF

	Endif

	If Select(_carealoc) > 0
		_carealoc->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
	dbSelectArea(_carealoc)
	(_carealoc)->(DbGoTop())

	If (_carealoc)->(!Eof())

		dbSelectArea( _carealoc )
		dbGoTop()
		While !( _carealoc )->(eof())

			ZZE->( dbGoTo( ( _carealoc )->ZZE_RECNO ) )
			RecLock("ZZE",.F.)
			ZZE->ZZE_OP		:= cNumOrd
			ZZE->ZZE_DOC	:= cNumDoc
			ZZE->ZZE_STATUS	:= cStatus
			ZZE->ZZE_DTPROC	:= STOD(cDtProc)
			ZZE->ZZE_HRPROC	:= cHrProc
			ZZE->ZZE_DESCER	:= cMsgErr
			If !Empty( cMsgArq )
				ZZE->ZZE_MSGERR	:= cMsgArq
			EndIf
			ZZE->( msUnlock() )
			( _carealoc )->( dbSkip() ) 

		EndDo

	Else

		_lretloc := .F.

	EndIf

	dbSelectArea( _carealoc )
	dbCloseArea()

Return _lRetloc