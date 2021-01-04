#ifdef SPANISH
	#define STR0001 "Esta opcion es solamente para los libros R-Diario Resumido y B-Balance Parcial Diario "
	#define STR0002 "Empresa"
	#define STR0003 "Sucursal"
	#define STR0004 "Revision"
	#define STR0005 "Tipo Registro"
	#define STR0006 "Registro"
	#define STR0007 "Generacion de Archivo Texto"
	#define STR0008 "Parametros Iniciales..."
	#define STR0009 "Esta rutina tiene el objetivo de generar el archivo texto del registro"
	#define STR0010 "Datos del Registro"
	#define STR0011 "Datos del Archivo"
	#define STR0012 "Parametros..."
	#define STR0013 " el campo Tipo es obligatorio "
	#define STR0014 " el campo Modalidad es obligatorio "
	#define STR0015 " el campo Hash es obligatorio "
	#define STR0016 " pues el tipo del libro es 0-Digital"
	#define STR0017 " existe un libro con la misma orden "
	#define STR0018 "En la linea "
#else
	#ifdef ENGLISH
		#define STR0001 "This option is only valid for R-Summarized Record and B-Trial Balance Record"
		#define STR0002 "Company"
		#define STR0003 "Branch"
		#define STR0004 "Review"
		#define STR0005 "Type of Bookkeeping"
		#define STR0006 "Bookkeeping"
		#define STR0007 "Generation of Text File"
		#define STR0008 "Inital Parameters..."
		#define STR0009 "This routine aims at generating bookkeeping text file"
		#define STR0010 "Bookkeeping Data"
		#define STR0011 "File data"
		#define STR0012 "Parameters..."
		#define STR0013 "the field Type is compulsory"
		#define STR0014 "the field Class is compulsory"
		#define STR0015 "the field HASH is compulsory"
		#define STR0016 "since type of record is 0-Digital"
		#define STR0017 "there is a record with the same order"
		#define STR0018 "In line"
	#else
		#define STR0001 "Essa op��o � somente para os livros R-Di�rio Resumido e B-Balancete Di�rio "
		#define STR0002 "Empresa"
		#define STR0003 "Filial"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Revis�o", "Revisao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Tipo Escritura��o", "Tipo Escrituracao" )
		#define STR0006 "Escritura��o"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Gera��o de Ficheiro Texto", "Gera��o de Arquivo Texto" )
		#define STR0008 "Par�metros Iniciais..."
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Esse procedimento tem o objectivo de gerar o ficheiro texto da escritura��o", "Essa rotina tem o objetivo de gerar o arquivo texto da escritura��o" )
		#define STR0010 "Dados da Escritura��o"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Dados do Ficheiro", "Dados do Arquivo" )
		#define STR0012 "Par�metros..."
		#define STR0013 " o campo Tipo � obrigat�rio "
		#define STR0014 " o campo Natureza � obrigat�rio "
		#define STR0015 " o campo Hash � obrigat�rio "
		#define STR0016 " pois o tipo do livro � 0-Digital"
		#define STR0017 " h� um livro com a mesma ordem "
		#define STR0018 "Na linha "
	#endif
#endif
