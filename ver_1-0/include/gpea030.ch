#ifdef SPANISH
	#define STR0001 "Confirma"
	#define STR0002 "Redigita"
	#define STR0003 "Sale"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Archivo de Funciones"
	#define STR0010 "Sale"
	#define STR0012 "¿En relacion con la eliminacion?"
	#define STR0013 "Copiar"
	#define STR0014 "El Sueldo debe ser mayor o igual al Sueldo Minimo del Codigo MTSS"
	#define STR0015 "El intercambio de la tabla de Cargos (SQ3) debera ser igual o poseer menor cantidad de intercambio exclusivo (Sucursal/Unidad/Empresa) que la tabla de funciones (SRJ). Ej: Si la tabla de funciones (SRJ) esta con C E E, la SQ3 no podra ser E E E."
	#define STR0016 "Modifique el modo de acceso a traves del Configurador. Archivos SRJ y SQ3."
#else
	#ifdef ENGLISH
		#define STR0001 "Confirm"
		#define STR0002 "Reenter"
		#define STR0003 "Quit"
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Roles File"
		#define STR0010 "Quit"
		#define STR0012 "Concerning deletion?"
		#define STR0013 "Copy"
		#define STR0014 "Salary must be greater of equal to Minimum Salary of MTSS Code"
		#define STR0015 "The Positions table sharing (SQ3) must be equal to or have smaller quantity of Exclusive sharing (Branch/Unit/Company) that the Roles table (SRJ). Ex: If the Roles table (SRJ) has C E E, the SQ3 cannot be E E E."
		#define STR0016 "Edit the access mode through the Configurator. Files SRJ and SQ3."
	#else
		#define STR0001 "Confirma"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Digita novamente.", "Redigita" )
		#define STR0003 "Abandona"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Registo de Funções", "Cadastro de Funções" )
		#define STR0010 "Abandona"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Quanto à exclusão?", "Quanto à exclusäo?" )
		#define STR0013 "Copiar"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "O salário deve ser maior ou igual ao salário mínimo do Código MTSS", "O Salário deve ser maior ou igual ao Salário Mínimo do Código MTSS" )
		#define STR0015 "O compartilhamento da tabela de Cargos (SQ3) deverá ser igual ou possuir menor quantidade de compartilhamento Exclusivo (Filial/Unidade/Empresa) que a tabela de Funções (SRJ). Ex: Se a tabela de Funções (SRJ) estiver com C E E, a SQ3 não poderá ser E E E."
		#define STR0016 "Altere o modo de acesso atraves do Configurador. Arquivos SRJ e SQ3."
	#endif
#endif
