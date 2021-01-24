#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP05
Chamada de execautos MATA240 Mov. Internos (Req/Dev/Ajustes)

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
User Function MGFTAP05( aParam )

	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd, nI, nX
	Local cAcao		:= aParam[1]
	Local aRotThread:= aParam[2]
	Local cArqThr	:= aParam[3]
	Local cDirLog	:= aParam[4]
	Local cIdProc	:= aParam[5]
	Local _cuuid	:= aParam[7]
	Local _nRecno   := aParam[8]
	Local cIdProcOri, cIdSeqOri, nRecnoOri
	Local cLocal    := ''
	Local _cchaved3 := " "
	Local cIdTaur
	Local nOpc		:= IIF(cAcao=="2",5,3)
	Local aErro
	Local cErro		:= ""
	Local _ctmi		:= ""
	Local _cultiml  := ""
	Local cNumOrd	:= ""
	Local cNumDoc	:= ""
	Local lRet      := .T.
	Local cFilOrd, dDatOrd, cCodPro, nQtdOrd, cTpMov, cTpOrd, cLotCtl
	Local cCodLoc
	Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SB8" , "SBC" , "SC2" , "SD3" , "SES", "ZZE" , "SG1" , "SC5" , "SC6" , "SHD" , "SHE" , "SC3" , ;
	"AFM" , "SGJ" , "SX5" , "SZ1" , "SZ2" , "SZ3" }

	Local cCodInt, cCodTpInt
	Local cArqLog	:= "" // Verificar declaração
	Local cMsgErr	:= ""
	Local cFunName	:= "MGFTAP05" // Incluir NomeRotina
	Local lRet		:= .T.
	Local _lretloc  := .T.


	SetFunName(cFunName)

	cCodInt	:= GetMv("MGF_TAP05A",,"001") // Taura Produção
	cCodTpInt	:= GetMv("MGF_TAP05B",,"003") // Req/Dev Produção

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros
	PRIVATE __nRecMGF5 := 0
	Private cError

	BEGIN SEQUENCE

		For nI := 1 to Len( aRotThread )
	
			cMsgErr	:= ""
			aRotAuto	:= aRotThread[nI]

			cFilOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_FILIAL"})][2]
			_ctmi		:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_TM"})][2]
			dDatOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_EMISSAO"})][2]
			cNumOrd	:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_OP"})][2]
			cNumDoc	:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_DOC"})][2]
			cCodPro	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_COD"})][2]
			cLocal  :=  aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "D3_LOCAL"})][2]
			nQtdOrd	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_QUANT"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_QUANT"})][2],0)
			cLotCtl	:= IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_LOTECTL"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_LOTECTL"})][2],"")
			cTpMov	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPMOV"})][2]
			cTpOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPOP"})][2]
			cCodPA	:=		aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZCODPA"})][2]
			dData	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_EMISSAO"})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=="D3_EMISSAO"})][2],CTOD(""))
			cIdProcOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDPROC'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDPROC'})][2],"")
			cIdSeqOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDSEQOR'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDSEQOR'})][2],"")
			nRecnoOri	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZRECNO'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZRECNO'})][2],0)
			cIdTaur	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDTAUR'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='__ZIDTAUR'})][2],"")
			cCodLoc	:=	IIF(aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='D3_LOCAL'})>0,aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1])=='D3_LOCAL'})][2],"")
			cOPTaura	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZOPTAURA"})][2]
			cZZELoc	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZLOCAL"})][2]
			cUUID	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__UUID"})][2]

			SB1->( dbSeek( xFilial("SB1")+cCodPro ) )

			cFilAnt		:= cFilOrd
			dDataBase	:= dDatOrd

			lMsHelpAuto := .T.
			lMsErroAuto := .F.

			If cAcao == "2"

				SC2->( dbSetOrder(1) ) //D3_FILIAL+D3_DOC+D3_COD
				SC2->( dbSeek( cFilAnt+cNumOrd ) )

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

				//Consulta Saldo quando necessário
				lRet := .T.
				IF (cAcao == "1" .and. _ctmi >= '500') .or. (cAcao == "2" .and. _ctmi < '500')
					//Consulta saldo 
					lRet := .F.
					SB2->(dbSetOrder(1))
					If SB2->(dbSeek(xFilial('SB2')+cCodPro+cLocal))
					    IF (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QEMPN)  >= nQtdOrd
							lRet := .T.
						EndIF
						
					EndIf
					If !lRet 
						cStatus := "6"
						cErro   := 'Falta de Saldo'
						cMsgErr := cErro
					Endif
				EndIF

				If lret .AND. SB1->B1_MSBLQL == '1'
					RecLock("SB1",.F.)
					SB1->B1_MSBLQL	:= '2'
					SB1->( msUnlock() )
					lMsBlq			:= .T.
				Else
					lMsBlq			:= .F.
				EndIf

				IF lRet

					//Se for devolução cria registro na SD4
					//Para evitar validação AJUDA:MAIORQUESALDO do padrão
					_npossd4 := 0
					If _ctmi < '500'

						Reclock("SD4",.T.)
						SD4->D4_FILIAL = cFilOrd
						SD4->D4_COD := cCodPro
						SD4->D4_LOCAL := cLocal
						SD4->D4_OP := cNumOrd
						SD4->D4_DATA := dData
						SD4->D4_QTDEORI := -1
						SD4->D4_PRODUTO := cCodPA
						SD4->(Msunlock())
						_npossd4 := SD4->(Recno())

					Endif

					
					SC2->( dbSetOrder(1) ) //D3_FILIAL+D3_DOC+D3_COD
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

					msExecAuto({|x,Y| Mata240(x,Y)},aRotAuto,nOpc)

					//Fecha novamente op que estava encerrada
					If lOpEnc
						SC2->(Dbgoto(_nsc2pos))
						Reclock("SC2",.F.)
						SC2->C2_DATRF := _dorifec
						SC2->(Msunlock())
					Endif

					//Apaga registro criado na SD4 para não poluir a base de dados
					If _npossd4 > 0
						SD4->(Dbgoto(_npossd4))
					
						If alltrim(SD4->D4_FILIAL) == alltrim(cFilOrd) .AND. ;
							alltrim(SD4->D4_COD) == alltrim(cCodPro) .AND. ;
							alltrim(SD4->D4_LOCAL) == alltrim(cLocal) .AND. ;
							alltrim(SD4->D4_OP) ==alltrim(cNumOrd)
						
							Reclock("SD4",.F.)
							SD4->(Dbdelete())
							SD4->(Msunlock())
						
						Endif
					
					Endif

					If lMsBlq
						RecLock("SB1",.F.)
						SB1->B1_MSBLQL	:= '1'
						SB1->( msUnlock() )
					EndIf

					cHorOrd	:= Time()

					cErro := ""
					If lMsErroAuto .And. IIF(cAcao=="1",Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc+cCodPro,2,"" ) ),.T.)

						cStatus := "2"

						cMsgErr := "ExecAuto Mata240"
						
						cErro := ""
						cErro += FunName() +" - ExecAuto Mata240" + CRLF

						cErro += "Id Proc - "+ cIdProc + CRLF
						cErro += "Filial  - "+ cFilOrd + CRLF
						cErro += "Ordem   - "+ cNumOrd + CRLF
						cErro += "Num.Doc.  "+ cNumDoc + CRLF
						cErro += "Produto - "+ cCodPro + CRLF
						cErro += "Lote    - "+ cLotCtl + CRLF
						cErro += "Quant.  - "+ AllTrim(Str(nQtdOrd)) + CRLF
						cErro += "Data    - "+ DTOC(dDatOrd) + CRLF
						cErro += "IdProc  - "+ cIdProc + CRLF
						cErro += " " + CRLF

						aErro := GetAutoGRLog() // Retorna erro em array
				
						for nX := 1 to len(aErro)
							cErro += aErro[nX] + CRLF
						next nX

					Else

						cStatus := "1"

						//Grava referências na SD3
						Reclock("SD3",.F.)
						SD3->D3_ZCHAVEU := alltrim(_cuuid)
						SD3->(Msunlock())
						_cchaved3 := STRZERO(SD3->(Recno()),15)

					EndIf
				EndIF
			Else
				cStatus := "1"
			EndIf

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
					ZZE->ZZE_IDPROC := _cchaved3
					ZZE->( msUnlock() )

					ZZE->(Dbskip())	

				Enddo

			Else

				Disarmtransaction()
				_lretloc := .F.
				U_MFCONOUT("Falha de integridade na gravação...") 
				Break
			
			Endif

		Next nI

	END SEQUENCE

Return .T.

