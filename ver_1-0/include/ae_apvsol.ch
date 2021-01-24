#ifdef SPANISH
	#define STR0001 "Busqueda"
	#define STR0002 "Visualiza"
	#define STR0003 "Imprimir"
	#define STR0004 "Aprobador  1"
	#define STR0005 "Aprobador  2"
	#define STR0006 "Anular"
	#define STR0007 "Parâmetros"
	#define STR0008 "Leyenda"
	#define STR0009 "Departamento de viaje"
	#define STR0010 "Usuario no registrado como Colaborador/Aprobador"
	#define STR0011 "Seleccionando Viajes ..."
	#define STR0012 "¿Filtra Emitidas ?"
	#define STR0013 "Para Aprobacion"
	#define STR0014 "Esperando Ap."
	#define STR0015 "Aprobadas"
	#define STR0016 "Encaminadas"
	#define STR0017 "Sin Filtro"
	#define STR0018 "¿De Emision         ?"
	#define STR0019 "¿A Emision        ?"
	#define STR0020 "¿De Partida         ?"
	#define STR0021 "¿A Partida        ?"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Print"
		#define STR0004 "Approver 1"
		#define STR0005 "Approver 2"
		#define STR0006 "Cancel"
		#define STR0007 "Parameters"
		#define STR0008 "Caption"
		#define STR0009 "Trip Complement "
		#define STR0010 "User is not registered as Employee/Approver"
		#define STR0011 "Selecting trips..."
		#define STR0012 "Filter already Issued?"
		#define STR0013 "For Approval"
		#define STR0014 "Waiting App."
		#define STR0015 "Approved"
		#define STR0016 "Forwarded"
		#define STR0017 "Without Filter"
		#define STR0018 "From Issue ?"
		#define STR0019 "To Issue  ?"
		#define STR0020 "From Output  ?"
		#define STR0021 "To Output       ?"
	#else
		#define STR0001  "Pesquisa"
		#define STR0002  "Visualiza"
		#define STR0003  "Imprimir"
		#define STR0004  "Aprovador  1"
		#define STR0005  "Aprovador  2"
		#define STR0006  "Cancelar"
		Static STR0007 := "Parametros"
		#define STR0008  "Legenda"
		#define STR0009  "Departamento de Viagem"
		#define STR0010  "Usuário não cadastrado como Colaborador/Aprovador"
		Static STR0011 := "Selecionando Viagens ..."
		Static STR0012 := "Filtra já Emitidas ?"
		#define STR0013  "Para Aprovação"
		Static STR0014 := "Aguardando Ap."
		#define STR0015  "Aprovadas"
		#define STR0016  "Encaminhadas"
		#define STR0017  "Sem Filtro"
		#define STR0018  "Da Emissão         ?"
		Static STR0019 := "Ate Emissão        ?"
		#define STR0020  "Da Partida         ?"
		Static STR0021 := "Ate Partida        ?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0007 := "Parâmetros"
			STR0011 := "A seleccionar Viagens ..."
			STR0012 := "Filtra já emitidas ?"
			STR0014 := "A aguardar Ap."
			STR0019 := "Até Emissão        ?"
			STR0021 := "Até Partida        ?"
		ElseIf cPaisLoc == "PTG"
			STR0007 := "Parâmetros"
			STR0011 := "A seleccionar Viagens ..."
			STR0012 := "Filtra já emitidas ?"
			STR0014 := "A aguardar Ap."
			STR0019 := "Até Emissão        ?"
			STR0021 := "Até Partida        ?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
