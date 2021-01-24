/*
===========================================================================================
Programa.:              MT241LOK
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao de linha na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT241LOK() 

Local nLinha := ParamIxb[1]
Local lRet := .T.

If FindFunction("U_Est26LOk")
	lRet := U_Est26LOk(nLinha)
Endif	

Return(lRet)