#ifdef SPANISH
	#define STR0001 "Acta de Instal. y Pose de la CIPA"
	#define STR0002 "Imprimiendo.."
	#define STR0003 "ACTA DE INSTAL. Y POSE DE LA CIPA"
	#define STR0004 " dias del mes"
	#define STR0005 " de "
	#define STR0006 "A "
	#define STR0007 "en la Empr. "
	#define STR0008 "en esta ciudad,"
	#define STR0009 "presente(s) el/los Senor(es) Diretor(es) de la Empresa, asi como los demas presentes, segun Libro"
	#define STR0010 "de Presencia, se reunieron para Instalac. y Pose de la Cipa de esta Empresa, segun lo estabelec."
	#define STR0011 "por la Resol. n° 3214/78. El Senor "
	#define STR0012 " representante de la Empr. y Presid. de la Sesion,"
	#define STR0013 "conmigo como invitado, "
	#define STR0014 " como Secretario de esta, declaro "
	#define STR0015 "instal. la sesion, recuerdo a todos los objet. de la Reunion, que son los sgtes: Instal. y "
	#define STR0016 "Pose de los componentes de la CIPA. A continuac. declaro instal. la Comis. y nombrados los"
	#define STR0017 "Representantes del Empleador:"
	#define STR0018 "Titulares"
	#define STR0019 "Suplentes"
	#define STR0020 "De la misma forma nombro a los Representantes electos por los Empleados:"
	#define STR0021 "A contin., se designa como Presidente de la CIPA al Senor"
	#define STR0022 ", elegido "
	#define STR0023 "entre los Repres electos por los Empleados el Senor "
	#define STR0024 " para Vicepresidente. "
	#define STR0025 "Los Repres. del Empleador y de los Empleados, de comun acuerdo, eligieron "
	#define STR0026 "tambien el Senor "
	#define STR0027 " para Secretario de la CIPA, y como sustituto el Senor "
	#define STR0028 ". Sin mas a tratar, el Presidente de la Sesion dio por terminada la reunion, "
	#define STR0029 "recordando a todos que el periodo de gestion de la CIPA instalada a la fecha, sera de 01 (un) ano, "
	#define STR0030 "a partir de esta fch. Y, para que asi conste, se labra la pte Acta que, despues de"
	#define STR0031 "leida, aprob, la firma, el Secretario, el Presidente de la Sesion y todos los "
	#define STR0032 "Representantes electos y/o designados, incluso los Suplentes."
	#define STR0033 "Presid. de la Sesion"
	#define STR0034 "Secret. de la Sesion"
	#define STR0035 "Secretario"
	#define STR0036 "Secretario Sustituto"
	#define STR0037 "ACTA DE ELECC. DE LOS REPRES. DE LOS EMPLEADOS CIPA"
	#define STR0038 "¿Cliente?"
	#define STR0039 "Tda."
	#define STR0040 " - Procesando..."
	#define STR0041 "¿Tipo de Impresion?"
	#define STR0042 "¿Mandato CIPA?"
	#define STR0043 "No fue posible grabar el informe"
	#define STR0044 "AVISO"
