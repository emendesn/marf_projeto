#ifdef SPANISH
	#define STR0001 "Plan. de Haber."
	#define STR0002 "Matricula"
	#define STR0003 "Nomb"
	#define STR0004 "Asientos"
	#define STR0005 "C.Costo Arch"
	#define STR0006 "C.Costo Mov."
	#define STR0007 "Depto."
	#define STR0008 "Lug.Pago"
	#define STR0009 "Imprime la Planilla de Haberes, de acuerdo con los param. solicit. por el usuario."
	#define STR0010 "Proceso / Periodo"
	#define STR0011 "Empresa:"
	#define STR0012 "Tipo de Contrato:"
	#define STR0013 "Indeterminado"
	#define STR0014 "Determinado"
	#define STR0015 "Ambos"
	#define STR0016 "Proceso:"
	#define STR0017 "Periodo:"
	#define STR0018 "Pago:"
	#define STR0019 "Fch.Per.:"
	#define STR0020 "Fch.Pago:"
	#define STR0021 "Func."
	#define STR0022 "Suel.:"
	#define STR0023 "Porc.Ant.: "
	#define STR0024 "       R E M U N E R A C.                            D E S C U E N T O S                           B A S E S"
	#define STR0025 "       R E M U N E R A C.                            D E S C U E N T.  "
	#define STR0026 "Concept. del Empl."
	#define STR0027 "Cod."
	#define STR0028 "Descrip."
	#define STR0029 "Ref."
	#define STR0030 "Valor"
	#define STR0031 "No se  encontro ningun periodo."
	#define STR0032 "Verifique Parametros de Impres."
	#define STR0033 "Analitico"
	#define STR0034 "Sintetico"
	#define STR0035 " de "
	#define STR0036 "Sucursal / Emplead."
	#define STR0037 "Total. Empleado "
	#define STR0038 "Total Suc."
	#define STR0039 "Neto:"
	#define STR0040 "Suc. / Nombre"
	#define STR0041 "C.Costo Arch."
	#define STR0042 "Total C.Costo"
	#define STR0043 "Remuner."
	#define STR0044 "Descuent."
	#define STR0045 "Bases"
	#define STR0046 "Departamento"
	#define STR0047 "Total Departamento"
	#define STR0048 "C.Costo Movim."
	#define STR0049 "Localidad Pago"
	#define STR0050 "Total Local. Pago"
	#define STR0051 "Arquitectura Organizativa - "
	#define STR0052 "Visual:"
	#define STR0053 "Dif. Netos: "
	#define STR0054 "Dif. Netos de Empleado: "
	#define STR0055 "Suc.: "
	#define STR0056 "Total de Emplead. Impresos: "
	#define STR0057 "Item Contab."
	#define STR0058 "Clase de Valor"
	#define STR0059 "Total Unidad de Negocios:"
	#define STR0060 "Total Empresa:"
	#define STR0061 "Total Item Contab."
	#define STR0062 "Total Clase de Valor"
