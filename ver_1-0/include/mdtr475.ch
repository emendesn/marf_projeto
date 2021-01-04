#ifdef SPANISH
	#define STR0001 "Informe anual del Programa de Salud Ocupacional - PCMSO        "
	#define STR0002 "Demostrativo por sector y modalidad de la cantidad de examenes "
	#define STR0003 "realizados con resultados Normales y Anormales.                "
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Informe Anual del PCMSO"
	#define STR0007 "Informe anual del PCMSO    Periodo:"
	#define STR0008 "|Responsable.....:"
	#define STR0009 "CRM.:"
	#define STR0010 "|Firma...........: _____________________________          Fecha:"
	#define STR0011 "|Sect./Examen    |Modalidad | Examenes |Resultados|Anormales x100 |Examen.p/Año|"
	#define STR0012 "ANULADO POR EL OPERADOR"
	#define STR0013 "|"
	#define STR0014 "Periodico"
	#define STR0015 "Cambio"
	#define STR0016 "Retorno"
	#define STR0017 "Despid"
	#define STR0018 "Informe del PCMSO.:"
	#define STR0019 "Periodo:"
	#define STR0020 "Emision:"
	#define STR0021 "Fecha:"
	#define STR0022 "|Sector/Examen                                        |    Naturaleza   |   Examenes | Resultados | Anormalesx 100 | Examenes p/Ano|"
	#define STR0023 "Cliente ?"
	#define STR0024 "Codigo del cliente."
	#define STR0025 "Tienda"
	#define STR0026 "Tienda del cliente."
	#define STR0027 "|Firma......: _________________________________________________"
	#define STR0028 "SUCURSAL"
	#define STR0029 "No existen datos para imprimir en el informe."
	#define STR0030 "|                                                     |                 | Realizados |  Anormales  |  /Realizados   |   Siguiente    |"
	#define STR0031 "Esta empresa esta registrada como Prestadora de Servicio, por lo tanto las 6 primeras "
	#define STR0032 "posiciones de los parametros: 'De Centro de Costo' y 'A Centro de Costo' se refieren "
	#define STR0033 "al codigo del cliente y deben rellenarse con el mismo valor."
	#define STR0034 "¿Enumerar Examenes Proximo Ano?"
	#define STR0035 "Todos"
	#define STR0036 "Ningun"
	#define STR0037 "Examen Periodico"
	#define STR0038 "Indica si la cantidad de examenes previstos para el "
	#define STR0039 "proximo ano sera enumerada en el informe en todas las modalidades, "
	#define STR0040 "solo en los examenes periodicos o en ninguna situacion."
	#define STR0041 "¿Imprimir Examenes NR7 ?"
	#define STR0042 "¿Clasificar por ?"
	#define STR0043 "¿Examenes Proximo Ano?"
	#define STR0044 "¿A Centro de Costo ?"
	#define STR0045 "¿De Centro de Costo ?"
	#define STR0046 "¿A PCMSO ?"
	#define STR0047 "¿De  PCMSO ?"
	#define STR0048 "De Sucursal?"
	#define STR0049 "¿A Sucursal         ?"
