#ifdef SPANISH
	#define STR0001 "Informe de rendimientos"
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por"
	#define STR0003 "el usuario."
	#define STR0004 "Matricula"
	#define STR0005 "CNPJ"
	#define STR0006 "Blanco"
	#define STR0007 "Administracion"
	#define STR0008 " RELACION DEL INFORME RENDIMIENTO"
	#define STR0009 "Codigo no registrado tabla 37                         "
	#define STR0010 "Codigo no registrado tabla 37                         "
	#define STR0011 "Centro de costo"
	#define STR0012 "Seleccion de registros..."
	#define STR0013 "Beneficiario"
	#define STR0014 "Atencion"
	#define STR0015 "Tablas desactualizadas. Ejecute el actualizador"
	#define STR0016 "COMPROBANTE DE REMUNERACIONES PAGADAS Y DE RETENCION DE IRPF"
	#define STR0017 "Ejecute la opcion del compatibilizador referente a los Ajustes para Dirf 2012 - Fase3. Para mas informacion, verifique el respectivo Boletin Tecnico."
	#define STR0018 "Valor bruto pago referente PLR: "
	#define STR0019 "El total informado en la linea 03 del Cuadro 5 incluye el valor total pagado a titulo de PLR correspondiente a"
	#define STR0020 "Departamento"
#else
	#ifdef ENGLISH
		#define STR0001 "Income Report"
		#define STR0002 "Will be printed according to parameters requested by the  "
		#define STR0003 "User.   "
		#define STR0004 "Registrat"
		#define STR0005 "C.N.P.J."
		#define STR0006 "White "
		#define STR0007 "Administration"
		#define STR0008 " STATEMENT ON INCOME REPORT  "
		#define STR0009 "Code not Registered Table    37                       "
		#define STR0010 "Code not registered table    37                       "
		#define STR0011 "Cost Center"
		#define STR0012 "Selecting Records..."
		#define STR0013 "Beneficiary "
		#define STR0014 "Attention"
		#define STR0015 "Outdated tables. Run the updater."
		#define STR0016 "RECEIPT OF INCOME PAID AND IRPF WITHHOLDING"
		#define STR0017 "Run the compatibility program option related to Adjustments for Dirf 2012 - Stage3. For further information, check the respective Technical Bulletin."
		#define STR0018 "Gross value paid in relation to PLR: "
		#define STR0019 "Total indicated in row 03 of Chart 5 already add total value paid to PLR bill corresponding to"
		#define STR0020 "Department"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Declara��o De Rendimentos", "Informe de Rendimentos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Sera impresso de acordo com os par�metro s solicitados pelo", "Ser� impresso de acordo com os par�metros solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "usu�rio." )
		#define STR0004 "Matr�cula"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Nr. contribuinte.", "C.N.P.J." )
		#define STR0006 "Branco"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administra��o" )
		#define STR0008 " RELA��O DO INFORME RENDIMENTO "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "C�digo n�o registado tabela 37                       ", "C�digo nao Cadastrado Tabela 37                       " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "C�digo n�o registado tabela 37                       ", "C�digo nao Cadastrado Tabela 37                       " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Centro De Custo", "Centro de Custo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0013 "Benefici�rio"
		#define STR0014 "Aten��o"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Tabelas desactualizadas. executar o actualizador", "Tabelas desatualizadas. Execute o atualizador" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Comprovativo De Rendimentos Pagos E De Reten��o De Irpf Imposto De Renda Pessoa F�sica ", "COMPROVANTE DE RENDIMENTOS PAGOS E DE RETEN��O DE IRPF" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Execute a op��o do compatibilizador referente aos Ajustes para Dirf 2012 - Fase3. Para mais informa��es, verifique o respectivo Boletim T�cnico.", "Execute a op��o do compatibilizador referente aos Ajustes para Dirf 2012 - Fase3. Para maiores informa��es, verifique o respectivo Boletim T�cnico." )
		#define STR0018 "Valor bruto pago referente PLR: "
		#define STR0019 "O total informado na linha 03 do Quadro 5 j� inclui o valor total pago a t�tulo de PLR correspondente a"
		#define STR0020 "Departamento"
	#endif
#endif
