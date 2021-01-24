#ifdef SPANISH
	#define STR0001 "Codigo Empresa"
	#define STR0002 "Nombre Empresa"
	#define STR0003 "Empresa"
	#define STR0004 "Buscar"
	#define STR0005 "Anular - <Ctrl-X>"
	#define STR0006 "Codigo Modulo"
	#define STR0007 "Nombre Modulo"
	#define STR0008 "Modulos"
	#define STR0009 "Registro de Agendamiento"
	#define STR0010 "Código Filial"
	#define STR0011 "Nome Filial"
	#define STR0012 "Empresa/Filial"
	#define STR0013 "Filial"
#else
	#ifdef ENGLISH
		#define STR0001 "Company Code"
		#define STR0002 "Company Name"
		#define STR0003 "Company"
		#define STR0004 "Search"
		#define STR0005 "Cancel - <Ctrl-X>"
		#define STR0006 "Module Code"
		#define STR0007 "Module Name"
		#define STR0008 "Modules"
		#define STR0009 "Scheduling Registration"
		#define STR0010 "Código Filial"
		#define STR0011 "Nome Filial"
		#define STR0012 "Empresa/Filial"
		#define STR0013 "Filial"
	#else
		Static STR0001 := "Codigo Empresa"
		Static STR0002 := "Nome Empresa"
		Static STR0003 := "Empresa"
		Static STR0004 := "Pesquisar"
		Static STR0005 := "Cancelar - <Ctrl-X>"
		Static STR0006 := "Codigo Módulo"
		Static STR0007 := "Nome Módulo"
		Static STR0008 := "Módulos"
		Static STR0009 := "Cadastro de Agendamento"
		Static STR0010 := "Código Filial"
		Static STR0011 := "Nome Filial"
		Static STR0012 := "Empresa/Filial"
		Static STR0013 := "Filial"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Codigo Empresa"
			STR0002 := "Nome Empresa"
			STR0003 := "Empresa"
			STR0004 := "Pesquisar"
			STR0005 := "Cancelar - <Ctrl-X>"
			STR0006 := "Codigo Módulo"
			STR0007 := "Nome Módulo"
			STR0008 := "Módulos"
			STR0009 := "Cadastro de Agendamento"
			STR0010 := "Código Filial"
			STR0011 := "Nome Filial"
			STR0012 := "Empresa/Filial"
			STR0013 := "Filial"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
