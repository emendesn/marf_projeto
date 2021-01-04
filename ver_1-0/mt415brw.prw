/*
===========================================================================================
Programa.:              MT415BRW 
Autor....:              Marcelo Carneiro
Data.....:              Jun/2018
Descricao / Objetivo:   P.E. em Orçamento para alteração do Filtro do Pré Pedido
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT415BRW ()
Local cRet := ''
      
If FindFunction("U_MGFFAT87")
	cRet := U_MGFFAT87(4)
Endif	

Return cRet