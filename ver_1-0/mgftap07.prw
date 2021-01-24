#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTAP07
Chamada de execauto para Mata650 / Mata250 Encerramento OP
@author  Atilio Amarilla
@since 08/11/2016
*/
User Function MGFTAP07( aParam )

Local aRetorno	:= {{"1",""}}
Local aRotAuto	:= {}
Local dDatIni	:= Date()
Local cHorIni	:= Time()
Local cHorOrd, nI, nX
Local cAcao		:= AllTrim(aParam[1])
Local aRotThread:= aParam[2]
Local cArqThr	:= aParam[3]
Local cDirLog	:= aParam[4]
Local cIdProc	:= aParam[5]
Local nOpc		:= IIF(cAcao=="2",5,3)
Local cFilOrd, cTpOrd, cCodPro
Local aErro
Local cErro		:= ""
Local cNumDoc	:= ""
Local cNumOrd	:= ""
Local nQtdOrd
Local cStatus	:= "1"
Local nRecMon	:= 0
Local nRecSC2	:= 0
Local aTables	:= {	"SB1" , "SB2" , "SM0" , "SB8" , "SBC" , "SC2" , "SD3" , "SES", "ZZE" , "SG1" , "SC5" , "SC6" , "SHD" , "SHE" , "SC3" , ;
"AFM" , "SGJ" , "SX5" , "SZ1" , "SZ2" , "SZ3" }

// Recuperação de Erros - Declaração de variáveis
Local cCodInt, cCodTpInt
Local cMsgErr	:= ""
Local cFunName	:= "" // Incluir NomeRotina
Local lRet		:= .T.
Local _cStusRej     := Alltrim(SuperGetMV("MGF_TAP21B",.T.,'7')) //Estado gravado no ero de processamento do encerramento de OP.

SetFunName("MGFTAP07")

cCodInt	:= GetMv("MGF_TAP07A",,"001") // Taura Produção
cCodTpInt	:= GetMv("MGF_TAP07B",,"005") // Inclusão OP

Private cError

BEGIN SEQUENCE

SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
SC2->( dbSetOrder(1) ) // C2_FILIAL+C2_NUM+C2_ITEM+C2_PRODUTO

For nI := 1 to Len( aRotThread )

	BEGIN TRANSACTION

	cMsgErr	:= ""
	cStatus	:= "1"
	aRotAuto	:= aRotThread[nI]
	
	cFilOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_FILIAL"})][2]
	cNumOrd	:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZNUMOP"})][2]
	cCodPro	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_PRODUTO"})][2]
	nQtdOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_QUANT"})][2]
	cTpMov	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPMOV"})][2]
	cTpOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPOP"})][2]
	dDatOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZDATEM"})][2]
	cIdSeq	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZIDSEQ"})][2]

	cTpOrd	:= Stuff( Space(TamSX3("C2_ITEM")[1]) , 1 , Len(cTpOrd) , cTpOrd )
	cCodPro	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(cCodPro) , cCodPro )
	
	If Empty( cNumOrd )
		cStatus	:= "2"
		cMsgErr	:= "OP Inválida: "+cNumOrd
	EndIf
	
	If cStatus == "1" .And. !SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
		cStatus	:= "2"
		cMsgErr	:= "Código de Produto inválido: "+AllTrim(cCodPro)
	EndIf
	
	If cStatus == "1" 
		SC2->( dbSetOrder(1) )
		If !SC2->( dbSeek( cFilOrd+cNumOrd ) )
			cStatus	:= "2"
			cMsgErr	:= "OP não localizada. Fil/Num/Tipo/Prod: "+AllTrim(cFilOrd)+"/"+AllTrim(Subs(cNumOrd,1,6))+"/"+AllTrim(cTpOrd)+"/"+AllTrim(cCodPro)
		ElseIf cAcao = "1" .And. !Empty(SC2->C2_DATRF)
			cStatus	:= "1"
			cMsgErr	:= "OP já está encerrada. Fil/Num/Tipo/Prod: "+AllTrim(cFilOrd)+"/"+AllTrim(Subs(cNumOrd,1,6))+"/"+AllTrim(cTpOrd)+"/"+AllTrim(cCodPro)
		ElseIf cAcao = "2" .And. Empty(SC2->C2_DATRF)
			cStatus	:= "1"
			cMsgErr	:= "OP não está encerrada. Fil/Num/Tipo/Prod: "+AllTrim(cFilOrd)+"/"+AllTrim(Subs(cNumOrd,1,6))+"/"+AllTrim(cTpOrd)+"/"+AllTrim(cCodPro)
		Else
			nRecSC2 := SC2->( Recno() )
		EndIf
	EndIf

	cFilAnt		:= cFilOrd
	dDataBase	:= dDatOrd

	If cStatus == "1" .And. Empty( cMsgErr )
		
		If cAcao == "2" // Estorno Encerramento OP
			
			If RecLock("SC2",.F.)
				
				SC2->C2_DATRF	:= CTOD("")
				SC2->( msUnlock() )
				cStatus := "1"
				aRetorno	:= {{"1","Encerramento de OP estornado com sucesso"}}
				
			Else
				
				cStatus := "2"
				aRetorno	:= {{"2","Falha em Estorno de Encerramento Mata250."}}
				cMsgErr		:= "Falha na gravação do estorno de encerramento"
				
			EndIf

		Else
			
			If SC2->C2_QUJE = nQtdOrd 

				If RecLock("SC2",.F.)
					
					SC2->C2_DATRF	:= dDataBase

					If SC2->C2_QUANT < SC2->C2_QUJE
						SC2->C2_QUANT := SC2->C2_QUJE
					EndIf
			
					SC2->( msUnlock() )
					
					cStatus := "1"
					aRetorno	:= {{"1","OP encerrada com sucesso"}}

				Else
					
					cStatus := "2"
					aRetorno	:= {{"2","Falha em Encerramento Mata250."}}
					cMsgErr		:= "Falha na gravação do estorno de encerramento"

				EndIf

			Else

				cStatus := _cStusRej
				aRetorno	:= {{"2","Não é possivel encerrar a OP: Quantidade Apontada divergente."}}
				cMsgErr		:= "Quantidade Apontada divergente"
				
			EndIf

			cHorOrd	:= Time()

		EndIf

	EndIf
	
	ZZE->( dbGoTo( aParam[7] ) )
	RecLock("ZZE",.F.)
	ZZE->ZZE_OP		:= cNumOrd
	ZZE->ZZE_DOC	:= cNumDoc
	ZZE->ZZE_STATUS	:= cStatus
	ZZE->ZZE_DTPROC	:= DATE()
	ZZE->ZZE_HRPROC	:= TIME()
	ZZE->ZZE_DESCER	:= "["+FunName()+"] "+IIF(cStatus == "1","Ação efetivada.",cMsgErr) 
	ZZE->ZZE_MSGERR	:= cErro
	ZZE->( msUnlock() )

	END TRANSACTION

Next nI

END SEQUENCE                               

Return .T.


