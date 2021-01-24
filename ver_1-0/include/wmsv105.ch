#ifdef SPANISH
	#define STR0001 "Operador no registrado"
	#define STR0002 "Reversión"
	#define STR0003 "Lista de embarque"
	#define STR0004 "Lista de embarque"
	#define STR0005 "Informe el código:"
	#define STR0006 "Lista de embarque: "
	#define STR0007 "Informe el volumen: "
	#define STR0008 "Atención"
	#define STR0009 "¿Desea liberar esta Lista de embarque para la facturación?"
	#define STR0010 "No fue posible liberar, porque existen ítems con componentes incompletos."
	#define STR0011 "¡Lista de embarque facturada!"
	#define STR0012 "¡Lista de embarque no encontrada!"
	#define STR0013 "Volumen: ¡[VAR01] ya está vinculado a la Lista de embarque!"
	#define STR0014 "Volumen: [VAR01] ya se vinculó a la Lista de embarque: ¡[VAR02]!"
	#define STR0015 "Volumen: [VAR01] no está vinculado a la Lista de embarque: ¡[VAR02]!"
	#define STR0016 "El servicio no está configurado con la liberación del pedido por lista de embarque (DC5_LIBPED)."
	#define STR0017 "Volumen"
	#define STR0018 "Carga"
	#define STR0019 "Pedido"
	#define STR0020 "Lib.Fact."
	#define STR0021 "Fact."
	#define STR0022 "¡Lista de embarque no encontrada!"
	#define STR0023 "Reversión volumen lista de embarque."
	#define STR0024 "Informe la lista de embarque:"
	#define STR0025 "Informe el volumen:"
	#define STR0026 "Confirma la reversión del volumen: ¿[VAR01] de esta lista de embarque?"
	#define STR0027 "¡No fue posible realizar la reversión, porque ya se facturó!"
	#define STR0028 "¡No fue posible realizar la reversión del volumen, porque tiene un ítem facturado!"
#else
	#ifdef ENGLISH
		#define STR0001 "Unregistered operator"
		#define STR0002 "Reversal"
		#define STR0003 "Packing List"
		#define STR0004 "Shipment Packing List"
		#define STR0005 "Enter code:"
		#define STR0006 "Packing List: "
		#define STR0007 "Enter Volume: "
		#define STR0008 "Warning"
		#define STR0009 "Do you wish to release this Packing List for Invoicing?"
		#define STR0010 "Could not release it because items with incomplete components exist!"
		#define STR0011 "Packing List already Invoiced!"
		#define STR0012 "Packing List not found!"
		#define STR0013 "Volume: [VAR01] already linked to Packing List!"
		#define STR0014 "Volume: [VAR01] is already linked to Packing List: [VAR02]!"
		#define STR0015 "Volume: [VAR01] is not linked to Packing List: [VAR02]!"
		#define STR0016 "The Service is not configured with release of order by packing list (DC_LIBPED)!"
		#define STR0017 "Volume"
		#define STR0018 "Cargo"
		#define STR0019 "Order"
		#define STR0020 "Inv.Rel."
		#define STR0021 "Inv."
		#define STR0022 "Packing List not found!"
		#define STR0023 "Pack.Lst Volume Reversal"
		#define STR0024 "Enter Packing List:"
		#define STR0025 "Enter volume"
		#define STR0026 "Confirm reversal of volume: [VAR01] of this shipment packing list?"
		#define STR0027 "Could not perform reversal, because it is already Invoiced!"
		#define STR0028 "Could not reverse the volume, because it has invoiced item!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Operador nao cadastrado" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Estorno" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Romaneio" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Romaneio de Embarque" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Informe o codigo:" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Romaneio: " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Informe o Volume: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Deseja liberar esse Romaneio para o Faturaramento?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Nao foi possivel liberar pois existem itens com componentes incompletos!" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Romaneio ja foi Faturado!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Romaneio nao encontrado!" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Volume: [VAR01] ja esta vinculado ao Romaneio!" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Volume: [VAR01] ja foi vinculado ao Romaneio: [VAR02]!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Volume: [VAR01] nao esta vinculado ao Romaneio: [VAR02]!" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "O Serviço não está configurado com liberação do pedido por romaneio (DC5_LIBPED)!" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Volume" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Carga" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Lib.Fat." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "NF" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Romaneio não encontrado!" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Estorno Volume Rom." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Informe o Romaneio:" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Informe o Volume:" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Confirma o estorno do volume: [VAR01] desse romaneio de embarque?" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Nao foi possivel realizar o estorno, pois ja foi Faturado!" )
		#define STR0028 "Nao foi possivel realizar o estorno do volume, pois possui item faturado!"
	#endif
#endif
