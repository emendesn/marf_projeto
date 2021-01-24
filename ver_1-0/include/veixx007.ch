#ifdef SPANISH
	#define STR0001 "Minimo Comercial"
	#define STR0002 "Valor de Tabla"
	#define STR0003 "% Min.Comercial"
	#define STR0004 "Vlr Min.Comercial"
	#define STR0005 "Valor Negociado"
	#define STR0006 "¡Imposible seguir!"
	#define STR0007 "Margen de ganancia"
	#define STR0008 "Atencion"
	#define STR0009 "Vehiculo"
	#define STR0010 "Diferencia"
#else
	#ifdef ENGLISH
		#define STR0001 "Commercial Minimum Value"
		#define STR0002 "List value"
		#define STR0003 "Min. Commercial %"
		#define STR0004 "Min. Commercial Vl."
		#define STR0005 "Negotiated Value"
		#define STR0006 "Cannot continue!"
		#define STR0007 "Profit Margin"
		#define STR0008 "Attention"
		#define STR0009 "Vehicle"
		#define STR0010 "Difference"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Mínimo Comercial", "Minimo Comercial" )
		#define STR0002 "Valor de Tabela"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "% Mín.Comercial", "% Min.Comercial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Vlr.Mín.Comercial", "Vlr Min.Comercial" )
		#define STR0005 "Valor Negociado"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Impossível continuar!", "Impossivel continuar!" )
		#define STR0007 "Margem de Lucro"
		#define STR0008 "Atenção"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Veículo", "Veiculo" )
		#define STR0010 "Diferença"
	#endif
#endif
