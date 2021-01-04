#ifdef SPANISH
	#define STR0001 "Este documento pertenece a una Convocatoria y no puede modificarse la Cantidad y/o Valor."
	#define STR0002 "ATENCION"
	#define STR0003 " solo podra modificarse mediante la factura previa de entrada, porque la Factura ya se libero del bloqueo de tolerancia de recepcion."
	#define STR0004 "El campo de "
	#define STR0005 "precio unitario"
	#define STR0006 "Vinculado al Pedido de venta: "
	#define STR0007 "Verifique el Item Fact: "
	#define STR0008 "El Pedido de compra no puede vincularse la Factura de compra, porque tiene vinculo con el Pedido de ventas generado por el proceso de la Central de compras de distribucion que aun no se facturo."
	#define STR0009 "Verifique el item Fact: "
	#define STR0010 "Es necesario vincular el Documento de entrada a un Pedido de compras centralizado."
	#define STR0011 "Atencion: Para que sea posible bajar el Pedido centralizado es necesario que el parametro MV_VPCCNFE este configurado con un valor diferente de CERO. �Verifique su contenido!"
	#define STR0012 "Saldo en el Pedido centralizado: "
	#define STR0013 "No existe saldo disponible en el Pedido de compras centralizado;"
	#define STR0014 "Producto no ubicado en ningun Pedido de compras centralizado."
	#define STR0015 "Atencion: El parametro MV_VPCCNFE esta activado. Verifique si los campos: D1_PCCENTR y D1_ITPCCEN estan marcados como UTILIZADO en el Configurador."
	#define STR0016 "La Factura no puede borrarse, porque tiene vinculo con otro Proceso."
	#define STR0017 "Verifique Pedido de venta: "
	#define STR0018 "Clave: "
#else
	#ifdef ENGLISH
		#define STR0001 "This document belongs to a Notice and cannot have its Amount and/or Value changed."
		#define STR0002 "ATTENTION"
		#define STR0003 " will only be changed by inbound pre-invoice, because the Invoice has been released from the receiving tolerance block."
		#define STR0004 "The field of "
		#define STR0005 "unit price"
		#define STR0006 "Related to Sales Order: "
		#define STR0007 "Check Invoice Item: "
		#define STR0008 "Purchase Request can not be related to Purchase Note, since binding with Sales Order generated by the Purchase Distribution Center process that was not invoiced!"
		#define STR0009 "Check Invoice Item: "
		#define STR0010 "The Inflow Document must be related to a Centralized Purchase Order!"
		#define STR0011 "Attention: In order to download Centered Order, the parameter MV_VPCCNFE must be configured with value different from ZERO. Check the content!"
		#define STR0012 "Balance in Centralized Order: "
		#define STR0013 "There is no balance available in the Centralized Purchase Order!"
		#define STR0014 "Product not found in any Centralized Purchase Order!"
		#define STR0015 "Attention: Parameter MV_VPCCNFE is active. Check if fields D1_PCCENTR and D1_ITPCCEN are set as USED in Configurator."
		#define STR0016 "Invoice cannot be deleted, as it is linked to another process!"
		#define STR0017 "Check Sales Order: "
		#define STR0018 "Key: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Este documento pertence � um Edital e nao poder� ocorrer altera��o na Quantidade e/ou Valor." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "ATENCAO" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , " s� poder� ser alterado atrav�s da pr�-nota de entrada, pois a Nota Fiscal j� foi liberada do bloqueio de toler�ncia de recebimento." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "O campo de " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "pre�o unit�rio" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Vinculado ao Pedido de Venda: " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Verifique o Item NF: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Pedido de Compra n�o pode ser vinculado a Nota de Compra, pois possui amarra��o com o Pedido de Vendas gerado pelo processo de Central de Compras de Distribui��o que ainda n�o foi faturado !" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Verifique o Item NF: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "� necess�rio vincular o Documento de Entrada a um Pedido de Compras Centralizado !" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Aten��o: Para que seja poss�vel baixar o Pedido Centralizado, � necess�rio que o par�metro MV_VPCCNFE esteja configurado com valor diferente de ZERO. Verifique o seu conte�do !" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Saldo no Pedido Centralizado: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "N�o existe saldo dispon�vel no Pedido de Compras Centralizado !" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Produto n�o localizado em nenhum Pedido de Compras Centralizado !" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Aten��o: O par�metro MV_VPCCNFE est� ativado. Verifique se os campos: D1_PCCENTR e D1_ITPCCEN est�o marcados como USADO no Configurador." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Nota Fiscal n�o pode ser Excluida, pois possui vinculo com outro Processo !" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Verifique Pedido de Venda: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Chave: " )
	#endif
#endif