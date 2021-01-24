#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} MGFEEC29
//TODO Ponto de entrada para alterar o Contas a Receber do Comex quando OffShore
@author leonardo.kume
@since 03/06/2017
@version 6

@type function
/*/
user function MGFEEC29()
	Local lExec := .T.

	Processa({|lEnd| Process29() })
	
Return

Static function Process29()

Local cFile		:= cgetFile()
Local cLinha	:= ""
Local lRet		:= .T.
Local nAux		:= 0
Local aLinhas	:= {}
Local nI		:= 2

ProcRegua(0)

If FT_FUse(cFile) > 0 
	ProcRegua(FT_FLASTREC())
	FT_FGoTop()
	While !FT_FEOF()
		cLinha	:= FT_FREADLN()
		If Empty(cLinha)
	    	FT_FSkip()
	    	Loop
		EndIf
		aAdd(aLinhas,StrToKarr(cLinha,";")) 
		nAux ++
		FT_FSkip()
		IncProc(OemToAnsi("Efetuando Leitura do Arquivo"))
	Enddo
Else
	MsgInfo( 'Não foi possível copiar o arquivo: ' + cFile)
	lRet := .F.
EndIf

For nI := 2 to Len(aLinhas)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+alltrim(aLinhas[nI][1]))
		RecLock("SB1",.F.)
			SB1->B1_DESC	:= aLinhas[nI][2]
		SB1->(MsUnlock())
		DbSelectArea("EE2")
		DbSetOrder(1)
		If !DbSeek(xFilial("EE2")+"3*INGLES-INGLES            "+alltrim(aLinhas[nI][1]))
			RecLock("EE2",.T.)
				EE2->EE2_FILIAL := xFilial("EE2")
				EE2->EE2_CODCAD	:= "3"
				EE2->EE2_COD	:= aLinhas[nI][1]
				EE2->EE2_TIPMEN	:= "*"
				EE2->EE2_IDIOMA	:= "INGLES-INGLES"
				MSMM(NIL,NIL,NIL,AllTrim(aLinhas[nI][3]),1,,,"EE2","EE2_TEXTO")
			EE2->(MsUnlock())
		EndIf
	EndIf
Next nI
	
return .T.