#ifdef SPANISH
	#define STR0001 "Falla en la obtencion del comprobante"
	#define STR0002 "Atencion, No fue posible realizar la transaccion con el respectivo bancario"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure in getting coupon"
		#define STR0002 "Attention, it was not possible to complete the transaction with the corresponding bank"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Falha na obten��o do cup�o", "Falha na obten��o do cupom" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Aten��o, n�o foi poss�vel realizar a transac��o com correspondente banc�rio", "Atencao, Nao foi possivel realizar a transacao com correspondente bancario" )
	#endif
#endif
