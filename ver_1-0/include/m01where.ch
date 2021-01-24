#ifdef SPANISH
	#define STR0001 "Filtro [ "
	#define STR0002 "Grabar"
	#define STR0003 "Permite grabar el filtro"
	#define STR0004 "Restaura"
	#define STR0005 "Restaura el filtro"
	#define STR0006 "Limpiar"
	#define STR0007 "Limpia el filtro"
	#define STR0008 "Expresion"
	#define STR0009 "Declaraciones del Filtro"
	#define STR0010 "Indicadores"
	#define STR0011 "Dimension:"
	#define STR0012 "Mantenimiento de filtros de la consulta "
	#define STR0013 "Para utilizar esta funcion es necesario seleccionar una celula del Formulario de filtro."
	#define STR0014 "N�o h� condi��es de filtro a serem salvas."
	#define STR0015 "Informe el nombre del filtro"
	#define STR0016 "Grabacion del filtro Anulada."
	#define STR0017 "Datos"
	#define STR0018 "Aviso"
	#define STR0019 "Esta expresion fue escrita en AdvPL."
	#define STR0020 "Elementos"
	#define STR0021 "Expresion"
	#define STR0022 "Declaraciones"
	#define STR0023 "Indicadores"
#else
	#ifdef ENGLISH
		#define STR0001 "Filter [ "
		#define STR0002 "Save"
		#define STR0003 "Allow saving filter"
		#define STR0004 "Restore"
		#define STR0005 "Restore filter"
		#define STR0006 "Clear"
		#define STR0007 "Clear filter"
		#define STR0008 "Expression"
		#define STR0009 "Filter Declarations"
		#define STR0010 "Indicators"
		#define STR0011 "Dimension:"
		#define STR0012 "Maintenance of query filters "
		#define STR0013 "Choose a filter form cell to use this function."
		#define STR0014 "There are no filter conditions to be saved."
		#define STR0015 "Enter the filter name"
		#define STR0016 "Filter saving cancelled."
		#define STR0017 "Data"
		#define STR0018 "Warning"
		#define STR0019 "This expression has been written in AdvPL."
		#define STR0020 "Elements"
		#define STR0021 "Expression"
		#define STR0022 "Declarations"
		#define STR0023 "Indicators"
	#else
		#define STR0001 "Filtro [ "
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Guardar", "Salvar" )
		#define STR0003 "Permite salva do filtro"
		#define STR0004 "Restaurar"
		#define STR0005 "Restaura o filtro"
		#define STR0006 "Limpar"
		#define STR0007 "Limpa o filtro"
		#define STR0008 "Express�o"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Declara��es do filtro", "Declara��es do Filtro" )
		#define STR0010 "Indicadores"
		#define STR0011 "Dimens�o:"
		#define STR0012 "Manuten��o de filtros da consulta "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Para utilizar esta fun��o, e necess�rio selecionar uma celula do formulario de filtro.", "Para utilizar esta fun��o, � necess�rio selecionar uma c�lula do formul�rio de filtro." )
		#define STR0014 "N�o h� condi��es de filtro a serem salvas."
		#define STR0015 "Informe o nome do filtro"
		#define STR0016 "Salva do filtro cancelada."
		#define STR0017 "Dados"
		#define STR0018 "Aviso"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Esta Express�o Foi Escrita Em Advpl.", "Esta express�o foi escrita em AdvPL." )
		#define STR0020 "Elementos"
		#define STR0021 "Express�o"
		#define STR0022 "Declara��es"
		#define STR0023 "Indicadores"
	#endif
#endif
