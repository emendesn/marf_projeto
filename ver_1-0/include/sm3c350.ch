#ifdef SPANISH
	#define STR0001 "Registro de control de produccion y stock"
	#define STR0002 "Este programa emitira el registro de control de produccion"
	#define STR0003 "y stock de los productos seleccionados, ordenados por dia."
	#define STR0004 "Este informe no relaciona la mano de obra. NOTA: Los totales se imprimiran segun el Modelo Legal."
	#define STR0005 " Por Codigo         "
	#define STR0006 " Por Tipo           "
	#define STR0007 " Por Descripcion   "
	#define STR0008 " Por Grupo        "
	#define STR0009 "A Rayas"
	#define STR0010 "Administracion"
	#define STR0011 "|                                                  REGISTRO DE CONTROL DE PRODUCCION Y STOCK                                                         |     (*)  CODIGO DE ENTRADAS Y SALIDAS             |"
	#define STR0012 "| EMPRESA: #############################################                                                                                             |                                                   |"
	#define STR0013 "|                                                                                                                                                    | 1 - EN EL PROPIO ESTABLECIMIENTO                  |"
	#define STR0014 "| INGR. BRUTOS  : ################                   CUIT: ############                                                                              |                                                   |"
	#define STR0015 "|                                                                                                                                                    | 2 - EN OTRO ESTABLECIMIENTO                       |"
	#define STR0016 "| HOJA:  ####               MES O PERIODO/A�O: ########                                                                                              |                                                   |"
	#define STR0017 "|                                                                                                                                                    | 3 - DIVERSOS                                      |"
	#define STR0018 "| PRODUC.: ###############################################                      UM: ## CLASIFICACION FISCAL: ###############     DEPOSITO: ##        |                                                   |"
	#define STR0019 "|            DOCUMENTO                  |             REGISTRO              |                         ENTRADAS Y SALIDAS                             |                      |                            |"
	#define STR0020 "|ESPECIE|SERIE|              |          |     |       CODIFICACION          |   |   |                      |                    |                    |         STOCK        |        OBSERVACIONES       |"
	#define STR0021 "|       |SUB- |              |          |     |-----------------------------|E/S|COD|                      |                    |                    |                      |                            |"
	#define STR0022 "|       |SERIE|    NUMERO    |  FECHA   | DIA |     CONTABLE         |FISCAL|   |(*)|       CANTIDAD       |       VALOR        |      I V A         |                      |                            |"
	#define STR0023 "ANULADO POR EL OPERADOR"
	#define STR0024 "Saldo Inicial:"
	#define STR0025 "Subtotal del Dia "
	#define STR0026 "Total del Periodo:"
	#define STR0027 "No hubo movimientos para este producto."
	#define STR0028 "|       |SERIE|    NUMERO    |  FECHA   | DIA |     CONTABLE                |   |(*)|       CANTIDAD       |       VALOR        |     IMPUESTOS      |                      |                            |"
	#define STR0029 "Selecionando Registros..."
	#define STR0030 "Atencion"
	#define STR0031 "Al modificar el deposito, no sera considerado el costo promedio unificado."
	#define STR0032 "Confirmar"
	#define STR0033 "Salir"
	#define STR0034 "| EMPRESA: ###########################################     SUCURSAL: #############                                                                   |                                                   |"
	#define STR0035 "| TOTAL SUCURSAL: #############                                                     |                      |                    |                    |                      |                            |"
	#define STR0036 "Actualiz."
	#define STR0037 "Prod. "
	#define STR0038 "|                                                  REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE  - P3                                               |     (*)  CODIGO DE ENTRADAS E SAIDAS              |"
	#define STR0039 "Reg. Kardex Mod. 3"
	#define STR0040 "Aten��o"
	#define STR0041 "Esse relat�rio n�o poder� ser impresso no formato HTML"
	#define STR0042 "Do Produto ?"
	#define STR0043 "Ate o Produto ?"
	#define STR0044 "Do tipo ?"
	#define STR0045 "Ate o Tipo ?"
	#define STR0046 "Do Periodo ?"
	#define STR0047 "Ate o Periodo ?"
	#define STR0048 "Lista Prods S/Movim"
	#define STR0049 "Do Armazem ?"
	#define STR0050 "Ate Armazem ?"
	#define STR0051 "(D)oc/(S)equencia ?"
	#define STR0052 "Qual a Moeda ?"
	#define STR0053 "Pagina Inicial ?"
	#define STR0054 "Quant. Paginas ?"
	#define STR0055 "Totaliza por dia ?"
	#define STR0056 "Prod s/Mov c/ Saldo ?"
	#define STR0057 "Outras Moedas ?"
	#define STR0058 "Quebrar Paginas ?"
	#define STR0059 "Desp nas NFs sem IPI ?"
	#define STR0060 "Reiniciar Paginas ?"
	#define STR0061 "Lista Filiais?"
