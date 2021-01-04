#ifdef SPANISH
	#define STR0001 "Salida de Vehiculos por Venta"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Anular"
	#define STR0006 "Leyenda"
	#define STR0007 "Busqueda Avanzada"
	#define STR0008 "Valida"
	#define STR0009 "Anulada"
	#define STR0010 "Devuelta"
	#define STR0011 "El pedido ya fue atendido parcial o totalmente. Imposible modificar."
	#define STR0012 "Atencion"
	#define STR0013 "No existe vehiculo pendiente en el periodo. Imposible facturar."
	#define STR0014 "Pedido ya se anulo/cerro. Imposible anular."
	#define STR0015 "Modificar"
	#define STR0016 "Facturar"
	#define STR0017 "Abierto"
	#define STR0018 "Anulado"
	#define STR0019 "Pendiente"
	#define STR0020 "Cerrado"
	#define STR0021 "Historial de pasajes"
	#define STR0022 "A rayas"
	#define STR0023 "Administracion"
	#define STR0024 "Diario taller"
#else
	#ifdef ENGLISH
		#define STR0001 "Outflow of Vehicles per Sale"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Cancel"
		#define STR0006 "Caption"
		#define STR0007 "Advanced Search"
		#define STR0008 "Valid"
		#define STR0009 "Cancelled"
		#define STR0010 "Returned"
		#define STR0011 "Order already partially or totally fulfilled. Change is not allowed."
		#define STR0012 "Attention"
		#define STR0013 "There is no pending vehicle in the order. Invoicing is not allowed."
		#define STR0014 "Order already cancelled/closed. Cancellation is not allowed."
		#define STR0015 "Edit"
		#define STR0016 "Invoice"
		#define STR0017 "Open"
		#define STR0018 "Canceled"
		#define STR0019 "Pending"
		#define STR0020 "Closed"
		#define STR0021 "Passage History"
		#define STR0022 "Z-form"
		#define STR0023 "Management"
		#define STR0024 "Repair Shop Journal"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Sa�da de Ve�culos por Venda", "Saida de Veiculos por Venda" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Cancelar"
		#define STR0006 "Legenda"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Pesquisa Avan�ada", "Pesquisa Avancada" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "V�lida", "Valida" )
		#define STR0009 "Cancelada"
		#define STR0010 "Devolvida"
		#define STR0011 "O pedido j� foi parcial ou totalmente atendido. Imposs�vel alterar."
		#define STR0012 "Aten��o"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "N�o existe ve�culo pendente no pedido. Imposs�vel facturar.", "N�o existe ve�culo pendente no pedido. Imposs�vel faturar." )
		#define STR0014 "Pedido j� cancelado/fechado. Imposs�vel cancelar."
		#define STR0015 "Alterar"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Facturar", "Faturar" )
		#define STR0017 "Aberto"
		#define STR0018 "Cancelado"
		#define STR0019 "Pendente"
		#define STR0020 "Fechado"
		#define STR0021 "Hist�rico de passagens"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Di�rio oficina", "Diario Oficina" )
	#endif
#endif