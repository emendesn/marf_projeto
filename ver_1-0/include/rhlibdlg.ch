#ifdef SPANISH
	#define STR0001 "Atencion"
	#define STR0002 "Los campos RQ_BCDEPBE (Banco/Agencia) y RQ_CTDEPBE (Cuenta) no se encontraron en el archivo de beneficiarios (SRQ)."
	#define STR0003 "La impresion del informe de los beneficiarios esta condicionada a la existencia de estos campos."
	#define STR0004 "Ok"
	#define STR0005 "Normal"
	#define STR0006 "Con licencia"
	#define STR0007 "Despedido"
	#define STR0008 "Transferido"
	#define STR0009 "Vacaciones"
	#define STR0010 "Situacion"
	#define STR0011 If( cPaisLoc == "ARG", "Trab p/mes", If( cPaisLoc == "AUS", "Trab p/mes", If( cPaisLoc == "BOL", "Trab p/mes", If( cPaisLoc == "BRA", "Trab p/mes", If( cPaisLoc == "CHI", "Mensalista", If( cPaisLoc == "COL", "Mensalista", If( cPaisLoc == "COS", "Mensalista", If( cPaisLoc == "DOM", "Mensalista", If( cPaisLoc == "EQU", "Mensalista", If( cPaisLoc == "EUA", "Mensalista", If( cPaisLoc == "HAI", "Mensalista", If( cPaisLoc == "MEX", "Mensalista", If( cPaisLoc == "PAD", "Mensalista", If( cPaisLoc == "PAN", "Mensalista", If( cPaisLoc == "PAR", "Mensalista", If( cPaisLoc == "PER", "Mensalista", If( cPaisLoc == "POR", "Mensalista", If( cPaisLoc == "PTG", "Mensal", If( cPaisLoc == "SAL", "Mensalista", If( cPaisLoc == "TRI", "Mensalista", If( cPaisLoc == "URU", "Mensalista", If( cPaisLoc == "VEN", "Mensalista", "Mensual" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
	#define STR0012 If( cPaisLoc == "ARG", "Trab p/hora", If( cPaisLoc == "AUS", "Trab p/hora", If( cPaisLoc == "BOL", "Trab p/hora", If( cPaisLoc == "BRA", "Trab p/hora", If( cPaisLoc == "CHI", "Horista", If( cPaisLoc == "COL", "Horista", If( cPaisLoc == "COS", "Horista", If( cPaisLoc == "DOM", "Horista", If( cPaisLoc == "EQU", "Horista", If( cPaisLoc == "EUA", "Horista", If( cPaisLoc == "HAI", "Horista", If( cPaisLoc == "MEX", "Horista", If( cPaisLoc == "PAD", "Horista", If( cPaisLoc == "PAN", "Horista", If( cPaisLoc == "PAR", "Horista", If( cPaisLoc == "PER", "Horista", If( cPaisLoc == "POR", "Horista", If( cPaisLoc == "PTG", "� hora", If( cPaisLoc == "SAL", "Horista", If( cPaisLoc == "TRI", "Horista", If( cPaisLoc == "URU", "Horista", If( cPaisLoc == "VEN", "Horista", "a la hora" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
	#define STR0013 If( cPaisLoc == "ANG", "Semanal", If( cPaisLoc == "CHI", "Semanalista", If( cPaisLoc == "COL", "Semanalista", If( cPaisLoc == "COS", "Semanalista", If( cPaisLoc == "DOM", "Semanalista", If( cPaisLoc == "EQU", "Semanalista", If( cPaisLoc == "EUA", "Semanalista", If( cPaisLoc == "HAI", "Semanalista", If( cPaisLoc == "MEX", "Semanalista", If( cPaisLoc == "PAD", "Semanalista", If( cPaisLoc == "PAN", "Semanalista", If( cPaisLoc == "PAR", "Semanalista", If( cPaisLoc == "PER", "Semanalista", If( cPaisLoc == "POR", "Semanalista", If( cPaisLoc == "PTG", "Semanal", If( cPaisLoc == "SAL", "Semanalista", If( cPaisLoc == "TRI", "Semanalista", If( cPaisLoc == "URU", "Semanalista", If( cPaisLoc == "VEN", "Semanalista", "Trab p/semana" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
	#define STR0014 "Tarea. Sem."
	#define STR0015 If( cPaisLoc == "ANG", "Miliciano", If( cPaisLoc == "CHI", "Comissionado", If( cPaisLoc == "COL", "Comissionado", If( cPaisLoc == "COS", "Comissionado", If( cPaisLoc == "DOM", "Comissionado", If( cPaisLoc == "EQU", "Comissionado", If( cPaisLoc == "EUA", "Comissionado", If( cPaisLoc == "HAI", "Comissionado", If( cPaisLoc == "MEX", "Comissionado", If( cPaisLoc == "PAD", "Comissionado", If( cPaisLoc == "PAN", "Comissionado", If( cPaisLoc == "PAR", "Comissionado", If( cPaisLoc == "PER", "Comissionado", If( cPaisLoc == "POR", "Comissionado", If( cPaisLoc == "PTG", "Miliciano", If( cPaisLoc == "SAL", "Comissionado", If( cPaisLoc == "TRI", "Comissionado", If( cPaisLoc == "URU", "Comissionado", If( cPaisLoc == "VEN", "Comissionado", "Comisionado" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
	#define STR0016 If( cPaisLoc == "ANG", "Diario", If( cPaisLoc == "CHI", "Diarista", If( cPaisLoc == "COL", "Diarista", If( cPaisLoc == "COS", "Diarista", If( cPaisLoc == "DOM", "Diarista", If( cPaisLoc == "EQU", "Diarista", If( cPaisLoc == "EUA", "Diarista", If( cPaisLoc == "HAI", "Diarista", If( cPaisLoc == "MEX", "Diarista", If( cPaisLoc == "PAD", "Diarista", If( cPaisLoc == "PAN", "Diarista", If( cPaisLoc == "PAR", "Diarista", If( cPaisLoc == "PER", "Diarista", If( cPaisLoc == "POR", "Diarista", If( cPaisLoc == "PTG", "Di�rio", If( cPaisLoc == "SAL", "Diarista", If( cPaisLoc == "TRI", "Diarista", If( cPaisLoc == "URU", "Diarista", If( cPaisLoc == "VEN", "Diarista", "Jornalero" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
	#define STR0017 "Tarea Mens."
	#define STR0018 "Categoria"
	#define STR0019 "�Confirma configuracion de los parametros?"
	#define STR0020 "Atencion"
	#define STR0021 "Seleccione el archivo"
	#define STR0022 "Bases de datos"
	#define STR0023 "Buscar:"
	#define STR0024 "Archivo no encontrado"
	#define STR0025 "Acumuladores auxiliares"
