#ifdef SPANISH
	#define STR0001 "Simples Paulista"
	#define STR0002 "Seleccionando registros..."
	#define STR0003 "Impresion del Simples Paulista"
	#define STR0004 "Parametro no encontrado."
	#define STR0005 "El parametro [MV_EMPRESA], utilizado para definir la empresa en Microempresa, Empresa de Pequeno Porte clase 'A' o Empresa de Pequeno Porte clase 'B', no se encontro."
	#define STR0006 "Incluir el parametro [MV_EMPRESA] en la tabla SX6. Para mayores referencias, consulte la documentacion que acompana la rutina."
	#define STR0007 "El parametro [MV_ALIQTPA], utilizado para definir el porcentaje de la alicuota utilizada por el Simples Paulista, no se encontro."
	#define STR0008 "Incluir el parametro [MV_ALIQTPA] en la tabla SX6. Para mas referencias, consulte la documentacion que acompana la rutina."
	#define STR0009 "El parametro [MV_ALIQTPB], utilizado para definir el porcentaje de la alicuota utilizada por el Simles Paulista, no se encontro."
	#define STR0010 "Incluir el parametro [MV_ALIQTPB] en la tabla SX6. Para mas referencias, consulte la documentacion que acompana la rutina."
	#define STR0011 "El parametro [MV_FXREC01], utilizado para informar el rango de ingreso bruto correspondiente a Microempresas, no se encontro."
	#define STR0012 "Incluir el parametro [MV_FXREC01] en la tabla SX6. La ausencia de este parametro podra afectar la visualizacion de los valores calculados."
	#define STR0013 "El parametro [MV_FXREC02], utilizado para informar el rango de ingreso bruto correspondiente a Empresas de Pequeno Porte clase 'A', no se encontro."
	#define STR0014 "Incluir el parametro [MV_FXREC02] en la tabla SX6. La ausencia de este parametro podra afectar la visualizacion de los valores calculados."
	#define STR0015 "El parametro [MV_FXREC03], utilizado para informar el rango de ingreso bruto correspondiente a Empresas de Pequeno Porte 'B', no se encontro."
	#define STR0016 "Incluir el parametro [MV_FXREC03] en la tabla SX6. La ausencia de este parametro podra afectar la visualizacion de los valores calculados."
	#define STR0017 "  C.N.P.J.:   ##################               I.E.:     ##################### "
	#define STR0018 "| Regimen de Tributacion:                                                     |"
	#define STR0019 "| ###################################                                         |"
	#define STR0020 "| Ingreso Bruto Anual (Ano Anterior):                                         |"
	#define STR0021 "| #################                                                           |"
	#define STR0022 "| Periodo:                                                                    |"
	#define STR0023 "| ###################                                                         |"
	#define STR0024 "| ICMS Adeudado:                                                              |"
	#define STR0025 "| #################                                                           |"
	#define STR0026 "El parametro [MV_DED001] se utiliza como deduccion en el calculo del impuesto. Si no se defineiera, la rutina realizara el calculo de forma incorrecta."
	#define STR0027 "Incluir el parametro [MV_DED001] en la tabla SX6."
	#define STR0028 "El parametro [MV_PERCDED]  se utiliza para informar el porcentaje del valor de las salidas de mercaderias o servicios por deducir en el calculo del impuesto. Sin ese parametro, el calculo se realizara de forma incorrecta."
	#define STR0029 "Incluir el parametro [MV_PERCDED] en la tabla SX6."
	#define STR0030 "El parametro [MV_LIMDED] se utiliza para informar el limite del valor por deducir en el calculo del impuesto. Debe informarse junto con el parametro [MV_PERCDED]."
	#define STR0031 "Incluir el parametro [MV_LIMDED] en la tabla SX6. Si no se define, la rutina realizara el calculo de forma incorrecta."
	#define STR0032 "| Ingreso Bruto Mensual                                                       |"
	#define STR0033 "| #################                                                           |"
	#define STR0034 "Microempresa"
	#define STR0035 "Empresa de Pequeno Porte"
	#define STR0036 "Razon Social:"
	#define STR0037 "Regimen de Tributacion:"
	#define STR0038 "Ingreso Bruto Anual (Ano Anterior):"
	#define STR0039 "R$"
	#define STR0040 "Ingreso Bruto Mensual:"
	#define STR0041 "Periodo:"
	#define STR0042 " a "
	#define STR0043 "ICMS adeudado:"
	#define STR0044 "Exento de ICMS."
	#define STR0045 "Empresa sujeta a las normas generales de tributacion."
	#define STR0046 "Informe la fecha inicial para calculo de  "
	#define STR0047 "ingreso bruto (suma del valor total "
	#define STR0048 "de las facturas de salida)             "
	#define STR0049 "Informe la fecha final para calculo de    "
	#define STR0050 "�Fecha Inicial?"
	#define STR0051 "�Fecha Final?"
