#ifdef SPANISH
	#define STR0001 "Titulo "
	#define STR0002 "Titulo no encontrado  "
	#define STR0003 "Valor por descontar "
	#define STR0004 "Valor por descontar mayor que valor del titulo  "
	#define STR0005 "Titulo sin saldo por descontar "
	#define STR0006 "descuento de Retencion"
	#define STR0007 "Retencion de Tasas"
	#define STR0008 "Seleccionando registros..."
	#define STR0009 "Disponible solo para otros paises"
	#define STR0010 "Tasa retencion"
#else
	#ifdef ENGLISH
		#define STR0001 "Bill "
		#define STR0002 "Bill not found.  "
		#define STR0003 "Value to deduct "
		#define STR0004 "Value to deduct is higher than bill value.  "
		#define STR0005 "Bill with no balance to deduct "
		#define STR0006 "Withholding Abatement"
		#define STR0007 "Withholding of Fees"
		#define STR0008 "Selecting Records..."
		#define STR0009 "Available only to other countries"
		#define STR0010 "Withholding Rate"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Título ", "Titulo " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Título não encontrado  ", "Titulo não encontrado  " )
		#define STR0003 "Valor a abater "
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Valor a abater maior que o valor do título  ", "Valor a abater maior que o valor do titulo  " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Título sem saldo a abater ", "Titulo sem saldo a abater " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Abatimento de retenção", "Abatimento de Retenção" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Retenção de taxas", "Retenção de Taxas" )
		#define STR0008 "Selecionando Registros..."
		#define STR0009 "Disponivel apenas para outros paises"
		#define STR0010 "Taxa Retenção"
	#endif
#endif
