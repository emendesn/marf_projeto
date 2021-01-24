#include 'RWMAKE.CH'
#include 'parmtype.ch'

/*
=====================================================================================
Programa.:              F430VAR
Autor....:              Natanael Filho
Data.....:              26/09/2017
Descricao / Objetivo:   O ponto de entrada F430VAR tem como finalidade tratar os dados para baixa CNAB.
						Antes de verificar a especie do titulo o array aValores permitira que qualquer
						excecao ou necessidade seja tratada no ponto de entrada em PARAMIXB.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
	http://tdn.totvs.com/display/public/mp/F430VAR+-+Baixa+de+CNAB+--+11797
	
	
=====================================================================================
*/


USER FUNCTION F430VAR()

	If ExistBlock("MGFFIN90")
		U_MGFFIN90()
	EndIf
	
	//Natanael Filho/Marcos Vieira - 15/07/2019: RITM0017555 - Modificação no CNPJ no retorno DDA.
	If ExistBlock("MGFFIN99")
		cCGC := U_MGFFIN99(cCGC)
	EndIf
	
Return