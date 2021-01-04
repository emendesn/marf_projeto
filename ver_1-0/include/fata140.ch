#ifdef SPANISH
	#define STR0001 "Estructura"
	#define STR0002 "Categoria de productos"
	#define STR0003 " - Prevision de Ventas"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Items de prevision"
	#define STR0008 "Cantidad"
	#define STR0009 "Valor"
	#define STR0010 "No existen totales para esta consulta."
	#define STR0011 "Totales de previsiones de venta"
	#define STR0012 "Incluye previsiones de venda"
	#define STR0013 "Prevision"
	#define STR0014 "El desbloqueo de esta categoria no se puede realizar porque hay productos de esta categoria que se vincularon a otra categoria."
	#define STR0015 "Grupos duplicados"
	#define STR0016 "Grupo"
	#define STR0017 "Descripcion"
	#define STR0018 "Categoria"
	#define STR0019 "Productos duplicados"
	#define STR0020 "Producto"
	#define STR0021 "Atencion"
	#define STR0022 "Esta Categoria no se puede borrar, pues esta asociada a Metas de ventas."
	#define STR0023 "Esta categoria no se puede borrar, pues esta asociada a Publicacion de precios."
	#define STR0024 "Total de registros"
#else
	#ifdef ENGLISH
		#define STR0001 "Structure"
		#define STR0002 "Product category"
		#define STR0003 " - Sales forecast "
		#define STR0004 "Add "
		#define STR0005 "Edit "
		#define STR0006 "Dlete "
		#define STR0007 "Forecast items "
		#define STR0008 "Quantity "
		#define STR0009 "Amount"
		#define STR0010 "No totals for this query. "
		#define STR0011 "Total sales forecasts "
		#define STR0012 "Add sales forecasts "
		#define STR0013 "Forecast"
		#define STR0014 "This category cannot be unblocked because there are products of this category that were related to another category."
		#define STR0015 "Duplicate groups"
		#define STR0016 "Group"
		#define STR0017 "Description"
		#define STR0018 "Category"
		#define STR0019 "Duplicate products"
		#define STR0020 "Product"
		#define STR0021 "Attention"
		#define STR0022 "This Category cannot be deleted, as it is associated to Sales Goals."
		#define STR0023 "This Category cannot be deleted, as it is associated to Price Publication."
		#define STR0024 "Total of Records"
	#else
		#define STR0001 "Estrutura"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Categoria de Artigos", "Categoria de produtos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", " - Previsão de Vendas", " - Previsao de Vendas" )
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Element. de previsão", "Itens de previsao" )
		#define STR0008 "Quantidade"
		#define STR0009 "Valor"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Não existem totais para essa consulta.", "Nao existem totais para essa consulta." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Totais de previsões de venda", "Totais de previsoes de venda" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Incluir previsões de venda", "Inclui previsoes de venda" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Previsão", "Previsao" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "O desbloqueio desta categoria não pode ser realizado pois há artigos desta categoria que foram vinculados a outra categoria.", "O desbloqueio desta categoria não pode ser realizado pois há produtos desta categoria que foram vinculados a outra categoria." )
		#define STR0015 "Grupos duplicados"
		#define STR0016 "Grupo"
		#define STR0017 "Descrição"
		#define STR0018 "Categoria"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Artigos duplicados", "Produtos duplicados" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Artigo", "Produto" )
		#define STR0021 "Atenção"
		#define STR0022 "Esta Categoria não pode ser excluída, pois esta associada a Metas de Vendas."
		#define STR0023 "Esta Categoria não pode ser excluída, pois esta associada a Publicação de preços."
		#define STR0024 "Total de Registros"
	#endif
#endif
