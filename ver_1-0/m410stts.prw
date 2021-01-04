#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: M410STTS
Autor...............: Joni Lima
Data................: 01/03/2017
Descricao / Objetivo: Ponto de Entrada para Copia de Pedido de Venda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ajusta Copia de Pedido de Venda
=====================================================================================
*/
User Function M410STTS()

	Local aArea		:= GetArea()
	Local nOpcTAS06	:= 0

	If IsInCallStack('A410COPIA')
		
		If FindFunction("U_MGFFAT06") .AND. !isInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5") .AND. !isInCallStack("AVMATA410")// FAT05 / U_MGFFAT53 Pedido do SFA / AVMATA410 - Pedido EXP
			u_MGFFAT06()
		Endif
		
		If FindFunction("u_MGFGCT09") // VEN02
			u_MGFGCT09(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_CONDPAG,.T.)
		Endif
		
		If FindFunction("U_MGFFAT17")
			cPedido := SC5->C5_NUM
			U_MGFFAT17(cPedido)
		Endif
		
//		If FindFunction("U_MGFTAS06")
//			U_MGFTAS06(3)
//		EndIF

	Endif

	// INICIO - Integracao com TAURA

	If 	   isInCallStack('A410INCLUI') .Or. isInCallStack('A410COPIA')
		   nOpcTAS06 := 3
	ElseIf isInCallStack('A410ALTERA')
		   nOpcTAS06 := 4
	ElseIf isInCallStack('A410DELETA')
		   nOpcTAS06 := 5
	EndIf
	
  	If nOpcTAS06 > 0
		if findFunction("U_MGFTAS06")
			U_MGFTAS06( nOpcTAS06 )
		endif
  	Endif
	  
	// FIM - Integracao com TAURA

	// Taura Saida
	If FindFunction("U_TAS01STTSM410")
		U_TAS01STTSM410()
	Endif

	// GAP FAT01
	If FindFunction("U_Fat03UsuAlt")
		U_Fat03UsuAlt()
	Endif

	If FindFunction("u_MGFEEC26")
		u_MGFEEC26()
	EndIf

	//Deleta registro no SZ5 na exclusao do pedido de venda (triangulacao faturamento)
	If FindFunction("u_MGFFAT75")
		u_MGFFAT75()
	EndIf

	If Findfunction("U_MGFFAT77")
		U_MGFFAT77()
	Endif

	// TMS Saida
	If FindFunction("U_TMSM410S")
		U_TMSM410STTS()
	Endif

	// exclusao de itens do pedido quando o cabecalho (sc5) nao for encontrado
	If Findfunction("U_MGFFATAD")
		U_MGFFATAD()
	Endif

	RestArea(aArea)

Return