#else
	#ifdef ENGLISH
		#define STR0001 "Production and Inventory Control File"
		#define STR0002 "This program prints the Production and Inventory Control"
		#define STR0003 "records referring to Selected products, Sorted by Date."
		#define STR0004 "This report does not list Labor Force. NOTE: Total Values according to the Legal Model"
		#define STR0005 " By Code          "
		#define STR0006 " By Type           "
		#define STR0007 " By Descript.     "
		#define STR0008 " By Group        "
		#define STR0009 "Z.Form "
		#define STR0010 "Management   "
		#define STR0011 "|                                                  INVENTORY AND PRODUCTION CONTROL RECORD                                                           |     (*)  INFLOW AND OUTFLOW CODE                  |"
		#define STR0012 "| COMP.: #############################################                                                                                               |                                                   |"
		#define STR0013 "|                                                                                                                                                    | 1 - OWN ESTABLISHMENT                             |"
		#define STR0014 "| EST REGISTRAT.: ################                  CNPJ : ############                                                                              |                                                   |"
		#define STR0015 "|                                                                                                                                                    | 2 - IN ANOTHER ESTABLISHMENT                      |"
		#define STR0016 "| SHEET: ####              MONTH OR PERIOD/YR: ########                                                                                              |                                                   |"
		#define STR0017 "|                                                                                                                                                    | 3 - VARIOUS                                       |"
		#define STR0018 "| PRODUCT: ###############################################                      UM: ## FISCAL CLASSIFICAT.: ###############    WAREHOUSE: ##         |                                                   |"
		#define STR0019 "|            DOCUMENT                   |               ENTRY               |                         INFLOWS AND OUTFLOWS                           |                      |                            |"
		#define STR0020 "|SPECIES|SERIE|              |          |     |       CODIFICATION          |   |   |                      |                    |                    |       INVENTORY      |         OBSERVATIONS       |"
		#define STR0021 "|       |SUB- |              |          |     |-----------------------------|I/O|COD|                      |                    |                    |                      |                            |"
		#define STR0022 "|       |SERI.|    NUMBER    |   DATE   | DAY |     ACCOUNTING       |FISCAL|   |(*)|      QUANTITY        |       VALUE        |        IPI         |                      |                            |"
		#define STR0023 "CANCELLED BY THE OPERATOR  "
		#define STR0024 "Opening Balance"
		#define STR0025 "SubTotal of the Day "
		#define STR0026 "Total of the Period :"
		#define STR0027 "There are no transactions for this product.  "
		#define STR0028 "|       |SERI.|    NUMBER    |   DATE   | DAY |       ACCOUNTING            |   |(*)|      QUANTITY        |       VALUE        |        TAXES       |                      |                            |"
		#define STR0029 "Selecting Records..."
		#define STR0030 "Attention"
		#define STR0031 "When editing warehouse, the unified average cost is disreagarded."
		#define STR0032 "OK"
		#define STR0033 "Quit"
		#define STR0034 "| COMPANY: ###########################################     BRANCH: ###############                                                                   |                                                   |"
		#define STR0035 "| BRANCH TOTAL: ###############                                                     |                      |                    |                    |                      |                            |"
		#define STR0036 "Update   "
		#define STR0037 "Products"
		#define STR0038 "|                                                  PRODUCTION AND STOCK CONTROL RECORD  - P3                                                        |     (*)  INFLOW AND OUTFLOW CODE                  |"
		#define STR0039 "Reg. Kardex Mod. 3"
		#define STR0040 "Aten��o"
		#define STR0041 "Esse relat�rio n�o poder� ser impresso no formato HTML"
		#define STR0042 "Do Produto ?"
		#define STR0043 "Ate o Produto ?"
		#define STR0044 "Do tipo ?"
		#define STR0045 "Ate o Tipo ?"
		#define STR0046 "Do Periodo ?"
		#define STR0047 "Ate o Periodo ?"
		#define STR0048 "Lista Prods S/Movim"
		#define STR0049 "Do Armazem ?"
		#define STR0050 "Ate Armazem ?"
		#define STR0051 "(D)oc/(S)equencia ?"
		#define STR0052 "Qual a Moeda ?"
		#define STR0053 "Pagina Inicial ?"
		#define STR0054 "Quant. Paginas ?"
		#define STR0055 "Totaliza por dia ?"
		#define STR0056 "Prod s/Mov c/ Saldo ?"
		#define STR0057 "Outras Moedas ?"
		#define STR0058 "Quebrar Paginas ?"
		#define STR0059 "Desp nas NFs sem IPI ?"
		#define STR0060 "Reiniciar Paginas ?"
		#define STR0061 "Lista Filiais?"
	#else
		#define STR0001 "Registro de Controle de Producao e Estoque"
		#define STR0002 "Este programa emitira' o Registro de Controle de Producao"
		#define STR0003 "e Estoque dos produtos Selecionados,Ordenados por Dia."
		#define STR0004 "Este relatorio nao lista a Mao de Obra. NOTA: Os Valores Totais serao impressos conforme o Modelo Legal."
		#define STR0005 " Por Codigo       "
		#define STR0006 " Por Tipo         "
		#define STR0007 " Por Descricao    "
		#define STR0008 " Por Grupo        "
		#define STR0009 "Zebrado"
		#define STR0010 "Administracao"
		#define STR0011 "|                                                  REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE                                                     |     (*)  CODIGO DE ENTRADAS E SAIDAS              |"
		#define STR0012 "| FIRMA: #############################################                                                                                               |                                                   |"
		#define STR0013 "|                                                                                                                                                    | 1 - NO PROPRIO ESTABELECIMENTO                    |"
		#define STR0014 "| INSCR.ESTADUAL: ################                  CNPJ : ############                                                                              |                                                   |"
		#define STR0015 "|                                                                                                                                                    | 2 - EM OUTRO ESTABELECIMENTO                      |"
		#define STR0016 "| FOLHA: ####              MES OU PERIODO/ANO: ########                                                                                              |                                                   |"
		#define STR0017 "|                                                                                                                                                    | 3 - DIVERSAS                                      |"
		#define STR0018 "| PRODUTO: ###############################################                      UM: ## CLASSIFICACAO FISCAL: ###############      ARMAZEM: ##        |                                                   |"
		#define STR0019 "|               DOCUMENTO               |            LANCAMENTO             |                         ENTRADAS E SAIDAS                              |                      |                            |"
		#define STR0020 "|ESPECIE|SERIE|              |          |     |         CODIFICACAO         |   |   |                      |                    |                    |        ESTOQUE       |         OBSERVACOES        |"
		#define STR0021 "|       |SUB- |              |          |     |-----------------------------|E/S|COD|                      |                    |                    |                      |                            |"
		#define STR0022 "|       |SERIE|    NUMERO    |   DATA   | DIA |     CONTABIL         |FISCAL|   |(*)|      QUANTIDADE      |       VALOR        |        IPI         |                      |                            |"
		#define STR0023 "CANCELADO PELO OPERADOR"
		#define STR0024 "Saldo Inicial:"
		#define STR0025 "Sub-Total do Dia "
		#define STR0026 "Total do Periodo:"
		#define STR0027 "Nao houve movimentacao para este produto."
		#define STR0028 "|       |SERIE|    NUMERO    |   DATA   | DIA |       CONTABIL              |   |(*)|      QUANTIDADE      |       VALOR        |      IMPOSTOS      |                      |                            |"
		#define STR0029 "Selecionando Registros..."
		#define STR0030 "Atencao"
		#define STR0031 "Ao alterar o aramazem o custo medio unificado sera desconsiderado."
		#define STR0032 "Confirma"
		#define STR0033 "Abandona"
		#define STR0034 "| FIRMA: #############################################     FILIAL: ###############                                                                   |                                                   |"
		#define STR0035 "| TOTAL FILIAL: ###############                                                     |                      |                    |                    |                      |                            |"
		#define STR0036 "Atualizar"
		#define STR0037 "Produtos"
		#define STR0038 "|                                                  REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE  - P3                                               |     (*)  CODIGO DE ENTRADAS E SAIDAS              |"
		#define STR0039 "Reg. Kardex Mod. 3"
		#define STR0040 "Aten��o"
		#define STR0041 "Esse relat�rio n�o poder� ser impresso no formato HTML"
		#define STR0042 "Do Produto ?"
		#define STR0043 "Ate o Produto ?"
		#define STR0044 "Do tipo ?"
		#define STR0045 "Ate o Tipo ?"
		#define STR0046 "Do Periodo ?"
		#define STR0047 "Ate o Periodo ?"
		#define STR0048 "Lista Prods S/Movim"
		#define STR0049 "Do Armazem ?"
		#define STR0050 "Ate Armazem ?"
		#define STR0051 "(D)oc/(S)equencia ?"
		#define STR0052 "Qual a Moeda ?"
		#define STR0053 "Pagina Inicial ?"
		#define STR0054 "Quant. Paginas ?"
		#define STR0055 "Totaliza por dia ?"
		#define STR0056 "Prod s/Mov c/ Saldo ?"
		#define STR0057 "Outras Moedas ?"
		#define STR0058 "Quebrar Paginas ?"
		#define STR0059 "Desp nas NFs sem IPI ?"
		#define STR0060 "Reiniciar Paginas ?"
		#define STR0061 "Lista Filiais?"
	#endif
#endif
