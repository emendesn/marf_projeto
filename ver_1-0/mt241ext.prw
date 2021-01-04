/*
===========================================================================================
Programa.:              MT241EXT
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao do estorno na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT241EXT()

Local lRet := .T.

If FindFunction("U_Est26VEst")
	lRet := U_Est26VEst()
Endif	

Return(lRet)