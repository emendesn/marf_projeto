#ifdef SPANISH
	#define STR0001 "�Problemas en la configuracion de la frecuencia! Se debe senalar uno de los dias."
	#define STR0002 "Atencion"
	#define STR0003 "Es necesario informar el usuario o grupo de usuarios que tendran acceso al informe."
	#define STR0004 "�No se informo el nombre del archivo!"
	#define STR0005 "�No se informo el e-mail!"
	#define STR0006 "�Confirma grabacion de los datos?"
	#define STR0007 "�No fue posible programar en agenda, ya existe una tarea con esta frecuencia!"
	#define STR0008 "Aviso"
	#define STR0009 "�Confirma borrado del acontecimiento?"
	#define STR0010 "De"
	#define STR0011 "A"
	#define STR0012 "Informes"
	#define STR0013 "Procesos Batch"
#else
	#ifdef ENGLISH
		#define STR0001 "Problems in frequency configuration! One date must be selected."
		#define STR0002 "Warning"
		#define STR0003 "It is necessary to enter the user or group of users who can access the report!"
		#define STR0004 "The file name has been not entered!"
		#define STR0005 "The e-mail address has been not entered!"
		#define STR0006 "OK to save all data?"
		#define STR0007 "Unable to schedule it. There is an existing task with the same frequency!"
		#define STR0008 "Warning"
		#define STR0009 "OK to delete the event?"
		#define STR0010 "From"
		#define STR0011 "To"
		#define STR0012 "Reports"
		#define STR0013 "Batch Processes"
	#else
		Static STR0001 := "Problemas na configura��o da frequ�ncia! Um dos dias dever� ser marcado."
		#define STR0002  "Aten��o"
		Static STR0003 := "� necess�rio informar o usu�rio ou grupo de usu�rios que ter�o acesso ao relat�rio!"
		Static STR0004 := "O nome do arquivo n�o foi informado!"
		Static STR0005 := "O e-mail n�o foi informado!"
		#define STR0006  "Confirma grava��o dos dados?"
		Static STR0007 := "N�o foi poss�vel agendar, j� existe uma tarefa com essa frequ�ncia!"
		#define STR0008  "Aviso"
		#define STR0009  "Confirma exclus�o do evento?"
		#define STR0010  "De"
		Static STR0011 := "Ate"
		#define STR0012  "Relat�rios"
		Static STR0013 := "Processos Batch"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Problemas na configura��o da frequ�ncia! um dos dias dever� ser marcado."
			STR0003 := "� necess�rio introduzir o utilizador ou grupo de utilizadores que ter�o acesso ao relat�rio!"
			STR0004 := "O nome do ficheiro n�o foi introduzido!"
			STR0005 := "O e-mail n�o foi introduzido!"
			STR0007 := "N�o  foi poss�vel agendar, j� existe uma tarefa com essa frequ�ncia!"
			STR0011 := "At�"
			STR0013 := "Processos Em S�rie"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
