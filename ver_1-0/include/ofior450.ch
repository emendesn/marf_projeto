#ifdef SPANISH
	#define STR0001 "¿Tipo tiempo  ?"
	#define STR0002 "¿Estatus Tp Tiempo ?"
	#define STR0003 "¿Tipo de informe  ?"
	#define STR0004 "¿Fecha por Consider.?"
	#define STR0005 "¿Fch. Inicial?"
	#define STR0006 "¿Fch. Final?"
	#define STR0007 "¿OS Inicial?"
	#define STR0008 "¿OS Final?"
	#define STR0009 "¿Fact. p/?"
	#define STR0010 "¿Tda.?"
	#define STR0011 "¿Marca?"
	#define STR0012 "¿Modelo?"
	#define STR0013 "¿Ident. Vehiculo?"
	#define STR0014 "¿Consultor apertura?"
	#define STR0015 "¿Consultor cierre ?"
	#define STR0016 "¿Mecanico?"
	#define STR0017 "¿Valor interno ?"
	#define STR0018 "¿De Tp Servic.?"
	#define STR0019 "¿A Tp Servicio?"
	#define STR0020 "¿Lista Os s/ Solicitud ?"
	#define STR0021 "¿Departamento interno?"
	#define STR0022 "¿Departam. Garantia ?"
	#define STR0023 "¿Segmento Cliente ?"
	#define STR0024 "¿Suc. Inicial ?"
	#define STR0025 "¿Suc. Final ?"
	#define STR0026 "¿Genera Plan.?"
	#define STR0027 "Este programa tiene como objetivo imprimir informe"
	#define STR0028 "de acuerdo con los param. informados por el usuario."
	#define STR0029 "Informe Ordenes de Servicios"
	#define STR0030 "Nro OS-- Apertura Hr Ap CT Ape ProVeh Tda Nombre del Cliente--- RPF/RNPJ------ Direccion---------------------- Ciudad--------- R/E/P Telefono---"
	#define STR0031 "Sucursal-------- Mc. Modelo do Vehiculo---------------- Fab./Mod. Color------- ChaInt Chasos del Vehiculo------ ---Km--- Placa----- CodFrt-"
	#define STR0032 "Tp   Fact P/ Td Nombre Cli-DG DI CT Fec Liberada Cerrada- Cancel.- Num.Lib- Num Fact    ----Piezas TpoPad TpoTra TpoCob TpoVen -Servicios"
	#define STR0033 "PCS Grp- Codigo de la pieza--------- Descripcion------------------------------ -Cant.de ProSol.Formul---Val Unit --Val Total"
	#define STR0034 "Srv TS. GS Codigo Servic.- Descripcion--------------------- Mecan. Nomb Mecanico ----- TpoEst TpoTra TpoCob TpoVen -Servic. "
	#define STR0035 "RESUM."
	#define STR0036 "TIEMP"
	#define STR0037 "Tipo de Tiempo------------  ------Cant.    -------Piezas    Estand   Trabaj.   Cobrado   Vendido  --Servic.    Cant.T.T.    Cant.OS."
	#define STR0038 "TOTAL"
	#define STR0039 "Ctd. pasaje chasis"
	#define STR0040 "DEPARTAMENTO"
	#define STR0041 "Departamento--------------  ------Cant.    -------Piezas    Estandar Trabaj.   Cobrado   Vendido  --Servic.     Cant.OS."
	#define STR0042 "TIPO DE SERVIC."
	#define STR0043 "Tip.Ser   Descripcion                       Estand   Vendido   Trabaj.   Cobrado    Valor Servicio   CantOS"
	#define STR0044 "Planilla generada con exito "
	#define STR0045 "Atenc. "
	#define STR0046 'Todos'
	#define STR0047 'Abiert'
	#define STR0048 'Liberada'
	#define STR0049 'Finaliz'
	#define STR0050 'Anulada  '
	#define STR0051 'Resumido'
	#define STR0052 'Sintetico'
	#define STR0053 'Analitico'
	#define STR0054 'Fch. Apert.'
	#define STR0055 'Fch. Liberac'
	#define STR0056 'Fch. Cierre  '
	#define STR0057 'Fch. Anul. '
	#define STR0058 'No'
	#define STR0059 'Si'
	#define STR0060 "A rayas"
	#define STR0061 "Administracion"
	#define STR0062 "*** ANULADO POR EL OPERADOR ***"
