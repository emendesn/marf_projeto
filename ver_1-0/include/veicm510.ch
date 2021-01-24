#ifdef SPANISH
	#define STR0001 "Registra Abordaje"
	#define STR0002 "Buscar"
	#define STR0003 "Registra"
	#define STR0004 "Registra enfoque"
	#define STR0005 "�Desea Modificar ?"
	#define STR0006 "�Atencion!"
	#define STR0007 "Abordaje ya registrado"
	#define STR0008 "Solamente el Vendedor "
	#define STR0009 " podra modificar este enfoque."
	#define STR0010 "�Historial de la OCURRENCIA no puede modificarse!"
	#define STR0011 "Actualizado:"
	#define STR0012 "Leyenda"
	#define STR0013 "Visita/Abordaje ya ejecutada"
	#define STR0014 "Visita/Abordaje no ejecutada"
	#define STR0015 "Tipo de Agenda no permitida para este producto. Disponibles las Agendas: "
	#define STR0016 "�Usuario sin autorizacion para visualizar otro vendedor!"
	#define STR0017 "Usuario sin permiso para agendar para el Vendedor."
	#define STR0018 "Usuario sin permiso para agendar para el Vendedor del proximo contacto."
	#define STR0019 "Vendedor no vinculado como Vendedor de servicios en el Archivo de datos adicionales del cliente CEV."
	#define STR0020 "Vendedor no vinculado como Vendedor de piezas en el archivo de datos adicionales del cliente CEV."
	#define STR0021 "Vendedor no vinculado como Vendedor de vehiculos en el archivo de datos adicionales del cliente CEV."
	#define STR0022 "Tipo de agenda no encontrada en el archivo de tipos de agenda."
	#define STR0023 "Cliente no encontrado en el archivo de datos adicionales del cliente CEV."
	#define STR0024 "Cliente:"
	#define STR0025 "Vendedor:"
	#define STR0026 "Tipo de agenda:"
	#define STR0027 "�Usuario sin permiso para digitar el registro de Visita/Abordaje en la fecha de hoy!"
	#define STR0028 "Database maxima permitida para digitacion"
	#define STR0029 "Filtro"
	#define STR0030 "Texto"
	#define STR0031 "No hay registro para este filtro."
	#define STR0032 "Limpia filtro"
	#define STR0033 "Cliente"
	#define STR0034 "Tienda"
	#define STR0035 "Vendedor"
	#define STR0036 "�Desea incluir Oportunidad de negocios para el cliente?"
	#define STR0037 "Base conocimiento"
#else
	#ifdef ENGLISH
		#define STR0001 "Register Boarding"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Register"
		#define STR0005 "Modify"
		#define STR0006 "Note!!!"
		#define STR0007 "Approaching registered  !"
		#define STR0008 "Only the salesman "
		#define STR0009 "may change this Approach."
		#define STR0010 "OCCURENCE log cannot be modified!             "
		#define STR0011 "Updated:"
		#define STR0012 "Caption"
		#define STR0013 "Visit/Approach already done"
		#define STR0014 "Visit/Approach not done"
		#define STR0015 "Schedule Type not allowed to this Sales Representative!!! Available in Schedules: "
		#define STR0016 "User not allowed to access another Sales Representative!!!"
		#define STR0017 "User not allowed to schedule for Sales Representative."
		#define STR0018 "User not allowed to schedule for Sales Representative of next contact."
		#define STR0019 "Sales Representative not related as Service Sales Representative in File of Additional Data of CEV Client."
		#define STR0020 "Sales Representative not related as Parts Sales Representative in File of Additional Data of CEV Client."
		#define STR0021 "Sales Representative not related as Vehicle Sales Representative in File of Additional Data of CEV Client."
		#define STR0022 "Type of Schedule not found in Schedule Types File."
		#define STR0023 "Client not found in File of Additional Data of CEV Client."
		#define STR0024 "Customer:"
		#define STR0025 "Sales representative:"
		#define STR0026 "Type of Schedule:"
		#define STR0027 "User without permission to enter the record of Visit/Approach today!"
		#define STR0028 "Maximum base date allowed for typing"
		#define STR0029 "Filter"
		#define STR0030 "Text"
		#define STR0031 "There is no record for this filter."
		#define STR0032 "Clean Filter"
		#define STR0033 "Customer"
		#define STR0034 "Store"
		#define STR0035 "Sales Representative"
		#define STR0036 "Want to add business opportunity for the customer?"
		#define STR0037 "Knowledge Bnk"
	#else
		#define STR0001 "Registra Abordagem"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Registar", "Registra" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Deseja alterar ?", "Deseja Alterar ?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Aten��o!!!", "Atencao!!!" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abordagem j� registada !", "Abordagem ja Cadastrada !" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Somente o vendedor ", "Somente o Vendedor " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " Poder� Alterar Esta Abordagem.", " podera alterar esta Abordagem." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Historico da ocorrencia n�o pode ser alterado!", "Historico da OCORRENCIA nao pode ser alterado!" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Actualizado:", "Atualizado:" )
		#define STR0012 "Legenda"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Visita/abordagem j� executada", "Visita/Abordagem ja executada" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Visita/abordagem n�o executada", "Visita/Abordagem nao executada" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Tipo de agenda n�o permitida para este vendedor. Dispon�veis as agendas: ", "Tipo de Agenda n�o permitida para este Vendedor !!! Dispon�veis as Agendas: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para acessar outro vendedor.", "Usu�rio sem permiss�o para acessar outro Vendedor !!!" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para agendar para o vendedor.", "Usu�rio sem permiss�o para agendar para o Vendedor." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para agendar para o vendedor do pr�ximo contacto.", "Usu�rio sem permiss�o para agendar para o Vendedor do pr�ximo contato." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Vendedor n�o relacionado como vendedor de servi�os no Registo de Dados Adicionais do Cliente CEV.", "Vendedor n�o relacionado como Vendedor de Servi�os no Cadastro de Dados Adicionais do Cliente CEV." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Vendedor n�o relacionado como vendedor de pe�as no Registo de Dados Adicionais do Cliente CEV.", "Vendedor n�o relacionado como Vendedor de Pe�as no Cadastro de Dados Adicionais do Cliente CEV." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Vendedor n�o relacionado como vendedor de ve�culos no Registo de Dados Adicionais do Cliente CEV.", "Vendedor n�o relacionado como Vendedor de Veiculos no Cadastro de Dados Adicionais do Cliente CEV." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Tipo de agenda n�o encontrada no Registo de Tipos de Agenda.", "Tipo de Agenda n�o encontrada no Cadastro de Tipos de Agenda." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Cliente n�o encontrado no Registo de Dados Adicionais do Cliente CEV.", "Cliente n�o encontrado no Cadastro de Dados Adicionais do Cliente CEV." )
		#define STR0024 "Cliente:"
		#define STR0025 "Vendedor:"
		#define STR0026 "Tipo de Agenda:"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para digitar o registo de Visita/Abordagem na data de hoje.", "Usu�rio sem permiss�o para digitar o registro de Visita/Abordagem na data de hoje!" )
		#define STR0028 "Database m�xima permitida para digita��o"
		#define STR0029 "Filtro"
		#define STR0030 "Texto"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "N�o h� registo para este filtro.", "N�o h� registro para este filtro." )
		#define STR0032 "Limpa Filtro"
		#define STR0033 "Cliente"
		#define STR0034 "Loja"
		#define STR0035 "Vendedor"
		#define STR0036 "Deseja incluir Oportunidade de Neg�cios para o Cliente?"
		#define STR0037 "Bco Conhecimento"
	#endif
#endif
