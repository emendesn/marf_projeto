#ifdef SPANISH
	#define STR0001 "No"
	#define STR0002 "¿Quiere realmente hacer el recuento?"
	#define STR0003 "Si"
	#define STR0004 "AVISO"
	#define STR0005 "Factura verificada"
	#define STR0006 "¡Factura sin verificacion!"
	#define STR0007 "Factura con divergencia"
	#define STR0008 "Factura en verificacion"
	#define STR0009 "¿Fact. Clas.? C/ Diver."
	#define STR0010 "Detalles de verificacion del producto "
	#define STR0011 "Orden "
#else
	#ifdef ENGLISH
		#define STR0001 "No"
		#define STR0002 "Are you sure that you want to recount?"
		#define STR0003 "Yes"
		#define STR0004 "ATTENTION"
		#define STR0005 "Invoice checked"
		#define STR0006 "Invoice not checked"
		#define STR0007 "Divergent invoice"
		#define STR0008 "NF in checking"
		#define STR0009 "Clas. Inv. W/ Diver."
		#define STR0010 "Product Checking Details "
		#define STR0011 "Order "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Nao" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Voce realmente quer fazer a recontagem?" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Sim" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "AVISO" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "NF conferida" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "NF nao conferida" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "NF com divergencia" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "NF em conferencia" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "NF Clas. C/ Diver." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Detalhes de Conferencia do Produto " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Ordem " )
	#endif
#endif
