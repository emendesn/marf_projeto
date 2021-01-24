#ifdef SPANISH
	#define STR0001 "Asientos"
	#define STR0002 "Asiento financiero sin ficha"
	#define STR0003 "Asiento financiero con ficha"
	#define STR0004 "Asientos"
	#define STR0005 "Asientos"
	#define STR0006 "Asientos"
	#define STR0007 "Rendición de cuentas"
	#define STR0008 "Asientos de ingresos"
	#define STR0009 "Asientos de gastos"
	#define STR0010 "Totales"
	#define STR0011 "Incluir"
	#define STR0012 "Modificar"
	#define STR0013 "Borrar"
	#define STR0014 "Imprimir"
	#define STR0015 "Sucursal del sistema"
	#define STR0016 "Código de la agencia."
	#define STR0017 "Nombre de la Agencia"
	#define STR0018 "Fecha de Movimiento"
	#define STR0019 "Total de ingresos"
	#define STR0020 "Total de gastos"
	#define STR0021 "Total resultante (ingresos - gastos)"
	#define STR0022 "Sucursal del sistema"
	#define STR0023 "Código del asiento"
	#define STR0024 "Código del asiento"
	#define STR0025 "Agencia"
	#define STR0026 "Código de la agencia"
	#define STR0027 "Código de la agencia"
	#define STR0028 "Nombre de la Agencia"
	#define STR0029 "Nombre de la Agencia"
	#define STR0030 "Fecha de movimiento"
	#define STR0031 "Fecha de movimiento"
	#define STR0032 "Total de ingresos"
	#define STR0033 "Total de ingresos"
	#define STR0034 "Total de gastos"
	#define STR0035 "Total de gastos"
	#define STR0036 "Total (ingresos - gastos)"
	#define STR0037 "Total (ingresos - gastos)"
#else
	#ifdef ENGLISH
		#define STR0001 "Entries"
		#define STR0002 "Finance Entries without form"
		#define STR0003 "Finance Entries with form"
		#define STR0004 "Entries"
		#define STR0005 "Entries"
		#define STR0006 "Entries"
		#define STR0007 "Rendering of Accounts"
		#define STR0008 "Income Entries"
		#define STR0009 "Expenditure Entries"
		#define STR0010 "Totals"
		#define STR0011 "Add"
		#define STR0012 "Edit"
		#define STR0013 "Delete"
		#define STR0014 "Print"
		#define STR0015 "System Branch"
		#define STR0016 "Bank Branch Code"
		#define STR0017 "Branch Name"
		#define STR0018 "Transaction Date"
		#define STR0019 "Income Total"
		#define STR0020 "Expenses Total"
		#define STR0021 "Resulting total (incomes - expenditures)"
		#define STR0022 "System Branch"
		#define STR0023 "Entry Code"
		#define STR0024 "Entry Code"
		#define STR0025 "Branch"
		#define STR0026 "Branch Code"
		#define STR0027 "Branch Code"
		#define STR0028 "Branch Name"
		#define STR0029 "Branch Name"
		#define STR0030 "Transaction Date"
		#define STR0031 "Transaction Date"
		#define STR0032 "Income Total"
		#define STR0033 "Income Total"
		#define STR0034 "Expenses Total"
		#define STR0035 "Expenses Total"
		#define STR0036 "Total (Incomes - Expenditures)"
		#define STR0037 "Total (Incomes - Expenditures)"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Lançamentos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Lançamento Financeiro sem ficha" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Lançamento Financeiro com ficha" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Lancamentos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Lancamentos" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Lançamentos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Prestacao de Contas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Lancamentos de Receitas" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Lancamentos de Despesas" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Totais" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Imprimir" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Filial de Sistema" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Código da Agência" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Nome da Agência" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Data de Movimento" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Total de Receitas" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Total de Despesas" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Total resultante (receitas - despesas)" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Filial de Sistema" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Código do Lançamento" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Código do Lançamento" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Agência" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Código da Agência" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Código da Agência" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Nome da Agência" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Nome da Agência" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Data de Movimento" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Data de Movimento" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Total de Receitas" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Total de Receitas" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Total de Despesas" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Total de Despesas" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Total (Receitas - Despesas)" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Total (Receitas - Despesas)" )
	#endif
#endif
