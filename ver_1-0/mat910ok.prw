#include "protheus.ch"
/*
=====================================================================================
Programa............: MAT910OK
Autor...............: Mauricio Gresele
Data................: Out/2017
Descricao / Objetivo: Ponto de entrada para validar a inclusao da nota de entrada pelo modulo Fiscal
Doc. Origem.........: Fiscal
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
//lRet := ExecBlock("MAT910OK",.F., .F., {dDEmissao, cTipo, cNFiscal, cEspecie, cA100For, cLoja})
User Function MAT910OK()

Local lRet := .T.

// valida inclusao de documento de tranporte por modulo diferente do GFE
If lRet
	If FindFunction("U_MGFEST35")
		lRet := U_MGFEST35()    
	Endif	
Endif	

If Empty(cFormul)
	cFormul := "N"
ENDIF

If lRet
	If IsInCallStack("MATA910")
	If Alltrim(cEspecie) $ 'CTE/CTEOS/SPED' .And. cFormul=='N'
			If FindFunction("U_MGFVAESP")
				lRet := U_MGFVAESP()
			ENDIF
		EndIf
	Endif	
Endif	

If lRet 
	If IsInCallStack("MATA910")
		If Alltrim(cEspecie) $ 'CTE/CTEOS' .And. cFormul=='N'
			If FindFunction("U_MGFCOMBG")
				lRet := U_MGFCOMBG()    
			Endif
		Endif
	EndIf
EndIf

Return(lRet)