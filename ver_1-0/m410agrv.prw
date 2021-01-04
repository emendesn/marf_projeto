#include "protheus.ch"

/*
=====================================================================================
Programa............: M410AGRV
Autor...............: Mauricio Gresele
Data................: 25/10/2016 
Descricao / Objetivo: Ponto de entrada antes de gravar as alteracoes no PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function M410AGRV()

// envia exclusao do PV ao Taura
If FindFunction("U_TAS01M410AGRV")
	U_TAS01M410AGRV(ParamIxb)
Endif		

Return()