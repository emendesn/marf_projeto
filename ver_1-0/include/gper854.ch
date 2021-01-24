#ifdef SPANISH
	#define STR0001 "Informe Trimestral Mintra"
	#define STR0002 "Se imprimira de acuerdo con los param. solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "Informe Mintra"
	#define STR0005 "A Rayas"
	#define STR0006 "Administrac."
	#define STR0007 "Espere..."
	#define STR0008 "Procesando Informe Trimestral"
	#define STR0009 "1�TRIMESTRE"
	#define STR0010 "2�TRIMESTRE"
	#define STR0011 "3�TRIMESTRE"
	#define STR0012 "4�TRIMESTRE"
	#define STR0013 "ENERO"
	#define STR0014 "FEBRERO"
	#define STR0015 "MARZO"
	#define STR0016 "ABRIL"
	#define STR0017 "MAYO"
	#define STR0018 "JUNIO"
	#define STR0019 "JULIO"
	#define STR0020 "AGOSTO"
	#define STR0021 "SEPTIEM"
	#define STR0022 "OCTUBRE"
	#define STR0023 "NOVIEMB."
	#define STR0024 "DICIEMB."
	#define STR0025 "MINISTERIO DE TRABAJO"
	#define STR0026 "DEL ANO DE "
	#define STR0027 "LISTA DE HORAS DEL MES "
	#define STR0028 " DE "
	#define STR0029 "N� Empleado"
	#define STR0030 "N� Hrs. Dia Trab."
	#define STR0031 "N� Dias por Mes"
	#define STR0032 "N� Total Horas"
	#define STR0033 "Procesando Mes de "
	#define STR0034 "del Ano de "
	#define STR0035 "Procesando Totalizacion Trimestral por departamento..."
	#define STR0036 "Cargando..."
	#define STR0037 "Imrimiendo.."
	#define STR0038 "No se encontraron datos de acuerdo con el parametro."
	#define STR0039 "Atenc."
	#define STR0040 "EMPLEADO DEL SEXO FEMENINO EN EL MES DE "
	#define STR0041 "EMPLEADO DEL SEXO MASCULINO DEL MES DE "
	#define STR0042 "EMPLEADO POR DEPARTAMENTO DEL MES DE "
	#define STR0043 "TOTAL GRAL."
	#define STR0044 "DEPARTAMENTO"
	#define STR0045 "CARGO"
	#define STR0046 "SALDO DE SUELDO"
	#define STR0047 "SOBRENOME"
	#define STR0048 "NOME"
	#define STR0049 "INGRES."
	#define STR0050 "SUELDO"
	#define STR0051 "CARGO"
	#define STR0052 "TOTAL"
	#define STR0053 "TOTAL TRIMESTRAL POR DEPARTAMENTO DEL"
	#define STR0054 "NO DEFINIDO"
	#define STR0055 "Pagina: "
	#define STR0056 "No hay informaciones por generarse.Verifique los par�metros"
	#define STR0057 "Aguarde"
