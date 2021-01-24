#ifdef SPANISH
	#define STR0001 "Caracter"
	#define STR0002 "Numerico"
	#define STR0003 "Fecha"
	#define STR0004 "Logico"
	#define STR0005 "Memo"
	#define STR0006 "Diario"
	#define STR0007 "Semanal"
	#define STR0008 "Mensual"
	#define STR0009 "(no soportado)"
	#define STR0010 "Suma"
	#define STR0011 "Conteo"
	#define STR0012 "Distincion"
	#define STR0013 "Promedio"
	#define STR0014 "Minimo"
	#define STR0015 "Maximo"
	#define STR0016 "Participacion"
	#define STR0017 "Participacion total"
	#define STR0018 "Participacion global"
	#define STR0019 "Promedio interno"
	#define STR0020 "Acumulado"
	#define STR0021 "Acumulado(%)"
	#define STR0022 "Acumulado Hist."
	#define STR0023 "Acumulado (%) Hist."
	#define STR0024 "n Superiores"
	#define STR0025 "n Inferiores"
	#define STR0026 "Pareto(%)"
	#define STR0027 "Curva ABC"
	#define STR0028 "Texto"
	#define STR0029 "Texto SDF"
	#define STR0030 "HyperText"
	#define STR0031 "Excel 95/97"
	#define STR0032 "Imagen JPEG"
	#define STR0033 "Excel 2000 o superior"
	#define STR0034 "Texto(CSV)"
	#define STR0035 "Excel(integracion)"
	#define STR0036 "No generar"
	#define STR0037 "Solamente claves, max. 500"
	#define STR0038 "Completo, max. 500"
	#define STR0039 "Solamente claves, sin limite"
	#define STR0040 "Completo, sin limite"
	#define STR0041 "Estandar"
	#define STR0042 "Produccion"
	#define STR0043 "Financiero"
	#define STR0044 "RR.HH."
	#define STR0045 "Comercial"
	#define STR0046 "Por nivel"
	#define STR0047 "(sin definicion)"
#else
	#ifdef ENGLISH
		#define STR0001 "Character"
		#define STR0002 "Numeric"
		#define STR0003 "Date"
		#define STR0004 "Logical"
		#define STR0005 "Memo"
		#define STR0006 "Daily"
		#define STR0007 "Weekly"
		#define STR0008 "Monthly"
		#define STR0009 "(not supported)"
		#define STR0010 "Sum"
		#define STR0011 "Count"
		#define STR0012 "Distinction"
		#define STR0013 "Average"
		#define STR0014 "Minimum"
		#define STR0015 "Maximum"
		#define STR0016 "Participation"
		#define STR0017 "Total Participation"
		#define STR0018 "Global Participation"
		#define STR0019 "Internal Average"
		#define STR0020 "Accrued"
		#define STR0021 "Accrued(%)"
		#define STR0022 "Accrued Hist."
		#define STR0023 "Accrued (%) Hist."
		#define STR0024 "Higher n"
		#define STR0025 "Lower n"
		#define STR0026 "Pareto(%)"
		#define STR0027 "Curve ABC"
		#define STR0028 "Text"
		#define STR0029 "SDF Text"
		#define STR0030 "HyperText"
		#define STR0031 "Excel 95/97"
		#define STR0032 "JPEG Image"
		#define STR0033 "Excel 2000 or higher"
		#define STR0034 "Text(CSV)"
		#define STR0035 "Excel(integration)"
		#define STR0036 "Do not generate"
		#define STR0037 "Only keys, max. 500"
		#define STR0038 "Complete, max. 500"
		#define STR0039 "Only keys, no limits"
		#define STR0040 "Complete, no limits"
		#define STR0041 "Standard"
		#define STR0042 "Production"
		#define STR0043 "Financial"
		#define STR0044 "H.R."
		#define STR0045 "Commercial"
		#define STR0046 "By level"
		#define STR0047 "(without definition)"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Car�cter", "Caracter" )
		#define STR0002 "Num�rico"
		#define STR0003 "Data"
		#define STR0004 "L�gico"
		#define STR0005 "Memo"
		#define STR0006 "Di�rio"
		#define STR0007 "Semanal"
		#define STR0008 "Mensal"
		#define STR0009 "(n�o suportado)"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Somar", "Soma" )
		#define STR0011 "Contagem"
		#define STR0012 "Distin��o"
		#define STR0013 "M�dia"
		#define STR0014 "M�nimo"
		#define STR0015 "M�ximo"
		#define STR0016 "Participa��o"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Participa��o total", "Participa��o Total" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Participa��o global", "Participa��o Global" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "M�dia interna", "M�dia Interna" )
		#define STR0020 "Acumulado"
		#define STR0021 "Acumulado(%)"
		#define STR0022 "Acumulado Hist."
		#define STR0023 "Acumulado (%) Hist."
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "N Maiores", "n Maiores" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "N Menores", "n Menores" )
		#define STR0026 "Pareto(%)"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Curva Abc", "Curva ABC" )
		#define STR0028 "Texto"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Texto Sdf", "Texto SDF" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Hypertext", "HyperText" )
		#define STR0031 "Excel 95/97"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Imagem Jpeg", "Imagem JPEG" )
		#define STR0033 "Excel 2000 ou superior"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Texto(csv)", "Texto(CSV)" )
		#define STR0035 "Excel(integra��o)"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "N�o criar", "N�o gerar" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Somente chaves, m�x. 500", "Somente chaves, max. 500" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Completo, m�x. 500", "Completo, max. 500" )
		#define STR0039 "Somente chaves, sem limite"
		#define STR0040 "Completo, sem limite"
		#define STR0041 "Padr�o"
		#define STR0042 "Produ��o"
		#define STR0043 "Financeiro"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "R.h.", "R.H." )
		#define STR0045 "Comercial"
		#define STR0046 "Por n�vel"
		#define STR0047 "(sem defini��o)"
	#endif
#endif
