#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Protocolos"
	#define STR0008 "Modelo de Datos de Protocolos"
	#define STR0009 "Datos de Protocolos"
	#define STR0010 "Facturas"
	#define STR0011 "Vias del Protocolo"
	#define STR0012 "Generar Automatico"
	#define STR0013 "Inf. Protocolo"
	#define STR0014 "Listar Protocolos"
	#define STR0015 "Impresora"
	#define STR0016 "Pantalla"
	#define STR0017 "PDF"
	#define STR0018 "Excel"
	#define STR0019 "Resultado"
	#define STR0020 "Generar"
	#define STR0021 "Anular"
	#define STR0022 "Protocolo Inicial"
	#define STR0023 "Protocolo Final"
	#define STR0024 "Tipo de Protocolo"
	#define STR0025 "Generacion Automatica"
	#define STR0026 "Necesario marcar por lo menos una factura para generar el comprobante."
	#define STR0027 "Tipos de Generacion Automatica de Comprobante:"
	#define STR0028 "Comprobante para cada factura"
	#define STR0029 "Comprobante agrupando facturas de mismo cliente"
	#define STR0030 "Comprobante para todas las facturas marcadas"
	#define STR0031 "Salir"
	#define STR0032 "�Necesario rellenar el tipo de comprobante y el tipo de Generacion Automatica!"
	#define STR0033 "�Necesario rellenar el tipo de Generacion Automatica!"
	#define STR0034 "Generando comprobante... Espere..."
	#define STR0035 "Factura anulada."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Protocols"
		#define STR0008 "Protocol Data Model"
		#define STR0009 "Protocol Data"
		#define STR0010 "Invoices"
		#define STR0011 "Protocol Copies"
		#define STR0012 "Generate Automatic"
		#define STR0013 "Report Protocol"
		#define STR0014 "List Protocols"
		#define STR0015 "Printer"
		#define STR0016 "Screen"
		#define STR0017 "PDF"
		#define STR0018 "Excel"
		#define STR0019 "Result"
		#define STR0020 "Generate"
		#define STR0021 "Cancel"
		#define STR0022 "Initial Protocol"
		#define STR0023 "Final Protocol"
		#define STR0024 "Protocol Type"
		#define STR0025 "Automatic Generation"
		#define STR0026 "Select at least an invoice for the protocol generation."
		#define STR0027 "Types of Protocol Automatic Generation Types:"
		#define STR0028 "Protocol for each invoice"
		#define STR0029 "Protocol grouping invoices of the same customer"
		#define STR0030 "Protocol for all selected invoices"
		#define STR0031 "Exit"
		#define STR0032 "Enter the protocol type and Automatic Generation type!"
		#define STR0033 "Enter Automatic Generation type!"
		#define STR0034 "Generating protocols... Wait..."
		#define STR0035 "Invoice Canceled."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Imprimir"
		#define STR0007 "Protocolos"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de dados de protocolos", "Modelo de Dados de Protocolos" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Dados de protocolos", "Dados de Protocolos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Facturas", "Faturas" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Vias do protocolo", "Vias do Protocolo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Gerar autom�tico", "Gerar Autom�tico" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Relat. protocolo", "Relat. Protocolo" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Listar protocolos", "Listar Protocolos" )
		#define STR0015 "Impressora"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Ecr�", "Tela" )
		#define STR0017 "PDF"
		#define STR0018 "Excel"
		#define STR0019 "Resultado"
		#define STR0020 "Gerar"
		#define STR0021 "Cancelar"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Protocolo inicial", "Protocolo Inicial" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Protocolo final", "Protocolo Final" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Tipo de protocolo", "Tipo de Protocolo" )
		#define STR0025 "Gera��o Autom�tica"
		#define STR0026 "Necess�rio marcar ao menos uma fatura para gera��o do protocolo."
		#define STR0027 "Tipos de Gera��o Autom�tica de Protocolo:"
		#define STR0028 "Protocolo para cada fatura"
		#define STR0029 "Protocolo agrupando faturas de mesmo cliente"
		#define STR0030 "Protocolo para todas as faturas marcadas"
		#define STR0031 "Sair"
		#define STR0032 "Necess�rio preencher o tipo de protocolo e o tipo de Gera��o Autom�tica!"
		#define STR0033 "Necess�rio preencher o tipo de Gera��o Autom�tica!"
		#define STR0034 "Gerando protocolos... Aguarde..."
		#define STR0035 "Fatura Cancelada."
	#endif
#endif
