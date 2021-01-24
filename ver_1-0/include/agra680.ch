#ifdef SPANISH
	#define STR0001 "Resultado de Laboratorio HVI"
	#define STR0002 "Busca archivos"
	#define STR0003 "Importacion de archivos"
	#define STR0004 "Resultado de Laboratorio de HVI"
	#define STR0005 'Modelo de datos del Resultado de Laboratorio HVI'
	#define STR0006 'Datos del Resultado de Laboratorio de HVI'
	#define STR0007 "Seleccione el camino donde estan ubicados los archivos"
	#define STR0008 "Layout"
	#define STR0009 "Buscar"
	#define STR0010 "Buscar archivos"
	#define STR0011 "Archivo"
	#define STR0012 "Tamaño"
	#define STR0013 "Ultima Modificacion"
	#define STR0014 "Archivos Procesados:"
	#define STR0015 "Registros Importados:"
	#define STR0016 "Importar"
	#define STR0017 "Importar Archivos"
	#define STR0018 "¡ATENCION!"
	#define STR0019 "La estructura del Layout esta vacia"
	#define STR0020 "Codigo de layout invalido."
	#define STR0021 "Layout:"
	#define STR0022 "Linea:"
	#define STR0023 "Programa:"
	#define STR0024 "Id del campo de origen: "
	#define STR0025 "Id del formulario de error: "
	#define STR0026 "Id del campo de error: "
	#define STR0027 "Id del error: "
	#define STR0028 "Mensaje de error: "
	#define STR0029 "Espere... ¡Importando resultados!"
	#define STR0030 "HVI Procesados: "
	#define STR0031 "HVI Importados: "
	#define STR0032 "Etiquetas no ubicadas: "
#else
	#ifdef ENGLISH
		#define STR0001 "HVI Lab Results"
		#define STR0002 "Files Search"
		#define STR0003 "Files Import"
		#define STR0004 "HVI Lab Results"
		#define STR0005 'HVI Lab Result data model'
		#define STR0006 'HVI Lab Result Data '
		#define STR0007 "Select path where the files are localized"
		#define STR0008 "Layout"
		#define STR0009 "Search"
		#define STR0010 "Search files"
		#define STR0011 "File"
		#define STR0012 "Size"
		#define STR0013 "Last Change"
		#define STR0014 "Files processed:"
		#define STR0015 "Records imported:"
		#define STR0016 "Import"
		#define STR0017 "Import Files"
		#define STR0018 "WARNING!"
		#define STR0019 "Layout structure is blank"
		#define STR0020 "Invalid Layout code"
		#define STR0021 "Layout:"
		#define STR0022 "Row:"
		#define STR0023 "Program:"
		#define STR0024 "Id of the origin field: "
		#define STR0025 "Id of error form: "
		#define STR0026 "Id of error field: "
		#define STR0027 "Error Id: "
		#define STR0028 "Error message: "
		#define STR0029 "Wait... Importing Results!"
		#define STR0030 "HVI Processed : "
		#define STR0031 "HVI Imported : "
		#define STR0032 "Labels Not Located : "
	#else
		#define STR0001 "Resultado Laboratorial HVI"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Pesquisa ficheiros", "Pesquisa arquivos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Importação de ficheiros", "Importação de arquivos" )
		#define STR0004 "Resultado Laboratorial de HVI"
		#define STR0005 'Modelo de dados do Resultado Laboratorial HVI'
		#define STR0006 'Dados do Resultado Laboratorial de HVI'
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Seleccione o caminho onde estão localizados os ficheiros", "Selecione o caminho onde estão localizados os arquivos" )
		#define STR0008 "Layout"
		#define STR0009 "Buscar"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Buscar ficheiros", "Buscar arquivos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Ficheiro", "Arquivo" )
		#define STR0012 "Tamanho"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Última alteração", "Ultima Alteração" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Ficheiros processados:", "Arquivos Processados:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Registos importados:", "Registros Importados:" )
		#define STR0016 "Importar"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Importar ficheiros", "Importar Arquivos" )
		#define STR0018 "ATENÇÃO!"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "A estrutura do layout está vazia", "A estrutura do Layout está vazia" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Código de layout inválido", "Código de Layout invalido" )
		#define STR0021 "Layout:"
		#define STR0022 "Linha:"
		#define STR0023 "Programa:"
		#define STR0024 "Id do campo de origem: "
		#define STR0025 "Id do formulário de erro: "
		#define STR0026 "Id do campo de erro: "
		#define STR0027 "Id do erro: "
		#define STR0028 "Mensagem do erro: "
		#define STR0029 "Aguarde... Importando Resultados!"
		#define STR0030 "HVI Processados : "
		#define STR0031 "HVI Importados : "
		#define STR0032 "Etiquetas Nao Localizadas : "
	#endif
#endif
