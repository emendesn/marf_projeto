#ifdef SPANISH
	#define STR0001 "Ficha de remisión manual"
	#define STR0002 "Ficha de remisión"
	#define STR0003 "Modificar"
	#define STR0004 "Ficha de remisión"
	#define STR0005 "Registros no se posicionaron o se encontraron para actualización con el número de la ficha de remisión"
	#define STR0006 "Entre en contacto con el administrador del sistema"
	#define STR0007 "Sumatoria de los asientos de ingresos"
	#define STR0008 "Sumatoria de los asientos de gastos"
	#define STR0009 "Diferencia entre ingresos y gastos"
	#define STR0010 "Total ingresos"
	#define STR0011 "Total de gastos"
	#define STR0012 "Sumatoria de los asientos de ingresos"
	#define STR0013 "Total gastos"
	#define STR0014 "Total de gastos"
	#define STR0015 "Sumatoria de los asientos de gastos"
	#define STR0016 "Remisión neta"
	#define STR0017 "Remisión neta"
	#define STR0018 "Diferencia entre ingresos y gastos"
	#define STR0019 "Carga de datos"
#else
	#ifdef ENGLISH
		#define STR0001 "Manual Remittance Form"
		#define STR0002 "Remittance Form"
		#define STR0003 "Edit"
		#define STR0004 "Remittance Form"
		#define STR0005 "Records were not positioned or found to be updated with the remittance form number"
		#define STR0006 "Contact the System administrator"
		#define STR0007 "Sum of Income Entries"
		#define STR0008 "Sum of Expenditure Entries"
		#define STR0009 "Difference between Income and Expenditures"
		#define STR0010 "Total Incomes"
		#define STR0011 "Total Income"
		#define STR0012 "Sum of Income Entries"
		#define STR0013 "Total Expenses"
		#define STR0014 "Expenses Total"
		#define STR0015 "Sum of Expenditure Entries"
		#define STR0016 "Net Remittance"
		#define STR0017 "Net Remittance"
		#define STR0018 "Difference between Income and Expenditures"
		#define STR0019 "Data Load"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Ficha de Remessa Manual" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Ficha de Remessa" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Ficha de Remessa" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Registros não foram posicionados ou encontrados para serem atualizados com o número da ficha de remessa" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Entre em contato com o administrador do sistema" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Somatória dos Lançamentos de Receita" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Somatória dos Lançamentos de Despesa" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Diferença entre Receitas e Despesas" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Total Receitas" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Total de Receita" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Somatória dos Lançamentos de Receita" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Total Despesas" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Total de Despesas" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Somatória dos Lançamentos de Despesa" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Remessa Liquida" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Remessa Liquida" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Diferença entre Receitas e Despesas" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Carga de Dados" )
	#endif
#endif
