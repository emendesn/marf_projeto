#include "rwmake.ch"        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � F420SOMA.PRW                                               ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para alterar o valor utilizado na funcao  ���
���          � SOMAVALOR() do cnab a pagar                                ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 02/12/2009                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Utilizado no cnab a pagar   para totalizar os acrescimos   ���
���            e descontos no valor total enviado ao banco no trailler    ���
���            de lote.                                                   ���
��������������������������������������������������������������������������ٱ�
/*/

User Function F420SOMA()        

Local _Valor := 0
Local _Abat  := 0
Local _Juros := 0

_Abat := 0.00
_Abat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Abat  += SE2->(E2_SDDECRE+E2_ZTXBOL+E2_XDESCO)                            
_Juros := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_SDACRES + SE2->E2_ZJURBOL)
_Valor := SE2->E2_SALDO - _Abat + _Juros

Return(_Valor)                                                                         
