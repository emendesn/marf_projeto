#ifdef SPANISH
	#define STR0001 "BUSCAR"
	#define STR0002 "VISUALIZAR"
	#define STR0003 "INCLUIR"
	#define STR0004 "MODIFICAR"
	#define STR0005 "BORRAR"
	#define STR0006 "Actualizacion de regla de seleccion"
	#define STR0007 "Reordenar"
	#define STR0008 "Reordenando reglas de seleccion"
	#define STR0009 "Leyendo reglas..."
	#define STR0010 "Grabando reglas..."
	#define STR0011 "�Desea implantar la Telecobranza utilizando las listas de cobranza?"
	#define STR0012 "REGLA PARA LISTAS DE COBRANZA"
#else
	#ifdef ENGLISH
		#define STR0001 "SEARCH"
		#define STR0002 "VIEW"
		#define STR0003 "ADD"
		#define STR0004 "EDIT"
		#define STR0005 "DELETE"
		#define STR0006 "Selection Rule Update"
		#define STR0007 "Sort again"
		#define STR0008 "Sorting selection rules again"
		#define STR0009 "Reading Rules..."
		#define STR0010 "Saving Rules..."
		#define STR0011 "Do you want to deploy Telecollection through the use of collection list ?"
		#define STR0012 "RULE FOR COLLECTION LISTS "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Pesquisar", "PESQUISAR" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Visualizar", "VISUALIZAR" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Incluir", "INCLUIR" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Alterar", "ALTERAR" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Excluir", "EXCLUIR" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Actualiza��o Da Regra De Selec��o", "Atualiza��o de Regra de Sele��o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Re-ordenar", "Reordenar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A Re-ordenar Regras De Selec��o", "Reordenando Regras de Selec�o" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A Ler Regras...", "Lendo Regras..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A Gravar Regras...", "Gravando Regras..." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Deseja implantar a telecobran�a, utilizando as listas de cobran�a ?", "Deseja implantar a Telecobranca utilizando as Listas de Cobranca ?" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Regra Para Listas De Cobran�as", "REGRA PARA LISTAS DE COBRAN�AS" )
	#endif
#endif
