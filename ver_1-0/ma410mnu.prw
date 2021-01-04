#include 'protheus.ch'
#include 'parmtype.ch'

user function MA410MNU()

	Local lMGFFIS34 := SuperGetMV('MGF_FIS34L',.T.,.F.)	//Habilita a rotina de valor do frete no pedido ou carga

	If FindFunction("u_MGFFAT38")
		aadd(aRotina,{'Alt. Inf. Nota','u_MGFFAT38', 0, 2, 0, NIL})
	Endif

	If FindFunction("U_MGFFAT12")
		AADD(aRotina,{OemToAnsi("Consultar Bloqueio"),"U_MGFFAT12()", 0, 8, 0, Nil})
	EndIf

	If FindFunction("U_FRETEPED") .AND. lMGFFIS34
		AADD(aRotina,{OemToAnsi("Informar Valor de Frete"),"U_FRETEPED()", 0, 8, 0, Nil})
	EndIf

	If FindFunction("U_MGFFAT66")
		AADD(aRotina,{OemToAnsi("Informar Data de Reembarque"),"U_MGFFAT66()", 0, 8, 0, Nil})
	EndIf

	// Historico do Pedido
	If FindFunction("U_FAT0363")
		aadd(aRotina,{'Hist�rico Pedido', 'U_FAT0363(SC5->C5_NUM)', 0, 2, 0, NIL})
	EndIf

	If FindFunction("U_MGFFAT85")
		AADD(aRotina,{OemToAnsi("Alterar Cliente de Entrega"),"U_MGFFAT85()", 0, 8, 0, Nil})
	EndIf

	If __cUserID $ GetMv("MGF_FAT70A",,"000000/000026/000023/") // Usu�rios com permiss�o para uso da rotina - Admin / Atilio / Marcia
		If FindFunction("U_MGFFAT70")
			AADD(aRotina,{OemToAnsi("Altera��o PV FISCAL"),"U_MGFFAT70()", 0, 8, 0, Nil})
		EndIf
	EndIf

	If __cUserID $ GetNewPar("MGF_FBW01","000000/004663/002836") .and. GetNewPar('MGF_FBW02' , .T.)
		If FindFunction("U_MGFFATBW")
			AADD(aRotina,{OemToAnsi("Altera dados especiais PV"),"U_MGFFATBW()", 0, 8, 0, Nil})
		EndIf
	EndIf 

	If FindFunction("U_MGFFAT93")
		AADD(aRotina,{OemToAnsi("For�a reenvio Nota Sa�da ao Taura"),"U_MGFFAT93()", 0, 8, 0, Nil})
	EndIf
	
	// Reenvio do Pedido ao TMS Transwide
	If FindFunction("U_TMSENVPV")
		AADD(aRotina,{OemToAnsi("Envio do Pedido ao TMS"),"U_TMSENVPV()", 0, 8, 0, Nil})
	EndIf

	// Reenvio do Pedido ao TMS em Massa
	If FindFunction("U_TMSENVP2")
		AADD(aRotina,{OemToAnsi("Envio PV em Massa ao TMS"),"U_TMSENVP2()", 0, 8, 0, Nil})
	EndIf

	//Exclus�o de roteiriza��o simples e em Massa
	If FindFunction("u_MGFFATBC")
		aadd(aRotina,{'Estorna Roteiriza��o','u_MGFFATBC', 0, 2, 0, NIL})
	Endif

	//RTASK0010973 - Inclus�o de filtro no Pedido de Venda por Nota Fiscal e impress�o de DANFE
	If FindFunction("U_MGFFATBZ")
		aadd(aRotina,{'Imprime Danfe','U_MGFFATBZ', 0, 2, 0, NIL}) // SPEDNFE
	Endif

return
