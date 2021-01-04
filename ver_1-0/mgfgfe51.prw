#include "totvs.ch"
#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFGFE51
Autor...............: Paulo Henrique
Data................: 14/08/2019
Descricao / Objetivo: GEST�O DE FRETE EMBARCADOR
Doc. Origem.........: RITM0023464 - DEV - AUDITORIA - GFE - FRETE CALCULO AUTOMATICO
Solicitante.........: Auditoria
Uso.................: Marfrig
Obs.................: Fun��o que efetua o bloqueio dos campos

a) Tipo de ve�culo
b) Placa do ve�culo
c) Percurso

Quando os campos abaixo:

a) Usu�rio de calculo = CALCULO AUTOM�TICO
b) Origem da integra��o = 2 (ERP/Taura)
c) Situa��o de Calculo = 1 (Calculado com sucesso) - Paulo Henrique - TOTVS - 27/08/2019
=====================================================================================
*/
User Function MGFGFE51

Local lRet := .T.

// Executa a condi��o, somente quando as tr�s condi��es forem satisfeitas
If  AllTrim(GWN->GWN_USUIMP) == "CALCULO AUTOMATICO" .And. ;
    AllTrim(GWN->GWN_ORI) == "2" .And. ;
    AllTrim(GWN->GWN_CALC) == "1"
    lRet := .F.
EndIf
	
Return(lRet)