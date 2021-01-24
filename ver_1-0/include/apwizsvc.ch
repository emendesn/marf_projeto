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
		Static STR0001 := "Nome Interno do Servi�o (name)"
		Static STR0002 := "Nome na Lista de Servi�os do Windows (displayname)"
		Static STR0003 := "N�o � poss�vel deletar esta configura��o."
		Static STR0004 := "O Servi�o do Windows NT/2000 n�o est� configurado."
		Static STR0005 := "Dados do Servi�o n�o configurados."
		#define STR0006  "Editar Configura��o"
		Static STR0007 := "Deletar Configura��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nome interno do servi�o (name)"
			STR0002 := "Nome na lista de servi�os do windows (displayname)"
			STR0003 := "N�o � poss�vel eliminar esta configura��o."
			STR0004 := "O servi�o do windows nt/2000 n�o est� configurado."
			STR0005 := "Dados do servi�o n�o configurados."
			STR0007 := "Eliminar Configura��o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
