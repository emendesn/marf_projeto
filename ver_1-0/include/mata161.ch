#ifdef SPANISH
	#define STR0001 "Bajo analisis"
	#define STR0002 "Analizada"
	#define STR0003 "Pendiente - No Cotizada"
	#define STR0004 "Cotizacion del MarketPlace"
	#define STR0005 "Mapa de cotizacion"
	#define STR0006 "Buscar"
	#define STR0008 "Pedido de Compra"
	#define STR0009 "Contrato"
	#define STR0012 "An�lisis de cotizacion"
	#define STR0013 "Datos de la cotizacion"
	#define STR0014 "Datos de la propuesta"
	#define STR0016 "Productos"
	#define STR0017 "Item de la propuesta"
	#define STR0019 "Pagina"
	#define STR0020 "/"
	#define STR0021 "Historial del producto (F4)"
	#define STR0023 "Pagina anterior (F5)"
	#define STR0025 "Proxima pagina (F6)"
	#define STR0027 "Proveedor"
	#define STR0028 "Propuesta"
	#define STR0029 "Tp. Flete"
	#define STR0030 "Cond. Pago"
	#define STR0031 "Vl. Total"
	#define STR0032 "Historial del Proveedor (F7)"
	#define STR0039 "Historial del Proveedor (F8)"
	#define STR0041 "Cod. Producto"
	#define STR0042 "Descripcion"
	#define STR0043 "Cantidad"
	#define STR0044 "UM"
	#define STR0045 "Necesidad"
	#define STR0046 "Entrega"
	#define STR0047 "Valor Final"
	#define STR0048 "Valor Total"
	#define STR0052 "Archivo de Proveedores"
	#define STR0053 "Si"
	#define STR0054 "No"
	#define STR0055 "Si p/todos"
	#define STR0056 "No p/todos"
	#define STR0057 "Atencion"
	#define STR0058 "El item "
	#define STR0059 " tuvo como ganador un participante no registrado como proveedor ("
	#define STR0060 "). �Desea registrarlo ahora? En caso de que es negativo, este item de cotizacion no se finalizara."
	#define STR0061 "Atencion"
	#define STR0062 "El archivo del participante "
	#define STR0063 " se cancelo y la cotizacion del item "
	#define STR0064 " no se finalizara."
	#define STR0065 "Ok"
	#define STR0066 " Parametro no rellenado. Es necesario completar el parametro MV_TPPLA con un Tipo de planilla valido para generar los contratos."
	#define STR0067 "Planilla invalida"
	#define STR0068 "Es necesario completar el par�metro MV_TPPLA con un Tipo de planilla valido para generar los contratos."
	#define STR0069 "Tipo de Contrato"
	#define STR0070 "�Se generara un contrato en Conjunto (todos los proveedores) o Individual (uno por proveedor)?"
	#define STR0071 "Conjunto"
	#define STR0072 "Individual"
	#define STR0073 "Incluir"
	#define STR0074 "Valor final"
	#define STR0075 "CIF"
	#define STR0076 "FOB"
	#define STR0077 "Terceros"
	#define STR0078 "Sin flete"
	#define STR0079 "Conocimiento"
