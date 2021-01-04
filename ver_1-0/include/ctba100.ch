#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Prorrateos On Line"
	#define STR0007 "Seleccionando registros..."
	#define STR0008 "Prorrateo:"
	#define STR0009 "Descripcion:"
	#define STR0010 "Porc. base:"
	#define STR0011 "Porcentajes prorrateados"
	#define STR0012 If( cPaisLoc == "MEX", "Total Cargo:", "Total Debito:" )
	#define STR0013 If( cPaisLoc == "MEX", "Total Abono:", "Total Credito:" )
	#define STR0014 "Moneda:"
	#define STR0015 "Saldo:"
	#define STR0016 "Cuenta de debito no completa"
	#define STR0017 "Cuenta de credito no completa"
	#define STR0018 "Para asientos de tipo debito, no rellenar campos de credito."
	#define STR0019 "Para asientos de tipo credito, no rellenar campos de debito."
	#define STR0020 "Porcentaje base debe ser superior a 0% o menor o igual a 100%"
	#define STR0021 "Importar"
	#define STR0022 "Log Proc"
	#define STR0023 "Archivo para importaci�n"
	#define STR0024 "superpone regla existente"
	#define STR0025 "S�"
	#define STR0026 "No"
	#define STR0027 "Prorrateo Online - Importaci�n CSV"
	#define STR0028 "Importaci�n del prorrateo"
	#define STR0029 "Importaci�n del archivo: "
	#define STR0030 "INICIO"
	#define STR0031 "Archivo no encontrado."
	#define STR0032 "ERROR"
	#define STR0033 "Archivo vac�o."
	#define STR0034 "Archivo incorrecto"
	#define STR0035 "Archivo con encabezado incorrecto"
	#define STR0036 "Las columnas de los �tems no coinciden con el n�mero de las columnas"
	#define STR0037 "Inconsistencia en los datos"
	#define STR0038 "Inconsistencia en los campos."
	#define STR0039 "FIN"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Online Proration"
		#define STR0007 "Selecting Records..."
		#define STR0008 "Prorate:"
		#define STR0009 "Descript.:"
		#define STR0010 "Base Perc.:"
		#define STR0011 "Prorated Percent."
		#define STR0012 "Debit Total:"
		#define STR0013 "Credit Total:"
		#define STR0014 "Curr.:"
		#define STR0015 "Balance:"
		#define STR0016 "Debit Account not completed"
		#define STR0017 "Credit Account not completed"
		#define STR0018 "For debit type entries, do not complete credit account."
		#define STR0019 "For credit type entries, do not complete debit account."
		#define STR0020 "Percent base must be higher than 0% or lower than 100%"
		#define STR0021 "Import"
		#define STR0022 "Proc Log"
		#define STR0023 "File for Import"
		#define STR0024 "subscribes existing rule"
		#define STR0025 "Yes"
		#define STR0026 "No"
		#define STR0027 "Online Apportionment - CSV Import"
		#define STR0028 "Apportionment Import"
		#define STR0029 "File menu: "
		#define STR0030 "START"
		#define STR0031 "File not found."
		#define STR0032 "ERROR"
		#define STR0033 "Empty File."
		#define STR0034 "Incorrect file"
		#define STR0035 "File with incorrect header"
		#define STR0036 "Item columns does not match to columns numbers"
		#define STR0037 "Data inconsistency"
		#define STR0038 "Fields inconsistency."
		#define STR0039 "END"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Rateios On-line", "Rateios On-Line" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0008 "Rateio:"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Descri��o:", "Descricao:" )
		#define STR0010 "Perc Base:"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Percentagens De Rateio", "Percentuais Rateados" )
		#define STR0012 If( cPaisLoc $ "ANG|EQU|HAI", "Total D�bito:", If( cPaisLoc $ "MEX|PTG", "Total Do D�bito:", "Total Debito:" ) )
		#define STR0013 If( cPaisLoc $ "ANG|EQU|HAI", "Total Cr�dito:", If( cPaisLoc $ "MEX|PTG", "Total Do Cr�dito:", "Total Credito:" ) )
		#define STR0014 "Moeda:"
		#define STR0015 "Saldo:"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Conta de d�bito n�o preenchida.", "Conta de D�bito n�o preenchida" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Conta de cr�dito n�o preenchida.", "Conta de Cr�dito n�o preenchida" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Para lan�amentos do tipo d�bito, n�o preencher campos de cr�dito.", "Para lan�amentos do tipo d�bito,n�o preencher campos de cr�dito." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Para lan�amentos do tipo cr�dito, n�o preencher campos de d�bito.", "Para lan�amentos do tipo cr�dito,n�o preencher campos de d�bito." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Percentagem base deve ser maior que 0% ou menor ou igual a 100%", "Percentual base deve ser maior que 0% ou menor ou igual a 100%" )
		#define STR0021 "Importar"
		#define STR0022 "Log Proc"
		#define STR0023 "Arquivo para Importa��o"
		#define STR0024 "sobrescreve regra existente"
		#define STR0025 "Sim"
		#define STR0026 "N�o"
		#define STR0027 "Rateio Online - Importa��o CSV"
		#define STR0028 "Importa��o do Rateio"
		#define STR0029 "Importa��o do arquivo: "
		#define STR0030 "INICIO"
		#define STR0031 "Arquivo n�o encontrado."
		#define STR0032 "ERRO"
		#define STR0033 "Arquivo Vazio."
		#define STR0034 "Arquivo incorreto"
		#define STR0035 "Arquivo  com cabe�alho incorreto"
		#define STR0036 "As colunas dos itens n�o bate com o numero das colunas"
		#define STR0037 "Inconsistencia nos dados"
		#define STR0038 "Inconsistencia nos campos."
		#define STR0039 "FIM"
	#endif
#endif