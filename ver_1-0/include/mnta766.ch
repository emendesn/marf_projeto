#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Generar Multa"
	#define STR0007 "NOTIFICACION"
	#define STR0008 "Notificaciones"
	#define STR0009 "Cuotas"
	#define STR0010 "Generacion de Multa"
	#define STR0011 "TRANSITO"
	#define STR0012 "PRODUCTO PELIGROSO"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Gen.Fine"
		#define STR0007 "NOTIFICATION"
		#define STR0008 "Notifications"
		#define STR0009 "Install."
		#define STR0010 "Fine Generation"
		#define STR0011 "TRAFFIC"
		#define STR0012 "HAZARDOUS PRODUCT"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Gerar Multa"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "NOTIFICAÇÃO", "NOTIFICACAO" )
		#define STR0008 "Notificações"
		#define STR0009 "Parcelas"
		#define STR0010 "Geração de Multa"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "TRÂNSITO", "TRANSITO" )
		#define STR0012 "PRODUTO PERIGOSO"
	#endif
#endif