#else
	#ifdef ENGLISH
		#define STR0001 "Simples Paulista tax"
		#define STR0002 "Selecting records..."
		#define STR0003 "Simples Paulista tax printing"
		#define STR0004 "Parameter not found."
		#define STR0005 "Parameter [MV_EMPRESA], which is used to define the companies as small companies, small class 'A' or small class 'B' companies, was not found."
		#define STR0006 "Insert parameter [MV_EMPRESA] in table SX6. For more information, check the documentation that is part of the routine."
		#define STR0007 "Parameter [MV_ALIQTPA], which is used to define the tax rate percentage for Simples Paulista tax, was not found."
		#define STR0008 "Insert parameter [MV_ALIQTPA] in table SX6. For more information, check the documentation that is part of the routine."
		#define STR0009 "Parameter [MV_ALIQTPB], which is used to define the tax rate percentage of Simples Paulista tax, was not found."
		#define STR0010 "Insert parameter [MV_ALIQTPB] in table SX6. For more information, check the documentation that follows the routine."
		#define STR0011 "Parameter [MV_FXREC01], which is used to inform the gross revenue range of small companies, was not found."
		#define STR0012 "Insert parameter [MV_FXREC01] in table SX6. The absence of this parameter will affect the display of the calculated values."
		#define STR0013 "Parameter [MV_FXREC02], which is used to inform the gross revenue range of Small class 'A' companies, was not found."
		#define STR0014 "Insert parameter [MV_FXREC02] in table SX6. The absence of this parameter will affect the dispaly of the calculated values."
		#define STR0015 "Parameter [MV_FXREC03], which is used to inform the gross revenue range of Small class 'B' companies, was not found."
		#define STR0016 "Insert parameter [MV_FXREC03] in table SX6. The absence of this parameter could affect the display of the calculated values."
		#define STR0017 "  C.N.P.J.:   ##################               I.E.:     ##################### "
		#define STR0018 "| Tax Basis:                                                                  |"
		#define STR0019 "| ###################################                                         |"
		#define STR0020 "| Annul Gross Revenue (Previous Year):                                        |"
		#define STR0021 "| #################                                                           |"
		#define STR0022 "| Period:                                                                     |"
		#define STR0023 "| ###################                                                         |"
		#define STR0024 "| ICMS Due:                                                                   |"
		#define STR0025 "| #################                                                           |"
		#define STR0026 "Parameter [MV_DED001] is used as a tax calculation deduction. If this parameter is not defined, the routine will not perform calculation correctly."
		#define STR0027 "Insert the parameter [MV_DED001] in table SX6."
		#define STR0028 "Parameter [MV_PERCDED]  is used to inform the percentage of services and goods outflow to be deducted in tax calculation. Without this parameter, the calculation will not be performed correctly."
		#define STR0029 "Insert parameter [MV_PERCDED] in table SX6."
		#define STR0030 "Parameter [MV_LIMDED] is used to inform the value limit to be deducted in tax calculation. Mandatory parameter [MV_PERCDED] to be informed."
		#define STR0031 "Insert parameter [MV_LIMDED] in table SX6. If the parameter is not defined, the routine will not perform calculation correctly."
		#define STR0032 "| Monthy Gross Revenue                                                        |"
		#define STR0033 "| #################                                                           |"
		#define STR0034 "Small comp. "
		#define STR0035 "Small Size Company      "
		#define STR0036 "Company Name"
		#define STR0037 "Taxation Basis:"
		#define STR0038 "Annual Gross Revenue (Previous Year):"
		#define STR0039 "R$"
		#define STR0040 "Monthly Gross Revenue:"
		#define STR0041 "Period:"
		#define STR0042 " to"
		#define STR0043 "ICMS Due:"
		#define STR0044 "ICMS Exempt"
		#define STR0045 "Company under taxation general rules."
		#define STR0046 "Inform the initial date for gross revenue"
		#define STR0047 "calculation (sum of the total value of "
		#define STR0048 "outflow invoices)                       "
		#define STR0049 "Inform the final date for the calculation of "
		#define STR0050 "Initial Date?"
		#define STR0051 "Final Date?"
	#else
		#define STR0001 "Simples Paulista"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando registros..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Impress�o Do Simples Paulista", "Impress�o do Simples Paulista" )
		#define STR0004 "Par�metro n�o encontrado."
		#define STR0005 "O par�metro [MV_EMPRESA], utilizado para definir a empresa em Microempresa, Empresa de Pequeno Porte classe 'A' ou Empresa de Pequeno Porte classe 'B', n�o foi encontrado."
		#define STR0006 "Incluir o par�metro [MV_EMPRESA] na tabela SX6. Para maiores refer�ncias, consulte a documenta��o que acompanha a rotina."
		#define STR0007 "O par�metro [MV_ALIQTPA], utilizado para definir o percentual da al�quota utilizada pelo Simles Paulista, n�o foi encontrado."
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Incluir o par�metro [MV_ALIQTPA] na tabela SX6. Para mais refer�ncias, consultar a documenta��o que acompanha o procedimento.", "Incluir o par�metro [MV_ALIQTPA] na tabela SX6. Para maiores refer�ncias, consulte a documenta��o que acompanha a rotina." )
		#define STR0009 "O par�metro [MV_ALIQTPB], utilizado para definir o percentual da al�quota utilizada pelo Simles Paulista, n�o foi encontrado."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Incluir o par�metro [MV_ALIQTPB] na tabela SX6. Para mais refer�ncias, consultar a documenta��o que acompanha o procedimento.", "Incluir o par�metro [MV_ALIQTPB] na tabela SX6. Para maiores refer�ncias, consulte a documenta��o que acompanha a rotina." )
		#define STR0011 "O par�metro [MV_FXREC01], utilizado para informar a faixa de receita bruta correspondente a Microempresas, n�o foi encontrado."
		#define STR0012 "Incluir o par�metro [MV_FXREC01] na tabela SX6. A aus�ncia deste par�metro poder� afetar a exibi��o dos valores calculados."
		#define STR0013 "O par�metro [MV_FXREC02], utilizado para informar a faixa de receita bruta correspondente a Empresas de Pequeno Porte classe 'A', n�o foi encontrado."
		#define STR0014 "Incluir o par�metro [MV_FXREC02] na tabela SX6. A aus�ncia deste par�metro poder� afetar a exibi��o dos valores calculados."
		#define STR0015 "O par�metro [MV_FXREC03], utilizado para informar a faixa de receita bruta correspondente a Empresas de Pequeno Porte classe 'B', n�o foi encontrado."
		#define STR0016 "Incluir o par�metro [MV_FXREC03] na tabela SX6. A aus�ncia deste par�metro poder� afetar a exibi��o dos valores calculados."
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "  nr. contribuinte.:   ##################               i.e.:     ##################### ", "  C.N.P.J.:   ##################               I.E.:     ##################### " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "| regime de tributa��o:                                                       |", "| Regime de Tributacao:                                                       |" )
		#define STR0019 "| ###################################                                         |"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "| receita bruta anual (ano anterior):                                         |", "| Receita Bruta Anual (Ano Anterior):                                         |" )
		#define STR0021 "| #################                                                           |"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "| per�odo:                                                                    |", "| Periodo:                                                                    |" )
		#define STR0023 "| ###################                                                         |"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "| icms devido:                                                                |", "| ICMS Devido:                                                                |" )
		#define STR0025 "| #################                                                           |"
		#define STR0026 "O par�metro [MV_DED001] � utilizado como dedu��o no c�lculo do imposto. Caso o mesmo n�o seja definido, a rotina ir� efetuar o c�lculo de maneira incorreta."
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Incluir O Par�metro [mv_ded001] Na Tabela Sx6.", "Incluir o par�metro [MV_DED001] na tabela SX6." )
		#define STR0028 "O par�metro [MV_PERCDED]  � utilizado para informar o percentual do valor das sa�das de mercadorias ou servi�os a ser deduzido no c�lculo do imposto. Sem tal par�metro, o c�lculo ser� efetuado de maneira incorreta."
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Incluir O Par�metro [mv_percded] Na Tabela Sx6.", "Incluir o par�metro [MV_PERCDED] na tabela SX6." )
		#define STR0030 "O par�metro [MV_LIMDED] � utilizado para informar o limite do valor a ser deduzido no c�lculo do imposto. Deve ser informado juntamente com o par�metro [MV_PERCDED]."
		#define STR0031 "Incluir o par�metro [MV_LIMDED] na tabela SX6. Caso o mesmo n�o seja definido, a rotina ir� efetuar o c�lculo de maneira incorreta."
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "| receita bruta mensal                                                        |", "| Receita Bruta Mensal                                                        |" )
		#define STR0033 "| #################                                                           |"
		#define STR0034 "Microempresa"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Empresa De Pequeno Dimens�o", "Empresa de Pequeno Porte" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Razao social:", "Raz�o Social:" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Regime De Tributa��o:", "Regime de Tributa��o:" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Receita Bruta Anual (ano Anterior):", "Receita Bruta Anual (Ano Anterior):" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "�", "R$" )
		#define STR0040 "Receita Bruta Mensal:"
		#define STR0041 "Per�odo:"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", " o ", " � " )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Icms Devido:", "ICMS Devido:" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Isento Do Icms.", "Isento do ICMS." )
		#define STR0045 "Empresa sujeita �s normas gerais de tributa��o."
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Introduza a data inicial para c�lculo de  ", "Informe a data inicial para c�lculo de  " )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Receita bruta (somat�rio do valor total ", "receita bruta (somat�ria do valor total " )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Das notas fiscais de sa�da)             ", "das notas fiscais de sa�da)             " )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Introduza a data final para c�lculo de    ", "Informe a data final para c�lculo de    " )
		#define STR0050 "Data Inicial?"
		#define STR0051 "Data Final?"
	#endif
#endif
