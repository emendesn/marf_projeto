#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              M410PVNF
Autor....:              Marcelo Carneiro / Barbieri
Data.....:              09/11/2016 
Descricao / Objetivo:   Integracao TAURA - SAIDAS / FAT14
Doc. Origem:            TAURA / FAT14
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de Entrada para Nao Liberar PV do Taura / Bloqueados pelo FAT14
=============================================================================================
*/
User Function M410PVNF
Local bRet := .T. 

If Findfunction("U_MGFTAS05") //TAURA
	 bRet := U_MGFTAS05(1)                                                                  
Endif

If bRet
	If FindFunction("U_xBlqNFRga") //FAT14
		bRet := U_xBlqNFRga(SC5->C5_NUM)
	Endif
Endif	

If bRet
	If FindFunction("U_MGFFAT45")
		 bRet := U_MGFFAT45()
	Endif
Endif

Return bRet