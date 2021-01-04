#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Examenes por Sucursal"
	#define STR0007 "Clientes"
	#define STR0008 "Examenes"
	#define STR0009 "Incluir Lote"
	#define STR0010 "No existe Sucursal registrada."
	#define STR0011 "Atencion"
	#define STR0012 "No existe Examen registrado."
	#define STR0013 "Generar Examenes Por Sucursal (En Lote)"
	#define STR0014 "Sucursal:"
	#define STR0015 "Localizar"
	#define STR0016 "Seleccione los examenes para cada sucursal"
	#define STR0017 "Modificar Rango "
	#define STR0018 "Al marcar/desmarcar un examen, �desea replicar en todas las sucursales seleccionadas?"
	#define STR0019 "Rango Estandar"
	#define STR0020 "�Confirma la generacion de los examenes por sucursal?"
	#define STR0021 "Necesita seleccionar el item: "
	#define STR0022 "Sucursal"
	#define STR0023 "Examen"
	#define STR0024 "Rango"
	#define STR0025 "Desea replicar este Rango para todos los examenes?"
	#define STR0026 "No fue posible localizar esta sucursal."
	#define STR0027 "No fue posible localizar este examen."
	#define STR0028 "El campo Rango es obligatorio."
	#define STR0029 "Sucursal: "
	#define STR0030 "Examen: "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Exams per Branch"
		#define STR0007 "Customers"
		#define STR0008 "Analyses"
		#define STR0009 "Add Lot"
		#define STR0010 "There is no Branch registered."
		#define STR0011 "Attention"
		#define STR0012 "There is no Examination registered."
		#define STR0013 "Generate Examinations per Branch (Batch)"
		#define STR0014 "Branch:"
		#define STR0015 "Locate"
		#define STR0016 "Select examinations for each branch"
		#define STR0017 "Change Range"
		#define STR0018 "When checking/unchecking an examination, do you want to replicate to all branches selected?"
		#define STR0019 "Standard Range"
		#define STR0020 "Confirm generation of examinations by branch?"
		#define STR0021 "Must select item: "
		#define STR0022 "Branch"
		#define STR0023 "Examination"
		#define STR0024 "Range"
		#define STR0025 "Do you want to replicate this Range to all examinations?"
		#define STR0026 "This branch could not be located."
		#define STR0027 "This examination could not located."
		#define STR0028 "The field Range is mandatory."
		#define STR0029 "Branch: "
		#define STR0030 "Examination: "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Exames Por Filial", "Exames por Filial" )
		#define STR0007 "Clientes"
		#define STR0008 "Exames"
		#define STR0009 "Incluir Lote"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "N�o existe Filial registada.", "N�o existe Filial cadastrada." )
		#define STR0011 "Aten��o"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "N�o existe Exame registado.", "N�o existe Exame cadastrado." )
		#define STR0013 "Gerar Exames Por Filial (Em Lote)"
		#define STR0014 "Filial:"
		#define STR0015 "Localizar"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Seleccione os exames para cada filial", "Selecione os exames para cada filial" )
		#define STR0017 "Alterar Faixa"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ao marcar/desmarcar um exame, deseja replicar em todas as filiais seleccionadas?", "Ao marcar/desmarcar um exame, deseja replicar em todas as filiais selecionadas?" )
		#define STR0019 "Faixa Padr�o"
		#define STR0020 "Confirma a gera��o dos exames por filial?"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Necessita seleccionar o elemento: ", "Necessita selecionar o item: " )
		#define STR0022 "Filial"
		#define STR0023 "Exame"
		#define STR0024 "Faixa"
		#define STR0025 "Deseja replicar esta Faixa para todos os exames?"
		#define STR0026 "N�o foi poss�vel localizar esta filial."
		#define STR0027 "N�o foi poss�vel localizar este exame."
		#define STR0028 "O campo Faixa � obrigat�rio."
		#define STR0029 "Filial: "
		#define STR0030 "Exame: "
	#endif
#endif
