#ifdef SPANISH
	#define STR0001 "Minimo Comercial"
	#define STR0002 "Valor de Tabla"
	#define STR0003 "% Min.Comercial"
	#define STR0004 "Vlr Min.Comercial"
	#define STR0005 "Valor Negociado"
	#define STR0006 "�Imposible seguir!"
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "M�nimo Comercial", "Minimo Comercial" )
		#define STR0002 "Valor de Tabela"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "% M�n.Comercial", "% Min.Comercial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Vlr.M�n.Comercial", "Vlr Min.Comercial" )
		#define STR0005 "Valor Negociado"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Imposs�vel continuar!", "Impossivel continuar!" )
		#define STR0007 "Margem de Lucro"
		#define STR0008 "Aten��o"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Ve�culo", "Veiculo" )
		#define STR0010 "Diferen�a"
	#endif
#endif
