#ifdef SPANISH
	#define STR0001 "Autorizar uso de Gastos"
	#define STR0002 "Autorizar por "
	#define STR0003 "Cargo"
	#define STR0004 "o"
	#define STR0005 "Empleado"
	#define STR0006 "Codigo"
	#define STR0007 "Gasto"
	#define STR0008 "Autorizacion para uso de gastos"
	#define STR0009 "Colaborador:"
	#define STR0010 "Estandarizar"
	#define STR0011 "Estandariza la autorizacion de uso de los gastos de acuerdo con el cargo del empleado."
	#define STR0012 "Cargo......:"
	#define STR0013 "Marcar Todos"
	#define STR0014 "Desmarcar Todos"
	#define STR0015 "Para configurar las autorizaciones para el uso de gastos, es necesario tener como minimo un gasto y un cargo/empleado registrados"
	#define STR0016 "¿Confirma grabacion de los datos actuales?"
	#define STR0017 "Permisos grabados con exito."
	#define STR0018 "El cargo del colaborador en el archivo de usuarios de viajes esta en blanco y el colaborador no tiene permisos para uso de gastos."
	#define STR0019 "¿Confirma la estandarizacion de las autorizaciones de uso por el cargo del colaborador?"
	#define STR0020 "El cargo del colaborador en el archivo de usuarios de viajes esta en blanco. Por favor, actualice el archivo del colaborador para poder configurar las autorizaciones de uso de gastos."
	#define STR0021 "Las configuraciones de autorizacion de uso por el cargo del colaborador se efectuaron con exito."
	#define STR0022 "No fue posible encontrar al colaborador en el archivo de usuarios de viajes."
#else
	#ifdef ENGLISH
		#define STR0001 "Authorize use of expenses"
		#define STR0002 "Authorize per "
		#define STR0003 "Position"
		#define STR0004 "or"
		#define STR0005 "Employee"
		#define STR0006 "Code"
		#define STR0007 "Expenses"
		#define STR0008 "Authorization for use of expenses"
		#define STR0009 "Employee:"
		#define STR0010 "Standardize"
		#define STR0011 "Standardize with authorization of expenses use, according to employee's function."
		#define STR0012 "Position......:"
		#define STR0013 "Check All "
		#define STR0014 "Uncheck All - "
		#define STR0015 "To configure authorizations for the use of expenses, it is necessary to have registered, at least, one expense and one position/employee "
		#define STR0016 "Confirm saving of current data?"
		#define STR0017 "Permissions saved successfully. "
		#define STR0018 "Employee function in trips users file is in blank and employee does not have permissions for use of expenses."
		#define STR0019 "Confirm use standardizing by employee position?"
		#define STR0020 "Employee position in trips users file is in blank. Please, update employee file in order to configure expenses use authorizations."
		#define STR0021 "Configurations of use authorizations by employee position were performed successfully. "
		#define STR0022 "It was not possible to find employee in trips users file. "
	#else
		Static STR0001 := "Autorizar uso de Despesas"
		#define STR0002  "Autorizar por "
		#define STR0003  "Cargo"
		#define STR0004  "ou"
		Static STR0005 := "Funcionario"
		#define STR0006  "Código"
		#define STR0007  "Despesa"
		#define STR0008  "Autorização para uso de despesas"
		#define STR0009  "Colaborador:"
		#define STR0010  "Padronizar"
		#define STR0011  "Padroniza a autorização de uso das despesas de acordo com o cargo do funcionário."
		#define STR0012  "Cargo......:"
		#define STR0013  "Marcar Todos"
		#define STR0014  "Desmarcar Todos"
		Static STR0015 := "Para configurar as autorizações para o uso de despesas, é necessário ter no minimo uma despesa e um cargo/funcionário cadastrados"
		Static STR0016 := "Confirma gravação dos dados atuais?"
		Static STR0017 := "Permissões gravadas com sucesso."
		Static STR0018 := "O cargo do colaborador no cadastro de usuários de viagens está em branco e o colaborador não possui permissões para uso de despesas."
		#define STR0019  "Confirma a padronização das autorizações de uso pelo cargo do colaborador?"
		Static STR0020 := "O cargo do colaborador no cadastro de usuários de viagens está em branco. Por favor, atualize o cadastro do colaborador para poder configurar as autorizações de uso de despesas."
		Static STR0021 := "As configurações de autorização de uso pelo cargo do colaborador foram efetuadas com sucesso."
		#define STR0022  "Não foi possível encontrar o colaborador no cadastro de usuários de viagens."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Autorizar uso de despesas"
			STR0005 := "Funcionário"
			STR0015 := "Para configurar as autorizações para o uso de despesas, é necessário ter, no mínimo, uma despesa e um cargo/funcionário cadastrados"
			STR0016 := "Confirma gravação dos dados actuais?"
			STR0017 := "Permissões gravadas com successo."
			STR0018 := "O cargo do colaborador no registo de usuários de viagens está em branco e o colaborador não possui permissões para uso de despesas."
			STR0020 := "O cargo do colaborador no registo de usuários de viagens está em branco. Por favor, actualize o registo do colaborador para poder configurar as autorizações de uso de despesas."
			STR0021 := "As configurações de autorização de uso pelo cargo do colaborador foram efetuadas com successo."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Autorizar uso de despesas"
			STR0005 := "Funcionário"
			STR0015 := "Para configurar as autorizações para o uso de despesas, é necessário ter, no mínimo, uma despesa e um cargo/funcionário cadastrados"
			STR0016 := "Confirma gravação dos dados actuais?"
			STR0017 := "Permissões gravadas com successo."
			STR0018 := "O cargo do colaborador no registo de usuários de viagens está em branco e o colaborador não possui permissões para uso de despesas."
			STR0020 := "O cargo do colaborador no registo de usuários de viagens está em branco. Por favor, actualize o registo do colaborador para poder configurar as autorizações de uso de despesas."
			STR0021 := "As configurações de autorização de uso pelo cargo do colaborador foram efetuadas com successo."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
