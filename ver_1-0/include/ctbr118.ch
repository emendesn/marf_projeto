#ifdef SPANISH
	#define STR0001 'Este programa imprimira el Libro Diario, de acuerdo'
	#define STR0002 'con los parametros sugeridos por el usuario. Este modelo es ideal'
	#define STR0003 'para Plan de Cuentas que tengan codigos poco extensos.'
	#define STR0004 'A rayas'
	#define STR0005 'Administracion'
	#define STR0006 ' Emision del Libro Diario Contable '
	#define STR0007 'Totalizadores Doc / General'
	#define STR0008 'Asientos Contables'
	#define STR0009 ' Totalizador de Transporte de la Pagina'
	#define STR0010 'Vlr.Debito'
	#define STR0011 'Vlr.Credito'
	#define STR0012 ' De Transporte=======>'
	#define STR0013 ' LIBRO DIARIO GENERAL DE'
	#define STR0014 ' A '
	#define STR0015 '  EN '
	#define STR0016 ' Total General============> '
	#define STR0017 ' Fecha '
	#define STR0018 ' Total por Fecha '
	#define STR0019 ' Por Transportar=======> '
	#define STR0020 "FORMATO 5.1: LIBRO DIARIO"
	#define STR0021 "Periodo: "
	#define STR0022 "RUC: "
	#define STR0023 "Referencia de la operacion"
	#define STR0024 "Cuenta contable asociada a la operacion"
	#define STR0025 "Movimiento"
#else
	#ifdef ENGLISH
		#define STR0001 'This program will print the Journal according '
		#define STR0002 'to parameters suggested by the user. This model is perfect '
		#define STR0003 'for Charts of Accounts whose codes are not too long.'
		#define STR0004 'Z-form'
		#define STR0005 'Administration'
		#define STR0006 ' Issue of Accounting Journal '
		#define STR0007 'Totalizers Doc / General'
		#define STR0008 'Accounting entries'
		#define STR0009 ' Totalizer of Page Transport'
		#define STR0010 'Debit Value'
		#define STR0011 'Credit Value'
		#define STR0012 ' From Transportation====>'
		#define STR0013 ' GENERAL JOURNAL OF '
		#define STR0014 ' TO '
		#define STR0015 '  IN '
		#define STR0016 ' Grand Total============> '
		#define STR0017 ' Date: '
		#define STR0018 ' Total per Date '
		#define STR0019 ' To be transported=======> '
		#define STR0020 "FORMAT 5.1: JOURNAL"
		#define STR0021 "Period: "
		#define STR0022 "RUC: "
		#define STR0023 "Operation Reference"
		#define STR0024 "Ledger account related to operation"
		#define STR0025 "Transaction"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", 'Este programa imprimirá o Livro Diário, de acordo', 'Este programa ira imprimir o Livro Diário, de acordo' )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'com os parâmetros sugeridos pelo utilizador. Este modelo é ideal', 'com os parametros sugeridos pelo usuario. Este modelo e ideal' )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", 'para Plano de Contas que possuam códigos não muito extensos.', 'para Plano de Contas que possuam codigos nao muito extensos.' )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cód.Barras", 'Zebrado' )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Administração', 'Administraçao' )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", ' Emissão do Livro Diário Contábil ', ' Emissao do Livro Diario Contábil ' )
		#define STR0007 'Totalizadores Doc / Geral'
		#define STR0008 If( cPaisLoc $ "ANG|PTG", 'Lançamentos Contabilísticos', 'Lançamentos contábeis' )
		#define STR0009 ' Totalizador de Transporte da Página'
		#define STR0010 'Vlr.Débito'
		#define STR0011 'Vlr.Crédito'
		#define STR0012 ' De Transporte=======>'
		#define STR0013 If( cPaisLoc $ "ANG|PTG", ' LIVRO DIÁRIO GERAL DE', ' LIVRO DIARIO GERAL DE' )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", ' ATÉ ', ' ATE ' )
		#define STR0015 '  EM '
		#define STR0016 ' Total Geral============> '
		#define STR0017 ' Data: '
		#define STR0018 ' Total por Data '
		#define STR0019 ' A Tranportar=======> '
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "FORMATO 5.1: LIVRO DIÁRIO", "FORMATO 5.1: LIBRO DIARIO" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Período: ", "Periodo: " )
		#define STR0022 "RUC: "
		#define STR0023 "Referência da Operação"
		#define STR0024 "Conta contábil associada a operação"
		#define STR0025 "Movimento"
	#endif
#endif
