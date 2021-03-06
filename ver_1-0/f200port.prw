/*
=====================================================================================
Programa.:              F200PORT
Autor....:              Atilio Amarilla
Data.....:              25/09/2017
Descricao / Objetivo:   PE acionado no processamento de arquivo CNAB
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA200. Permite bloquear (lRet := .F.)altera豫o de
Obs......:              banco da baixa pelo portador (E1_PORTADO+...)
=====================================================================================
*/
User Function F200PORT()

Local lRet := .T.
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒AP 19_20_21 FIDC - Bloqueio baixa pelo portador para t�tulo FIDC            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ExistBlock("MGFFIN59")
	lRet := U_MGFFIN59(lRet)
EndIf

Return lRet