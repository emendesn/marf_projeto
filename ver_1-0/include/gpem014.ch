#ifdef SPANISH
	#define STR0001 "Calculo de Vale Restaurante"
	#define STR0002 "Este programa calcula el vale restaurante."
	#define STR0003 "Se calculara de acuerdo con los parametros seleccionados por el usuario."
	#define STR0004 "Inicio del procesamiento"
	#define STR0005 "Hubo inconsistencias durante el proceso de calculo del beneficio. "
	#define STR0006 "Atencion"
	#define STR0007 "Log de Ocurrencias - Vale Restaurante"
	#define STR0008 "Termino del procesamiento"
	#define STR0009 "Calculando el Beneficio: "
	#define STR0010 "Suc Matric Mes  Ano Turno Semana Descripcion "
	#define STR0011 "No existen valores en el calendario de la planilla de pago referente a los dias de Vale Restaurante"
	#define STR0012 "No existen valores en el calendario de la planilla de pago referente a los dias de Vale Alimentacion"
	#define STR0013 "Calculo de Vale Alimentacion"
	#define STR0014 "Este programa calcula el Vale Alimentacion"
	#define STR0015 "Log de Ocurrencias - Vale Alimentacion"
	#define STR0016 "Para continuar, Ejecute el RHUPDMOD, opcion 236 - Modificacion en el tamano del campo RG2_PERC"
	#define STR0017 "Empleado con licencia"
#else
	#ifdef ENGLISH
		#define STR0001 "Meal Voucher Calculation"
		#define STR0002 "This program calculates the meal voucher."
		#define STR0003 "It is calculated according to parameters selected by user."
		#define STR0004 "Beginning of processing"
		#define STR0005 "Inconsistencies occurred during benefit calculation process. "
		#define STR0006 "Attention"
		#define STR0007 "Occurrence Log - Meal Voucher"
		#define STR0008 "End of Processing"
		#define STR0009 "Calculating the benefit: "
		#define STR0010 "Bra Regist Month Year Shift Week Description "
		#define STR0011 "There are no values in payroll calendar regarding the Meal Voucher days"
		#define STR0012 "There are no values in payroll calendar regarding the Food Voucher days"
		#define STR0013 " Food Voucher Calculation"
		#define STR0014 "This program calculates the Food Voucher"
		#define STR0015 "Occurrence Log - Food Voucher"
		#define STR0016 "To continue, Run RHUPDMOD, option 236 - Change in the field RG2_PERC size"
		#define STR0017 "Employee On Leave"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "C�lculo de ticket refei��o", "C�lculo de Vale Refei��o" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa calcula o ticket refei��o.", "Este programa calcula o vale refei��o." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Ser� calculado de acordo com os par�metros seleccionados pelo utilizador.", "Ser� calculado de acordo com os par�metros selecionados pelo usu�rio." )
		#define STR0004 "In�cio do processamento"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Ocorreram inconsist�ncias durante o processo de c�lculo do benef�cio. ", "Ocorreram Inconsist�ncias durante o processo de calculo do benef�cio. " )
		#define STR0006 "Aten��o"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Log de ocorr�ncias - Ticket refei��o", "Log de Ocorr�ncias - Vale Refei��o" )
		#define STR0008 "T�rmino do processamento"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A calcular o benef�cio: ", "Calculando o Benef�cio: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Fil Matric M�s  Ano Turno Semana Descri��o ", "Fil Matric Mes  Ano Turno Semana Descri��o " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o existem valores no calend�rio da folha de pagamento referente aos dias de ticket refei��o", "N�o existem valores no calend�rio da folha de pagamento referente aos dias de Vale Refei��o" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "N�o existem valores no calend�rio da folha de pagamento referentes aos dias de ticket alimenta��o", "N�o existem valores no calend�rio da folha de pagamento referente aos dias de Vale Alimenta��o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "C�lculo de ticket alimenta��o", "C�lculo de Vale Alimenta��o" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Este programa calcula o ticket alimenta��o", "Este programa calcula o Vale Alimenta��o" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Log de ocorr�ncias - Ticket alimenta��o", "Log de Ocorr�ncias - Vale Alimenta��o" )
		#define STR0016 "Para continuar, Execute o RHUPDMOD, op��o 236 - Altera��o no tamanho do campo RG2_PERC"
		#define STR0017 "Funcion�rio Afastado"
	#endif
#endif
