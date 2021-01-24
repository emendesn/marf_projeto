#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN42
Autor....:              Atilio Amarilla
Data.....:              02/02/2017
Descricao / Objetivo:   Valida��o de Natureza em Contas a Pagar (E2_NATUREZ)
Doc. Origem:            Contrato - GAP ID Auditoria Marfrig= 09 (AUDIT05)
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Valida��o para Inclus�o/Altera��o Manual de T�tulos
Obs......:              Valida��o adicional (X3_VLFUSER) para campos E2_NATUREZ
=====================================================================================
*/

User Function MGFFIN42()

Local lRet		:= .T.
//������������������������������������������������������������������������Ŀ
//�GAP AUDIT05 - Valida Uso/Filtro de naturezas com flag ED_ZMANUAL = S    �
//�              para t�tulos a pagar inclu�dos manualmente                �
//��������������������������������������������������������������������������
Local lNatMan	:= GetNewPar("MGF_FIN42A",.T.)
//������������������������������������������������������������������������Ŀ
//�GAP AUDIT05 - Valida permiss�o de altera��o de naturezas para t�tulos   �
//�              inclu�dos via integra��o com outros m�dulos			   �
//��������������������������������������������������������������������������
Local lNatInt	:= GetNewPar("MGF_FIN42B",.F.)

If FunName() $ "FINA050/FINA750/" // Contas a Pagar / Fun��es Contas a Pagar
	If !lNatInt .And. Altera .And. M->E2_NATUREZ # SE2->E2_NATUREZ .And. !AllTrim(SE2->E2_ORIGEM) $ "FINA050/FINA750/"
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("N�o � permitido alterar a natureza em t�tulos gerados"+CRLF+"do processo de integra��o com outros m�dulos!"),{OemToAnsi("Ok")}, 1)
	ElseIf lNatMan .And. "S" <> GetAdvFVal("SED","ED_ZMANUAL",xFilial("SED")+M->E2_NATUREZ,1,"")
		lRet := .F.
		Aviso(OemToAnsi("Atencao!"),OemToAnsi("Natureza inv�lida!"+CRLF+"Verifique c�digos v�lidos na consulta F3."),{OemToAnsi("Ok")}, 1)
	EndIf
EndIf

Return lRet