#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN42
Autor....:              Atilio Amarilla
Data.....:              02/02/2017
Descricao / Objetivo:   Validacao de Natureza em Contas a Pagar (E2_NATUREZ)
Doc. Origem:            Contrato - GAP ID Auditoria Marfrig= 09 (AUDIT05)
Solicitante:            Cliente
Uso......:              
Obs......:              Validacao para Inclusao/Alteracao Manual de Titulos
Obs......:              Validacao adicional (X3_VLFUSER) para campos E2_NATUREZ
=====================================================================================
*/

User Function MGFFIN42()

Local lRet		:= .T.
//������������������������������������������������������������������������Ŀ
//�GAP AUDIT05 - Valida Uso/Filtro de naturezas com flag ED_ZMANUAL = S    �
//�              para titulos a pagar incluidos manualmente                �
//��������������������������������������������������������������������������
Local lNatMan	:= GetNewPar("MGF_FIN42A",.T.)
//������������������������������������������������������������������������Ŀ
//�GAP AUDIT05 - Valida permissao de alteracao de naturezas para titulos   �
//�              incluidos via integracao com outros modulos			   �
//��������������������������������������������������������������������������
Local lNatInt	:= GetNewPar("MGF_FIN42B",.F.)

If FunName() $ "FINA050/FINA750/" // Contas a Pagar / Funcaes Contas a Pagar
	If !lNatInt .And. Altera .And. M->E2_NATUREZ # SE2->E2_NATUREZ .And. !AllTrim(SE2->E2_ORIGEM) $ "FINA050/FINA750/"
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("Nao � permitido alterar a natureza em titulos gerados"+CRLF+"do processo de integracao com outros modulos!"),{OemToAnsi("Ok")}, 1)
	ElseIf lNatMan .And. "S" <> GetAdvFVal("SED","ED_ZMANUAL",xFilial("SED")+M->E2_NATUREZ,1,"")
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("Natureza inv�lida!"+CRLF+"Verifique codigos v�lidos na consulta F3."),{OemToAnsi("Ok")}, 1)
	EndIf
EndIf

Return lRet