#ifdef SPANISH
	#define STR0001 "Rutinas Perfil 360"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Rutinas del Perfil 360"
	#define STR0007 "Rutinas"
	#define STR0008 "Rutina y Alias ya registrada para este tipo de funci�n."
#else
	#ifdef ENGLISH
		#define STR0001 "360 Profile Routines"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "360 Profile Routines"
		#define STR0007 "Routines"
		#define STR0008 "Routine and Alias already registered for this type of role."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Rotinas Perfil 360" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Rotinas do Perfil 360" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Rotinas" )
		#define STR0008 "Rotina e Alias j� cadastrada para este tipo de fun��o."
	#endif
#endif
