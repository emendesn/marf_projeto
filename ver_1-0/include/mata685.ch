#ifdef SPANISH
	#define STR0001 "Apunte de la perdida"
	#define STR0002 "bUscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Borrar"
	#define STR0006 "Orden de produccion"
	#define STR0007 "Producto"
	#define STR0008 "Operacion"
	#define STR0009 "Recurso"
	#define STR0010 "Atencion"
	#define STR0011 "Para utilizar esta rutina, debe crearse el campo BC_SEQSD3 con el mismo tama�o y caracteristica del campo BC_NUMSEQ."
	#define STR0012 "OP informada finalizada con fecha anterior a ultima fecha de cierre."
	#define STR0013 "Anular"
	#define STR0014 "Continuar"
	#define STR0015 " Almacen: "
	#define STR0016 "Explosion del 1er nivel de la Estructura"
	#define STR0017 "1er Nivel"
	#define STR0018 "Ctd Perd."
	#define STR0019 "Acceso negado."
	#define STR0020 "Finalizada"
	#define STR0021 "La orden de producci�n informada esta finalizada. En este caso no se atribuira el costo de dicha perdida. Desea continuar"
	#define STR0022 "C�d. Lan�"
#else
	#ifdef ENGLISH
		#define STR0001 "Loss Registration"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Delete"
		#define STR0006 "Production Order"
		#define STR0007 "Product"
		#define STR0008 "Operation"
		#define STR0009 "Resour."
		#define STR0010 "Attention"
		#define STR0011 "You must create the field BC_SEQSD3 with the same size and characteristic as the field BC_NUMSEQ to use this routine."
		#define STR0012 "PO entered closed with a date prior to the last closing date. "
		#define STR0013 "Cancel "
		#define STR0014 "Continue "
		#define STR0015 " Warehouse: "
		#define STR0016 "Explosion of 1st level of Structure"
		#define STR0017 "1st Level"
		#define STR0018 "Lost Qty."
		#define STR0019 "Access denied"
		#define STR0020 "Closed"
		#define STR0021 "The manufacturing order is closed. At this example, the cost of loss will not be appropriated. Continue?"
		#define STR0022 "Code Entry"
	#else
		#define STR0001 "Apontamento da Perda"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Ordem de Produ��o", "Ordem de Produ��o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Artigo", "Produto" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Opera��o", "Opera��o" )
		#define STR0009 "Recurso"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Deve ser criado o campo BC_SEQD3 com o mesmo tamanho e caracter�sticas do campo BC_NUMSEQ para a utiliza��o deste procedimento.", "Deve ser criado o campo BC_SEQSD3 com o mesmo tamanho e caracteristica do campo BC_NUMSEQ para utilizacao dessa rotina." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "OP informada encerrada com data anterior a �ltima data de fechamento.", "OP informada encerrada com data anterior a ultima data de fechamento." )
		#define STR0013 "Cancelar"
		#define STR0014 "Continuar"
		#define STR0015 " Armaz�m: "
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Explos�o do 1� n�vel da estrutura", "Explos�o do 1� n�vel da Estrutura" )
		#define STR0017 "1� N�vel"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Qtd. Perd.", "Qtde Perd." )
		#define STR0019 "Acesso negado"
		#define STR0020 "Encerrada"
		#define STR0021 "A ordem de produ��o informada encontra-se encerrada. Neste caso o custo desta perda n�o ser� apropriado. Deseja prosseguir?"
		#define STR0022 "C�d. Lan�"
	#endif
#endif
