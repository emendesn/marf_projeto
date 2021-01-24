#ifdef SPANISH
	#define STR0001 "Finaliza PDP"
	#define STR0002 "Este programa tiene la finalidad de finalizar planes de desarrollo"
	#define STR0003 "com periodos fuera del plazo"
	#define STR0004 "Plan(es) seleccionado(s) debidamente finalizado(s)"
	#define STR0005 "No existe ningun plan pendiente para este periodo"
	#define STR0006 "Operacion no permitida. Verifique el parametro MV_APDBLOQ"
	#define STR0007 "Parametros"
#else
	#ifdef ENGLISH
		#define STR0001 "Conclude PDP"
		#define STR0002 "The aim of this program is to conclude development plans"
		#define STR0003 "not following the deadline periods."
		#define STR0004 "Selected plan(s) already concluded."
		#define STR0005 "No pending plan for this period."
		#define STR0006 "This operation is not allowed. Check parameter MV_APDBLOQ."
		#define STR0007 "Parameters"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Finaliza Pdp", "Finaliza PDP" )
		#define STR0002 "Este programa tem a finalidade de finalizar planos de desenvolvimento"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Com período s fora do prazo", "com períodos fora do prazo" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Plano(s) seleccionado(s) devidamente finalizado(s)", "Plano(s) selecionado(s) devidamente finalizado(s)" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Não existe nenhum plano pendente para esse perido", "Não existe nenhum plano pendente para esse perído" )
		#define STR0006 "Operação não permitida. Verifique parâmetro MV_APDBLOQ"
		#define STR0007 "Parâmetros"
	#endif
#endif
