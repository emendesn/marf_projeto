#ifdef SPANISH
	#define STR0001 "Este informe tiene como objetivo mostrar los valores sinteticos calculados en el calculo del FCI."
	#define STR0002 "Calculo previo FCI"
	#define STR0003 "Codigo"
	#define STR0004 "Descripcion"
	#define STR0005 "Periodo"
	#define STR0006 "Origen"
	#define STR0007 "Valor VI"
	#define STR0008 "Ficha de contenido de importacion "
	#define STR0009 "Codigo"
	#define STR0010 "Descripcion"
	#define STR0011 "Per. Calc."
	#define STR0012 "Per.Fact."
	#define STR0013 "Cuota Imp."
	#define STR0014 "Valor salidas"
	#define STR0015 "Cont. Import."
	#define STR0016 "Origen"
	#define STR0017 "Codigo FCI"
	#define STR0018 "Relacion FCI Sintetico "
	#define STR0019 "Comprado"
	#define STR0020 "Producido"
	#define STR0021 "Relacion FCI Sintetico "
	#define STR0022 "Tipo"
	#define STR0023 "(Calculo previo FCI)"
	#define STR0024 "(Ficha de contenido de importacion)"
	#define STR0025 "Tipo"
#else
	#ifdef ENGLISH
		#define STR0001 "This report aims at displaying the summarized values calculated in the FCI calculation."
		#define STR0002 "FCI Pre Calculation"
		#define STR0003 "Code"
		#define STR0004 "Description"
		#define STR0005 "Period"
		#define STR0006 "Origin"
		#define STR0007 "Value VI"
		#define STR0008 "Import Content Form"
		#define STR0009 "Code"
		#define STR0010 "Description"
		#define STR0011 "Calc. Per."
		#define STR0012 "Inv. Per."
		#define STR0013 "Imp. Inst."
		#define STR0014 "Outflow Values"
		#define STR0015 "Imp. Cont."
		#define STR0016 "Origin"
		#define STR0017 "FCI Code"
		#define STR0018 "Summarized FCI List "
		#define STR0019 "Purchased"
		#define STR0020 "Produced"
		#define STR0021 "Summarized FCI List "
		#define STR0022 "Type"
		#define STR0023 "(FCI Pre Calculation)"
		#define STR0024 "(Import Content Form)"
		#define STR0025 "Type"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Este relatório tem como objetivo apresentar os valores sintéticos calculados na apuração do FCI." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Pré-Apuração FCI" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Código" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Periodo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Origem" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Valor VI" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Ficha de Conteúdo de Importação" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Código" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Per.Apur." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Per.Fat." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Parcela Imp." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Valor Saídas" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Cont. Import." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Origem" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Código FCI" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Relação FCI Sintético " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Comprado" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Produzido" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Relação FCI Sintético " )
		#define STR0022 "Tipo"
		#define STR0023 "(Pré-Apuração FCI)"
		#define STR0024 "(Ficha de Conteúdo de Importação)"
		#define STR0025 "Tipo"
	#endif
#endif
