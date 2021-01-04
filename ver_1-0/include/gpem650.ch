#ifdef SPANISH
	#define STR0001 "Generacion de titulos"
	#define STR0002 "Este programa genera titulos en el  archivo  de  movimientos (RC1) a partir del registro de"
	#define STR0003 "definiciones (RC0). Tras generarlos, estaran disponibles para consultas e integracion con "
	#define STR0004 "el financiero.                              "
	#define STR0005 "Generando titulos - "
	#define STR0006 "Selecionando registros..."
	#define STR0007 "Confirma configuracion de los parametros?"
	#define STR0008 "Atención"
	#define STR0009 "Generando archivo, espere..."
	#define STR0010 "Procesando..."
	#define STR0011 "No se genero(generaron) el (los) titulo(s): "
	#define STR0012 ". Ajuste el (los) tipo(s) y procese generacion nuevamente."
	#define STR0013 "Se debe ejecutar el programa para actualizacion de base del SIGAGPE - (RHUPDMOD)"
	#define STR0014 "Seleccione la actualizacion 'Ajustar Indices - RC1'."
	#define STR0015 "Ejecute la opcion do compatibilizador referente a la creacion de la nueva tabla de Convenio Colectivo Acumulado. Para mayores informaciones verifique respectivo Boletin Tecnico."
	#define STR0016 "Solo los titulos de tipo 006 - INSS - Convenio NO se generaran hasta que el compatibilizador se ejecute."
	#define STR0017 "OK"
	#define STR0018 "Para titulos de INSS no se permite el agrupamiento por empleado."
	#define STR0019 "Arregle el agrupamiento y procese la generacion de nuevo."
	#define STR0020 "Las fechas inicial y final deben estar dentro del mismo mes y ano. Verifique."
	#define STR0021 "¿Desea basarse en la duplicidad de títulos?"
	#define STR0022 "Registros duplicados"
	#define STR0023 "Os titulos abaixo não foram gerados por já se encontrarem na base de dados:"
	#define STR0024 "Filial:"
	#define STR0025 "Centro de Custo:"
	#define STR0026 "Matricula: "
	#define STR0027 "Prefixo: "
	#define STR0028 "Tipo: "
	#define STR0029 "Data de Vencimento: "
	#define STR0030 "Valor: "
#else
	#ifdef ENGLISH
		#define STR0001 "Bill´s Generation "
		#define STR0002 "This program will generate bills in the movements file (RC1) from the registration of"
		#define STR0003 "definitions (RC0). After generated they will be available for query and integration  "
		#define STR0004 "with the financial module.                 "
		#define STR0005 "Generating Bills- "
		#define STR0006 "Selecting Files..."
		#define STR0007 "Confirm the parameters configuration?"
		#define STR0008 "Warning"
		#define STR0009 "Generating file. Wait..."
		#define STR0010 "Processing..."
		#define STR0011 "Bill(s) not generated: "
		#define STR0012 ". Correct the type(s) and generate again."
		#define STR0013 "The program to update SIGAGPE database (RHUPDMOD) must be executed."
		#define STR0014 "Select update 'Adjust Indexes - RC1.'"
		#define STR0015 "Run the compatibility program option referring to the creation of a new table of accrued pay increase due to labor agreement. For more information, check the respective Technical Newsletter."
		#define STR0016 "Only bills of type 006 - INSS - Labor Agreement are NOT generated until the compressor is run."
		#define STR0017 "OK"
		#define STR0018 "For INSS bills, grouping by employee is not allowed."
		#define STR0019 "Adjust grouping and process the generation again."
		#define STR0020 "The initial and final dates must be within the same month and year. Check it."
		#define STR0021 "Consist the bill duplicity?"
		#define STR0022 "Duplicated registers"
		#define STR0023 "The bills below were not generated because they are already on the database:"
		#define STR0024 "Branch:"
		#define STR0025 "Cost Center:"
		#define STR0026 "Registration: "
		#define STR0027 "Prefix: "
		#define STR0028 "Type: "
		#define STR0029 "Due Date: "
		#define STR0030 "Value: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Criação De Títulos", "Geracao de Titulos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa gera títulos no  ficheiro  de  movimentos (rc1) a partir do registo de", "Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Definicoes (rc0). após criados, estarão disponíveis para consultas e integração com ", "definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "O financeiro.                              ", "o financeiro.                              " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A criar títulos - ", "Gerando Titulos - " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Confirma configuração dos parâmetros?", "Confirma configuraçäo dos parâmetros?" )
		#define STR0008 "Atenção"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A criar ficheiro aguarde...", "Gerando arquivo aguarde..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A processar...", "Processando..." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Não foi(ram) criado(s) o(s) título(s): ", "Nao foi(ram) gerado(s) o(s) titulo(s): " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", ". corrijir o(s) tipo(s) e processar a criação novamente.", ". Acerte o(s) tipo(s) e processe a geracao novamente." )
		#define STR0013 "Deve ser executado o programa para atualização de base do SIGAGPE - (RHUPDMOD)"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Seleccione a actualização 'Ajustar Índices - RC1'.", "Selecione a atualização 'Ajustar Indices - RC1'." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Execute a opção do compatibilizador referente à criação da nova tabela de Dissídio Acumulado. Para mais informações, verifique o respectivo Boletim Técnico.", "Execute a opção do compatibilizador referente à criação da nova tabela de Dissídio Acumulado. Para maiores informações verifique respectivo Boletim Técnico." )
		#define STR0016 "Somente os títulos de tipo 006 - INSS - Dissidio NÃO serão gerados até que o compatibilizador seja executado."
		#define STR0017 "OK"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Para títulos de INSS, não é permitido o agrupamento por colaborador.", "Para titulos de INSS nao e permitido o agrupamento por funcionario." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Acerte o agrupamento e processe a geração novamente.", "Acerte o agrupamento e processe a geracao novamente." )
		#define STR0020 "As datas inicial e final devem estar dentro do mesmo mês e ano. Verifique."
		#define STR0021 "Deseja consistir a duplicidade de títulos?"
		#define STR0022 "Registros duplicados"
		#define STR0023 "Os titulos abaixo não foram gerados por já se encontrarem na base de dados:"
		#define STR0024 "Filial:"
		#define STR0025 "Centro de Custo:"
		#define STR0026 "Matricula: "
		#define STR0027 "Prefixo: "
		#define STR0028 "Tipo: "
		#define STR0029 "Data de Vencimento: "
		#define STR0030 "Valor: "
	#endif
#endif
