#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MT410ALT
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/display/public/PROT/MT410ALT
=====================================================================================
*/
user function MT410ALT()

	Local cPedido := SC5->C5_NUM

	If FindFunction("U_MGFFAT17") 
		If !IsInCallStack("U_MGFFATBW")
			U_MGFFAT17(cPedido)
		EndIf
	Endif

   	If findFunction("u_MGFFAT06") .AND. !isInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5") .AND. !isInCallStack("AVMATA410") // U_MGFFAT53 Pedido do SFA / AVMATA410 - Pedido EXP
		u_MGFFAT06()
 	Endif  	

	If FindFunction("U_MGFFAT73")
		U_MGFFAT73()
	Endif

return