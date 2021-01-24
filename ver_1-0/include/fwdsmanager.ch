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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Defina o alias utilizando o m�todo SetAlias()" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Erro na gera��o/grava��o do arquivo " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Defina o alias utilizando o m�todo SetAlias()" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Vis�o sem nome definido. Utilize o m�todo SetName() da FWDSView() para definir um nome." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Nome j� existente. Defina um nome diferente para a Vis�o." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Colunas n�o inseridas. Utilize o m�todo SetCollumns()" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "J� existe um gr�fico com este nome. Defina um nome diferente." )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Tipo de gr�fico n�o definido. Utilize o m�todo SetType()." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Categoria n�o definida. Utilize o m�todo SetCategory()." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Serie n�o definida. Utilize o m�todo SetSerie()." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Campos da s�rie preenchidos incorretamente." )
	#endif
#endif
