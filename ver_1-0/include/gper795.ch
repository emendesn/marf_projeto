#ifdef SPANISH
	#define STR0001 "Declaracion de IRS"
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "Matricula"
	#define STR0005 "Num. contribuyente."
	#define STR0006 "Blanco"
	#define STR0007 "Administracion"
	#define STR0008 " DECLARACION DE RENDIMIENTOS - IRS "
	#define STR0009 "Centro de Costo"
	#define STR0010 "Seleccionar Registos..."
	#define STR0011 "Atencion"
	#define STR0012 "DECLARACION PARA EFECTO DEL IMPUESTO SOBRE LA REMUNERACION DE PERSONAS FISICAS "
	#define STR0013 "(ANO CALENDARIO - "
	#define STR0014 "Periodo: "
	#define STR0015 "Se declara para efectos de lo dispuesto en la referencia b) del Articulo 119 del  codigo del impuesto de remuneracion de las "
	#define STR0016 "personas fisicas, que el siguiente contribuyente, en la calidad de emplegado de esta empresa, durante el ano "
	#define STR0017 "indicado, obtuvo las siguientes remuneraciones.  "
	#define STR0018 "1 - IDENTIFICACION DEL ENTE PAGADOR "
	#define STR0019 " Nombre: "
	#define STR0020 " N� de Contribuyente: "
	#define STR0021 " Direccion de la Sede: "
	#define STR0022 "2 - IDENTIFICACION DEL TITULAR DE LAS REMUNERACIONES "
	#define STR0023 " N� de Empleado: "
	#define STR0024 " Direccion: "
	#define STR0025 "TIPOS DE REMUNERACIONES: "
	#define STR0026 "3 - REMUNERACIONES E IMPUESTOS RETENIDOS "
	#define STR0027 "01 - Total de Remuneraciones Puestos a Disposicion y Sujetos a I.R.S"
	#define STR0028 "02 - Total de I.R.S Retenido"
	#define STR0029 "03 - Total de las Contribuiciones para la Seguridad Social"
	#define STR0030 "04 - Total de los Aportes Sindicales"
	#define STR0031 "4 - REMUNERACIONES NO SUJETAS A IRS"
	#define STR0032 "Total de Remuneraciones no sujetas a IRS"
	#define STR0033 "5 - RESPONSABLE POR LAS INFORMACIONES"
	#define STR0034 "  Nombre del Responsable"
	#define STR0035 "Fecha"
	#define STR0036 "4. REMUNERACIONES NO SUJETAS A IRS "
	#define STR0037 "01 - Total de Remuneraciones no sujetas a IRS"
	#define STR0038 " N� de Contribuyente"
	#define STR0039 "Nombre"
	#define STR0040 "Firma"
	#define STR0041 " ENERO    -    DICIEMBRE "
