#ifdef SPANISH
	#define STR0001 "Emitir el resumen de accidentes con victima "
	#define STR0002 "segun el Cuadro III de la NR4."
	#define STR0003 "A rayas"
	#define STR0004 "Administracion"
	#define STR0005 "Cuadro de accidentes con victima"
	#define STR0006 "ANULADO POR EL OPERADOR"
	#define STR0007 "|ACCIDENTES C/VICTIMA______________________________________________  PERIODO DE"
	#define STR0008 "|RESPONSABLE:________________________________________________                              FIRMA:____________________________________|"
	#define STR0009 "|                  Setor                  | Numero |Licencia|Licencia|  Sin   |  Indice  |  Dias/   |   Tasa   | Obitos |  Indice  |"
	#define STR0010 "|                                         |Absoluto|Menor o| Mayor  |Licencia| Relativo |  Hombre   |    de    |        | de Eval. |"
	#define STR0011 "|                                         |        |Igual a | Que "
	#define STR0012 "|                                         |        |   "
	#define STR0013 "Total del establecimiento"
	#define STR0014 "De Data ?"
	#define STR0015 "Ate Data?"
	#define STR0016 "No hay datos para mostrar"
	#define STR0017 "�De Cliente?"
	#define STR0018 "Tda."
	#define STR0019 "�A Cliente ?"
	#define STR0020 "Responsable"
	#define STR0021 "RESPONSABLE:"
	#define STR0022 "FIRMA:____________________________________|"
	#define STR0023 "Codigo del responsable. Esta pregunta puede permanecer vacia si opta por informar manualmente el nombre del responsable."
	#define STR0024 "Fecha del Mapa del Informe de Accidentes Con Victimas."
	#define STR0025 "DATOS DE LA EMPRESA"
	#define STR0026 "EMPRESA.: "
	#define STR0027 "CIUDAD..: "
	#define STR0028 "DIRECCION: "
	#define STR0029 "TELEFONO: "
	#define STR0030 "�Dias hab. en ano ?"
	#define STR0031 "�Jornada de trabajo?"
	#define STR0032 "�A Fecha?"
	#define STR0033 "Fch del Mapa"
	#define STR0034 "�De Sucursal?"
	#define STR0035 "�A Sucursal?"
	#define STR0036 "|                  Sector                 | Numero |Licencia|Licencia|  Sem   |  Indice  |  Dias/   |   Tasa   | Obitos |   Tasa   |"
	#define STR0037 "|                                         |Absoluto|Menor o | Mayor  |Licencia| Relativo |  Hombre  |    de    |        |    de    |"
	#define STR0038 "|                                         |        |Igual a | Que "
	#define STR0039 "|                                         |        |   "
	#define STR0040 "A"
	#define STR0041 "FECHA DEL MAPA: __/__/___   |"
	#define STR0042 "FECHA DEL MAPA:"
	#define STR0043 " |        | Total de | Perdidos | Frecuen. |        |Gravedad |"
	#define STR0044 "   |        |        | Emplea. |          |          |        |          |"
	#define STR0045 " |        | Total de | Perdidos | Frecuen. |        |    de    |"
	#define STR0046 "   |        |        | Emplea. |          |          |        | Embaraz. |"
