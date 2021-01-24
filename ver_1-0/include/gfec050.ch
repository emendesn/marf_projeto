#ifdef SPANISH
	#define STR0001 "Trechos del Documento de Carga"
	#define STR0002 "Unitizadores de los Documentos de Carga"
	#define STR0003 "Items de los Documentos de Carga"
	#define STR0004 "Documentos de Carga"
	#define STR0005 "Calculos"
	#define STR0006 "Factura Previas"
	#define STR0007 "Ajustes"
	#define STR0008 "Valor flete"
	#define STR0009 "Valor de la suma de los componentes de Calculo"
	#define STR0010 "Digitado"
	#define STR0011 "Imprimido"
	#define STR0012 "Aprobado"
	#define STR0013 "Concluido"
	#define STR0014 "Lista de Embarques de Carga"
	#define STR0015 "Buscar"
	#define STR0016 "Visualizar"
	#define STR0017 "Imprimir"
	#define STR0018 "Valor de la suma de los componentes de Calculo"
#else
	#ifdef ENGLISH
		#define STR0001 "Shipping Document Distances"
		#define STR0002 "Unitizers of Shipping Documents"
		#define STR0003 "Items of Shipping Documents"
		#define STR0004 "Shipping Documents"
		#define STR0005 "Calculation"
		#define STR0006 "Pro Forma Invoices"
		#define STR0007 "Adjustments"
		#define STR0008 "Freight Amount"
		#define STR0009 "Sum of calculation components"
		#define STR0010 "Entered"
		#define STR0011 "Printed"
		#define STR0012 "Released"
		#define STR0013 "Closed"
		#define STR0014 "Shipping Manifest"
		#define STR0015 "Search"
		#define STR0016 "View"
		#define STR0017 "Print"
		#define STR0018 "Sum of calculation components"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Trechos do documento de carga", "Trechos do Documento de Carga" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Unitizadores dos documentos de carga", "Unitizadores dos Documentos de Carga" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Itens dos documentos de carga", "Itens dos Documentos de Carga" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Documentos de carga", "Documentos de Carga" )
		#define STR0005 "Cálculos"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Pré-facturas", "Pré-faturas" )
		#define STR0007 "Ajustes"
		#define STR0008 "Valor frete"
		#define STR0009 "Valor da soma dos componentes de cálculo."
		#define STR0010 "Digitado"
		#define STR0011 "Impresso"
		#define STR0012 "Liberado"
		#define STR0013 "Encerrado"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Romaneios de carga", "Romaneios de Carga" )
		#define STR0015 "Pesquisar"
		#define STR0016 "Visualizar"
		#define STR0017 "Imprimir"
		#define STR0018 "Valor da soma dos componentes de cálculo."
	#endif
#endif
