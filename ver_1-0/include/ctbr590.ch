#ifdef SPANISH
	#define STR0001 "Demonstrativos Cont�beis M�ltiplas Vis�es Gerenciais"
	#define STR0002 "Apresenta��o"
	#define STR0003 "Bem-Vindo "
	#define STR0004 "Esta herramienta ayudara a completar la informacion necesaria para la configuracion de la emision de demostrativos contables utilizando multiples visiones gerenciales."
	#define STR0005 "Par�metros Iniciais"
	#define STR0006 "Defini��o de par�metros inicias do relat�rio"
	#define STR0007 "Sele��o de Filiais"
	#define STR0008 "Filtro por Filiais/Unid.Neg�cio/Empresa"
	#define STR0009 "Calend�rio Cont�bil X Periodicidade"
	#define STR0010 "Vis�es Gerenciais"
	#define STR0011 "Sim"
	#define STR0012 "N�o"
	#define STR0013 "Quant. Vis�es Gerenciais:"
	#define STR0014 "Moeda: "
	#define STR0015 "Taxa de Moeda: "
	#define STR0016 "Considera Filiais ?"
	#define STR0017 "Calend�rio"
	#define STR0018 "Periodicidade"
	#define STR0019 "Quinzenal"
	#define STR0020 "Mensal"
	#define STR0021 "Trimestral"
	#define STR0022 "Semestral"
	#define STR0023 "Anual"
	#define STR0024 "Marca/Desmarca todos"
	#define STR0025 "Conf. Livro"
	#define STR0026 "Descri��o"
	#define STR0027 "Tipo Saldo"
	#define STR0028 "Informe a configura��o do livro cont�bil da linha "
	#define STR0029 "Informe o tipo de saldo cont�bil da linha "
	#define STR0030 "Defina se ser�o consideradas as filiais/Und.Neg�cio/Empresa no relat�rio"
	#define STR0031 "Debe definirse una cantidad de visiones gerenciales que se utilizaran en el informe, por menos una debe definirse. "
	#define STR0032 "Deve ser definida a moeda dos saldos do relat�rio de demonstrativos cont�beis."
	#define STR0033 "Moeda definida inv�lida."
	#define STR0034 "Quinzena"
	#define STR0035 "Trimestre"
	#define STR0036 "Semestre"
	#define STR0037 "Cantidad de periodos supero  el limite de #1[Limite Columnas]# columnas. Modifique los calendarios y periodos deseados."
	#define STR0038 "Defina pelo menos um calend�rio e periodicidade."
	#define STR0039 "Total"
	#define STR0040 "Pict. Tot."
	#define STR0041 "Tp. Val. Tot."
