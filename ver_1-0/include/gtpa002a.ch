#ifdef SPANISH
	#define STR0001 "Veh�culos vs. L�nea"
	#define STR0002 "Es necesario completar el c�digo de la l�nea antes de efectuar el registro de Veh�culo vs. L�nea"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicles x Line"
		#define STR0002 "You must complete the line code before registering Vehicle x Line"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Ve�culos x Linha" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "� necess�rio preencher o c�digo da linha antes de efetuar o cadastro de Veiculo x Linha" )
	#endif
#endif
