#ifdef SPANISH
	#define STR0001 "Transacciones"
	#define STR0002 "Eventos de la tarea"
	#define STR0003 "Escriba lo que desea buscar."
	#define STR0004 "�No se encontro ningun resultado!"
	#define STR0005 "Leyenda"
	#define STR0006 "Filtro"
	#define STR0007 "Intentelo nuevamente"
	#define STR0008 "Actualizar"
	#define STR0009 "Buscar"
	#define STR0010 "Codigo"
	#define STR0011 "Aguardando ejecucion"
	#define STR0012 "Ejecutando"
	#define STR0013 "Finalizada"
	#define STR0014 "Hubo un error"
	#define STR0015 "No se encontro ningun registro para estas condiciones de filtro."
	#define STR0016 "Atencion"
	#define STR0017 "Bloquear transa��o"
	#define STR0018 "Filial"
	#define STR0019 "Dt Transa��o"
	#define STR0020 "Hr Transa��o"
	#define STR0021 "Dt Processa"
	#define STR0022 "Hr Processa"
	#define STR0023 "Bloqueado"
#else
	#ifdef ENGLISH
		#define STR0001 "Transactions"
		#define STR0002 "Task Events"
		#define STR0003 "Type what you want to search."
		#define STR0004 "No results found!"
		#define STR0005 "Caption"
		#define STR0006 "Filter"
		#define STR0007 "Try again"
		#define STR0008 "Update"
		#define STR0009 "Search"
		#define STR0010 "Code"
		#define STR0011 "Waiting for execution"
		#define STR0012 "Executing"
		#define STR0013 "Finished"
		#define STR0014 "Failed"
		#define STR0015 "No record was found for these filter conditions."
		#define STR0016 "Attention"
		#define STR0017 "Bloquear transa��o"
		#define STR0018 "Filial"
		#define STR0019 "Dt Transa��o"
		#define STR0020 "Hr Transa��o"
		#define STR0021 "Dt Processa"
		#define STR0022 "Hr Processa"
		#define STR0023 "Bloqueado"
	#else
		Static STR0001 := "Transa��es"
		Static STR0002 := "Eventos da Tarefa"
		Static STR0003 := "Digite o que deseja procurar."
		Static STR0004 := "Nenhum resultado encontrado!"
		Static STR0005 := "Legenda"
		Static STR0006 := "Filtro"
		Static STR0007 := "Tentar novamente"
		Static STR0008 := "Atualizar"
		Static STR0009 := "Buscar"
		Static STR0010 := "C�digo"
		Static STR0011 := "Aguardando execu��o"
		Static STR0012 := "Executando"
		Static STR0013 := "Finalizada"
		Static STR0014 := "Falhou"
		Static STR0015 := "N�o foi encontrado nenhum registro para essas condi��es de filtro."
		Static STR0016 := "Aten��o"
		Static STR0017 := "Bloquear transa��o"
		Static STR0018 := "Filial"
		Static STR0019 := "Dt Transa��o"
		Static STR0020 := "Hr Transa��o"
		Static STR0021 := "Dt Processa"
		Static STR0022 := "Hr Processa"
		Static STR0023 := "Bloqueado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Transa��es"
			STR0002 := "Eventos da Tarefa"
			STR0003 := "Digite o que deseja procurar."
			STR0004 := "Nenhum resultado encontrado!"
			STR0005 := "Legenda"
			STR0006 := "Filtro"
			STR0007 := "Tentar novamente"
			STR0008 := "Atualizar"
			STR0009 := "Buscar"
			STR0010 := "C�digo"
			STR0011 := "Aguardando execu��o"
			STR0012 := "Executando"
			STR0013 := "Finalizada"
			STR0014 := "Falhou"
			STR0015 := "N�o foi encontrado nenhum registro para essas condi��es de filtro."
			STR0016 := "Aten��o"
			STR0017 := "Bloquear transa��o"
			STR0018 := "Filial"
			STR0019 := "Dt Transa��o"
			STR0020 := "Hr Transa��o"
			STR0021 := "Dt Processa"
			STR0022 := "Hr Processa"
			STR0023 := "Bloqueado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF