#include "protheus.ch"

/*
=====================================================================================
Programa.:              F260BUT
Autor....:              Totvs
Data.....:              Setembro/2018
Descricao / Objetivo:   PE para botoes na tela do FINA260 tratando Conciliacao DDA 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Consideracoes da regra conforme a MIT44-Tela Marcacao
=====================================================================================
*/
User Function F260BUT(aRotina)

aRotina := {{ "Pesquisar"	,"AxPesqui"	, 0 , 1 , ,.F. }	,;			
			{ "Visualizar"	,"AxVisual"	, 0 , 2 }       	,;			
			{ "Conciliar"	,"U_MGF260Conc", 0 , 3 }		,;			
			{ "Alterar"		,"F260Alte"	, 0 , 4 }			,;			
			{ "Estornar"	,"F260Canc"	, 0 , 5 }			,;			
			{ "Legenda"		,"Fa260Leg"	, 0 , 6 , ,.F. } } 				
			
Return(aRotina)