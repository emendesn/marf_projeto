#ifdef SPANISH
	#define STR0001 "Cambiar Regla"
	#define STR0002 "No se modifico ningun usuario"
	#define STR0003 "Se modifico un usuario"
	#define STR0004 "Se modificaron "
	#define STR0005 " Usuarios"
	#define STR0006 "Operadora de Salud"
	#define STR0007 "Operadora"
	#define STR0008 "Grupo/Empresa"
	#define STR0009 "Empresa"
	#define STR0010 "Contrato"
	#define STR0011 "Version del Contrato"
	#define STR0012 "SubContrato"
	#define STR0013 "Version del Subcontrato"
	#define STR0014 "Matricula"
	#define STR0015 "Secuencia"
	#define STR0016 "Version"
#else
	#ifdef ENGLISH
		#define STR0001 "Change Rule"
		#define STR0002 "No register was altered!"
		#define STR0003 "A user was altered!"
		#define STR0004 "The following were altered "
		#define STR0005 " Users"
		#define STR0006 "Health Provider"
		#define STR0007 "Operator"
		#define STR0008 "Group/Company"
		#define STR0009 "Company"
		#define STR0010 "Contract"
		#define STR0011 "Contract Version"
		#define STR0012 "Subcontract"
		#define STR0013 "Subcontract Version"
		#define STR0014 "Registration"
		#define STR0015 "Sequence"
		#define STR0016 "Version"
	#else
		#define STR0001 "Mudar Regra"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Nenhum Utilizador foi Alterado!", "Nenhum Usu�rio foi Alterado!" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Foi Alterado um Utilizador!", "Foi Alterado um Usu�rio!" )
		#define STR0004 "Foram alterados "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", " Utilizadores", " Usuarios" )
		#define STR0006 "Operadora de Sa�de"
		#define STR0007 "Operadora"
		#define STR0008 "Grupo/Empresa"
		#define STR0009 "Empresa"
		#define STR0010 "Contrato"
		#define STR0011 "Vers�o do Contrato"
		#define STR0012 "Subcontrato"
		#define STR0013 "Vers�o do Subcontrato"
		#define STR0014 "Matr�cula"
		#define STR0015 "Sequ�ncia"
		#define STR0016 "Vers�o"
	#endif
#endif
