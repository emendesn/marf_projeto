/*
===========================================================================================
Programa.:              SD3240I
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para complementar a gravacao da inclusao na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function SD3240I()

Local nLinha := ParamIxb[1]

If FindFunction("U_Est26GEst")
	U_Est26GEst("I")
Endif	

Return()