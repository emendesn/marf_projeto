#ifdef SPANISH
	#define STR0001 "¿Confirma el borrado de la configuracion [GENERAL]? "
	#define STR0002 "La Seccion ["
	#define STR0003 "] se borro con exito."
	#define STR0004 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reiniciar el Servidor Protheus."
	#define STR0005 "Configuraciones de la Seccion"
	#define STR0006 "Asistente de Configuracion General"
	#define STR0007 "Modo de Operacion CTREE"
	#define STR0008 "Habilitar Consola del Server en modo ISAPI"
	#define STR0009 "Grabar LOG de Mensajes de Consola"
	#define STR0010 "Nombre del Archivo de LOG de la Consola"
	#define STR0011 "¿Confirma la grabacion de las Configuraciones Generais especificadas? "
	#define STR0012 "Configuraciones Generais actualizadas con exito."
	#define STR0013 "El Camino para el Archivo de LOG debe iniciarse con una unidad de disco."
	#define STR0014 "No se permiten los siguientes caracteres en esta configuracion: "
#else
	#ifdef ENGLISH
		#define STR0001 "Confirm configuration deletion [GENERAL] ? "
		#define STR0002 "Section ["
		#define STR0003 "] was deleted successfully."
		#define STR0004 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0005 "Section Configurations"
		#define STR0006 "General Configuration Assistant "
		#define STR0007 "CTREE Operation Mode  "
		#define STR0008 "Enable the Server Console in ISAPI mode  "
		#define STR0009 "Save the Condole Messages LOG      "
		#define STR0010 "Console LOG File Name            "
		#define STR0011 "Confirm the specified General Configurations saving?         "
		#define STR0012 "General Configurations updated successfully. "
		#define STR0013 "The Path to the LOG File should begin with a disk unit.                    "
		#define STR0014 "The characters below are not permitted in the configuration: "
	#else
		Static STR0001 := "Confirma a exclusão da configuração [GENERAL] ? "
		Static STR0002 := "A Seção ["
		Static STR0003 := "] foi deletada com sucesso."
		Static STR0004 := "ATENÇÃO : As configurações atualizadas somente serão válidas após a re-inicialização do Servidor Protheus."
		Static STR0005 := "Configurações da Seção"
		Static STR0006 := "Assistente de Configuração Geral"
		Static STR0007 := "Modo de Operação CTREE"
		Static STR0008 := "Habilitar Console do Server em modo ISAPI"
		Static STR0009 := "Gravar LOG das Mensagens do Console"
		Static STR0010 := "Nome do Arquivo de LOG do Console"
		Static STR0011 := "Confirma a gravação das Configurações Gerais especificadas ? "
		Static STR0012 := "Configurações Gerais atualizadas com sucesso."
		Static STR0013 := "O Caminho para o Arquivo de LOG deve ser iniciado com uma unidade de disco."
		#define STR0014  "Não são permitidos os caracteres abaixo nesta configuração : "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Confirma a eliminação da configuração [crial] ? "
			STR0002 := "A secção ["
			STR0003 := "] foi eliminada com sucesso."
			STR0004 := "Atenção : As Configurações Actualizadas Serão Válidas Somente Após A Re-inicialização Do Servidor Protheus."
			STR0005 := "Configurações Da Secção"
			STR0006 := "Assistente De Configuração Geral"
			STR0007 := "Modo De Operação Ctree"
			STR0008 := "Instalar Console do Server em modo Isapi"
			STR0009 := "Gravar Diário Das Mensagens Da Consola"
			STR0010 := "Nome Do Ficheiro De Diário Da Consola"
			STR0011 := "Confirma a gravação das configurações gerais especificadas ? "
			STR0012 := "Configurações gerais actualizadas com sucesso."
			STR0013 := "O caminho para o ficheiro de diário deve ser iniciado com uma unidade de disco."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
