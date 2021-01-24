#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Leyenda"
	#define STR0007 "Reserva pendiente"
	#define STR0008 "Reserva parcialmente dada de baja"
	#define STR0009 "Reserva totalmente dada de baja"
	#define STR0010 "Ajuste de Reservas (Mod.2)"
	#define STR0011 "Orden de Produccion"
	#define STR0012 "Items"
	#define STR0013 "1� Nivel"
	#define STR0014 "Direcciones"
	#define STR0015 "Explota el 1� nivel de la estructura de un producto - <F5>"
	#define STR0016 "Reserva por direcciones - <F6>"
	#define STR0017 "Seleccione un producto con estructura"
	#define STR0018 "Producto"
	#define STR0019 "Cantidad"
	#define STR0020 "Existe registro con esta informacion."
	#define STR0021 "Atencion"
	#define STR0022 "No puede borrarse una reserva que se dio de baja parcialmente."
	#define STR0023 "La OP esta finalizada, pero existen reservas pendientes. �Desea poner en cero reservas?"
	#define STR0024 "Si"
	#define STR0025 "No"
	#define STR0026 "Independientemente de existir valores superiores a cero en el campo de saldo reservado ('Sal. Reseva'), "
	#define STR0027 "el contenido que se grabara en la confirmacion sera cero."
	#define STR0028 "Ok"
	#define STR0029 "Aviso"
	#define STR0030 "Desactivando la opcion para poner en cero el saldo reservado"
	#define STR0031 "Desea activar la opcao para poner en cero el saldo reservado para todos los productos"
	#define STR0032 "Pone en cero Reserva Lote/Direccion - <F7>"
	#define STR0033 "Pone en cero Res."
	#define STR0034 "Los prototipos pueden manejarse solo a traves del modulo Desarrollador de Productos (DPR)."
	#define STR0035 "Esta orden de produccion tiene reserva que est� en una orden de separacion WMS. Borre la orden de separacion para realizar esta operacion."
	#define STR0036 "Esta reserva esta en una orden de separacion WMS. Borre la orden de separacion para realizar esta operacion."
	#define STR0037 "Operaci�n informada no existe. Producto: "
	#define STR0038 "Opera��es"
	#define STR0039 "Opera��o"
	#define STR0040 "Descri��o"
	#define STR0041 "Roteiro"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Caption"
		#define STR0007 "Open Allocation"
		#define STR0008 "Allocation partially posted"
		#define STR0009 "Allocation fully posted"
		#define STR0010 "Allocation Adjustment (Mod.2)"
		#define STR0011 "Production Order"
		#define STR0012 "Items"
		#define STR0013 "1st Level"
		#define STR0014 "Addresses"
		#define STR0015 "Exceed 1st structure level of a product - <F5>"
		#define STR0016 "Allocation by addresses - <F6>"
		#define STR0017 "Select a product with structure"
		#define STR0018 "Product"
		#define STR0019 "Quantity"
		#define STR0020 "A record already exists with this information."
		#define STR0021 "Attention"
		#define STR0022 "You cannot delete an allocation partially posted."
		#define STR0023 "P.O. is closed, but there are pending allocations. Do you want to zero allocations?"
		#define STR0024 "Yes"
		#define STR0025 "No"
		#define STR0026 "Even if there are values higher than zero in the allocated balance field ('Sal.Empenho'), "
		#define STR0027 "content to be saved when confirming will be zero."
		#define STR0028 "Ok"
		#define STR0029 "Warning"
		#define STR0030 "Disabling option to zero allocated balance"
		#define STR0031 "Do you wish yo enable option to zero allocated balance for all products"
		#define STR0032 "Zero Allocation Lot/Address - <F7>"
		#define STR0033 "Zero Alloc."
		#define STR0034 "Prototypes can only be manipulated through Products Developer (DPR)."
		#define STR0035 "This manufacturing order has allocation at a WMS kitting order. Delete the kitting order to execute this operation."
		#define STR0036 "This allocation is at a WMS kitting order. Delete the kitting order to execute this operation."
		#define STR0037 "Entered operation does not exist. Product: "
		#define STR0038 "Operations"
		#define STR0039 "Operation"
		#define STR0040 "Description"
		#define STR0041 "Script"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Legenda"
		#define STR0007 "Empenho em aberto"
		#define STR0008 "Empenho parcialmente baixado"
		#define STR0009 "Empenho totalmente baixado"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Ajuste de empenhos (mod.2)", "Ajuste de Empenhos (Mod.2)" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Ordem de producao", "Ordem de Produ��o" )
		#define STR0012 "Itens"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "1� nivel", "1� N�vel" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Moradas", "Endere�os" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Explode o 1�n�velda estrutura de um artigo - <f5>", "Explode o 1� n�vel da estrutura de um produto - <F5>" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Empenho por moradas - <f6>", "Empenho por endere�os - <F6>" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Seleccionar um artigo com estrutura", "Selecione um produto com estrutura" )
		#define STR0018 "Produto"
		#define STR0019 "Quantidade"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "J� existe registo com esta informa��o.", "J� existe registro com esta informa��o." )
		#define STR0021 "Aten��o"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "N�o pode ser exclu�do um empenho que j� foi parcialmente liquidado.", "N�o pode ser exclu�do um empenho que j� foi parcialmente baixado." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "A op j� esta encerrada, mas existem registos de despesa pendentes. deseja colocar os registos de despesa a zeros?", "A OP j� est� encerrada, mas existem empenhos pendentes. Deseja zerar empenhos?" )
		#define STR0024 "Sim"
		#define STR0025 "N�o"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Independente de existirem valores maiores que zero no campo de saldo empenhado ('sal.empenho'), ", "Independente de existirem valores maiores que zero no campo de saldo empenhado ('Sal.Empenho'), " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "O conte�do a ser gravado na confirma��o  ser� zero.", "o conte�do a ser gravado na confirma��o ser� zero." )
		#define STR0028 "Ok"
		#define STR0029 "Aviso"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "A desactivar a op��o para zerar o saldo empenhado", "Desativando a opcao para zerar o saldo empenhado" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Deseja activar a op��o para zerar o saldo empenhado para todos os artigos", "Deseja ativar a opcao para zerar o saldo empenhado para todos os produtos" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Zera Empenho Lote/Endere�o - <F7>", "Zera Empenho Lote/Endereco - <F7>" )
		#define STR0033 "Zera Emp."
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Os prot�tipos podem ser manipulados somente atrav�s do m�dulo Desenvolvedor de artigos (DPR).", "Prot�tipos podem ser manipulados somente atrav�s do m�dulo Desenvolvedor de Produtos (DPR)." )
		#define STR0035 "Esta ordem de produ��o possui empenho que est� em uma ordem de separa��o WMS. Exclua a ordem de separa��o para realizar esta opera��o."
		#define STR0036 "Este empenho est� em uma ordem de separa��o WMS. Exclua a ordem de separa��o para realizar esta opera��o."
		#define STR0037 "Opera��o informada n�o existe. Produto: "
		#define STR0038 "Opera��es"
		#define STR0039 "Opera��o"
		#define STR0040 "Descri��o"
		#define STR0041 "Roteiro"
	#endif
#endif
