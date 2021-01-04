#ifdef SPANISH
	#define STR0001 "Registro de Contribucion Patronal"
	#define STR0002 "Empresa"
	#define STR0003 "Sucursal"
	#define STR0004 "Descripcion"
	#define STR0005 "Seleccion de Registros..."
	#define STR0006 "Visualizar"
	#define STR0007 "Incluir"
	#define STR0008 "Modificar"
	#define STR0009 "Borrar"
	#define STR0010 "Ya existe registro en archivo."
	#define STR0011 "No existe registro archivado."
	#define STR0012 "Aporte Sindical"
	#define STR0013 "Nombre de la Empresa"
	#define STR0014 "Registro en blanco"
	#define STR0015 "Mes en periodo incorrecto"
	#define STR0016 "Analice este registro, hay duplicidad."
	#define STR0017 "Cosultar"
	#define STR0018 "Sucursal no encontrada"
#else
	#ifdef ENGLISH
		#define STR0001 "Cadastro de Contribuição Patronal"
		#define STR0002 "Empresa"
		#define STR0003 "Filial"
		#define STR0004 "Descricao"
		#define STR0005 "Selecionando Registros..."
		#define STR0006 "Visualizar"
		#define STR0007 "Incluir"
		#define STR0008 "Alterar"
		#define STR0009 "Excluir"
		#define STR0010 "Já possui registro cadastrado."
		#define STR0011 "Não possui registro cadastrado."
		#define STR0012 "Contribuição Sindical"
		#define STR0013 "Nome da Empresa"
		#define STR0014 "Registro em branco"
		#define STR0015 "Mes no periodo incorreto."
		#define STR0016 "Analise este registro, duplicidade"
		#define STR0017 "Pesquisar"
		#define STR0018 "Filial não encontrada"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo De Contribuição Patronal", "Cadastro de Contribuição Patronal" )
		#define STR0002 "Empresa"
		#define STR0003 "Filial"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Descrição", "Descricao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0006 "Visualizar"
		#define STR0007 "Incluir"
		#define STR0008 "Alterar"
		#define STR0009 "Excluir"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Já possui registo registado.", "Já possui registro cadastrado." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Não possui registo registado.", "Não possui registro cadastrado." )
		#define STR0012 "Contribuição Sindical"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Nome Da Empresa", "Nome da Empresa" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Registo em branco", "Registro em branco" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Mês no período incorrecto.", "Mes no periodo incorreto." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Análise deste registo, duplicidade", "Analise este registro, duplicidade" )
		#define STR0017 "Pesquisar"
		#define STR0018 "Filial não encontrada"
	#endif
#endif
