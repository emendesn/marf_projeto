#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFAT14
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MA410COR
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ajusta e adiciona Legenda no Browse de pedidos de venda
=====================================================================================
*/
User Function MGFFAT14(aRet)

	Local ni := 0

	Default aRet := {}

	For ni:= 1 to len(aRet)
		//aRet[ni,1] += '.and. (Empty(C5_ZBLQRGA) .or. C5_ZBLQRGA=="L")'
		aRet[ni,1] += '.and. (Empty(C5_ZBLQRGA) .or. C5_ZBLQRGA=="L") .and. (Empty(C5_XORCAME) .or. C5_XORCAME=="N")'
	Next ni

	AADD(aRet,{"C5_ZBLQRGA=='B'"	, "BR_AZUL_CLARO"	, "Pedido Bloqueado por Regra"	})
	AADD(aRet,{"C5_XORCAME=='S'"	, "BR_PINK"			, "Aguardando Salesforce"		})

Return aRet

