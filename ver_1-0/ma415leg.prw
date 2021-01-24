/*
===========================================================================================
Programa.:              MA415LEG 
Autor....:              Marcelo Carneiro
Data.....:              Jun/2018
Descricao / Objetivo:   P.E. em Orçamento para alteração das legendas Pré Pedido
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MA415LEG ()
Local aRet := PARAMIXB

If FindFunction("U_MGFFAT87")
	aRet := U_MGFFAT87(2,aRet)
Endif	

Return aRet