#ifdef SPANISH
	#define STR0001 "Calculo de titulos de INSS - OffLine"
	#define STR0002 "Esta rutina se procesara unicamente con la creacion del campo E2_TITINS (Char/25) en la tabla SE2"
	#define STR0003 "La Funcion de Calculo de INSS por"
	#define STR0004 "otro usuario, por cuestiones de integridad de datos, no"
	#define STR0005 "se permite la utilizacion de esta rutina por mas de un usuario"
	#define STR0006 "simultaneamente. Tente nuevamente mas tarde."
	#define STR0007 "Operador: "
	#define STR0008 "Empresa.: "
	#define STR0009 "Sucursal..: "
	#define STR0010 "El objetivo de este programa es generar titulos por pagar de INSS, segun la suma"
	#define STR0011 "de los titulos por vencer en la misma fecha del mismo proveedor."
	#define STR0012 "Calculo del INSS Off-Line"
	#define STR0013 "Proveedor    "
	#define STR0014 "Tienda          "
	#define STR0015 "Valor Base    "
	#define STR0016 "INSS Retenido   "
	#define STR0017 "INSS Pagar "
	#define STR0018 "Total General"
	#define STR0019 "Seleccionando Registros..."
	#define STR0020 "Seleccionado titulos por pagar"
	#define STR0021 "Este informe mostrara los titulos que se utilizaron para "
	#define STR0022 "para la elaboracion de la base de calculo del INSS por pagar"
	#define STR0023 "Resultado Analitico para verificacion - Titulos INSS"
	#define STR0024 "A rayas"
	#define STR0025 "Administracion"
	#define STR0026 "Sucursal"
	#define STR0027 " Prefijo  Numero   Cuot Tipo  Emision     Vencimiento Venc Real           Valor  Proveedor                        IN Titulo    IN Reten.  IN Pagar  "
	#define STR0028 "Subtotal"
	#define STR0029 "TOTAL"
	#define STR0030 "Instituto Nacional de Seguridad Social  "
	#define STR0031 "NOTA DE DEBITO AL PROVEEDOR "
	#define STR0032 "Buscar"
	#define STR0033 "Visualizar"
	#define STR0034 "Incluir"
	#define STR0035 "Modificar"
	#define STR0036 "Parametros"
	#define STR0037 "Los nuevos titulos tendran el aprobador estandar (parametro MV_FINAP01 - moneda 01)."
	#define STR0038 "Control de pertinencias activo"
#else
	#ifdef ENGLISH
		#define STR0001 "INSS bills calculation - Off-line     "
		#define STR0002 "Processing this routine will only be possible after creating the field E2_TITINS (Char/25) in table SE2"
		#define STR0003 "The INSS Calculation Function performed by"
		#define STR0004 "another user. Due to data integrity reasons, the use of this "
		#define STR0005 "routine by more than one user simultaneously is not         "
		#define STR0006 "allowed. Please, try again later.      "
		#define STR0007 "Operator: "
		#define STR0008 "Company.: "
		#define STR0009 "Branch..: "
		#define STR0010 "The aim of this program is to generate INSS bills payable, according to the total"
		#define STR0011 "falling due bills on the same date of the same supplier"
		#define STR0012 "Off-line INSS Calculation"
		#define STR0013 "Supplier      "
		#define STR0014 "Unit          "
		#define STR0015 "Base    "
		#define STR0016 "INSS Withheld "
		#define STR0017 "INSS to be Accrued  "
		#define STR0018 "Grand Total"
		#define STR0019 "Selecting Records ..."
		#define STR0020 "Selecting bills accrued"
		#define STR0021 "This report will display the bills to be used for "
		#define STR0022 "to perform the INSS calculation basis to be accrued"
		#define STR0023 "Detailed Result for checking - INSS bills"
		#define STR0024 "Z-Form"
		#define STR0025 "Management"
		#define STR0026 "Branch"
		#define STR0027 " Prefix  Number   Install Type Issue     Due date  real Due Date            Value  Supplier                       IN Bill    IN Withheld  IN Receivable"
		#define STR0028 "Subtotal"
		#define STR0029 "TOTAL"
		#define STR0030 "National Institute of Social Security   "
		#define STR0031 "DEBIT NOTE TO SUPPLIER"
		#define STR0032 "Search"
		#define STR0033 "View"
		#define STR0034 "Add"
		#define STR0035 "Edit"
		#define STR0036 "Parameters"
		#define STR0037 "New bills will have standard approver (parameter MV_FINAP01 - currecy 01)."
		#define STR0038 "Active Compet Control"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Apuro Dos Títulos De Ss - Offline", "Apuracao dos titulos de INSS - OffLine" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Apenas Será Possível O Processamento Desto Procedimento Com A Criação Do Campo E2_titins (char/25) Na Tabela Se2", "Somente será possível o processamento desta rotina com a criação do campo E2_TITINS (Char/25) na tabela SE2" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A função de apuro de Seg. Social por", "A Funcao de Apuração de INSS por" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Outro utilizador. por questoes de integridade de dados, não", "outro usuario. Por questoes de integridade de dados, nao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "é permitida a utilização desta procedimento por mais de um utilizador", "é permitida a utilizaçäo desta rotina por mais de um usuário" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Simultaneamente. tente novamente mais tarde.", "simultaneamente. Tente novamente mais tarde." )
		#define STR0007 "Operador: "
		#define STR0008 "Empresa.: "
		#define STR0009 "Filial..: "
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo criar títulos a pagar de ss, de acordo com a soma", "Este programa tem como objetivo gerar titulos a pagar de INSS, conforme a soma" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Dos títulos a vencer na mesma data do mesmo fornecedor.", "dos titulos a vencer na mesma data do mesmo fornecedor." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Apuro Do Seg. Social Off-line", "Apuracao do INSS Off-Line" )
		#define STR0013 "Fornecedor    "
		#define STR0014 "Loja          "
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Valor base    ", "Valor Base    " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "SS retida   ", "Inss Retido   " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Ss recolher ", "Inss Recolher " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Total Crial", "Total Geral" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "A seleccionar títulos a pagar", "Selecionado titulos a pagar" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Este relatório vai demonstrar os títulos que foram utilizados para ", "Este relatorio irá demonstrar os titulos que foram utilizados para " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Para a montagem da base de cálculo do ss a recolher", "para a montagem da base de calculo do INSS a recolher" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Resultado Analítico Para A Conferência - Títulos Ss", "Resultado Analitico para a conferencia - Titulos INSS" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0026 "Filial"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", " Prefixo  Número   Parc Tipo  Emissão     Vencimento  Venc.Real           Valor  Fornecedor                       IN Título    IN Retido  IN Recolher", " Prefixo  Numero   Parc Tipo  Emissao     Vencimento  Venc Real           Valor  Fornecedor                       IN Titulo    IN Retido  IN Recolher" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Sub-total", "Sub-Total" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Total", "TOTAL" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Segurança Social", "Instituto Nacional de Previdencia Social" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Nota De Débito Ao Fornecedor", "NOTA DE DEBITO AO FORNECEDOR" )
		#define STR0032 "Pesquisar"
		#define STR0033 "Visualizar"
		#define STR0034 "Incluir"
		#define STR0035 "Alterar"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Parâmetros", "Parãmetros" )
		#define STR0037 "Os novos títulos terão o aprovador padrão (parâmetro MV_FINAP01 - moeda 01)."
		#define STR0038 "Controle de alçadas ativo"
	#endif
#endif
