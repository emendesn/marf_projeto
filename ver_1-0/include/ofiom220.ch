#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Borrar"
	#define STR0004 "Borrado de Presupuestos"
	#define STR0005 "Presupuesto"
	#define STR0006 "Consulta Pedido"
	#define STR0007 "Consulta Factura"
	#define STR0008 "Venta"
	#define STR0009 "Pago"
	#define STR0010 "Cliente: "
	#define STR0011 "Condicion: "
	#define STR0012 "Itemes"
	#define STR0013 "Descuento"
	#define STR0014 "Total"
	#define STR0015 "Descripcion  "
	#define STR0016 "Valor      "
	#define STR0017 "Fecha"
	#define STR0018 "Valor"
	#define STR0019 "Hay titulos de baja referentes a esta Venta.."
	#define STR0020 "Atencion"
	#define STR0021 "Anulando Fac. de Salida..."
	#define STR0022 "¿Esta seguro que desea interrupir esta operacion ?"
	#define STR0023 "Anulando Pedido..."
	#define STR0024 "Borrando Titulos..."
	#define STR0025 "Anulacion de Factura de Venta"
	#define STR0026 "Esta rutina solo se utiliza cuando no hay Integracion con la TIENDA..."
	#define STR0027 "Otros"
	#define STR0028 "Venta Mostrador"
	#define STR0029 "Oficina"
	#define STR0030 "Vehiculos"
	#define STR0031 "Leyenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "Delete "
		#define STR0004 "Deletion of quotations"
		#define STR0005 "Quotation"
		#define STR0006 "Search Order"
		#define STR0007 "Search Invoice"
		#define STR0008 "Sale"
		#define STR0009 "Payment"
		#define STR0010 "Customer: "
		#define STR0011 "Condition: "
		#define STR0012 "Items"
		#define STR0013 "Discount"
		#define STR0014 "Total"
		#define STR0015 "Description  "
		#define STR0016 "Value      "
		#define STR0017 "Date"
		#define STR0018 "Value"
		#define STR0019 "There are bills posted related to this Sales."
		#define STR0020 "Attention"
		#define STR0021 "Cancelling Outflow INV..."
		#define STR0022 "Abort operation anyway?"
		#define STR0023 "Cancelling Order..."
		#define STR0024 "Deleting Bills..."
		#define STR0025 "Cancellation of Sales Invoice"
		#define STR0026 "This routine is used only when there is no Integration with the STORE..."
		#define STR0027 "Others"
		#define STR0028 "Over-the-counter Sale"
		#define STR0029 "Repair Shop"
		#define STR0030 "Vehicles"
		#define STR0031 "Caption"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Excluir"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Exclusão De Orçamentos", "Exclusao de Orcamentos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Orçamento", "Orcamento" )
		#define STR0006 "Consulta Pedido"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Consulta Factura  ", "Consulta Nota Fiscal" )
		#define STR0008 "Venda"
		#define STR0009 "Pagamento"
		#define STR0010 "Cliente: "
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Condição: ", "Condicao: " )
		#define STR0012 "Itens"
		#define STR0013 "Desconto"
		#define STR0014 "Total"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Descrição  ", "Descricao  " )
		#define STR0016 "Valor      "
		#define STR0017 "Data"
		#define STR0018 "Valor"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Há Títulos Liquidados Referentes A Esta Venda..", "Ha titulos baixados referentes a esta Venda.." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "A Cancelar Fact De Saida...", "Cancelando NF de Saida..." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja abortar esta operação ?", "Tem certeza que deseja abortar esta operacao ?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "A Cancelar Pedido...", "Cancelando Pedido..." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Excluindo Títulos...", "Excluindo Titulos..." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Cancelamento de Factura de Venda", "Cancelamento de Nota Fiscal de Venda" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Esta rotina só é utilizada quando não existir integração com o LOJA.", "Esta rotina so e utilizada qdo nao ha Integracao com o LOJA..." )
		#define STR0027 "Outros"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Venda Balcão", "Venda Balcao" )
		#define STR0029 "Oficina"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Veículos", "Veiculos" )
		#define STR0031 "Legenda"
	#endif
#endif
