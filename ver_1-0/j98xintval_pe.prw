#include "protheus.ch"
#INCLUDE "FWMVCDEF.CH"


/*                                       
=====================================================================================
Programa.:              J98XINTVAL
Autor....:              Marcelo Carneiro
Data.....:              06/09/2019
Descricao / Objetivo:   Integra��o Grade de Aprova��o SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE para verificar se pode ou n�o a integra��o financeira
=====================================================================================
*/
User Function J98XINTVAL()
Local bRet := .F.

IF !INCLUI .AND. !ALTERA
    bRet := .T.
Else
	IF IsInCallStack("U_MGFJUR03") 
		bRet := .T.
	EndIF
EndIF
	
Return bRet