#else
	#ifdef ENGLISH
		#define STR0001 "IRS Return"
		#define STR0002 "It will be printed in accordance with parameters requested by"
		#define STR0003 "User."
		#define STR0004 "Registration"
		#define STR0005 "Tax payer number."
		#define STR0006 "Blank"
		#define STR0007 "Management"
		#define STR0008 " INCOME STATEMENT - IRS "
		#define STR0009 "Cost Center"
		#define STR0010 "Selecting Files..."
		#define STR0011 "Attention"
		#define STR0012 "DECLARATION FOR INCOME TAX OF NATURAL PERSON "
		#define STR0013 "(CURRENT YEAR - "
		#define STR0014 "Period: "
		#define STR0015 "According to paragraph b) of Article 119 of income tax code "
		#define STR0016 "of natural person, the taxpayer below, as employee of this company, during the year "
		#define STR0017 "indicated, earned the following remunerations:  "
		#define STR0018 "1 - IDENTIFICATION OF PAYER ENTITY "
		#define STR0019 " Name: "
		#define STR0020 "Tax Payer Nr: "
		#define STR0021 " Headquarter Address: "
		#define STR0022 "2 - IDENTIFICATION OF EARNINGS' HOLDER "
		#define STR0023 "Employee Nr.: "
		#define STR0024 " Address: "
		#define STR0025 "EARNINGS TYPE: "
		#define STR0026 "3 - EARNINGS AND RETAINED TAXES "
		#define STR0027 "01 - Total of Earnings Made Available and Subject to IRS"
		#define STR0028 "02 - Total of Retained IRS"
		#define STR0029 "03 - Total of Contributions to Social Security"
		#define STR0030 "04 - Total of Union Quotableness"
		#define STR0031 "4 - REMUNERATIONS NOT SUBJECT TO IRS"
		#define STR0032 "Total remuneration not subject to IRS"
		#define STR0033 "5 - RESPONSIBLE FOR INFORMATION"
		#define STR0034 "  Responsible Name"
		#define STR0035 "Date"
		#define STR0036 "4. REMUNERATION NOT SUBJECT TO IRS "
		#define STR0037 "01 - Total of Remuneration not subject to IRS"
		#define STR0038 "Tax Payer Nr."
		#define STR0039 "Name"
		#define STR0040 "Signature"
		#define STR0041 "JANUARY  -   DECEMBER"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "Declara��o de IRS", "Declara��o De IRS" )
		#define STR0002 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "Ser� impresso de acordo com os par�metros solicitados pelo", "Sera impresso de acordo com os par�metro s solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|EQU|HAI", "Utilizador.", If( cPaisLoc == "PTG", "utilizador.", "Usu�rio." ) )
		#define STR0004 "Matr�cula"
		#define STR0005 "Nr. contribuinte."
		#define STR0006 "Branco"
		#define STR0007 "Administra��o"
		#define STR0008 " DECLARA��O DE RENDIMENTOS - IRS "
		#define STR0009 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "Centro de Custo", "Centro De Custo" )
		#define STR0010 "A Seleccionar Registos..."
		#define STR0011 "Aten��o"
		#define STR0012 "DECLARA��O PARA EFEITO DO IMPOSTO SOBRE O RENDIMENTO DAS PESSOAS SINGULARES "
		#define STR0013 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "(ANO CALEND�RIO - ", "(ANO CALENDARIO - " )
		#define STR0014 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "Per�odo: ", "Periodo: " )
		#define STR0015 If( cPaisLoc $ "ANG|EQU|HAI", "Declara-se para os efeitos do disposto na al�nea b) do Artigo 119 do  c�digo do imposto de rendimento das ", If( cPaisLoc == "PTG", "Declara-se para os efeitos do disposto na al�nea b) do Artigo 119 do c�digo do imposto de rendimento das ", "Declara-se para os efeitos do disposto na alinea b) do Artigo 119 do  c�digo do imposto de rendimento das " ) )
		#define STR0016 If( cPaisLoc $ "ANG|EQU|HAI|PTG", "pessoas singulares, que o contribuinte abaixo, na qualidade de empregado desta empresa, durante o ano ", "pessoas singulares, que o contribuinte abaixo, na qualidade de empregado desta empresa,  durante  o   ano " )
		#define STR0017 If( cPaisLoc $ "ANG|EQU|HAI", "indicado, auferiu as seguintes remunera��es.  ", If( cPaisLoc == "PTG", "indicado auferiu as seguintes remunera��es.  ", "indicado,auferiu as seguintes remunera��es.  " ) )
		#define STR0018 "1 - IDENTIFICA��O DA ENTIDADE PAGADORA "
		#define STR0019 " Nome: "
		#define STR0020 " Nr. de Contribuinte: "
		#define STR0021 " Morada da Sede: "
		#define STR0022 "2 - IDENTIFICACAO DO TITULAR DOS RENDIMENTOS "
		#define STR0023 " Nr. de Empregado: "
		#define STR0024 " Morada: "
		#define STR0025 "TIPOS DE RENDIMENTOS: "
		#define STR0026 "3 - RENDIMENTOS E IMPOSTOS RETIDOS "
		#define STR0027 "01 - Total de Rendimentos Postos a Disposi��o e Sujeitos a I.R.S"
		#define STR0028 "02 - Total de I.R.S Retido"
		#define STR0029 "03 - Total das Contribui��es para a Seguran�a Social"
		#define STR0030 "04 - Total das Quotiza��es Sindicais"
		#define STR0031 "4 - REMUNERA��ES N�O SUJEITAS A IRS"
		#define STR0032 "Total de Remunera��es n�o sujeitas a IRS"
		#define STR0033 If( cPaisLoc $ "ANG|EQU|HAI", "5 - RESPONS�VEL PELAS INFORMA��ES", If( cPaisLoc == "PTG", "5 - RESPONS�VEL PELAS INFORMA��ES", "5 - RESPONS�VEL PELAS INFORMA��ES" ) )
		#define STR0034 "  Nome do Respons�vel"
		#define STR0035 "Data"
		#define STR0036 If( cPaisLoc $ "ANG|EQU|HAI", "4. REMUNERA��O N�O SUJEITA A IRS ", If( cPaisLoc == "PTG", "4. REMUNERA��ES N�O SUJEITAS A IRS ", "4. REMUNERA��O N�O SUJEITAS A IRS " ) )
		#define STR0037 If( cPaisLoc $ "ANG|EQU|HAI", "01 - Total de Remunera��o n�o sujeita a IRS", If( cPaisLoc == "PTG", "01 - Total de Remunera��es n�o sujeitas a IRS", "01 - Total de Remunera��o n�o sujeitas a IRS" ) )
		#define STR0038 " Nr. de Contribuinte"
		#define STR0039 "Nome"
		#define STR0040 "Assinatura"
		#define STR0041 " JANEIRO    -    DEZEMBRO "
	#endif
#endif