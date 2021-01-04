#ifdef SPANISH
	#define STR0001 "Solicitud por punto de pedido"
	#define STR0002 "El objetivo de este programa es generar la solicitud de compra de"
	#define STR0003 "los materiales que alcanzaron el punto de pedido. Sera considerado:"
	#define STR0004 "lote economico, stock de seguridad, lote minimo, tolerancia y el"
	#define STR0005 "plazo de  entrega del  material.   Para obtener una previa de las"
	#define STR0006 "compras  es  posible  emitir  el informe de los itemes en punto de"
	#define STR0007 "pedido, encontrado en el menu INFORME.  "
	#define STR0008 "�Genera solicitud por punto de pedido?"
	#define STR0009 "Atencion"
	#define STR0010 "Actualizar "
#else
	#ifdef ENGLISH
		#define STR0001 "Request by Point of Order      "
		#define STR0002 "The purpose of this program is to generate Purchase Requests to "
		#define STR0003 "the material that reachs the Point of Order. It will consider the"
		#define STR0004 "Economic Lot, the Security Stock, the Minimum Lot, Tolerance and the"
		#define STR0005 "Time of Delivery. To obtain a preview of the purchases you can "
		#define STR0006 "print the Report of Point of Order Items, located in the REPORT"
		#define STR0007 "Menu              "
		#define STR0008 "Generate Requests by Point of Order  ?"
		#define STR0009 "Attention"
		#define STR0010 "Update  "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Cria Solicita��o por Ponto de Pedido ?", "Solicita��o por Ponto de Pedido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo criar solicita��es de compra para", "Este programa tem como objetivo gerar Solicita��es de Compra para" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Os materiais  que atingiram o ponto de pedido.  ele ir� considerar o", "os materiais  que atingiram o Ponto de Pedido.  Ele ir� considerar o" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Lote econ�mico, o stock de seguran�a, o lote m�nimo, a toler�ncia e o", "Lote Econ�mico, Estoque de Seguran�a, Lote M�nimo, Tolerancia   e o" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Prazo de entrega do material. para obter uma lista pr�via das compras", "Prazo de Entrega do material. Para obter uma pr�via das compras voc�" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Poder� emitir o  relat�rio de  itens que se encontra no men�", "poder� emitir o  Relat�rio de  Itens em Ponto de Pedido, encontrado" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Como Pedido", "no Menu de RELATORIO" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cria Solicita��o por Ponto de Pedido ?", "Gera Solicita��o por Ponto de Pedido ?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Aten��o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Actualizar ", "Atualizar " )
	#endif
#endif
