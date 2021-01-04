#ifdef SPANISH
	#define STR0001 "Enero"
	#define STR0002 "Febrero"
	#define STR0003 "Marzo"
	#define STR0004 "Abril"
	#define STR0005 "Mayo"
	#define STR0006 "Junio"
	#define STR0007 "Julio"
	#define STR0008 "Agosto"
	#define STR0009 "Septiembre"
	#define STR0010 "Octubre"
	#define STR0011 "Noviembre"
	#define STR0012 "Diciembre"
	#define STR0013 "Aumento salarial - Mes y ano"
	#define STR0014 "Aumento salarial en el mes y acumulado en el ano(%)."
	#define STR0015 "Tiempo medio de aumento salarial"
	#define STR0016 "Numero de empleados"
	#define STR0017 "Numero de empleados por situacion."
	#define STR0018 "Progresion de sueldos en el ano"
	#define STR0019 "Indice de progresion de sueldos en el ano."
	#define STR0020 "Indice de valores salariales (Comparativo)"
	#define STR0021 "No existen datos por mostrarse"
	#define STR0022 "Mes"
	#define STR0023 "Ano"
	#define STR0024 "Dias"
	#define STR0025 "Matricula"
	#define STR0026 "Nombre"
	#define STR0027 "Activos"
	#define STR0028 "Vacaciones"
	#define STR0029 "De licencias"
	#define STR0030 "Despedidos"
	#define STR0031 "Empleados por situacion:"
	#define STR0032 "Empleados"
	#define STR0033 "Meses"
	#define STR0034 "En este panel se muestran porcentajes de aumentos salariales en el mes de referencia y acumulado en el ano."
	#define STR0035 "Donde el sistema selecciona todos los empleados que recibieron aumento en el periodo (mes/ano) y calcula el promedio."
	#define STR0036 "En este panel se muestra el tiempo medio entre aumentos salariales en el periodo determinado por el usuario."
	#define STR0037 "En este panel se muestran los numeros de empleados en las situaciones: Activos, Vacaciones, De licencia y Despedidos."
	#define STR0038 "En este panel se muestra el porcentaje medio de aumento salarial en cada mes del ano, hasta el mes de referencia."
	#define STR0039 "En este panel se muestra el indice  de valores salariales pagados en el ano en comparacion al ano anterior."
	#define STR0040 "Porcentaje de aumento salarial en el ano anterior (entero)"
	#define STR0041 "Porcentaje de aumento salarial en el ano hasta el mes de referencia"
