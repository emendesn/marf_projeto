#ifdef SPANISH
	#define STR0001 "Relat�rio das Legisla��es cadastradas no sistema."
	#define STR0002 "O usu�rio poder� utilizar a opcao Par�metros para a obten��o "
	#define STR0003 "das Legisla��es de seu interesse."
	#define STR0004 "A Rayas"
	#define STR0005 "Administra��o"
	#define STR0006 "Archivo de requisitos"
	#define STR0007 "ANULADO POR EL OPERADOR"
	#define STR0008 "Federal"
	#define STR0009 "Provincial"
	#define STR0010 "Municipal"
	#define STR0011 "Accionistas"
	#define STR0012 "Comunidad"
	#define STR0013 "Otros"
	#define STR0014 "Requisito..:"
	#define STR0015 "Tipo......: "
	#define STR0016 "Dt. Emiss�o: "
	#define STR0017 "Dt. Publica��o: "
	#define STR0018 "Cod. Resol.: "
	#define STR0019 "Num. Resolu��o: "
	#define STR0020 "Origem: "
	#define STR0021 "Enlace Relac.: "
	#define STR0022 "Descri��o.: "
#else
	#ifdef ENGLISH
		#define STR0001 "Legislation report registered in the system."
		#define STR0002 "You can use option Parameters to obtain "
		#define STR0003 "of legislation of your interest."
		#define STR0004 "Z.form "
		#define STR0005 "Administration"
		#define STR0006 "Requirements Registration"
		#define STR0007 "CANCELLED BY OPERATOR  "
		#define STR0008 "Federal"
		#define STR0009 "State   "
		#define STR0010 "Municipal"
		#define STR0011 "Shareholders"
		#define STR0012 "Comunity  "
		#define STR0013 "Other "
		#define STR0014 "Requirement..:"
		#define STR0015 "Type......: "
		#define STR0016 "Dt. Issue: "
		#define STR0017 "Dt. Publication: "
		#define STR0018 "Resol. Cod.: "
		#define STR0019 "Num. Resolution: "
		#define STR0020 "Origin: "
		#define STR0021 "Link Relat.: "
		#define STR0022 "Description: "
	#else
		#define STR0001 "Relat�rio das Legisla��es cadastradas no sistema."
		#define STR0002 "O usu�rio poder� utilizar a opcao Par�metros para a obten��o "
		#define STR0003 "das Legisla��es de seu interesse."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0005 "Administra��o"
		#define STR0006 "Cadastro de Requisitos"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0008 "Federal"
		#define STR0009 "Estadual"
		#define STR0010 "Municipal"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Accionistas", "Acionistas" )
		#define STR0012 "Comunidade"
		#define STR0013 "Outros"
		#define STR0014 "Requisito..:"
		#define STR0015 "Tipo......: "
		#define STR0016 "Dt. Emiss�o: "
		#define STR0017 "Dt. Publica��o: "
		#define STR0018 "Cod. Resol.: "
		#define STR0019 "Num. Resolu��o: "
		#define STR0020 "Origem: "
		#define STR0021 "Link Relac.: "
		#define STR0022 "Descri��o.: "
	#endif
#endif
