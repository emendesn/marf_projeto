#ifdef SPANISH
	#define STR0001 "Pendientes de la base instalada"
	#define STR0002 "Buscar   "
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar "
	#define STR0007 "     ¿Desea modificar el estatus del item para "
	#define STR0008 "¿Inactivo?"
	#define STR0009 "¿Activo?"
	#define STR0010 "íAviso !"
	#define STR0011 ""
	#define STR0012 ""
#else
	#ifdef ENGLISH
		#define STR0001 "Holdovers of Installed Base"
		#define STR0002 "Search "
		#define STR0003 "View   "
		#define STR0004 "Insert "
		#define STR0005 "Edit   "
		#define STR0006 "Delete "
		#define STR0007 "      Do you want to update this item Status to "
		#define STR0008 "Inactive ?"
		#define STR0009 "Active ?"
		#define STR0010 "Warning !"
		#define STR0011 ""
		#define STR0012 ""
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Pendências Da Base Instalada", "Pendencias da Base de Atendimento" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "      deseja alterar o estado deste item para ", "      Deseja alterar o Status deste item para " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Inactivo ?", "Inativo ?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Activo ?", "Ativo ?" )
		#define STR0010 "Aviso !"
		#define STR0011 ""
		#define STR0012 ""
	#endif
#endif
