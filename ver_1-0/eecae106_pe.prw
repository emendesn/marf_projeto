#include 'protheus.ch'
#include 'parmtype.ch'
/*
===========================================================================================
Programa.:              EECAE100
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Programa para chamada de pontos de de entrada padrao MVC rotina EECAE100
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
user function EECAE106()
	Local uRet := nil

	If findfunction("u_xMGFEEC27")
		uRet := u_xMGFEEC27()
	EndIf

	
return uRet