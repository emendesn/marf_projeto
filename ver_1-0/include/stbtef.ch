#ifdef SPANISH
	#define STR0001 "Transaccion TEF confirmada. Por favor reimprimima el utimo comprobante."
	#define STR0002 "No se efectuo la transaccion. Por favor, retenga el comprobante."
	#define STR0003 "TEF no configurado para la estacion."
#else
	#ifdef ENGLISH
		#define STR0001 "TEF Transaction confirmed. Please, re-print the last receipt."
		#define STR0002 "Transaction was not performed. Retain the receipt."
		#define STR0003 "TIO not setup for the station."
	#else
		#define STR0001 "Transa��o TEF comfirmada. Favor reimprimir �timo comprovante."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A transac��o n�o foi efectuada. Por favor, retenha o cup�o.", "Transa��o n�o foi efetuada. Favor reter o cupom." )
		#define STR0003 "TEF n�o configurado para a esta��o."
	#endif
#endif
