#ifdef SPANISH
	#define STR0001 "Elim. de residuos de Pedidos de Compras"
	#define STR0002 "Este prog. tiene como objet. encerrar los Pedidos de Compra, Contrato"
	#define STR0003 "de Asociacion, Autorizaciones de Entrega y Solicit. de Compra, con"
	#define STR0004 "residuos dado de baja, basado en el porc. digitado en los Param."
	#define STR0005 "¿Confirma Elim.Residuos?"
	#define STR0006 "Atencion"
	#define STR0007 "¿De Fecha de Entrega?"
	#define STR0008 "¿A Fecha de Entrega?"
	#define STR0009 "¡no se procesaron los Itemes pues los estan usando en otra estacion!"
#else
	#ifdef ENGLISH
		#define STR0001 "Elimination of Purchase Orders residues"
		#define STR0002 "This program closes the Purchase Orders, Partnership Contract"
		#define STR0003 "Delivery Authorizatinos and Purchase Requests, with"
		#define STR0004 "remainders posted based on the percentage entered in the parameters."
		#define STR0005 "Confirm Elim. Residues ?"
		#define STR0006 "Attention"
		#define STR0007 "Delivery Date from?"
		#define STR0008 "Delivery Date to?"
		#define STR0009 " items were not processed, as they were in use at another station!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Elim. De Resíduos Dos Pedidos De Compras", "Elim. de resíduos dos Pedidos de Compras" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este Programa Tem Como Objectivo Fechar Os Pedidos De Compra, Contrato", "Este programa tem como objetivo fechar os Pedidos de Compra, Contrato" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "De parceria, autorizações de entrega e solicitações de compra, com", "de Parceria, Autorizaçoes de Entrega e Solicitaçoes de Compra, com" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Resíduos Liquidados, Baseado Na Percentagem Digitada Nos Parâmetros.", "residuos baixados, baseado na porcentagem digitada nos Parâmetros." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Confirma elim. resíduos ?", "Confirma Elim. Resíduos ?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atençäo" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Data de entrega de ?", "Data de Entrega de ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Data de entrega até?", "Data de Entrega ate?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " itens não foram processados por estar em utilização  em outra estação!", " itens näo foram processados por estar em uso em outra estacao!" )
	#endif
#endif
