#ifdef SPANISH
	#define STR0001 "Subcontactos"
	#define STR0002 "Visualizar"
	#define STR0003 "Modificar"
	#define STR0004 "Perfil del contacto"
	#define STR0005 "Leyenda"
	#define STR0006 "Codigo: "
	#define STR0007 "Nombre: "
	#define STR0008 "Estructura de Subcontactos"
	#define STR0009 "Codigo: "
	#define STR0010 "Nombre: "
	#define STR0011 "Contacto primario"
	#define STR0012 "Contacto secundario"
	#define STR0013 "Contacto secundario/primario"
#else
	#ifdef ENGLISH
		#define STR0001 "Sub-contacts"
		#define STR0002 "View"
		#define STR0003 "Change"
		#define STR0004 "Contact profile"
		#define STR0005 "Caption"
		#define STR0006 "Code: "
		#define STR0007 "Name: "
		#define STR0008 "Sub-contact Structure"
		#define STR0009 "Code: "
		#define STR0010 "Name: "
		#define STR0011 "Primary Contact"
		#define STR0012 "Secondary Contact"
		#define STR0013 "Primary/Secondary Contact"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "SubContatos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Perfil do Contato" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Legenda" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Código: " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Nome: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Estrutura de SubContatos" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Código: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Nome: " )
		#define STR0011 "Contato Primário"
		#define STR0012 "Contato Secundário"
		#define STR0013 "Contato Secundário/Primário"
	#endif
#endif
