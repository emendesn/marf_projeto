#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA200REJ
Autor....:              Atilio Amarilla
Data.....:              08/01/2017
Descricao / Objetivo:   PE acionado no processamento de arquivo CNAB
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA060
=====================================================================================
*/
User Function FA200REJ()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿒AP 19_20_21 FIDC - Verifica豫o e acerto de valores de baixa �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If ExistBlock("MGFFIN48")
	U_MGFFIN48()
EndIf

Return