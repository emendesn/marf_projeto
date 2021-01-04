#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT103PRE
Autor...............: Joni Lima
Data................: 04/11/2016
Descrição / Objetivo: O ponto de entrada MT103PRE está localizado no Documento de Entrada, opção Rateio por Centro de Custo. Ele tem por objetivo retornar os dados dos campos personalizados, no momento em que carrega as definições de um rateio externo, podendo ser visualizados e salvos na tabela SDE (Rateio por Centro de Custo).
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085418
=====================================================================================
*/
User Function MT103PRE()

	Local aExpA1 := PARAMIXB[1]//aHeader
	Local aExpA2 := PARAMIXB[2]//aCols
	
	Local aColsSDE := {}
	
	If Findfunction('U_xMF103PRE')	
		aColsSDE := U_xMF103PRE(aExpA1,aExpA2)
	EndIf
	
Return aColsSDE


