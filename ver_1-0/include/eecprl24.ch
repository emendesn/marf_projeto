#ifdef SPANISH
	#define STR0001 "Lista de Precios"
	#define STR0002 "A"
	#define STR0003 "Todos"
	#define STR0004 "De"
	#define STR0005 "a"
	#define STR0006 "A partir de"
	#define STR0007 "Todas"
	#define STR0008 "Activos"
	#define STR0009 "Esperando Aprobacion"
	#define STR0010 "Intervalo sin datos para impresion"
	#define STR0011 "�Aviso ! "
	#define STR0012 "Situacion:"
	#define STR0013 "Fch. Aprv.:"
	#define STR0014 "A"
	#define STR0015 "Producto:"
	#define STR0016 "Pais:"
	#define STR0017 "Cliente:"
	#define STR0018 "Moneda"
	#define STR0019 "Fecha Final no puede ser menor a la inicial."
#else
	#ifdef ENGLISH
		#define STR0001 "Prices Table    "
		#define STR0002 "To  "
		#define STR0003 "All  "
		#define STR0004 "From"
		#define STR0005 " to"
		#define STR0006 "From        "
		#define STR0007 "All  "
		#define STR0008 "Active"
		#define STR0009 "Awaitng approval    "
		#define STR0010 "Interval with no data for printing."
		#define STR0011 "Warn !"
		#define STR0012 "Status   :"
		#define STR0013 "Approv. Dt.:"
		#define STR0014 "To  "
		#define STR0015 "Product : "
		#define STR0016 "Cntry: "
		#define STR0017 "Client  :"
		#define STR0018 "Curren: "
		#define STR0019 "Final Date cannot be prior to initial one.  "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Tabela de pre�os", "Tabela de Pre�os" )
		#define STR0002 "At� "
		#define STR0003 "Todos"
		#define STR0004 "De "
		#define STR0005 " a "
		#define STR0006 "A partir de "
		#define STR0007 "Todas"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Activos", "Ativos" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A Aguardar Aprova��o", "Aguardando Aprova��o" )
		#define STR0010 "Intervalo sem dados para impress�o."
		#define STR0011 "Aviso!"
		#define STR0012 "Situa��o :"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Dt. aprov. :", "Dt. Aprov. :" )
		#define STR0014 "At� "
		#define STR0015 "Produto : "
		#define STR0016 "Pa�s : "
		#define STR0017 "Cliente :"
		#define STR0018 "Moeda : "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Data final n�o pode ser menor que a inicial.", "Data Final n�o pode ser menor que a inicial." )
	#endif
#endif
