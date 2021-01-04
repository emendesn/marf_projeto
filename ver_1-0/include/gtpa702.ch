#ifdef SPANISH
	#define STR0001 "Reajuste de peaje"
	#define STR0002 "Reajustes"
	#define STR0003 "Vigencia"
	#define STR0004 "Vigencia"
	#define STR0005 "Valor"
	#define STR0006 "Valor"
	#define STR0007 "Reajuste de tarifas"
	#define STR0008 "Vigencia"
	#define STR0009 "Vigencia"
	#define STR0010 "1=Coeficiente"
	#define STR0011 "2=Valor por Km"
	#define STR0012 "Valor"
	#define STR0013 "Valor Reaj"
	#define STR0014 "Cálculo"
	#define STR0015 "Calcular"
	#define STR0016 "Calcular"
	#define STR0017 "Ítem"
	#define STR0018 "Tramo"
	#define STR0019 "Val actual Km"
	#define STR0020 "Val Órgano"
	#define STR0021 "Val. Actual"
	#define STR0022 "Val. Reajustado"
	#define STR0023 "Vigencia"
	#define STR0024 "Aviso"
	#define STR0025 "OK"
	#define STR0026 "Es necesario informar el 'Órgano' para realizar la consulta de las categorías."
	#define STR0027 "Aviso"
	#define STR0028 "OK"
	#define STR0029 "Al menos se debe seleccionar una sección."
	#define STR0030 "Aviso"
	#define STR0031 "Debe informarse la fecha de vigencia."
	#define STR0032 "OK"
	#define STR0033 "Aviso"
	#define STR0034 "No se encontraron registros en la tabla de tramos de la línea para actualización."
	#define STR0035 "OK"
	#define STR0036 "Aviso"
	#define STR0037 "Hubo un error durante la grabación, se ejecutará el 'RollBack'."
	#define STR0038 "OK"
	#define STR0039 "Aviso"
	#define STR0040 "Hubo un error durante la grabación, se ejecutará el 'RollBack'."
	#define STR0041 "OK"
#else
	#ifdef ENGLISH
		#define STR0001 "Toll Adjustment"
		#define STR0002 "Adjustments"
		#define STR0003 "Validity"
		#define STR0004 "Validity"
		#define STR0005 "Value"
		#define STR0006 "Value"
		#define STR0007 "Fee Adjustment"
		#define STR0008 "Validity"
		#define STR0009 "Validity"
		#define STR0010 "1=Coefficient"
		#define STR0011 "2=Value per Km"
		#define STR0012 "Value"
		#define STR0013 "Adj Value"
		#define STR0014 "Calculation"
		#define STR0015 "Calculate"
		#define STR0016 "Calculate"
		#define STR0017 "Item"
		#define STR0018 "Distance"
		#define STR0019 "Current Km Vl"
		#define STR0020 "Entity Vl"
		#define STR0021 "Current Vl."
		#define STR0022 "Adjusted Vl."
		#define STR0023 "Validity"
		#define STR0024 "Warning"
		#define STR0025 "OK"
		#define STR0026 "You must enter the 'Entity' to search for categories."
		#define STR0027 "Warning"
		#define STR0028 "OK"
		#define STR0029 "At least one Section must be selected."
		#define STR0030 "Warning"
		#define STR0031 "Due date must be entered."
		#define STR0032 "OK"
		#define STR0033 "Warning"
		#define STR0034 "No registers were found on the table of Update Line Excerpts."
		#define STR0035 "OK"
		#define STR0036 "Warning"
		#define STR0037 "There was an error during recording, the 'RollBack' will be executed ."
		#define STR0038 "OK"
		#define STR0039 "Warning"
		#define STR0040 "There was an error during recording, the 'RollBack' will be executed ."
		#define STR0041 "OK"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Reajuste de Pedágio" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Reajustes" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Vigencia" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Vigencia" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Valor" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Valor" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Reajuste de Tarifas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Vigencia" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Vigencia" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "1=Coeficiente" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "2=Valor por Km" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Valor" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Valor Reaj" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Cálculo" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Calcular" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Calcular" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Item" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Trecho" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Val Atual Km" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Val Orgão" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Val. Atual" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Val. Reajustado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Vigencia" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "OK" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "É necessário informar o 'Orgão' para realizar a consulta das categorias." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "OK" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Pelo menos uma Seção deve ser selecionada." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Data de vigência deve ser informada." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "OK" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Não foram encontrado registros na tabela de Trechos da Linha para atualização." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "OK" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Houve um erro durante a gravação, será executado o 'RollBack'." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "OK" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Aviso" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Houve um erro durante a gravação, será executado o 'RollBack'." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "OK" )
	#endif
#endif
