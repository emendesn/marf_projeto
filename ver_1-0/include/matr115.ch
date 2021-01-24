#ifdef SPANISH
	#define STR0001 "Control de entrega de las Solicitudes al Depos."
	#define STR0002 " Este informe lista la posicion de los requerimientos previos generados por las"
	#define STR0003 "solicitudes al deposito segun los parametros elegidos."
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
	#define STR0007 "ANULADO POR EL OPERADOR"
	#define STR0008 "Numero   Sec.   Codigo            Descripcion                      Necesidad          Cantidad       Ctd. Disponible     Numero SC    Numero Pedido          Centro de Costo    Solicitante"
	#define STR0009 "Items de Solic. Prev."
	#define STR0010 "Numero   Sec.   Codigo                           Descripc.                        Necesidad          Cantidad       Cant. Disponib.     Numero SC    Numero Pedido         Centro de Costo    Solicitante"
#else
	#ifdef ENGLISH
		#define STR0001 "Delivery Control on Warehouse Requisitions."
		#define STR0002 "  This report shows the pre-Requisitions status, generated by"
		#define STR0003 "warehouse requisitions according to the selected parameters."
		#define STR0005 "Z.Form"
		#define STR0006 "Management"
		#define STR0007 "CANCELLED BY THE OPERATOR"
		#define STR0008 "Number   Seq.   Code              Description                      Necessity          Quantity       Qtty. Available     Wareh.Req.   Order Number     Cost Center        Petitioner"
		#define STR0009 "Pre-requisition items  "
		#define STR0010 "Seq.Number   Code                           Description                      Necessity        Amount     Amt. Available     SC Number    Order Number         Cost Center    requestor"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Controle De Entrega Das Solicita��es Ao Armaz.", "Controle de entrega das Solicitacoes ao Armaz." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "  este relat�rio lista a posi��o das pr�-requisi��es criadas pelas", "  Este relatorio lista a posicao das Pre-Requisicoes geradas pelas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Solicita��es ao armaz�m de acordo com par�metros seleccionados.", "solicitacoes ao armazem de acordo com parametros selecionados." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "N�mero   Seq.   C�digo            Descri��o                        Necessidade        Quantidade     Qtd. Dispon�vel     N�mero Sc    N�mero Pedido         Centro De Custo    Solicitante", "Numero   Seq.   Codigo            Descricao                        Necessidade        Quantidade     Qtd. Disponivel     Numero SC    Numero Pedido         Centro de Custo    Solicitante" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Itens da pr�-requisi��o", "Itens da pre-requisi��o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "N�mero   Seq.   C�digo                           Descri�ao                        Necessidade        Quantidade     Qtd. Dispon�vel     N�mero SC    N�mero Pedido         Centro de Custo    Solicitante", "Numero   Seq.   Codigo                           Descricao                        Necessidade        Quantidade     Qtd. Disponivel     Numero SC    Numero Pedido         Centro de Custo    Solicitante" )
	#endif
#endif
