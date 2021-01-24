#ifdef SPANISH
	#define STR0001 "Espere, comunicando aprobacion al portal..."
	#define STR0002 "Volver"
	#define STR0003 "El  acceso y la utilizacion de esta rutina solo se destina a los usuarios pertenecientes al grupo de compras : "
	#define STR0004 "Acceso restringido"
	#define STR0005 ". Usuario sin autorizacion para utilizar esta rutina.  "
	#define STR0006 ". con derecho de analisis de cotizacion. Usuario sin autorizacion para utilizar esta rutina.  "
	#define STR0007 "Item"
	#define STR0008 "Motivo de finalizacion"
	#define STR0009 "Observaciones"
	#define STR0010 "Valor ICMS"
	#define STR0011 "Valor del IPI"
	#define STR0012 "Historial de compras - Ultimas cotizaciones"
	#define STR0013 "Atencion"
	#define STR0014 "No existen cotizaciones incluidas para este producto."
	#define STR0015 "Cotizacion"
	#define STR0016 "Proveedor"
	#define STR0017 "Cantidad"
	#define STR0018 "Precio Unit"
	#define STR0019 "TOTAL "
	#define STR0020 "Cond. Pago."
	#define STR0021 "Prevision Entr."
	#define STR0022 "Fecha de emision"
	#define STR0023 "Alic. IPI"
	#define STR0024 "Alic. ICMS"
	#define STR0025 "Portal ACC"
#else
	#ifdef ENGLISH
		#define STR0001 "Wait, communicating  approval to portal..."
		#define STR0002 "Back"
		#define STR0003 "The access and use of this routine is destined only to users belonging to purchase group: "
		#define STR0004 "Restricted Access"
		#define STR0005 "User has no permission to use this routine.  "
		#define STR0006 ". with quotation analysis right. User has no permission to use this routine.  "
		#define STR0007 "Item"
		#define STR0008 "Closing Reason"
		#define STR0009 "Notes"
		#define STR0010 "ICMS Value"
		#define STR0011 "IPI Value"
		#define STR0012 "Purchase history - Last Quotation"
		#define STR0013 "Attention"
		#define STR0014 "No quotation for this product."
		#define STR0015 "Quotation"
		#define STR0016 "Supplier"
		#define STR0017 "Quantity"
		#define STR0018 "Unit Price"
		#define STR0019 "TOTAL "
		#define STR0020 "Paym. Term"
		#define STR0021 "Entry Estimation"
		#define STR0022 "Issue Date"
		#define STR0023 "Rate IPI"
		#define STR0024 "Rate ICMS"
		#define STR0025 "ACC Portal"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Aguarde, comunicando aprovação ao portal..." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Voltar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios pertencentes ao grupo de compras : " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Acesso Restrito" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , ". Usuario sem permissao para utilizar esta rotina.  " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , ". com direito de analise de cotacao. Usuario sem permissao para utilizar esta rotina.  " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Item" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Motivo do Encerramento" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Observações" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Valor ICMS" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Valor do IPI" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Historico de compras - Ultimas Cotacoes" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Nao existem cotacoes colocadas para este produto." )
		#define STR0015 "Cotacao"
		#define STR0016 "Fornecedor"
		#define STR0017 "Quantidade"
		#define STR0018 "Preco Unit."
		#define STR0019 "TOTAL "
		#define STR0020 "Cond. Pagto."
		#define STR0021 "Previsao Entr."
		#define STR0022 "Data de Emissao"
		#define STR0023 "Aliq. IPI"
		#define STR0024 "Aliq. ICMS"
		#define STR0025 "Portal ACC"
	#endif
#endif
