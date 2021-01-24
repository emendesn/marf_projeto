#ifdef SPANISH
	#define STR0001 "Informe de Scorecard_name______ e Indicador"
	#define STR0002 "Informes de Scorecard_name______s e Indicadores"
	#define STR0003 "Iniciando generacion del informe [REL053_"
	#define STR0004 "Error en la creacion del archivo [REL053_"
	#define STR0005 "Operacion interrumpida"
	#define STR0006 "Finalizando la generacion del informe ["
	#define STR0007 "Informe de Scorecard_name______ e Indicadores"
	#define STR0008 "Scorecard_name______:"
	#define STR0009 "Descripcion:"
	#define STR0010 "Responsable:"
	#define STR0011 "Jerarquia:"
	#define STR0012 "Indicador:"
	#define STR0013 "Descripcion:"
	#define STR0014 "Indicador Principal:"
	#define STR0015 "Orientacion:"
	#define STR0016 "Decimales:"
	#define STR0017 "Unidad de Medida:"
	#define STR0018 "Frecuencia:"
	#define STR0019 "Grupo:"
	#define STR0020 "Tipo Acumulado:"
	#define STR0021 "Visible:"
	#define STR0022 "Codigo de Importacion:"
	#define STR0023 "Formula:"
	#define STR0024 "No se encontraron informaciones dentro de especificaciones pasadas"
	#define STR0025 "o no existen personas en cobranza en las tareas verificadas"
	#define STR0026 "Ascendente"
	#define STR0027 "Descendente"
	#define STR0028 "Anual"
	#define STR0029 "Semestral"
	#define STR0030 "Trimestral"
	#define STR0031 "Cuadrimestral"
	#define STR0032 "Bimestral"
	#define STR0033 "Mensual"
	#define STR0034 "Quincenal"
	#define STR0035 "Semanal"
	#define STR0036 "Diaria"
	#define STR0037 "Suma"
	#define STR0038 "Promedio"
	#define STR0039 "Si"
	#define STR0040 "No"
	#define STR0041 "�Generacion del informe Finalizada!"
	#define STR0042 "�Error en la Generacion del Informe!"
	#define STR0043 "Fecha:"
	#define STR0044 "Usuarios autorizados:"
	#define STR0045 "Vacio"
	#define STR0046 "Manual"
	#define STR0047 "Via planilla"
	#define STR0048 "Via fuente de datos"
	#define STR0049 "Informe de "
	#define STR0050 " e Indicador"
	#define STR0051 "Informes de "
	#define STR0052 " e Indicadores"
#else
	#ifdef ENGLISH
		#define STR0001 "Scorecard_name______ and indicator report"
		#define STR0002 "Scorecard_name______ and indicators reports"
		#define STR0003 "Starting report generation [REL053_"
		#define STR0004 "Error creating file [REL053_"
		#define STR0005 "Operation aborted"
		#define STR0006 "Finishing report generation ["
		#define STR0007 "Report of Scorecard_name______ and Indicators"
		#define STR0008 "Scorecard_name______:"
		#define STR0009 "Description"
		#define STR0010 "Responsible:"
		#define STR0011 "Hierarchy: "
		#define STR0012 "Indicator:"
		#define STR0013 "Description"
		#define STR0014 "Parent indicator:"
		#define STR0015 "Orientation:"
		#define STR0016 "Decimals:"
		#define STR0017 "Unit of measurement:"
		#define STR0018 "Frequence: "
		#define STR0019 "Group:"
		#define STR0020 "Accumulated type:"
		#define STR0021 "Visible:"
		#define STR0022 "Import code: "
		#define STR0023 "Formula:"
		#define STR0024 "No information found within the specifications passed "
		#define STR0025 "or there are no people in collection for the tasks checked"
		#define STR0026 "Ascending "
		#define STR0027 "Descending "
		#define STR0028 "Annual"
		#define STR0029 "Semester "
		#define STR0030 "Quaterly "
		#define STR0031 "Quatrimester "
		#define STR0032 "Bi-monthly"
		#define STR0033 "Monthly"
		#define STR0034 "Fortnightly"
		#define STR0035 "Weekly "
		#define STR0036 "Daily "
		#define STR0037 "Sum "
		#define STR0038 "Average"
		#define STR0039 "Yes"
		#define STR0040 "No "
		#define STR0041 "Report generation finished! "
		#define STR0042 "Error generating report! "
		#define STR0043 "Date:"
		#define STR0044 "Authorized users: "
		#define STR0045 "Blank"
		#define STR0046 "Manual"
		#define STR0047 "Via Worksheet"
		#define STR0048 "Via Data Source"
		#define STR0049 "Report of "
		#define STR0050 " and Indicator"
		#define STR0051 "Reports of "
		#define STR0052 " and Indicators"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relat�rio De Scorecard_nome______ E Indicador", "Relatorio de Scorecard_name______ e Indicador" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Relat�rios De Scorecard_nome______s E Indicadores", "Relatorios de Scorecard_name______s e Indicadores" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A iniciar cria��o do relat�rio [rel053_", "Iniciando gerac�o do relatorio [REL053_" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Erro na ��o do ficheiro [rel053_", "Erro na criac�o do arquivo [REL053_" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Opera��o abortada", "Operac�o abortada" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A finalizar cria��o do relat�rio [", "Finalizando gerac�o do relatorio [" )
		#define STR0007 "Relat�rio de Scorecard_name______ e Indicadores"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Scorecard_nome______:", "Scorecard_name______:" )
		#define STR0009 "Descri��o:"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Responsavel:", "Respons�vel:" )
		#define STR0011 "Hierarquia:"
		#define STR0012 "Indicador:"
		#define STR0013 "Descri��o:"
		#define STR0014 "Indicador Pai:"
		#define STR0015 "Orienta��o:"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "D�cimais:", "Decimais:" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Unidade De Medida:", "Unidade de Medida:" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Frequ�ncia:", "Freq��ncia:" )
		#define STR0019 "Grupo:"
		#define STR0020 "Tipo Acumulado:"
		#define STR0021 "Vis�vel:"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "C�digo de importa��o:", "C�digo de Importa��o:" )
		#define STR0023 "F�rmula:"
		#define STR0024 "N�o foram encontradas informa��es dentro das especifica��es passadas"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Ou n�o existem pessoas em cobran�a nas tarefas verificadas", "ou n�o existe pessoas em cobran�a nas tarefas verificadas" )
		#define STR0026 "Ascendente"
		#define STR0027 "Descendente"
		#define STR0028 "Anual"
		#define STR0029 "Semestral"
		#define STR0030 "Trimestral"
		#define STR0031 "Quadrimestral"
		#define STR0032 "Bimestral"
		#define STR0033 "Mensal"
		#define STR0034 "Quinzenal"
		#define STR0035 "Semanal"
		#define STR0036 "Di�ria"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Somar", "Soma" )
		#define STR0038 "M�dia"
		#define STR0039 "Sim"
		#define STR0040 "N�o"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Cria��o do relat�rio finalizada!", "Gera��o do Relat�rio Finalizada!" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Erro na cria��o do relat�rio!", "Erro na Gera��o do Relat�rio!" )
		#define STR0043 "Data:"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Utilizadores autorizados:", "Usu�rios autorizados:" )
		#define STR0045 "Vazio"
		#define STR0046 "Manual"
		#define STR0047 "Via planilha"
		#define STR0048 "Via fonte de dados"
		#define STR0049 "Relat�rio de "
		#define STR0050 " e Indicador"
		#define STR0051 "Relat�rios de "
		#define STR0052 " e Indicadores"
	#endif
#endif
