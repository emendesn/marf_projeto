#ifdef SPANISH
	#define STR0001 "MODIFICAR"
	#define STR0002 "VISUALIZAR"
	#define STR0003 "�Rotaci�n no configurada!"
	#define STR0004 "INCLUIR"
	#define STR0005 "�Operaci�n invalida!"
	#define STR0006 "Archivo de rotaci�n"
	#define STR0007 "Colas"
	#define STR0008 "Cola vs Miembro"
	#define STR0009 "Log vs Miembro"
	#define STR0010 "Cola"
	#define STR0011 "Miembro"
	#define STR0012 "Historial del miembro"
	#define STR0013 "LISTA EST�NDAR"
	#define STR0014 "LISTA EST�NDAR"
	#define STR0015 "Alternancia"
	#define STR0016 "Colas de alternancia"
	#define STR0017 "Miembros de la cola"
	#define STR0018 "Historial del procesamiento"
	#define STR0019 "No existe historial de procesamiento para este miembro."
	#define STR0020 "No fue posible crear la alternancia est�ndar."
#else
	#ifdef ENGLISH
		#define STR0001 "EDIT"
		#define STR0002 "VIEW"
		#define STR0003 "Restriction not configured!"
		#define STR0004 "ADD"
		#define STR0005 "Invalid operation !"
		#define STR0006 "Restriction Register"
		#define STR0007 "Queues"
		#define STR0008 "Queue x Member"
		#define STR0009 "Log x Member"
		#define STR0010 "Queue"
		#define STR0011 "Limb"
		#define STR0012 "Member History"
		#define STR0013 "STANDARD QUEUE"
		#define STR0014 "STANDARD QUEUE"
		#define STR0015 "Rotation"
		#define STR0016 "Restriction Queues"
		#define STR0017 "Queue Members"
		#define STR0018 "Processing History"
		#define STR0019 "There is no processing history for this member!"
		#define STR0020 "Unable to create the default restriction!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "ALTERAR" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "VISUALIZAR" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Rodizio n�o configurado !" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "INCLUIR" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Opera��o inv�lida !" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Rod�zio" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Filas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Fila x Membro" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Log x Membro" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Fila" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Membro" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Hist�rico do Membro" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "LISTA PADR�O" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "LISTA PADR�O" )
		#define STR0015 "Rod�zio"
		#define STR0016 "Filas do Rod�zio"
		#define STR0017 "Membros da Fila"
		#define STR0018 "Hist�rico do Processamento"
		#define STR0019 "N�o existe hist�rico de processamento para este membro!"
		#define STR0020 "N�o foi poss�vel criar o rod�zio padr�o!"
	#endif
#endif
