#ifdef SPANISH
	#define STR0001 "Par�metros del m�dulo"
	#define STR0002 "Visualizar"
	#define STR0003 "Rellene Cont."
	#define STR0004 "Incluir"
	#define STR0005 "Excluir"
	#define STR0006 "Imprimir"
	#define STR0007 "Par�metros del m�dulo"
	#define STR0008 "�Par�metro ya registrado!"
	#define STR0009 "�Valor inv�lido! �Digite .T. o .F. !"
	#define STR0010 "�Valor inv�lido! Digite solo valores num�ricos."
#else
	#ifdef ENGLISH
		#define STR0001 "Module Parameters"
		#define STR0002 "View"
		#define STR0003 "Completes Cont."
		#define STR0004 "Add"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Module Parameters"
		#define STR0008 "Parameter already registered!"
		#define STR0009 "Invalid value! Enter .T. or .F. !"
		#define STR0010 "Invalid value! Enter only numerical values."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Par�metros do M�dulo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Preenche Cont." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Imprimir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Par�metros do M�dulo" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Par�metro j� cadastrado!" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Valor inv�lido! Digite .T. ou .F. !" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Valor inv�lido! Digite apenas valores num�ricos." )
	#endif
#endif
