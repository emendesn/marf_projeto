#include 'protheus.ch'
#include 'parmtype.ch'
/*
===========================================================================================
Programa.:              EECAE100
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Programa para chamada de pontos de de entrada padrão MVC rotina EECAE100
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
user function EECAE100()
	Local uRet := nil

	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

	If findfunction("u_MGFDT15")
		u_MGFDT15()
	EndIf

	If findfunction("u_fGrvCpos") .AND. !(IsInCallStack("U_MONINT72"))
		u_fGrvCpos()
	EndIf

	If FindFunction("u_EEC19A")
		uRet := u_EEC19A(cParam)
		If Valtype(uRet) == "L"
			lRetorno := uRet
		EndIf
	EndIf

	If FindFunction("U_xMGF39t")
		U_xMGF39t(cParam)
	EndIf
	If FindFunction("U_xMGF39v")
		U_xMGF39v(cParam)
	EndIf
	If FindFunction("u_xMGF39Men")
		u_xMGF39Men(cParam)
	EndIf
//	//Ponto de entrada para limpar o campo D2_PREEMB
//	If FindFunction("u_MGFEEC50")
//		u_MGFEEC50()
//	EndIf
//	
//	//Campos Editaveis no Embarque.
//	IF cParam == "ALTERA_FILTRO"
//		aAdd(aEECCamposEditaveis,"EEC_VMINGE") 
//	Endif    

	//valida cancelamento do embarque com campo EEC_DTEMBA
	If FindFunction("u_MGFEEC60")
		u_MGFEEC60()
	EndIf
	
	If FindFunction("u_MGFEEC62") //Rafael 27/11/2018
		if cParam=="PE_EXC" .and. uRet 
			uRet:= u_MGFEEC62(PARAMIXB)
		endif	
	EndIf

return uRet