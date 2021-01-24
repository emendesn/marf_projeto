#ifdef SPANISH
	#define STR0001 "Plan de Mantenimiento"
	#define STR0002 "Buscar"
	#define STR0003 "Expandir"
	#define STR0004 "Revertir"
	#define STR0005 "      Confirma la expansion del Plan de Mantenim. "
	#define STR0006 "íAviso!"
	#define STR0007 "      Confirma la reversion del Plan de Mantenim. "
	#define STR0008 "Visualizar"
	#define STR0009 "Revertir expansion"
	#define STR0010 "íNingun movimiento fue expandido!"
	#define STR0011 "íAtencion!"
	#define STR0012 "Automatico"
	#define STR0013 "    Este programa efectua la generacion automatica del plan de"
	#define STR0014 "mantenim. preventivo, de acuerdo con los parametros solicitados."
	#define STR0015 "Plan"
	#define STR0016 "Si"
	#define STR0017 "No"
#else
	#ifdef ENGLISH
		#define STR0001 "Movement Plan"
		#define STR0002 "Search"
		#define STR0003 "Expand"
		#define STR0004 "Reverse"
		#define STR0005 "      OK to expand the Maintenance Plan "
		#define STR0006 "Warning !"
		#define STR0007 "      OK to reverse the Maintenance Plan "
		#define STR0008 "View"
		#define STR0009 "Reverse expansion"
		#define STR0010 "No moviments has been expanded !"
		#define STR0011 "Attention !"
		#define STR0012 "Automatic"
		#define STR0013 "     This program generates automatically the preventive "
		#define STR0014 "maintenance plan, according to the selected parameters.  "
		#define STR0015 "Plan "
		#define STR0016 "Yes"
		#define STR0017 "No"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Plano De Manutenção", "Plano de Manutencao" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Expandir"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Estornar", "eStornar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "      cofacturairma a expansão do plano de manutenção ", "      Confirma a expansao do Plano de Manutencao " )
		#define STR0006 "Aviso !"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "      cofacturairma o estorno do plano de manutenção ", "      Confirma o estorno do Plano de Manutencao " )
		#define STR0008 "Visualizar"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Estornar expansão", "Estornar expansao" )
		#define STR0010 "Nenhum movimento foi expandido !"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Atenção !", "Atencao !" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Automático", "Automatico" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "     este programa efectua a geração automática dos planos de", "     Este programa efetua a geracao automatica dos planos de" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Manutenção preventiva, cofacturaorme os parâmetros solicitados.  ", "manutencao preventiva, conforme os parametros solicitados.  " )
		#define STR0015 "Plano "
		#define STR0016 "Sim"
		#define STR0017 "Não"
	#endif
#endif
