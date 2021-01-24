#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo de Modelos de Evaluacion"
	#define STR0007 "Otro usuario esta sendo utilizando el registro"
	#define STR0008 "�Intentar nuevamente?"
	#define STR0009 "Otro usuario est� utilizando los Registros relacionados a esta Tabla."
	#define STR0010 "Copiar"
	#define STR0011 ""
	#define STR0012 ""
	#define STR0013 ""
	#define STR0014 "Preguntas..."
	#define STR0015 "Alternativas..."
	#define STR0016 "Valores de las Competencias..."
	#define STR0017 "&Definiciones del Modelo"
	#define STR0018 "&Relevancias/Preguntas"
	#define STR0019 ""
	#define STR0020 ""
	#define STR0021 ""
	#define STR0022 ""
	#define STR0023 "�Aviso de Inconsistencia!"
	#define STR0024 ""
	#define STR0025 ""
	#define STR0026 ""
	#define STR0027 ""
	#define STR0028 "Esta pregunta no se puede borrar pues ya se esta utilizando en proceso de Evaluacion en curso."
	#define STR0029 "Intentando acceder al registro."
	#define STR0030 "Intentando acceder a los registros."
	#define STR0031 "�Aviso!"
	#define STR0032 "Log de Inconsistencia en Modificacion del Codigo de Preguntas"
	#define STR0033 "El Codigo de la Pregunta no puede modificarse."
	#define STR0034 "La Pregunta se esta utilizando en el proceso de Evaluacion."
	#define STR0035 "�Desea consultar el LOG?"
	#define STR0036 "y/o"
	#define STR0037 "Invalido(s)."
	#define STR0038 "Esta pregunta no pertenece al tipo de Evaluacion."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Change"
		#define STR0005 "Delete"
		#define STR0006 "Evaluation Model Registration"
		#define STR0007 "Registration is being used by another user"
		#define STR0008 "Do you want to try again?"
		#define STR0009 "Registrations related to this Table are being used by another user"
		#define STR0010 "Copy  "
		#define STR0011 ""
		#define STR0012 ""
		#define STR0013 ""
		#define STR0014 "Questions..."
		#define STR0015 "Answers..."
		#define STR0016 "Competence Values..."
		#define STR0017 "Model  &Definitions"
		#define STR0018 "Importance/Questions"
		#define STR0019 ""
		#define STR0020 ""
		#define STR0021 ""
		#define STR0022 ""
		#define STR0023 "Inconsistency Warning!"
		#define STR0024 ""
		#define STR0025 ""
		#define STR0026 ""
		#define STR0027 ""
		#define STR0028 "This question cannot be deleted, for it is being used for the Evaluation process in progress.     "
		#define STR0029 "Trying to access the record."
		#define STR0030 "Trying to access the records."
		#define STR0031 "Warning!"
		#define STR0032 "Log of Inconsistency while Changing the Code of Questions"
		#define STR0033 "Code of Questions cannot be changed."
		#define STR0034 "Question is already being used during the Evaluation process."
		#define STR0035 "Do you want to check the LOG?"
		#define STR0036 "and/or"
		#define STR0037 "Invalid."
		#define STR0038 "This question does not belong to the Evaluation type."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Cadastro de Modelos de Avalia��o", "Cadastro de Modelos de Avalia��o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "O registo est� a ser utilizado por outro utilizador", "O Registro est� sendo utilizado por outro usu�rio" )
		#define STR0008 "Tentar novamente?"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Os Registros relacionados a esta Tabela est�o sendo utilizados por outro utilizador", "Os Registros relacionados a esta Tabela est�o sendo utilizados por outro usu�rio" )
		#define STR0010 "Copiar"
		#define STR0011 ""
		#define STR0012 ""
		#define STR0013 ""
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Quest�es...", "Quest�es..." )
		#define STR0015 "Alternativas..."
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Valores Das Compet�ncias...", "Valores das Compet�ncias..." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Defini��es Do Modelo", "&Definiciones del modelo" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Relev�ncias/quest�es", "&Relevancias/Preguntas" )
		#define STR0019 ""
		#define STR0020 ""
		#define STR0021 ""
		#define STR0022 ""
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Aviso De Inconsist�ncia!", "Aviso de Inconsist�ncia!" )
		#define STR0024 ""
		#define STR0025 ""
		#define STR0026 ""
		#define STR0027 ""
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Esta quest�o n�o pode ser exclu�da pois j� est� a ser usada num processo de avalia��o em andamento.", "Esta quest�o n�o pode ser Excluida pois ja esta sendo usada em processo de Avaliac�o em andamento." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "A tentar aceder ao registo.", "Tentando acessar o registro." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Tentando aceder aos registos.", "Tentando acessar os registros." )
		#define STR0031 "Aviso!"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Log De Inconsist�ncia Na Altera��o Do C�digo De Quest�es", "Log de Inconsistencia na Alteracao do Codigo de Questoes" )
		#define STR0033 "O C�digo da Quest�o n�o pode ser alterado."
		#define STR0034 "A Quest�o j� est� sendo utilizada no processo de Avalia��o."
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Deseja Consultar O Log?", "Deseja consultar o LOG?" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "E/ou", "e/ou" )
		#define STR0037 "Inv�lido(s)."
		#define STR0038 "Esta quest�o n�o pertence ao tipo de Avalia��o."
	#endif
#endif
