#ifdef SPANISH
	#define STR0001 "Reservas"
	#define STR0002 "Modelo de Datos del Archivo de Reserva"
	#define STR0003 "Datos de la Reserva"
	#define STR0004 "Datos del Item de la Reserva"
	#define STR0005 'Total de fardos'
	#define STR0006 'Total disponible'
	#define STR0007 'Peso bruto total'
	#define STR0008 'Peso neto total'
	#define STR0009 "Seleccionar fardos"
	#define STR0010 "Buscar"
	#define STR0011 "Visualizar"
	#define STR0012 "Incluir"
	#define STR0013 "Modificar"
	#define STR0014 "Borrar"
	#define STR0015 "Imprimir"
	#define STR0016 "Seleccion de fardos"
	#define STR0017 "Bloque"
	#define STR0018 "Fardos libres"
	#define STR0019 "Acciones"
	#define STR0020 "Fardos reservados"
	#define STR0021 "Tipo"
	#define STR0022 "Etiqueta"
	#define STR0023 "Fardo"
	#define STR0024 "Peso Neto"
	#define STR0025 "Peso bruto"
	#define STR0026 "Vincular Marcados"
	#define STR0027 "Desvincular Marcados"
	#define STR0028 "Cant. Reservada"
	#define STR0029 "¡Atencion!"
	#define STR0030 "La cantidad en movimiento es superior a la cantidad de fardos disponibles"
	#define STR0031 "Este fardo ya pertenece a otra reserva"
	#define STR0032 "Seleccion no permitida..."
	#define STR0033 "Fardo pendiente"
	#define STR0034 "Fardo embarcado"
	#define STR0035 "Subtitulo"
	#define STR0036 "Estatus"
	#define STR0037 "La cosecha que consta en el contrato es diferente de la cosecha informada en la reserva"
	#define STR0038 "Usuario no posee Unidad de mejora registrada."
#else
	#ifdef ENGLISH
		#define STR0001 "Reserves"
		#define STR0002 "Data Model of Reserve File"
		#define STR0003 "Reserve Data"
		#define STR0004 "Reserve Item Data"
		#define STR0005 'Total of Bales'
		#define STR0006 'Total Availability'
		#define STR0007 'Total gross weight'
		#define STR0008 'Total Net Weight'
		#define STR0009 "Select Bales"
		#define STR0010 "Search"
		#define STR0011 "View"
		#define STR0012 "Add"
		#define STR0013 "Edit"
		#define STR0014 "Delete"
		#define STR0015 "Print"
		#define STR0016 "Selection of Bales"
		#define STR0017 "Block"
		#define STR0018 "Free Bales"
		#define STR0019 "Actions"
		#define STR0020 "Reserved Bales"
		#define STR0021 "Type"
		#define STR0022 "Label"
		#define STR0023 "Bale"
		#define STR0024 "Net Weight"
		#define STR0025 "Gross Weight"
		#define STR0026 "Associate the Selected ones"
		#define STR0027 "Dissociate the Selected ones"
		#define STR0028 "Amt. Reservada"
		#define STR0029 "Attention"
		#define STR0030 "The amount operated is greater than the amount of available bales"
		#define STR0031 "This bale already belongs to another reserve"
		#define STR0032 "Selection not allowed..."
		#define STR0033 "Pending Bale"
		#define STR0034 "Shipped Bale"
		#define STR0035 "Caption"
		#define STR0036 "Status"
		#define STR0037 "The contract crop differs from the crop in the reservation"
		#define STR0038 "User has no Benefit Unit registered."
	#else
		#define STR0001 "Reservas"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Modelo de dados do registo de reserva", "Modelo de Dados do Cadastro de Reserva" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Dados da reserva", "Dados da Reserva" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Dados do item da reserva", "Dados do Item da Reserva" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Total de fardos', 'Total de Fardos' )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", 'Total disponível', 'Total Disponivel' )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", 'Peso bruto total', 'Peso Bruto Total' )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", 'Peso líquido total', 'Peso Líquido Total' )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Seleccionar fardos", "Selecionar Fardos" )
		#define STR0010 "Pesquisar"
		#define STR0011 "Visualizar"
		#define STR0012 "Incluir"
		#define STR0013 "Alterar"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0015 "Imprimir"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Selecção de fardos", "Seleção de Fardos" )
		#define STR0017 "Bloco"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Fardos livres", "Fardos Livres" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Acções", "Ações" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Fardos reservados", "Fardos Reservados" )
		#define STR0021 "Tipo"
		#define STR0022 "Etiqueta"
		#define STR0023 "Fardo"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Peso líquido", "Peso Liquido" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Peso bruto", "Peso Bruto" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Vincular marcados", "Vincular Marcados" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Desvincular marcados", "Desvincular Marcados" )
		#define STR0028 "Qtd. Reservada"
		#define STR0029 "Atenção"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "A quantidade movimentada é superior à quantidade de fardos disponíveis", "A quantidade movimentada é superior a quantidade de fardos disponiveis" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Este fardo já pertence a outra reserva.", "Este fardo ja esta pertence a outra reservada" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Selecção não permitida...", "Selecão não permitida..." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Fardo pendente", "Fardo Pendente" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Fardo embarcado", "Fardo Embarcado" )
		#define STR0035 "Legenda"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0037 "A safra do contrato difere da safra informada na reserva"
		#define STR0038 "Usuário não possui Unidade de Beneficiamento cadastrado."
	#endif
#endif
