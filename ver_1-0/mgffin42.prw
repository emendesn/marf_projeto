#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN42
Autor....:              Atilio Amarilla
Data.....:              02/02/2017
Descricao / Objetivo:   Validação de Natureza em Contas a Pagar (E2_NATUREZ)
Doc. Origem:            Contrato - GAP ID Auditoria Marfrig= 09 (AUDIT05)
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Validação para Inclusão/Alteração Manual de Títulos
Obs......:              Validação adicional (X3_VLFUSER) para campos E2_NATUREZ
=====================================================================================
*/

User Function MGFFIN42()

Local lRet		:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP AUDIT05 - Valida Uso/Filtro de naturezas com flag ED_ZMANUAL = S    ³
//³              para títulos a pagar incluídos manualmente                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lNatMan	:= GetNewPar("MGF_FIN42A",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP AUDIT05 - Valida permissão de alteração de naturezas para títulos   ³
//³              incluídos via integração com outros módulos			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lNatInt	:= GetNewPar("MGF_FIN42B",.F.)

If FunName() $ "FINA050/FINA750/" // Contas a Pagar / Funções Contas a Pagar
	If !lNatInt .And. Altera .And. M->E2_NATUREZ # SE2->E2_NATUREZ .And. !AllTrim(SE2->E2_ORIGEM) $ "FINA050/FINA750/"
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("Não é permitido alterar a natureza em títulos gerados"+CRLF+"do processo de integração com outros módulos!"),{OemToAnsi("Ok")}, 1)
	ElseIf lNatMan .And. "S" <> GetAdvFVal("SED","ED_ZMANUAL",xFilial("SED")+M->E2_NATUREZ,1,"")
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("Natureza inválida!"+CRLF+"Verifique códigos válidos na consulta F3."),{OemToAnsi("Ok")}, 1)
	EndIf
EndIf

Return lRet