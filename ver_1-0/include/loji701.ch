#ifdef SPANISH
	#define STR0001 "�Error en el parser!"
	#define STR0002 "�Version del mensaje no informada!"
	#define STR0003 "�La version del mensaje informado no se implemento!"
	#define STR0004 "Marca no integrada al Protheus, verifique la marca de integracion"
	#define STR0005 "Estaci�n no se inform� en la integraci�n, verifique la Tag StationId o StationInternalId."
	#define STR0006 "Comprobante o serie no informados, verifique las tag: DocumentId y SerieId"
	#define STR0007 "Cliente:"
	#define STR0008 "no integrado al Protheus, verifique integraci�n de clientes"
	#define STR0009 "Operador:"
	#define STR0010 "no integrado al Protheus, verifique integraci�n de operador"
	#define STR0011 "Estacion: "
	#define STR0012 "no integrada al Protheus, verifique integraci�n de Estaci�n"
	#define STR0013 "Producto:"
	#define STR0014 "no integrado al Protheus, verifique integraci�n de Producto"
	#define STR0015 "Documento:"
	#define STR0016 "Serie:"
	#define STR0017 "Tienda:"
	#define STR0018 "Operador no se inform� en la integraci�n, verifique la Tag OperatorId o OperatorInternalId."
	#define STR0019 "no registrado en el Protheus, verifique el archivo de clientes."
	#define STR0020 "Campo obligatorio no se inform�: Fecha de emisi�n, verifique la tag: IssueDateDocument."
	#define STR0021 "Campo obligatorio no se inform�: Id Interno, verifique la tag: InternalId."
	#define STR0022 "Comprobante:"
	#define STR0023 "integrado al Protheus."
	#define STR0024 "Actualice EAI"
	#define STR0025 "Error en la grabaci�n de la venta:"
	#define STR0026 "no se encontr� en el Protheus, verifique el archivo o integraci�n de Estaci�n."
	#define STR0027 "Campo obligatorio no se inform�: Valor total de la venta, verifique la tag: TotalPrice."
	#define STR0028 "Campo obligatorio no se inform�: Valor neto de la venta, verifique la tag: NetPrice."
	#define STR0029 "Campo obligatorio no se inform�: Valor bruto de la venta, verifique la tag: GrossPrice."
	#define STR0030 "Lista de productos vac�a, verifique la lista SaleItem."
	#define STR0031 "Inconsistencia en el �tem"
	#define STR0032 "producto no informado en la integraci�n, verifique la Tag ItemCode."
	#define STR0033 "producto:"
	#define STR0034 "no registrado en el Protheus, verifique la tag: ItemCode"
	#define STR0035 "campo obligatorio no se inform�: �tem, verifique la tag: ItemOrder."
	#define STR0036 "campo obligatorio no se inform�: Cantidad, verifique la tag: Quantity."
	#define STR0037 "campo obligatorio no se inform�: Precio unitario, verifique la tag: UnitPrice."
	#define STR0038 "campo obligatorio no se inform�: Precio del �tem, verifique la tag: ItemPrice."
	#define STR0039 "campo obligatorio no se inform�: CFOP, verifique la tag: OperationCode"
	#define STR0040 "TES no se inform�, verifique el archivo de Producto en el Protheus, campo B1_TS o los par�metros MV_TESSERV y MV_TESVEND."
	#define STR0041 "Valor total divergente."
	#define STR0042 "verifique las tag TotalPrice y la suma de las tags: ItemPrice."
	#define STR0043 "Lista de forma de pagos vac�a, verifique la lista SaleCondition."
	#define STR0044 "Inconsistencia en la forma  de pago"
	#define STR0045 "Forma de pago no se inform� en la integraci�n."
	#define STR0046 "Verifique las tags: PaymentMethodId o PaymentMethodInternalId."
	#define STR0047 "Forma de pago:"
	#define STR0048 "no se encontr� en el Protheus."
	#define STR0049 "Verifique el archivo de Forma de pago."
	#define STR0050 "Administradora financiera no registrada en el Protheus."
	#define STR0051 "Esta informaci�n es obligatoria para pagos en tarjeta, verifique la tag: FinancialManagerId."
	#define STR0052 "Valor del Pago no se inform� en la integraci�n, verifique la tag: PaymentValue."
	#define STR0053 "Valor de la venta divergente del total de pago"
	#define STR0054 "verifique las tags: NetPrice e PaymentValue."
	#define STR0055 "Versi�n no soportada."
	#define STR0056 "Las versiones soportadas son:"
	#define STR0057 "Venta:"
	#define STR0058 "�No se encontr� en de/a!"
	#define STR0059 "Se detect� que el campo referente al estado de cobranza(M0_ESTCOB) no est� configurado."
	#define STR0060 "Efect�e la inclusi�n en el archivo de sucursales en el Protheus."
	#define STR0061 "Inconsistencia en la fecha de pago"
	#define STR0062 "Fecha de pago no informada, verifique la tag: DateOfPayment"
	#define STR0063 "CFOP inv�lida:"
	#define STR0064 "verifique el registro de CFOP"
	#define STR0065 "Campo obligatorio no informado para NFce: Informaciones adicionales, verifique la tag: ElectronicInvoiceComplement"
	#define STR0066 "Cuenta Hotel no se inform�"
	#define STR0067 "Esta informaci�n es obligatoria para pagos RA, verifique la tag: CurrentAccount"
	#define STR0068 "Campo obligatorio no se inform�: MD-5, verifique la tag: Md5"
	#define STR0069 "Impuesto ISS obligatorio para la venta de servicio, verifique el tag: IssValue"
	#define STR0070 "Impuesto ICMS informado para la venta de servicio, verifique el tag: IcmsValue"
	#define STR0071 "Impuesto ICMS obligatorio para la venta de mercader�a, verifique el tag: IcmsValue"
	#define STR0072 "Impuesto ISS informado para la venta de mercader�a, verifique el Tag: IssValue"
	#define STR0073 "impuesto ISS obligatorio para el servicio, verifique el Tag: ItemIss"
	#define STR0074 "Impuesto ICMS obligatorio para la mercader�a, verifique el Tag: ItemIcms"
	#define STR0075 "bloqueado, verifique el archivo de cliente en el Protheus."
