#include 'protheus.ch'
#include 'parmtype.ch'
/*
===========================================================================================
Programa.:              EECAP105
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Programa para chamada de pontos de de entrada padrao MVC rotina EECAE100
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
user function EECAP105()
	Local uRet := nil

	If findfunction("u_MGFEEC30")
		uRet := u_MGFEEC30()
	EndIf
	
	
return uRet