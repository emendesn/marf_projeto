#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFEEC77
Autor...............: Joni Lima
Data................: 27/12/2019
Descricao / Objetivo: Funcao para Hora de Inclusao no Embarque
Doc. Origem.........: Contrato AMS - Manutencao
Solicitante.........: Cliente
Uso.................: 
Obs.................: Corrigir o campo de hora de inclusao que esta sendo substituido com o horario do pedido
=====================================================================================
*/
user function MGFEEC77()
	
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If Alltrim(cParam) == "PEDREF_FINAL" //Funcao do gatilho no campo EEC_PEDREF
		M->EEC_ZHRINC := TIME()
	EndIf
	
return Nil