#else
	#ifdef ENGLISH
		#define STR0001 "Error in parser!"
		#define STR0002 "Message version not entered!"
		#define STR0003 "Version of message entered not implemented!"
		#define STR0004 "Brand not integrated to Protheus. Check integration brand."
		#define STR0005 "Station not entered in the integration. Check tag StationId or StationInternalId."
		#define STR0006 "Voucher or Series not entered. Check tags: DocumentId and SerieId."
		#define STR0007 "Customer:"
		#define STR0008 "not integrated to Protheus, check customer integration"
		#define STR0009 "Operator:"
		#define STR0010 "not integrated to Protheus. Check operator integration."
		#define STR0011 "Station: "
		#define STR0012 "not integrated to Protheus. Check Station integration."
		#define STR0013 "Product:"
		#define STR0014 "not integrated to Protheus, check Product integration"
		#define STR0015 "Document:"
		#define STR0016 "Series:"
		#define STR0017 "Store:"
		#define STR0018 "Operator not entered in integration. Check tag OperatorId or OperatorInternalId."
		#define STR0019 "not registered in Protheus. Check the customers register."
		#define STR0020 "Required field not entered: Issue date, check tag: IssueDateDocument."
		#define STR0021 "Required field not filled out: Internal ID. Check tag: InternalId."
		#define STR0022 "Receipt:"
		#define STR0023 "already integrated to Protheus!"
		#define STR0024 "Update EAI"
		#define STR0025 "Error recording sales:"
		#define STR0026 "not found in Protheus, check the Station register or integration."
		#define STR0027 "Required field not filled out: Total Sale Value. Check tag: TotalPrice."
		#define STR0028 "Required field not filled out: Net Sale Value. Check tag: NetPrice."
		#define STR0029 "Required field not filled out: Gross Sale Value. Check tag: GrossPrice."
		#define STR0030 "Products list empty. Check list: SaleItem."
		#define STR0031 "Inconsistency in item"
		#define STR0032 "Product not filled out in integration. Check tag: ItemCode."
		#define STR0033 "product:"
		#define STR0034 "not registered in Protheus. Check tag: ItemCode."
		#define STR0035 "Required field not filled out: Item. Check tag: ItemOrder."
		#define STR0036 "Required field not filled out: Quantity. Check tag: Quantity."
		#define STR0037 "required field not filled out: Unit Price. Check tag: UnitPrice."
		#define STR0038 "required field not filled out: Item Price. Check tag: ItemPrice."
		#define STR0039 "Required field not filled out: CFOP. Check tag: OperationCode."
		#define STR0040 "TIO not entered. Check Product Register in Protheus, field B1_TS or parameters MV_TESSERV and MV_TESVEND."
		#define STR0041 "Total Value divergent."
		#define STR0042 "Check tag TotalPrice and the sum of tags: ItemPrice."
		#define STR0043 "Payment Methods List empty. Chekc list: SaleCondition."
		#define STR0044 "Payment Method not consistent."
		#define STR0045 "Payment Method not entered in integration."
		#define STR0046 "Check tags: PaymentMethodId or PaymentMethodInternalId."
		#define STR0047 "Payment Method:"
		#define STR0048 "not found in Protheus."
		#define STR0049 "Check the Payment Methods register."
		#define STR0050 "Financial Company not registered in Protheus."
		#define STR0051 "This information is required for card payments. Check tag: FinancialManagerId."
		#define STR0052 "Payment Value not entered in integration. Check tag: PaymentValue."
		#define STR0053 "Sale value divergent from payment total."
		#define STR0054 "Check tags: NetPrice and PaymentValue."
		#define STR0055 "Version not supported."
		#define STR0056 "The supported versions are:"
		#define STR0057 "Sales:"
		#define STR0058 "not found in from/to!"
		#define STR0059 "Field related to state of billing (M0_ESTCOB) not configured."
		#define STR0060 "Add data to branches register of Protheus."
		#define STR0061 "Payment Date not consistent."
		#define STR0062 "Payment Date not entered. Check tag: DateOfPayment."
		#define STR0063 "CFOP not valid:"
		#define STR0064 "Check CFOP register."
		#define STR0065 "Required field not filled out for E-Invc: Additional Information. Check tag: ElectronicInvoiceComplement."
		#define STR0066 "Hotel Account not entered."
		#define STR0067 "This information is required for RA payments. Check tag: CurrentAccount."
		#define STR0068 "Required field not filled out: MD-5. Check tag: Md5."
		#define STR0069 "ISS Tax required for Service Sales. Check tag: IssValue."
		#define STR0070 "ICMS Tax entered for Service Sales. Check tag: IcmsValue."
		#define STR0071 "ICMS Tax required for Goods Sales. Check tag: IcmsValue."
		#define STR0072 "ISS Tax entered for Goods Sales. Check tag: IssValue."
		#define STR0073 "ISS tax required for service. Check tag: ItemIss."
		#define STR0074 "ICMS tax required for goods. Check tag: ItemIcms."
		#define STR0075 "blocked, check the Customers Register in Protheus."
	#else
		#define STR0001 "Erro no parser!"
		#define STR0002 "Versao da mensagem nao informada!"
		#define STR0003 "A versao da mensagem informada nao foi implementada!"
		#define STR0004 "Marca nao integrada ao Protheus, verificar a marca da integracao"
		#define STR0005 "Estacao nao informada na integracao, verifique a Tag StationId ou StationInternalId."
		#define STR0006 "Cupom ou Serie nao informados, verificar as tags: DocumentId e SerieId"
		#define STR0007 "Cliente:"
		#define STR0008 "nao integrado ao Potheus, verificar integracao de clientes"
		#define STR0009 "Operador:"
		#define STR0010 "nao integrado ao Protheus, verificar integracao de operador"
		#define STR0011 "Estacao: "
		#define STR0012 "nao integrada no Protheus, verificar integracao de Estacao"
		#define STR0013 "Produto:"
		#define STR0014 "nao integrado ao Protheus, verificar integracao de Produto"
		#define STR0015 "Documento:"
		#define STR0016 "Serie:"
		#define STR0017 "Loja:"
		#define STR0018 "Operador nao informado na integracao, verifique a Tag OperatorId ou OperatorInternalId."
		#define STR0019 "nao cadastrado no Protheus, verifique o cadastro de clientes."
		#define STR0020 "Campo obrigatorio nao informado: Data de Emissao, verifique a tag: IssueDateDocument."
		#define STR0021 "Campo obrigatorio nao informado: Id Interno, verifique a tag: InternalId."
		#define STR0022 "Cupom:"
		#define STR0023 "ja integrado no Protheus!"
		#define STR0024 "Atualize EAI"
		#define STR0025 "Erro na gravacao da venda:"
		#define STR0026 "nao encontrada no Protheus, verificar o cadastro ou integracao de Estacao."
		#define STR0027 "Campo obrigatorio nao informado: Valor Total da Venda, verifique a tag: TotalPrice."
		#define STR0028 "Campo obrigatorio nao informado: Valor Liquido da Venda, verifique a tag: NetPrice."
		#define STR0029 "Campo obrigatorio nao informado: Valor Bruto da Venda, verifique a tag: GrossPrice."
		#define STR0030 "Lista de produtos vazia, verifique a lista SaleItem."
		#define STR0031 "Inconsistencia no item"
		#define STR0032 "produto nao informado na integracao, verifique a Tag ItemCode."
		#define STR0033 "produto:"
		#define STR0034 "nao cadastrado no Protheus, verifique a tag: ItemCode"
		#define STR0035 "campo obrigatorio nao informado: Item, verifique a tag: ItemOrder."
		#define STR0036 "campo obrigatorio nao informado: Quantidade, verifique a tag: Quantity."
		#define STR0037 "campo obrigatorio nao informado: Preco Unitario, verifique a tag: UnitPrice."
		#define STR0038 "campo obrigatorio nao informado: Preco do Item, verifique a tag: ItemPrice."
		#define STR0039 "campo obrigatorio nao informado: CFOP, verifique a tag: OperationCode"
		#define STR0040 "TES nao informada, verifique o Cadastro de Produto no Protheus, campo B1_TS ou os parametros MV_TESSERV e MV_TESVEND."
		#define STR0041 "Valor Total divergente."
		#define STR0042 "verifique as tag TotalPrice e a soma das tags: ItemPrice."
		#define STR0043 "Lista de Forma de Pagamentos vazia, verifique a lista SaleCondition."
		#define STR0044 "Inconsistencia na forma de pagamento"
		#define STR0045 "Forma de Pagamento nao informado na integracao."
		#define STR0046 "Verifique as tags: PaymentMethodId ou PaymentMethodInternalId."
		#define STR0047 "Forma de Pagemento:"
		#define STR0048 "nao encontrado no Protheus."
		#define STR0049 "Verifique o cadastro de Forma de Pagamento."
		#define STR0050 "Administradora Financeira nao cadastrada no Protheus."
		#define STR0051 "Esta informacao e obrigatoria para pagamentos em cartao, verifique a tag: FinancialManagerId."
		#define STR0052 "Valor do Pagamento nao informado na integracao, verifique a tag: PaymentValue."
		#define STR0053 "Valor da venda divergente do total do pagamento"
		#define STR0054 "verifique as tags: NetPrice e PaymentValue."
		#define STR0055 "Vers�o nao suportada."
		#define STR0056 "As versoes suportadas sao:"
		#define STR0057 "Venda:"
		#define STR0058 "nao encontrado no de/para!"
		#define STR0059 "Foi detectado que o campo referente ao estado de cobranca(M0_ESTCOB) nao esta configurado."
		#define STR0060 "Efetue a inclusao no cadastro de filiais no Protheus."
		#define STR0061 "Inconsistencia na Data de Pagamento"
		#define STR0062 "Data de Pagamento nao informada, verifique a tag: DateOfPayment"
		#define STR0063 "CFOP invalida:"
		#define STR0064 "verifique o cadastro de CFOP"
		#define STR0065 "Campo obrigat�rio nao informado para Nfce: Informacoes Adicionais, verifique a tag: ElectronicInvoiceComplement"
		#define STR0066 "Conta Hotel nao informada"
		#define STR0067 "Esta informacao e obrigatoria para pagamentos RA, verifique a tag: CurrentAccount"
		#define STR0068 "Campo obrigatorio nao informado: MD-5, verifique a tag: Md5"
		#define STR0069 "Imposto ISS obrigatorio para Venda de Servico, verifique a tag: IssValue"
		#define STR0070 "Imposto ICMS informado para Venda de Servico, verifique a tag: IcmsValue"
		#define STR0071 "Imposto ICMS obrigatorio para Venda de Mercadoria, verifique a tag: IcmsValue"
		#define STR0072 "Imposto ISS informado para Venda de Mercadoria, verifique a tag: IssValue"
		#define STR0073 "imposto ISS obrigatorio para servico, verifique a tag: ItemIss"
		#define STR0074 "imposto ICMS obrigatorio para mercadoria, verifique a tag: ItemIcms"
		#define STR0075 "bloqueado, verifique o Cadastro de Clientes no Protheus."
	#endif
#endif
