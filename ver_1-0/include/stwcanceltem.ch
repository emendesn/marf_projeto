#ifdef SPANISH
	#define STR0001 "Item no registrado en la venta"
	#define STR0002 "Item anulado con exito"
	#define STR0003 "No fue posible anular el item"
	#define STR0004 "Usuario sin autorizacion para anular items"
#else
	#ifdef ENGLISH
		#define STR0001 "Item not registered on sale"
		#define STR0002 "Item canceled successfully"
		#define STR0003 "It was not possible to cancel the item"
		#define STR0004 "User without write permission to cancel items"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Item n�o registado na venda", "Item n�o registrado na venda" )
		#define STR0002 "Item cancelado com sucesso"
		#define STR0003 "N�o foi poss�vel cancelar o item"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Utilizador sem permiss�o para cancelar itens", "Usuario sem permiss�o para cancelar itens" )
	#endif
#endif
