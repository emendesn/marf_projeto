#include "protheus.ch"

/*
=====================================================================================
Programa.:              F260BUT
Autor....:              Totvs
Data.....:              Setembro/2018
Descricao / Objetivo:   PE para bot�es na tela do FINA260 tratando Concilia��o DDA 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Considera��es da regra conforme a MIT44-Tela Marca��o
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