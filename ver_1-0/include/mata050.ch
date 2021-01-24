#ifdef SPANISH
	#define STR0001 "Actualizacion de transportadoras"
	#define STR0002 "Contactos"
	#define STR0003 "Fact. de flete"
	#define STR0004 "Este proveedor posee movimiento de telemercadeo y no se podra borrar"
	#define STR0005 "Geoprocesamiento"
	#define STR0006 "Geo"
	#define STR0007 "Atencion"
	#define STR0008 "El CNPJ informado se utilizo en la transportadora"
	#define STR0009 "Aceptar"
	#define STR0010 "Anular"
	#define STR0011 "La base del CNPJ se utilizo en otra transportadora:"
	#define STR0012 "El CPF informado ya se utilizo en la transportadora"
	#define STR0013 "Espere"
	#define STR0014 "Anotando registros para integracion"
	#define STR0015 "Ejecutando integracion"
	#define STR0016 "CNPJ/CPF (A4_CGC) no se puede modificar por servir como identificador en el SIGAGFE."
	#define STR0017 "Inconsistencia con el Flete Embarcador (SIGAGFE): "
	#define STR0018 "Buscar"
	#define STR0019 "Visualizar"
	#define STR0020 "Incluir"
	#define STR0021 "Modificar"
	#define STR0022 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Carriers Update"
		#define STR0002 "Contacts"
		#define STR0003 "Waybill"
		#define STR0004 "This supplier has telemarketing movement and cannot be deleted"
		#define STR0005 "Geoprocessing   "
		#define STR0006 "Geo"
		#define STR0007 "Attention"
		#define STR0008 "The CNPJ informed was already used in the carrier."
		#define STR0009 "Accept"
		#define STR0010 "Cancel"
		#define STR0011 "The CNPJ base was used in another carrier:"
		#define STR0012 "The CPF informed was already used in the carrier."
		#define STR0013 "Wait"
		#define STR0014 "Annotating records for integration"
		#define STR0015 "Running integration"
		#define STR0016 "CNPJ/CPF (A4_CGC) cannot be changed to serve as identifier in SIGAGFE module."
		#define STR0017 "Inconsistency with Shipper Freight (SIGAGFE): "
		#define STR0018 "Search"
		#define STR0019 "View"
		#define STR0020 "Add"
		#define STR0021 "Edit"
		#define STR0022 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Actualiza��o de Transportadoras", "Atualiza��o de Transportadoras" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Contactos", "conTatos" )
		#define STR0003 "Conhecimento"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Este fornecedor possui movimento de telemarketing e n�o poder� ser exclu�do", "Este fornecedor possui movimento de telemarketing e nao podera ser excluido" )
		#define STR0005 "Geoprocessamento"
		#define STR0006 "Geo"
		#define STR0007 "Aten��o"
		#define STR0008 "O CNPJ informado j� foi utilizado na transportadora"
		#define STR0009 "Aceitar"
		#define STR0010 "Cancelar"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "A base do CNPJ foi utilizada em outra transportadora:", "A base do CNPJ foi utilizado em outra transportadora:" )
		#define STR0012 "O CPF informado j� foi utilizado na transportadora"
		#define STR0013 "Aguarde"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A anotar registos para integra��o", "Anotando registros para integracao" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "A executar integra��o", "Executando integracao" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "O No.Contribuinte (A4_CGC) n�o pode ser alterado por servir como identificador no SIGAGFE.", "CNPJ/CPF (A4_CGC) n�o pode ser alterado por servir como identificador no SIGAGFE." )
		#define STR0017 "Inconsist�ncia com o Frete Embarcador (SIGAGFE): "
		#define STR0018 "Pesquisar"
		#define STR0019 "Visualizar"
		#define STR0020 "Incluir"
		#define STR0021 "Alterar"
		#define STR0022 "Excluir"
	#endif
#endif