#else
	#ifdef ENGLISH
		#define STR0001 "Annual Report of Occupational Health Program     - PCMSO             "
		#define STR0002 "Demonstrative per sector and class of the amount of exams done       "
		#define STR0003 "with normal and abnornal results.                                    "
		#define STR0004 "Z. Form"
		#define STR0005 "Management"
		#define STR0006 "PCMSO Annual Report"
		#define STR0007 "PCMSO Annual Report        Period :"
		#define STR0008 "|Responsible.....:"
		#define STR0009 "CRM.:"
		#define STR0010 "|Signature.......: _____________________________           Date:"
		#define STR0011 "|Sector/Exam     |Class     | Exams    |Results   |Abnormal x 100 |Exams  p/Yr.|"
		#define STR0012 "CANCELED BY OPERATOR"
		#define STR0013 "|"
		#define STR0014 "Periodical"
		#define STR0015 "Change "
		#define STR0016 "Return "
		#define STR0017 "Dismis."
		#define STR0018 "PCMSO report:"
		#define STR0019 "Period:"
		#define STR0020 "Issuance:"
		#define STR0021 "Date:"
		#define STR0022 "|Sect./Exam                                           |    Class        |   Exams    | Results    | Abnorm.  x 100 | Exams p/Year  |"
		#define STR0023 "Customer?"
		#define STR0024 "Customer code."
		#define STR0025 "Unit"
		#define STR0026 "Customer's unit"
		#define STR0027 "|Signature......: _________________________________________________"
		#define STR0028 "BRANCH"
		#define STR0029 "There is nothing to print on the report."
		#define STR0030 "|                                                     |                 | Performed |  Abnormal  |  /Performed   |   Following    |"
		#define STR0031 "This company is registered as Service Provider; therefore, the 6 first "
		#define STR0032 "positions of parameters 'From Cost Center' and  'To Cost Center' refer to "
		#define STR0033 "the customer code and must be filled in with the same amount."
		#define STR0034 "List Exams of Next Year?"
		#define STR0035 "All"
		#define STR0036 "None"
		#define STR0037 "Periodical Exam"
		#define STR0038 "Indicates if number of exams estimated for the "
		#define STR0039 "next year will be listed in the report in all natures, "
		#define STR0040 "only in periodical exams or in no situation."
		#define STR0041 "Print Exams NR7?"
		#define STR0042 "Classify by?"
		#define STR0043 "Exams of Next Year?"
		#define STR0044 "To Cost Center?"
		#define STR0045 "From Cost Center?"
		#define STR0046 "To PCMSO?"
		#define STR0047 "From PCMSO?"
		#define STR0048 "From Branch?"
		#define STR0049 "To Branch?"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relatório anual do programa de saude ocupacional - pcmso             ", "Relatorio Anual do Programa de Saude Ocupacional - PCMSO             " )
		#define STR0002 "Demonstrativo por setor e natureza da quantidade de exames realizados"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Com resultados normais e anormais.                                   ", "com resultados normais e anormais.                                   " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Relatório Anual Do Pcmso", "Relatorio Anual do PCMSO" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Relatório Anual Do Pcmso   Período:", "Relatorio anual do PCMSO   Periodo:" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "|responsavel.....:", "|Responsavel.....:" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Crm.:", "CRM.:" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "|assinatura......: _____________________________           Data:", "|Assinatura......: _____________________________           Data:" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "|setor/função/exame                                   |    natureza     |   exames   | resultados | anormais x 100 | exames p/ano  |", "|Setor/Funcao/Exame                                   |    Natureza     |   Exames   | Resultados | Anormais x 100 | Exames p/Ano  |" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0013 "|"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Periódico", "Periodico" )
		#define STR0015 "Mudanca"
		#define STR0016 "Retorno"
		#define STR0017 "Demiss"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Relatório Do Pcmso.:", "Relatorio do PCMSO.:" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Período:", "Periodo:" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Emissão:", "Emissao:" )
		#define STR0021 "Data:"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "|sector/exame                                          |    natureza     |   exames   | resultados | anormais x 100 | exames p/ano  |", "|Setor/Exame                                          |    Natureza     |   Exames   | Resultados | Anormais x 100 | Exames p/Ano  |" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Cliente?", "Cliente ?" )
		#define STR0024 "Código do cliente."
		#define STR0025 "Loja"
		#define STR0026 "Loja do cliente."
		#define STR0027 "|Assinatura......: _________________________________________________"
		#define STR0028 "FILIAL"
		#define STR0029 "Não há nada para imprimir no relatório."
		#define STR0030 "|                                                     |                 | Realizados |  Anormais  |  /Realizados   |   Seguinte    |"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Essa empresa esta registada como Prestadora de Serviço, portanto as 6 primeiras ", "Essa empresa esta cadastrada como Prestadora de Servico, portanto as 6 primeiras " )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "posições dos parâmetros: 'De Centro de Custo' e 'Até Centro de Custo' referem-se ", "posicoes dos parametros: 'De Centro de Custo' e 'Ate Centro de Custo' referem-se " )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "ao código do cliente e devem ser preenchidas com o mesmo valor.", "ao codigo do cliente e devem ser preenchidas com o mesmo valor." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Listar Exames Próximo Ano?", "Listar Exames Proximo Ano?" )
		#define STR0035 "Todos"
		#define STR0036 "Nenhum"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Exame Periódico", "Exame Periodico" )
		#define STR0038 "Indica se a quantidade de exames previstos para o "
		#define STR0039 "próximo ano será listada no relatório em todas as naturezas, "
		#define STR0040 "apenas nos exames periódicos ou em nenhuma situação."
		#define STR0041 "Imprimir Exames NR7 ?"
		#define STR0042 "Classificar por ?"
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Exames Próximo Ano ?", "Exames Proximo Ano ?" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Até Centro de Custo?", "Ate Centro de Custo ?" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "De Centro de Custo?", "De Centro de Custo ?" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Até PCMSO ?", "Ate PCMSO ?" )
		#define STR0047 "De PCMSO ?"
		#define STR0048 "De Filial ?"
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Até Filial ?", "Ate Filial ?" )
	#endif
#endif
