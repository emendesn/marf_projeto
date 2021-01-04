#ifdef SPANISH
	#define STR0001 "�Falla para obtener el numero del comprobante fiscal!"
	#define STR0002 "Valor invalido."
	#define STR0003 "Falla en la obtencion del Contador de Operacion No Fiscal"
	#define STR0004 "Falla en la obtencion del Contador de CDC"
	#define STR0005 "Falla en la obtencion del Contador de Informe Gerencial"
	#define STR0006 "La transaccion no fue efectuada. Favor retener el cupon."
	#define STR0007 "No fue posible efectuar la transaccion con TEF, �desea continuar manualmente?"
	#define STR0008 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure to get receipt number!"
		#define STR0002 "Value not valid."
		#define STR0003 "Failure in obtainment of not fiscal operation counter"
		#define STR0004 "Failure in obtainment of CDC counter"
		#define STR0005 "Failure in obtainment of managerial report counter"
		#define STR0006 "Transaction was not performed. Retain the receipt."
		#define STR0007 "Could not perform EFT transaction. Continue manually?"
		#define STR0008 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Falha para obter o n�mero do cup�o fiscal.", "Falha para obter o n�mero do cupom fiscal!" )
		#define STR0002 "Valor inv�lido."
		#define STR0003 "Falha na obten��o do Contador de Opera��o Nao Fiscal"
		#define STR0004 "Falha na obten��o do Contador de CDC"
		#define STR0005 "Falha na obten��o do Contador de Relatorio Gerencial"
		#define STR0006 "Transa��o n�o foi efetuada. Favor reter o cupom."
		#define STR0007 "N�o foi possivel efetuar a transa��o com TEF, deseja continuar manualmente?"
		#define STR0008 "Aten��o"
	#endif
#endif