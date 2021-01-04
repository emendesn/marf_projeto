#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MT410INC
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/display/public/PROT/MT410INC
=====================================================================================
*/
user function MT410INC()

	Local aAreaSC5 := SC5->(GetArea())
	Local cPedido := SC5->C5_NUM

	If FindFunction("u_MGFGCT09") // VEN02
		u_MGFGCT09(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_CONDPAG,.T.)
	Endif
	If FindFunction("U_MGFFAT17")
		U_MGFFAT17(cPedido)
	Endif
	If findFunction("u_MGFFAT06") .AND. !isInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5") .AND. !isInCallStack("AVMATA410")// U_MGFFAT53 Pedido do SFA / AVMATA410 - PEDIDO EXP
		u_MGFFAT06()
	Endif

	/*
	DESABILITADO POR SOLICITACAO DE ALEXANDRE BEZERRA - GAP DE CONTRATO NAO VALIDADO POR ELE

	If findFunction("U_MGFFAT32")
		U_MGFFAT32()
	Endif
	*/

	RestArea(aAreaSC5)
return