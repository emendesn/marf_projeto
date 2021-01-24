#ifdef SPANISH
	#define STR0001 "Archivo de respuesta de campana"
	#define STR0002 "Archivo de respuesta de campana"
	#define STR0003 "1=Abierto"
	#define STR0004 "2=En ejecucion"
	#define STR0005 "6=Descalificado"
	#define STR0006 "4=Contacto"
	#define STR0007 "1=Cliente"
	#define STR0008 "3=Prospect"
	#define STR0009 "2=Suspect"
	#define STR0010 "4=Contacto"
	#define STR0011 "Buscar"
	#define STR0012 "Visualizar"
	#define STR0013 "Incluir"
	#define STR0014 "Modificar"
	#define STR0015 "Borrar"
	#define STR0016 "Copiar"
	#define STR0017 "Convertir respuesta de campana"
	#define STR0018 "Privilegios"
	#define STR0019 "Incluir"
	#define STR0020 "Esta respuesta de campana no puede modificarse porque esta inactiva."
	#define STR0021 "Modificar"
	#define STR0022 "Convertir en Prospect"
	#define STR0023 "Convertir en Suspect"
	#define STR0024 "Crear una oportunidad"
	#define STR0025 "Descalificar"
	#define STR0026 "Esta respuesta de campana no puede convertirse porque esta inactiva."
	#define STR0027 "Convertir respuesta de campana"
	#define STR0028 "Convertir en Suspect"
	#define STR0029 "Convertir en Prospect"
	#define STR0030 "Crear una oportunidad"
	#define STR0031 "Entidad"
	#define STR0032 "Codigo de la Entidad"
	#define STR0033 "Descalificar"
	#define STR0034 "Descripcion de descalificacion"
	#define STR0035 "Seleccione solamente un tipo de conversion."
	#define STR0036 "Provea una descripcion para la descalificacion."
	#define STR0037 "Modificar"
	#define STR0038 "Incluir"
	#define STR0039 "No se pudo ejecutar la conversion, el RCPJ del Suspect ya existe en el archivo de Prospect."
	#define STR0040 "No se pudo ejecutar la conversion, el RCPJ del Suspect ya existe en el archivo de clientes."
	#define STR0041 "Incluir"
	#define STR0042 "Provea una descripcion para la descalificacion."
	#define STR0043 "Filtro del CRM"
	#define STR0044 "Filtro de la campana"
	#define STR0045 "Para la inclusion de Respuestas de Campana son validas solamente las opciones 1=Abierto, 2=En Ejecucion y 6=Descalificado del campo Estatus."
	#define STR0046 "Estatus de respuesta de campanas"
	#define STR0047 "Total de registros"
	#define STR0048 "Nueva actividad"
	#define STR0049 "Todas las actividades"
	#define STR0050 "Nueva anotacion"
	#define STR0051 "Todas las anotaciones"
	#define STR0052 "Relacionadas"
#else
	#ifdef ENGLISH
		#define STR0001 "Registration of Campaign Answer"
		#define STR0002 "Registration of Campaign Answer"
		#define STR0003 "1=Pending"
		#define STR0004 "2=In Progress"
		#define STR0005 "6=Not qualified"
		#define STR0006 "4=Contact"
		#define STR0007 "1=Customer"
		#define STR0008 "3=Prospect"
		#define STR0009 "2=Suspect"
		#define STR0010 "4=Contact"
		#define STR0011 "Search"
		#define STR0012 "View"
		#define STR0013 "Add"
		#define STR0014 "Edit"
		#define STR0015 "Delete"
		#define STR0016 "Copy"
		#define STR0017 "Convert Campaign Answers"
		#define STR0018 "Privileges"
		#define STR0019 "Add"
		#define STR0020 "This Campaign Answer cannot be edited as it is inactive."
		#define STR0021 "Edit"
		#define STR0022 "Convert in Prospect"
		#define STR0023 "Convert in Suspect"
		#define STR0024 "Create an opportunity"
		#define STR0025 "Do not qualify"
		#define STR0026 "This Campaign Answer cannot be converted as it is inactive."
		#define STR0027 "Convert Campaign Answers"
		#define STR0028 "Convert in Suspect"
		#define STR0029 "Convert in Prospect"
		#define STR0030 "Create an opportunity"
		#define STR0031 "Entity"
		#define STR0032 "Entity code"
		#define STR0033 "Do not qualify"
		#define STR0034 "Not qualification Description"
		#define STR0035 "Select a type of conversion only."
		#define STR0036 "Add a description for the disqualification."
		#define STR0037 "Edit"
		#define STR0038 "Add"
		#define STR0039 "You cannot run the conversion, as the CNPJ of the Suspect already exists in the Prospect register."
		#define STR0040 "You cannot run the conversion, as the CNPJ of the Suspect already exists in the Customer register."
		#define STR0041 "Add"
		#define STR0042 "Add a description for the disqualification."
		#define STR0043 "CRM Filter"
		#define STR0044 "Campaign Filter"
		#define STR0045 "For Campaign Answers addition, only the following options are valid: 1=Pending, 2=In Progress, 3=Not qualified for field Status."
		#define STR0046 "Campaign Answer Status"
		#define STR0047 "Total of Records"
		#define STR0048 "New Activity"
		#define STR0049 "All Companies"
		#define STR0050 "New Annotation"
		#define STR0051 "All Annotations"
		#define STR0052 "Related"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Resposta de Campanha" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Resposta de Campanha" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "1=Aberto" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "2=Em Andamento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "6=Desqualificado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "4=Contato" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "1=Cliente" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "3=Prospect" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "2=Suspect" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "4=Contato" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Copiar" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Converter Resposta de Campanha" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Privilégios" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Esta Resposta de Campanha não pode ser alterada pois está inativa." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Converter em Prospect" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Converter em Suspect" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Criar uma Oportunidade" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Desqualificar" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Esta Resposta de Campanha não pode ser convertida pois está inativa." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Converter Resposta de Campanha" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Converter em Suspect" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Converter em Prospect" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Criar uma Oportunidade" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Entidade" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Código da Entidade" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Desqualificar" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Descrição de desqualificação" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Selecione somente um tipo de conversão." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Forneça uma descrição para a desqualificação." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Não foi possível executar a conversão, o CNPJ do Suspect já existe no cadastro de Prospect." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Não foi possível executar a conversão, o CNPJ do Suspect já existe no cadastro de Clientes." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Forneça uma descrição para a desqualificação." )
		#define STR0043 "Filtro do CRM"
		#define STR0044 "Filtro da Campanha"
		#define STR0045 "Para a inclusão de Respostas de Campanha são válidas somente as opções 1=Aberto, 2=Em Andamento e 6=Desqualificado do campo Status."
		#define STR0046 "Status de Resposta de Campanhas"
		#define STR0047 "Total de Registros"
		#define STR0048 "Nova Atividade"
		#define STR0049 "Todas as Atividades"
		#define STR0050 "Nova Anotação"
		#define STR0051 "Todas as Anotação"
		#define STR0052 "Relacionadas"
	#endif
#endif
