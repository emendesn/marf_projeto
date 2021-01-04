#ifdef SPANISH
	#define STR0001 "Lotes financieros"
	#define STR0002 "2"
	#define STR0003 "GREEN"
	#define STR0004 "Pendiente"
	#define STR0005 "Pagado"
	#define STR0006 "RED"
	#define STR0007 "Justificar"
	#define STR0008 "Visualizar"
	#define STR0009 "Vincular Doc"
	#define STR0010 "Divergencia"
	#define STR0011 "GENERAL"
	#define STR0012 "Vincular documento"
#else
	#ifdef ENGLISH
		#define STR0001 "Finance Batches"
		#define STR0002 "2"
		#define STR0003 "GREEN"
		#define STR0004 "Pending"
		#define STR0005 "Paid"
		#define STR0006 "RED"
		#define STR0007 "Justify"
		#define STR0008 "View"
		#define STR0009 "Relate Doc"
		#define STR0010 "Divergence"
		#define STR0011 "GENERAL"
		#define STR0012 "Bind Document"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Lotes Financeiros" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "2" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "GREEN" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Pendente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Pago" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "RED" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Justificar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Vincular Doc" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Divergencia" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "GERAL" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Vincular Documento" )
	#endif
#endif
