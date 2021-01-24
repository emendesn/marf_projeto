#ifdef SPANISH
	#define STR0001 "CORRESP. BANC."
	#define STR0002 "Atencion, No se pudieron grabar las informaciones financieras del Correspondiente Bancario, se grabara en modo de contingencia"
#else
	#ifdef ENGLISH
		#define STR0001 "CORRESP. BANK."
		#define STR0002 "Attention. Financial information on the Correspondent Bank could not be saved. It is saved in contingency mode."
	#else
		#define STR0001 "CORRESP. BANC."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Atenção, não foi possível gravar as infomações financeiras do Correspondente bancário,que será gravado em modo de contingência", "Atencao, Nao foi possivel gravar as infomacões financeiras do Correspondente Bancário, será gravado em modo de contingência" )
	#endif
#endif
