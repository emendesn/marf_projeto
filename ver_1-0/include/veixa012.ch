#ifdef SPANISH
	#define STR0001 "Salida de Vehiculos por Devolucion de Compra"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir Devolucion"
	#define STR0005 "Anula Devolucion"
	#define STR0006 "Leyenda"
	#define STR0007 "Busqueda Avanzada"
	#define STR0008 "Valida"
	#define STR0009 "Anulada"
	#define STR0010 "Devuelta"
	#define STR0011 "Atencion"
	#define STR0012 "Devolver"
	#define STR0013 "Usuario no posee archivo en el registro de vendedor. Favor providenciar."
	#define STR0014 "Datos de la Devolucion"
	#define STR0015 "Ocurrio un error inesperado. Favor contactar el administrador del sistema."
	#define STR0016 "Codigo"
	#define STR0017 "Seleccione los Vehiculos para Devolucion"
	#define STR0018 "Chasis"
	#define STR0019 "Valor"
	#define STR0020 "No se selecciono ningun vehiculo"
	#define STR0021 " debe controlar poder de terceros y "
	#define STR0022 " no debe controlar poder de terceros y "
	#define STR0023 " realizar movimientos de stock "
	#define STR0024 " no realizar movimientos de stock "
	#define STR0025 "El Tes de salida"
	#define STR0026 "segun la entrada."
	#define STR0027 "Codigo"
	#define STR0028 "TES"
	#define STR0029 "Vehiculo no encontrado"
	#define STR0030 "Item de nota de entrada no encontrado"
	#define STR0031 "¡No existe el producto agrupado para este modelo de vehiculo en el SB1! ¡Imposible continuar!"
#else
	#ifdef ENGLISH
		#define STR0001 "Outflow of Vehicles per Purchase Return"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add Return"
		#define STR0005 "Cancel Return"
		#define STR0006 "Caption"
		#define STR0007 "Advanced Search"
		#define STR0008 "Valid"
		#define STR0009 "Cancelled"
		#define STR0010 "Returned"
		#define STR0011 "Attention"
		#define STR0012 "Return"
		#define STR0013 "User does not have a record in salesman file. Please, prepare it."
		#define STR0014 "Return Data"
		#define STR0015 "An unexpected error occurred. Please, contact system administrator."
		#define STR0016 "Code"
		#define STR0017 "Select Vehicles to Return them"
		#define STR0018 "Chassis"
		#define STR0019 "Value"
		#define STR0020 "No Vehicle was selected."
		#define STR0021 " must control third party possession and "
		#define STR0022 " Don't forget to control the third party power and "
		#define STR0023 " move stock "
		#define STR0024 " It does not move stock "
		#define STR0025 "IOT code"
		#define STR0026 "According to inflow"
		#define STR0027 "Code"
		#define STR0028 "TIO"
		#define STR0029 "Vehicle not found"
		#define STR0030 "Inbound invoice item not found"
		#define STR0031 "There is no Grouped Product for this Vehicle Model in the SB1! Cannot continue!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Saída de Veículos por Devolução de Compra", "Saida de Veiculos por Devolucao de Compra" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Incluir Devolução", "Incluir Devolucao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Cancela Devolução", "Cancela Devolucao" )
		#define STR0006 "Legenda"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Pesquisa Avançada", "Pesquisa Avancada" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Válida", "Valida" )
		#define STR0009 "Cancelada"
		#define STR0010 "Devolvida"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0012 "Devolver"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Utilizador não possui registo no registo de vendedor. Favor providenciar.", "Usuario nao possui registro no cadastro de vendedor. Favor providenciar." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Dados da Devolução", "Dados da Devolucao" )
		#define STR0015 "Ocorreu um erro inesperado. Favor contactar o administrador do sistema."
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Código", "Não existe(m) veiculos(s) para o registro selecionado!" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Seleccione os veículos para devolução", "Selecione os Veiculos para Devolucao" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Chassis", "Chassi" )
		#define STR0019 "Valor"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Nenhum veículo foi seleccionado.", "Nenhum veiculo foi selecionado." )
		#define STR0021 " deve controlar poder de terceiros e "
		#define STR0022 " não deve controlar poder de terceiros e "
		#define STR0023 If( cPaisLoc $ "ANG|PTG", " movimentar stock ", " movimentar estoque " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", " não movimentar stock ", " não movimentar estoque " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "O TES de saída", "O Tes de saída" )
		#define STR0026 "segundo a entrada."
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Código", "Codigo" )
		#define STR0028 "TES"
		#define STR0029 "Veículo não encontrado"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Item da factura de entrada não encontrado", "Item da nota de entrada não encontrado" )
		#define STR0031 "Não existe o Produto Agrupado para este Modelo de Veículo no SB1! Impossível Continuar!"
	#endif
#endif
