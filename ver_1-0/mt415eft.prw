/*
===========================================================================================
Programa.:              MT415EFT 
Autor....:              Marcelo Carneiro
Data.....:              Jun/2018
Descricao / Objetivo:   P.E. em Or�amento para altera��o dados antes de Efetivar o pedido
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT415EFT

If FindFunction("U_MGFFAT87")
	cRet := U_MGFFAT87(6)
Endif	                                      

Return .T.