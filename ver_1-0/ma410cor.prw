#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MA410COR
Autor...............: Joni Lima
Data................: 17/10/2016
Descrição / Objetivo: Ponto de Entrada para Ajuste de Legenda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ajusta Legenda do Browse de Pedido de Venda
=====================================================================================
*/
User Function MA410COR()

	Local aRet := PARAMIXB
	Local ni   := 0

	If findfunction("U_MGFFAT14")	
		aRet := U_MGFFAT14(aRet)
	Endif

Return aRet

