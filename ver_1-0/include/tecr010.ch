#ifdef SPANISH
	#define STR0001 "Detalle de Equipos"
	#define STR0002 " Este informe imprimira la relacion de equipos y "
	#define STR0003 "accesorios de la Base Instalada conforme los parametros solicitados"
	#define STR0004 ""
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
	#define STR0007 "ANULADO POR EL OPERADOR"
	#define STR0008 "CLIENTE   NOMBRE               PRODUCTO        DESC.PRODUCTO                NUM.SERIE              VENTA      INSTALACION GARANTIA  PROVEEDOR  DESC. PROVEEDOR      FABRICANTE DESC.FABR.      MODELO                        "
	#define STR0009 "                               ACCESORIO       DESC.ACCES.                  NUM.SERIE ACCESORIO"
	#define STR0010 "CLIENTE                   NOMBRE               PRODUCTO              DESC.PRODUCTO  NUM.SERIE              VENTA     INSTALACION GARANTIA   PROVEEDOR               FABRICANTE                MODELO                         "
	#define STR0011 "                                               ACCESORIO            DESC.ACCES.   NUM.SERIE ACCESORIO"
	#define STR0012 "¿De Grupo           ?"
	#define STR0013 "¿A Grupo            ?"
	#define STR0014 "Cliente vs. Prod. "
	#define STR0015 "Base Instalada"
	#define STR0016 "Accesorios de Base Instalada"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Equipments   "
		#define STR0002 " This report will show the list of equipments and"
		#define STR0003 "accessories of Installed Base according to requested parameters"
		#define STR0004 ""
		#define STR0005 "Z.Form "
		#define STR0006 "Management   "
		#define STR0007 "CANCELLED BY THE OPERATOR  "
		#define STR0008 "CUSTOMER  NAME                 PRODUCT         PRODUCT DESC                   SERIE NO.            SALE       INSTALLAT. GUARANT.   SUPPLIER   SUPPLIER DESC.       MANUFACTU. FACT.DESC.      MODEL                         "
		#define STR0009 "                               ACCESSORY        ACCES.DESC.                    ACCESSORY SER.NO."
		#define STR0010 "CUSTOMER                  NAME                 PRODUCT              PRODUCT DESC.   SERI.NO.            SALE       INSTALLAT. GUARANT.   SUPPLIER                MANUFACTURER              MODEL                         "
		#define STR0011 "                                               ACCESSORY            ACCES.DESC.     ACCESSORY SER.NO."
		#define STR0012 "Group from         ?"
		#define STR0013 "Group to           ?"
		#define STR0014 "Customer vs. product"
		#define STR0015 "Installed base"
		#define STR0016 "Acessories of installed base"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relação De Equipamentos", "Relacao de Equipamentos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", " este relatório vai imprimir a relação de equipamentos", " Este relatorio ira imprimir a relacao de equipamentos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "E acessórios da base instalada cofacturaorme os parâmetros solicitados", "e acessorios da Base de Atendimento conforme os parametros solicitados" )
		#define STR0004 ""
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cliente   nome                 artigo         desc.artigo                   n.série              venda      instalação garantia   fornecedor desc.fornecedor      fabricante desc.fabr.      modelo                        ", "CLIENTE   NOME                 PRODUTO         DESC.PRODUTO                   ID.UNICO             VENDA      INSTALACAO GARANTIA   FORNECEDOR DESC.FORNECEDOR      FABRICANTE DESC.FABR.      MODELO                        " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "                               Acessório       Desc.acess.                    N.série Acessório", "                               ACESSORIO       DESC.ACESS.                    ID.UNICO ACESSORIO" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cliente                   nome                 artigo              desc.artigo    n.série              venda      instalação garantia   fornecedor                fabricante                modelo                        ", "CLIENTE                   NOME                 PRODUTO              DESC.PRODUTO    ID.UNICO             VENDA      INSTALACAO GARANTIA   FORNECEDOR                FABRICANTE                MODELO                        " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "                                               Acessório            Desc.acess.     N.série Acessório", "                                               ACESSORIO            DESC.ACESS.     ID.UNICO ACESSORIO" )
		#define STR0012 "Grupo de           ?"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Grupo até          ?", "Grupo ate          ?" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Cliente X Artigo", "Cliente X Produto" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Base Instalada", "Base de Atendimento" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Acessórios Da Base Instalada", "Acessórios da Base de Atendimento" )
	#endif
#endif
