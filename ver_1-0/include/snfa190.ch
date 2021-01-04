#ifdef SPANISH
	#define STR0001 "Tabla de"
	#define STR0002 "Tabla a"
	#define STR0003 "Verificar claves de las tablas destino con claves"
	#define STR0004 "Seleccionando Registros..."
	#define STR0005 "del diccionario destino"
	#define STR0006 "Comparar llaves del diccionario destino con "
	#define STR0007 "claves del diccionario local (de esta maquina)"
	#define STR0008 "Verificar la existencia de los campos de SIX destino"
	#define STR0009 "con campos del SX3 destino"
	#define STR0010 "Al menos una verificacion se debe seleccionar!"
	#define STR0011 "El filtro de tablas se debe rellenar !"
	#define STR0012 "Problema na Chave Indice : "
#else
	#ifdef ENGLISH
		#define STR0001 "Tabela de"
		#define STR0002 "Tabela ate"
		#define STR0003 "Verificar chaves das tabelas destino com chaves"
		#define STR0004 "Selecionando Registros..."
		#define STR0005 "do dicionário destino"
		#define STR0006 "Comparar chaves do dicionário destino com "
		#define STR0007 "chaves do dicionário local (desta máquina)"
		#define STR0008 "Verificar existência dos campos do SIX destino"
		#define STR0009 "com campos do SX3 destino"
		#define STR0010 "Ao menos uma verificação deve ser selecionada !"
		#define STR0011 "O filtro de tabelas deve ser preenchido !"
		#define STR0012 "Problema na Chave Indice : "
	#else
		Static STR0001 := "Tabela de"
		Static STR0002 := "Tabela ate"
		Static STR0003 := "Verificar chaves das tabelas destino com chaves"
		Static STR0004 := "Selecionando Registros..."
		Static STR0005 := "do dicionário destino"
		Static STR0006 := "Comparar chaves do dicionário destino com "
		Static STR0007 := "chaves do dicionário local (desta máquina)"
		Static STR0008 := "Verificar existência dos campos do SIX destino"
		Static STR0009 := "com campos do SX3 destino"
		Static STR0010 := "Ao menos uma verificação deve ser selecionada !"
		Static STR0011 := "O filtro de tabelas deve ser preenchido !"
		Static STR0012 := "Problema na Chave Indice : "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Tabela de"
			STR0002 := "Tabela ate"
			STR0003 := "Verificar chaves das tabelas destino com chaves"
			STR0004 := "Selecionando Registros..."
			STR0005 := "do dicionário destino"
			STR0006 := "Comparar chaves do dicionário destino com "
			STR0007 := "chaves do dicionário local (desta máquina)"
			STR0008 := "Verificar existência dos campos do SIX destino"
			STR0009 := "com campos do SX3 destino"
			STR0010 := "Ao menos uma verificação deve ser selecionada !"
			STR0011 := "O filtro de tabelas deve ser preenchido !"
			STR0012 := "Problema na Chave Indice : "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
