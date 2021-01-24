#ifdef SPANISH
	#define STR0001 "Anulación de venta de boletos"
	#define STR0002 "Boletos CON Financiero"
	#define STR0003 "Boletos SIN Financiero"
	#define STR0004 "¡Atención!"
	#define STR0005 "¿Anula boleto ?"
	#define STR0006 "¡Anulación de boleto no efectuada!"
	#define STR0007 "¡Título por cobrar, referente al boleto, no encontrado!"
	#define STR0008 "Se borró el título: "
	#define STR0009 "Prefijo: "
	#define STR0010 "Número: "
	#define STR0011 "Cuota: "
	#define STR0012 "Tipo: "
	#define STR0013 "Cliente: "
	#define STR0014 "Valor: "
	#define STR0015 "Título por cobrar: "
	#define STR0016 " ¡de los títulos!"
	#define STR0017 "No fue posible la compensación"
	#define STR0018 "Se compensaron los títulos: "
	#define STR0019 "Prefijo: "
	#define STR0020 "Número: "
	#define STR0021 "Cuota: "
	#define STR0022 "Tipo: "
	#define STR0023 "Cliente: "
	#define STR0024 "Valor: "
	#define STR0025 "Prefijo: "
	#define STR0026 "Número: "
	#define STR0027 "Cuota: "
	#define STR0028 "Tipo: "
	#define STR0029 "Cliente: "
	#define STR0030 "Valor: "
	#define STR0031 "Títulos compensados"
	#define STR0032 "Se Incluyó el título: "
	#define STR0033 "Prefijo: "
	#define STR0034 "Número: "
	#define STR0035 "Cuota: "
	#define STR0036 "Tipo: "
	#define STR0037 "Cliente: "
	#define STR0038 "Valor: "
	#define STR0039 "Título por cobrar: "
	#define STR0040 "Se incluyó el título por pagar: "
	#define STR0041 "Prefijo: "
	#define STR0042 "Número: "
	#define STR0043 "Tipo: "
	#define STR0044 "Proveedor: "
	#define STR0045 "Valor: "
	#define STR0046 "Título por pagar: "
	#define STR0047 "Se anuló el boleto:"
	#define STR0048 "Agencia: "
	#define STR0049 "Boleto: "
	#define STR0050 "Valor: "
	#define STR0051 "Boleto:  "
#else
	#ifdef ENGLISH
		#define STR0001 "Ticket Sales Cancel"
		#define STR0002 "Ticket WITH Finances"
		#define STR0003 "Ticket WITHOUT Finances"
		#define STR0004 "Attention!"
		#define STR0005 "Cancels Ticket ?"
		#define STR0006 "Ticket cancel not performed!"
		#define STR0007 "Receivable bill, regarding the ticket, not found!"
		#define STR0008 "The Bill was Deleted: "
		#define STR0009 "Prefix: "
		#define STR0010 "Number: "
		#define STR0011 "Installment: "
		#define STR0012 "Type: "
		#define STR0013 "Customer: "
		#define STR0014 "Value: "
		#define STR0015 "Receivable Bill: "
		#define STR0016 " of bills!"
		#define STR0017 "Unable to compensate"
		#define STR0018 "The Bills were Compensated: "
		#define STR0019 "Prefix: "
		#define STR0020 "Number: "
		#define STR0021 "Installment: "
		#define STR0022 "Type: "
		#define STR0023 "Customer: "
		#define STR0024 "Value: "
		#define STR0025 "Prefix: "
		#define STR0026 "Number: "
		#define STR0027 "Installment: "
		#define STR0028 "Type: "
		#define STR0029 "Customer: "
		#define STR0030 "Value: "
		#define STR0031 "Bills Compensated"
		#define STR0032 "The Bill was Added: "
		#define STR0033 "Prefix: "
		#define STR0034 "Number: "
		#define STR0035 "Installment: "
		#define STR0036 "Type: "
		#define STR0037 "Customer: "
		#define STR0038 "Value: "
		#define STR0039 "Receivable Bill: "
		#define STR0040 "The Payable Bill was Added: "
		#define STR0041 "Prefix: "
		#define STR0042 "Number: "
		#define STR0043 "Type: "
		#define STR0044 "Supplier: "
		#define STR0045 "Value: "
		#define STR0046 "Payable Bill: "
		#define STR0047 "The ticket was canceled:"
		#define STR0048 "Bank Office: "
		#define STR0049 "Ticket: "
		#define STR0050 "Value: "
		#define STR0051 "Ticket:  "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cancelamento de Venda de Bilhetes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Bilhete COM Financeiro" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Bilhete SEM Financeiro" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Atenção!" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Cancela Bilhete ?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Cancelamento de bilhete não efetuado!" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Título a receber, referente ao bilhete, não encontrado!" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Foi Excluído o Titulo: " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Parcela: " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Cliente: " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Titulo a Receber: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , " dos titulos!" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Não foi possível a compensação" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Foram Compensados os Titulo: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Parcela: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Cliente: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Parcela: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Cliente: " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Titulos Compensados" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Foi Incluído o Titulo: " )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Parcela: " )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Cliente: " )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Titulo a Receber: " )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Foi Incluído o Titulo a Pagar: " )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Fornecedor: " )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Titulo a Pagar: " )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Foi cancelado o bilhete:" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", , "Agencia: " )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", , "Bilhete: " )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", , "Bilhete:  " )
	#endif
#endif
