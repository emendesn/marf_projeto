/*
=====================================================================================
Programa.:              CN120CMP
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   PE acionado na consulta de contratos, F3.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina CNTA120.
=====================================================================================
*/
User Function CN120CMP()

Local aRet	:= ""
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒AP 75_82 - Incluir campo para nome de fornecedor na consulta F3        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ExistBlock("MGFGCT14")
	aRet := U_MGFGCT14()
EndIf

Return aRet