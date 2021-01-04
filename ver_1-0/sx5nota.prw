#Include 'Protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �SX5NOTA() � Autor � Natanael Filho        � Data �16/07/2018���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A finalidade do ponto de entrada SX5NOTA � permitir que o  .���
���          � usu�rio fa�a uma valida��o das s�ries das notas fiscais    ���
���          � de sa�da que deseja considerar no momento da gera��o da NF ���
���          �Deve ser ajustado a linha abaixo de acordo com o padr�o de  ��� 
���          � empresa (EEFF, FF...)                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Tru or False                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SX5NOTA()
Local lRet := .T.

If findFunction("U_MGFFIS37") .AND. lRet
	If SuperGetMV("MGF_FIS37L",.T.,.F.) //Habilita GAP370/MGFFIS37
		lRet := U_MGFFIS37()
	EndIf
EndIf

Return lRet