#ifdef SPANISH
	#define STR001  "Buscar"
	#define STR002  "Modificar"
	#define STR003  "Visualizar"
	#define STR004  "Incluir"
	#define STR005  "Borrar"
	#define STR006  "Modelos de boletas disponibles"
	#define STR007  "Fecha de Vencimiento"
	#define STR008  "Fecha de Emision"
	#define STR009  "Numero de la Boleta"
	#define STR010  "Total de la Boleta"
	#define STR011  "Nombre del Cliente"
	#define STR012  "Direccion del Cliente"
	#define STR013  "Barrio del Cliente"
	#define STR014  "Municipio del Cliente"
	#define STR015  "Estado/Provincia/Region del do Cliente"
	#define STR016  "Mensaje 1"
	#define STR017  "Mensaje 2"
	#define STR018  "Mensaje 3"
	#define STR019  "Mensaje 4"
	#define STR020  "Mensaje 5"
	#define STR021  "Configuracion de boletas para impresion"
	#define STR022  " Modelo de boleta "
	#define STR023  "ATENCION: El numero de la linea y de la columna debe ser superior a cero."
	#define STR024  "CGC del Cliente"
	#define STR025  "CP del Cliente"
	#define STR026  "Lugar de Pago"
	#define STR027  "Especie del Doc."
	#define STR028  "Tipo de Doc"
	#define STR029  "Fecha Base"
	#define STR030  "Aceptacion"
	#define STR031  "Cartera"
	#define STR032  "Cedente"
	#define STR033  "Ultima Situacion Form"
#else
	#ifdef ENGLISH
		#define STR001  "Search"
		#define STR002  "Change"
		#define STR003  "View"
		#define STR004  "Add"
		#define STR005  "Delete"
		#define STR006  "Available bank bill models"
		#define STR007  "Due Date"
		#define STR008  "Issue Date"
		#define STR009  "Bank Bill Number"
		#define STR010  "Bank Bill Total"
		#define STR011  "Customer�s Name"
		#define STR012  "Customer�s Address"
		#define STR013  "Customer�s District"
		#define STR014  "Customer�s City"
		#define STR015  "Customer�s State"
		#define STR016  "Message 1"
		#define STR017  "Message 2"
		#define STR018  "Message 3"
		#define STR019  "Message 4"
		#define STR020  "Message 5"
		#define STR021  "Configuration of bank bills for print"
		#define STR022  " Bank bill model "
		#define STR023  "ATTENTION: Row and column number must be higher than zero."
		#define STR024  "Customer CGC"
		#define STR025  "Customer Postal Code"
		#define STR026  "Payment Location"
		#define STR027  "Doc. Type"
		#define STR028  "Doc. Type"
		#define STR029  "Base Date"
		#define STR030  "Acceptance"
		#define STR031  "Card"
		#define STR032  "Assignor"
		#define STR033  "Last Position Form"
	#else
		#define STR001  "Pesquisar"
		#define STR002  "Alterar"
		#define STR003  "Visualizar"
		#define STR004  "Incluir"
		#define STR005  "Excluir"
		#define STR006  If( cPaisLoc $ "ANG|PTG", "Modelos de boletos dispon�veis", "Modelos de boletos disponiveis" )
		#define STR007  "Data de Vencimento"
		#define STR008  If( cPaisLoc $ "ANG|PTG", "Data de Emiss�o", "Data de Emissao" )
		#define STR009  If( cPaisLoc $ "ANG|PTG", "N�mero do Boleto", "Numero do Boleto" )
		#define STR010  "Total do Boleto"
		#define STR011  "Nome do Cliente"
		#define STR012  If( cPaisLoc $ "ANG|PTG", "Morada do Cliente", "Endereco do Cliente" )
		#define STR013  If( cPaisLoc $ "ANG|PTG", "Freguesia do Cliente", "Bairro do Cliente" )
		#define STR014  If( cPaisLoc $ "ANG|PTG", "Concelho do Cliente", "Municipio do Cliente" )
		#define STR015  If( cPaisLoc $ "ANG|PTG", "Distrito do Cliente", "UF do Cliente" )
		#define STR016  "Mensagem 1"
		#define STR017  "Mensagem 2"
		#define STR018  "Mensagem 3"
		#define STR019  "Mensagem 4"
		#define STR020  "Mensagem 5"
		#define STR021  If( cPaisLoc $ "ANG|PTG", "Configura��o de boletos para impress�o", "Configuracao de boletos para impressao" )
		#define STR022  " Modelo do boleto "
		#define STR023  If( cPaisLoc $ "ANG|PTG", "ATEN��O: O n�mero da linha e da coluna deve ser maior que zero.", "ATENCAO: O numero da linha e da coluna deve ser maior que zero." )
		#define STR024  If( cPaisLoc $ "ANG|PTG", "Nr.Contribuinte do Cliente", "CGC do Cliente" )
		#define STR025  If( cPaisLoc $ "ANG|PTG", "CP do Cliente", "CEP do Cliente" )
		#define STR026  "Local de Pagamento"
		#define STR027  If( cPaisLoc $ "ANG|PTG", "Esp�cie do Doc.", "Especie do Doc." )
		#define STR028  "Tipo de Doc"
		#define STR029  "Data Base"
		#define STR030  "Aceite"
		#define STR031  "Carteira"
		#define STR032  "Cedente"
		#define STR033  If( cPaisLoc $ "ANG|PTG", "�ltima Posi��o Form", "Ultima Posicao Form" )
	#endif
#endif
