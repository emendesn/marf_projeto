#ifdef SPANISH
	#define STR0001 "Busca"
	#define STR0002 "Nueva busqueda"
	#define STR0003 "Cons.busqueda"
	#define STR0004 "Curriculos"
	#define STR0005 "Seleccione una busqueda"
	#define STR0006 "Busquedas:"
	#define STR0007 "Seleccione archivo "
	#define STR0008 "El archivo seleccionado no existe "
	#define STR0009 "Archivo esta siendo usado"
	#define STR0010 "Este archivo no pertenece a la busqueda"
	#define STR0011 "Escriba palabras que se buscaran"
	#define STR0012 "Campo: "
	#define STR0013 "Llene los campos de la busqueda: "
	#define STR0014 "Campos que se buscaran"
	#define STR0015 "Seleccione"
	#define STR0016 "De"
	#define STR0017 "A"
	#define STR0018 "No hay datos para esta consulta"
	#define STR0019 "Curriculos seleccionados"
	#define STR0020 "Archivo no grabado. Verifique el nombre del archivo."
	#define STR0021 "Este programa imprimira los curriculos seleccionados en la busqueda.,"
	#define STR0022 "A Rayas"
	#define STR0023 "Administracion"
	#define STR0024 "No hay ningun curriculo seleccionado"
	#define STR0025 "Continua......."
	#define STR0026 "Curriculo"
	#define STR0027 "Telefono"
	#define STR0028 "Nombre"
	#define STR0029 "Problema en la busqueda. Verifique el tipo de busqueda en el archivo ***"
	#define STR0030 "Sec."
	#define STR0031 "Seleccionando registros..."
	#define STR0032 "Programar..."
	#define STR0033 "Atencion"
	#define STR0034 "Esta busqueda no tiene ningun campo definido."
	#define STR0035 "El archivo "
	#define STR0036 " ya existe. ¿Desea sustituirlo?"
	#define STR0037 "SI"
	#define STR0038 "NO"
	#define STR0039 "Cupo Selec."
	#define STR0040 "Salir..."
	#define STR0041 "Efectuar Busqueda"
	#define STR0042 "Ficha Candidatos"
	#define STR0043 "Aviso"
	#define STR0044 "No fue seleccionado ningun Candidato. Marque los candidatos para impresion de la(s) Ficha(s)."
	#define STR0045 "Marca Todos"
	#define STR0046 "Invierte Seleccion"
	#define STR0047 "Lista Candidatos"
	#define STR0048 "Lista"
	#define STR0049 "Agendar"
	#define STR0050 "Ficha"
	#define STR0051 "Leyenda"
	#define STR0052 "Visualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "New Search"
		#define STR0003 "Cons.Search"
		#define STR0004 "Curriculum"
		#define STR0005 "Select a Search"
		#define STR0006 "Searches:"
		#define STR0007 "Select file"
		#define STR0008 "File selected not exists"
		#define STR0009 "File is in Use"
		#define STR0010 "File does not belong to the Search"
		#define STR0011 "Write words to be Searched"
		#define STR0012 "Field:"
		#define STR0013 "Fill the Search fields: "
		#define STR0014 "Fields to be searched"
		#define STR0015 "Select"
		#define STR0016 "From"
		#define STR0017 "To "
		#define STR0018 "No data for this Search"
		#define STR0019 "Curricula selected"
		#define STR0020 "File not recorded. Check the file name."
		#define STR0021 "This program will print the curricula selected during the Search."
		#define STR0022 "Z.Form"
		#define STR0023 "Management"
		#define STR0024 "There is no Curriculum selected"
		#define STR0025 "Continue..."
		#define STR0026 "Curriculum"
		#define STR0027 "Phone"
		#define STR0028 "Name"
		#define STR0029 "Search Error. Please check the Type of Search in File ***"
		#define STR0030 "Seq."
		#define STR0031 "Selecting Records..."
		#define STR0032 "Schedule Applicants"
		#define STR0033 "Attention"
		#define STR0034 "This search has no defined field."
		#define STR0035 "The file  "
		#define STR0036 " exists. Do you want to susbtitute it?"
		#define STR0037 "YES"
		#define STR0038 "NO "
		#define STR0039 "Selec. Vacancy"
		#define STR0040 "Exit..."
		#define STR0041 "Perform search  "
		#define STR0042 "Applicants card"
		#define STR0043 "Warning"
		#define STR0044 "No applicant selected. Please, check the applicants for printing the card(s).            "
		#define STR0045 "Check all  "
		#define STR0046 "Flip selection "
		#define STR0047 "List of Applicants"
		#define STR0048 "List   "
		#define STR0049 "Schedule"
		#define STR0050 "Card "
		#define STR0051 "Legend"
		#define STR0052 "View"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Nova Pesquisa"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Cons.pesquisa", "Cons.Pesquisa" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Currículos", "Curriculos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Seleccione uma pesquisa", "Selecione uma pesquisa" )
		#define STR0006 "Pesquisas:"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Seleccionar ficheiro ", "Selecione arquivo " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Não existe ficheiro seleccionado", "Nao existe arquivo selecionado" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Ficheiro a ser usado", "Arquivo esta sendo usado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Este ficheiro não pertence à pesquisa", "Este arquivo nao pertence a pesquisa" )
		#define STR0011 "Escreva palavras a serem pesquisadas"
		#define STR0012 "Campo: "
		#define STR0013 "Preencha os campos da pesquisa: "
		#define STR0014 "Campos a serem pesquisados"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecione" )
		#define STR0016 "De"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Até", "Ate" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Não há dados para esta consulta", "Nao ha dados para esta consulta" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Currículos seleccionados", "Curriculos selecionados" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Ficheiro não gravado. verificar o nome do ficheiro.", "Arquivo nao gravado. Verifique o nome do arquivo." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Este programa irá imprimir os currículos seleccionados na pesquisa.,", "Este programa ira imprimir os curriculos selecionados na pesquisa.," )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Não existe currículo seleccionado", "Nao existe curriculo selecionado" )
		#define STR0025 "Continua......."
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Currículo", "Curriculo" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Telefone", "Fone" )
		#define STR0028 "Nome"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Problema na pesquisa. verifique o tipo da pesquisa no registo ***", "Problema na pesquisa. Verifique o Tipo da Pesquisa no cadastro ***" )
		#define STR0030 "Seq."
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0032 "Agendar Candidatos"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Esta pesquisa não tem nenhum campo definido.", "Esta pesquisa nao tem nenhum campo definido." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "O ficheiro ", "O arquivo " )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", " já existe. deseja substituí-lo ?", " ja existe. Deseja substitui-lo ?" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Sim", "SIM" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Não", "NAO" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Vaga selecc.", "Vaga Selec." )
		#define STR0040 "Sair"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Efectuar Pesquisa", "Efetuar Pesquisa" )
		#define STR0042 "Ficha Candidatos"
		#define STR0043 "Aviso"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Não Foi Seleccionado Nenhum Candidato. Marque Os Candidatos Para Impressão Da(s) Ficha(s).", "Nao foi selecionado nenhum Candidato. Marque os candidatos para impressao da(s) Ficha(s)." )
		#define STR0045 "Marca Todos"
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Inverter Selecção", "Inverte Seleção" )
		#define STR0047 "Relação Candidatos"
		#define STR0048 "Relação"
		#define STR0049 "Agendar"
		#define STR0050 "Ficha"
		#define STR0051 "Legenda"
		#define STR0052 "Visualizar"
	#endif
#endif
