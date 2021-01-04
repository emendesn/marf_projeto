#ifdef SPANISH
	#define STR0001 "No fue posible establecer conexion."
	#define STR0002 "No se encontro presupuesto pendiente para este cliente"
	#define STR0003 "No se encontro presupuesto pendiente"
	#define STR0004 "No es posible finalizar la venta; este presupuesto se finalizo por otro PDV."
	#define STR0005 "No fue posible crear uno o mas archivos referentes a importacion del presupuesto."
	#define STR0006 "Presupuestos: "
#else
	#ifdef ENGLISH
		#define STR0001 "Connection was not established."
		#define STR0002 "No pending quotation was found for this customer"
		#define STR0003 "No pending quotation was found"
		#define STR0004 "Sale could not be closed, as this estimate is already finalized by another POS."
		#define STR0005 "Creating one or more files referring to budget import was not possible."
		#define STR0006 "Budgets: "
	#else
		#define STR0001 "N�o foi poss�vel estabelecer conex�o."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "N�o foi encontrado or�amento em aberto para este cliente", "Nao foi encontrado orcamento em aberto para este cliente" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "N�o foi encontrado or�amento em aberto", "Nao foi encontrado orcamento em aberto" )
		#define STR0004 "N�o � poss�vel finalizar a venda, este or�amento j� foi finalizado por outro PDV."
		#define STR0005 "Nao foi possivel criar um ou mais arquivos referentes a importacao do orcamento."
		#define STR0006 "Orcamentos: "
	#endif
#endif
