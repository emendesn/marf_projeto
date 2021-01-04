/*
===========================================================================================
Programa.:              MT241TOK
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao do OK na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT241TOK()

Local lRet := .T.

If FindFunction("U_Est26TOk")
	lRet := U_Est26TOk()
Endif	

Return(lRet)
