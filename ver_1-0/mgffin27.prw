#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              MGFFIN27 - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Pedidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir campos Cliente e Nome no Browse de Pedidos
=====================================================================================
*/
User Function MGFFIN27() 
Local aArea    := GetArea()
Local aHeadAux := {}
Local aStruAux := {}

aAdd(aHeadAux,{"Codigo","A1_COD","@!",06,0,"","","C","","" } )
aAdd(aStruAux,{"A1_COD","C",06,0})

aAdd(aHeadAux,{"Loja","A1_LOJA","@!",02,0,"","","C","","" } )
aAdd(aStruAux,{"A1_LOJA","C",02,0})

aAdd(aHeadAux,{"Cliente","A1_NOME","@!",40,0,"","","C","","" } )
aAdd(aStruAux,{"A1_NOME","C",40,0})
 
Return {aClone(aHeadAux),aClone(aStruAux)}  