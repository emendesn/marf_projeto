#ifdef SPANISH
	#define STR0001 "INFORME EL RFC /CNPJ PARA IMPRESION"
	#define STR0002 "RFC/CUIT"
	#define STR0003 "Cliente"
	#define STR0004 "Direccion"
	#define STR0005 "�Imprime datos en comprobante fiscal?"
	#define STR0006 "�RFC/CUIT invalido!"
	#define STR0007 "Nombre/Direccion no informada"
	#define STR0008 "�Desea informar el CPF/CNPJ para impresion?"
	#define STR0009 "Nombre del Cliente"
	#define STR0010 "Confirmar"
	#define STR0011 "Anular"
	#define STR0012 "No se puede informar el RCPF, pues el comprobante fiscal ya se abri�."
#else
	#ifdef ENGLISH
		#define STR0001 "INDICATE CPF / CNPJ FOR PRINT"
		#define STR0002 "CPF/CNPJ"
		#define STR0003 "Customer"
		#define STR0004 "Address"
		#define STR0005 "Print data in receipt?"
		#define STR0006 "CPF/CNPJ not valid!"
		#define STR0007 "Name/Address not provided"
		#define STR0008 "Do you with to enter the CPF/CNPJ for printing?"
		#define STR0009 "Customer's Name"
		#define STR0010 "Confirm"
		#define STR0011 "Cancel"
		#define STR0012 "Cannot enter CPF, because the tax receipt is already open."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "INFORME O NO. CONTRIB. PARA IMPRESS�O", "INFORME O CPF / CNPJ PARA IMPRESS�O" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "NO. CONTRIB.", "CPF/CNPJ" )
		#define STR0003 "Cliente"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Morada", "Endereco" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Imprime dados no cup�o fiscal?", "Imprime dados no cupom fiscal?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "No.Contrib. inv�lido.", "CPF/CNPJ inv�lido!" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Nome/Morada n�o informado", "Nome/Endere�o n�o informado" )
		#define STR0008 "Deseja informar o CPF/CNPJ para impress�o?"
		#define STR0009 "Nome do Cliente"
		#define STR0010 "Confirmar"
		#define STR0011 "Cancelar"
		#define STR0012 "N�o � poss�vel informar o CPF, pois o cupom fiscal j� foi aberto."
	#endif
#endif
