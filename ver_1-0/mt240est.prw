/*
===========================================================================================
Programa.:              MT240EST
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao do estorno na rotina MATA240.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT240EST()

Local lRet := .T.

If FindFunction("U_Est26VEst")
	lRet := U_Est26VEst()
Endif	

Return(lRet)