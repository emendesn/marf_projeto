#ifdef SPANISH
	#define STR0001 "Seleccione los Fardos"
	#define STR0002 "En Mejoras"
	#define STR0003 "Mejorado"
	#define STR0004 "Procesar"
	#define STR0005 "Revirtiendo movimiento de stock"
	#define STR0006 "Revirtiendo"
	#define STR0007 "Cantidades/Porcentajes de Separacion"
	#define STR0008 "Cantidad de Fardos : [ "
	#define STR0009 " ]"
	#define STR0010 "Peso Neto Total : [ "
	#define STR0011 "Fardo"
	#define STR0012 "Producto"
	#define STR0013 "Local"
	#define STR0014 "Peso Neto"
	#define STR0015 "Descripcion"
	#define STR0016 "Unidad Medida"
	#define STR0017 "Porcentaje"
	#define STR0018 "Cantidad"
	#define STR0019 "Confirmar"
	#define STR0020 "Anular"
	#define STR0021 "Generando movimientos de stock..."
	#define STR0022 "Espere"
#else
	#ifdef ENGLISH
		#define STR0001 "Select the bales"
		#define STR0002 "In Processing"
		#define STR0003 "Processed"
		#define STR0004 "Process"
		#define STR0005 "Reversing stock transaction"
		#define STR0006 "Reversing"
		#define STR0007 "Separation Amounts/Percentages"
		#define STR0008 "Amount of Bales: [ "
		#define STR0009 " ]"
		#define STR0010 "Total Net Weight : [ "
		#define STR0011 "Bale"
		#define STR0012 "Product"
		#define STR0013 "Location"
		#define STR0014 "Net Weight"
		#define STR0015 "Description"
		#define STR0016 "Unit of Measurement"
		#define STR0017 "Percentage"
		#define STR0018 "Amount"
		#define STR0019 "Confirm"
		#define STR0020 "Cancel"
		#define STR0021 "Generating inventory operations..."
		#define STR0022 "Wait"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Seleccione os fardos", "Selecione os Farões" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Em beneficiamento", "Em Beneficiamento" )
		#define STR0003 "Beneficiado"
		#define STR0004 "Processar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A estornar movimento de stock", "Estornando movimento de estoque" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A estornar", "Estornando" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Quantidades/percentagens de separação", "Quantidades/Percentuais de Separação" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Quantidade de fardões : [ ", "Quantidade de Fardões : [ " )
		#define STR0009 " ]"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Peso líquido total : [ ", "Peso Liquido Total : [ " )
		#define STR0011 "Fardão"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Artigo", "Produto" )
		#define STR0013 "Local"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Peso líquido", "Peso Líquido" )
		#define STR0015 "Descrição"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Unidade medida", "Unidade Medida" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Percentagem", "Percentual" )
		#define STR0018 "Quantidade"
		#define STR0019 "Confirmar"
		#define STR0020 "Cancelar"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "A gerar movimentações de stock...", "Gerando movimentações de estoque..." )
		#define STR0022 "Aguarde"
	#endif
#endif
