#ifdef SPANISH
	#define STR0001 "Registro de Pendencias"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Modificar"
	#define STR0005 "Indemnizar"
	#define STR0006 "Finalizar"
	#define STR0007 "Estornar"
	#define STR0008 "Leyenda"
	#define STR0009 "Facturas con Averia"
	#define STR0010 "NF Ave."
	#define STR0011 "Estatus"
	#define STR0012 "Pendiente"
	#define STR0013 "Indemnizacion Solicitada"
	#define STR0014 "Indemnizada"
	#define STR0015 "Finalizada"
	#define STR0016 "Identificacion del Producto"
	#define STR0017 "Id. Producto"
	#define STR0018 "Vis.Conciliacion"
	#define STR0019 "Hay conciliaciones pendientes y que se finalizaran automaticamente. ¿Lo confirma? "
#else
	#ifdef ENGLISH
		#define STR0001 "Pending Issues File"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Alter"
		#define STR0005 "Indemnify"
		#define STR0006 "Close"
		#define STR0007 "Reverse"
		#define STR0008 "Legend"
		#define STR0009 "Invoices with Damages"
		#define STR0010 "Inv.Dam"
		#define STR0011 "Status"
		#define STR0012 "Open"
		#define STR0013 "Compensation requested"
		#define STR0014 "Indemnifd."
		#define STR0015 "Closed"
		#define STR0016 "Product Identification"
		#define STR0017 "Id. Product"
		#define STR0018 "Conciliation Values"
		#define STR0019 "There are pending conciliations that will be automatically terminated. Confirm? "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de pendências", "Registro de Pendências" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Indemnizar", "Indenizar" )
		#define STR0006 "Encerrar"
		#define STR0007 "Estornar"
		#define STR0008 "Legenda"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Facturas Com Avaria", "Notas Fiscais com Avaria" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Fact. Ava.", "NF Ava." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0012 "Em Aberto"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Indemnização solicitada", "Indenização Solicitada" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Indemnizada", "Indenizada" )
		#define STR0015 "Encerrada"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Identificação do artigo", "Identificação do Produto" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Id. Artigo", "Id. Produto" )
		#define STR0018 "Vis.Conciliação"
		#define STR0019 "Existem conciliações pendentes e serão encerradas automaticamente. Confirma ? "
	#endif
#endif
