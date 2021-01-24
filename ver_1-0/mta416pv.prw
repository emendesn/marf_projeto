/*
===========================================================================================
Programa.:              MTA416PV 
Autor....:              Marcelo Carneiro
Data.....:              Jun/2018
Descricao / Objetivo:   P.E. em Orçamento para alteração dados antes de Efetivar o pedido
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MTA416PV
Local nAux := PARAMIXB
      
If FindFunction("U_MGFFAT87")
	cRet := U_MGFFAT87(5)
Endif	                                      

Return Nil