#ifdef SPANISH
	#define STR0001 "Busca"
	#define STR0002 "Borrado Fact/Presup"
	#define STR0003 "Salir"
	#define STR0004 "Confirma"
	#define STR0005 "Totales"
	#define STR0006 "Impuestos"
	#define STR0007 "�Cuanto al borrado?"
	#define STR0008 "Valor mercaderia"
	#define STR0009 "Aumento"
	#define STR0010 "Gastos"
	#define STR0011 "Descuentos"
	#define STR0012 "Valor del Flete"
	#define STR0013 "Total del Pedido"
	#define STR0014 "Esta factura posee uno o varios t�tulos liquidados en otra fecha y no podra ser borrada sin que se realice la anulacion de las liquidaciones por el m�dulo financiero"
	#define STR0015 "  Sucursal:"
	#define STR0016 "  Prefijo:"
	#define STR0017 "  Numero:"
	#define STR0018 "  Cuota:"
	#define STR0019 "  Tipo:"
	#define STR0020 "  Cliente:"
	#define STR0021 "  Tienda:"
	#define STR0022 "  Fecha de la Liquidacion"
	#define STR0023 "Esta atencion fue anulada por la rutina de borrado de Pedido de Televendas el :"
	#define STR0024 "Leyenda"
	#define STR0025 "Atencion con Pedido"
	#define STR0026 "Atencion con factura emitida"
	#define STR0027 "Atencion con Presupuesto"
	#define STR0028 "Atencion"
	#define STR0029 "Atencion Anulada"
	#define STR0030 "Atencion"
	#define STR0031 "Registre un Grupo de Atencion valido en el parametro MV_POSTO."
	#define STR0032 "La Factura debe borrarse en la facturacion para que el pedido tambien pueda borrarse en el Call Center"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "Delete Inv./Budg."
		#define STR0003 "Quit"
		#define STR0004 "OK"
		#define STR0005 "Totals"
		#define STR0006 "Taxes"
		#define STR0007 "About Deleting ?"
		#define STR0008 "Goods� Value"
		#define STR0009 "Increase"
		#define STR0010 "Expensess"
		#define STR0011 "Discounts"
		#define STR0012 "Freight Value"
		#define STR0013 "Total of Order"
		#define STR0014 "This invoice has bills posted in another date and cannot be excluded without the cancellation of all postings through the financial module"
		#define STR0015 "  Branch:"
		#define STR0016 "  Prefix:"
		#define STR0017 "  Number:"
		#define STR0018 "  Install."
		#define STR0019 "  Type:"
		#define STR0020 "  Customer"
		#define STR0021 "  Shop:"
		#define STR0022 "  Posting date"
		#define STR0023 "This service was cancelled by the Telesales Order deletion routine on :"
		#define STR0024 "Caption"
		#define STR0025 "Servicing with Order"
		#define STR0026 "Servicing with issued Inv"
		#define STR0027 "Servicing with Budget"
		#define STR0028 "Servicing"
		#define STR0029 "Cancelled Service "
		#define STR0030 "Warning"
		#define STR0031 "Enter a valid Servicing Group in parameter MV_POSTO."
		#define STR0032 "Invoice must be deleted in Billing so that the order can also be deleted in Call Center"
	#else
		#define STR0001 "Pesquisa"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Elimina��o", "Exclusao" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0004 "Confirma"
		#define STR0005 "Totais"
		#define STR0006 "Impostos"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Quanto � elimina��o ?", "Quanto a exclus�o ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Valor Da Mercadoria", "Valor Mercadoria" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Acr�scimo", "Acrescimo" )
		#define STR0010 "Despesas"
		#define STR0011 "Descontos"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Valor Do Frete", "Valor do Frete" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total Do Pedido", "Total do Pedido" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Esta factura possui t�tulo(s) liquidado(s) noutra data e n�o poder� ser eliminada sem que seja realizado o cancelamento das baixas pelo m�dulo financeiro", "Esta nota fiscal possui t�tulo(s) baixado(s) em outra data e n�o poder� ser exclu�da sem que seja realizado o cancelamento das baixas pelo m�dulo financeiro" )
		#define STR0015 "  Filial:"
		#define STR0016 "  Prefixo:"
		#define STR0017 "  N�mero:"
		#define STR0018 "  Parcela:"
		#define STR0019 "  Tipo:"
		#define STR0020 "  Cliente:"
		#define STR0021 "  Loja:"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "  Data Da Liquida��o", "  Data da Baixa" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Este atendimento foi cancelado pelo procedimento de exclus�o de pedido de televendas em :", "Esse atendimento foi cancelado pela rotina de exclus�o de Pedido do Televendas em :" )
		#define STR0024 "Legenda"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Atendimento Com Pedido", "Atendimento com Pedido" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Atendimento com nf emitida", "Atendimento com NF emitida" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Atendimento Com Or�amento", "Atendimento com Orcamento" )
		#define STR0028 "Atendimento"
		#define STR0029 "Atendimento Cancelado"
		#define STR0030 "Aten��o"
		#define STR0031 "Cadastre um Grupo de Atendimento v�lido no par�metro MV_POSTO."
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "A Factura Deve Ser Exclu�da Na Factura��o Para Que O Pedido Tamb�m Possa Ser Exclu�do No Call Center", "A NF deve ser excluida no Faturamento para que o pedido tamb�m possam ser exclu�do no Call Center" )
	#endif
#endif
