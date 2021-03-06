#ifdef SPANISH
	#define STR0001 "No es posible borrar la configuracion [TOTVSDBAcess], pues existen "
	#define STR0002 "entornos en este servidor que utilizan TOTVSDBAcess."
	#define STR0003 "�Confirma el borrado de la Configuracion ["
	#define STR0004 "] del Archivo de Configuraciones? "
	#define STR0005 "La seccion ["
	#define STR0006 "] se borro con exito."
	#define STR0007 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reinicializar el Servidor Protheus."
	#define STR0008 "Configuraciones de la Seccion"
	#define STR0009 "Asistente de Configuracion de TOTVSDBAcess"
	#define STR0010 "Nombre o IP de TOTVSDBAcess"
	#define STR0011 "Puerto del Listener"
	#define STR0012 "DataBase"
	#define STR0013 "Alias"
	#define STR0014 "Utiliza MAPPER"
	#define STR0015 "�Confirma la grabacion de las configuraciones de TOTVSDBAcess? "
	#define STR0016 "Configuraciones de TOTVSDBAcess actualizadas con exito."
	#define STR0017 "Debe informarse el nombre o IP de TOTVSDBAcess."
	#define STR0018 "El puerto no puede ser negativo."
	#define STR0019 "Si se especificara un puerto no-default para TOTVSDBAcess, "
	#define STR0020 "la configuracion del puerto de TOTVSDBAcess Server debe estar "
	#define STR0021 "apuntando a la puerta especificada."
	#define STR0022 "�Confirma el valor informado? "
#else
	#ifdef ENGLISH
		#define STR0001 "Unable to delete [TOTVSDBAcess] configuration because there are "
		#define STR0002 "environments in this server that use TOTVSDBAcess."
		#define STR0003 "Confirm deletion of the Configurations ["
		#define STR0004 "] File Configuration ?          "
		#define STR0005 "Section ["
		#define STR0006 "] was deleted successfully."
		#define STR0007 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0008 "Section Configuration "
		#define STR0009 "TOTVSDBAcess configuration assistant"
		#define STR0010 "TOTVSDBACESS name or IP"
		#define STR0011 "Listner Drawer   "
		#define STR0012 "DataBase"
		#define STR0013 "Alias"
		#define STR0014 "Use MAPPER"
		#define STR0015 "Confirm saving TOTVSDBAcess configuration?"
		#define STR0016 "TOTVSDBAcess configuration updated successfully."
		#define STR0017 "TOTVSDBACESS name or IP must be entered."
		#define STR0018 "The drawer cannot be negative."
		#define STR0019 "If a non-default port is specified for TOTVSDBAcess, "
		#define STR0020 "configuration of TOTVSDBAcess Server port must be"
		#define STR0021 "indicate it to the specified drawer."
		#define STR0022 "Confirm the informed value ? "
	#else
		Static STR0001 := "N�o � poss�vel deletar a configura��o [TOTVSDBAcess], pois existem "
		Static STR0002 := "ambientes neste servidor que utilizam o TOTVSDBAcess."
		Static STR0003 := "Confirma a dele��o da Configura��o ["
		Static STR0004 := "] do Arquivo de Configura��es ? "
		Static STR0005 := "A Se��o ["
		Static STR0006 := "] foi deletada com sucesso."
		Static STR0007 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0008 := "Configura��es da Se��o"
		Static STR0009 := "Assistente de Configura��o do TOTVSDBAcess"
		Static STR0010 := "Nome ou IP do TOTVSDBAcess"
		Static STR0011 := "Porta do Listener"
		Static STR0012 := "DataBase"
		Static STR0013 := "Alias"
		Static STR0014 := "Utiliza MAPPER"
		Static STR0015 := "Confirma a grava��o das Configura��es do TOTVSDBAcess ? "
		Static STR0016 := "Configura��es do TOTVSDBAcess atualizadas com sucesso."
		Static STR0017 := "O Nome ou IP do TOTVSDBAcess deve ser informado."
		#define STR0018  "A porta n�o pode ser negativa."
		Static STR0019 := "Caso especificada uma porta n�o-default para o TOTVSDBAcess, "
		Static STR0020 := "a configura��o da Porta do TOTVSDBAcess Server deve estar "
		Static STR0021 := "apontando para a porta especificada."
		Static STR0022 := "Confirma o valor informado ? "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "N�o � poss�vel apagar a configura��o [totvsdbacess], pois existem "
			STR0002 := "ambientes neste servidor que utilizam o TOTVSDBACESS."
			STR0003 := "Confirma a elimina��o da configura��o ["
			STR0004 := "] do ficheiro de configura��es ? "
			STR0005 := "A sec��o ["
			STR0006 := "] foi eliminada com sucesso."
			STR0007 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0008 := "Configura��es Da Sec��o"
			STR0009 := "Assistente de Configura��o do TOTVSDBACESS"
			STR0010 := "Nome Ou IP do TOTVSDBACESS"
			STR0011 := "Porta Do Receptor"
			STR0012 := "Base de dados"
			STR0013 := "Ali�s"
			STR0014 := "Utilizar Mapeador"
			STR0015 := "Confirma a grava��o das configura��es do totvsdbacess ? "
			STR0016 := "Configura��es do totvsdbacess actualizadas com sucesso."
			STR0017 := "O nome ou ip do totvsdbacess deve ser introduzido."
			STR0019 := "Caso seja especificada uma porta n�o-por defeito para o TOTVSDBACESS, "
			STR0020 := "A configura��o da porta do TOTVSDBACESS Server deve estar "
			STR0021 := "A apontar para a porta especificada."
			STR0022 := "Confirma o valor introduzido ? "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
