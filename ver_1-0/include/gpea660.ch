#ifdef SPANISH
	#define STR0001 "Localidad de Pago"
	#define STR0002 "Verifique el parametro MV_MODFOL"
	#define STR0003 "Este registro no se puede borrar pues esta en uso en el Archivo de Empleados"
#else
	#ifdef ENGLISH
		#define STR0001 "Payment Location"
		#define STR0002 "Check parameter MV_MODFOL!"
		#define STR0003 "This register cannot be deleted, because it is in use in Employees register"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Localidade De Pagamento", "Localidade de Pagamento" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Verifique o par�metro MV_MODFOL.", "Verifique o parametro MV_MODFOL!" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Este registo n�o pode ser exclu�do, pois est� em uso no registo de Colaboradores", "Este registro n�o pode ser exclu�do, pois est� em uso no cadastro de Funcion�rios" )
	#endif
#endif
