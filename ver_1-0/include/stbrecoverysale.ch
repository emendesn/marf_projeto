#ifdef SPANISH
	#define STR0001 "Existe un comprobante de caja: "
	#define STR0002 "para ser recuperado. Acceda al sistema con esta caja para concluir la operacion"
	#define STR0003 "El Sistema va a finalizar el Comprobante, pues existe item de reserva."
	#define STR0004 "El Sistema va a finalizar el Comprobante, el presupuesto debe importarse nuevamente"
	#define STR0005 "         COMPROBANTE FISCAL ANULADO         "
#else
	#ifdef ENGLISH
		#define STR0001 "There is a cash receipt: "
		#define STR0002 "to be recovered. Access the system with this cash register to finish the operation"
		#define STR0003 "The receipt is finished by system because there is a reservation item."
		#define STR0004 "The receipt is finished by system. Quotation must be imported again."
		#define STR0005 "         RECEIPT CANCELED         "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Existe um cupão do caixa: ", "Existe um cupom do caixa: " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "para ser recuperado. Acesse o sistema com esse caixa para concluir a operação", "para ser recuperado. Acesse o sistema com esse caixa para concluir a operacao" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "O Sistema finalizará o cupão, pois existe item de reserva.", "O Sistema irá finalizar o Cupom, pois existe item de reserva." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "O Sistema finalizará o cupão. O orçamento deve ser importado novamente", "O Sistema irá finalizar o Cupom, O orçamento deve ser importado novamente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "         CUPÃO FISCAL CANCELADO         ", "         CUPOM FISCAL CANCELADO         " )
	#endif
#endif
