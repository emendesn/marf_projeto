#ifdef SPANISH
	#define STR0001 "..::: include espec�fico uninove [ aluno ] :::.."
#else
	#ifdef ENGLISH
		#define STR0001 "..::: include espec�fico uninove [ aluno ] :::.."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "..::: inclui espec�fico uni. nove de Julho [ aluno ] :::..", "..::: include espec�fico uninove [ aluno ] :::.." )
	#endif
#endif
