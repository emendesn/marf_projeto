#ifdef SPANISH
	#define STR0001 "El objetivo de esta rutina es Generar el Movimiento de Stock. "
	#define STR0002 "Por favor confirme en OK para informar los parámetros de procesamiento"
	#define STR0003 "Generación de Movimiento de Stock"
	#define STR0005 "Producto (MP):"
	#define STR0006 "Cantidad"
	#define STR0007 "Base"
	#define STR0008 "Digitada"
	#define STR0009 "Diferencia"
	#define STR0010 "Porcentaje"
	#define STR0011 "¡Atención!"
	#define STR0012 "La cantidad informada es diferente de la Base. Ajuste las cantidades"
	#define STR0013 "El porcentaje informado es diferente de la Base. Ajuste los Porcentajes"
#else
	#ifdef ENGLISH
		#define STR0001 "This routine purports to Generate Inventory Turnover. "
		#define STR0002 "Please click OK to enter processing parameters"
		#define STR0003 "Generation of Inventory Turnover"
		#define STR0005 "Product (MP):"
		#define STR0006 "Quantity"
		#define STR0007 "Base"
		#define STR0008 "Entered"
		#define STR0009 "Difference"
		#define STR0010 "Percentage"
		#define STR0011 "Attention!"
		#define STR0012 "The Amount Entered is different from the Base. Adjust the Quantities"
		#define STR0013 "The Entered Percentage differs from the Base. Adjust the Percentages"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Esse procedimento tem como objectivo em gerar e movimentação de stock. ", "Essa rotina tem por objetivo em Gerar e movimentação de Estoque. " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Por favor, clique no botão OK para informar os parâmetros do processamento", "Por favor clique no botão OK para informar os parâmetros do processamento" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Geração de Movimentação de Stock", "Geração de Movimentação de Estoque" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Artigo (MP):", "Produto (MP):" )
		#define STR0006 "Quantidade"
		#define STR0007 "Base"
		#define STR0008 "Digitada"
		#define STR0009 "Diferença"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Percentagem", "Percentual" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Atenção!", "Atencao!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A quantidade digitada está diferente da base. Acerte as quantidades", "A Quantidade Digitada está diferente da Base. Acerte as Quantidades" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "A percetagem digitada está diferente da base. Acerte as percentagens", "O Percetual Digitado está diferente da Base. Acerte os Percentuais" )
	#endif
#endif
