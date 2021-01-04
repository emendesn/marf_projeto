#ifdef SPANISH
	#define STR0001 "Nombre Interno del Servicio (name)"
	#define STR0002 "Nombre en la Lista de Servicios del Windows (displayname)"
	#define STR0003 "No es posible borrar esta configuracion."
	#define STR0004 "El Servicio del Windows NT/2000 no esta configurado."
	#define STR0005 "Datos del Servicio no configurados."
	#define STR0006 "Editar Configuracion"
	#define STR0007 "Borrar Configuracion"
#else
	#ifdef ENGLISH
		#define STR0001 "Service Internal Name (name)  "
		#define STR0002 "Name on the Windows Services Liat   (displayname) "
		#define STR0003 "It is not possible to delete this configuration."
		#define STR0004 "Windows NT/2000 is not configured.                "
		#define STR0005 "Service Data not configured.      "
		#define STR0006 "Edit Configuration "
		#define STR0007 "Delete Configuration"
	#else
		Static STR0001 := "Nome Interno do Serviço (name)"
		Static STR0002 := "Nome na Lista de Serviços do Windows (displayname)"
		Static STR0003 := "Não é possível deletar esta configuração."
		Static STR0004 := "O Serviço do Windows NT/2000 não está configurado."
		Static STR0005 := "Dados do Serviço não configurados."
		#define STR0006  "Editar Configuração"
		Static STR0007 := "Deletar Configuração"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nome interno do serviço (name)"
			STR0002 := "Nome na lista de serviços do windows (displayname)"
			STR0003 := "Não é possível eliminar esta configuração."
			STR0004 := "O serviço do windows nt/2000 não está configurado."
			STR0005 := "Dados do serviço não configurados."
			STR0007 := "Eliminar Configuração"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
