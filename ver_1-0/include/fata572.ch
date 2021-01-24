#ifdef SPANISH
	#define STR0001 "Actualizacion de Tipo de Regla de Alternancia"
	#define STR0003 "Buscar"
	#define STR0004 "Visualizar"
	#define STR0005 "Incluir"
	#define STR0006 "Modificar"
	#define STR0007 "Borrar"
	#define STR0008 "Mantenimiento "
	#define STR0009 "Campos del Sistema"
	#define STR0010 "Campo"
	#define STR0011 "Descripcion"
	#define STR0012 "X3_DESCRIC"
	#define STR0013 "Prioridad"
	#define STR0014 "Solicite al administrador que ejecute el update 'U_UpdRODZ' antes de ejecutar esta rutina"
	#define STR0015 "Prioridad"
	#define STR0016 "Atencion"
	#define STR0017 "Este tipo de regla se esta utilizando por una tabla - Reglas de Alternancia y no podra borrarse."
#else
	#ifdef ENGLISH
		#define STR0001 "Update of Rotation Rule Type"
		#define STR0003 "Search"
		#define STR0004 "View"
		#define STR0005 "Add"
		#define STR0006 "Edit"
		#define STR0007 "Delete"
		#define STR0008 "Maintenance"
		#define STR0009 "System Fields"
		#define STR0010 "Field"
		#define STR0011 "Description"
		#define STR0012 "X3_DESCRIC"
		#define STR0013 "Priority"
		#define STR0014 "Ask administrator to run update 'U_UpdRODZ' before running this routine"
		#define STR0015 "Priority"
		#define STR0016 "Attention"
		#define STR0017 "This rule type is being used by a table - Rotation Rules and cannot be deleted."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Actualiza��o de tipo de regra de rod�zio", "Atualiza��o de Tipo de Regra de Rod�zio" )
		#define STR0003 "Pesquisar"
		#define STR0004 "Visualizar"
		#define STR0005 "Incluir"
		#define STR0006 "Alterar"
		#define STR0007 "Excluir"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Manuten��o ", "Manutencao " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Campos do sistema", "Campos do Sistema" )
		#define STR0010 "Campo"
		#define STR0011 "Descri��o"
		#define STR0012 "X3_DESCRIC"
		#define STR0013 "Prioridade"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Solicite ao administrador que execute o update U_TkUpdADJ antes de acessar esta rotina.", "Solicite ao administrador que execute o update 'U_UpdRODZ' antes de executar esta rotina" )
		#define STR0015 "Prioridade"
		#define STR0016 "Aten��o"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Este tipo de regra est� a ser utilizado por uma tabela - Regras de rod�zio, e n�o poder� ser eliminado.", "Este tipo de regra esta sendo utilizado por uma tabela - Regras de Rod�zio e nao podera ser excluido." )
	#endif
#endif
