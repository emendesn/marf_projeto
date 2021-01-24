#ifdef SPANISH
	#define STR0001 "Sectores de escala"
	#define STR0002 "Sectores de escala"
	#define STR0003 "Vehiculos vs. Sector"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "El vehículo está vinculado al Sector de escala #1."
#else
	#ifdef ENGLISH
		#define STR0001 "Shift Sections"
		#define STR0002 "Scale Sectors"
		#define STR0003 "Vehicl x Sector"
		#define STR0004 "Query"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Vehicle already related to Scale Sector #1."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Setores de Escala" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Setores de Escala" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Veículos X Setor" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0009 "O veículo já está vinculado ao Setor de Escala #1."
	#endif
#endif
