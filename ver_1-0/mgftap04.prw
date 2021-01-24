#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP04
Chamada de execautos MATA250 Apontamento

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
User Function MGFTAP04( aParam )


	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd, nI, nX
	Local cAcao		:= aParam[1]
	Local aRotThread:= aParam[2]
	Local cArqThr	:= aParam[3]
	Local cDirLog	:= aParam[4]
	Local cIdProc	:= aParam[5]
	Local _cuuid	:= aParam[6]
	Local _nRecno   := aParam[7]
	Local cIdProcOri, cIdSeqOri, nRecnoOri
	Local cIdTaur
	Local nOpc		:= IIF(cAcao=="2",5,3)
	Local aErro, cLotCtl
	Local cErro	:= ""
	Local cNumOrd	:= ""
	Local cNumDoc	:= ""
	Local cFilOrd, dDatOrd, cCodPro, nQtdOrd, cTpMov, cTpOrd
	Local aDados := {}
	Local aTables	:= { "SB1" , "SB2" , "SM0" , "SC2" , "SD3" }
	Local cCodInt, cCodTpInt
	Local cArqLog	:= ""
	Local cMsgErr	:= ""
	Local cFunName	:= "MGFTAP04"
	Local _lretloc  := .T.
	Local lRet		:= .T.
	Local nContExec	:= 0
	Local nLimExec, nSleep, cDesEmail, lEnvEmail		
	Local cLocPrd   := ''  
	Local bLocal    := .F.
	Local _cultiml  := " "

	PRIVATE __nRecMGF4 := 0

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	SetFunName(cFunName)

	cCodInt		:= GetMv("MGF_TAP04A",,"001")	// Taura Produção
	cCodTpInt	:= GetMv("MGF_TAP04B",,"002")	// Inclusão OP
	nLimExec	:= GetMv("MGF_TAP04C",,10)		// Número limite de execuções (persistencia)
	lEnvEmail	:= GetMv("MGF_TAP04D",,.T.)		// Envia Email se nContExec > 1 
	cDesEmail	:= GetMv("MGF_TAP04E",,"atilio.duarte@totvs.com.br")	// Destinatario de Email
	nSleep		:= GetMv("MGF_TAP04F",,5000)		// Número limite de execuções (persistencia)

	Private cError

	BEGIN SEQUENCE

		For nI := 1 to Len( aRotThread )
	
			cMsgErr	:= ""
			aRotAuto	:= aRotThread[nI]

			cFilOrd		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_FILIAL"})][2]
			dDatOrd		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_EMISSAO"})][2]
			cNumDoc		:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_DOC"})][2]
			cNumOrd		:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_OP"})][2]
			cCodPro		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_COD"})][2]
			nQtdOrd		:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_QUANT"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_QUANT"})][2],0)
			cTpMov		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPMOV"})][2]
			cTpOrd		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPOP"})][2]
			cLotCtl		:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_LOTECTL"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_LOTECTL"})][2],"")
			dDatVld		:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_DTVALID"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_DTVALID"})][2],CTOD(""))
			cPedLot		:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_ZPEDLOT"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_ZPEDLOT"})][2],"")
			cIdProcOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDPROC'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDPROC'})][2],"")
			cIdSeqOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDSEQOR'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDSEQOR'})][2],"")
			nRecnoOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZRECNO'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZRECNO'})][2],0)
			cIdTaur		:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDTAUR'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDTAUR'})][2],"")
			cCodPA		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZCODPA"})][2]
			cOPTaura	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZOPTAURA"})][2]
            cLocPrd     :=  aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_LOCAL"})][2]
            bLocal      :=  aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__LOCAL"})][2]
			cUUID		:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__UUID"})][2]

			aSize( aRotAuto , Len( aRotAuto ) - 2 )
 
			cFilAnt		:= cFilOrd
			dDataBase	:= dDatOrd

			SB2->( dbSetOrder(1) )
			If !SB2->( dbSeek( cFilOrd+cCodPro+cLocPrd ) )
				CriaSB2(cCodPro,cLocPrd)
			EndIf

			lMsHelpAuto := .T.

			If cAcao == "2"

				SC2->( dbSetOrder(1) ) //D3_FILIAL+D3_DOC+D3_COD
				SC2->( dbSeek( cFilAnt+cNumOrd ) )


				dbSelectArea("SD3")
				SD3->( dbSetOrder(2) ) //D3_FILIAL+D3_DOC+D3_COD
				SD3->( dbSeek( cFilAnt+cNumDoc+cCodPro ) )

				SD3->( dbSetOrder(8) ) //D3_FILIAL+D3_DOC+D3_NUMSEQ

				cNumOrd	:= Stuff( Space(TamSX3("D3_OP")[1]) , 1 , Len(cNumOrd) , cNumOrd )

				If SD3->D3_ESTORNO = ' '

					aDados	:= 	{	{"D3_FILIAL"	, cFilAnt			, Nil},;
					{"D3_DOC"		, cNumDoc			, Nil},;
					{"D3_NUMSEQ"	, SD3->D3_NUMSEQ	, Nil},;
					{"INDEX" 		, 8					, Nil}	}

				Else
					aDados	:=	{}
				EndIf

				aRotAuto := aDados


			EndIf

			If Len( aRotAuto ) > 0

				If SB1->B1_MSBLQL == '1'
					RecLock("SB1",.F.)
					SB1->B1_MSBLQL	:= '2'
					SB1->( msUnlock() )
					lMsBlq			:= .T.
				Else
					lMsBlq			:= .F.
				EndIf

				SC2->( dbSetOrder(1) ) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQ
				SC2->( dbSeek( cFilAnt+cNumOrd ) )

				//Reabre op se precisar
				If !Empty(SC2->C2_DATRF)
					_nsc2pos := SC2->(Recno())
					lOpEnc	:= .T.
					_dorifec := SC2->C2_DATRF
					Reclock("SC2",.F.)
					SC2->C2_DATRF := stod(" ")
					SC2->(Msunlock())
				Else
					lOpEnc	:= .F.
				EndIf

				nContExec	:= 0
				lExec		:= .F.
				cErro 		:= ""

				While !lExec .And. nContExec < nLimExec
					
					nContExec++

					lMsErroAuto := .F.

					msExecAuto({|x,Y| Mata250(x,Y)},aRotAuto,nOpc)

					If nOpc==3
						If QtdComp(nQtdOrd) == QtdComp(GetAdvFVal("SD3","D3_QUANT", xFilial("SD3")+cNumDoc+cCodPro,2,0 ))
							lExec		:= .T.
							If lMsErroAuto
								lMsErroAuto := .F.
							Endif
						Else
							Sleep(nSleep)
							If nContExec == 1
								cErro += cFunName +" - ExecAuto Mata250" + CRLF
								cErro += "Id Proc - "+ cIdProc + CRLF
								cErro += "Filial  - "+ cFilOrd + CRLF
								cErro += "Ordem   - "+ cNumOrd + CRLF
								cErro += "Num.Doc.  "+ cNumDoc + CRLF
								cErro += "Produto - "+ cCodPro + CRLF
								cErro += "Data    - " + DTOC(dDatOrd) + CRLF
								cErro += "Quantid.- " + Tran(nQtdOrd,"@E 999,999,999,999.999") + CRLF
								cErro += "Tp.Ordem- " + cTpOrd + CRLF
								cErro += "Tp.Movto- " + cTpMov + CRLF
								cErro += "OP Taura- " + cOPTaura + CRLF
								cErro += " " + CRLF

							EndIf

							cErro += "Num.Exec- " + AllTrim(Str(nContExec)) + CRLF
							cErro += "B1_COD   - " + SB1->B1_COD + CRLF
							cErro += "B1_MSBLQL- " + SB1->B1_MSBLQL + CRLF
							cErro += " " + CRLF

							aErro := GetAutoGRLog() // Retorna erro em array

							for nX := 1 to len(aErro)
								cErro += aErro[nX] + CRLF
							next nX
						EndIf
					Else
						lExec		:= .T.
					EndIf

				EndDo

				//Fecha novamente op que estava encerrada
				If lOpEnc
					SC2->(Dbgoto(_nsc2pos))
					Reclock("SC2",.F.)
					SC2->C2_DATRF := _dorifec
					SC2->(Msunlock())
				Endif


				If lMsBlq
					RecLock("SB1",.F.)
					SB1->B1_MSBLQL	:= '1'
					SB1->( msUnlock() )
				EndIf
				
				__nRecMGF4	:= 0

				cHorOrd	:= Time()
				cErro := ""
				If !lExec
					cStatus := "3"
				Else
					If lMsErroAuto 

						cStatus := "2"

						cErro := ""
						cErro += cFunName +" - ExecAuto Mata250" + CRLF

						cErro += "Id Proc - "+ cIdProc + CRLF
						cErro += "Filial  - "+ cFilOrd + CRLF
						cErro += "Ordem   - "+ cNumOrd + CRLF
						cErro += "Num.Doc.  "+ cNumDoc + CRLF
						cErro += "Produto - "+ cCodPro + CRLF
						cErro += "Data    - " + DTOC(dDatOrd) + CRLF
						cErro += "Documen.- " + cNumDoc + CRLF
						cErro += " " + CRLF

						aErro := GetAutoGRLog() // Retorna erro em array

						for nX := 1 to len(aErro)
							cErro += aErro[nX] + CRLF
						next nX

					Else

						cStatus := "1"

					EndIf
				EndIf
			Else
				cStatus := "1"
			EndIf

			If cStatus $ "12"
	
				_cultiml := _cuuid
				ZZE->(Dbsetorder(10)) //ZZE_CHAVEA

				If ZZE->(Dbseek(_cultiml))

					Do while  alltrim(_cultiml) == alltrim(ZZE->ZZE_CHAVEA)

						RecLock("ZZE",.F.)
						ZZE->ZZE_OP		:= cNumOrd
						ZZE->ZZE_DOC	:= cNumDoc
						ZZE->ZZE_STATUS	:= cStatus
						ZZE->ZZE_DTPROC	:= DATE()
						ZZE->ZZE_HRPROC	:= TIME()
						ZZE->ZZE_DESCER	:= "["+FunName()+"] "+IIF(cStatus == "1","Ação efetivada.",cMsgErr) 
						ZZE->ZZE_MSGERR	:= cErro

						If cstatus == "1"
							ZZE->ZZE_IDPROC := strzero(SD3->(Recno()),15)
						Endif

						ZZE->( msUnlock() )

						ZZE->(Dbskip())

					Enddo

				Else
					Disarmtransaction()
					_lretloc := .F.
					U_MFCONOUT("Falha de integridade na gravação...") 
					Break
				Endif


				If cstatus == "1"
					Reclock("SD3",.F.)
					SD3->D3_ZCHAVEU := alltrim(_cuuid)
					SD3->(Msunlock())
				Endif

			EndIf

		Next nI

	END SEQUENCE

Return _lretloc