#else
	#ifdef ENGLISH
		#define STR0001 "Attention"
		#define STR0002 "The fields RQ_BCDEPBE (Bank/Bank Branch) and RQ_CTDEPBE (Account) not found in beneficiary register (SRQ)."
		#define STR0003 "Printing of beneficiary report is conditioned to these fields existence."
		#define STR0004 "OK"
		#define STR0005 "Regular"
		#define STR0006 "Leave"
		#define STR0007 "Dismissed"
		#define STR0008 "Transferred"
		#define STR0009 "Vacation"
		#define STR0010 "Status"
		#define STR0011 If( cPaisLoc == "ARG", "Monthly paid worker", If( cPaisLoc == "AUS", "Monthly paid worker", If( cPaisLoc == "BOL", "Monthly paid worker", If( cPaisLoc == "BRA", "Monthly paid worker", If( cPaisLoc == "CHI", "Monthly paid worker", If( cPaisLoc == "COL", "Monthly paid worker", If( cPaisLoc == "COS", "Monthly paid worker", If( cPaisLoc == "DOM", "Monthly paid worker", If( cPaisLoc == "EQU", "Monthly paid worker", If( cPaisLoc == "EUA", "Monthly paid worker", If( cPaisLoc == "HAI", "Monthly paid worker", If( cPaisLoc == "MEX", "Monthly paid worker", If( cPaisLoc == "PAD", "Monthly paid worker", If( cPaisLoc == "PAN", "Monthly paid worker", If( cPaisLoc == "PAR", "Monthly paid worker", If( cPaisLoc == "PER", "Monthly paid worker", If( cPaisLoc == "POR", "Monthly paid worker", If( cPaisLoc == "SAL", "Monthly paid worker", If( cPaisLoc == "TRI", "Monthly paid worker", If( cPaisLoc == "URU", "Monthly paid worker", If( cPaisLoc == "VEN", "Monthly paid worker", "Monthly" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
		#define STR0012 If( cPaisLoc == "ARG", "Hourly paid worker", If( cPaisLoc == "AUS", "Hourly paid worker", If( cPaisLoc == "BOL", "Hourly paid worker", If( cPaisLoc == "BRA", "Hourly paid worker", If( cPaisLoc == "CHI", "Hourly paid worker", If( cPaisLoc == "COL", "Hourly paid worker", If( cPaisLoc == "COS", "Hourly paid worker", If( cPaisLoc == "DOM", "Hourly paid worker", If( cPaisLoc == "EQU", "Hourly paid worker", If( cPaisLoc == "EUA", "Hourly paid worker", If( cPaisLoc == "HAI", "Hourly paid worker", If( cPaisLoc == "MEX", "Hourly paid worker", If( cPaisLoc == "PAD", "Hourly paid worker", If( cPaisLoc == "PAN", "Hourly paid worker", If( cPaisLoc == "PAR", "Hourly paid worker", If( cPaisLoc == "PER", "Hourly paid worker", If( cPaisLoc == "POR", "Hourly paid worker", If( cPaisLoc == "SAL", "Hourly paid worker", If( cPaisLoc == "TRI", "Hourly paid worker", If( cPaisLoc == "URU", "Hourly paid worker", If( cPaisLoc == "VEN", "Hourly paid worker", "at time" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
		#define STR0013 If( cPaisLoc == "ANG", "Weekly", If( cPaisLoc == "PTG", "Weekly", "Weekly Paid Worker" ) )
		#define STR0014 "Week Task"
		#define STR0015 If( cPaisLoc == "ANG", "Militia", If( cPaisLoc == "PTG", "Militia", "Commissioned" ) )
		#define STR0016 If( cPaisLoc == "ANG", "Daily", If( cPaisLoc == "PTG", "Daily", "Daily paid worker" ) )
		#define STR0017 "Month Task"
		#define STR0018 "Category"
		#define STR0019 "Confirm configuration of the parameters?"
		#define STR0020 "Attention"
		#define STR0021 "Select the File"
		#define STR0022 "Database"
		#define STR0023 "Search:"
		#define STR0024 "File not found"
		#define STR0025 "Auxiliary Accumulators"
	#else
		#define STR0001 "Aten��o"
		#define STR0002 "Os campos RQ_BCDEPBE (Banco/Agencia) e RQ_CTDEPBE (Conta) nao foram encontrados no cadastro de beneficiarios (SRQ)."
		#define STR0003 "A impressao do relatorio dos beneficiarios esta condicionada a existencia destes campos."
		#define STR0004 "Ok"
		#define STR0005 "Normal"
		#define STR0006 "Afastado"
		#define STR0007 "Demitido"
		#define STR0008 "Transferido"
		#define STR0009 "F�rias"
		#define STR0010 "Situa��o"
		#define STR0011 If( cPaisLoc $ "ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|SAL|TRI|URU|VEN", "Mensalista", "Mensal" )
		#define STR0012 If( cPaisLoc $ "ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|SAL|TRI|URU|VEN", "Horista", "� hora" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Semanal", "Semanalista" )
		#define STR0014 "Taref. sem."
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Miliciano", "Comissionado" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Di�rio", "Diarista" )
		#define STR0017 "Taref.Mens."
		#define STR0018 "Categoria"
		#define STR0019 "Confirma configura��o dos par�metros?"
		#define STR0020 "Aten��o"
		#define STR0021 "Selecione o Arquivo"
		#define STR0022 "Bases de Dados"
		#define STR0023 "Pesquisar:"
		#define STR0024 "Arquivo n�o encontrado"
		#define STR0025 "Acumuladores Auxiliares"
	#endif
#endif
