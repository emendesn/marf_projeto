#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFEEC77
Autor...............: Joni Lima
Data................: 27/12/2019
Descri��o / Objetivo: Fun��o para Hora de Inclus�o no Embarque
Doc. Origem.........: Contrato AMS - Manuten��o
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Corrigir o campo de hora de inclus�o que est� sendo substituido com o horario do pedido
=====================================================================================
*/
user function MGFEEC77()
	
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If Alltrim(cParam) == "PEDREF_FINAL" //Fun��o do gatilho no campo EEC_PEDREF
		M->EEC_ZHRINC := TIME()
	EndIf
	
return Nil