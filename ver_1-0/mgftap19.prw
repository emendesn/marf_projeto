#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP19
Chamada de execautos MATA240/Mata250 - Estornos

@author Atilio Amarilla
@since 20/03/2018 
@type Função  
/*/   
User Function MGFTAP19( aParam )

	Local dDatIni	:= Date()
	Local cHorIni	:= Time()
	Local cHorOrd, nI, nX
	Local _lretloc := .T.
	Local aRotThread:= aParam[1]
	Local cIdProc	:= aParam[2]
	Local _cuuid	:= aParam[3]
	Local _nRecno   := aParam[4]
	Local cIdProcOri, cIdSeqOri, nRecnoOri
	Local cIdTaur
	Local aErro
	Local cErro		:= ""
	Local cNumOrd	:= ""
	Local cNumDoc	:= ""
	Local cFilOrd, cDatOrd, cCodPro, nQtdOrd, cTpMov, cTpOrd, cLotCtl
	Local cCodLoc, nQuant
	Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SB8" , "SBC" , "SC2" , "SD3" , "SES", "ZZE" , "SG1" , "SC5" , "SC6" , "SHD" , "SHE" , "SC3" , ;
	"AFM" , "SGJ" , "SX5" , "SZ1" , "SZ2" , "SZ3" }

	Local cCodInt, cCodTpInt
	Local cArqLog	:= ""
	Local cMsgErr	:= ""
	Local cFunName	:= "MGFTAP19" // Incluir NomeRotina
	Local lRet		:= .T.
	Local cAliasTRB := GetNextAlias()
	Local cQuery, cEndPad
	Local cStatus := "1"     
	Local bProcessa := .F.

	PRIVATE __nRecMGF5 := 0
	Private	dMovBlq
    Private nSaldoAtu  :=  0 
	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros
	Private cError
	Private cMovPrd, cMovDev

	SetFunName(cFunName)

	SB1->(dbSetOrder(1)) //D3_FILIAL+D3_DOC+D3_COD
	SC2->(dbSetOrder(1)) //D3_FILIAL+D3_DOC+D3_COD
	SB2->(dbSetOrder(1)) //B2_FILIAL, B2_LOCAL, B2_COD
	SD3->( dbSetOrder(8) ) //D3_FILIAL+D3_DOC+D3_NUMSEQ


	BEGIN SEQUENCE

		For nI := 1 to Len( aRotThread )

			BEGIN TRANSACTION

			cStatus	:= ""
			cMsgErr	:= ""
			aRotAuto	:= aRotThread[nI]

			cFilOrd	:=	aRotAuto[01]
			cDatOrd	:=	aRotAuto[02]
			cTpOrd	:=	aRotAuto[03]
			cTpMov	:=	aRotAuto[04]
			cCodPA	:=	aRotAuto[05]
			cCodPro	:=	aRotAuto[06]
			cLotCtl	:=  aRotAuto[07]
			cDatVld	:=	aRotAuto[08]
			nQtdOrd	:=	aRotAuto[09]
			cCodLoc	:=	aRotAuto[10]
			cOPTaura:=	aRotAuto[11]
			cIdProc	:=	aRotAuto[12]
			cIdSeq	:=	aRotAuto[13]
			nQtdPcs	:=	aRotAuto[14]
			nQtdCxs	:=	aRotAuto[14]

			SB1->( dbSeek( xFilial("SB1")+cCodPro ) )

			aRotAuto:= {}

			cFilAnt		:= cFilOrd

			dMovBlq	:= GetMV("MV_DBLQMOV")
			dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

			cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integracaoo Taura Producao
			cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad ) 

			cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Producao
			cMovDev		:= GetMv("MGF_TAP02L",,"03/")		// Devolucao (Apontamento de Sub-produto)


			cQuery := "SELECT SUM( D3_QUANT ) D3_QUANT " + CRLF
			cQuery += "FROM "+RetSqlName("SD3")+" SD3 "+CRLF     	
			cQuery += "WHERE SD3.D_E_L_E_T_ = ' ' "+CRLF
			cQuery += "	AND D3_FILIAL = '"+ cFilOrd +"' "+CRLF
			cQuery += "	AND D3_ESTORNO <> 'S' "+CRLF
			cQuery += "	AND D3_COD = '"+cCodPro+"' "+CRLF
			cQuery += "	AND D3_EMISSAO > '" + DTOS(dMovBlq)+"' "+CRLF
			cQuery += "	AND D3_ZOPTAUR = '"+cOPTaura+"' "+CRLF

			If cTpMov $ cMovPrd + cMovDev + "05/99"
				cQuery += "	AND D3_TM < '500' "+CRLF
			Else
				cQuery += "	AND D3_TM > '500' "+CRLF
			EndIf

			If !Empty(cCodLoc)
				cQuery += "	AND D3_LOCAL = '"+cCodLoc+"' "+CRLF
			EndIf

			cQuery	:= ChangeQuery( cQuery )

			DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .F. )

			nQuant	:= (cAliasTRB)->D3_QUANT

			dbSelectArea(cAliasTRB)
			dbCloseArea()

			If nQuant < nQtdOrd

				cStatus := "2"

				cMsgErr	:=	"Nao existe quantidade suficiente em movimentacoes para estorno."

			EndIf                                    

			///Check para saber se tem saldo.
			nSaldoAtu :=  0 
			IF cTpMov $ cMovPrd .OR. cTpMov $ cMovDev .OR. cTpMov $ '99'
			    IF SB2->(dbSeek(xFilial('SB2')+PADR(cCodPro,TamSx3('B1_COD')[1])+SB1->B1_LOCPAD))
                    IF SB2->B2_QATU < nQtdOrd                                         
                    	cStatus := "2"
					    cMsgErr	:=	"Nao existe saldo em estoque para realizar o estorno.(Seek na SB2)"
                    Else 
                        nSaldoAtu := SB2->B2_QATU
                    EndIF
                Else
					cStatus := "2"
					cMsgErr	:=	"Nao existe saldo em estoque para realizar o estorno."
                EndIF
			EndIf

			If cStatus <> "2"
				cQuery := "SELECT SD3.* , (Select F5_TIPO from "+RetSqlName("SF5")+" SF5  Where SF5.D_E_L_E_T_ = ' ' AND F5_FILIAL = '      ' AND F5_CODIGO = D3_TM) F5_TIPO " + CRLF
				cQuery += "FROM "+RetSqlName("SD3")+" SD3 "+CRLF
				cQuery += "WHERE SD3.D_E_L_E_T_ = ' ' "+CRLF
				cQuery += "	AND D3_FILIAL = '"+ cFilOrd +"' "+CRLF
				cQuery += "	AND D3_ESTORNO <> 'S' "+CRLF
				cQuery += "	AND D3_COD = '"+cCodPro+"' "+CRLF
				cQuery += "	AND D3_EMISSAO > '" + DTOS(dMovBlq)+"' "+CRLF
				cQuery += "	AND D3_ZOPTAUR = '"+cOPTaura+"' "+CRLF

				If cTpMov $ cMovPrd + cMovDev + "05/99"
					cQuery += "	AND D3_TM < '500' "+CRLF
				Else
					cQuery += "	AND D3_TM > '500' "+CRLF
				EndIf
				If !Empty(cCodLoc)
					cQuery += "	AND D3_LOCAL = '"+cCodLoc+"' "+CRLF
				EndIf
				cQuery += "ORDER BY R_E_C_N_O_ "+CRLF
								
				cQuery	:= ChangeQuery( cQuery )

				DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .F. )

				nQtdAux	:= 0
				nQtdPcA	:= 0
				nQtdCxA	:= 0
				dbSelectArea(cAliasTRB)
				cStatus	:= "" 
				bProcessa := .F.
				While !(cAliasTRB)->( eof() ) .And. nQtdAux < nQtdOrd .And. cStatus <> "2"

					nQtdAux += (cAliasTRB)->D3_QUANT 
					nQtdPcA += (cAliasTRB)->D3_ZQTDPCS
					nQtdCxA += (cAliasTRB)->D3_ZQTDCXS

					cNumOrd	:= (cAliasTRB)->D3_OP
					cDatOrd	:= (cAliasTRB)->D3_EMISSAO
					cNumDoc	:= (cAliasTRB)->D3_DOC
					cLocal  := (cAliasTRB)->D3_LOCAL

					SC2->( dbSetOrder(1) ) //D3_FILIAL+D3_DOC+D3_COD
					SC2->( dbSeek( cFilAnt+cNumOrd ) )

					SD3->( dbSetOrder(8) ) //D3_FILIAL+D3_DOC+D3_NUMSEQ
					SD3->( dbSeek( cFilAnt+(cAliasTRB)->D3_NUMSEQ ) )

					If nQtdAux > nQtdOrd

						dDataBase	:= STOD( cDatOrd )
						cNumDoc	:= ""

						While Empty(cNumDoc) .Or. !Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc,2,"" ) )
							cNumDoc	:= GetSXENum("SD3","D3_DOC")
							ConfirmSX8()
						EndDo

						aRotAuto:= {}
						aAdd( aRotAuto ,	{"D3_FILIAL"	, (cAliasTRB)->D3_FILIAL		,NIL} )
						aAdd( aRotAuto ,	{"D3_TM"		, (cAliasTRB)->D3_TM			,NIL} )
						aAdd( aRotAuto ,	{"D3_COD"		, SB1->B1_COD					,NIL} )
						aAdd( aRotAuto ,	{"D3_OP"		, (cAliasTRB)->D3_OP			,NIL} )
						aAdd( aRotAuto ,	{"D3_LOCAL"		, (cAliasTRB)->D3_LOCAL			,NIL} )
						aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
						aAdd( aRotAuto ,	{"D3_EMISSAO"	, dDataBase						,NIL} )
						aAdd( aRotAuto ,	{"D3_QUANT"		, nQtdAux - nQtdOrd		,NIL} )

						If nQtdPcA > nQtdPcs
							aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, nQtdPcA - nQtdPcs		,NIL} )
						EndIf

						If nQtdCxA > nQtdCxs
							aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, nQtdCxA - nQtdCxs		,NIL} )
						EndIf

						If (cAliasTRB)->F5_TIPO == 'P'
							aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
						EndIf

						If SB1->B1_LOCALIZ == "S"
							aAdd( aRotAuto ,	{"D3_LOCALIZ"	, cEndPad					,NIL} )
						EndIf

						aAdd( aRotAuto , {"D3_ZOPTAUR"	, (cAliasTRB)->D3_ZOPTAUR			,NIL} )

						If !Empty((cAliasTRB)->D3_ZPEDLOT)
							aAdd( aRotAuto ,	{"D3_ZPEDLOT"	, (cAliasTRB)->D3_ZPEDLOT	,NIL} )
						EndIf
							
						lMsHelpAuto := .T.
						lMsErroAuto := .F.
		
						If SB1->B1_MSBLQL == '1'
							RecLock("SB1",.F.)
							SB1->B1_MSBLQL	:= '2'
							SB1->( msUnlock() )
							lMsBlq			:= .T.
						Else
							lMsBlq			:= .F.
						EndIf

						If !Empty(SC2->C2_DATRF)
							lOpEnc	:= .T.
						Else
							lOpEnc	:= .F.
						EndIf
		
						IF  (cAliasTRB)->F5_TIPO == 'P' .OR. (cAliasTRB)->D3_TM < '500'

							//Se for devolução cria registro na SD4
							//Para evitar validação AJUDA:MAIORQUESALDO do padrão
							_npossd4 := 0

							Reclock("SD4",.T.)
							SD4->D4_FILIAL = cFilOrd
							SD4->D4_COD := cCodPro
							SD4->D4_LOCAL := cLocal
							SD4->D4_OP := cNumOrd
							SD4->D4_DATA := stod(cDatOrd)
							SD4->D4_QTDEORI := -1
							SD4->D4_PRODUTO := cCodPro
							SD4->(Msunlock())
							_npossd4 := SD4->(Recno())

							
							If (cAliasTRB)->F5_TIPO == 'P'					
								msExecAuto({|x,Y| Mata250(x,Y)},aRotAuto,3)
							Else
								msExecAuto({|x,Y| Mata240(x,Y)},aRotAuto,3)
							EndIf
			
							If lMsBlq
								RecLock("SB1",.F.)
								SB1->B1_MSBLQL	:= '1'
								SB1->( msUnlock() )
							EndIf

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
							
							cHorOrd	:= Time()
							cErro := ""

						    If lMsErroAuto .And. Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc+cCodPro,2,"" ) )
									cStatus := "2"
									cMsgErr := "ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno"
									cErro := ""
									cErro += "["+cFunName+"] - ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno" + CRLF
									cErro += IIF(lOpEnc,'OP Encerrada no Protheus'+ CRLF,'')
									cErro += "Filial  - "+ cFilOrd + CRLF
									cErro += "Ordem   - "+ cNumOrd + CRLF
									cErro += "Num.Doc.  "+ cNumDoc + CRLF
									cErro += "Produto - "+ cCodPro + CRLF
									cErro += "Lote    - "+ cLotCtl + CRLF
									cErro += "Data    - "+ DTOC(dDataBase) + CRLF
									cErro += "IdProc  - "+ cIdProc + CRLF
									cErro += "IdSeq   - "+ cIdSeq + CRLF
									cErro += " " + CRLF
									aErro := GetAutoGRLog() // Retorna erro em array MostraErro
						
									for nX := 1 to len(aErro)
										cErro += aErro[nX] + CRLF
									next nX
							Else
								cStatus := "1"
							EndIf

						Else  
						    bProcessa := .T.
						EndIF

					EndIf

                    IF cStatus <> "2"
						aDados	:= 	{	{"D3_FILIAL"	, (cAliasTRB)->D3_FILIAL	, Nil},;
										{"D3_DOC"		, (cAliasTRB)->D3_DOC		, Nil},;
										{"D3_NUMSEQ"	, (cAliasTRB)->D3_NUMSEQ	, Nil},;
										{"INDEX" 		, 8						, Nil}	}
	
						lMsHelpAuto := .T.
						lMsErroAuto := .F.
	
						If SB1->B1_MSBLQL == '1'
							RecLock("SB1",.F.)
							SB1->B1_MSBLQL	:= '2'
							SB1->( msUnlock() )
							lMsBlq			:= .T.
						Else
							lMsBlq			:= .F.
						EndIf
	
						If !Empty(SC2->C2_DATRF)
							lOpEnc	:= .T.
						Else
							lOpEnc	:= .F.
						EndIf

						//Se for devolução cria registro na SD4
						//Para evitar validação AJUDA:MAIORQUESALDO do padrão
						_npossd4 := 0

						Reclock("SD4",.T.)
						SD4->D4_FILIAL = cFilOrd
						SD4->D4_COD := cCodPro
						SD4->D4_LOCAL := cLocal
						SD4->D4_OP := cNumOrd
						SD4->D4_DATA := stod(cDatOrd)
						SD4->D4_QTDEORI := -1
						SD4->D4_PRODUTO := cCodPro
						SD4->(Msunlock())
						_npossd4 := SD4->(Recno())

	
						//-- Chamada da rotina automatica
						If (cAliasTRB)->F5_TIPO == 'P' //cTpMov $ cMovPrd
							msExecAuto({|x,Y| Mata250(x,Y)},aDados,5)
						Else
							msExecAuto({|x,Y| Mata240(x,Y)},aDados,5)
						EndIf
	
						If lMsBlq
							RecLock("SB1",.F.)
							SB1->B1_MSBLQL	:= '1'
							SB1->( msUnlock() )
						EndIf

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
			
						cHorOrd	:= Time()
	
						cErro := ""
	
						If lMsErroAuto
	
							cStatus := "2"
	
							cMsgErr := "ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno"
	
							cErro := ""
							cErro += "["+cFunName+"] - ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno" + CRLF
	
							cErro += "Filial  - "+ cFilOrd + CRLF
							cErro += "Ordem   - "+ cNumOrd + CRLF
							cErro += "Num.Doc.  "+ cNumDoc + CRLF
							cErro += "Produto - "+ cCodPro + CRLF
							cErro += "Lote    - "+ cLotCtl + CRLF
							cErro += "Data    - "+ DTOC(dDataBase) + CRLF
							cErro += "IdProc  - "+ cIdProc + CRLF
							cErro += "IdSeq   - "+ cIdSeq + CRLF
							cErro += " " + CRLF
	
							aErro := GetAutoGRLog() // Retorna erro em array
					
							for nX := 1 to len(aErro)
								cErro += aErro[nX] + CRLF
							next nX
						Else
							cStatus := "1"
						EndIf
	                EndIF
					(cAliasTRB)->( dbSkip() )
				EndDo
				dbSelectArea(cAliasTRB)
				dbCloseArea()
			EndIf

			IF bProcessa

				//Se for devolução cria registro na SD4
				//Para evitar validação AJUDA:MAIORQUESALDO do padrão
				_npossd4 := 0
			
				Reclock("SD4",.T.)
				SD4->D4_FILIAL = cFilOrd
				SD4->D4_COD := cCodPro
				SD4->D4_LOCAL := cLocal
				SD4->D4_OP := cNumOrd
				SD4->D4_DATA := stod(cDatOrd)
				SD4->D4_QTDEORI := -1
				SD4->D4_PRODUTO := cCodPro
				SD4->(Msunlock())
				_npossd4 := SD4->(Recno())


				msExecAuto({|x,Y| Mata240(x,Y)},aRotAuto,3)
				
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
				If lMsErroAuto .And. Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc+cCodPro,2,"" ) )
					cStatus := "2"
					cMsgErr := "ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno"
					cErro := ""
					cErro += "["+cFunName+"] - ExecAuto Mata2"+IIF(cTpMov $ GetMv("MGF_TAP02E",,"01/"),"5","4")+"0 - Estorno" + CRLF
					cErro += IIF(lOpEnc,'OP Encerrada no Protheus'+ CRLF,'')
					cErro += "Filial  - "+ cFilOrd + CRLF
					cErro += "Ordem   - "+ cNumOrd + CRLF
					cErro += "Num.Doc.  "+ cNumDoc + CRLF
					cErro += "Produto - "+ cCodPro + CRLF
					cErro += "Lote    - "+ cLotCtl + CRLF
					cErro += "Data    - "+ DTOC(dDataBase) + CRLF
					cErro += "IdProc  - "+ cIdProc + CRLF
					cErro += "IdSeq   - "+ cIdSeq + CRLF
					cErro += " " + CRLF
					aErro := GetAutoGRLog() // Retorna erro em array MostraErro
					
					for nX := 1 to len(aErro)
						cErro += aErro[nX] + CRLF
					next nX
				Else
					cStatus := "1"
				EndIf
			EndIF
			
						

			cDtProc	:= DTOS( Date() )
			cHrProc	:= Time()

			ZZE->( dbGoTo( _nrecno ) )
			
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

			If cstatus == "1"
				Reclock("SD3",.F.)
				SD3->D3_ZCHAVEU := alltrim(_cuuid)
				SD3->(Msunlock())
			Endif

			END TRANSACTION

		Next nI

	END SEQUENCE

Return _lretloc

