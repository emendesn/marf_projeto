#ifdef SPANISH
	#define STR0001 "Error al borrar el numero del comprobante despues de la impresion del pedido. Verifique el ECF."
	#define STR0002 "Error al borrar el numero del PDV tras la impresion del pedido. Verifique el ECF."
	#define STR0003 "Imposible continuar impresion. Ajustar Fecha/Hora de la impresora."
	#define STR0004 "El rdmake SCRPED.PRW no esta compilado y no se podra imprimir el comprobante de venta. Informe este mensaje al administrador del sistema."
	#define STR0005 "Impresora no contesta."
	#define STR0006 "¿Desea imprimirlo nuevamente?"
	#define STR0007 "Espere la impresion del comprobante no fiscal..."
	#define STR0008 "Problemas con la Impresora fiscal"
#else
	#ifdef ENGLISH
		#define STR0001 "Error while getting the receipt number after printing the order. Check ECF."
		#define STR0002 "Error while getting the POS number after printing the order. Check ECF."
		#define STR0003 "Impossible to continue the print. Adjust printer Date/Time."
		#define STR0004 "SCRPED.PRW rdmake is not compiled and the sales transaction receipt cannot be printed. Contact the system administrator concerning this message."
		#define STR0005 "Printer does not answer."
		#define STR0006 "Do you wish to print it again?"
		#define STR0007 "Wait printing non-fiscal receipt...."
		#define STR0008 "Problems with Fiscal Printer"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Erro ao pegar o número do cupão após a impressão do pedido. Verifique o ECF.", "Erro ao pegar o número do cupom após a impressão do pedido. Verifique o ECF." )
		#define STR0002 "Erro ao pegar o número do PDV após a impressão do pedido. Verifique o ECF."
		#define STR0003 "Impossível continuar impressão. Ajustar Data/Hora da impressora."
		#define STR0004 "O rdmake SCRPED.PRW não está compilado e não será possível imprimir o comprovante de venda. Informe essa mensagem ao administrador do sistema."
		#define STR0005 "Impressora não responde."
		#define STR0006 "Deseja imprimir novamente?"
		#define STR0007 "Aguarde a impressão do comprovante não fiscal...."
		#define STR0008 "Problemas com a Impressora Fiscal"
	#endif
#endif
