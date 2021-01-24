/*
=====================================================================================
Programa.:              FINA200
Autor....:              Atilio Amarilla
Data.....:              08/01/2017
Descricao / Objetivo:   PE acionado no processamento de arquivo CNAB
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA060
=====================================================================================
*/
User Function FINA200()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒AP 19_20_21 FIDC - Verifica豫o e acerto de valores de baixa            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ExistBlock("MGFFIN47")
	U_MGFFIN47()
EndIf

Return