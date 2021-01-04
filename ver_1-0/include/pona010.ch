#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo de Marcaciones"
	#define STR0007 "Ya existen Marcaciones registrados para este empleado. Seleccione la opcion Modificacion"
	#define STR0008 "Leyenda"
	#define STR0009 "No fue posible crear el Calendario de Marcaciones para el periodo informado"
	#define STR0010 "Aviso de Inconsistencia"
	#define STR0011 "El Orden informado es invalido para o periodo"
	#define STR0012 "El periodo informado es invalido"
	#define STR0013 "Ordenar Marcaciones <F5>"
	#define STR0014 "Ordenando Marcaciones..."
	#define STR0015 "Calendario de Marcaciones <F6>..."
	#define STR0016 "Creando el Calendario..."
	#define STR0017 "Elaborando el Calendario..."
	#define STR0018 "Limpiar Ordenes <F7>..."
	#define STR0019 "Limpiando Ordenes..."
	#define STR0020 "Periodo:"
	#define STR0021 "Inicial:"
	#define STR0022 "Final:"
	#define STR0023 "Si"
	#define STR0024 "No"
	#define STR0025 "�Limpiar Ordenes de Items Informados/Modificados?"
	#define STR0026 "�Considerar el Periodo de Apunte o la Fecha?"
	#define STR0027 "Periodo"
	#define STR0028 "Fecha"
	#define STR0029 "Ordenar Marcacion <F4>..."
	#define STR0030 "Ordenando Marcacion..."
	#define STR0031 "Indexar Registros <F8>..."
	#define STR0032 "Indexando Registros..."
	#define STR0033 "Indexacion:"
	#define STR0034 "Indexar los Registros de Marcaciones en orden:"
	#define STR0035 "Ascendiente"
	#define STR0036 "Descendiente"
	#define STR0037 "Borrar, ademas de los apuntes calculados por el sistema, �los apuntes informados por el usuario?"
	#define STR0038 "Grabando Marcaciones..."
	#define STR0039 "Borrando Marcaciones..."
	#define STR0040 "Borrando Apuntes..."
	#define STR0041 ""
	#define STR0042 "Filtrar Registros <F9>..."
	#define STR0043 "Filtro Registros de Marcaciones:"
	#define STR0044 "No ordenadas"
	#define STR0045 "Ordenadas e impares"
	#define STR0046 "Duplicadas"
	#define STR0047 "Considerar el periodo:"
	#define STR0048 "Despues de seleccionar pulse la tecla <TAB> para habilitar la digitacion del periodo"
	#define STR0049 "No existen informaciones a disposicion"
	#define STR0050 "�Desea seleccionar periodo?"
	#define STR0113 "Ordenar"
	#define STR0115 "Calend."
	#define STR0118 "Limpiar"
	#define STR0131 "Indexar"
	#define STR0142 "Filtrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Time Record File"
		#define STR0007 "There are already time records registered for this employee. Select the option Editing"
		#define STR0008 "Caption"
		#define STR0009 "No Time Record calendar was possible to be created for the informed period"
		#define STR0010 "Inconsistency Warning"
		#define STR0011 "The Informed Order is not valid for the period"
		#define STR0012 "Period informed is invalid"
		#define STR0013 "Order Time Records <F5>..."
		#define STR0014 "Ordering Time Records."
		#define STR0015 "Time Record Calendar <F6>..."
		#define STR0016 "Creating Calendar..."
		#define STR0017 "Structuring a Calendar.."
		#define STR0018 "Clear Orders <F7>..."
		#define STR0019 "Cleaning the Orders.."
		#define STR0020 "Period:"
		#define STR0021 "Initial:"
		#define STR0022 "Final:"
		#define STR0023 "Yes"
		#define STR0024 "No"
		#define STR0025 "Clean Informed/Changed Items Orders"
		#define STR0026 "Consider the Date or Period Registered"
		#define STR0027 "Periodo"
		#define STR0028 "Date"
		#define STR0029 "Order Time Record <F4>..."
		#define STR0030 "Ordering Time Records"
		#define STR0031 "Index Entries <F8>..."
		#define STR0032 "Indexing Entries..."
		#define STR0033 "Indexing:"
		#define STR0034 "Index the Time Records Entries in order:"
		#define STR0035 "Increasing"
		#define STR0036 "Descreasing"
		#define STR0037 "Delete the records informed by the user besides the ones calculated by the system"
		#define STR0038 "Recording Time Records"
		#define STR0039 "Deleting Time Records."
		#define STR0040 "Deleting Registrations..."
		#define STR0041 ""
		#define STR0042 "Filter Entries <F9>..."
		#define STR0043 "Filter Time Records Entries:"
		#define STR0044 "Not ordered"
		#define STR0045 "Orded and Odd numbers"
		#define STR0046 "Trade Notes"
		#define STR0047 "Consider period:"
		#define STR0048 "After selecting press the key <TAB> to enable the period typing"
		#define STR0049 "There is no information to be made available"
		#define STR0050 "Do you require to select the period"
		#define STR0113 "Order"
		#define STR0115 "Calendar"
		#define STR0118 "Clean"
		#define STR0131 "Index"
		#define STR0142 "Filter"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Marca��es", "Cadastro de Marca��es" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "J� Existem Marca��es cadastradas para este empregado. Selecione a op��o de Altera��o", "J� Existem Marca��es cadastradas para este funcion�rio. Selecione a op��o de Altera��o" )
		#define STR0008 "Legenda"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel criar o calend�rio de Marca��es para o per�odo informado", "N�o foi poss�vel criar o calend�rio de Marca��es para o per�odo informado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Aviso De Inconsist�ncia", "Aviso de Inconsist�ncia" )
		#define STR0011 "A Ordem informada n�o � v�lida para o per�odo"
		#define STR0012 "O per�odo informado n�o � v�lido"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Ordenar marca��es <f5>...", "Ordenar Marca��es <F5>" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A Ordenar Marca��es...", "Ordenando Marca��es..." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Calend�rio de marca��es <f6>...", "Calend�rio de Marca��es <F6>" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A Criar O Calend�rio...", "Criando o Calend�rio..." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "A Construir O Calend�rio...", "Montando o Calend�rio..." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Limpar as ordens <f7>...", "Limpar as Ordens <F7>" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "A Limpar As Ordens...", "Limpando as Ordens..." )
		#define STR0020 "Per�odo:"
		#define STR0021 "Inicial:"
		#define STR0022 "Final:"
		#define STR0023 "Sim"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "N�o", "N�o" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Limpar Ordens De Itens Introduzidos/modificados?", "Limpar Ordens de Itens Informados/Modificados?" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Considerar O Per�odo De Registo Ou A Data?", "Considerar o Periodo de Apontamento ou a Data?" )
		#define STR0027 "Per�odo"
		#define STR0028 "Data"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Ordenar Marca��o <F4>...", "Ordenar Marca��o Atual <F4>" )
		#define STR0030 "Ordenando Marca��o..."
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Indexar movimentos <f8>...", "Indexar Lan�amentos <F8>" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "A Indexar Movimentos...", "Indexando Lan�amentos..." )
		#define STR0033 "Indexa��o:"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Indexar os movimentos de marca��es em ordem:", "Indexar os Lan�amentos de Marca��es em ordem:" )
		#define STR0035 "Ascendente"
		#define STR0036 "Descendente"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Excluir, al�m dos registos calculados pelo sistema, os registos introduzidos pelo utilizador?", "Excluir, al�m dos apontamentos calculados pelo sistema, os apontamentos informados pelo usu�rio?" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "A Gravar Marca��es...", "Gravando Marca��es..." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "A Eliminar Marca��es...", "Excluindo Marca��es..." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "A Eliminar Registos...", "Excluindo Apontamentos..." )
		#define STR0041 ""
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Filtrar movimentos <f9>...", "Filtrar Lan�amentos <F9>" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Filtro Movimentos De Marca��es:", "Filtro Lan�amentos de Marca��es:" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "N�o ordenadas", "N�o ordenadas" )
		#define STR0045 "Ordenadas e �mpares"
		#define STR0046 "Duplicadas"
		#define STR0047 "Considerar o per�odo:"
		#define STR0048 "Ap�s selecionar pressione a tecla <TAB> para habilitar a digita��o do per�odo"
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "N�o existem informa��es a serem disponibilizadas", "N�o existem informa��es a serem disponibilizadas" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Deseja seleccionar per�odo?", "Deseja selecionar per�odo?" )
		#define STR0113 "Ordenar"
		#define STR0115 "Calend."
		#define STR0118 "Limpar"
		#define STR0131 "Indexar"
		#define STR0142 "Filtrar"
	#endif
#endif