#else
	#ifdef ENGLISH
		#define STR0001 "Minute of CIPA institution and take-over"
		#define STR0002 "Printing ... "
		#define STR0003 "MINUTE OF CIPA INSTITUTION AND TAKE-OVER"
		#define STR0004 " days of month"
		#define STR0005 " of "
		#define STR0006 "On  "
		#define STR0007 " in the company"
		#define STR0008 " in this city, "
		#define STR0009 "present Mr.(Messrs.) Director(s) of the company, as well as the other persons present, as per the"
		#define STR0010 "Record of presence, gathered for CIPA instauration and take-over in the company as per provisions"
		#define STR0011 "by decree n° 3214/78. Mr.          "
		#define STR0012 " represent.of the company and chairman of session,"
		#define STR0013 "having invited me,     "
		#define STR0014 " as its secretary, stated           "
		#define STR0015 "after opening the session, remembering all presents the purpose of the meeting: instauration"
		#define STR0016 "take-over by the members of CIPA. Next, the committed was declared instated and taken over the"
		#define STR0017 "Representatives of employer: "
		#define STR0018 "Holders  "
		#define STR0019 "Substitutes"
		#define STR0020 "The same way, declared taken over the representatives elected by the employees:"
		#define STR0021 "Next, as CIPA chairman was designed Mr.                  "
		#define STR0022 " and has been elected  "
		#define STR0023 "amongs the representatives elected of the employees Mr. "
		#define STR0024 " for Vice-Ppesident.   "
		#define STR0025 "The representatives of the employer and employeer, under mutual agreement, chose"
		#define STR0026 "also Mr.        "
		#define STR0027 " to CIPA secretary, its substitute is Messr.            "
		#define STR0028 ". There being no more topics to treat, the Chairman of the session closed the meeting"
		#define STR0029 "reminding all tat the CIPA management office will be for 01 (one) year,              "
		#define STR0030 "from the present day. And, for the records, this minute was recorded, read and   "
		#define STR0031 "approved, is signed by myself, Secretary, the Chairman of the session and all the    "
		#define STR0032 "Representatives elected and/or appointed, including Substitutes."
		#define STR0033 "Chairman of session "
		#define STR0034 "Session secretary   "
		#define STR0035 "Secretary "
		#define STR0036 "Substitute secretary"
		#define STR0037 "MINUTE OF ELECTION OF REPRESENTATIVES OF CIPA EMPLOYEES"
		#define STR0038 "Customer ?"
		#define STR0039 "Unit"
		#define STR0040 " - Processing..."
		#define STR0041 "Print Type?"
		#define STR0042 "CIPA Term?"
		#define STR0043 "Report could not be saved."
		#define STR0044 "WARNING"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Acta De Instalação E Posse Da Chsst", "Ata de Instalacao e Posse da CIPA" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A imprimir...", "Imprimindo..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Acta De Instalação E Posse Da Chsst", "ATA DE INSTALAÇÃO E POSSE DA CIPA" )
		#define STR0004 " dias do mês "
		#define STR0005 " de "
		#define STR0006 "Aos "
		#define STR0007 If( cPaisLoc $ "ANG|PTG", " na empresa ", " na Empresa " )
		#define STR0008 " nesta cidade, "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Presente(s) o(s) senhor(es) director(es) da empresa, artigo como os demais presentes, conforme livro ", "presente(s) o(s) Senhor(es) Diretor(es) da Empresa, bem como os demais presentes, conforme Livro " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "De presença, reuniram-se para instalação e posse da chsst desta empresa, conforme o estabelecido ", "de Presença, reuniram-se para Instalação e Posse da Cipa desta Empresa, conforme o estabelecido " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Pela portaria n° 3214/78. o senhor ", "pela portaria n° 3214/78. O Senhor " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", " representante da empresa e presidente da sessão, ", " representante da Empresa e Presidente da Sessão, " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Tendo-me convidado, ", "tendo convidado a mim, " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " para secretário da mesma, declarou ", " para Secretário da mesma, declarou " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Abertos os trabalhos, lembrando a todos os objectivos da reunião, que são: instalação e ", "abertos os trabalhos, lembrando a todos os objetivos da Reunião, quais sejam: Instalação e " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Posse dos componentes da chsst. continuando, declarou instalada a comissão e empossados os ", "Posse dos componentes da CIPA. Continuando, declarou instalada a Comissão e empossados os " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Representantes Do Empregador:", "Representantes do Empregador:" )
		#define STR0018 "Titulares"
		#define STR0019 "Suplentes"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Da Mesma Forma Declarou Empossados Os Representantes Eleitos Pelos Empregados:", "Da mesma forma declarou empossados os Representantes eleitos pelos Empregados:" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "A seguir, foi designado para presidente da chsst o senhor ", "A seguir, foi designado para Presidente da CIPA o Senhor " )
		#define STR0022 ", tendo sido escolhido "
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Entre os representantes eleitos dos empregados o senhor ", "entre os Representantes eleitos dos Empregados o Senhor " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", " para vice-presidente. ", " para Vice-Presidente. " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Os representantes do empregador e dos empregados, de comum acordo, escolheram ", "Os Representantes do Empregador e dos Empregados, em comum acordo, escolheram " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Também o senhor ", "também o Senhor " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", " para secretário da chsst, sendo seu substituto o senhor ", " para Secretário da CIPA, sendo seu substituto o Senhor " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", ". nada mais havendo para tratar, o presidente da sessão deu por encerrada a reunião, ", ". Nada mais havendo para tratar, o Presidente da Sessão deu por encerrada a reunião, " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Lembrando a todos que o período de gestão da chsst agora constituída será de 01 (um) ano, ", "lembrando a todos que o período da gestão da CIPA ora instalada será de 01 (um) ano, " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "A contar da presente data. e, para que conste se lavrou a presente acta que, depois de lida e ", "a contar da presente data. E, para constar, lavrou-se a presente Ata que, lida e " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Aprovada, vai ser assinada por mim, secretário, pelo presidente da sessão e por todos os ", "aprovada, vai assinada por mim, Secretário, pelo Presidente da Sessão e por todos os " )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Representantes Eleitos E/ou Designados, Inclusive Os Suplentes.", "Representantes eleitos e/ou designados, inclusive os Suplentes." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Presidente Da Sessão", "Presidente da Sessão" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Secretário Da Sessão", "Secretário da Sessão" )
		#define STR0035 "Secretário"
		#define STR0036 "Secretário Substituto"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Acta De Eleição Dos Representantes Dos Empregados Chsst", "ATA DE ELEIÇÃO DOS REPRESENTANTES DOS EMPREGADOS CIPA" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Cliente?", "Cliente ?" )
		#define STR0039 "Loja"
		#define STR0040 If( cPaisLoc $ "ANG|PTG", " – A Processar...", " - Processando..." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Tipo de Impressão ?", "Tipo de Impressao ?" )
		#define STR0042 "Mandato CIPA ?"
		#define STR0043 "Não foi possível gravar o relatório"
		#define STR0044 "AVISO"
	#endif
#endif
