#ifdef SPANISH
	#define STR0001 "Documentos de Carga"
	#define STR0002 "Digitado"
	#define STR0003 "Bloqueado"
	#define STR0004 "Aprobado"
	#define STR0005 "Embarcado"
	#define STR0006 "Entregado"
	#define STR0007 "Retornado"
	#define STR0008 "Anulado"
	#define STR0009 "Buscar"
	#define STR0010 "Visualizar"
	#define STR0011 "Prorrateos"
	#define STR0012 "Imprimir"
	#define STR0013 "Items"
	#define STR0014 "Unitizadores"
	#define STR0015 "Trechos"
	#define STR0016 "Calculos"
	#define STR0017 "Factura Previas"
	#define STR0018 "Ocurrencias"
	#define STR0019 "Documentos de Flete"
	#define STR0020 "Valor Flete"
	#define STR0021 "Valor de la suma de los componentes de Calculo"
#else
	#ifdef ENGLISH
		#define STR0001 "Shipping Documents"
		#define STR0002 "Entered"
		#define STR0003 "Blocked"
		#define STR0004 "Released"
		#define STR0005 "Shipped"
		#define STR0006 "Delivered"
		#define STR0007 "Reversed"
		#define STR0008 "Canceled"
		#define STR0009 "Search"
		#define STR0010 "View"
		#define STR0011 "Apportionments"
		#define STR0012 "Print"
		#define STR0013 "Items"
		#define STR0014 "Unitizers"
		#define STR0015 "Distances"
		#define STR0016 "Calculation"
		#define STR0017 "Pro Forma Invoices"
		#define STR0018 "Occurrences"
		#define STR0019 "Freight Documents"
		#define STR0020 "Freight Value"
		#define STR0021 "Sum of calculation components"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Documentos de carga", "Documentos de Carga" )
		#define STR0002 "Digitado"
		#define STR0003 "Bloqueado"
		#define STR0004 "Liberado"
		#define STR0005 "Embarcado"
		#define STR0006 "Entregue"
		#define STR0007 "Retornado"
		#define STR0008 "Cancelado"
		#define STR0009 "Pesquisar"
		#define STR0010 "Visualizar"
		#define STR0011 "Rateios"
		#define STR0012 "Imprimir"
		#define STR0013 "Itens"
		#define STR0014 "Unitizadores"
		#define STR0015 "Trechos"
		#define STR0016 "C�lculos"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Pr�-facturas", "Pr�-faturas" )
		#define STR0018 "Ocorr�ncias"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Documentos de frete", "Documentos de Frete" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Valor frete", "Valor Frete" )
		#define STR0021 "Valor da soma dos componentes de c�lculo"
	#endif
#endif