#else
	#ifdef ENGLISH
		#define STR0001 "January"
		#define STR0002 "February"
		#define STR0003 "March"
		#define STR0004 "April"
		#define STR0005 "May"
		#define STR0006 "June"
		#define STR0007 "July"
		#define STR0008 "August"
		#define STR0009 "September"
		#define STR0010 "October"
		#define STR0011 "November"
		#define STR0012 "December"
		#define STR0013 "Salare raise - Month and year"
		#define STR0014 "Salary raise in month and accrued in year (%)."
		#define STR0015 "Salary raise average time"
		#define STR0016 "Number of employees"
		#define STR0017 "Number of employees by status."
		#define STR0018 "Progress of salaries during the year"
		#define STR0019 "Index of salary progress in the year."
		#define STR0020 "Index of salary amounts (Comparison)"
		#define STR0021 "No information to be displayed"
		#define STR0022 "Month"
		#define STR0023 "Year"
		#define STR0024 "Days"
		#define STR0025 "Registration"
		#define STR0026 "Name"
		#define STR0027 "Active"
		#define STR0028 "Vacation"
		#define STR0029 "On leave"
		#define STR0030 "Dismissed"
		#define STR0031 "Employees by status:"
		#define STR0032 "Employees"
		#define STR0033 "Months"
		#define STR0034 "In this dashboard are displayed the percentages of salary raises in the referred month and accrued in the year."
		#define STR0035 "Where the system lists all the employees that will get a salary raise in the period (month/year) and calculates the average."
		#define STR0036 "In this dashboard is displayed the average time between salary raises in the period determined by the user."
		#define STR0037 "In this dashboard are displayed the number of employees with status: Active, Vacation, On leave and Dismissed."
		#define STR0038 "In this dashboard is displayed the average percentage of salary raise in each month of the year up to the referred month."
		#define STR0039 "In this dashboard is displayed the index of salary amounts paid in the year confronted with the previous year."
		#define STR0040 "Percentage of salary raise during the previous year (whole)"
		#define STR0041 "Percentage of salary raise during year up to the referred month"
	#else
		#define STR0001 "Janeiro"
		#define STR0002 "Fevereiro"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Marco", "Mar�o" )
		#define STR0004 "Abril"
		#define STR0005 "Maio"
		#define STR0006 "Junho"
		#define STR0007 "Julho"
		#define STR0008 "Agosto"
		#define STR0009 "Setembro"
		#define STR0010 "Outubro"
		#define STR0011 "Novembro"
		#define STR0012 "Dezembro"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Aumento salarial - m�s e ano", "Aumento Salarial - M�s e Ano" )
		#define STR0014 "Aumento salarial no m�s e acumulado no ano(%)."
		#define STR0015 "Tempo m�dio de aumento salarial"
		#define STR0016 "N�mero de funcion�rios"
		#define STR0017 "N�mero de funcion�rios por situa��o."
		#define STR0018 "Progress�o dos sal�rios no ano"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "�ndice de progress�o dos sal�rios no ano.", "�ndice de progress�o dos sal�rios no ano." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "�ndice de valores salariais (comparativo)", "�ndice de valores salariais (Comparativo)" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "N�o h� dados para serem exibidos", "N�o h� dados a serem exibidos" )
		#define STR0022 "M�s"
		#define STR0023 "Ano"
		#define STR0024 "Dias"
		#define STR0025 "Matr�cula"
		#define STR0026 "Nome"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Activos", "Ativos" )
		#define STR0028 "F�rias"
		#define STR0029 "Afastados"
		#define STR0030 "Demitidos"
		#define STR0031 "Funcion�rios por situa��o:"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Empregados", "Funcion�rios" )
		#define STR0033 "Meses"
		#define STR0034 "Neste painel s�o apresentados percentuais de aumentos salariais no m�s de refer�ncia e acumulado no ano."
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Onde o m�dulo selecciona todos os funcion�rios que receberam aumento no per�odo (m�s/ano) e calcula a m�dia.", "Onde o sistema seleciona todos os funcion�rios que receberam aumento no per�odo (m�s/ano) e calcula a m�dia." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Neste painel � apresentado o tempo m�dio entre aumentos salariais no per�odo determinado pelo utilizador.", "Neste painel � apresentado o tempo m�dio entre aumentos salariais no per�odo determinado pelo usu�rio." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Neste painel s�o apresentados os n�meros de funcion�rios nas situa��es: activos, f�rias, afastados e demitidos.", "Neste painel s�o apresentados os n�meros de funcion�rios nas situa��es: Ativos, F�rias, Afastados e Demitidos." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Neste painel � apresentada a percentagem m�dia de aumento salarial em cada m�s do ano, at� ao m�s de refer�ncia.", "Neste painel � apresentado o percentual m�dio de aumento salarial em cada m�s do ano, at� o m�s de refer�ncia." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Neste painel � apresentado o �ndice  de valores salariais pagos no ano em compara��o com o ano anterior.", "Neste painel � apresentado  �ndice  de valores salariais pagos no ano em compara��o ao ano anterior." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Percentagem de aumento salarial no ano anterior (inteiro)", "Percentual de aumento salarial no ano anterior (inteiro)" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Percentagem de aumento salarial no ano at� ao m�s de refer�ncia", "Percentual de aumento salarial no ano at� o m�s de refer�ncia" )
	#endif
#endif
