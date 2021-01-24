#ifdef SPANISH
	#define STR0001 "El registro no se encontro en la base de destino."
	#define STR0002 "Clave del registro no enviada, es  necesaria para registrar el de-a"
	#define STR0003 "Tag de operacion 'Event' inexistente."
	#define STR0004 "Event"
	#define STR0005 "Version de mensaje no procesada por el Protheus, las posibles son: "
	#define STR0006 "Xml mal configurado "
	#define STR0007 "No se envio el contenido de devolucion para archivo de-a"
	#define STR0008 "Error en procesamiento por la otra aplicacion"
	#define STR0009 "Error en procesamiento, pero sin detalles de error por la otra aplicacion"
	#define STR0010 "Proveedor no encontrado en el Protheus."
	#define STR0011 "Proveedor no informado."
	#define STR0012 "Para la integración Newhotel, la interfaz de comisión debe ser 'S' - Cuentas por pagar."
	#define STR0013 "Interfaz de comisión no informada."
#else
	#ifdef ENGLISH
		#define STR0001 "Register not found in destination database."
		#define STR0002 "Record key has not been sent, you must register the from-to"
		#define STR0003 "Inexistent 'Event' operation tag."
		#define STR0004 "Event"
		#define STR0005 "Version of message not handled by Protheus. The possible ones are: "
		#define STR0006 "Xml badly formatted "
		#define STR0007 "No feedback content sent to from-to register"
		#define STR0008 "Processing error by the other application"
		#define STR0009 "Processing error, but without error details by the other application"
		#define STR0010 "Supplier not found at Protheus."
		#define STR0011 "Supplier not entered"
		#define STR0012 "For Newhotel integration, the interface of commission must be Y - Payable Accounts."
		#define STR0013 "Commission Interface not entered."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "O registro não foi encontrado na base de destino." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Chave do registro não enviada, é necessária para cadastrar o de-para" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Tag de operação 'Event' inexistente." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Event" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Versão da mensagem não tratada pelo Protheus, as possíveis são: " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Xml mal formatado " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Não enviado conteúdo de retorno para cadastro de de-para" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Erro no processamento pela outra aplicação" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Erro no processamento, mas sem detalhes do erro pela outra aplicação" )
		#define STR0010 "Fornecedor não encontrado no Protheus."
		#define STR0011 "Fornecedor não informado."
		#define STR0012 "Para a integração Newhotel, a interface de comissão deve ser 'S' - Contas a Pagar."
		#define STR0013 "Interface de comissão não informada."
	#endif
#endif