#else
	#ifdef ENGLISH
		#define STR0001 "Mintra Quarterly Report"
		#define STR0002 "It will be printed in accordance with the parameters requested by the"
		#define STR0003 "user."
		#define STR0004 "Mintra Report"
		#define STR0005 "Z-form"
		#define STR0006 "Management"
		#define STR0007 "Please, wait..."
		#define STR0008 "Processing Quarterly Report"
		#define STR0009 "1st QUARTER"
		#define STR0010 "2nd QUARTER"
		#define STR0011 "3rd QUARTER"
		#define STR0012 "4th QUARTER"
		#define STR0013 "JANUARY"
		#define STR0014 "FEBRUARY"
		#define STR0015 "MARCH"
		#define STR0016 "APRIL"
		#define STR0017 "MAY"
		#define STR0018 "JUNE"
		#define STR0019 "JULY"
		#define STR0020 "AUGUST"
		#define STR0021 "SEPTEMBER"
		#define STR0022 "OCTOBER"
		#define STR0023 "NOVEMBER"
		#define STR0024 "DECEMBER"
		#define STR0025 "MINISTRY OF LABOR"
		#define STR0026 " OF THE YEAR OF "
		#define STR0027 "RELATION OF HOURS OF THE MONTH "
		#define STR0028 " OF "
		#define STR0029 "Nr. Employee"
		#define STR0030 "Nr. Hr. Work Day"
		#define STR0031 "Nr. Days per Month"
		#define STR0032 "Nr. Total Hours"
		#define STR0033 "Processing Month of "
		#define STR0034 " of the Year of "
		#define STR0035 "Processing Quarterly Total by department..."
		#define STR0036 "Loading..."
		#define STR0037 "Printing..."
		#define STR0038 "No data were found in accordance with the parameter."
		#define STR0039 "Attention"
		#define STR0040 "FEMALE EMPLOYEE OF THE MONTH OF "
		#define STR0041 "MALE EMPLOYEE OF THE MONTH OF "
		#define STR0042 "EMPLOYEE PER DEPARTMENT OF THE MONTH OF "
		#define STR0043 "GRAND TOTAL"
		#define STR0044 "DEPARTMENT"
		#define STR0045 "POSITION"
		#define STR0046 "SALARY BALANCE"
		#define STR0047 "NICKNAME"
		#define STR0048 "NAMES"
		#define STR0049 "ADMISSION"
		#define STR0050 "SALARY"
		#define STR0051 "POSITION"
		#define STR0052 "TOTAL"
		#define STR0053 "QUARTERLY TOTAL PER DEPARTMENT OF THE "
		#define STR0054 "NON-DEFINED"
		#define STR0055 "Page: "
		#define STR0056 "There is no information to be generated. Check the parameters"
		#define STR0057 "Please, wait"
	#else
		#define STR0001 "Informe Trimestral Mintra"
		#define STR0002 If( cPaisLoc $ "VEN|ANG|PTG", "Ser� impresso de acordo com os par�metros solicitados pelo", "Ser� impresso de acordo com os parametros solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "VEN|ANG|PTG", "utilizador.", "usuario." )
		#define STR0004 If( cPaisLoc $ "VEN|ANG|PTG", "Relat�rio Mintra", "Relatorio Mintra" )
		#define STR0005 If( cPaisLoc $ "VEN|ANG|PTG", "C�digo de Barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "VEN|ANG|PTG", "Administra��o", "Administracao" )
		#define STR0007 "Aguarde..."
		#define STR0008 If( cPaisLoc $ "VEN|ANG|PTG", "A processar Informe Trimestral", "Processando Informe Trimestral" )
		#define STR0009 "1�TRIMESTRE"
		#define STR0010 "2�TRIMESTRE"
		#define STR0011 "3�TRIMESTRE"
		#define STR0012 "4�TRIMESTRE"
		#define STR0013 "JANEIRO"
		#define STR0014 "FEVEREIRO"
		#define STR0015 "MARCO"
		#define STR0016 "ABRIL"
		#define STR0017 "MAIO"
		#define STR0018 "JUNHO"
		#define STR0019 "JULHO"
		#define STR0020 "AGOSTO"
		#define STR0021 If( cPaisLoc $ "VEN|ANG|PTG", "SETEMBRO", "SETEMBOR" )
		#define STR0022 "OUTUBRO"
		#define STR0023 "NOVEMBRO"
		#define STR0024 "DEZEMBRO"
		#define STR0025 If( cPaisLoc $ "VEN|ANG|PTG", "MINIST�RIO DO TRABALHO", "MINISTERIO DO TRABALHO" )
		#define STR0026 " DO ANO DE "
		#define STR0027 If( cPaisLoc $ "VEN|ANG|PTG", "RELA��O DE HORAS DO M�S ", "RELACAO DE HORAS DO MES " )
		#define STR0028 " DE "
		#define STR0029 If( cPaisLoc $ "VEN|ANG|PTG", "Nr. Empregado", "Nro. Empregado" )
		#define STR0030 If( cPaisLoc $ "VEN|ANG|PTG", "Nr. Hrs. Dia Trab.", "Nro. Hrs. Dia Trab." )
		#define STR0031 If( cPaisLoc $ "VEN|ANG|PTG", "Nr. Dias por M�s", "Nro. Dias por Mes" )
		#define STR0032 If( cPaisLoc $ "VEN|ANG|PTG", "Nr. Total Horas", "Nro. Total Horas" )
		#define STR0033 If( cPaisLoc $ "VEN|ANG|PTG", "A processar M�s de ", "Processando Mes de " )
		#define STR0034 " do Ano de "
		#define STR0035 If( cPaisLoc $ "VEN|ANG|PTG", "A processar Totaliza��o Trimestral por departamento...", "Processando Totalizacao Trimestral por departamento..." )
		#define STR0036 If( cPaisLoc $ "VEN|ANG|PTG", "A carregar...", "Carregando..." )
		#define STR0037 If( cPaisLoc $ "VEN|ANG|PTG", "A imrimir...", "Imrimindo..." )
		#define STR0038 If( cPaisLoc $ "VEN|ANG|PTG", "N�o foram encontrados dados de acordo com o par�metro.", "Nao foram encontrados dados de acordo com o parametro." )
		#define STR0039 If( cPaisLoc $ "VEN|ANG|PTG", "Aten��o", "Atencao" )
		#define STR0040 If( cPaisLoc $ "VEN|ANG|PTG", "EMPREGADO DO SEXO FEMINININO DO M�S DE ", "FUNCIONARIO DO SEXO FEMINININO DO MES DE " )
		#define STR0041 If( cPaisLoc $ "VEN|ANG|PTG", "EMPREGADO DO SEXO MASCULINO DO MES DE ", "FUNCIONARIO DO SEXO MASCULINO DO MES DE " )
		#define STR0042 If( cPaisLoc $ "VEN|ANG|PTG", "EMPREGADO POR DEPARTAMENTO DO MES DE ", "FUNCIONARIO POR DEPARTAMENTO DO MES DE " )
		#define STR0043 "TOTAL GERAL"
		#define STR0044 "DEPARTAMENTO"
		#define STR0045 "CARGO"
		#define STR0046 If( cPaisLoc $ "VEN|ANG|PTG", "SALDO DE SAL�RIO", "SALDO DE SALARIO" )
		#define STR0047 "APELIDOS"
		#define STR0048 "NOMES"
		#define STR0049 "ADMISSA"
		#define STR0050 If( cPaisLoc $ "VEN|ANG|PTG", "SAL�RIO", "SALARIO" )
		#define STR0051 "CARGO"
		#define STR0052 "TOTAL"
		#define STR0053 "TOTAL TRIMESTRAL POR DEPARTAMENTO DO "
		#define STR0054 If( cPaisLoc $ "VEN|ANG|PTG", "N�O DEFINIDO", "NAO DEFINIDO" )
		#define STR0055 If( cPaisLoc $ "VEN|ANG|PTG", "P�gina: ", "Pagina: " )
		#define STR0056 If( cPaisLoc $ "VEN|ANG|PTG", "N�o h� informa��es para serem geradas. Verifique os par�metros.", "Nao ha informacoes para serem geradas.Verifique os parametros" )
		#define STR0057 "Aguarde"
	#endif
#endif
