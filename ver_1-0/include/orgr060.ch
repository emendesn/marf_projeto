#ifdef SPANISH
	#define STR0001 "Informe Puestos vs. Ocupantes"
	#define STR0002 "Se imprimira de acuerdo con los param. solicitados por el usuario."
	#define STR0003 "Departamento/Puesto"
	#define STR0004 "Emite lista de Puestos con sus Ocupantes actuales y anteriores."
	#define STR0005 "Departamento"
	#define STR0006 "Puests"
	#define STR0007 "Puest"
	#define STR0008 "Cargo"
	#define STR0009 "Func. "
	#define STR0010 "Historial"
	#define STR0011 "Matricula"
	#define STR0012 "Impr. Estatus de Puestos"
	#define STR0013 "Vac."
	#define STR0014 "Ocupado"
	#define STR0015 "Anulado"
	#define STR0016 "Congelado"
	#define STR0017 "Suc. Ocupante"
	#define STR0018 "Cod. Ocupante"
	#define STR0019 "Nombre Ocupante"
	#define STR0020 "�Titular?"
	#define STR0021 "Maximo"
	#define STR0022 "Ocupados"
	#define STR0023 "Sustituto"
	#define STR0024 "Titular"
	#define STR0025 "Total de Puestos"
	#define STR0026 "Puestos "
	#define STR0027 "Cantidad Maxima "
	#define STR0028 "Cantidad Ocupados "
#else
	#ifdef ENGLISH
		#define STR0001 "Positions vs. Occupiers Report "
		#define STR0002 "It will be printed according to the parameters requested by the user."
		#define STR0003 "Department/Position "
		#define STR0004 "It lists the Positions with its current and previous Occupiers."
		#define STR0005 "Department  "
		#define STR0006 "Positions"
		#define STR0007 "Position"
		#define STR0008 "Position"
		#define STR0009 "Role  "
		#define STR0010 "History  "
		#define STR0011 "Registrat."
		#define STR0012 "Print position status "
		#define STR0013 "Vacant"
		#define STR0014 "Occupied"
		#define STR0015 "Cancelled"
		#define STR0016 "Frozen   "
		#define STR0017 "Bran. Occupant"
		#define STR0018 "Code Occupant"
		#define STR0019 "Occupant Name"
		#define STR0020 "Holder"
		#define STR0021 "Maximum"
		#define STR0022 "Occupied"
		#define STR0023 "Replacement"
		#define STR0024 "Holder"
		#define STR0025 "Total Stations"
		#define STR0026 "Positions "
		#define STR0027 "Maximum amount "
		#define STR0028 "Amount Occupied "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relat�rio De Postos X Ocupantes", "Relat�rio de Postos x Ocupantes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Sera impresso de acordo com os par�metro s solicitados pelo utilizador.", "Ser� impresso de acordo com os par�metros solicitados pelo usu�rio." )
		#define STR0003 "Departamento / Posto"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Emite rela��o de postos com os seus ocupantes actuais e anteriores.", "Emite rela��o de Postos com seus Ocupantes atuais e anteriores." )
		#define STR0005 "Departamento"
		#define STR0006 "Postos"
		#define STR0007 "Posto"
		#define STR0008 "Cargo"
		#define STR0009 "Fun��o"
		#define STR0010 "Hist�rico"
		#define STR0011 "Matr�cula"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Imprimir Estado De Postos", "Imprimir Status de Postos" )
		#define STR0013 "Vago"
		#define STR0014 "Ocupado"
		#define STR0015 "Cancelado"
		#define STR0016 "Congelado"
		#define STR0017 "Fil. Ocupante"
		#define STR0018 "Cod. Ocupante"
		#define STR0019 "Nome Ocupante"
		#define STR0020 "Titular?"
		#define STR0021 "M�ximo"
		#define STR0022 "Ocupados"
		#define STR0023 "Substituto"
		#define STR0024 "Titular"
		#define STR0025 "Total de Postos"
		#define STR0026 "Postos "
		#define STR0027 "Quantidade M�xima "
		#define STR0028 "Quantidade Ocupados "
	#endif
#endif
