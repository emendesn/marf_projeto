#ifdef SPANISH
	#define STR0001 "SubClientes"
	#define STR0002 "Visualizar"
	#define STR0003 "Modificar"
	#define STR0004 "Generar oportunidad"
	#define STR0005 "Generar apunte"
	#define STR0006 "Contactos"
	#define STR0007 "Leyenda"
	#define STR0008 "Codigo: "
	#define STR0009 "Nombre: "
	#define STR0010 "Estructura de Subclientes"
	#define STR0011 "Codigo: "
	#define STR0012 "Nombre: "
	#define STR0013 "Cliente primario"
	#define STR0014 "Cliente secundario"
	#define STR0015 "Cliente secundario/primario"
	#define STR0016 "Incluir"
#else
	#ifdef ENGLISH
		#define STR0001 "Sub-customers"
		#define STR0002 "View"
		#define STR0003 "Change"
		#define STR0004 "Generate Opportunities"
		#define STR0005 "Generate Annotation"
		#define STR0006 "Contacts"
		#define STR0007 "Caption"
		#define STR0008 "Code: "
		#define STR0009 "Name: "
		#define STR0010 "Sub-customers Structure"
		#define STR0011 "Code: "
		#define STR0012 "Name: "
		#define STR0013 "Primary Customer"
		#define STR0014 "Secondary Customer"
		#define STR0015 "Primary/Secondary Customer"
		#define STR0016 "Add"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "SubClientes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Gerar Oportunidade" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Gerar Apontamento" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Contatos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Legenda" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "C�digo: " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Nome: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Estrutura de SubClientes" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "C�digo: " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Nome: " )
		#define STR0013 "Cliente Prim�rio"
		#define STR0014 "Cliente Secund�rio"
		#define STR0015 "Cliente Secund�rio/Prim�rio"
		#define STR0016 "Incluir"
	#endif
#endif
