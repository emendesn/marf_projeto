#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Medios de Transporte"
	#define STR0007 "Tasas de Flete"
	#define STR0008 "Procesando Archivo Temporal..."
	#define STR0009 "Contenedores"
	#define STR0010 "Flete p/ Kg"
	#define STR0011 "Pais Origen"
	#define STR0012 "Pais Destino"
	#define STR0013 "Ciudad Orig."
	#define STR0014 "Ciudad Dest."
	#define STR0016 "Informacion"
	#define STR0017 "Fletes por Kg"
	#define STR0018 "Contenedores / Flete por Kg"
	#define STR0020 "ATENCION"
	#define STR0025 "Calculadora"
	#define STR0026 "Agenda"
	#define STR0027 "Administrador de Impresion"
	#define STR0028 "Help de Programa"
	#define STR0029 "Visualizar Contenedores / Flete p/ Kg"
	#define STR0030 "Ok - <Ctrl>-O"
	#define STR0031 "Anular - <Ctrl-X>"
	#define STR0032 "Calc"
	#define STR0033 "Generar Impresion"
	#define STR0034 "Help"
	#define STR0035 "Contenedor"
	#define STR0036 "OK"
	#define STR0037 "Anular"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Transport. Ways"
		#define STR0007 "Freight Duties"
		#define STR0008 "Processing Temporary File..."
		#define STR0009 "Containers"
		#define STR0010 "Freight p/Kg"
		#define STR0011 "Source Country"
		#define STR0012 "Destin. Country"
		#define STR0013 "Source City"
		#define STR0014 "Destin. City"
		#define STR0016 "Information"
		#define STR0017 "Freights p/Kg"
		#define STR0018 "Containers / Freight p/Kg"
		#define STR0020 "ATTENTION"
		#define STR0025 "Calculator"
		#define STR0026 "Schedule"
		#define STR0027 "Print Manager"
		#define STR0028 "Program Help"
		#define STR0029 "View Containers/Freight p/Kg"
		#define STR0030 "Ok - <Ctrl>-O"
		#define STR0031 "Cancel - <Ctrl-X>"
		#define STR0032 "Calc"
		#define STR0033 "Gen.Printing"
		#define STR0034 "Help"
		#define STR0035 "Container"
		#define STR0036 "OK"
		#define STR0037 "Cancel"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Vias De Transporte", "Vias de Transporte" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tarifas De Frete", "Tarifas de Frete" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A Processar O Ficheiro Temporário...", "Processando Arquivo Temporário..." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Contentores", "Containers" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Transportar p/kg", "Frete p/Kg" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "País Origem", "Pais Origem" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "País Destino", "Pais Destino" )
		#define STR0013 "Cidade Orig."
		#define STR0014 "Cidade Dest."
		#define STR0016 "Informação"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Fretes Por Kg", "Fretes por Kg" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Contentores / Transportar Por Kg", "Containers / Frete por Kg" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENÇÇO" )
		#define STR0025 "Calculadora"
		#define STR0026 "Agenda"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Gestor De Impressão", "Gerenciador de Impressao" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Ajuda De Programa", "Help de Programa" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Visualizar contentores/frete p/kg", "Visualizar Containers/Frete p/Kg" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Ok - <ctrl>-o", "Ok - <Ctrl>-O" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Cancelar - <ctrl-x>", "Cancelar - <Ctrl-X>" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Cálc", "Calc" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "G.impres.", "G.Impre" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Ajuda", "Help" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Contentor", "Container" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Ok", "OK" )
		#define STR0037 "Cancelar"
	#endif
#endif
