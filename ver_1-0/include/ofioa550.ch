#ifdef SPANISH
	#define STR0001 "Pedido de Garantia Mutua"
	#define STR0002 "No es posible modificar pedido de garantia con estatus diferente de Pendiente Liberacion."
	#define STR0003 "Pendiente Liberacion"
	#define STR0004 "Liberado"
	#define STR0005 "Rechazado"
	#define STR0006 "Anulado"
	#define STR0007 "Leyenda"
	#define STR0008 "Buscar"
	#define STR0009 "Visualizar"
	#define STR0010 "Liberar"
	#define STR0011 "Rechazar"
	#define STR0012 "Atencion"
	#define STR0013 "Existe una solicitud de garant�a mutua creada para la OS."
	#define STR0014 "Nueva sol."
	#define STR0015 "Continuar"
	#define STR0016 "�Desea crear una nueva solicitud relacionando este presupuesto o continuar la exportacion?"
	#define STR0017 "Total estimado"
	#define STR0018 "OS de garantia mutua pero aun no tiene solicitud generada."
#else
	#ifdef ENGLISH
		#define STR0001 "Mutual Guarantee Request"
		#define STR0002 "You cannot change a guarantee request with status different from Pending Approval."
		#define STR0003 "Pending Approval"
		#define STR0004 "Released"
		#define STR0005 "Rejected"
		#define STR0006 "Canceled"
		#define STR0007 "Caption"
		#define STR0008 "Search"
		#define STR0009 "View"
		#define STR0010 "Release"
		#define STR0011 "Reject"
		#define STR0012 "Attention"
		#define STR0013 "There is a mutual guarantee request created for the SO."
		#define STR0014 "New Request"
		#define STR0015 "Continue"
		#define STR0016 "Do you want to create a new request related to this budget or to continue the export?"
		#define STR0017 "Total estimado"
		#define STR0018 "OS de garantia m�tua mas ainda n�o possui solicita��o gerada."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Pedido de garantia m�tua", "Pedido de Garantia M�tua" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel alterar pedido de garantia com estado diferente de Pendente libera��o.", "N�o � poss�vel alterar pedido de garantia com status diferente de Pendente Libera��o." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Pendente libera��o", "Pendente Libera��o" )
		#define STR0004 "Liberado"
		#define STR0005 "Rejeitado"
		#define STR0006 "Cancelado"
		#define STR0007 "Legenda"
		#define STR0008 "Pesquisar"
		#define STR0009 "Visualizar"
		#define STR0010 "Liberar"
		#define STR0011 "Rejeitar"
		#define STR0012 "Aten��o"
		#define STR0013 "Existe uma solicita��o de garantia m�tua criada para a OS."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Nova sol.", "Nova Sol." )
		#define STR0015 "Continuar"
		#define STR0016 "Deseja criar uma nova solicita��o relacionando este or�amento ou continuar a exporta��o?"
		#define STR0017 "Total estimado"
		#define STR0018 "OS de garantia m�tua mas ainda n�o possui solicita��o gerada."
	#endif
#endif
