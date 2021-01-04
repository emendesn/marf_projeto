#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MA410LEG
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Ponto de entrada para ajuste de legenda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ajusta e adiciona Legenda no Browse de pedidos de venda
=====================================================================================
*/
User Function MA410LEG()

	Local aRet := PARAMIXB

	If findfunction("U_MGFFAT15")	
		aRet := U_MGFFAT15(aRet)
	Endif

Return aRet

