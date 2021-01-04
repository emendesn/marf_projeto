#ifdef SPANISH
	#define STR0001 "Cantidad invalida por ubicar para el Producto/Almac�n [VAR01]/[VAR02]"
	#define STR0002 "Producto [VAR01] no registrado. (SB1)"
	#define STR0003 "Producto [VAR01] no registrado en los Datos adicionales del producto. (SB5)"
	#define STR0004 "Zona de almacenamiento [VAR01] no registrada. (DC4)"
	#define STR0005 "El registro de movimiento del Producto/Almacen/Doc/Serie [VAR01]/[VAR02]/[VAR03]/[VAR04] no se encontro en el Archivo de saldos por ubicar. (SDA)"
	#define STR0006 "El Producto/Almacen/Doc/Serie [VAR01]/[VAR02]/[VAR03]/[VAR04] no tiene Saldo por ubicar. (SDA)"
	#define STR0007 "El registro de movimiento del Producto/Almacen/Doc/Serie [VAR01]/[VAR02]/[VAR03]/[VAR04] no se encontro en el Archivo de origen ([VAR05])."
	#define STR0008 "No se informo la direccion origen"
	#define STR0009 "El Producto/Almacen [VAR01]/[VAR02] no tiene secuencia de abastecimiento registrada. (DC3)"
	#define STR0010 "Estructura fisica [VAR01] no registrada. (DC8)"
	#define STR0011 "Almacen [VAR01] - Busqueda de direccion en la estructura [VAR02] - [VAR03]"
	#define STR0012 "No fue posible ubicar toda la cantidad. Saldo restante ([VAR01])."
	#define STR0013 " - Producto: "
	#define STR0014 "El producto no utiliza estructura pulmon. (B5_NPULMAO)"
	#define STR0015 "Encontro direccion de picking. Multiples = No"
	#define STR0016 "Limite de direcciones picking ocupados ([VAR01])."
	#define STR0017 "Saldo de la direccion utiliza toda la capacidad."
	#define STR0018 "Tiene saldo de otros productos/lotes."
	#define STR0019 "Tiene producto que no comparte direcci�n."
	#define STR0020 "Direccion descartada por el PE DLENDEOK"
	#define STR0021 "Direccion libre para utilizacion. Distancia ([VAR01])"
	#define STR0022 "Direccion utilizada."
	#define STR0023 "No se encontro ninguna direccion disponible."
	#define STR0024 "Estructura con capacidad en cero."
	#define STR0025 "Direcci�n con capacidad en cero."
	#define STR0026 "Producto/Almac�n [VAR01]/[VAR02] no tiene estructura f�sica del tipo cross-docking registrada en la secuencia de abastecimiento registrada (DC3)."
