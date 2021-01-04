#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT103IPC
Autor...............: Atilio Amarilla
Data................: 07/06/2017
Descri��o / Objetivo: LOCALIZA��O : Function NFePC2Acol() - Esta rotina atualiza o acols, campo descri��o do produto (D1_DESPRO) na sele��o de 
						pedido de compra
Doc. Origem.........: Contrato - GAP 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MT103IPC()

	Local nItem	:= PARAMIXB[1]
	
	If Findfunction('U_MGFCOM32')
		U_MGFCOM32(nItem)
	EndIf
	
Return

