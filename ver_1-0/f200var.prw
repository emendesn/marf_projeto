/*
=====================================================================================
Programa.:              F200VAR
Autor....:              Atilio Amarilla
Data.....:              22/05/2017
Descricao / Objetivo:   PE acionado no processamento de arquivo CNAB. Busca ID CNAB 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA200
=====================================================================================
*/
User Function F200VAR()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?AP CNAB - Se existe ID CNAB importado (E1_ZIDCNAB), busca E1_IDCNAB    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//If ExistBlock("MGFFIN49")
//	U_MGFFIN49()
//EndIf

If ExistBlock("FIN89200Var")
	U_FIN89200Var()
Endif	

Return