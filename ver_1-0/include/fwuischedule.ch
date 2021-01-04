#ifdef SPANISH
	#define STR0001 "Programaciones"
	#define STR0002 "Codigo"
	#define STR0003 "Usuario"
	#define STR0004 "Nombre del usuario"
	#define STR0005 "Rutina"
	#define STR0006 "Leyenda"
	#define STR0007 "Filtro"
	#define STR0008 "Ejecutar ahora"
	#define STR0009 "Buscar"
	#define STR0010 "Escriba lo que desea buscar."
	#define STR0011 "¡No se encontro ningun resultado!"
	#define STR0012 "Habilitado"
	#define STR0013 "Deshabilitado"
	#define STR0014 "Finalizado"
	#define STR0015 "No se encontro ningun registro para estas condiciones de filtro."
	#define STR0016 "Atencion"
	#define STR0017 "Actualizar"
	#define STR0018 "Status"
#else
	#ifdef ENGLISH
		#define STR0001 "Scheduling"
		#define STR0002 "Code"
		#define STR0003 "User"
		#define STR0004 "User Name"
		#define STR0005 "Routine"
		#define STR0006 "Caption"
		#define STR0007 "Filter"
		#define STR0008 "Run now"
		#define STR0009 "Search"
		#define STR0010 "Type what you want to search."
		#define STR0011 "No results found!"
		#define STR0012 "Enabled"
		#define STR0013 "Disabled"
		#define STR0014 "Finished"
		#define STR0015 "No record was found for these filter conditions."
		#define STR0016 "Attention"
		#define STR0017 "Update"
		#define STR0018 "Status"
	#else
		Static STR0001 := "Agendamentos"
		Static STR0002 := "Código"
		Static STR0003 := "Usuário"
		Static STR0004 := "Nome do Usuário"
		Static STR0005 := "Rotina"
		Static STR0006 := "Legenda"
		Static STR0007 := "Filtro"
		Static STR0008 := "Executar agora"
		Static STR0009 := "Buscar"
		Static STR0010 := "Digite o que deseja procurar."
		Static STR0011 := "Nenhum resultado encontrado!"
		Static STR0012 := "Habilitado"
		Static STR0013 := "Desabilitado"
		Static STR0014 := "Finalizado"
		Static STR0015 := "Não foi encontrado nenhum registro para essas condições de filtro."
		Static STR0016 := "Atenção"
		Static STR0017 := "Atualizar"
		Static STR0018 := "Status"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Agendamentos"
			STR0002 := "Código"
			STR0003 := "Usuário"
			STR0004 := "Nome do Usuário"
			STR0005 := "Rotina"
			STR0006 := "Legenda"
			STR0007 := "Filtro"
			STR0008 := "Executar agora"
			STR0009 := "Buscar"
			STR0010 := "Digite o que deseja procurar."
			STR0011 := "Nenhum resultado encontrado!"
			STR0012 := "Habilitado"
			STR0013 := "Desabilitado"
			STR0014 := "Finalizado"
			STR0015 := "Não foi encontrado nenhum registro para essas condições de filtro."
			STR0016 := "Atenção"
			STR0017 := "Atualizar"
			STR0018 := "Status"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
