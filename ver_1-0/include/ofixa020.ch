#ifdef SPANISH
	#define STR0001 "Pedidos de transferencia de piezas"
	#define STR0002 "Buscar"
	#define STR0003 "Aceptar Transf."
	#define STR0004 "Rechazar Transf."
	#define STR0005 "T.E.S."
	#define STR0006 "Pedido atendido"
	#define STR0007 "Leyenda"
	#define STR0008 "Pedido rechazado"
	#define STR0009 "Fact. emitida"
	#define STR0010 "Entrada confirmada"
	#define STR0011 "�Desea aceptar la transferencia?"
	#define STR0012 "�Desea RECHAZAR la transferencia?"
	#define STR0013 "Atencion"
	#define STR0014 "Observacion"
	#define STR0015 "El item no tiene stock en ninguna sucursal."
	#define STR0016 "Cantidad solicitada"
	#define STR0017 "La cantidad solicitada es mayor que la cantidad de la pieza en el presupuesto."
	#define STR0018 "Piezas en exceso"
	#define STR0019 "Cantidad faltante :"
	#define STR0020 "Saldos en exceso para el producto "
	#define STR0021 "Sucursal"
	#define STR0022 "Saldo"
	#define STR0023 "Solicitada"
	#define STR0024 "Pedido pendiente"
	#define STR0025 "El usuario debe estar logado en la sucursal del pedido para aceptar una transferencia."
	#define STR0026 "El usuario debe estar logado en la sucursal del pedido para rechazar una transferencia."
	#define STR0027 "Se rechazo el pedido."
	#define STR0028 "Producto no tiene valor de costo, �imposible continuar!"
	#define STR0029 "Tp Operaci�n"
	#define STR0030 "�TES informado no es de salida!"
	#define STR0031 "�TES informado no actualiza stock, imposible continuar!"
#else
	#ifdef ENGLISH
		#define STR0001 "Part Transfer Orders"
		#define STR0002 "Search"
		#define STR0003 "Accept Transfer"
		#define STR0004 "Reject Transfer"
		#define STR0005 "TIO"
		#define STR0006 "Order fulfilled"
		#define STR0007 "Caption"
		#define STR0008 "Order rejected"
		#define STR0009 "Invoice issued"
		#define STR0010 "Inflow confirmed"
		#define STR0011 "Do you want to accept the transfer?"
		#define STR0012 "Do you want to REJECT the transfer?"
		#define STR0013 "Attention"
		#define STR0014 "Note"
		#define STR0015 "No item stock in all branches."
		#define STR0016 "Quantity Requested"
		#define STR0017 "The quantity requested is larger than the part quantity in the quotation."
		#define STR0018 "Parts in Excess"
		#define STR0019 "Missing Quantity:"
		#define STR0020 "Exceeding balance for the product "
		#define STR0021 "Branch"
		#define STR0022 "Balance"
		#define STR0023 "Requested"
		#define STR0024 "Pending Order"
		#define STR0025 "User must be logged in to the order branch to accept a transfer."
		#define STR0026 "User must be logged in to the order branch to reject a transfer."
		#define STR0027 "The order was rejected."
		#define STR0028 "Product does not have dost value, impossible to continue!"
		#define STR0029 "Operation Tp."
		#define STR0030 "TIO entered is not an outflow TIO"
		#define STR0031 "TIO entered does not update inventory, impossible to continue!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Pedidos de transfer�ncia de pe�as", "Pedidos de Transfer�ncia de Pe�as" )
		#define STR0002 "Pesquisar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Aceitar transf.", "Aceitar Transf." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Rejeitar transf.", "Rejeitar Transf." )
		#define STR0005 "T.E.S."
		#define STR0006 "Pedido atendido"
		#define STR0007 "Legenda"
		#define STR0008 "Pedido rejeitado"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Fact. emitida", "NF emitida" )
		#define STR0010 "Entrada confirmada"
		#define STR0011 "Deseja aceitar a transfer�ncia ?"
		#define STR0012 "Deseja REJEITAR a transfer�ncia ?"
		#define STR0013 "Aten��o"
		#define STR0014 "Observa��o"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "O item n�o possui stock em nenhuma filial.", "O item n�o possui estoque em nenhuma filial." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Quantidade solicitada", "Quantidade Solicitada" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "A quantidade solicitada � maior que a quantidade da pe�a no or�amento.", "Quantidade solicitada � maior que a quantidade da pe�a no or�amento." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Pe�as em excesso", "Pe�as em Excesso" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Quantidade faltante :", "Quantidade Faltante :" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Saldos em excesso para o artigo ", "Saldos em excesso para o produto " )
		#define STR0021 "Filial"
		#define STR0022 "Saldo"
		#define STR0023 "Solicitada"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Pedido pendente", "Pedido Pendente" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "O utilizador deve estar conectado � filial do pedido para aceitar uma transfer�ncia.", "O usu�rio deve estar logado na filial do pedido para aceitar uma transfer�ncia." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "O utilizador deve estar conectado � filial do pedido para rejeitar uma transfer�ncia.", "O usu�rio deve estar logado na filial do pedido para rejeitar uma transfer�ncia." )
		#define STR0027 "O pedido foi rejeitado."
		#define STR0028 "Produto n�o possui valor do custo, imposs�vel continuar!"
		#define STR0029 "Tp Opera��o"
		#define STR0030 "TES informado n�o � de Sa�da!"
		#define STR0031 "TES informado n�o atualiza estoque, imposs�vel continuar!"
	#endif
#endif