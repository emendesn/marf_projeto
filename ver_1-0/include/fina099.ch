#ifdef SPANISH
	#define STR0001 "Control Pagos por Tarjeta de Credito"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Mantenimiento"
	#define STR0005 "Leyenda"
	#define STR0006 "Bajo Analisis"
	#define STR0007 "Pago Aprobado"
	#define STR0008 "Rechazo Parcial"
	#define STR0009 "Rechazo Total"
	#define STR0010 "Mantenimiento de los Titulos"
	#define STR0011 "Codigo Estatus"
	#define STR0012 "Motivo Anulac."
	#define STR0013 "Valor Pago"
	#define STR0014 "Codigo Anulacion"
	#define STR0015 "Fecha Anulacion"
	#define STR0016 "Hora Anulacion"
	#define STR0017 "Bajando titulo: "
	#define STR0018 "BAJA TITULO CC"
	#define STR0019 "Consulta"
	#define STR0020 "Atencion"
	#define STR0021 "�Mantenimiento realizado!"
	#define STR0022 "�Situacion de Pago invalido!"
	#define STR0023 "�Informe el motivo somente si el Estatus es diferente de 01 y 02!"
	#define STR0024 "�Motivo de rechazo inv�lido!"
	#define STR0025 "�Valor cobrado superior al valor del titulo!"
	#define STR0026 "�Informe el valor parcial recibido!"
	#define STR0027 "�Fecha de anulacion inferior a la fecha del titulo!"
	#define STR0028 "�Codigo de rechazo es obligatorio!"
#else
	#ifdef ENGLISH
		#define STR0001 "Credit Card Payment Control"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Maintenance"
		#define STR0005 "Caption"
		#define STR0006 "In analysis"
		#define STR0007 "Payment Approved"
		#define STR0008 "Partial Rejection"
		#define STR0009 "Total Rejection"
		#define STR0010 "Bill Maintenance"
		#define STR0011 "Status Code"
		#define STR0012 "Cancel. Reason"
		#define STR0013 "Value Paid"
		#define STR0014 "Cancelation Code"
		#define STR0015 "Cancelation Date"
		#define STR0016 "Cancelation Hour"
		#define STR0017 "Loading bill: "
		#define STR0018 "LOADING CC BILL"
		#define STR0019 "Query"
		#define STR0020 "Attention"
		#define STR0021 "Maintenance already performed!"
		#define STR0022 "Invalid Payment Status!"
		#define STR0023 "Enter a reason only for status different from 01 and 02!"
		#define STR0024 "Invalid rejection reason!"
		#define STR0025 "Value received is greater than bill value!"
		#define STR0026 "Enter the partial value received!"
		#define STR0027 "Void date less than the bill date!"
		#define STR0028 "Rejection code is mandatory!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Controlo Pagamentos por Cart�o de Cr�dito", "Controle Pagamentos por Cart�o de Credito" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Manuten��o"
		#define STR0005 "Legenda"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Em An�lise", "Em Analise" )
		#define STR0007 "Pagamento Aprovado"
		#define STR0008 "Rejei��o Parcial"
		#define STR0009 "Rejei��o Total"
		#define STR0010 "Manuten��o dos T�tulos"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "C�digo Estado", "C�digo Status" )
		#define STR0012 "Motivo Cancel."
		#define STR0013 "Valor Pago"
		#define STR0014 "C�digo Cancelamento"
		#define STR0015 "Data Cancelamento"
		#define STR0016 "Hora Cancelamento"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "A liquidar t�tulo: ", "Baixando t�tulo: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "LIQ. T�TULO CC", "BAIXA TITULO CC" )
		#define STR0019 "Consulta"
		#define STR0020 "Aten��o"
		#define STR0021 "Manuten��o j� realizado !"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Situa��o de Pagamento inv�lido !", "Situa��o de Pagamento invalido !" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Informe o motivo somente quando Estado for diferente de 01 e 02 !", "Informe o motivo somente quando Status diferente de 01 e 02 !" )
		#define STR0024 "Motivo de rejei��o inv�lido !"
		#define STR0025 "Valor recebido maior que o valor do t�tulo !"
		#define STR0026 "Informe o valor parcial recebido !"
		#define STR0027 "Data de anula��o menor que a data do t�tulo !"
		#define STR0028 "C�digo de rejei��o � obrigat�rio !"
	#endif
#endif
