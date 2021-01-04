#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: CMA20BLQ
Autor...............: Marcos Vieira 
Data................: 07/08/2019
Descricao / Objetivo: Tratamento Ajuste de Regra de Tolerancia na Entrada da NF. 
Solicitante.........: Cliente
Uso.................: 
Obs.................:  Ponto de entrada no final da funcao e deve ser utilizado para 
					   regras especificas de bloqueio pertencentes ao usuario onde sera 
					   controlada pelo retorno do ponto de entrada o qual se for .F. o 
					   documento nao sera bloqueao e se .T. sera bloqueado.
Eventos
=====================================================================================
*/
User Function CMA20BLQ()
Local lRet := PARAMIXB[1]

If Findfunction("U_MGFCOMBA")
	 lRet := U_MGFCOMBA()                                                                  
Endif

Return(lRet) 
