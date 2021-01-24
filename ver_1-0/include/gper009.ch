#ifdef SPANISH
	#define STR0001 "Mapa ticket transp."
	#define STR0002 "Se imprimira segun los parametros solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "Matricula"
	#define STR0005 "C.Costo"
	#define STR0006 "Nomb"
	#define STR0007 "C.Costo + Nomb"
	#define STR0008 "C.Costo + Turno + Nomb"
	#define STR0009 " MAPA TICKET REST. "
	#define STR0010 " MAPA TICKET CANASTA "
	#define STR0011 " MAPA TICKET TRANSP.  "
	#define STR0012 "Esta rutina genera un mapa que resume la inform. del Ticket Rest. por "
	#define STR0013 "( NORMAL )"
	#define STR0014 "( DIFERENC. )"
	#define STR0015 "( NORMAL + DIFERENC. )"
	#define STR0016 "Esta rutina genera un mapa que resume la inform. del Ticket canasta por "
	#define STR0017 "Mapa ticket rest."
	#define STR0018 "Mapa ticket canasta"
	#define STR0019 "FIRMA      ___________________________"
	#define STR0020 "       TOTAL DEL EMPLEADO     "
	#define STR0021 "       TOTAL C.COSTO "
	#define STR0022 "       TOTAL SUC.   "
	#define STR0023 "       TOTAL DE BENEFICIARIOS "
	#define STR0024 "       TOTAL TURNO"
	#define STR0025 "Seleccionando Reg. ..."
	#define STR0026 "Cant"
	#define STR0027 "COSTO UNITARIO"
	#define STR0028 "COSTO TOTAL"
	#define STR0029 "COSTO EMPL."
	#define STR0030 "COSTO EMPL."
	#define STR0031 "CANT. "
	#define STR0032 "VALOR TOTAL"
	#define STR0033 "VALE DIF."
	#define STR0034 "CT.DIF."
	#define STR0035 "CODIGO TICK"
	#define STR0036 "COSTO TOTAL"
	#define STR0037 "Esta rutina genera un mapa que resume la inform. de Ticket Transp. por    "
	#define STR0038 " empleados permitiendo que el descuento se genere para la planilla de haberes."
	#define STR0039 "Empleado   "
	#define STR0040 "Atencion"
	#define STR0041 "Periodo no registrado"
	#define STR0042 "No. Pago no registrado para este Periodo."
	#define STR0043 "- COMPETENCIA: "
	#define STR0044 "Active/Seleccione la impresion del informe personalizable"
	#define STR0045 "Ok"
	#define STR0046 "Ticket Transporte"
	#define STR0047 "Ticket Restaurant"
	#define STR0048 "Ticket Comida"
	#define STR0049 "Tipo de Beneficio"
	#define STR0050 "Elija el Tipo de Beneficio:"
	#define STR0051 "Antes de proseguir, es necesario ejecutar los procedimientos del boletin tecnico - Modificacion Grupo de Preguntas en la Impresion del Mapa (Beneficios). "
