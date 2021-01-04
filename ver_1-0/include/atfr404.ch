#ifdef SPANISH
	#define STR0001 "MAPA"
	#define STR0002 "MODELO"
	#define STR0003 "A imprimir mapa..."
	#define STR0004 "Seleccionando los datos para la impresion del mapa"
	#define STR0005 "Anulado por el operador"
	#define STR0006 "Totales de la cuenta"
	#define STR0007 "Periodo de tributacion"
	#define STR0008 "Incluyendo los adquiridos en estado de uso"
	#define STR0009 "Fijo Corp�reo"
	#define STR0010 "Fijo Incorp�reo"
	#define STR0011 "Elementos descontados en el ejercicio"
	#define STR0012 "Numero de Identificacion Fiscal"
	#define STR0013 "Actividad principal"
	#define STR0014 "Codigo CAE"
	#define STR0015 "Descripcion de los elementos del activo"
	#define STR0016 "Numero de Identificacion Fiscal"
	#define STR0017 "Gastos Fiscales"
	#define STR0018 "Perdidas por imapridad aceptadas en el periodo (art. 38� CIRC)"
	#define STR0019 "Depreciaciones / amortizaciones y perdidas por imparidad no aceptadas como gastos"
	#define STR0020 "Tasa %"
	#define STR0021 "Tasa corregida %"
	#define STR0022 "Ano"
	#define STR0023 "Mes"
	#define STR0024 "Ejercicio de"
	#define STR0025 "Adquisicion"
	#define STR0026 "Fecha"
	#define STR0027 "Total general o a transportar"
	#define STR0028 "Documento emitido por computadora"
	#define STR0029 "Del ejercicio"
	#define STR0030 "Actualizando preguntas del informe"
	#define STR0031 "MAPA DE DEPRECIACIONES Y AMORTIZACIONES"
	#define STR0032 "elementos del activo no reevaluados"
	#define STR0033 "Codigo de acuerdo con la tabla adjunta al DR n� 25/2009"
	#define STR0034 "Inicio de utilizacion"
	#define STR0035 "Valor contable registrado"
	#define STR0036 "Ano util."
	#define STR0037 "Depreciaciones / amortizaciones y perdidas por imparidad contabilizadas en el periodo"
	#define STR0038 "Depreciaciones y amortizaciones aceptadas en periodos anteriores"
	#define STR0039 "Depreciaciones y amortizaciones"
	#define STR0040 "Tasa perdida acumul."
	#define STR0041 "Activos"
	#define STR0042 "Valor de adquisicion o produccion para efectos fiscales"
	#define STR0043 "Limite fiscal del periodo per�odo"
	#define STR0044 "Depreciaciones / amortizaciones y perdidas por imparidad recuperadas en el periodo"
	#define STR0045 "NATURALEZA DE LOS ACTIVOS"
	#define STR0046 "ACTIVOS FIJOS TANGIBLES"
	#define STR0047 "ACTIVOS FIJOS INTANGIBLES"
	#define STR0048 "PROPIEDADES DE INVERSION"
	#define STR0049 "METODO UTILIZADO"
	#define STR0050 "CUOTAS CONSTANTES"
	#define STR0051 "CUOTAS DECRECIENTES"
	#define STR0052 "OTRO"
