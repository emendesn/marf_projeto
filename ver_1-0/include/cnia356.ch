#ifdef SPANISH
	#define STR0001 "Archivo de C.Contable"
	#define STR0002 "Este programa bloquea / desbloquea datos en masa"
	#define STR0003 "No hay datos para presentar. Verifique los parametros."
	#define STR0004 "�Confirma bloqueo de las cuentas seleccionadas?"
	#define STR0005 "�Confirma desbloqueo de las cuentas seleccionadas?"
	#define STR0006 "Desbloqueada"
	#define STR0007 "Bloqueada"
	#define STR0008 "Estatus de los Registros"
	#define STR0009 "De C.Contable"
	#define STR0010 "A C.Contable"
	#define STR0011 "Informe la Cuenta Contable Inicial."
	#define STR0012 "Informe la Cuenta Contable final."
	#define STR0013 "Fecha p/ Bloqueo"
	#define STR0014 "Fecha para el Bloqueo > que a Fecha del dia."
	#define STR0015 "Fecha para el Bloqueo invalida y/o no completa."
#else
	#ifdef ENGLISH
		#define STR0001 "Cadastro de C.Contabil"
		#define STR0002 "Este programa bloqueia / desbloqueia dados em massa"
		#define STR0003 "N�o h� dados para apresentar. Verifique os par�metros."
		#define STR0004 "Confirma bloqueio das contas selecionadas?"
		#define STR0005 "Confirma desbloqueio das contas selecionadas?"
		#define STR0006 "Desbloqueada"
		#define STR0007 "Bloqueada"
		#define STR0008 "Status dos Registros"
		#define STR0009 "C.Contabil de"
		#define STR0010 "C.Contabil ate"
		#define STR0011 "Informe a Conta Contabil incial."
		#define STR0012 "Informe a Conta Contabil final."
		#define STR0013 "Data p/ Bloqueio"
		#define STR0014 "Data para o Bloqueio > que a Data do dia."
		#define STR0015 "Data para o Bloqueio inv�lida e/ou n�o preenchida."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de C.Contabil�stico", "Cadastro de C.Contabil" )
		#define STR0002 "Este programa bloqueia / desbloqueia dados em massa"
		#define STR0003 "N�o h� dados para apresentar. Verifique os par�metros."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Confirma bloqueio das contas seleccionadas?", "Confirma bloqueio das contas selecionadas?" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Confirma desbloqueio das contas seleccionadas?", "Confirma desbloqueio das contas selecionadas?" )
		#define STR0006 "Desbloqueada"
		#define STR0007 "Bloqueada"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Estado dos Registos", "Status dos Registros" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "De C.Contabil�stica", "C.Contabil de" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "At� C.Contabil�stica", "C.Contabil ate" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Informe a conta contabil�stica inicial.", "Informe a Conta Contabil incial." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Informe a conta contabil�stica final.", "Informe a Conta Contabil final." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Data p/ bloqueio", "Data p/ Bloqueio" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Data para o Bloqueio > que a data do dia.", "Data para o Bloqueio > que a Data do dia." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Data para o bloqueio inv�lida e/ou n�o preenchida.", "Data para o Bloqueio inv�lida e/ou n�o preenchida." )
	#endif
#endif
