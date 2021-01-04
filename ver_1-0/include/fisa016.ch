#ifdef SPANISH
	#define STR0001 "Codigo Industrial Internacional Uniforme"
	#define STR0002 "ATENCION"
	#define STR0003 "OK"
	#define STR0004 "No es posible borrar este codigo de agrupamiento, pues el mismo tiene relacion con el TES: "
	#define STR0005 "No es posible borrar este codigo de CIIU, pues el mismo tiene relacion con el cliente: "
	#define STR0006 "No es posible borrar este codigo de CIIU, pues el mismo tiene relacion con el proveedor: "
	#define STR0007 "  Tienda: "
#else
	#ifdef ENGLISH
		#define STR0001 "International Standard Industrial Code"
		#define STR0002 "ATTENTION"
		#define STR0003 "OK"
		#define STR0004 "This grouping code cannot be deleted because it is related to TIO: "
		#define STR0005 "This CIIU code cannot be deleted because it is related customer: "
		#define STR0006 "This CIIU code cannot be deleted because it is related to the supplier: "
		#define STR0007 "  Store: "
	#else
		#define STR0001 "Código Industrial Internacional Uniforme"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "ATENÇÃO", "ATENCAO" )
		#define STR0003 "OK"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Não é possível eliminar esse código de agrupamento pois possui relacionamento com o TES: ", "Não é possível excluir esse código de agrupamento, pois o mesmo possui relacionamento com o TES: " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Não é possível eliminar esse código de CIIU pois possui relacionamento com o cliente: ", "Não é possível excluir esse código de CIIU, pois o mesmo possui relacionamento com o cliente: " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Não é possível eliminar esse código de CIIU pois possui relacionamento com o fornecedor: ", "Não é possível excluir esse código de CIIU, pois o mesmo possui relacionamento com o fornecedor: " )
		#define STR0007 "  Loja: "
	#endif
#endif
