#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Opciones CR"
	#define STR0003 "Transf / Bordero"
	#define STR0004 "Bajas"
	#define STR0005 "Cheques"
	#define STR0006 "Facturas"
	#define STR0007 "Comp&ensacion"
	#define STR0008 "Liquidacion"
	#define STR0009 "CNA&B"
	#define STR0010 "Leyenda"
	#define STR0011 "Cuentas por Cobrar"
	#define STR0012 "Visualizar"
	#define STR0013 "Incluir"
	#define STR0014 "Modificar"
	#define STR0015 "Borrar"
	#define STR0016 "Sustituir"
	#define STR0017 "Transferir"
	#define STR0018 "Bordero"
	#define STR0019 "Anular"
	#define STR0020 "Dar de baja"
	#define STR0021 "Lote"
	#define STR0022 "Anular Baja"
	#define STR0023 "Seleccionar"
	#define STR0024 "Compensar"
	#define STR0025 "Liquidar"
	#define STR0026 "Reliquidar"
	#define STR0027 "Genera archivo envio"
	#define STR0028 "Lee archivo retorno"
	#define STR0029 "Ctas por Cobrar"
	#define STR0030 "Revertir"
	#define STR0031 "Tracker contable"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "CR Options"
		#define STR0003 "Transf/Bordero"
		#define STR0004 "Postings"
		#define STR0005 "Checks"
		#define STR0006 "Invoices"
		#define STR0007 "Settlement"
		#define STR0008 "Liquidation"
		#define STR0009 "CNA&B"
		#define STR0010 "Le&gend"
		#define STR0011 "Accounts Receivable"
		#define STR0012 "View"
		#define STR0013 "Add"
		#define STR0014 "Edit"
		#define STR0015 "Delete"
		#define STR0016 "Replace"
		#define STR0017 "Transfer"
		#define STR0018 "Bordero"
		#define STR0019 "Cancel"
		#define STR0020 "Post"
		#define STR0021 "Lot"
		#define STR0022 "Cancel Posting"
		#define STR0023 "Select"
		#define STR0024 "Offset"
		#define STR0025 "Liquidate"
		#define STR0026 "Liquidate"
		#define STR0027 "Generate send file"
		#define STR0028 "Read return file"
		#define STR0029 "Accts. Receivable"
		#define STR0030 "Reverse "
		#define STR0031 "Accounting Tracker"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Op��es Cr", "Op��es CR" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Transf/bor", "Transf/Border�" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Levantamentos", "Bai&xas" )
		#define STR0005 "Cheques"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Facturas", "Faturas" )
		#define STR0007 "Comp&ensa��o"
		#define STR0008 "Liquida��o"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Cnab", "CNA&B" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Legenda", "Le&genda" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Contas A Receber", "Contas a Receber" )
		#define STR0012 "Visualizar"
		#define STR0013 "Incluir"
		#define STR0014 "Alterar"
		#define STR0015 "Excluir"
		#define STR0016 "Substituir"
		#define STR0017 "Transferir"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Borderaux ", "Bordero" )
		#define STR0019 "Cancelar"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Liquidar", "Baixar" )
		#define STR0021 "Lote"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Canc Liquida��o", "Canc Baixa" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecionar" )
		#define STR0024 "Compensar"
		#define STR0025 "Liquidar"
		#define STR0026 "Reliquidar"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Criar fich. de envio", "Gera arq envio" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Ler ficheiro de retorno", "Le arq retorno" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Contas A Receber", "Ctas a Receber" )
		#define STR0030 "Estornar"
		#define STR0031 "Tracker Cont�bil"
	#endif
#endif
