#ifdef SPANISH
	#define STR0001 "Archivo de Hoteles"
	#define STR0002 "Este Hotel no podra borrarse por estar relacionado la solicitudes de viaje."
#else
	#ifdef ENGLISH
		#define STR0001 "Hotels File"
		#define STR0002 "This Hotel can not be excluded as it is related to trip request."
	#else
		Static STR0001 := "Cadastro de Hoteis"
		Static STR0002 := "Este Hotel não poderá ser excluido por estar relacionado a solicitações de viagens."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Cadastro de Hotéis"
			STR0002 := "Este hotel não poderá ser excluído por estar relacionado a solicitações de viagens."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Cadastro de Hotéis"
			STR0002 := "Este hotel não poderá ser excluído por estar relacionado a solicitações de viagens."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