#else
	#ifdef ENGLISH
		#define STR0001 "Accounting Statements Multiple Managerial Visions"
		#define STR0002 "Presentation"
		#define STR0003 "Welcome "
		#define STR0004 "This tool will help to complete the data needed to check the issuing of accounting statements using multiple managerial visions"
		#define STR0005 "Initial Parameters"
		#define STR0006 "Definition of initial parameters of report"
		#define STR0007 "Selection of Branches"
		#define STR0008 "Filter by Branch/Business Unit/Company"
		#define STR0009 "Accounting Schedule X Periodicity"
		#define STR0010 "Managerial Visions"
		#define STR0011 "Yes"
		#define STR0012 "No"
		#define STR0013 "Amt. Managerial Visions:"
		#define STR0014 "Currency: "
		#define STR0015 "Currency Rate: "
		#define STR0016 "Consider Branches ?"
		#define STR0017 "Calendar"
		#define STR0018 "Periodicity"
		#define STR0019 "Fortnightly"
		#define STR0020 "Monthly"
		#define STR0021 "Quarterly"
		#define STR0022 "Semiannual"
		#define STR0023 "Annual"
		#define STR0024 "&Mark/Unmark All"
		#define STR0025 "Conf. Journal"
		#define STR0026 "Description"
		#define STR0027 "Balance Type"
		#define STR0028 "Enter configuration of accounting journal of line "
		#define STR0029 "Enter the type of accounting balance of line "
		#define STR0030 "Define whether the Branches/Business Unit/Company will be considered in report"
		#define STR0031 "You must define a number of managerial visions for use in report. At least one must be defined"
		#define STR0032 "You must define the currency of accounting statement report balances."
		#define STR0033 "Specified currency not valid."
		#define STR0034 "Fortnight"
		#define STR0035 "Quarter"
		#define STR0036 "Semester"
		#define STR0037 "Quantity of periods has exceeded the limit of #1[Column Limit]# columns. Modify desired schedules and periods."
		#define STR0038 "Define at least one schedule and periodicity."
		#define STR0039 "Total"
		#define STR0040 "Pict. Tot."
		#define STR0041 "Tot. Val. Tp."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Demonstrativos Contabil�sticos M�ltiplas Vis�es de Gest�o", "Demonstrativos Cont�beis M�ltiplas Vis�es Gerenciais" )
		#define STR0002 "Apresenta��o"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Bem-vindo ", "Bem-Vindo " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Esta ferramenta auxiliar� a preencher as informa��es necess�rias para configura��o da emiss�o de demonstrativos contabil�sticos utilizando m�ltiplas vis�es de gest�o", "Esta ferramenta ir� auxiliar a preencher as informa��es necess�rias para configura��o da emiss�o de demonstrativos cont�beis utilizando m�ltiplas vis�es gerenciais" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Par�metros iniciais", "Par�metros Iniciais" )
		#define STR0006 "Defini��o de par�metros inicias do relat�rio"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Selec��o de filiais", "Sele��o de Filiais" )
		#define STR0008 "Filtro por Filiais/Unid.Neg�cio/Empresa"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Calend�rio Contabil�stico X Periodicidade", "Calend�rio Cont�bil X Periodicidade" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Vis�es de Gest�o", "Vis�es Gerenciais" )
		#define STR0011 "Sim"
		#define STR0012 "N�o"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Qtd. Vis�es de Gest�o:", "Quant. Vis�es Gerenciais:" )
		#define STR0014 "Moeda: "
		#define STR0015 "Taxa de Moeda: "
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Considera filiais ?", "Considera Filiais ?" )
		#define STR0017 "Calend�rio"
		#define STR0018 "Periodicidade"
		#define STR0019 "Quinzenal"
		#define STR0020 "Mensal"
		#define STR0021 "Trimestral"
		#define STR0022 "Semestral"
		#define STR0023 "Anual"
		#define STR0024 "&Marca/Demarca Todos"
		#define STR0025 "Conf. Livro"
		#define STR0026 "Descri��o"
		#define STR0027 "Tipo Saldo"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Informe a configura��o do livro contabil�stico da linha ", "Informe a configura��o do livro cont�bil da linha " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Informe o tipo de saldo contabil�stico da linha ", "Informe o tipo de saldo cont�bil da linha " )
		#define STR0030 "Defina se ser�o consideradas as filiais/Und.Neg�cio/Empresa no relat�rio"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Deve ser definida a quantidade de vis�es de gest�o que ser� utilizada no relat�rio; pelo menos uma deve ser definida", "Deve ser definida uma quantidade de vis�es gerenciais que ser�o utilizadas no relat�rio, pelo menos uma deve ser definida" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Deve ser definida a moeda dos saldos do relat�rio de demonstrativos contabil�sticos.", "Deve ser definida a moeda dos saldos do relat�rio de demonstrativos cont�beis." )
		#define STR0033 "Moeda definida inv�lida."
		#define STR0034 "Quinzena"
		#define STR0035 "Trimestre"
		#define STR0036 "Semestre"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "A quantidade de per�odos superou o limite de #1[Limite Colunas]# colunas. Altere os calend�rios e per�odos desejados.", "Quantidade de per�odos superou o limite de #1[Limite Colunas]# colunas. Altere os calend�rios e per�odos desejados." )
		#define STR0038 "Defina pelo menos um calend�rio e periodicidade."
		#define STR0039 "Total"
		#define STR0040 "Pict. Tot."
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Tp. Vlr. Tot.", "Tp. Val. Tot." )
	#endif
#endif
