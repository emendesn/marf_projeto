#ifdef SPANISH
	#define STR0001 "Precio no encontrado"
	#define STR0002 "Atencion. TES de Salida Invalida."
	#define STR0003 "No fue posible la apertura de Comprobante Fiscal"
	#define STR0004 "Item registrado"
	#define STR0005 "Item de tipo Kit registrado"
	#define STR0006 "No fue posible registrar el item"
	#define STR0007 "Registrando Item..."
	#define STR0008 "Cantidad invalida"
	#define STR0009 "Item: "
	#define STR0010 " Bloqueado."
	#define STR0011 "No es posible registrar producto del tipo GE"
	#define STR0012 "No se permite modificar cantidad para Servicio financiero."
	#define STR0013 "Item de servicio no es valido por vincularse a otro producto"
	#define STR0014 "Venta de servicio financiero no se permite para cliente estandar."
	#define STR0015 "Para la venta 'Cupon de regalo', utilice la opcion del 'Menu(F2)'."
	#define STR0016 "No es posible incluir Servicios financieros, porque la venta tiene descuento"
	#define STR0017 "Entre en contacto con su soporte. Por favor, actualice el fuente STWECFCONTROL.PRW y STWZReduction.PRW."
#else
	#ifdef ENGLISH
		#define STR0001 "Price not found"
		#define STR0002 "Attention. Invalid Outflow TIO."
		#define STR0003 "It was not possible to open Receipt"
		#define STR0004 "Registered item"
		#define STR0005 "Item of type registered Kit"
		#define STR0006 "It was not possible to register the item"
		#define STR0007 "Registering Item..."
		#define STR0008 "Invalid quantity"
		#define STR0009 "Item: "
		#define STR0010 " Blocked."
		#define STR0011 "It is not possible to register product of GE type"
		#define STR0012 "Not allowed to edit amount for Financial Service."
		#define STR0013 "Service Item not validated for being related to another product"
		#define STR0014 "Financial Service Sales not allowed for standard Customer."
		#define STR0015 "To sell a 'Gift Certificate', use option at 'Menu(F2)'."
		#define STR0016 "Unable to add Financial Services as sale has discount"
		#define STR0017 "Contact support. Please update source STWECFCONTROL.PRW and STWZReduction.PRW."
	#else
		#define STR0001 "Preço não encontrado"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Atenção. TES de saída inválida.", "Atenção. TES de Saída Inválida." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Não foi possível a abertura do Cupão fiscal", "Nao foi possivel a abertura do Cupom Fiscal" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Item registado", "Item registrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Item do tipo Kit registado", "Item do tipo Kit registrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Não foi possível registar o item", "Nao foi possivel registrar o item" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A registar item...", "Registrando Item..." )
		#define STR0008 "Quantidade inválida"
		#define STR0009 "Item: "
		#define STR0010 " Bloqueado."
		#define STR0011 "Não é possivel registrar produto do tipo GE"
		#define STR0012 "Não é permitido alterar quantidade para Serviço Financeiro."
		#define STR0013 "Item de Serviço não é valido por ser Vinculado á outro produto"
		#define STR0014 "Venda de Serviço Financeiro não permitida para Cliente padrão."
		#define STR0015 "Para a venda de 'Vale Presente', utilizar opção do 'Menu(F2)'."
		#define STR0016 "Não é possível inserir Servicos Financeiros pois venda possui desconto"
		#define STR0017 "Contate o seu suporte. Favor atualizar o fonte STWECFCONTROL.PRW e STWZReduction.PRW."
	#endif
#endif
