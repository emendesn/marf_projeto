/*
===========================================================================================
Programa.:              MA415LEG 
Autor....:              Marcelo Carneiro
Data.....:              Jun/2018
Descricao / Objetivo:   P.E. em Orcamento para alteracao das legendas Pre Pedido
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MA415LEG ()
Local aRet := PARAMIXB

If FindFunction("U_MGFFAT87")
	aRet := U_MGFFAT87(2,aRet)
Endif	

Return aRet