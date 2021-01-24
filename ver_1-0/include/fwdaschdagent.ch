#ifdef SPANISH
	#define STR0001 "Otro agente ya esta utilizando el codigo informado"
	#define STR0002 "La configuracion informada para este Agente ya esta siendo utilizada"
	#define STR0003 "Codigo"
	#define STR0004 "Nombre"
	#define STR0005 "Puerto"
	#define STR0006 "Entorno"
	#define STR0007 "Empresa"
	#define STR0008 "Sucursal"
	#define STR0009 "Nº de threads"
	#define STR0010 "Habilitado"
	#define STR0011 "Nombre de la empresa"
	#define STR0012 "Ultimo dia"
	#define STR0013 "Ultima hora"
	#define STR0014 "Agentes de schedule"
#else
	#ifdef ENGLISH
		#define STR0001 "Code informed is already being used by another Agent."
		#define STR0002 "Configuration indicated for this Agent is already been used"
		#define STR0003 "Code"
		#define STR0004 "Name"
		#define STR0005 "Portal"
		#define STR0006 "Environment"
		#define STR0007 "Company"
		#define STR0008 "Branch"
		#define STR0009 "Nr. of Threads"
		#define STR0010 "Enabled"
		#define STR0011 "Company Name"
		#define STR0012 "Last day"
		#define STR0013 "Last time"
		#define STR0014 "Schedule Agents"
	#else
		Static STR0001 := "O código informado já está sendo usado por outro Agent"
		Static STR0002 := "A configuração informada para este Agent já esta sendo usada"
		Static STR0003 := "Código"
		Static STR0004 := "Nome"
		Static STR0005 := "Porta"
		Static STR0006 := "Ambiente"
		Static STR0007 := "Empresa"
		Static STR0008 := "Filial"
		Static STR0009 := "Nº de Threads"
		Static STR0010 := "Habilitado"
		Static STR0011 := "Nome da Empresa"
		Static STR0012 := "Ultimo dia"
		Static STR0013 := "Ultima hora"
		Static STR0014 := "Agents de Schedule"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "O código informado já está sendo usado por outro Agent"
			STR0002 := "A configuração informada para este Agent já esta sendo usada"
			STR0003 := "Código"
			STR0004 := "Nome"
			STR0005 := "Porta"
			STR0006 := "Ambiente"
			STR0007 := "Empresa"
			STR0008 := "Filial"
			STR0009 := "Nº de Threads"
			STR0010 := "Habilitado"
			STR0011 := "Nome da Empresa"
			STR0012 := "Ultimo dia"
			STR0013 := "Ultima hora"
			STR0014 := "Agents de Schedule"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
