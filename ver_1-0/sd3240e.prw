/*
===========================================================================================
Programa.:              SD3240E
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para complementar a gravacao do estorno na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function SD3240E()

If FindFunction("U_Est26GEst")
	U_Est26GEst("E")
Endif	

Return()