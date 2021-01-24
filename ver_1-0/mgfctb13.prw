#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFCTB13
Autor...............: Atilio Amarilla
Data................: 01/11/2017
Descrição / Objetivo: Manutenção de Parâmetros de Fechamento
Doc. Origem.........: Contrato - GAP CTB04
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFCTB13()

	Local aRet := {}
	Local aParamBox := {}

	Local aComboFin := {"Filial "+cFilAnt,"Empresa "+Subs(cFilAnt,1,2),"Grupo"}
	Local cComboFin := "Filial "+cFilAnt

	Local aComboFis := {"Filial "+cFilAnt,"Empresa "+Subs(cFilAnt,1,2),"Grupo"}
	Local cComboFis := "Filial "+cFilAnt

	Local aComboEst := {"Filial "+cFilAnt,"Empresa "+Subs(cFilAnt,1,2),"Grupo"}
	Local cComboEst := "Filial "+cFilAnt

	Local dDataFin	:= GetMV("MV_DATAFIN")
	Local dDataFis	:= GetMV("MV_DATAFIS")
	Local dDataEst	:= GetMV("MV_DBLQMOV")
	Local cAtuaSal	:= GetMV("MV_ATUSAL")

	aAdd(aParamBox,{2,"Replica para filiais",1,{"Não","Sim"},40,"",.T.})

	aAdd(aParamBox,{1,"Data Limite Financeiro",dDataFin,"","","","",50,.T.})

	aAdd(aParamBox,{1,"Data Limite Fiscal"	,dDataFis,"","","","",50,.T.})

	aAdd(aParamBox,{1,"Data Limite Estoque"	,dDataEst,"","","","",50,.T.})

	aAdd(aParamBox,{2,"Atualiza Saldos CTB",1,IIF(cAtuaSal=="N",{"Não","Sim"},{"Sim","Não"}),40,"",.T.})

	If ParamBox(aParamBox,"Parâmetros de Fechamento",@aRet)

		If ValType(aRet[1]) == "C"
			If aRet[1] == "Sim"
				aFilsAtu := MatFilCalc( .T. )
			EndIf
		EndIf

		PutMV("MV_DATAFIN",aRet[2])
		If ValType(aRet[1]) == "C"
			If aRet[1] == "Sim"
				UpdParam("MV_DATAFIN",aRet[2],aFilsAtu)
			EndIf
		EndIf

		PutMV("MV_DATAFIS",aRet[3])
		If ValType(aRet[1]) == "C"
			If aRet[1] == "Sim"
				UpdParam("MV_DATAFIS",aRet[3],aFilsAtu)
			EndIf
		EndIf

		PutMV("MV_DBLQMOV",aRet[4])
		If ValType(aRet[1]) == "C"
			If aRet[1] == "Sim"
				UpdParam("MV_DBLQMOV",aRet[4],aFilsAtu)
			EndIf
		EndIf

		If ValType(aRet[5]) == "C"
			PutMV("MV_ATUSAL",Subs(aRet[5],1,1))
			If ValType(aRet[1]) == "C"
				If aRet[1] == "Sim"
					UpdParam("MV_ATUSAL",Subs(aRet[5],1,1),aFilsAtu)
				EndIf
			EndIf
		EndIf

		//	RVBJ
		If ValType(aRet[1]) == "C" .and. aRet[1] == "Sim"
			GrvLogParam(aParamBox, aRet, aFilsAtu )
		Else
			GrvLogParam(aParamBox, aRet, nil )
		Endif

		Aviso("Marfrig - Parâmetros de Fechamento","Atualização finalizada",{"Ok"})

	Endif


Return

Static Function UpdParam(cParam,dParam,aParam)

	Local cFilOri	:= cFilAnt
	Local nI		:= 0

	For nI := 1 to Len( aParam )
		If aParam[nI,1]
			cFilAnt	:= aParam[nI,2] 
			PutMV(cParam,dParam)
		EndIf
	Next nI

	cFilAnt	:= cFilOri

Return


Static Function GrvLogParam(aParam,xaRet,aParFil)
Local cMsgLog	:=	""
Local nI		:= 	0
Local cFilOri	:= cFilAnt
Local cFilName	:=	FWFilialName()
Local cRespAnt	:=	cRespPar	:=	""
Local lContinua:=	.F.

If ValType(xaRet[1]) == "N"
	aParFil	:=	{}
Endif

//Sempre adiciona a filial corrente
AADD(aParfil, {.T., cFilAnt, cFilName	})

// Monta as mensagens/textos que serão gravados no Log
For nI:=	2	TO		LEN(aParam)
	lContinua:=	.F.	// RVBJ - somente se houve alteracao

	If aParam[nI][1]	==	2

		If ValType( aParam[nI][3] ) == 'N'	// Nao selecionou, entao converte para a resposta
			aParam[nI,3]	:=	aParam[nI][4] [aParam[nI][3]]
		Endif	
		If ValType( xaRet[nI] ) == 'N'	// Nao selecionou, entao converte para a resposta
			xaRet[nI]	:=	aParam[nI][4] [xaRet[nI]]
		Endif	
	EndIf
	If aParam[nI][3]	<> xaRet[nI]
		lContinua:=	.T.
	Endif

	If (lContinua)
		If	aParam[nI][1]	==	1	// GET
			If	Valtype(xaRet[nI])	== "D"
				cRespAnt	:=	DTOC(aParam[nI][3])
				cRespPar	:=	DTOC(xaRet[nI])
			ElseIf	Valtype(xaRet[nI])	== "N"
				cRespAnt	:=	Alltrim(Str(aParam[nI][3]))
				cRespPar	:=	Alltrim(Str(xaRet[nI]))
			ElseIf	Valtype(xaRet[nI])	== "L"

				If (aParam[nI][3])
					cRespAnt	:=	"Verdadeiro"
				Else
					cRespAnt	:=	"Falso"
				Endif

				If (xaRet[nI])
					cRespPar	:=	"Verdadeiro"
				Else
					cRespPar	:=	"Falso"
				Endif
			Else	// == "C"
				cRespAnt	:=	aParam[nI][3]
				cRespPar	:=	xaRet[nI]
			Endif

		ElseIf	aParam[nI][1]	==	2	// COMBO
			cRespAnt	:=	aParam[nI][3]
			cRespPar	:=	aParam[nI][4] [2 ]
		Else
			cRespAnt	:=	xaRet[nI]
			cRespPar	:=	xaRet[nI]
		Endif

		cMsgLog += aParam[nI][2]	+ " de "	+ cRespAnt	+	" para "	+ cRespPar + CRLF
	Endif

Next

// Grava Log para Filial(ais), somente se tiver alteracoes
If ! Empty(cMsgLog)
	For nI	:=	1 to Len(aParFil)
		If (aParFil[nI,1] )
			cFilAnt	:= aParFil[nI,2] 
			GravaZG3(cMsgLog)
		Endif
	Next
Endif

cFilAnt	:= cFilOri
Return

//
Static Function GravaZG3(cDetalhes)
	dbSelectArea("ZG3")
	RecLock("ZG3",.T.)
	ZG3->ZG3_FILIAL		:= xFilial("ZG3")
	ZG3->ZG3_XMSFIL		:= cFilAnt
	ZG3->ZG3_DATA 		:= MsDate()
	ZG3->ZG3_HORA 		:= SubStr(Time(),1,TamSx3("ZG3_HORA")[1])
	ZG3->ZG3_XUSERI		:= cUserName+"-"+Subs(UsrFullName(__cUseriD),1,20)
	ZG3->ZG3_DET		:= cDetalhes
	ZG3->(MsUnlock())
Return
