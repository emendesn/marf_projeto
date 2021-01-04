#ifdef SPANISH
	#define STR0001 "Beneficiarios presentes a la campana"
	#define STR0002 "Regalos en la campana"
	#define STR0003 "Regalos de la campana"
	#define STR0004 "Lista de pacientes presentes a la campana"
	#define STR0005 "Grabar"
	#define STR0006 "No existe ningun regalo marcado"
	#define STR0007 "Brinde(s) incluído(s) com Sucesso!"
#else
	#ifdef ENGLISH
		#define STR0001 "Beneficiaries Campaign Gifts"
		#define STR0002 "Campaign Gifts"
		#define STR0003 "Campaign Gifts"
		#define STR0004 "Patient List Campaign Gifts"
		#define STR0005 "Save"
		#define STR0006 "There is no selected gifts"
		#define STR0007 "Gift(s) successfully added!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Beneficiarios Presentes na Campanha" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Brindes na Campanha" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Brindes da Campanha" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Lista de Pacientes Presentes na Campanha" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Gravar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Não existe nenhum Brinde Marcado" )
		#define STR0007 "Brinde(s) incluído(s) com Sucesso!"
	#endif
#endif
