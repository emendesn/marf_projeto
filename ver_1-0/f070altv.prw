/*
=====================================================================================
Programa.:              F070ALTV
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   PE acionado na busca de dados adicionais na baixa do CR.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA070.
=====================================================================================
*/
User Function F070ALTV()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒AP CRE041 - manter valor de desconto para t�tulo com baixa parcial     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ExistBlock("MGFFIN69")
	U_MGFFIN69()
EndIf

Return