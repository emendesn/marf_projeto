#ifdef SPANISH
	#define STR0001 "Informe de la Agenda de Reuniones "
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 "Agenda de reuniones"
	#define STR0005 "Mandato    Nombre Mandato"
	#define STR0006 "  Fcha Prev.  Fcha Real   Hora    Tipo"
	#define STR0007 "ANULADO POR EL OPERADOR"
	#define STR0008 "Ordinaria"
	#define STR0009 "Extraordinaria"
	#define STR0010 "Asunto.:"
	#define STR0011 "Participantes....:"
	#define STR0012 "Acta de reunion"
	#define STR0013 "Fecha prev."
	#define STR0014 "Hora prev."
	#define STR0015 "Fecha real"
	#define STR0016 "Hora real"
	#define STR0017 "Tipo"
	#define STR0018 "Firma.:______________________"
	#define STR0019 "Participantes"
	#define STR0020 "Reunion de CIPA"
	#define STR0021 "Agenda de Reunion."
	#define STR0022 "Mandato CIPA:"
	#define STR0023 "Fch. de Reunion:"
	#define STR0024 "Horario:"
	#define STR0025 "Reunion:"
	#define STR0026 "Ordinaria"
	#define STR0027 "Extraordinaria"
	#define STR0028 "Asunto:"
	#define STR0029 "Acta de Reun."
	#define STR0030 "Fir.:_____________________________________"
	#define STR0031 "Cliente/Tda.: "
	#define STR0032 "�De Cliente?"
	#define STR0033 "Tda."
	#define STR0034 "�A Cliente ?"
	#define STR0035 "No existe nada para imprimir en el informe."
	#define STR0036 "�Modelo de informes?"
	#define STR0037 "�Acta de reunion?"
	#define STR0038 "�A Fecha?"
	#define STR0039 "�De Fecha?"
	#define STR0040 "�A Mandato?"
	#define STR0041 "�De Mandato ?"
	#define STR0042 "Seleccionando Registros ..."
	#define STR0043 "�Listar Ausentes ?"
	#define STR0044 "�Ausencia Justificada ?"
	#define STR0045 "Define si se debe imprimir las ausencias de las reuniones."
	#define STR0046 "Define si se debe imprimir la situacion de la ausencia, donde es Justificada o No Justificada"
	#define STR0047 "Falta Justificada"
	#define STR0048 "Falta No Justificada"
	#define STR0049 "No Comparecio"
	#define STR0050 "Externo"
#else
	#ifdef ENGLISH
		#define STR0001 "Meeting Agenda Report"
		#define STR0002 "Z. Form"
		#define STR0003 "Management"
		#define STR0004 "Meetings Agenda"
		#define STR0005 "Mandate    Mandate Name"
		#define STR0006 "  Prev.Date   Actual Dt   Time    Type"
		#define STR0007 "CANCELED BY OPERATOR"
		#define STR0008 "Ordinary"
		#define STR0009 "Extraordinary"
		#define STR0010 "Subject.:"
		#define STR0011 "Participants.....:"
		#define STR0012 "Minutes of Meeting"
		#define STR0013 "Est. Date "
		#define STR0014 "Est. time "
		#define STR0015 "Act. date"
		#define STR0016 "Act. time"
		#define STR0017 "Type"
		#define STR0018 "Signature: __________________"
		#define STR0019 "Participants "
		#define STR0020 "CIPA Meeting"
		#define STR0021 "Meetings Schedule"
		#define STR0022 "CIPA Mandate:"
		#define STR0023 "Meeting Date:"
		#define STR0024 "Time:"
		#define STR0025 "Meeting:"
		#define STR0026 "Ordinary"
		#define STR0027 "Extraordinary"
		#define STR0028 "Subject:"
		#define STR0029 "Meeting Minute"
		#define STR0030 "Sign.:_____________________________________"
		#define STR0031 "Customer/Unit: "
		#define STR0032 "From Customer ?"
		#define STR0033 "Unit"
		#define STR0034 "To Customer ?"
		#define STR0035 "No information to print in the report."
		#define STR0036 "Report Model?"
		#define STR0037 "Meeting Minute?"
		#define STR0038 "To Date?"
		#define STR0039 "From Date?"
		#define STR0040 "To Term of Office?"
		#define STR0041 "From Term of Office?"
		#define STR0042 "Selecting records ..."
		#define STR0043 "List Absences?"
		#define STR0044 "Justified Absence?"
		#define STR0045 "Defines whether absences from the meetings must be printed."
		#define STR0046 "Defines whether absence status must be printed, being either Justified or Not Justified"
		#define STR0047 "Justified Absence"
		#define STR0048 "Absence not Justified"
		#define STR0049 "Did not show up"
		#define STR0050 "External"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relat�rio da agenda de reuni�es ", "Relatorio da Agenda de Reunioes " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Agenda De Reuni�es", "Agenda de Reunioes" )
		#define STR0005 "Mandato    Nome Mandato"
		#define STR0006 "  Data Prev.  Data Real   Hora    Tipo"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Ordin�ria", "Ordinaria" )
		#define STR0009 "Extraordinaria"
		#define STR0010 "Assunto.:"
		#define STR0011 "Participantes....:"
		#define STR0012 "Ata da Reuni�o"
		#define STR0013 "Data Prev."
		#define STR0014 "Hora Prev."
		#define STR0015 "Data Real"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Hora Real.", "Hora Real" )
		#define STR0017 "Tipo"
		#define STR0018 "Ass.:________________________"
		#define STR0019 "Participantes"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Reuni�o Da Chsst", "Reuni�o da CIPA" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Agenda de reuni�es", "Agenda de Reuni�es" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Mandato Chsst:", "Mandato CIPA:" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Data Da Reuni�o:", "Data da Reuni�o:" )
		#define STR0024 "Hor�rio:"
		#define STR0025 "Reuni�o:"
		#define STR0026 "Ordin�ria"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Extraordinaria", "Extraordin�ria" )
		#define STR0028 "Assunto:"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Acta da reuni�o", "Ata da Reuni�o" )
		#define STR0030 "Ass.:_____________________________________"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Cliente/loja: ", "Cliente/Loja: " )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "De cliente ?", "De Cliente ?" )
		#define STR0033 "Loja"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "At� cliente ?", "At� Cliente ?" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "N�o existe informa��o para imprimir no relat�rio.", "N�o h� nada para imprimir no relat�rio." )
		#define STR0036 "Modelo de Relat�rio ?"
		#define STR0037 "Ata de Reuni�o ?"
		#define STR0038 "At� Data ?"
		#define STR0039 "De  Data ?"
		#define STR0040 "At� Mandato ?"
		#define STR0041 "De  Mandato ?"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos ...", "Selecionando Registros ..." )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Listar ausentes ?", "Listar Ausentes ?" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Aus�ncia justificada ?", "Aus�ncia Justificada ?" )
		#define STR0045 "Define se deve imprimir as aus�ncias das reuni�es."
		#define STR0046 "Define se deve imprimir a situa��o da aus�ncia, sendo ela Justificada ou N�o Justificada"
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Falta justificada", "Falta Justificada" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Falta n�o justificada", "Falta N�o Justificada" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "N�o compareceu", "N�o Compareceu" )
		#define STR0050 "Externo"
	#endif
#endif