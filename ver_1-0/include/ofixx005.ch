#ifdef SPANISH
	#define STR0001 "Formas de Descuento"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "1-Promocion"
	#define STR0008 "2-CAI"
	#define STR0009 "3-Grupo Pieza"
	#define STR0010 "4-Grupo Descuento"
	#define STR0011 "5-Clas.Financ"
	#define STR0012 "6-Modelo Vehiculo"
	#define STR0013 "Confirma el borrado de los parametros de descuento de esta marca"
	#define STR0014 "�Confirma?"
	#define STR0015 "Cantidad de Items es mayor que el stock actual...   ( "
	#define STR0016 "�Atencion.!"
	#define STR0017 " Carpeta: "
	#define STR0018 "Item Duplicado en la Carpeta: "
	#define STR0019 " Grupo/Item: "
	#define STR0020 " Grupo Descuento:"
	#define STR0021 "Carpeta: "
	#define STR0022 " Clas.Financiera:"
	#define STR0023 " Modelo:"
	#define STR0024 "Marca + Centro de Ingreso"
	#define STR0025 "Secuencia informada esta incorrecta..."
	#define STR0026 "Digito informado esta incorrecto..."
	#define STR0027 "�Atencion!"
	#define STR0028 "No se informo ningun descuento..."
	#define STR0029 "�Desea visualizar datos historicos?"
	#define STR0030 "Ya hay una politica de descuento registrada con el encabezamiento de arriba. La confirmacion sobrescribira la anterior. �Confirma grabacion?"
	#define STR0031 "�Desea salir de la pantalla de politicas de descuento?"
	#define STR0032 "No se pudo abrir la tabla de Tipos de Descuentos. La operacion se abortara."
	#define STR0033 "Entre en contacto con el administrador del sistema."
	#define STR0034 "No se pudo abrir la tabla de Items de Tipos de Descuentos. La operacion se abortara."
	#define STR0035 "Entre en contacto con el administrador del sistema."
	#define STR0036 "A Pieza "
	#define STR0037 " : tiene precio fijo."
	#define STR0038 " tiene un descuento mas alla de lo permitido. "
	#define STR0039 " tiene margen de ganancia inferior a la permitida."
	#define STR0040 " : Descuento del cliente excedido ! Criterio Mayor"
	#define STR0041 " : Descuento del cliente excedido ! Criterio Estandar."
#else
	#ifdef ENGLISH
		#define STR0001 "Forms of Discounts"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "1-Promotion"
		#define STR0008 "2-CAI"
		#define STR0009 "3-Group Part"
		#define STR0010 "4-Group Discount"
		#define STR0011 "5-Financial Class"
		#define STR0012 "6-Vehicle Model "
		#define STR0013 "Confirm exclusion of discount parameters of this brand"
		#define STR0014 "Do you confirm it?"
		#define STR0015 "Amount of items is larger than current inventory...   ( "
		#define STR0016 "Attention...!"
		#define STR0017 " Folder: "
		#define STR0018 "Item doubled in the Folder: "
		#define STR0019 " Group/Item: "
		#define STR0020 " Group Discount:"
		#define STR0021 "Folder: "
		#define STR0022 " Financial Class:"
		#define STR0023 " Model:"
		#define STR0024 "Brand + Revenue Center"
		#define STR0025 "Sequence enter is not correct..."
		#define STR0026 "Digit informed is not correct..."
		#define STR0027 "Attention!"
		#define STR0028 "No discount was indicated..."
		#define STR0029 "Do you want to view history?"
		#define STR0030 "There is already a discount policy registered with the header above. Confirming overwrites the previous. Confirm saving?"
		#define STR0031 "Do you want to exit screen of discount policies?"
		#define STR0032 "It was not possible to open Types of Discounts table. The operation will be aborted."
		#define STR0033 "Contact the system administrator."
		#define STR0034 "It was not possible to open table of Items of Discounts Types. The operation will be aborted."
		#define STR0035 "Contact the system administrator."
		#define STR0036 "The part "
		#define STR0037 " : has fixed price."
		#define STR0038 " presents discount beyond the allowed. "
		#define STR0039 " presents profit margin lower the allowed."
		#define STR0040 " : Customer discount surpassed! Higher criteria"
		#define STR0041 " : Customer discount surpassed! Default criteria."
	#else
		#define STR0001 "Formas de Descontos"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "1-Promo��o", "1-Promocao" )
		#define STR0008 "2-CAI"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "3-Grupo Pe�a", "3-Grupo Peca" )
		#define STR0010 "4-Grupo Desconto"
		#define STR0011 "5-Clas.Financ"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "6-Modelo Ve�culo", "6-Modelo Veiculo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Confirma a exclus�o dos par�metros de desconto desta marca", "Confirma a exclusao dos parametros de desconto desta marca" )
		#define STR0014 "Confirma?"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Quantidade de elens � maior que o estoque actual...   ( ", "Quantidade de Itens e maior que o estoque atual...   ( " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Aten��o...!", "Atencao...!" )
		#define STR0017 " Pasta: "
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Elem Duplicado na Pasta: ", "Item Duplicado na Pasta: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", " Grupo/Elem: ", " Grupo/Item: " )
		#define STR0020 " Grupo Desconto:"
		#define STR0021 "Pasta: "
		#define STR0022 " Class.Financeira:"
		#define STR0023 " Modelo:"
		#define STR0024 "Marca + Centro de Receita"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Sequ�ncia informada est� incorreta...", "Sequencia informada esta incorreta..." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "D�gito informado est� incorrecto...", "Digito informado esta incorreto..." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Aten��o!", "Atencao!" )
		#define STR0028 "Nenhum desconto foi informado..."
		#define STR0029 "Deseja visualizar dados historicos?"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Ja existe pol�tica de desconto cadastrada com o cabe�alho acima. A confirma��o ir� sobreescrever a anterior. Confirma grava��o?", "Ja existe politica de desconto cadastrada com o cabecalho acima. A confirma��o ira sobreescrever a anterior. Confirma gravacao?" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Deseja sair da tela de pol�ticas de desconto?", "Deseja sair da tela de politicas de desconto?" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel abrir a tabela de Tipos de Descontos. A opera��o ser� abortada.", "Nao foi possivel abrir a tabela de Tipos de Descontos. A operacao sera abortada." )
		#define STR0033 "Contacte o administrador do sistema."
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel abrir a tabela de Elens de Tipos de Desconto. A opera��o ser� abortada.", "Nao foi possivel abrir a tabela de Itens de Tipos de Desconto. A operacao sera abortada." )
		#define STR0035 "Contacte o administrador do sistema."
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "A Pe�a ", "A Peca " )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", " : possui pre�o fixo.", " : possui preco fixo." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", " est� com desconto al�m do permitido. ", " esta com desconto alem do permitido. " )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", " est� com a margem de lucro inferior a permitida.", " esta com a margem de lucro inferior a permitida." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", " : Desconto do cliente superado ! Crit�rio Maior", " : Desconto do cliente superado ! Criterio Maior" )
		#define STR0041 " : Desconto do cliente superado ! Crit�rio Padr�o."
	#endif
#endif