#ifdef SPANISH
	#define STR0001 "Sucursal"
	#define STR0002 "Cree su vision"
	#define STR0003 "Confirmar"
	#define STR0004 "Opciones"
	#define STR0005 "Configuraciones"
	#define STR0006 "Configuraciones"
	#define STR0007 "Campos"
	#define STR0008 "Filtros"
	#define STR0009 "Nombre de la vision"
	#define STR0010 "Digite un nombre para su vision"
	#define STR0011 "Orden de los registros"
	#define STR0012 "Seleccione uno de los indices disponibles para su vision"
	#define STR0013 "Seleccion de campos"
	#define STR0014 "Campos disponibles para su vision"
	#define STR0015 "Campos que estan utilizandose actualmente"
	#define STR0016 "Nombre de la vision"
	#define STR0017 'El campo "Nombre de la vision" es obligatorio en este registro.'
	#define STR0018 "Es necesario agregar, por lo menos, un campo para su vision."
#else
	#ifdef ENGLISH
		#define STR0001 "Branch"
		#define STR0002 "Create your view"
		#define STR0003 "Confirm"
		#define STR0004 "Options"
		#define STR0005 "Configurations"
		#define STR0006 "Configurations"
		#define STR0007 "Fields"
		#define STR0008 "Filters"
		#define STR0009 "View Name"
		#define STR0010 "Enter a name for your view"
		#define STR0011 "Record Order"
		#define STR0012 "Select one of the available indexes for your view"
		#define STR0013 "Field Selection"
		#define STR0014 "Fields available for your view"
		#define STR0015 "Fields currently being used"
		#define STR0016 "View Name"
		#define STR0017 'View Name field is required in this register.'
		#define STR0018 "Add at least one field for your view."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Filial" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Crie sua vis�o" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Confirmar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Op��es" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Configura��es" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Configura��es" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Campos" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Filtros" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Nome da Vis�o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Digite um nome para sua vis�o" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Ordem dos registros" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Selecione um dos �ndices dispon�veis para sua vis�o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Sele��o de campos" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Campos dispon�veis para sua vis�o" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Campos sendo utilizados atualmente" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Nome da vis�o" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , 'O campo "Nome da vis�o" � obrigat�rio neste cadastro.' )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "� necess�rio adicionar, ao menos, um campo para sua vis�o." )
	#endif
#endif
