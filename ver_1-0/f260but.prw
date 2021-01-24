#include "protheus.ch"

/*
=====================================================================================
Programa.:              F260BUT
Autor....:              Totvs
Data.....:              Setembro/2018
Descricao / Objetivo:   PE para botões na tela do FINA260 tratando Conciliação DDA 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Considerações da regra conforme a MIT44-Tela Marcação
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