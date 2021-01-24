#include "totvs.ch"
#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFGFE51
Autor...............: Paulo Henrique
Data................: 14/08/2019
Descricao / Objetivo: GESTÃO DE FRETE EMBARCADOR
Doc. Origem.........: RITM0023464 - DEV - AUDITORIA - GFE - FRETE CALCULO AUTOMATICO
Solicitante.........: Auditoria
Uso.................: Marfrig
Obs.................: Função que efetua o bloqueio dos campos

a) Tipo de veículo
b) Placa do veículo
c) Percurso

Quando os campos abaixo:

a) Usuário de calculo = CALCULO AUTOMÁTICO
b) Origem da integração = 2 (ERP/Taura)
c) Situação de Calculo = 1 (Calculado com sucesso) - Paulo Henrique - TOTVS - 27/08/2019
=====================================================================================
*/
User Function MGFGFE51

Local lRet := .T.

// Executa a condição, somente quando as três condições forem satisfeitas
If  AllTrim(GWN->GWN_USUIMP) == "CALCULO AUTOMATICO" .And. ;
    AllTrim(GWN->GWN_ORI) == "2" .And. ;
    AllTrim(GWN->GWN_CALC) == "1"
    lRet := .F.
EndIf
	
Return(lRet)