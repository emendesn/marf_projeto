#ifdef SPANISH
	#define STR0001 "Enero"
	#define STR0002 "Febrero"
	#define STR0003 "Marzo"
	#define STR0004 "Abril"
	#define STR0005 "Mayo"
	#define STR0006 "Junio"
	#define STR0007 "Julio"
	#define STR0008 "Agosto"
	#define STR0009 "Septiembre"
	#define STR0010 "Octubre"
	#define STR0011 "Noviembre"
	#define STR0012 "Diciembre"
	#define STR0014 "CALENDARIO"
	#define STR0015 "Calendario - Feriados"
	#define STR0016 "Fecha: "
	#define STR0017 "Descripcion: "
	#define STR0018 "L"
	#define STR0019 "M"
	#define STR0020 "M"
	#define STR0021 "J"
	#define STR0022 "V"
	#define STR0023 "S"
	#define STR0024 "D"
	#define STR0025 "Tp.HE.Nor."
	#define STR0026 "Tp.HE.Noc."
	#define STR0027 "Si"
	#define STR0028 "No"
	#define STR0029 "Copia feriado <F4>..."
	#define STR0030 "Copia"
	#define STR0031 "Selecionando registros..."
	#define STR0032 "COPIAR de la sucursal corriente..."
	#define STR0033 "A las siguientes sucursales seleccionadas:"
	#define STR0034 "Datos del feriado:"
	#define STR0035 "El dia no es feriado"
	#define STR0036 "Help de Programa..."
	#define STR0037 "Anular - <Ctrl-X>"
	#define STR0038 "Anular"
	#define STR0039 "Help"
	#define STR0040 "Ok - <Ctrl-O>"
	#define STR0041 "Ok"
	#define STR0042 "Ninguna sucursal seleccionada"
	#define STR0043 "Marca todos...<F6>"
	#define STR0044 "Mc.Todos"
	#define STR0045 "Invierte...<F7>"
	#define STR0046 "Invierte"
	#define STR0047 "Borrar"
	#define STR0048 "�Desea agregar el feriado a las sucursales marcadas? Si selecciona 'No', se borraran las sucursales desmarcadas. Solamente se grabaran los registros marcados."
#else
	#ifdef ENGLISH
		#define STR0001 "January"
		#define STR0002 "February "
		#define STR0003 "March"
		#define STR0004 "April"
		#define STR0005 "May "
		#define STR0006 "June "
		#define STR0007 "July "
		#define STR0008 "August"
		#define STR0009 "September"
		#define STR0010 "October"
		#define STR0011 "November"
		#define STR0012 "December"
		#define STR0014 "CALENDAR  "
		#define STR0015 "Calendar - Vacations"
		#define STR0016 "Date: "
		#define STR0017 "Descript.: "
		#define STR0018 "M"
		#define STR0019 "T"
		#define STR0020 "W"
		#define STR0021 "T"
		#define STR0022 "F"
		#define STR0023 "S"
		#define STR0024 "S"
		#define STR0025 "Tp.HE.Nor."
		#define STR0026 "Tp.HE.Not."
		#define STR0027 "Yes"
		#define STR0028 "No"
		#define STR0029 "Copy holiday <F4>..."
		#define STR0030 "Copy"
		#define STR0031 "Selecting records ..."
		#define STR0032 "COPY from current branch ..."
		#define STR0033 "TO the branches selected below: "
		#define STR0034 "Holiday data:"
		#define STR0035 "The day is not a holiday"
		#define STR0036 "Program help ..."
		#define STR0037 "Cancel - <Ctrl-X>"
		#define STR0038 "Cancel "
		#define STR0039 "Help"
		#define STR0040 "OK - <Ctrl-O>"
		#define STR0041 "OK"
		#define STR0042 "No branch selected "
		#define STR0043 "Check all ...<F6>"
		#define STR0044 "Check all"
		#define STR0045 "Revert ...<F7>"
		#define STR0046 "Revert "
		#define STR0047 "Delete"
		#define STR0048 "Do you want to add the holiday to the selected branches? If you select No, the non-selected branches are deleted. All the selected records are saved."
	#else
		#define STR0001 "Janeiro"
		#define STR0002 "Fevereiro"
		#define STR0003 "Marco"
		#define STR0004 "Abril"
		#define STR0005 "Maio"
		#define STR0006 "Junho"
		#define STR0007 "Julho"
		#define STR0008 "Agosto"
		#define STR0009 "Setembro"
		#define STR0010 "Outubro"
		#define STR0011 "Novembro"
		#define STR0012 "Dezembro"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Calend�rio", "CALENDARIO" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Calend�rio - Feriados", "Calendario - Feriados" )
		#define STR0016 "Data: "
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Descri��o: ", "Descri��o: " )
		#define STR0018 "S"
		#define STR0019 "T"
		#define STR0020 "Q"
		#define STR0021 "Q"
		#define STR0022 "S"
		#define STR0023 "S"
		#define STR0024 "D"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Tp.he.nor.", "Tp.HE.Nor." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Tp.he.noct.", "Tp.HE.Not." )
		#define STR0027 "Sim"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "N�o", "N�o" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "C�pia feriado <f4>...", "Copia Feriado <F4>..." )
		#define STR0030 "Copia"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando Registros..." )
		#define STR0032 "COPIAR da filial corrente..."
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "PARA as filiais seleccionadas abaixo:", "PARA as filiais selecionadas abaixo:" )
		#define STR0034 "Dados do feriado:"
		#define STR0035 "O dia nao � feriado"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Ajuda Do Programa...", "Help de Programa..." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Cancelar - <ctrl-x>", "Cancelar - <Ctrl-X>" )
		#define STR0038 "Cancelar"
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Ajuda", "Help" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Ok - <ctrl-o>", "Ok - <Ctrl-O>" )
		#define STR0041 "Ok"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Nenhuma filial seleccionada", "Nenhuma filial selecionada" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Marca Todos...<f6>", "Marca Todos...<F6>" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Mc.todos", "Mc.Todos" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Inverte...<f7>", "Inverte...<F7>" )
		#define STR0046 "Inverte"
		#define STR0047 "Excluir"
		#define STR0048 "Deseja adicionar o feriado �s filiais marcadas? Caso selecione 'N�o', as filiais desmarcadas ser�o exclu�das. Somente os registros marcados ser�o gravados."
	#endif
#endif