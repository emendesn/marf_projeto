#ifdef SPANISH
	#define STR0001 "Salir"
	#define STR0002 "Generar informe"
	#define STR0003 "Buscar"
	#define STR0004 "Relacion de la izquierda"
	#define STR0005 "Principal"
	#define STR0006 "Relacion de la derecha"
	#define STR0007 "Buscar"
	#define STR0008 "&Buscar"
	#define STR0009 "&Visualizar"
	#define STR0010 "Tabla"
	#define STR0011 "No hay tablas configuradas para el WalkThru."
#else
	#ifdef ENGLISH
		#define STR0001 "Exit"
		#define STR0002 "Generate report"
		#define STR0003 "Search"
		#define STR0004 "Left relationship"
		#define STR0005 "Main"
		#define STR0006 "Right relationship"
		#define STR0007 "Search"
		#define STR0008 "Search"
		#define STR0009 "&View"
		#define STR0010 "Table"
		#define STR0011 "There are no tables configurated for WalkThru."
	#else
		#define STR0001  "Sair"
		Static STR0002 := "Gerar Relatório"
		Static STR0003 := "Buscar"
		Static STR0004 := "Relacionamento da Esquerda"
		#define STR0005  "Principal"
		Static STR0006 := "Relacionamento da Direita"
		Static STR0007 := "Buscar"
		Static STR0008 := "&Pesquisar"
		Static STR0009 := "&Visualizar"
		#define STR0010  "Tabela"
		#define STR0011  "Não existem tabelas configuradas para o WalkThru."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Criar relatório"
			STR0003 := "Procurar"
			STR0004 := "Relacionamento Da Esquerda"
			STR0006 := "Relacionamento Da Direita"
			STR0007 := "Procurar"
			STR0008 := "&pesquisar"
			STR0009 := "&visualizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
