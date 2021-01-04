#ifdef SPANISH
	#define STR0001 "Importacion de valores variables"
	#define STR0002 "Esta rutina importa valores para los archivos de movimiento mensual,"
	#define STR0003 "Confirma"
	#define STR0004 "Reescribe"
	#define STR0005 "Salir"
	#define STR0006 "Continua"
	#define STR0007 "Salir"
	#define STR0008 "Este programa importa asiento de valores variables "
	#define STR0009 "Codigo no registrado"
	#define STR0010 "Valores extras y aguinaldo, segun lo definido en el parametro 2     "
	#define STR0011 "Condicion del codigo "
	#define STR0012 "no esta devolviendo un valor logico"
	#define STR0013 "Condicion: "
	#define STR0014 "Formula invalida"
	#define STR0015 "Campo sucursal: "
	#define STR0016 "Campo matricula: "
	#define STR0017 "Empleado no registrado"
	#define STR0018 "Linea: "
	#define STR0019 "Campo C. Costo: "
	#define STR0020 "Campo Concepto: "
	#define STR0021 "Concepto no registrado"
	#define STR0022 "Sucursal + Concepto: "
	#define STR0023 "Campo Tipo del Concepto: "
	#define STR0024 "Campo Horas: "
	#define STR0025 "Campo Valor: "
	#define STR0026 "Campo Semana: "
	#define STR0027 "Campo Cuota: "
	#define STR0028 "Empleados importados"
	#define STR0029 "Linea  Matricula                             Concepto                  Horas          Valor Semana Cuota   Fecha Pago Fch Ref "
	#define STR0030 "Invalido "
	#define STR0031 "Ningun registro se ajusto a la condicion del filtro"
	#define STR0032 "Campo Fecha "
	#define STR0033 "Empleado Despedido "
	#define STR0034 "Empleados no Importados ( CENTRO DE COSTOS INVALIDO )"
	#define STR0035 "Concepto no permite cantidad para asiento"
	#define STR0036 "Campo Fecha de referencia"
	#define STR0037 "Importación de variables - ¿Coparticipacion/Reembolso? "
	#define STR0038 "Antes de proseguir, es necesario ejecutar los procedimientos del Boletín técnico de Importación de coparticipación"
	#define STR0039 "Ok"
	#define STR0040 "Atención"
#else
	#ifdef ENGLISH
		#define STR0001 "Import of Variable Values"
		#define STR0002 "These routines import values to Monthly Transaction files"
		#define STR0003 "Confirm"
		#define STR0004 "Retype"
		#define STR0005 "Quit"
		#define STR0006 "Continue"
		#define STR0007 "Quit"
		#define STR0008 "This program imports Variable Values Entries "
		#define STR0009 "Code not Registered"
		#define STR0010 "Extra Values and 13th Salary, as defined in Parameter 02     "
		#define STR0011 "Code status"
		#define STR0012 "is not returning the logical value"
		#define STR0013 "Status: "
		#define STR0014 "Invalid Formula"
		#define STR0015 "Branch Field: "
		#define STR0016 "Registration Field: "
		#define STR0017 "Employee not Registered"
		#define STR0018 "Row: "
		#define STR0019 "C.Center Field: "
		#define STR0020 "Funds Field: "
		#define STR0021 "Fund not registered"
		#define STR0022 "Branch+Funds: "
		#define STR0023 "Fund Type Field: "
		#define STR0024 "Hours Field: "
		#define STR0025 "Value Field: "
		#define STR0026 "Week Field: "
		#define STR0027 "Installment Field: "
		#define STR0028 "Imported Employees"
		#define STR0029 "Line  Registration                             Payroll Item                     Hours         Value Week Installment Date Paymt Ref.Dt "
		#define STR0030 " - Value: "
		#define STR0031 "No record served the filter status"
		#define STR0032 "Date Field "
		#define STR0033 "Employee dismissed   "
		#define STR0034 "Employees not imported (INVALID COST CENTER)"
		#define STR0035 "Line item does not enable amount for entry"
		#define STR0036 "Reference Date Field"
		#define STR0037 "Variable import - Coparticipation/Reimbursement? "
		#define STR0038 "Before proceeding, you must follow the procedures of the Technical Bulletin of Coparticipation Import"
		#define STR0039 "Ok"
		#define STR0040 "Warning"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Importação De Valores Variáveis", "Importacao de Valores Variaveis" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este Procedimento Importa Valores Para Os Ficheiros De Movimentação Mensal,", "Esta rotina importa valores para os arquivos de Movimentacao Mensal," )
		#define STR0003 "Confirma"
		#define STR0004 "Redigita"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0006 "Continua"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Este programa importa movimento de valores variáveis ", "Este programa Importa lancamento de Valores Variaveis " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Código não registado", "Codigo nao cadastrado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Valores extras e sub.de Natal, conforme definido no parâmetro 02     ", "Valores Extras e 13o Salario, conforme definido no Parametro 02     " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Condição do código ", "Condicao do codigo " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Não devolve valor lógico", "nao esta retornando valor logico" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Condição: ", "Condicao: " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Fórmula Inválida", "Formula Invalida" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Campo filial: ", "Campo Filial: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Campo registo: ", "Campo Matricula: " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Empregado não registado", "Funcionario nao cadastrado" )
		#define STR0018 "Linha: "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Campo c.custo: ", "Campo C.Custo: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Campo valor: ", "Campo Verba: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Valor não registado", "Verba nao cadastrada" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Filial+valor: ", "Filial+Verba: " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Campo tipo do valor: ", "Campo Tipo da Verba: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Campo horas: ", "Campo Horas: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Campo valor: ", "Campo Valor: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Campo semana: ", "Campo Semana: " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Campo parcela: ", "Campo Parcela: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Empregados Importados", "Funcionarios Importados" )
		#define STR0029 "Linha  Matricula                             Verba                     Horas          Valor Semana Parcela Data Pagto Dt.Ref "
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Inválido ", "Invalido " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Nenhum registo atendeu a condição de filtro", "Nenhum registro atendeu a condicao de filtro" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Campo data ", "Campo Data " )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Empregado demitido ", "Funcionario Demitido " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Empregados não Importados ( CENTRO DE CUSTOS INVÁLIDO )", "Funcionarios não Importados ( CENTRO DE CUSTOS INVÁLIDO )" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Verba não permite quantidade para lançamento.", "Verba não permite quantidade para lançamento" )
		#define STR0036 "Campo Data de Referencia"
		#define STR0037 "Importação de variáveis - Coparticipação/Reembolso? "
		#define STR0038 "Antes de prosseguir, é necessario executar os procedimentos do Boletim Técnico de Importação de Coparticipação"
		#define STR0039 "Ok"
		#define STR0040 "Atenção"
	#endif
#endif