#else
	#ifdef ENGLISH
		#define STR0001 "MAP"
		#define STR0002 "MODEL"
		#define STR0003 "Printing Map..."
		#define STR0004 "Selecting data to print the map"
		#define STR0005 "Canceled by operator"
		#define STR0006 "Totals of account"
		#define STR0007 "Taxation period"
		#define STR0008 "including those purchased in condition of use"
		#define STR0009 "Tangible Capital Assets"
		#define STR0010 "Intangible Capital Assets"
		#define STR0011 "Elements deducted in the year"
		#define STR0012 "Tax identification number"
		#define STR0013 "Main Activity"
		#define STR0014 "CAE Code"
		#define STR0015 "DESCRIPTION OF ASSET ELEMENTS"
		#define STR0016 "Tax identification number"
		#define STR0017 "Tax Expenses"
		#define STR0018 "Loss by impairment accepted in the period (art. 38 - CIRC)"
		#define STR0019 "Depreciation/amortization and loss by impairment not accepted as expenses"
		#define STR0020 "% Fee"
		#define STR0021 "Adjusted % Fee"
		#define STR0022 "Year"
		#define STR0023 "Month"
		#define STR0024 "Year of"
		#define STR0025 "Purchase"
		#define STR0026 "Date"
		#define STR0027 "General total or total to transport"
		#define STR0028 "Document generated by computer"
		#define STR0029 "From year"
		#define STR0030 "Updating report questions"
		#define STR0031 "MAP OF DEPRECIATION AND AMORTIZATION"
		#define STR0032 "asset elements not reevaluated"
		#define STR0033 "Code according to the table attached to DR no. 25/2009"
		#define STR0034 "Beginning of Use"
		#define STR0035 "Accounting value registered"
		#define STR0036 "Year of Use"
		#define STR0037 "Depreciation/amortization and loss by impairment accounted in the period"
		#define STR0038 "Depreciation and amortization accepted in previous periods"
		#define STR0039 "Depreciation and amortization"
		#define STR0040 "Accum. lost rate"
		#define STR0041 "Assets"
		#define STR0042 "Acquisition or production value for tax purposes"
		#define STR0043 "Period tax limit"
		#define STR0044 "Depreciation/amortization and loss by impairment recovered in the period"
		#define STR0045 "TYPE OF ASSETS"
		#define STR0046 "TANGIBLE FIXED ASSETS"
		#define STR0047 "INTANGIBLE FIXED ASSETS"
		#define STR0048 "INVESTMENT PROPERTIES"
		#define STR0049 "METHOD USED"
		#define STR0050 "CONSTANT QUOTAS"
		#define STR0051 "DECREASING QUOTAS"
		#define STR0052 "OTHER"
	#else
		#define STR0001 "MAPA"
		#define STR0002 "MODELO"
		#define STR0003 "A imprimir mapa..."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "A seleccionar os dados para a impress�o do mapa", "Selecionando os dados para a impress�o do mapa" )
		#define STR0005 "Cancelado pelo operador"
		#define STR0006 "Totais da conta"
		#define STR0007 "Per�odo de tributa��o"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "a incluir os adquiridos em estado de uso", "incluindo os adquiridos em estado de uso" )
		#define STR0009 "Imobilizado Corp�reo"
		#define STR0010 "Imobilizado Incorp�reo"
		#define STR0011 "Elementos abatidos no exerc�cio"
		#define STR0012 "N�mero de identifica��o fiscal"
		#define STR0013 "Actividade prinicipal"
		#define STR0014 "C�digo CAE"
		#define STR0015 "Descri��o dos elementos do activo"
		#define STR0016 "N�mero de identifica��o fiscal"
		#define STR0017 "Gastos Fiscais"
		#define STR0018 "Perdas por imparidade aceites no per�odo (art. 38� CIRC)"
		#define STR0019 "Deprecia��es / amortiza��es e perdas por imparidade n�o aceites como gastos"
		#define STR0020 "Taxa %"
		#define STR0021 "Taxa corrigida %"
		#define STR0022 "Ano"
		#define STR0023 "M�s"
		#define STR0024 "Exerc�cio de"
		#define STR0025 "Aquisi��o"
		#define STR0026 "Data"
		#define STR0027 "Total geral ou a transportar"
		#define STR0028 "Documento emitido por computador"
		#define STR0029 "Do exerc�cio"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "A actualizar perguntas do relat�rio", "Atualizando perguntas do relat�rio" )
		#define STR0031 "MAPA DE DEPRECIA��ES E AMORTIZA��ES"
		#define STR0032 "elementos do activo n�o reavaliados"
		#define STR0033 "C�digo de acordo com a tabela anexa ao DR n� 25/2009"
		#define STR0034 "In�cio de utiliza��o"
		#define STR0035 "Valor contab�listico registado"
		#define STR0036 "Ano util."
		#define STR0037 "Deprecia��es / amortiza��es e perdas por imparidade contabilizadas no per�odo"
		#define STR0038 "Deprecia��es e amortiza��es aceites em per�odos anteriores"
		#define STR0039 "Deprecia��es e amortiza��es"
		#define STR0040 "Taxa perdida acumul."
		#define STR0041 "Activos"
		#define STR0042 "Valor de aquisi��o ou produ��o para efeitos fiscais"
		#define STR0043 "Limite fiscal do per�odo"
		#define STR0044 "Deprecia��es / amortiza��es e perdas por imparidade recuperadas no per�odo"
		#define STR0045 "NATUREZA DOS ACTIVOS"
		#define STR0046 "ACTIVOS FIXOS TANG�VEIS"
		#define STR0047 "ACTIVOS FIXOS INTANG�VEIS"
		#define STR0048 "PROPRIEDADES DE INVESTIMENTO"
		#define STR0049 "M�TODO UTILIZADO"
		#define STR0050 "QUOTAS CONSTANTES"
		#define STR0051 "QUOTAS DECRESCENTES"
		#define STR0052 "OUTRO"
	#endif
#endif