#else
	#ifdef ENGLISH
		#define STR0001 "Payroll"
		#define STR0002 "Registration"
		#define STR0003 "Name"
		#define STR0004 "Entries"
		#define STR0005 "C Cost Registration"
		#define STR0006 "C. Cost Transaction"
		#define STR0007 "Department"
		#define STR0008 "Payment Location"
		#define STR0009 "Prints the Payroll, according to parameters requested by the us�er."
		#define STR0010 "Process/Period"
		#define STR0011 "Company:"
		#define STR0012 "Type of contract:"
		#define STR0013 "Indeterminate"
		#define STR0014 "Determinate"
		#define STR0015 "Both"
		#define STR0016 "Process:"
		#define STR0017 "Period:"
		#define STR0018 "Payment:"
		#define STR0019 "Period Date:"
		#define STR0020 "Payment Date:"
		#define STR0021 "Position"
		#define STR0022 "Salary: "
		#define STR0023 "Advancement Percentage: "
		#define STR0024 "       EARNINGS                            D ISCOUNTS                            B A S E S"
		#define STR0025 "       EARNINGS                            D ISCOUNTS "
		#define STR0026 "Employee Resources"
		#define STR0027 "Code of"
		#define STR0028 "Description"
		#define STR0029 "Reference"
		#define STR0030 "Value"
		#define STR0031 "No period was found"
		#define STR0032 "Check Printing Parameters"
		#define STR0033 "Detailed"
		#define STR0034 "Summarized"
		#define STR0035 " of  "
		#define STR0036 "Branch/Employee"
		#define STR0037 "Employee Totals "
		#define STR0038 "Branch Total"
		#define STR0039 "Net:"
		#define STR0040 "Branch/name "
		#define STR0041 "C. Cost Registration"
		#define STR0042 "C. Cost Total"
		#define STR0043 "Earnings"
		#define STR0044 "Discounts"
		#define STR0045 "Bases"
		#define STR0046 "Department"
		#define STR0047 "Department Total"
		#define STR0048 "C. Cost Transaction"
		#define STR0049 "Payment Location"
		#define STR0050 "Location Total Payment"
		#define STR0051 "Organizational Architecture "
		#define STR0052 "Vision: "
		#define STR0053 "Dif. Net: "
		#define STR0054 "Dif. Employee Net: "
		#define STR0055 "Branch: "
		#define STR0056 "Total of Employees Printed: "
		#define STR0057 "Accounting Item"
		#define STR0058 "Value Class"
		#define STR0059 "Total Business Unit:"
		#define STR0060 "Company total:"
		#define STR0061 "Accounting Item Total"
		#define STR0062 "Value Class Total"
	#else
		#define STR0001 "Folha de Pagamento"
		#define STR0002 "Matr�cula"
		#define STR0003 "Nome"
		#define STR0004 "Lan�amentos"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "C.Custo Registo", "C.Custo Cad." )
		#define STR0006 "C.Custo Mov."
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Dep.", "Depto." )
		#define STR0008 "Loc.Pago"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Imprime a Folha de Pagamento, de acordo com os par�metros solicitados pelo utilizador.", "Imprime a Folha de Pagamento, de acordo com os par�metros solicitados pelo usu�rio." )
		#define STR0010 "Processo / Per�odo"
		#define STR0011 "Empresa:"
		#define STR0012 "Tipo de Contrato:"
		#define STR0013 "Indeterminado"
		#define STR0014 "Determinado"
		#define STR0015 "Ambos"
		#define STR0016 "Processo:"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Per�odo:", "Periodo:" )
		#define STR0018 "Pagamento:"
		#define STR0019 "Dt.Per�odo:"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Dt.Pgt:", "Dt.Pagto:" )
		#define STR0021 "Fun��o"
		#define STR0022 "Sal.: "
		#define STR0023 "Perc.Adto.: "
		#define STR0024 "       P R O V E N T O S                             D E S C O N T O S                             B A S E S"
		#define STR0025 "       P R O V E N T O S                             D E S C O N T O S "
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Verbas do Empregado", "Verbas do Funcion�rio" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "C�d.", "Cod." )
		#define STR0028 "Descri��o"
		#define STR0029 "Ref."
		#define STR0030 "Valor"
		#define STR0031 "N�o foi encontrado nenhum per�odo."
		#define STR0032 "Verifique Par�metros de Impress�o."
		#define STR0033 "Anal�tico"
		#define STR0034 "Sint�tico"
		#define STR0035 " de "
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Filial / Empregado", "Filial / Funcion�rio" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Totais Empregado ", "Totais Funcion�rio " )
		#define STR0038 "Total Filial"
		#define STR0039 "L�quido:"
		#define STR0040 "Filial / Nome "
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "C.Custo Registo", "C.Custo Cadastro" )
		#define STR0042 "Total C.Custo"
		#define STR0043 "Proventos"
		#define STR0044 "Descontos"
		#define STR0045 "Bases"
		#define STR0046 "Departamento"
		#define STR0047 "Total Departamento"
		#define STR0048 "C.Custo Movimento"
		#define STR0049 "Localidade Pagamento"
		#define STR0050 "Total Local. Pagamento"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Arquitectura Organizacional - ", "Arquitetura Organizacional - " )
		#define STR0052 "Vis�o: "
		#define STR0053 "Dif. L�quidos: "
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "Dif. L�quidos do Empregado: ", "Dif. L�quidos do Funcion�rio: " )
		#define STR0055 "Filial: "
		#define STR0056 If( cPaisLoc $ "ANG|PTG", "Total de Empregados Impressos: ", "Total de Funcion�rios Impressos: " )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Item Contabil�stico", "Item Cont�bil" )
		#define STR0058 "Classe de Valor"
		#define STR0059 If( cPaisLoc $ "ANG|PTG", "Total Unidade de Neg�cios:", "Total Unidade de Negocios:" )
		#define STR0060 "Total Empresa:"
		#define STR0061 If( cPaisLoc $ "ANG|PTG", "Total Item Contabil�stico", "Total Item Cont�bil" )
		#define STR0062 "Total Classe de Valor"
	#endif
#endif
