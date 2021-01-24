#ifdef SPANISH
	#define STR0001 "bUscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Ubicacion Fisica"
	#define STR0007 "Salir"
	#define STR0008 "Confirmar"
	#define STR0009 "�Cuanto al borrado?"
	#define STR0010 "El deposito"
	#define STR0011 " Ubicacion "
	#define STR0012 " tiene  "
	#define STR0013 "saldo en stock. Borrar esta ubicacion impedira "
	#define STR0014 "nuevas distribuciones para ella. "
	#define STR0015 "�Confirma borrado?"
	#define STR0016 "Atencion - "
	#define STR0017 "Ocupacion"
	#define STR0018 "Grafico de ocupacion de ubicaciones"
	#define STR0019 "Ocupacion de ubicaciones por posicion"
	#define STR0020 "Ubicaciones ocupadas"
	#define STR0021 "Ubicaciones desocupadas"
	#define STR0022 "Espere, colectando datos para el grafico..."
	#define STR0023 "No existen registros de la sucursal "
	#define STR0024 " en el archivo de ubicaciones."
	#define STR0025 "Negro          "
	#define STR0026 "Azul oscuro    "
	#define STR0027 "Verde oscuro   "
	#define STR0028 "Azul turquesa  "
	#define STR0029 "Rojo oscuro    "
	#define STR0030 "Magenta oscuro "
	#define STR0031 "Marron         "
	#define STR0032 "Gris           "
	#define STR0033 "Gris claro     "
	#define STR0034 "Gris oscuro    "
	#define STR0035 "Azul           "
	#define STR0036 "Verde          "
	#define STR0037 "Azul verdoso   "
	#define STR0038 "Rojo           "
	#define STR0039 "Magenta        "
	#define STR0040 "Amarillo       "
	#define STR0041 "Blanco         "
	#define STR0042 "Colores disponibles"
	#define STR0043 "Ajustando"
	#define STR0045 "Espere"
	#define STR0046 "El Status no puede ser modificado porque esta Localizacion esta"
	#define STR0047 "Ocupada"
	#define STR0048 "Desocupada"
	#define STR0049 "La estruc. fisica solo podra modificarse cuando esta direccion este desocupada   "
	#define STR0050 "Esta ubicacion no puede borrarse por que tiene el estatus con contenido igual a Ocupado/Bloqueado"
	#define STR0051 "Esta ubicacion no puede borrarse por que tiene movimientos con fecha posterior al ultimo cierre."
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "View  "
		#define STR0003 "Add "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "Location"
		#define STR0007 "Quit   "
		#define STR0008 "Confirm"
		#define STR0009 "About Deleting?  "
		#define STR0010 "The warehouse "
		#define STR0011 " location "
		#define STR0012 " has    "
		#define STR0013 "stock balance . If you delete this location,you cannot make "
		#define STR0014 "distributions in its favor. "
		#define STR0015 "OK to Delete?"
		#define STR0016 "Attention - "
		#define STR0017 "Occupation"
		#define STR0018 "Locations occupation chart"
		#define STR0019 "Locations occupation by Position"
		#define STR0020 "Occupied Locations"
		#define STR0021 "Free Locations"
		#define STR0022 "Wait, Collecting data for the chat..."
		#define STR0023 "There are no branch records "
		#define STR0024 " in the Address File."
		#define STR0025 "Black          "
		#define STR0026 "Dark blue      "
		#define STR0027 "Dark green     "
		#define STR0028 "Dark aciano    "
		#define STR0029 "Dark red       "
		#define STR0030 "Magenta        "
		#define STR0031 "Brown          "
		#define STR0032 "Grey           "
		#define STR0033 "Light grey     "
		#define STR0034 "Dark grey      "
		#define STR0035 "Blue           "
		#define STR0036 "Green          "
		#define STR0037 "Aciano         "
		#define STR0038 "Red            "
		#define STR0039 "Magenta        "
		#define STR0040 "Yellow         "
		#define STR0041 "White          "
		#define STR0042 "Available Colors "
		#define STR0043 "Adjusting"
		#define STR0045 "Wait"
		#define STR0046 "The Status can not be modified because this Location is"
		#define STR0047 "Occupied"
		#define STR0048 "Free"
		#define STR0049 "The Physical Structure can only be  edited when this address is unoccupied.      "
		#define STR0050 "This address cannot be deleted because its status is equal to Busy/Blocked"
		#define STR0051 "This address cannot be deleted because it has transactions dated later than the last closing."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Morada", "Endereco Fisico" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 "Confirma"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Quanto � exclus�o?", "Quanto � exclusao?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "O armaz�m ", "O armazem " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " endere�o ", " endereco " )
		#define STR0012 " possui "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Saldo em stock . excluir este endere�o impedir nova(s) ", "saldo em estoque . Excluir este endereco impedira nova(s) " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Distribui��es para a mesma. ", "distribuicoes para a mesma. " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Cofacturairma elimina��o ?", "Confirma exclusao ?" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Aten��o - ", "Atencao - " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Ocupa��o", "Ocupacao" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Gr�fico de ocupa��o dos enderec�os", "Grafico de ocupacao dos enderecos" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Ocupa��o Dos Endere�os Por Posi��o", "Ocupacao dos Enderecos por Posicao" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Moradas Ocupadas", "Enderecos Ocupados" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Moradas Desocupadas", "Enderecos Desocupados" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Aguarde, a reunir dados para o gr�fico...", "Aguarde, Coletando dados para o grafico..." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "N�o existem registos da filial ", "Nao existem registros da filial " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", " No Registo De Endere�os.", " no Cadastro de Enderecos." )
		#define STR0025 "Preto          "
		#define STR0026 "Azul escuro    "
		#define STR0027 "Verde escuro   "
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Cian escuro   ", "Ciano escuro   " )
		#define STR0029 "Vermelho escuro"
		#define STR0030 "Magenta escuro "
		#define STR0031 "Marrom         "
		#define STR0032 "Cinza          "
		#define STR0033 "Cinza claro    "
		#define STR0034 "Cinza escuro   "
		#define STR0035 "Azul           "
		#define STR0036 "Verde          "
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Cian          ", "Ciano          " )
		#define STR0038 "Vermelho       "
		#define STR0039 "Magenta        "
		#define STR0040 "Amarelo        "
		#define STR0041 "Branco         "
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Cores Dispon�veis", "Cores Disponiveis" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "A ajustar", "Ajustando" )
		#define STR0045 "Aguarde"
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "O estado n�o pode ser alterado, pois este endere�o est�", "O Status nao pode ser alterado, pois este Endereco esta" )
		#define STR0047 "Ocupado"
		#define STR0048 "Desocupado"
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "A Estrutura Fisica So Poder� Ser Alterada Quando Esta Morada Estiver Desocupada", "A Estrutura Fisica so podera ser alterada quando este Endereco estiver Desocupado" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Este endere�o n�o pode ser eliminado, porque possui o estado com conte�do igual a ocupado/bloqueado", "Este endereco n�o pode ser excluido porque possui o status com conteudo igual a Ocupado/Bloqueado" )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Este morada n�o pode ser excluido porque possui movimenta��es com data posterior ao �ltimo fechamento.", "Este endere�o n�o pode ser excluido porque possui movimenta��es com data posterior ao ultimo fechamento." )
	#endif
#endif
