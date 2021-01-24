#ifdef SPANISH
	#define STR0001 "Fecha"
	#define STR0002 "Cantidad"
	#define STR0003 "Equipo"
	#define STR0004 "Descripcion"
	#define STR0005 "Servicio"
	#define STR0006 "Prevision Consumo de Productos"
	#define STR0007 "Codigo"
	#define STR0008 "Producto"
	#define STR0009 "Plazo entrega"
	#define STR0010 "Bien"
	#define STR0011 "Nomb. del Bien"
	#define STR0012 "Nomb. Servicio"
	#define STR0013 "Horas"
	#define STR0014 "Hora"
	#define STR0015 "Meses"
	#define STR0016 "Mes"
	#define STR0017 "Semanas"
	#define STR0018 "Semana"
	#define STR0019 "A�os"
	#define STR0020 "A�o"
	#define STR0021 "Dias"
	#define STR0022 "Dia"
	#define STR0023 "Selecionando Registros..."
#else
	#ifdef ENGLISH
		#define STR0001 "Date"
		#define STR0002 "Quantity"
		#define STR0003 "Equipment"
		#define STR0004 "Description"
		#define STR0005 "Service"
		#define STR0006 "Products Consunption Preview"
		#define STR0007 "Code"
		#define STR0008 "Product"
		#define STR0009 "Delivery Deadline"
		#define STR0010 "Asset"
		#define STR0011 "Name of Asset"
		#define STR0012 "Service Name"
		#define STR0013 "Hours"
		#define STR0014 "Hour"
		#define STR0015 "Months"
		#define STR0016 "Month"
		#define STR0017 "Weeks"
		#define STR0018 "Week"
		#define STR0019 "Years"
		#define STR0020 "Year"
		#define STR0021 "Days"
		#define STR0022 "Day"
		#define STR0023 "Selecting records ...  "
	#else
		#define STR0001 "Data"
		#define STR0002 "Quantidade"
		#define STR0003 "Equipamento"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Descri��o", "Descricao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Servi�o", "Servico" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Previs�o Consumo De Produtos", "Previsao Consumo de Produtos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "C�digo", "Codigo" )
		#define STR0008 "Produto"
		#define STR0009 "Prazo Entrega"
		#define STR0010 "Bem"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Nome Do Bem", "Nome do Bem" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Nome Servi�o", "Nome Servico" )
		#define STR0013 "Horas"
		#define STR0014 "Hora"
		#define STR0015 "Meses"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "M�s", "Mes" )
		#define STR0017 "Semanas"
		#define STR0018 "Semana"
		#define STR0019 "Anos"
		#define STR0020 "Ano"
		#define STR0021 "Dias"
		#define STR0022 "Dia"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
	#endif
#endif
