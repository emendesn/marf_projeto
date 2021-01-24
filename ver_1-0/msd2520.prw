#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MSD2520
Autor...............: Joni Lima
Data................: 18/04/2018 
Descricao / Objetivo: Ponto de entrada antes de gravar a Exclusão da Tabela SD2 no Extorno da Nota
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/PROT/MSD2520
=====================================================================================
*/
user function MSD2520()
	
	// exclusao de residuo do pedido, gerado na inclusao da nota	
	If Findfunction("U_MGFFAT28")
		U_MGFFAT28()
	Endif
	
	// exclusao de tabela ZZR - exportacao
	If Findfunction("U_MGFFAT86")
		U_MGFFAT86()
	Endif
	
return