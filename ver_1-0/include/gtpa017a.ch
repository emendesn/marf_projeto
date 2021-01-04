#ifdef SPANISH
	#define STR0001 "Divergencia"
	#define STR0002 "Divergencia"
	#define STR0003 "Tit cobrar"
	#define STR0004 "Tit pagar"
	#define STR0005 "Total SE1"
	#define STR0006 "Total SE2"
	#define STR0007 "Tit.Cobrar"
	#define STR0008 "Tit.Pagar"
#else
	#ifdef ENGLISH
		#define STR0001 "Divergence"
		#define STR0002 "Divergence"
		#define STR0003 "Receivable Bill"
		#define STR0004 "Payable Bill"
		#define STR0005 "SE1 Total"
		#define STR0006 "SE2 Total"
		#define STR0007 "Receivable Bill"
		#define STR0008 "Payable Bill"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Divergencia" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Divergencia" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Tit Receber" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Tit Pagar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Total SE1" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Total SE2" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Tit.Receber" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Tit.Pagar" )
	#endif
#endif
