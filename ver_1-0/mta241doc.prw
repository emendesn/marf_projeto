/*
===========================================================================================
Programa.:              MTA241DOC
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para manipulacao do numero do documento na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MTA241DOC()

If FindFunction("U_Est26Header")
	U_Est26Header(.F.)
Endif	

Return(Nil) // força retorno Nil, para padrao seguir sem a interferencia deste ponto de entrada	