#ifdef SPANISH
	#define STR0001 "Cuadro de Licitaciones"
	#define STR0002 "Este informe solo esta disponible a partir de la Release 4."
	#define STR0003 "Este programa tiene el objetivo de imprimir la  "
	#define STR0004 "lista de los editales y los productos "
	#define STR0005 "Licitacion:"
	#define STR0006 "Modalidad"
	#define STR0007 "Etapa"
	#define STR0008 "Productos del Edital"
	#define STR0009 "Proveedores/Clientes"
	#define STR0010 "Tipo"
	#define STR0011 "Nombre"
	#define STR0012 "Valor Total"
	#define STR0013 "Ganador"
	#define STR0014 "No Clasificado"
	#define STR0015 "Clasificacion"
	#define STR0016 "Pre-Cliente"
	#define STR0017 "Cliente"
	#define STR0018 "Pre-Proveedor"
	#define STR0019 "Proveedor"
#else
	#ifdef ENGLISH
		#define STR0001 "Bidding Staff"
		#define STR0002 "This report is only available as of Release 4."
		#define STR0003 "This program aims at printing"
		#define STR0004 "list of notices and products"
		#define STR0005 "Bidding"
		#define STR0006 "Modality"
		#define STR0007 "Stage"
		#define STR0008 "Notice products"
		#define STR0009 "Suppliers/Customers"
		#define STR0010 "Type"
		#define STR0011 "Name"
		#define STR0012 "Total Value"
		#define STR0013 "Winner"
		#define STR0014 "Not Classified"
		#define STR0015 "Classification"
		#define STR0016 "Pre-Customer"
		#define STR0017 "Customer"
		#define STR0018 "Pre-Supplier"
		#define STR0019 "Supplier"
	#else
		#define STR0001 "Quadro de Licitações"
		#define STR0002 "Este relatório só está disponível a partir da Release 4."
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Este programa imprime a  ", "Este programa tem como objetivo imprimir a  " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "listagem dos editais e os artigos ", "listagem dos editais e os produtos " )
		#define STR0005 "Licitação"
		#define STR0006 "Modalidade"
		#define STR0007 "Etapa"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Artigos do Edital", "Produtos do Edital" )
		#define STR0009 "Forcedores/Clientes"
		#define STR0010 "Tipo"
		#define STR0011 "Nome"
		#define STR0012 "Valor Total"
		#define STR0013 "Ganhador"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Não Classificado", "Nao Classificado" )
		#define STR0015 "Classificação"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Pré-Cliente", "Pre-Cliente" )
		#define STR0017 "Cliente"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Pré-Fornecedor", "Pre-Fornecedor" )
		#define STR0019 "Fornecedor"
	#endif
#endif
