#ifdef SPANISH
	#define STR0001 'No existe la Tag InputOrOutput'
	#define STR0002 'No se encontro el Producto'
	#define STR0003 'No existe la Tag ItemCode'
	#define STR0004 'No existe la Tag UnitOfMeasure'
	#define STR0005 'No se encontro el Almacen'
	#define STR0006 'No existe la Tag "WarehouseId"'
	#define STR0007 'No exite la Tag "Quantity"'
	#define STR0008 'No existe la Tag "Date"'
	#define STR0009 'No existe la Tag "LotNumber"'
	#define STR0010 'No existe la Tag "SubLotNumber"'
	#define STR0011 'No existe la Tag "LotExpirationDate"'
	#define STR0012 'No se encontro el "Grupo de producto"'
	#define STR0013 'No existe la Tag "GroupCode"'
	#define STR0014 'No existe la Tag "Address"'
	#define STR0015 'No existe la Tag "NumberSeries"'
	#define STR0016 "Actualice EAI"
	#define STR0017 'Xml mal formateado '
	#define STR0018 "El Tipo de movimiento no fue registrado en los parametros "
	#define STR0019 "El procesamiento por la otra aplicacion no tuvo exito"
	#define STR0020 "Centro de custo inv�lido/n�o encontrado."
#else
	#ifdef ENGLISH
		#define STR0001 'Tag InputOrOutput does not exist'
		#define STR0002 'Product not found'
		#define STR0003 'Tag ItemCode does not exist'
		#define STR0004 'Tag UnitOfMeasure does not exist'
		#define STR0005 'Warehouse not found'
		#define STR0006 'Tag WarehouseId does not exist'
		#define STR0007 'Tag Quantity does not exist'
		#define STR0008 'Tag Date does not exist'
		#define STR0009 'Tag LotNumber does not exist'
		#define STR0010 'Tag SubLotNumber does not exist'
		#define STR0011 'Tag LotExpirationDate does not exist'
		#define STR0012 'Product Group not found'
		#define STR0013 'Tag GroupCode does not exist'
		#define STR0014 'Tag Address does not exist'
		#define STR0015 'Tag NumberSeries does not exist'
		#define STR0016 "Update EAI"
		#define STR0017 'Xml badly formatted '
		#define STR0018 "The transaction type has not been registered in the parameters "
		#define STR0019 "Processing by the other application was unsuccessful."
		#define STR0020 "Cost center invalid/not found."
	#else
		#define STR0001 'N�o existe a Tag InputOrOutput'
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'N�o encontrado o artigo', 'N�o encontrado o Produto' )
		#define STR0003 'N�o existe a Tag ItemCode'
		#define STR0004 'N�o existe a Tag UnitOfMeasure'
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Armaz�m n�o encontrado', 'N�o encontrado o Armazem' )
		#define STR0006 'N�o existe a Tag "WarehouseId"'
		#define STR0007 'N�o exite a Tag "Quantity"'
		#define STR0008 'N�o existe a Tag "Date"'
		#define STR0009 'N�o existe a Tag "LotNumber"'
		#define STR0010 'N�o existe a Tag "SubLotNumber"'
		#define STR0011 'N�o existe a Tag "LotExpirationDate"'
		#define STR0012 If( cPaisLoc $ "ANG|PTG", 'N�o encontrado o "Grupo de artigo"', 'N�o encontrado o "Grupo de Produto"' )
		#define STR0013 'N�o existe a Tag "GroupCode"'
		#define STR0014 'N�o existe a Tag "Address"'
		#define STR0015 'N�o existe a Tag "NumberSeries"'
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Actualize EAI", "Atualize EAI" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", 'XML mal formatado ', 'Xml mal formatado ' )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "O Tipo de movimenta��o n�o foi registado nos par�metros ", "O Tipo de movimenta��o n�o foi cadastrado nos par�metros " )
		#define STR0019 "Processamento pela outra aplica��o n�o teve sucesso"
		#define STR0020 "Centro de custo inv�lido/n�o encontrado."
	#endif
#endif
