#ifdef SPANISH
	#define STR0001 "Anular"
	#define STR0002 "Confirmar"
	#define STR0003 "Confirmar"
	#define STR0004 "Reescribir"
	#define STR0005 "Anular"
	#define STR0006 "Actualiz. de Comisiones"
	#define STR0007 "bUscar"
	#define STR0008 "Visualizar"
	#define STR0009 "Incluir"
	#define STR0010 "Modificar"
	#define STR0011 "Borrar"
	#define STR0012 "Comisiones"
	#define STR0013 "�Borra?"
	#define STR0014 "Comision no pagada"
	#define STR0015 "Comision pagada"
	#define STR0016 "Leyenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Quit    "
		#define STR0002 "OK      "
		#define STR0003 "OK      "
		#define STR0004 "Retype  "
		#define STR0005 "Quit    "
		#define STR0006 "Commissions Update"
		#define STR0007 "Search  "
		#define STR0008 "View    "
		#define STR0009 "Insert  "
		#define STR0010 "Edit    "
		#define STR0011 "Delete  "
		#define STR0012 "Commisions"
		#define STR0013 "About Deleting ?  "
		#define STR0014 "Commiss. not paid"
		#define STR0015 "Commission paid"
		#define STR0016 "Caption"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0002 "Confirma"
		#define STR0003 "Confirma"
		#define STR0004 "Redigita"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Actualiza��o das Comiss�es", "Atualiza��o das Comiss�es" )
		#define STR0007 "Pesquisar"
		#define STR0008 "Visualizar"
		#define STR0009 "Incluir"
		#define STR0010 "Alterar"
		#define STR0011 "Excluir"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Comiss�es", "Comiss�es" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Quanto � exclus�o?", "Quanto � exclus�o?" )
		#define STR0014 "Comiss�o n�o paga"
		#define STR0015 "Comiss�o paga"
		#define STR0016 "Legenda"
	#endif
#endif
