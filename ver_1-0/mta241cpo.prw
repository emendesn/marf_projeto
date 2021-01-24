/*
===========================================================================================
Programa.:              MTA241CPO
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para manipulacao dos arrays aHeader e aCols na rotina MATA241. Inclusao de campos no array.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MTA241CPO()

Local nOpc := ParamIxb[1]

If FindFunction("U_Est26Cpo")
	U_Est26Cpo(nOpc)
Endif	

Return()


