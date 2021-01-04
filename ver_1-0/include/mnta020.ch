#ifdef SPANISH
	#define STR0001 "Salir"
	#define STR0002 "Confirma"
	#define STR0003 "Reescribir"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Bienes"
	#define STR0010 "Archivo de empleados"
	#define STR0011 "MANO DE OBRA DEL CENTRO DE COSTO "
	#define STR0012 "Empleado no habilitado con la planilla"
	#define STR0013 "Situacion:"
	#define STR0014 "NO CONFORMIDAD"
	#define STR0015 "Continuar"
	#define STR0016 "Empleado no esta registrado como empleado de Mantenimiento."
	#define STR0017 "Para que el producto sea registrado correctamente en la tabla de Saldos en Stock(SB2) y/o Productos(SB1), el campo centro de costo "
	#define STR0018 "debe poseer maximo 12 caracteres."
	#define STR0019 "Debera informarse la fecha fin de la disponibilidad del empleado."
	#define STR0020 "Si empleado consta con Disponibil. = Si, no debe informarse la Fc.Fin Disp."
	#define STR0021 "Datos del Empleado"
	#define STR0022 "Datos de la especialidad del empleado"
	#define STR0023 "Datos del Empleado"
	#define STR0024 "Datos de las especialidades del empleado"
#else
	#ifdef ENGLISH
		#define STR0001 "Quit"
		#define STR0002 "Confirm"
		#define STR0003 "Retype"
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Assets"
		#define STR0010 "Employee File"
		#define STR0011 "COST CENTER LABOR FORCE"
		#define STR0012 "Employee not qualified in payroll "
		#define STR0013 "Status: "
		#define STR0014 "NON-CONFORMANCE "
		#define STR0015 "Continue "
		#define STR0016 "Employee not registered as Maintenance employee."
		#define STR0017 "In order for the product to be correctly registered in the table of Balances in stock (SB2) and/or Products (SB1), the field cost center "
		#define STR0018 "maximum of 12 characters"
		#define STR0019 "You must enter the emplyee availability end date."
		#define STR0020 "If employee Availability = Yes, Avail. End Date must not be entered."
		#define STR0021 "Employee Data"
		#define STR0022 "Data of employee specialty"
		#define STR0023 "Employee Data"
		#define STR0024 "Data of employee specialty"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0002 "Confirma"
		#define STR0003 "Redigita"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 "Bens"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Registo De Funcion�rios", "Cadastro de Funcionarios" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "M�o de obra do centro de custo ", "MAO DE OBRA DO CENTRO DE CUSTO " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Empregado n�o autorizado junto � folha", "Funcionario nao habilitado junto a folha" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Situa��o:", "Situacao:" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "N�o Conformidade", "NAO CONFORMIDADE" )
		#define STR0015 "Continuar"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Empregado n�o est� registado como empregado da Manuten��o.", "Funcion�rio n�o est� cadastrado como funcion�rio da Manuten��o." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Para que o artigo seja registado correctamente na tabela de Saldos em Stock(SB2) e/ou Artigos(SB1), o campo centro custo ", "Para que o produto seja cadastrado corretamente na tabela de Saldos em Estoque(SB2) e/ou Produtos(SB1), o campo centro custo " )
		#define STR0018 "deve possuir no m�ximo 12 caracteres."
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Dever� ser informada a data fim da disponibilidade do empregado.", "Dever� ser informado a data fim da disponibilidade do funcion�rio." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Se o empregado consta com Disponibil. = Sim, n�o deve ser informada a Dt.Fim Disp.", "Se funcion�rio consta com Disponibil. = Sim, n�o deve ser informada a Dt.Fim Disp." )
		#define STR0021 "Dados do Funcion�rio"
		#define STR0022 "Dados da especialidade do funcion�rio"
		#define STR0023 "Dados do Funcion�rio"
		#define STR0024 "Dados das especialidades do funcion�rio"
	#endif
#endif
