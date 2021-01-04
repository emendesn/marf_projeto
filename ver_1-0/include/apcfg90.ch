#ifdef SPANISH
	#define STR0001 "Rehace indices de las tablas"
	#define STR0002 "¿Rehacer ahora?"
	#define STR0003 "¡Opcion no disponible para entorno TOP!"
	#define STR0004 "Atencion"
	#define STR0005 "Espere, recreando indices..."
	#define STR0006 "Procesando"
	#define STR0007 "¿Anular?"
	#define STR0008 "Esta opcion rehace los indices de las tablas contenidas en el Dicionario de Tablas"
	#define STR0009 "No se ejecuta en Entorno Top"
	#define STR0010 "Error al abrir SX2 exclusivo"
	#define STR0011 "Iniciacion de las tablas"
	#define STR0012 "Esta rutina ejecuta el script de creacion de tablas del sistema, imprescindible para el entorno AS/400."
	#define STR0013 "¡Opcion disponible para entorno TOP!"
	#define STR0014 "Esta opcion puede ejecutarse a cualquier momento. Observacion: "
	#define STR0015 "1-La rutina debe ejecutarse en modo exclusivo;"
	#define STR0016 "2-Solo se crean los componentes inexistentes"
#else
	#ifdef ENGLISH
		#define STR0001 "Redo table indexes       "
		#define STR0002 "Redo now ?    "
		#define STR0003 "Option not available in the TOP environment"
		#define STR0004 "Warning"
		#define STR0005 "Please, wait...Recreating indexes"
		#define STR0006 "Processing"
		#define STR0007 "Cancel?"
		#define STR0008 "This option redoes the tables indexes enclosed in the Tables Dictionary  "
		#define STR0009 "Not performed in Top Environment"
		#define STR0010 "Error while opening the exclusive SX2"
		#define STR0011 "Table Startup"
		#define STR0012 "This routine runs script of table creation in the system, which is essential to environment AS/400."
		#define STR0013 "Option available to environment TOP!"
		#define STR0014 "This option can be executed at any time. Note: "
		#define STR0015 "1-The routine must be executed exclusively;"
		#define STR0016 "2-Only non-existent components are created."
	#else
		Static STR0001 := "Refaz índices das tabelas"
		#define STR0002  "Refazer agora?"
		Static STR0003 := "Opção não disponivel para ambiente TOP!"
		#define STR0004  "Atenção"
		Static STR0005 := "Aguarde, recriando índices..."
		Static STR0006 := "Processando"
		#define STR0007  "Cancelar?"
		Static STR0008 := "Esta opção refaz os índices das tabelas contidas no Dicionário de Tabelas"
		Static STR0009 := "Não é executada em Ambiente Top"
		Static STR0010 := "Erro abrindo SX2 exclusivo"
		#define STR0011  "Inicializaçao das tabelas"
		#define STR0012  "Esta rotina executa o script de criação de tabelas do sistema, imprescindível para o ambiente AS/400."
		Static STR0013 := "Opção disponivel para ambiente TOP!"
		#define STR0014  "Esta opção pode ser executada a qualquer momento. Observação: "
		Static STR0015 := "1-A rotina deve ser executada em modo exclusivo;"
		Static STR0016 := "2-Somente sao criadas os componentes inexistentes"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Refazer índices das tabelas"
			STR0003 := "Opção Não Disponível Para Ambiente Top!"
			STR0005 := "Aguarde, rea criar índices..."
			STR0006 := "A processar"
			STR0008 := "Esta Opção Refaz Os índices Das Tabelas Contidas No Dicionário De Tabelas"
			STR0009 := "Não é Executada Em Ambiente Top"
			STR0010 := "Erro a abrir sx2 exclusivo"
			STR0013 := "Opção disponível para ambiente TOP!"
			STR0015 := "1-A rotina deve ser executada em modo exclusivo."
			STR0016 := "2-Somente são criados os componentes inexistentes."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
