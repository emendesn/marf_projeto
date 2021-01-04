#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFAT15
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MA410LEG
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ajusta e adiciona Legenda no Browse de pedidos de venda
=====================================================================================
*/
User Function MGFFAT15(aRet)

	Default aRet := {}

	AADD(aRet,{"BR_AZUL_CLARO"	,"Pedido Bloqueado por Regra"	})
	AADD(aRet,{"BR_PINK"		,"Aguardando Salesforce"		})

Return aRet

