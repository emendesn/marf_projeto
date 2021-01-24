#ifdef SPANISH
	#define STR0001 "Error al copiar archivo : "
	#define STR0002 "Error al actualizar archivo : "
	#define STR0003 "Error al cambia atributo a modo ejecutable : "
	#define STR0004 "Espere ..."
	#define STR0005 "Actualizando archivos del Protheus Remote ..."
	#define STR0006 "El Protheus Remote se actualizo con exito."
	#define STR0007 "Por favor, reinicie el Protheus Remote."
	#define STR0008 "Actualizacion de Archivos"
#else
	#ifdef ENGLISH
		#define STR0001 "Error while copying file : "
		#define STR0002 "Error while updating file : "
		#define STR0003 "Error while changing attribute to running mode : "
		#define STR0004 "Wait ..."
		#define STR0005 "Updating Remote Protheus files ..."
		#define STR0006 "Remote Protheus was updated successfully."
		#define STR0007 "Please, restart Remote Protheus."
		#define STR0008 "File Updating"
	#else
		Static STR0001 := "Falha ao copiar arquivo : "
		Static STR0002 := "Falha ao atualizar arquivo : "
		#define STR0003  "Falha ao mudar o atributo para modo executável : "
		#define STR0004  "Aguarde ..."
		Static STR0005 := "Atualizando arquivos do Protheus Remote ..."
		Static STR0006 := "O Protheus Remote foi atualizado com sucesso."
		#define STR0007  "Por favor, re-inicie o Protheus Remote."
		Static STR0008 := "Atualização de Arquivos"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Falha ao copiar ficheiro : "
			STR0002 := "Falha ao actualizar ficheiro : "
			STR0005 := "A actualizar ficheiros do Protheus Remote ..."
			STR0006 := "O Protheus Remoto foi actualizado com sucesso."
			STR0008 := "Actualização De Ficheiros"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
