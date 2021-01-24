#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              MGFFINBC
Autor....:              Paulo Henrique - TOTVS
Data.....:              27/09/2019
Descricao / Objetivo:   Gera o nosso numero para titulos em cobranÃ§a simples
Doc. Origem:            RTASK0010081
Solicitante:            Contas a Receber
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFFINBC()

Local _cNossoNum := Space(11)
Local _cDvNosNum := Space(01)
Local _cNumBco   := Space(15)

// Converte o campo E1_NUMBCO sem o "-" (hífen)
_cNumBco := STRTRAN(SE1->E1_NUMBCO,"-","")

// 1a. Parte : Nosso Numero
_cNossoNum := STRZERO(VAL(SUBSTR(ALLTRIM(_cNumBco),1,9)),11)

// 2a. Parte := Digito do Nosso Numero
_cDvNosNum := SUBSTR(ALLTRIM(_cNumBco),10,1)

Return(_cNossoNum+_cDvNosNum)