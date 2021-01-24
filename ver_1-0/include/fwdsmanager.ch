#ifdef SPANISH
	#define STR0001 "Defina el alias utilizando el metodo SetAlias()"
	#define STR0002 "Error en la generacion/grabacion del archivo "
	#define STR0003 "Defina el alias utilizando el metodo SetAlias()"
	#define STR0004 "Vision sin nombre definido. Utilice el metodo SetName() de FWDSView() para definir un nombre."
	#define STR0005 "Nombre ya existente. Defina un nombre diferente para la vision."
	#define STR0006 "Columnas no incluidas. Utilice el metodo SetCollumns()"
	#define STR0007 "Ya existe un grafico con este nombre. Defina un nombre diferente."
	#define STR0008 "Tipo de grafico no definido. Utilice el metodo SetType()."
	#define STR0009 "Categoria no definida. Utilice el metodo SetCategory()."
	#define STR0010 "Serie no definida. Utilice el metodo SetSerie()."
	#define STR0011 "Campos de la serie rellenados incorrectamente."
#else
	#ifdef ENGLISH
		#define STR0001 "Set the alias by using the SetAlias() method."
		#define STR0002 "Error while generating/saving the file "
		#define STR0003 "Set the alias by using the SetAlias() method."
		#define STR0004 "View without a name defined. Use the SetName() method of FWDSView() to define a name."
		#define STR0005 "Name already exists. Define a different name for the View."
		#define STR0006 "Columns not inserted. Use the SetCollumns() method."
		#define STR0007 "A chart already exists with this name. Define a different name."
		#define STR0008 "Chart type not defined. Use the SetType() method."
		#define STR0009 "Category not defined. Use the SetCategory() method."
		#define STR0010 "Series not defined. Use the SetSerie() method."
		#define STR0011 "Series fields filled out incorrectly."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Defina o alias utilizando o método SetAlias()" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Erro na geração/gravação do arquivo " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Defina o alias utilizando o método SetAlias()" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Visão sem nome definido. Utilize o método SetName() da FWDSView() para definir um nome." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Nome já existente. Defina um nome diferente para a Visão." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Colunas não inseridas. Utilize o método SetCollumns()" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Já existe um gráfico com este nome. Defina um nome diferente." )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Tipo de gráfico não definido. Utilize o método SetType()." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Categoria não definida. Utilize o método SetCategory()." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Serie não definida. Utilize o método SetSerie()." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Campos da série preenchidos incorretamente." )
	#endif
#endif
