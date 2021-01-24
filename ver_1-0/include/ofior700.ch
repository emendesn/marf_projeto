#ifdef SPANISH
	#define STR0001 "Copia de solicitud de piezas"
	#define STR0002 "Taller"
	#define STR0003 "Mostrador"
	#define STR0004 "Tipo de solicitud"
	#define STR0005 "Tipo de movimiento"
	#define STR0006 "Seleccionando registros..."
	#define STR0007 "Dev."
	#define STR0008 "Solic."
	#define STR0009 "Solicitudes / Devoluciones de piezas"
	#define STR0010 "N�. OS:"
	#define STR0011 "<<< I M P R I M I R >>>"
	#define STR0012 "<<< VISUALIZA PARTES >>>"
	#define STR0013 "<<<     S A L I R     >>>"
	#define STR0014 "Deposito"
	#define STR0015 "Marcar todos"
	#define STR0016 "Numero"
	#define STR0017 "Fecha"
	#define STR0018 "Hora"
	#define STR0019 "Estatus"
	#define STR0020 "Atencion"
	#define STR0021 "No hay Solicitudes o Devoluciones para esta O.S."
	#define STR0022 "Piezas de las solicitudes"
	#define STR0023 "N�. Factura:"
	#define STR0024 "Sec."
	#define STR0025 "Grupo"
	#define STR0026 "Codigo del item"
	#define STR0027 "Descripcion"
	#define STR0028 "Cant."
	#define STR0029 "Valor"
	#define STR0030 "Valor total"
	#define STR0031 "T.T."
	#define STR0032 "Mecanico"
	#define STR0033 "No hay Piezas solicitadas en las solicitudes seleccionadas."
	#define STR0034 "Solicitud de piezas"
	#define STR0035 "Orden de busqueda"
	#define STR0036 "Nuestro numero"
	#define STR0037 "Buscar"
	#define STR0038 "Seleccionar"
	#define STR0039 "Leyenda"
	#define STR0040 "�Por favor, seleccione una o mas requisiciones!"
#else
	#ifdef ENGLISH
		#define STR0001 "Copy of Requisition of Parts"
		#define STR0002 "Repair Shop"
		#define STR0003 "Counter"
		#define STR0004 "Type of Requisition"
		#define STR0005 "Transaction type"
		#define STR0006 "Selecting records..."
		#define STR0007 "Retrn"
		#define STR0008 "Req"
		#define STR0009 "Requisitions / Returns of Parts"
		#define STR0010 "No. Service Order:"
		#define STR0011 "<<< P R I N T >>>"
		#define STR0012 "<<< VIEW PARTS >>>"
		#define STR0013 "<<<     E X I T     >>>"
		#define STR0014 "Warehouse"
		#define STR0015 "Check all"
		#define STR0016 "Number"
		#define STR0017 "Date"
		#define STR0018 "Time"
		#define STR0019 "Status"
		#define STR0020 "Attention"
		#define STR0021 "There are no Requisitions or Returns for this S.O."
		#define STR0022 "Requisition Parts"
		#define STR0023 "No. Mark:"
		#define STR0024 "Seq."
		#define STR0025 "Group"
		#define STR0026 "Item Code"
		#define STR0027 "Description"
		#define STR0028 "Qty."
		#define STR0029 "Value"
		#define STR0030 "Total Value"
		#define STR0031 "T.T."
		#define STR0032 "Mechanic"
		#define STR0033 "There are no Parts requisitioned in the selected requisitions."
		#define STR0034 "Requisition of Parts"
		#define STR0035 "Search Order"
		#define STR0036 "Our Number"
		#define STR0037 "Search"
		#define STR0038 "Select"
		#define STR0039 "Caption"
		#define STR0040 "Select one or more requests!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "C�pia de requisi��o de pe�as", "C�pia de Requisi��o de Pe�as" )
		#define STR0002 "Oficina"
		#define STR0003 "Balc�o"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Tipo de requisi��o", "Tipo de Requisi��o" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Tipo de movimento", "Tipo de Movimento" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando registros..." )
		#define STR0007 "Dev"
		#define STR0008 "Req"
		#define STR0009 "Requisi��es / Devolu��es de Pe�as"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "No. OS:", "Nro. OS:" )
		#define STR0011 "<<< I M P R I M I R >>>"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "<<< VISUALIZA PE�AS >>>", "<<< VISUALIZA PECAS >>>" )
		#define STR0013 "<<<     S A I R     >>>"
		#define STR0014 "Almoxarifado"
		#define STR0015 "Marcar todos"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "N�mero", "Numero" )
		#define STR0017 "Data"
		#define STR0018 "Hora"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0020 "Aten��o"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "N�o ha requisi��es ou devolu��es para esta O.S.", "N�o ha Requisi��es ou Devolu��es para esta O.S." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Pe�as das requisi��es", "Pe�as das Requisi��es" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "No.Fact.:", "Nro. Nota:" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Seq.", "Seq" )
		#define STR0025 "Grupo"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "C�digo do item", "C�digo do Item" )
		#define STR0027 "Descri��o"
		#define STR0028 "Qtd."
		#define STR0029 "Valor"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Valor total", "Valor Total" )
		#define STR0031 "T.T."
		#define STR0032 "Mec�nico"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "N�o ha pe�as requsitadas nas requisi��es seleccionadas.", "N�o ha Pe�as requsitadas nas requisi��es selecionadas." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Requisi��o de pe�as", "Requisi��o de Pe�as" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Ordem de busca", "Ordem de Busca" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Nosso n�mero", "Nosso Numero" )
		#define STR0037 "Pesquisar"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecionar" )
		#define STR0039 "Legenda"
		#define STR0040 "Favor selecionar uma ou mais requisi��es!"
	#endif
#endif
