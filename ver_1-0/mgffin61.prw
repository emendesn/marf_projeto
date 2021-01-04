#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN61
Autor...............: Mauricio Gresele
Data................: Setembro/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada FA60FIL
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/     
User Function MGFFIN61()

Local cRet := ""

//cRet := " Posicione('SA1',1,xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,'A1_TIPO') != 'X' "
cRet := " Posicione('SA1',1,xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,'A1_ZBOLETO') != 'N' .AND. Posicione('SA1',1,xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,'A1_TIPO') != 'X' "
	
Return(cRet)