#ifdef SPANISH
	#define STR0001 "CORRESP. BANC."
	#define STR0002 "Atencion, No se pudieron grabar las informaciones financieras del Correspondiente Bancario, se grabara en modo de contingencia"
#else
	#ifdef ENGLISH
		#define STR0001 "CORRESP. BANK."
		#define STR0002 "Attention. Financial information on the Correspondent Bank could not be saved. It is saved in contingency mode."
	#else
		#define STR0001 "CORRESP. BANC."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Aten��o, n�o foi poss�vel gravar as infoma��es financeiras do Correspondente banc�rio,que ser� gravado em modo de conting�ncia", "Atencao, Nao foi possivel gravar as infomac�es financeiras do Correspondente Banc�rio, ser� gravado em modo de conting�ncia" )
	#endif
#endif
