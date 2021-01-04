#ifdef SPANISH
	#define STR0001 "INFORME COMPARATIVO MENSUAL"
	#define STR0002 "Aviso"
	#define STR0003 "No existe el directorio"
	#define STR0004 "COMPARATIVO DE CUOTAS OBRERO-PATRONALES - MENSUAL -"
	#define STR0005 "Proviene de"
	#define STR0006 "Número de Seguridad Social"
	#define STR0007 "Nombre"
	#define STR0008 "C.U.R.P."
	#define STR0009 "Empleado"
	#define STR0010 "Registro Patronal"
	#define STR0011 "RFC"
	#define STR0012 "Nombre o Razón Social."
	#define STR0013 "Mes y Año de Proceso"
	#define STR0014 "Fecha"
	#define STR0015 "Días"
	#define STR0016 "SDI"
	#define STR0017 "T.M."
	#define STR0018 "C.F."
	#define STR0019 "Enfermedad y Maternidad Excedente"
	#define STR0020 "P.D."
	#define STR0021 "G.M.P."
	#define STR0022 "R.T."
	#define STR0023 "I.V."
	#define STR0024 "G.P.S."
	#define STR0025 "Suma"
	#define STR0026 "Total"
	#define STR0027 "EM.Pat."
	#define STR0028 "EM.Obr."
	#define STR0029 "Matrícula"
	#define STR0030 "PD.Pat."
	#define STR0031 "PD.Obr."
	#define STR0032 "GMP.Pat."
	#define STR0033 "GMP.Obr."
	#define STR0034 "IV.Pat."
	#define STR0035 "IV.Obr."
	#define STR0036 "Seleccione un Registro Patronal"
	#define STR0037 "Total IMSS"
	#define STR0038 "Total PROTHEUS"
	#define STR0039 "TODOS"
	#define STR0040 "DIFERENCIAS"
	#define STR0041 "("
	#define STR0042 ")"
	#define STR0043 "Los siquientes Archivos no fueron encontrados:"
	#define STR0044 "Movimientos: "
	#define STR0045 "Personales:  "
	#define STR0046 "Ok"
	#define STR0047 "Seleccionando Registros..."
	#define STR0048 "Registros existentes en el archivo del IMSS que no se encontraron en Protheus"
#else
	#ifdef ENGLISH
		#define STR0001 "INFORME COMPARATIVO MENSUAL"
		#define STR0002 "Aviso"
		#define STR0003 "No existe el directorio"
		#define STR0004 "COMPARATIVO DE CUOTAS OBRERO-PATRONALES - MENSUAL -"
		#define STR0005 "Proviene de"
		#define STR0006 "Número de Seguridad Social"
		#define STR0007 "Nombre"
		#define STR0008 "C.U.R.P."
		#define STR0009 "Empleado"
		#define STR0010 "Registro Patronal"
		#define STR0011 "RFC"
		#define STR0012 "Nombre o Razón Social."
		#define STR0013 "Mes y Año de Proceso"
		#define STR0014 "Fecha"
		#define STR0015 "Días"
		#define STR0016 "SDI"
		#define STR0017 "T.M."
		#define STR0018 "C.F."
		#define STR0019 "Enfermedad y Maternidad Excedente"
		#define STR0020 "P.D."
		#define STR0021 "G.M.P."
		#define STR0022 "R.T."
		#define STR0023 "I.V."
		#define STR0024 "G.P.S."
		#define STR0025 "Suma"
		#define STR0026 "Total"
		#define STR0027 "EM.Pat."
		#define STR0028 "EM.Obr."
		#define STR0029 "Matrícula"
		#define STR0030 "PD.Pat."
		#define STR0031 "PD.Obr."
		#define STR0032 "GMP.Pat."
		#define STR0033 "GMP.Obr."
		#define STR0034 "IV.Pat."
		#define STR0035 "IV.Obr."
		#define STR0036 "Seleccione un Registro Patronal"
		#define STR0037 "Total IMSS"
		#define STR0038 "Total PROTHEUS"
		#define STR0039 "TODOS"
		#define STR0040 "DIFERENCIAS"
		#define STR0041 "("
		#define STR0042 ")"
		#define STR0043 "Los siquientes Archivos no fueron encontrados:"
		#define STR0044 "Movimientos: "
		#define STR0045 "Personales:  "
		#define STR0046 "Ok"
		#define STR0047 "Seleccionando Registros..."
		#define STR0048 "Registros existentes en el archivo del IMSS que no se encontraron en Protheus"
	#else
		#define STR0001 "INFORME COMPARATIVO MENSUAL"
		#define STR0002 "Aviso"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "No existe el directorio", "Não existe o diretório" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "COMPARATIVO DE CUOTAS OBRERO-PATRONALES - MENSUAL -", "COMPARATIVO DE CONTRIBUIÇÕES EMPREGADO-EMPREGADOR - MENSAL -" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Proviene de", "Provém de" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Número de Seguridad Social", "Número da Previdência Social" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Nombre", "Nome" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "C.U.R.P.", "RG" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Empleado", "Funcionário" )
		#define STR0010 "Registro Patronal"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "RFC", "CPF" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Nombre o Razón Social.", "Nome ou Razão Social" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Mes y Año de Proceso", "Mês e Ano do Processo" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Fecha", "Data" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Días", "Dias" )
		#define STR0016 "SDI"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "T.M.", "T. M." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "C.F.", "C. F." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Enfermedad y Maternidad Excedente", "Doença e Maternidade Excedente" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "P.D.", "P. D." )
		#define STR0021 "G.M.P."
		#define STR0022 "R.T."
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "I.V.", "I. V." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "G.P.S.", "G.P. S." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Suma", "Soma" )
		#define STR0026 "Total"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "EM.Pat.", "EM. Pat." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "EM.Obr.", "EM. Func." )
		#define STR0029 "Matrícula"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "PD.Pat.", "PD. Pat." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "PD.Obr.", "PD. Func." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "GMP.Pat.", "GMP. Pat." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "GMP.Obr.", "GMP. Func." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "IV.Pat.", "IV. Pat." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "IV.Obr.", "IV. Func." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Seleccione un Registro Patronal", "Selecione um Registro Patronal" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Total IMSS", "Total INSS" )
		#define STR0038 "Total PROTHEUS"
		#define STR0039 "TODOS"
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "DIFERENCIAS", "DIFERENÇAS" )
		#define STR0041 "("
		#define STR0042 ")"
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Los siquientes Archivos no fueron encontrados:", "Os seguintes Arquivos não foram encontrados:" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Movimientos: ", "Movimentos: " )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Personales:  ", "Pessoais: " )
		#define STR0046 "Ok"
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Seleccionando Registros...", "Selecionando Registros..." )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Registros existentes en el archivo del IMSS que no se encontraron en Protheus", "Registros existentes no aqruivo do INSS que não foram encontrados no Protheus" )
	#endif
#endif
