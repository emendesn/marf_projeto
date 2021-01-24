#INCLUDE "rwMake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA103OK    � Grava Faturas a pagar      � Data � 26/04/19 ���
�������������������������������������������������������������������������Ĵ��
���	                                                                      ���
���	Descri��o � : Ponto de Entrada MTA103OK na fun��o A103LinOk() Rotina  ���
���		de validacao da LinhaOk. Esse ponto permite a alterar o resultado ���
���		da valida��o padr�o para inclus�o/altera��o de registros de       ���
���		entrada, por customiza��es do cliente.                            ���
���		                                                                  ���
���	Programa Fonte                                                        ���
���	Mata103.PRW                                                           ���
���	Sintaxe                                                               ���
���	MTA103OK - Altera o resultado da valida��o padr�o para                ���
���		inclus�o/altera��o de registros de entrada,                       ���
���		por customiza��es do cliente ( ) --> L                     		  ���
���	          � da fatura no SE2 e antes da contabiliza��o.               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA103OK()

	Local lRet	:= .T.

	//Natanael Filho - 26/Abril/2019
	//Rotina para valida��o dos campos D1_CLASFIS,D1_BASNDES,D1_ALQNDES e D1_ICMNDES 
	If lRet .AND. FindFunction("U_MGFFIS48")
		lRet := U_MGFFIS48()
	EndIf
	If lRet .AND. FindFunction("U_MGFFIS51") //Rafael 01/10/2019  - tratativa tes inteligente
		lRet := U_MGFFIS51()
	EndIf



Return lRet