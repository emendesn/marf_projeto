#ifdef SPANISH
	#define STR0001 "Abono permanencia"
	#define STR0002 "Mantenimiento"
	#define STR0003 "Borrar"
	#define STR0004 "Registro del Derecho"
	#define STR0005 "El valor retroactivo debe ser igual a 0,00"
	#define STR0006 "Debe informarse el valor retroactivo. Utilice acciones relacionadas."
	#define STR0007 "Se debe informar la Fecha de pago."
	#define STR0008 "Se debe informar el numero de cuotas."
	#define STR0009 "Informe Fch.Ini.Pago y Fch.Ini.Derec"
	#define STR0010 "Valor retroactivo se efectuo con exito"
	#define STR0011 "No se encontro Valor retroactivo para el periodo de "
	#define STR0012 "¡Periodo en abierto no localizado!"
	#define STR0013 "Fecha informada debe ser mayor o igual al Periodo en Abierto - Cod.: "
	#define STR0014 "No se permite informar fecha de anos anteriores al del Periodo en Abierto - Cod.: "
	#define STR0015 "Calc.Retro"
	#define STR0016 "El valor retroactivo informado debe reflejar solo el total del ano del periodo en abierto. ¡Valores de anos anteriores deben pagarse por medio de RRA en rutina especifica!"
	#define STR0017 "¡Atencion!"
#else
	#ifdef ENGLISH
		#define STR0001 "Permanence Bonus"
		#define STR0002 "Maintenance"
		#define STR0003 "Delete"
		#define STR0004 "Registration of Rights"
		#define STR0005 "The retroactive amount must be set to 0.00"
		#define STR0006 "Retroactive Value must be entered. Use Related Features."
		#define STR0007 "Payment Date must be entered"
		#define STR0008 "Number of Installments must be entered"
		#define STR0009 "Enter St Date Payment and St Date Entitled"
		#define STR0010 "Retroactive Value not performed Successfully"
		#define STR0011 "Retroactive value not found for the period "
		#define STR0012 "Open Period not found!"
		#define STR0013 "Entered date must be greater or equal to the Outstanding Period - Cod.: "
		#define STR0014 "Not allowed enter date from previous years to the Outstanding Period - Code: "
		#define STR0015 "Retro.Calc"
		#define STR0016 "The entered Retroactive Value must reflect only the total of the year in an Outstanding Period. Amounts from previous years must be paid by RRA in specific routines!"
		#define STR0017 "Attention!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Abono Permanência" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Manutenção" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Cadastramento do Direito" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "O valor Retroativo deve ser igual a 0,00" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "O valor Retroativo deve ser informado. Utilize Ações Relacionadas." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Data de Pagamento deve ser informado" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Numero de parcelas deve ser informado" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Informar Dt.Ini.Pagto e Dt.Ini.Direi" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Valor Retroativo foi efetuado com Sucesso" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Valor retroativo não encontrado para o período de " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Periodo em Aberto não localizado!" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Data informada tem que ser maior ou igual ao Periodo em Aberto - Cód.: " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Não é permitido informar data de anos anteriores ao do Periodo em Aberto - Cód.: " )
		#define STR0015 "Calc.Retro"
		#define STR0016 "O Valor Retroativo informado deve refletir somente o total do ano do Período em Aberto. Valores de anos anteriores devem ser pagos por meio de RRA em rotina específica!"
		#define STR0017 "Atenção!"
	#endif
#endif
