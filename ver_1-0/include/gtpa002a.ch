#ifdef SPANISH
	#define STR0001 "Vehículos vs. Línea"
	#define STR0002 "Es necesario completar el código de la línea antes de efectuar el registro de Vehículo vs. Línea"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicles x Line"
		#define STR0002 "You must complete the line code before registering Vehicle x Line"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Veículos x Linha" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "É necessário preencher o código da linha antes de efetuar o cadastro de Veiculo x Linha" )
	#endif
#endif
