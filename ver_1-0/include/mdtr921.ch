#ifdef SPANISH
	#define STR0001 "Design. de la Comision Electoral CIPA"
	#define STR0002 "Imprimiendo.."
	#define STR0003 "DESIGN. DE LA COMISION ELECTORAL"
	#define STR0004 "Quedan desig. a los senores"
	#define STR0005 "para conformar la Com. Electoral de la CIPA, segun la Norma"
	#define STR0006 "Reglamentadora N� 5, de la Resoluc. 3.214/78 del Minist. deo Trabajo y Empleo,"
	#define STR0007 "modif. por la Resol. n� 08, del 23 de febrero de 1999."
	#define STR0008 "Quedan desig. a los senores"
	#define STR0009 "Presid. o Vicepresidente de la CIPA"
	#define STR0010 "�Cliente?"
	#define STR0011 "Tda."
	#define STR0012 "�Tipo de Impres.?"
	#define STR0013 "�Cuantas copias?"
	#define STR0014 "�Mandato CIPA Anterior?"
	#define STR0015 "y "
	#define STR0016 " de "
	#define STR0017 "Queda designado el senor "
	#define STR0018 "para componer la Comision Electoral de la CIPA,de conformidad con la Norma "
#else
	#ifdef ENGLISH
		#define STR0001 "Designation of CIPA Electoral Commission"
		#define STR0002 "Printing..."
		#define STR0003 "DESIGNATION OF ELECTORAL COMMISSION"
		#define STR0004 "Are appointed Messrs.        "
		#define STR0005 "as members of the CIPA election Committee, according to regulation    "
		#define STR0006 "NR 5, of Decree 3.214/78 of the Ministry of Labor and Employment,              "
		#define STR0007 "as amended by Decree n� 08, dated February 23, 1999.     "
		#define STR0008 "Are appointed Messrs.       "
		#define STR0009 "CIPA President or Vice-president     "
		#define STR0010 "Customer ?"
		#define STR0011 "Unit"
		#define STR0012 "Print Type?"
		#define STR0013 "How many copies?"
		#define STR0014 "Previous CIPA Term?"
		#define STR0015 "and "
		#define STR0016 " from "
		#define STR0017 "You have been chosen "
		#define STR0018 "to be part of CIPA Electoral Commission, according to the rule "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Designa��o Da Comiss�o Eleitoral Chsst", "Designa��o da Comiss�o Eleitoral CIPA" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A imprimir...", "Imprimindo..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Designa��o Da Comiss�o Eleitoral", "DESIGNA��O DA COMISS�O ELEITORAL" )
		#define STR0004 "Ficam designados os senhores "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Para Comporem A Comiss�o Eleitoral Da Chsst, Em Conformidade Com A Norma", "para comporem a Comiss�o Eleitoral da CIPA, em conformidade com a Norma" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Regulamentadora N� 5, Da Portaria 3.214/78 Do Minist�rio Do Trabalho E Solidariedade Social,", "Regulamentadora NR 5, da Portaria 3.214/78 do Minist�rio do Trabalho e Emprego," )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Alterada pela portaria n� 08, de 23 de Fevereiro de 1999.", "alterada pela Portaria n� 08, de 23 de fevereiro de 1999." )
		#define STR0008 "Ficam designados os senhores"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Presidente Ou Vice-presidente Da Chsst", "Presidente ou Vice Presidente da CIPA" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cliente?", "Cliente ?" )
		#define STR0011 "Loja"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Tipo de Impress�o ?", "Tipo de Impressao ?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Quantas c�pias ?", "Quantas copias ?" )
		#define STR0014 "Mandato CIPA Anterior ?"
		#define STR0015 "e "
		#define STR0016 " de "
		#define STR0017 "Fica designado o senhor "
		#define STR0018 "para compor a Comiss�o Eleitoral da CIPA, em conformidade com a Norma "
	#endif
#endif
