#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFEEC77
Autor...............: Joni Lima
Data................: 27/12/2019
Descrição / Objetivo: Função para Hora de Inclusão no Embarque
Doc. Origem.........: Contrato AMS - Manutenção
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Corrigir o campo de hora de inclusão que está sendo substituido com o horario do pedido
=====================================================================================
*/
user function MGFEEC77()
	
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If Alltrim(cParam) == "PEDREF_FINAL" //Função do gatilho no campo EEC_PEDREF
		M->EEC_ZHRINC := TIME()
	EndIf
	
return Nil