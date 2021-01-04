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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "T�tulo ", "Titulo " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "T�tulo n�o encontrado  ", "Titulo n�o encontrado  " )
		#define STR0003 "Valor a abater "
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Valor a abater maior que o valor do t�tulo  ", "Valor a abater maior que o valor do titulo  " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "T�tulo sem saldo a abater ", "Titulo sem saldo a abater " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Abatimento de reten��o", "Abatimento de Reten��o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Reten��o de taxas", "Reten��o de Taxas" )
		#define STR0008 "Selecionando Registros..."
		#define STR0009 "Disponivel apenas para outros paises"
		#define STR0010 "Taxa Reten��o"
	#endif
#endif
