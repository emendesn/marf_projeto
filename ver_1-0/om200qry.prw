#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
       
/*/Ponto de entrada para antes de montar carga na OMSA200
@description
Criação de ponto de entrada para adicionar condição na querie anstes de carregas os PV na tela de carga.

@author Henrique Vidal Santos
@since 01/11/2019

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	SC5 - Pedido de vendas 
	SC9 - Liberação do pedido de venda 
	SC6 - Itens do pedido de venda 
	DAK - Cargas
@param
@return caracter - filtro a ser adicionado 

@menu
	SIGAOMS-> 'sem menu'. Rotina interna
@history
	Criação da rotina
	PRBXXXX	- Adicionar filtro no carregmento da carga 
					- Adicionar somente pedidos totalmete liberados
	
/*/
User Function OM200QRY()

Local _cQry     := PARAMIXB[1]

_cQry += " AND SC5.C5_ZBLQRGA <> 'B'  "

Return _cQry