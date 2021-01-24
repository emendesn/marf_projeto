#ifdef SPANISH
	#define STR0001 "Parametros"
	#define STR0002 "Tablas Genericas"
	#define STR0003 "Preguntas"
	#define STR0004 "Log de Procesos"
	#define STR0005 "Opciones"
	#define STR0006 "Ejecucion"
	#define STR0007 "Iniciar Ejecucion"
	#define STR0008 "Anular"
	#define STR0009 "Descripcion"
	#define STR0010 "Estatus"
	#define STR0011 "Sucursal"
	#define STR0012 "Nombre"
	#define STR0013 "Contenido"
	#define STR0014 "Tabla"
	#define STR0015 "Clave"
	#define STR0016 "Programa"
	#define STR0017 "Usuario"
	#define STR0018 "Fecha"
	#define STR0019 "Hora"
	#define STR0020 "Log"
	#define STR0021 "Pregunta"
	#define STR0022 "Parametro"
#else
	#ifdef ENGLISH
		#define STR0001 "Parameters"
		#define STR0002 "Generic tables"
		#define STR0003 "Questions"
		#define STR0004 "Process log"
		#define STR0005 "Options"
		#define STR0006 "Execution"
		#define STR0007 "Run"
		#define STR0008 "Cancel"
		#define STR0009 "Description"
		#define STR0010 "Status"
		#define STR0011 "Branch"
		#define STR0012 "Name"
		#define STR0013 "Content"
		#define STR0014 "Table"
		#define STR0015 "Key"
		#define STR0016 "Program"
		#define STR0017 "User"
		#define STR0018 "Date"
		#define STR0019 "Time"
		#define STR0020 "Log"
		#define STR0021 "Question"
		#define STR0022 "Parameter"
	#else
		#define STR0001  "Parâmetros"
		Static STR0002 := "Tabelas Genéricas"
		#define STR0003  "Perguntas"
		Static STR0004 := "Log de Processos"
		#define STR0005  "Opções"
		#define STR0006  "Execução"
		Static STR0007 := "Iniciar Execução"
		#define STR0008  "Cancelar"
		#define STR0009  "Descrição"
		Static STR0010 := "Status"
		#define STR0011  "Filial"
		#define STR0012  "Nome"
		#define STR0013  "Conteúdo"
		#define STR0014  "Tabela"
		#define STR0015  "Chave"
		#define STR0016  "Programa"
		Static STR0017 := "Usuário"
		#define STR0018  "Data"
		#define STR0019  "Hora"
		Static STR0020 := "Log"
		#define STR0021  "Pergunta"
		#define STR0022  "Parâmetro"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Tabelas genéricas"
			STR0004 := "Diário De Processos"
			STR0007 := "Executar"
			STR0010 := "Estado"
			STR0017 := "Utilizador"
			STR0020 := "Diário"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