#else
	#ifdef ENGLISH
		#define STR0001 "Quantity addressing for Product/Warehouse [VAR01]/[VAR02] not valid"
		#define STR0002 "Product [VAR01] not registered. (SB1)"
		#define STR0003 "Product not registered in Product Additional Data (SB5)."
		#define STR0004 "Storage zone [VAR01] not registered. (DC4)"
		#define STR0005 "Movement record of Product/Warehouse/Doc/Series [VAR01]/[VAR02]/[VAR03]/[VAR04] not found in Balance File to Address. (SDA)"
		#define STR0006 "Product/Warehouse/Doc/Series [VAR01]/[VAR02]/[VAR03]/[VAR04] has no balance to address. (SDA)"
		#define STR0007 "Movement record of Product/Warehouse/Doc/Series [VAR01]/[VAR02]/[VAR03]/[VAR04] not found in Origin File ([VAR05])."
		#define STR0008 "Source Address not entered"
		#define STR0009 "Product/Warehouse [VAR01]/[VAR02] has no registered supply sequence. (DC3)"
		#define STR0010 "Physical structure [VAR01] not registered. (DC8)"
		#define STR0011 "Warehouse [VAR01] - Address search in structure [VAR02] - [VAR03]"
		#define STR0012 "Could not address entire quantity. Remaining balance ([VAR01])."
		#define STR0013 " - Product: "
		#define STR0014 "Product does not use buffer structure. (B5_NPULMAO)"
		#define STR0015 "Picking address found. Multiples = No"
		#define STR0016 "Occupied picking addresses limit ([VAR01])."
		#define STR0017 "Address balance uses full capacity."
		#define STR0018 "Has balance of other products/lots."
		#define STR0019 "Has product that does not share address."
		#define STR0020 "Address dismissed by PE DLENDEOK"
		#define STR0021 "Address free for use. Distance ([VAR01])"
		#define STR0022 "Used Address."
		#define STR0023 "No available address found."
		#define STR0024 "Structure with capacity zeroed."
		#define STR0025 "Address with capacity zeroed."
		#define STR0026 "Product/Warehouse [VAR01]/[VAR02] has no cross-docking type physical structure registered in the registered supply sequence (DC3)."
	#else
		#define STR0001 "Quantidade inv�lida a enderecar para o Produto/Armaz�m [VAR01]/[VAR02]"
		#define STR0002 "Produto [VAR01] n�o cadastrado. (SB1)"
		#define STR0003 "Produto [VAR01] n�o cadastrado nos Dados Adicionais do Produto. (SB5)"
		#define STR0004 "Zona de Armazenagem [VAR01] n�o cadastrada. (DC4)"
		#define STR0005 "O registro de movimenta��o do Produto/Armaz�m/Doc/S�rie [VAR01]/[VAR02]/[VAR03]/[VAR04] n�o foi encontrado no Arquivo de Saldos a Enderecar. (SDA)"
		#define STR0006 "O Produto/Armaz�m/Doc/S�rie [VAR01]/[VAR02]/[VAR03]/[VAR04] n�o possui Saldo a Enderecar. (SDA)"
		#define STR0007 "O registro de movimenta��o do Produto/Armaz�m/Doc/S�rie [VAR01]/[VAR02]/[VAR03]/[VAR04] n�o foi encontrado no Arquivo de Origem ([VAR05])."
		#define STR0008 "O endere�o origem n�o foi informado"
		#define STR0009 "Produto/Armaz�m [VAR01]/[VAR02] n�o possui sequ�ncia de abastecimento cadastrada. (DC3)"
		#define STR0010 "Estrutura Fisica [VAR01] n�o cadastrada. (DC8)"
		#define STR0011 "Armaz�m [VAR01] - Busca de endere�o na estrutura [VAR02] - [VAR03]"
		#define STR0012 "N�o foi poss�vel endere�ar toda a quantidade. Saldo restante ([VAR01])."
		#define STR0013 " - Produto: "
		#define STR0014 "Produto n�o utiliza estrutura pulm�o. (B5_NPULMAO)"
		#define STR0015 "Encontrou endere�o de picking. M�ltiplos = N�o"
		#define STR0016 "Limite de endere�os picking ocupados ([VAR01])."
		#define STR0017 "Saldo do endere�o utiliza toda capacidade."
		#define STR0018 "Possui saldo de outros produtos/lotes."
		#define STR0019 "Possui produto que n�o compartilha endere�o."
		#define STR0020 "Endere�o descartado pelo PE DLENDEOK"
		#define STR0021 "Endere�o livre para utiliza��o. Dist�ncia ([VAR01])"
		#define STR0022 "Endere�o utilizado."
		#define STR0023 "N�o encontrou nenhum endere�o dispon�vel."
		#define STR0024 "Estrutura com capacidade zerada."
		#define STR0025 "Endere�o com capacidade zerada."
		#define STR0026 "Produto/Armaz�m [VAR01]/[VAR02] n�o possui estrutura f�sica do tipo cross-docking cadastrada na sequ�ncia de abastecimento cadastrada (DC3)."
	#endif
#endif