#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM75
Autor...............: Totvs
Data................: Fev/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT094LEG
=====================================================================================
*/
User Function MT110LEG() 

 Local aLeg := PARAMIXB[1] 

 aAdd(aLeg,{"BR_CANCEL","Cancelado por usuario"}) 

 Return (aLeg) 
