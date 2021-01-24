#ifdef SPANISH
	#define STR0001 "Prorrateo por Vehiculo/Viaje"
	#define STR0002 "Codigo del gasto: "
	#define STR0003 "Documento: "
	#define STR0004 "Item:"
	#define STR0005 "Codigo del gasto: "
	#define STR0006 "Prorrateo por flota"
	#define STR0007 "Codigo del gasto: "
	#define STR0008 "Documento: "
	#define STR0009 "Item:"
	#define STR0010 "Codigo del gasto: "
#else
	#ifdef ENGLISH
		#define STR0001 "Apportionment per Vehicle/Trip"
		#define STR0002 "Expense Code : "
		#define STR0003 "Document: "
		#define STR0004 "Item :"
		#define STR0005 "Expense Code : "
		#define STR0006 "Apportionment per Fleet"
		#define STR0007 "Expense Code : "
		#define STR0008 "Document: "
		#define STR0009 "Item :"
		#define STR0010 "Expense Code : "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Rateio por Veiculo/Viagem" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Codigo da Despesa : " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Documento : " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Item :" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Codigo da Despesa : " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Rateio por Frota" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Codigo da Despesa : " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Documento : " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Item :" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Codigo da Despesa : " )
	#endif
#endif
