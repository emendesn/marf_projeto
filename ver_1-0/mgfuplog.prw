#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*/{Protheus.doc} MGFUPLOG
//TODO Descricao auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFUPLOG()

	Local cFaile		:= GetSrvProfString("Startpath","")+"UPLOG.TXT"
	Local nQtdArq       := 0
	Local nQtdReg       := 0
	Local nQtdErr       := 0






	nHdFaile := fCreate( cFaile )

	If nHdFaile == -1
		Aviso("Atenção!","Rotina já está em processamento. Operação cancelada",{"Ok"},1,"Rotina em processamento")
		Return
	EndIf







	RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )

	dbSelectArea("ZZE")
	dbSetOrder(1)

	If Iif(FindFunction("APMsgYesNo"), APMsgYesNo("Esta rotina gravará o conteúdo dos arquivos .LOG no campo memo ZEE_MSGERR, deseja continuar?", "Atualização Log Campo Memo"), (cMsgYesNo:="MsgYesNo", &cMsgYesNo.("Esta rotina gravará o conteúdo dos arquivos .LOG no campo memo ZEE_MSGERR, deseja continuar?", "Atualização Log Campo Memo")))

		MsgRun("Aguarde, gravando LOGs ...",,{ ||  MGFUPLOG01() })

	EndIf

	Aviso("Gravação de LOGs","Final de  processamento.",{"Ok"},1,"Atualização de campo ZZE_MSGERR")

Return

Static Function MGFUPLOG01()

	MGFUPLOG02()

	nQtdReg       := 0
	While QRYZZE->(!EOF())

		ZZE->( dbGoTo( QRYZZE->ZZE_RECNO ) )

		nQtdReg++
		If nQtdReg >= nLimReg
			nQtdReg  := 0
			TAE13_ENV(aEnvia)
			aEnvia   := {}
		Else




			AAdd(aEnvia,{QRYZZE->ZZE_RECNO,	    			QRYZZE->ZZE_CHAVEU,	    			QRYZZE->ZZE_STATUS,	    			QRYZZE->ZZE_DESCER, ZZE->ZZE_MSGERR		} )
		EndIF
		QRYZZE->(DBSkip())
		IF QRYZZE->(EOF()) .And.  nQtdReg <> 0
			TAE13_ENV(aEnvia)
		EndIF
	End
	QRYZZE->(DBCloseArea())

	Fclose( nHdFaile )

	ConOut("Taura Producao - MGFTAP13 - Finalizando Integracao de Retorno")
	




	RpcClearEnv()

Return


Static Function MGFUPLOG02()

	Local cQryZZE  := ""

	cQryZZE := "SELECT ZZE_FILIAL, ZZE_MSGERR  " + Chr(13)+Chr(10)
	cQryZZE += " FROM "	+ RetSQLName("ZZE") + " ZZE "	+ Chr(13)+Chr(10)
	cQryZZE += " WHERE ZZE.D_E_L_E_T_	=	' ' "	+ Chr(13)+Chr(10)
	cQryZZE += " 	AND	ZZE_STATUS	= '2' "	+ Chr(13)+Chr(10)
	cQryZZE += " 	AND INSTR('.LOG',ZZE_ZZE_DESCER) > 0 "+Chr(13)+Chr(10)
	cQryZZE += "GROUP BY ZZE_FILIAL, ZZE_MSGERR "	+ Chr(13)+Chr(10)
	cQryZZE += "ORDER BY 1, 2 "	+ Chr(13)+Chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,ChangeQuery(cQryZZE)), "QRYZZE" , .F. , .T. )

Return













Static Function LerTxt(cArqTxt)

	Local cRet	:= ""
	Local cLin	:= ""
	Local lLin	:= .F.
	Local nHandle

	If nHandle := FT_FUSE(cArqTxt) > 0
		While !FT_FEOF()
			cRet += Ft_Freadln()
			If !lLin
				lLin := .T.
				cLin += cRet
			EndIf
			FT_FSkip()
		EndDo

		FT_FUse()
	EndIf

Return( { cLin , cRet } )




Static Function TAE13_ENV(aEnvia)

	Local cRet := "-1"
	Local cUpd := ""
	Private oRetTP13   := nil
	Private oArrTP13   := nil
	Private aParJob    := ACLONE(aEnvia)


	oRetTP13 := nil
	oRetTP13 := RetTP13():new()
	oRetTP13:CHAVES := {}

	For nI := 1  To Len(aParJob)
		cRet        += ","+Alltrim(STR(aParJob[nI,01]))
		oRetTP13:SetRetTP13()
	next

	cJson := fwJsonSerialize(oRetTP13, .F. , .T. )



	cJson := StrTran(cJson,"CHAVEUID"		,"ChaveUID")
	cJson := StrTran(cJson,"MENSAGEM"		,"Mensagem")
	cJson := StrTran(cJson,"SUCESSO"		,"Sucesso")
	cJson := StrTran(cJson,"CHAVES"	     	,"Chaves")



	oWSRetTP13 := nil
	oWSRetTP13 := MGFINT23():new(cURLPost, oRetTP13, , ,""  , cCodInt , cTipInt, "RET PROD"  , .F. , .F. ,lMonitor)
	oWSRetTP13:SendByHttpPost()





	IF oWSRetTP13:lOk
		cUpd := " UPDATE "+RetSqlName("ZZE")
		cUpd += " SET ZZE_RTAURA = 'I' "
		cUpd += " WHERE R_E_C_N_O_ in ("+cRet+")"
		IF (TcSQLExec(cUpd) < 0)
			MemoWrite("c:\temp\"+FunName()+"_erro"+StrTran(Time(),":","")+".txt",TcSQLError())
		EndIF
	EndIF


Return




















Static Function MGFUPLOG03(aEmpSel)

	Local cQryZZE  := ""
	Local cStatus  := GetMv("MGF_TAP13D",,"'1','2','4','5'")
	Local cEmpSel  := "'x'"
	Local nI       := 0



	For nI := 1 To Len(aEmpSel[02])
		cEmpSel += ",'"+aEmpSel[02][nI]+"'"
	next



	cQryZZE := "SELECT R_E_C_N_O_ ZZE_RECNO, ZZE_GERACA, ZZE_HORA, ZZE_IDTAUR, ZZE_ID, ZZE_RTAURA, ZZE_DESCER, ZZE_STATUS, ZZE_CHAVEU " + Chr(13)+Chr(10)
	cQryZZE += " FROM "	+ RetSQLName("ZZE") + " ZZE "	+ Chr(13)+Chr(10)
	cQryZZE += " WHERE ZZE.D_E_L_E_T_	=	' ' "	+ Chr(13)+Chr(10)
	cQryZZE += " 	AND	ZZE_RTAURA	=	' ' "	+ Chr(13)+Chr(10)
	cQryZZE += " 	AND	ZZE_STATUS	IN	("+cStatus+") "	+ Chr(13)+Chr(10)
	cQryZZE += " 	AND	ZZE_CHAVEU <> ' '"
	cQryZZE += " 	AND ZZE.ZZE_IDTAUR <> ' ' "
	cQryZZE += "	AND ZZE_FILIAL in ("+cEmpSel+")"
	cQryZZE += "ORDER BY 1"	+ Chr(13)+Chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,ChangeQuery(cQryZZE)), "QRYZZE" , .F. , .T. )

Return
