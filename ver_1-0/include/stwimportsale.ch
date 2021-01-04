#ifdef SPANISH
	#define STR0001 "No fue posible importar el(los) presupuesto(s) "
	#define STR0002 "�continua la importacion de los otros?"
	#define STR0003 "Confirma importacion del(os) presupuesto(s) "
	#define STR0004 "Presupuesto: "
	#define STR0005 " no posee numero de DAV o Preventa. En entorno PAF-ECF no se permite importar Presupuesto "
	#define STR0006 "�que no provenga de un DAV o Pre-Venta! Verifique si el entorno que genero el presupuesto "
	#define STR0007 "esta activado para operar en modo PAF-ECF con DAV o Pre-Venta."
	#define STR0008 "Ocurrio falla de comunicacion entre los entornos"
	#define STR0009 "La Pre-venta "
	#define STR0010 " no se encontro en la Retaguardia."
	#define STR0011 "LA DAV "
	#define STR0012 " no se encontro en la Retaguardia."
	#define STR0013 " ya se importo de la Retaguardia."
	#define STR0014 " no contiene items que no poseen saldo en stock."
	#define STR0015 "Error al cargar presupuesto, intente nuevamente"
	#define STR0016 "El Presupuesto "
	#define STR0017 "Presupuesto vencido"
#else
	#ifdef ENGLISH
		#define STR0001 "It was not possible to import quotations "
		#define STR0002 "continue import to others?"
		#define STR0003 "Confirm importing quotations "
		#define STR0004 "Quotation: "
		#define STR0005 " has no DAV number or Pre-Sale. In PAF-ECF environment is not permitted importing Quotations "
		#define STR0006 "that does not come from a DAV or Pre-Sale! Check the environment that created the Quotation "
		#define STR0007 "is enabled to operate in PAF-ECF mode with DAV or Pre-Sale."
		#define STR0008 "A communication failure took place between the environments"
		#define STR0009 "Pre-Sale "
		#define STR0010 " was not found in Back Office."
		#define STR0011 "DAV "
		#define STR0012 " was not found in Back Office."
		#define STR0013 " was already imported from Back Office."
		#define STR0014 " does not contain items that are not in stock."
		#define STR0015 "Error loading quotation, please try again"
		#define STR0016 "Quotation "
		#define STR0017 "Quotation expired"
	#else
		#define STR0001 "N�o foi poss�vel importar o(s) or�amento(s) "
		#define STR0002 "continua a importa��o dos outros?"
		#define STR0003 "Confirma importa��o do(s) or�amento(s) "
		#define STR0004 "Or�amento: "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", " n�o possui n�mero de DAV ou Pr�-Venda. Em ambiente PAF-ECF, n�o � permitido importar Or�amento ", " n�o possui n�mero de DAV ou Pr�-Venda. Em ambiente PAF-ECF n�o � permitido importar Or�amento " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "que n�o seja proveniente de um DAV ou Pr�-Venda. Verifique se o ambiente que gerou o Or�amento ", "que n�o seja proveniente de um DAV ou Pr�-Venda! Verifique se o ambiente que gerou o Or�amento " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "est� habilitado para operar em modo PAF-ECF com DAV ou Pr�-Venda.", "esta habilitado para operar em modo PAF-ECF com DAV ou Pre-Venda." )
		#define STR0008 "Ocorreu falha de comunica��o entre os ambientes"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A pr�-venda ", "A Pre-Venda " )
		#define STR0010 " n�o foi encontrada na Retaguarda."
		#define STR0011 "A DAV "
		#define STR0012 " n�o foi encontrada na Retaguarda."
		#define STR0013 " j� foi importado da Retaguarda."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " n�o cont�m itens que n�o possuem saldo em stock.", " n�o contem itens que n�o possuem saldo em estoque." )
		#define STR0015 "Erro ao carregar or�amento, tente novamente"
		#define STR0016 "O Or�amento "
		#define STR0017 "Or�amento expirado"
	#endif
#endif
