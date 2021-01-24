#ifdef SPANISH
	#define STR0001 "Matricula"
	#define STR0002 "Centro de Costo"
	#define STR0003 "Lista de vacac. vencidas en el mes"
	#define STR0004 "Se imprimira de acuerdo con los param. solicitados por el"
	#define STR0005 "usuario."
	#define STR0006 "A Rayas"
	#define STR0007 "Administrac."
	#define STR0008 "LISTA DE VACAC VENCIDAS EN EL MES"
	#define STR0009 "SUC. C. COSTO             MAT.   NOMBRE                         FCH BASE VACAC.  DIAS VAC VENCIDAS  DIAS FALTAS  VAC ANTICIPADAS"
	#define STR0010 "LISTA DE VACAC VENCIDAS EN EL MES"
	#define STR0011 " FECHA REFERENCIA: "
	#define STR0012 "Dias Faltas"
	#define STR0013 "Valor Descont"
	#define STR0014 "Emision del Informe de Vacac. Vencidas del mes"
#else
	#ifdef ENGLISH
		#define STR0001 "Registrat."
		#define STR0002 "Cost Center    "
		#define STR0003 "Report on vacations due in the Month "
		#define STR0004 "It will be printed according to parameters selected by the  "
		#define STR0005 "User.   "
		#define STR0006 "Z.form "
		#define STR0007 "Management   "
		#define STR0008 "REPORT ON VACATIONS DUE IN THE MONTH"
		#define STR0009 "BRC C. CENTER             REG.   NAME                           VACAT.BASE DATE  OVERDUE VAC. DAYS  ABSENC.DAYS  ANTICIP. VACAT."
		#define STR0010 "REPORT ON VACATIONS DUE IN MONTH "
		#define STR0011 "  REFERENCE DATE : "
		#define STR0012 "Absent Days"
		#define STR0013 "Amount Deduct."
		#define STR0014 "Generation of Report of Overdue Vacations in  "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo", "Matricula" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Centro De Custo", "Centro de Custo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Rela��o de F�rias Vencidas no M�s.", "Rela��o de F�rias Vencidas no Mes." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Sera impresso de acordo com os par�metro s solicitados pelo", "Ser� impresso de acordo com os parametros solicitados pelo" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "usu�rio." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administra��o" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "RELA��O DE F�RIAS VENCIDAS NO M�S", "RELA��O DE F�RIAS VENCIDAS NO MES" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Fil C. Custo              Reg.   Nome                           Dt. Base F�rias  Dias Fer.vencidas  Dias Faltas  Fer.antecipadas", "FIL C. CUSTO              MAT.   NOME                           DT. BASE FERIAS  DIAS FER.VENCIDAS  DIAS FALTAS  FER.ANTECIPADAS" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "RELACAO DE F�RIAS VENCIDAS NO M�S", "RELACAO DE FERIAS VENCIDAS NO MES" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "  DATA REFER�NCIA: ", "  DATA REFERENCIA: " )
		#define STR0012 "Dias Faltas"
		#define STR0013 "Valor Deduzido"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Emiss�o do relat�rio de f�rias vencidas no m�s", "Emissao do Relatorio de Ferias Vencidas no mes" )
	#endif
#endif
