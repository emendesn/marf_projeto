#ifdef SPANISH
	#define STR0001 "CHECK-OUT DEL PROCESO DE EMBALAJE"
	#define STR0002 "Este programa tiene como objetivo imprimir informe "
	#define STR0003 "de acuerdo con los parametros informados por el usuario."
	#define STR0004 "A rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Documento"
	#define STR0007 "Estatus"
	#define STR0008 "CANT.ITEMS"
	#define STR0009 "CANT.VOLUMENES"
	#define STR0010 "Analitico"
	#define STR0011 "Sintetico"
	#define STR0012 "Divergentes"
	#define STR0013 "Todos"
	#define STR0014 "NO EXISTEN DATOS PARA ESTA SELECCION"
	#define STR0015 "ANULADO POR EL OPERADOR"
	#define STR0016 "ERROR DE INTEGRIDAD"
	#define STR0017 "Documentos sin Items"
	#define STR0018 "No Iniciado"
	#define STR0019 "En Proceso"
	#define STR0020 "Finalizado"
	#define STR0021 "Volumen"
	#define STR0022 "Cant. de Items"
	#define STR0023 "Operador"
	#define STR0024 "Items divergentes"
	#define STR0025 "PRODUCTO"
	#define STR0026 "DESCRIPCION"
	#define STR0027 "CANT."
	#define STR0028 "TOTAL DE VOLUMENES"
	#define STR0029 "TOTAL GENERAL DE VOLUMENES"
	#define STR0030 "LOTE"
	#define STR0031 "SUBLOTE"
#else
	#ifdef ENGLISH
		#define STR0001 "CHECK-OUT OF THE PACKAGE PROCESS"
		#define STR0002 "This program prints the report"
		#define STR0003 "according to parameters informed by the user."
		#define STR0004 "Z-form"
		#define STR0005 "Administration"
		#define STR0006 "Document"
		#define STR0007 "Status"
		#define STR0008 "ITEM AMT."
		#define STR0009 "VOLUME AMT."
		#define STR0010 "Detailed"
		#define STR0011 "Summarized"
		#define STR0012 "Conflicting"
		#define STR0013 "All"
		#define STR0014 "NO DATA FOR THIS SELECTION."
		#define STR0015 "CANCELLED BY THE OPERATOR."
		#define STR0016 "INTEGRITY ERROR"
		#define STR0017 "Documents with no items"
		#define STR0018 "Not Started"
		#define STR0019 "In Progress"
		#define STR0020 "Finished"
		#define STR0021 "Volume"
		#define STR0022 "Item Amount"
		#define STR0023 "Operator"
		#define STR0024 "Conflicting items"
		#define STR0025 "PRODUCT"
		#define STR0026 "DESCRIPTION"
		#define STR0027 "AMT."
		#define STR0028 "VOLUME TOTAL"
		#define STR0029 "VOLUME GRAND TOTAL"
		#define STR0030 "LOT"
		#define STR0031 "SUBLOT"
	#else
		#define STR0001 "CHECK-OUT DO PROCESSO DE EMBALAGEM"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo imprimir relatório ", "Este programa tem como objetivo imprimir relatorio " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "de acordo com os parâmetros informados pelo utilizador.", "de acordo com os parametros informados pelo usuario." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0006 "Documento"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "QTD.ITENS", "QTDE.ITENS" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "QTD.VOLUMES", "QTDE.VOLUMES" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Analítico", "Analitico" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Sintético", "Sintetico" )
		#define STR0012 "Divergentes"
		#define STR0013 "Todos"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "NÃO HÁ DADOS PARA ESTA SELECÇÃO", "NAO EXISTEM DADOS PARA ESTA SELECAO" )
		#define STR0015 "CANCELADO PELO OPERADOR"
		#define STR0016 "ERRO DE INTEGRIDADE"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Documentos sem itens", "Documentos sem Itens" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Não iniciado", "Nao Iniciado" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Em andamento", "Em Andamento" )
		#define STR0020 "Finalizado"
		#define STR0021 "Volume"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Qtd. de itens", "Qtde de Itens" )
		#define STR0023 "Operador"
		#define STR0024 "Itens divergentes"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "ARTIGO", "PRODUTO" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "DESCRIÇÃO", "DESCRICAO" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "QTD.", "QTDE." )
		#define STR0028 "TOTAL DE VOLUMES"
		#define STR0029 "TOTAL GERAL DE VOLUMES"
		#define STR0030 "LOTE"
		#define STR0031 "SUBLOTE"
	#endif
#endif