#else
	#ifdef ENGLISH
		#define STR0001 "Transport Voucher Map"
		#define STR0002 "It will be printed in accordance with the parameters requested by"
		#define STR0003 "user."
		#define STR0004 "Registration"
		#define STR0005 "Cost Center"
		#define STR0006 "Name"
		#define STR0007 "Cost C. + Name"
		#define STR0008 "Cost C. + Shift + Name"
		#define STR0009 " MEAL VOUCHER MAP "
		#define STR0010 " FOOD VOUCHER MAP "
		#define STR0011 " TRANSPORT VOUCHER MAP "
		#define STR0012 "This routine generates a map the summarizes the Food Voucher data per "
		#define STR0013 "( NORMAL )"
		#define STR0014 "( DIFFERENCE )"
		#define STR0015 "( NORMAL + DIFFERENCE )"
		#define STR0016 "This routine generates a map the summarizes the Meal Voucher data per "
		#define STR0017 "Meal Voucher Map"
		#define STR0018 "Food Voucher Map"
		#define STR0019 "SIGNATURE ___________________________"
		#define STR0020 "       EMPLOYEE TOTAL   "
		#define STR0021 "       COST C. TOTAL "
		#define STR0022 "       BRANCH TOTAL "
		#define STR0023 "       BENEFICIARY TOTAL "
		#define STR0024 "       SHIFT TOTAL"
		#define STR0025 "Selecting records ..."
		#define STR0026 "QTY"
		#define STR0027 "UNIT COST"
		#define STR0028 "TOTAL COST"
		#define STR0029 "EMPL. COST"
		#define STR0030 "EMPL. COST"
		#define STR0031 "AMT."
		#define STR0032 "TOTAL AMOUNT"
		#define STR0033 "DIF. VOUCHER"
		#define STR0034 "DIF.AMT."
		#define STR0035 "VOUCHER CODE"
		#define STR0036 "TOTAL COST"
		#define STR0037 "This routine generates a map the summarizes the Food Voucher data per "
		#define STR0038 " employees allowing discount to be generated for the payroll."
		#define STR0039 "Employee"
		#define STR0040 "Attention"
		#define STR0041 "Period not registered."
		#define STR0042 "Payment No. not registered for this period."
		#define STR0043 "_ JURISDICTION: "
		#define STR0044 "Activate/Select the customizable report printing"
		#define STR0045 "Ok"
		#define STR0046 "Transport Voucher"
		#define STR0047 "Meal Voucher"
		#define STR0048 "Food Voucher"
		#define STR0049 "Benefit Type"
		#define STR0050 "Choose Benefit Type:"
		#define STR0051 "Before continuing, you must follow the technical newsletter procedures - Edit Group of Questions on Map Printing (Benefits). "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Mapa vale transporte", "Mapa Vale Transporte" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Ser� impresso de acordo com os par�metros solicitados pelo", "Ser� impresso de acordo com os parametros solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "utilizador.", "usu�rio." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Matr�cula", "Matricula" )
		#define STR0005 "C.Custo"
		#define STR0006 "Nome"
		#define STR0007 "C.Custo + Nome"
		#define STR0008 "C.Custo + Turno + Nome"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " MAPA TICKET REFEI��O ", " MAPA VALE REFEI��O " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", " MAPA TICKET ALIMENTA��O ", " MAPA VALE ALIMENTA��O " )
		#define STR0011 " MAPA VALE TRANSPORTE "
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Est procedimento gera um mapa que resume as informa��es de ticket refei��o por ", "Esta rotina gera um mapa que resume as informacoes de Vale refei��o por " )
		#define STR0013 "( NORMAL )"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "( DIFEREN�A )", "( DIFERENCA )" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "( NORMAL + DIFEREN�A )", "( NORMAL + DIFERENCA )" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Este procedimento gera um mapa que resume as informa��es de ticket alimenta��o por ", "Esta rotina gera um mapa que resume as informacoes de Vale alimenta��o por " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Mapa Ticket Refei��o", "Mapa Vale Refei��o" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Mapa Ticket Alimenta��o", "Mapa Vale Alimenta��o" )
		#define STR0019 "ASSINATURA ___________________________"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "       TOTAL DO COLABORADOR   ", "       TOTAL DO FUNCIONARIO   " )
		#define STR0021 "       TOTAL C.CUSTO "
		#define STR0022 "       TOTAL FILIAL "
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "       TOTAL DE BENEFICI�RIOS ", "       TOTAL DE BENEFICIARIOS " )
		#define STR0024 "       TOTAL DO TURNO"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos ...", "Selecionando Registros ..." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "QTD", "QTDE" )
		#define STR0027 "CUSTO UNIT�RIO"
		#define STR0028 "CUSTO TOTAL"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "CUSTO COLAB.", "CUSTO FUNC." )
		#define STR0030 "CUSTO EMPR."
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "QTD.", "QUANT." )
		#define STR0032 "VALOR TOTAL"
		#define STR0033 "VALE DIF."
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "QTD.DIF.", "QT.DIF." )
		#define STR0035 "C�DIGO VALE"
		#define STR0036 "CUSTO TOTAL"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Este procedimento gera um mapa que resume as informa��es de vale transporte por ", "Esta rotina gera um mapa que resume as informacoes de Vale transporte por " )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", " colaboradores permitindo que o desconto seja gerado para a folha de pagamento.", " funcionarios permitindo que o desconto seja gerado para a folha de pagamento." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Colaborador", "Funcion�rio" )
		#define STR0040 "Aten��o"
		#define STR0041 "Per�odo n�o cadastrado."
		#define STR0042 "No. Pagamento n�o cadastrado para este Per�odo."
		#define STR0043 "- COMPETENCIA: "
		#define STR0044 "Ative/Selecione a impress�o do relat�rio personaliz�vel"
		#define STR0045 "Ok"
		#define STR0046 "Vale Transporte"
		#define STR0047 "Vale Refei��o"
		#define STR0048 "Vale Alimenta��o"
		#define STR0049 "Tipo de Benef�cio"
		#define STR0050 "Escolha o Tipo de Benef�cio:"
		#define STR0051 "Antes de prosseguir, � necess�rio executar os procedimentos do boletim t�cnico - Altera��o Grupo de Perguntas na Impress�o do Mapa (Benef�cios). "
	#endif
#endif
