#ifdef SPANISH
	#define STR0001 "Mantenimiento del Profile"
	#define STR0002 "Salir"
	#define STR0003 "Borrar"
	#define STR0004 "Usuario"
	#define STR0005 "Programa"
	#define STR0006 "Tarea"
	#define STR0007 "Tipo"
	#define STR0008 "¿Confirma el borrado?"
	#define STR0009 "¡Atencion!"
	#define STR0010 "Buscar   "
	#define STR0011 "Borrar profile"
	#define STR0012 "¿Borrar?"
	#define STR0013 "Registro corriente"
	#define STR0014 "Todos los registros del usuario"
	#define STR0015 "Buscar usuario"
#else
	#ifdef ENGLISH
		#define STR0001 "Profile Maintenance  "
		#define STR0002 "Exit"
		#define STR0003 "Delete"
		#define STR0004 "User"
		#define STR0005 "Program"
		#define STR0006 "Task"
		#define STR0007 "Type"
		#define STR0008 "Confirm record deletion"
		#define STR0009 "Warning!"
		#define STR0010 "Search   "
		#define STR0011 "Delete profile"
		#define STR0012 "Delete"
		#define STR0013 "Current record"
		#define STR0014 "All users records"
		#define STR0015 "Search user"
	#else
		Static STR0001 := "Manutenção do Profile"
		#define STR0002  "Sair"
		#define STR0003  "Excluir"
		Static STR0004 := "Usuário"
		#define STR0005  "Programa"
		#define STR0006  "Tarefa"
		#define STR0007  "Tipo"
		Static STR0008 := "Confirma a exclusäo?"
		#define STR0009  "Atenção!"
		#define STR0010  "Pesquisar"
		#define STR0011  "Excluir profile"
		#define STR0012  "Excluir?"
		Static STR0013 := "Registro corrente"
		Static STR0014 := "Todos registros do usuario"
		Static STR0015 := "Pesquisar usuario"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Manutenção Do Perfil"
			STR0004 := "Utilizador"
			STR0008 := "Confirmar a exclusão?"
			STR0013 := "Registo corrente"
			STR0014 := "Todos os registos do utilizador"
			STR0015 := "Pesquisar utilizador"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