#else
	#ifdef ENGLISH
		#define STR0001 "Time Type      ?"
		#define STR0002 "Time Type Status ?"
		#define STR0003 "Report Type?"
		#define STR0004 "Date to be Considered ?"
		#define STR0005 "Initial Date ?"
		#define STR0006 "Final Date ?"
		#define STR0007 "Initial SO ?"
		#define STR0008 "Final SO ?"
		#define STR0009 "Invoice for ?"
		#define STR0010 "Store?"
		#define STR0011 "Brand ?"
		#define STR0012 "Model                    ?"
		#define STR0013 "Vehicle Identification ?"
		#define STR0014 "Opening Consultant ?"
		#define STR0015 "Closing Consultant ?"
		#define STR0016 "Productive ?"
		#define STR0017 "Internal Value ?"
		#define STR0018 "Service Type From ?"
		#define STR0019 "Service Type To ?"
		#define STR0020 "List S.O.s w/out Requests?"
		#define STR0021 "Internal Department?"
		#define STR0022 "Warranty Department?"
		#define STR0023 "Customer Segment?"
		#define STR0024 "Initial Branch?"
		#define STR0025 "Final Branch?"
		#define STR0026 "Generate Worksheet ?"
		#define STR0027 "This program prints report "
		#define STR0028 "according to parameters entered by user."
		#define STR0029 "Service Orders Report"
		#define STR0030 "WO No. -- Opening Time Op CT Op ProVh Store Customer Name--- Tax ID---- Address---------------------- City--------- State Phone Number---"
		#define STR0031 "Branch-------- Mc. Vehicle Model-------------------- Man./Mod. Color------- ChaInt Vehicle Chassis------Mileage--- License Plate----- CodFrt-"
		#define STR0032 "Tp  Ivc to St Cust Naem-DG DI CT Cls Released Closed- Cancel.-Rls.Nº·-Ivc Nº  --- Parts StdTp TrTp CollTp VhcTp - Services"
		#define STR0033 "PCS Grp- Spare parts code------------- Description-------------------------------- -Qty ProReq Formul ---Unit Vl --Total Vl"
		#define STR0034 "Srv TS. GS Service Code- Description----------------------- Product Name Productive----- STTp TpTra TpCob TpSal -Services"
		#define STR0035 "SUMMARY"
		#define STR0036 "TIME"
		#define STR0037 "Time Type-------------  ------Qty.    -------Spare Parts     Standard   Worked   Charge   Sold  --Services   Qty T.T.    Qty SO."
		#define STR0038 "TOTAL"
		#define STR0039 "Chassis Passage Qty."
		#define STR0040 "DEPARTMENT"
		#define STR0041 "Department--------------  ------Qty.    -------Spare Parts     Standard   Worked   Charge   Sold  --Services   Qty SO."
		#define STR0042 "SERVICE TYPE"
		#define STR0043 "Ser.Tp   Description                         Standard   Sold   Worked   Charged   Value Service   Qty. SO"
		#define STR0044 "Worksheet successfully generated!"
		#define STR0045 "Attention"
		#define STR0046 'All'
		#define STR0047 'Open'
		#define STR0048 'Released'
		#define STR0049 'Closed'
		#define STR0050 'Cancelled'
		#define STR0051 'Summarized'
		#define STR0052 'Summarized'
		#define STR0053 'Detailed'
		#define STR0054 'Opening Dt'
		#define STR0055 'Release Dt.'
		#define STR0056 'Closing Dt.'
		#define STR0057 'Cancellation Dt'
		#define STR0058 'No'
		#define STR0059 'Yes'
		#define STR0060 "Z-form"
		#define STR0061 "Administration"
		#define STR0062 "*** CANCELED BY OPERATOR ***"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Tipo de tempo ?", "Tipo de Tempo ?" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Estado do tp.tempo ?", "Status do Tp Tempo ?" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Tipo de relatório ?", "Tipo de Relatorio ?" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Data ser considerad ?", "Data ser Considerad ?" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Data inicial ?", "Data Inicial ?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Data final ?", "Data Final ?" )
		#define STR0007 "OS Inicial ?"
		#define STR0008 "OS Final ?"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Facturar p/ ?", "Faturar p/ ?" )
		#define STR0010 "Loja ?"
		#define STR0011 "Marca ?"
		#define STR0012 "Modelo ?"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Identif. veículo ?", "Identif Veiculo ?" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Consultor abertura ?", "Consultor Abertura ?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Consultor fechamento?", "Consultor Fechament ?" )
		#define STR0016 "Produtivo ?"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Valor interno ?", "Valor  Interno ?" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "De Tp.Serviço?", "Tp Servico De ?" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Até Tp.Serviço?", "Tp Servico Ate ?" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Lista Os s/ requisição ?", "Lista Os s/ Requisicao ?" )
		#define STR0021 "Departamento interno ?"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Departamento garantia ?", "Departamento Garantia ?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Segmento do cliente ?", "Segmento do Cliente ?" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Filial inicial ?", "Filial Inicial ?" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Filial final ?", "Filial Final ?" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Gera folha de cálculo?", "Gera Planilha ?" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo imprimir relatório ", "Este programa tem como objetivo imprimir relatorio " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "de acordo com os parâmetros informados pelo utilizador.", "de acordo com os parametros informados pelo usuario." )
		#define STR0029 "Relatório de Ordens de Serviços"
		#define STR0030 "Nro OS-- Abertura Hr Ab CT Abe ProVei Loja Nome do Cliente--- CPF/CNPJ------ Endereço--------------- Cidade--------- UF Telefone---"
		#define STR0031 "Filial-------- Mc. Modelo do Veiculo---------------- Fab./Mod. Cor------- ChaInt Chassi do Veiculo------ ---Km--- Placa----- CodFrt-"
		#define STR0032 "Tp   Fat P/ Lj Nome Cli-DG DI CT Fec Liberada Fechada- Cancel.- Num.Lib- Num NF    ----Peças TpoPad TpoTra TpoCob TpoVen -Serviços"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "PCS Grp- Código da peça------------- Descrição-------------------------------- -Qtd ProReq Formul ---Vlr Unit --Vlr Total", "PCS Grp- Codigo da peca------------- Descricao-------------------------------- -Qtdade ProReq Formul ---Vlr Unit --Vlr Total" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Srv TS. GS Código Serviço- Descrição----------------------- Produt Nome Produtivo----- TpoPad TpoTra TpoCob TpoVen -Serviços", "Srv TS. GS Codigo Servico- Descricao----------------------- Produt Nome Produtivo----- TpoPad TpoTra TpoCob TpoVen -Servicos" )
		#define STR0035 "RESUMO"
		#define STR0036 "TEMPO"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Tipo de Tempo-------------  ------Qtd.    -------Peças     Padrão   Trabal.   Cobrado   Vendido  --Serviços   Qtd. T.T.    Qtd. OS.", "Tipo de Tempo-------------  ------Qtde.    -------Pecas     Padrão   Trabal.   Cobrado   Vendido  --Servicos   Qtde T.T.    Qtde OS." )
		#define STR0038 "TOTAL"
		#define STR0039 "Qtd.Passagem Chassi"
		#define STR0040 "DEPARTAMENTO"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Departamento--------------  ------Qtd.    -------Peças     Padrão   Trabal.   Cobrado   Vendido  --Serviços    Qtd. OS.", "Departamento--------------  ------Qtde.    -------Pecas     Padrão   Trabal.   Cobrado   Vendido  --Servicos    Qtde OS." )
		#define STR0042 "TIPO DE SERVIÇO"
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Tp.Ser   Descrição                          Padrão   Vendido   Trabal.   Cobrado    Valor Serviço    Qtd.OS", "Tip.Ser   Descrição                         Padrão   Vendido   Trabal.   Cobrado    Valor Serviço    Qtd.OS" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Folha de cálculo gerada com sucesso.", "Planilha gerada com sucesso!" )
		#define STR0045 "Atenção"
		#define STR0046 'Todos'
		#define STR0047 'Aberta'
		#define STR0048 'Liberada'
		#define STR0049 'Fechada'
		#define STR0050 'Cancelada'
		#define STR0051 'Resumido'
		#define STR0052 'Sintético'
		#define STR0053 'Analítico'
		#define STR0054 If( cPaisLoc $ "ANG|PTG", 'Dt.Abertura', 'Dt Abertura' )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", 'Dt.Liberação', 'Dt Liberacao' )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", 'Dt.Fechamento', 'Dt Fechamento' )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", 'Dt.Cancelam', 'Dt Cancelam' )
		#define STR0058 'Não'
		#define STR0059 'Sim'
		#define STR0060 "Zebrado"
		#define STR0061 "Administração"
		#define STR0062 "*** CANCELADO PELO OPERADOR ***"
	#endif
#endif
