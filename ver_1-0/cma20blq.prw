#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: CMA20BLQ
Autor...............: Marcos Vieira 
Data................: 07/08/2019
Descricao / Objetivo: Tratamento Ajuste de Regra de Toler�ncia na Entrada da NF. 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:  Ponto de entrada no final da fun��o e deve ser utilizado para 
					   regras especificas de bloqueio pertencentes ao usuario onde ser� 
					   controlada pelo retorno do ponto de entrada o qual se for .F. o 
					   documento n�o ser� bloqueao e se .T. ser� bloqueado.
Eventos
=====================================================================================
*/
User Function CMA20BLQ()
Local lRet := PARAMIXB[1]

If Findfunction("U_MGFCOMBA")
	 lRet := U_MGFCOMBA()                                                                  
Endif

Return(lRet) 