#else
	#ifdef ENGLISH
		#define STR0001 "Issue the summary of accidents w/ victim"
		#define STR0002 "according to Chart III of NR4."
		#define STR0003 "Z. Form"
		#define STR0004 "Management"
		#define STR0005 "Chart of accidents with victim"
		#define STR0006 "CANCELLED BY THE OPERATOR"
		#define STR0007 "|ACCIDENTS W/VICTIM______________________________________________  PERIOD FROM"
		#define STR0008 "|RESPONSIBLE:________________________________________________                              SIGN.:____________________________________|"
		#define STR0009 "|                  Sector                 | Number |Leave    |Leave  | Without  |  Index |  Days/   |   Rate   | Deaths |  Index  |"
		#define STR0010 "|                                         |Absolute|Smaller or| Larger |Leave | Relative |  Man     |    of    |        | of Eval. |"
		#define STR0011 "|                                         |        |Equal to | Than "
		#define STR0012 "|                                         |        |   "
		#define STR0013 "Total of Establishment"
		#define STR0014 "Fr Date ?"
		#define STR0015 "To Date ?"
		#define STR0016 "No information to display"
		#define STR0017 "From Customer?"
		#define STR0018 "Unit"
		#define STR0019 "To Customer ?"
		#define STR0020 "Responsible"
		#define STR0021 "|RESPONSIBLE:"
		#define STR0022 "SIG:____________________________________|"
		#define STR0023 "Responsible code. This question can remain blank if responsible name is entered manually."
		#define STR0024 "Date of Map of report of Accidents with Victims."
		#define STR0025 "COMPANY DATE"
		#define STR0026 "COMPANY: "
		#define STR0027 "CITY: "
		#define STR0028 "ADDRESS: "
		#define STR0029 "PHONE: "
		#define STR0030 "Working days in year?"
		#define STR0031 "Working hours?"
		#define STR0032 "To Date?"
		#define STR0033 "Map Date"
		#define STR0034 "From Branch?"
		#define STR0035 "To Branch?"
		#define STR0036 "|                  Sector                 | Number |Leave   |Leave   | Without|  Index   |  Days/   |   Rate   | Deaths |   Rate   |"
		#define STR0037 "|                                         |Absolute |Less or | Greater|Leave   | Relative |   Man    |    of    |        |    of    |"
		#define STR0038 "|                                         |        |Equal to | Than "
		#define STR0039 "|                                         |        |   "
		#define STR0040 "TO"
		#define STR0041 "MAP DATE: __/__/___   |"
		#define STR0042 "MAP DATE:"
		#define STR0043 " |        | Total of | Lost | Frequency |        |Severity |"
		#define STR0044 "   |        |        | Hiring |          |          |        |          |"
		#define STR0045 " |        | Total of | Lost | Frequency |        |    of    |"
		#define STR0046 "   |        |        | Hiring |          |          |        | Pregnant |"
	#else
		#define STR0001 "Emitir o resumo de acidentes com vitima "
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Conforme O Quadro Iii Da Nr4.", "conforme o Quadro III da NR4." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Quadro De Acidentes Com Vitima", "Quadro de Acidentes com Vitima" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "|ACIDENTES C/V�TIMA______________________________________________  PER�ODO DE", "|ACIDENTES C/VITIMA______________________________________________  PERIODO DE" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "|RESPONS�VEL:________________________________________________                              ASS:____________________________________|", "|RESPONSAVEL:________________________________________________                              ASS:____________________________________|" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "|                  Setor                  | N�mero |Afastam.|Afastam.|  Sem   |  �ndice  |  Dias/   |   Taxa   | �bitos |  �ndice  |", "|                  Setor                  | Numero |Afastam.|Afastam.|  Sem   |  Indice  |  Dias/   |   Taxa   | Obitos |  Indice  |" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "|                                         |Absoluto|Menor ou| Maior  |Afastam.| Relactivo |  Homem   |    de    |        | de Aval. |", "|                                         |Absoluto|Menor ou| Maior  |Afastam.| Relativo |  Homem   |    de    |        | de Aval. |" )
		#define STR0011 "|                                         |        |Igual a | Que "
		#define STR0012 "|                                         |        |   "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total Do Estabelecimento", "Total do Estabelecimento" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "De data ?", "De Data ?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "At� data?", "Ate Data?" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "N�o existem dados para apresentar.", "N�o h� dados para exibir." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "De cliente ?", "De Cliente ?" )
		#define STR0018 "Loja"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "At� cliente ?", "At� Cliente ?" )
		#define STR0020 "Respons�vel"
		#define STR0021 "|RESPONSAVEL:"
		#define STR0022 "ASS:____________________________________|"
		#define STR0023 "C�digo do respons�vel. Esta pergunta pode permanecer vazia caso se opte por informar manualmente o nome do respons�vel."
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Data do mapa do relat�rio de accidentes com v�timas.", "Data do Mapa do relat�rio de Acidentes Com V�timas." )
		#define STR0025 "DADOS DA EMPRESA"
		#define STR0026 "EMPRESA.: "
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "CONCELHO..: ", "CIDADE..: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "|FREGUESIA ", "ENDERECO: " )
		#define STR0029 "TELEFONE: "
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Dias �teis no ano ?", "Dias uteis no ano ?" )
		#define STR0031 "Jornada de trabalho ?"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "At� Data ?", "Ate Data ?" )
		#define STR0033 "Data do Mapa"
		#define STR0034 "De Filial ?"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "At� Filial ?", "Ate Filial ?" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "|                  Sector                  | N�mero |Afastam.|Afastam.|  Sem   |  �ndice  |  Dias/   |   Taxa   | �bitos |   Taxa   |", "|                  Setor                  | Numero |Afastam.|Afastam.|  Sem   |  Indice  |  Dias/   |   Taxa   | Obitos |   Taxa   |" )
		#define STR0037 "|                                         |Absoluto|Menor ou| Maior  |Afastam.| Relativo |  Homem   |    de    |        |    de    |"
		#define STR0038 "|                                         |        |Igual a | Que "
		#define STR0039 "|                                         |        |   "
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "AT�", "ATE" )
		#define STR0041 "DATA DO MAPA: __/__/___   |"
		#define STR0042 "DATA DO MAPA:"
		#define STR0043 " |        | Total de | Perdidos | Frequen. |        |Gravidade |"
		#define STR0044 "   |        |        | Emprega. |          |          |        |          |"
		#define STR0045 " |        | Total de | Perdidos | Frequen. |        |    da    |"
		#define STR0046 "   |        |        | Emprega. |          |          |        | Gravida. |"
	#endif
#endif