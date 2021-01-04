#ifdef SPANISH
	#define STR0001 "Opcion disponible solamente para entorno TOPConnect."
	#define STR0002 "Atencion"
	#define STR0003 "Abrir..."
	#define STR0004 "Grabar..."
	#define STR0005 "Ejecutar..."
	#define STR0006 "Conectar como..."
	#define STR0007 "Desconectar..."
	#define STR0008 "Falla de conexion"
	#define STR0009 "Buffer de Lectura"
	#define STR0010 "Salir..."
	#define STR0011 "¡El Buffer especificado debe ser mayor o igual a 40!"
	#define STR0012 "Tiempo de ejecucion: "
	#define STR0013 "Abrir archivo"
	#define STR0014 "Falla de lectura del archivo "
	#define STR0015 "Grabar Archivo"
	#define STR0016 "¿Sobrescribir el archivo existente?"
	#define STR0017 "Falla de grabacion del archivo "
	#define STR0018 "¿Grabar script corriente?"
#else
	#ifdef ENGLISH
		#define STR0001 "Option available only for environment TOPConnect."
		#define STR0002 "Warning"
		#define STR0003 "Open..."
		#define STR0004 "Save..."
		#define STR0005 "Run..."
		#define STR0006 "Connect with...."
		#define STR0007 "Disconnect...."
		#define STR0008 "Error at connection"
		#define STR0009 "Reading Buffer"
		#define STR0010 "Exit..."
		#define STR0011 "The specified Buffer should be equal to or bigger than 40"
		#define STR0012 "Running time : "
		#define STR0013 "Open the file"
		#define STR0014 "Error while reading the file"
		#define STR0015 "Save the file"
		#define STR0016 "Overwrite the existing file"
		#define STR0017 "Error while saving the file "
		#define STR0018 "Save current script"
	#else
		Static STR0001 := "Opção disponível somente para ambiente TOPConnect."
		#define STR0002  "Atenção"
		#define STR0003  "Abrir..."
		#define STR0004  "Salvar..."
		#define STR0005  "Executar..."
		Static STR0006 := "Conectar como..."
		Static STR0007 := "Desconectar..."
		Static STR0008 := "Falha de conexão"
		Static STR0009 := "Buffer de Leitura"
		#define STR0010  "Sair..."
		Static STR0011 := "O Buffer especificado deve ser maior ou igual a 40!"
		#define STR0012  "Tempo de execução : "
		#define STR0013  "Abrir arquivo"
		Static STR0014 := "Falha na leitura do arquivo "
		Static STR0015 := "Salvar Arquivo"
		Static STR0016 := "Sobrescrever o arquivo existente?"
		Static STR0017 := "Falha na gravação do arquivo "
		#define STR0018  "Salvar script corrente?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Opção Disponível Somente Para Ambiente Topconnect."
			STR0006 := "Aceder como..."
			STR0007 := "Desaceder..."
			STR0008 := "Falha de ligação"
			STR0009 := "Buffer De Leitura"
			STR0011 := "O buffer especificado deve ser maior ou igual a 40!"
			STR0014 := "Falha na leitura do ficheiro "
			STR0015 := "Salvar Ficheiro"
			STR0016 := "Sobrepor o ficheiro existente?"
			STR0017 := "Falha na gravação do ficheiro "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