#else
	#ifdef ENGLISH
		#define STR0001 "In Analysis"
		#define STR0002 "Analyzed"
		#define STR0003 "Pending - Not Quoted"
		#define STR0004 "MarketPlace Quotation"
		#define STR0005 "Quotation Map"
		#define STR0006 "Search"
		#define STR0008 "Purchase Order"
		#define STR0009 "Contract"
		#define STR0012 "Quotation Analysis"
		#define STR0013 "Quotation Data"
		#define STR0014 "Proposal Data"
		#define STR0016 "Products"
		#define STR0017 "Proposal Item"
		#define STR0019 "Page"
		#define STR0020 "/"
		#define STR0021 "Product History (F4)"
		#define STR0023 "Previous Page (F5)"
		#define STR0025 "Next Page (F6)"
		#define STR0027 "Supplier"
		#define STR0028 "Proposal"
		#define STR0029 "Freight Tp."
		#define STR0030 "Payment Term"
		#define STR0031 "Total Vl."
		#define STR0032 "Supplier History (F7)"
		#define STR0039 "Supplier History (F8)"
		#define STR0041 "Product Code"
		#define STR0042 "Description"
		#define STR0043 "Quantity"
		#define STR0044 "UM"
		#define STR0045 "Need"
		#define STR0046 "Delivery"
		#define STR0047 "Final Value"
		#define STR0048 "Total Value"
		#define STR0052 "Supplier Register"
		#define STR0053 "Yes"
		#define STR0054 "No"
		#define STR0055 "Yes for All"
		#define STR0056 "No for All"
		#define STR0057 "Attention"
		#define STR0058 "The item "
		#define STR0059 " has as winner a participant not registered as a supplier ("
		#define STR0060 "). Do you want to register this participant now? If not, this quotation item is closed."
		#define STR0061 "Attention"
		#define STR0062 "The participant registration "
		#define STR0063 " was canceled and the item quotation "
		#define STR0064 " will not be closed."
		#define STR0065 "OK"
		#define STR0066 " Parameter not filled out. It is necessary fill out the parameter MV_TPPLA with one type of valid Spreadsheet for contract generation"
		#define STR0067 "Invalid Worksheet"
		#define STR0068 "It is necessary fill out the parameter MV_TPPLA with one type of valid Spreadsheet for contract generation"
		#define STR0069 "Type of Contract"
		#define STR0070 "Will a Collective (all the suppliers) or an Individual (one per supplier) contract be generated?"
		#define STR0071 "Collective"
		#define STR0072 "Individual"
		#define STR0073 "Add"
		#define STR0074 "Final Value"
		#define STR0075 "CIF"
		#define STR0076 "FOB"
		#define STR0077 "Third Parties"
		#define STR0078 "No Freight"
		#define STR0079 "Awareness"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Em Analise" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Analisada" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Em Aberto - N�o Cotada" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Cota��o do MarketPlace" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "An�lise da Cota��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Pedido de Compra" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Contrato (GCT)" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "An�lise de Cota��o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Dados da Cota��o" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Dados da Proposta" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Produtos" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Item da Proposta" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "P�gina" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "/" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Hist�rico do Produto (F4)" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "P�gina Anterior (F5)" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Pr�xima P�gina (F6)" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Fornecedor" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Proposta" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Tp. Frete" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Cond. Pagto" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Vl. Total" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Hist�rico do Fornecedor (F7)" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Hist�rico do Fornecedor (F8)" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Cod. Produto" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Descri��o" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "UM" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Necessidade" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Entrega" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Valor Final" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", , "Valor Total" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Fornecedores" )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", , "Sim" )
		#define STR0054 If( cPaisLoc $ "ANG|PTG", , "N�o" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", , "Sim p/ Todos" )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", , "N�o p/ Todos" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0058 If( cPaisLoc $ "ANG|PTG", , "O item " )
		#define STR0059 If( cPaisLoc $ "ANG|PTG", , " teve como ganhador um participante n�o cadastrado como fornecedor (" )
		#define STR0060 If( cPaisLoc $ "ANG|PTG", , "). Deseja cadastr�-lo agora? Em caso negativo, este item da cota��o n�o ser� finalizado." )
		#define STR0061 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0062 If( cPaisLoc $ "ANG|PTG", , "O cadastro do participante " )
		#define STR0063 If( cPaisLoc $ "ANG|PTG", , " foi cancelado e a cota��o do item " )
		#define STR0064 If( cPaisLoc $ "ANG|PTG", , " n�o ser� finalizada." )
		#define STR0065 If( cPaisLoc $ "ANG|PTG", , "Ok" )
		#define STR0066 If( cPaisLoc $ "ANG|PTG", , "� necess�rio configurar o par�metro MV_TPPLA com um tipo de planilha v�lido para a gera��o do(s) contrato(s)." )
		#define STR0067 If( cPaisLoc $ "ANG|PTG", , "Planilha inv�lida." )
		#define STR0068 If( cPaisLoc $ "ANG|PTG", , "� necess�rio configurar o par�metro MV_TPPLA com um tipo de planilha v�lido para a gera��o do(s) contrato(s)." )
		#define STR0069 If( cPaisLoc $ "ANG|PTG", , "Gera��o de Contrato" )
		#define STR0070 If( cPaisLoc $ "ANG|PTG", , "Deseja gerar um �nico contrato para todos os fornecedores separando-os em planilhas ou contratos separados para cada fornecedor?" )
		#define STR0071 If( cPaisLoc $ "ANG|PTG", , "�nico" )
		#define STR0072 If( cPaisLoc $ "ANG|PTG", , "Separados" )
		#define STR0073 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0074 "Valor Final"
		#define STR0075 "CIF"
		#define STR0076 "FOB"
		#define STR0077 "Terceiros"
		#define STR0078 "Sem Frete"
		#define STR0079 "Conhecimento"
	#endif
#endif
