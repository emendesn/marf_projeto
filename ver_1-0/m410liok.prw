#include "protheus.ch"

User Function M410LIOK()
	local lRet := .T.
	local varLocal  :=  ''

	//eliminar warning de variavel não declarada
	varLocal    :=  M->C5_TIPO


// inclusão de Carga Taura 
	If !(IsInCallStack("GravarCarga") .or. IsInCallStack("U_TAS02EECPA100") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("U_xGravarCarga") .or. IsInCallStack("U_xTAS02EECPA100") .or. IsInCallStack("U_MGFEST01"))
		// rotina de exclusao de nota de saida, desfaz fis45
		If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
			// pedido de venda devolucao
			If !M->C5_TIPO $ "D/B"
				// validacoes RAMI
				If FindFunction("U_MGFCRM46")
					lRet := U_MGFCRM46()
				Endif
			Endif
		Endif
	Endif

	If lRet
		If FindFunction("U_MGFFAT81")
			lRet := U_MGFFAT81()
		Endif
	Endif

	If lRet
		If FindFunction("U_MGFFAT84")
			lRet := U_MGFFAT84()
		Endif
	Endif

	If lRet
		If FindFunction("U_MGFFATBB")
			lRet := U_MGFFATBB(IsInCallStack("MATA410"))
		Endif
	Endif

// RTASK0010806 - Bloquear alteração do campo TES para alguns tipos de Pedido de Venda 
	If lRet
		If FunName() == "MATA410"
			If FindFunction("U_MGFFATBT")
				lRet := U_MGFFATBT()
			Endif
		Endif
	Endif

// RTASK0010975 - Incluir peso total no cabeçalho do pedido de venda
	If lRet
		If FunName() == "MATA410"
			If FindFunction("U_MGFFATBX")
				lRet := U_MGFFATBX()
			Endif
		Endif
	Endif

Return lRet