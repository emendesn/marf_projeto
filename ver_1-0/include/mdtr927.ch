#ifdef SPANISH
	#define STR0001 "Acta de Eleccion"
	#define STR0002 "Imprimiendo..."
	#define STR0003 "ACTA DE ELECCION DE LOS REPRESENTANTES DE LOS EMPLEADOS CIPA"
	#define STR0004 " dias del mes "
	#define STR0005 " de "
	#define STR0006 "A los "
	#define STR0007 " en el lugar designado en el Edicto de Convocacion "
	#define STR0008 " , con la presencia de los Senores "
	#define STR0009 " y "
	#define STR0010 " se instalo la mesa de recepcion y escrutinio de los votos a las "
	#define STR0011 " horas, el Sr. Presidente de la mesa declaro iniciados los trabajos. Durante la votacion, "
	#define STR0012 "se verificaron las siguientes ocurrencias: "
	#define STR0013 " horas, el Sr. Presidente declaro encerrados los trabajos de eleccion, verificandose"
	#define STR0014 "que comparecieron "
	#define STR0015 " empleados y efectuandose el escrutinio, en la presencia de todos aquellos"
	#define STR0016 "lo deseen."
	#define STR0017 "Despues del calculo se llego al sgte. resultado:"
	#define STR0018 "Titulare(s)"
	#define STR0019 "Suplente(s)"
	#define STR0020 "Nombre"
	#define STR0021 "Votos"
	#define STR0022 "Despues de la clasif. de los repres. de los empl. por orden de votac., de los"
	#define STR0023 "titulares y suplentes, estos represent. elegiran el "
	#define STR0024 "para Vicepresidente."
	#define STR0025 "Otros votados en orden decreciente de votos:"
	#define STR0026 "Y, para constar, mando el Sr. Presidente de la mesa que se labre la presente Acta,"
	#define STR0027 "que firmo, "
	#define STR0028 ", p/los Miembr. de mesa y"
	#define STR0029 "p/los elegidos"
	#define STR0030 "Presidente de mesa"
	#define STR0031 "Secretario de mesa"
	#define STR0032 "Represent. de los Empleados:"
	#define STR0033 "Titular"
	#define STR0034 "Suplente"
	#define STR0035 "�Cliente?"
	#define STR0036 "Tda."
	#define STR0037 " - Procesando..."
	#define STR0038 "�Tipo de Impres.?"
	#define STR0039 "�Mandato CIPA?"
	#define STR0040 "A "
	#define STR0041 "No fue posible grabar el informe"
	#define STR0042 "AVISO"
	#define STR0043 " , con la presencia del Senor "
	#define STR0044 "Imprimir Blancos/Nulos"
	#define STR0045 "Si"
	#define STR0046 "No"
	#define STR0047 "Indica si los votos blancos y nulos se imprimiran en el informe(Acta de Eleccion CIPA)."
	#define STR0048 "Votos Blancos"
	#define STR0049 "Votos Nulos"
	#define STR0050 "�Alistar no votados?"
	#define STR0051 "Indica si los candidatos que no tuvieron voto se deben enumerar."
	#define STR0052 "Candidatos sin voto:"
#else
	#ifdef ENGLISH
		#define STR0001 "Minutes of Election"
		#define STR0002 "Printing..."
		#define STR0003 "MINUTES OF ELECTION OF REPRESENTATIVES OF EMPLOYEES CIPA"
		#define STR0004 "days of the month"
		#define STR0005 "from"
		#define STR0006 "To "
		#define STR0007 " in the place designated in the Convocation Edict"
		#define STR0008 " ,with the presence of Sirs"
		#define STR0009 "and"
		#define STR0010 "the reception and vote counting table was installed at "
		#define STR0011 " , the Chairman of the table declared open the work. During the voting, "
		#define STR0012 "the following occurrences were checked: "
		#define STR0013 " , the Chairman declared closed the election work, ensuring"
		#define STR0014 "that appeared "
		#define STR0015 " employees and moving to counting, in the presence of "
		#define STR0016 "wished.    "
		#define STR0017 "After counting, the following result was obtained:"
		#define STR0018 "Main(s)"
		#define STR0019 "Auxiliary(ies)"
		#define STR0020 "Name"
		#define STR0021 "Votes"
		#define STR0022 "After classifying the representatives of the employees by order of votation, the"
		#define STR0023 "holders and substitutes, these representatives elected "
		#define STR0024 "for Vice-chairmen.   "
		#define STR0025 "Other voted in descending order:             "
		#define STR0026 "For the records, Mr. Chairman requested that this minute were recorded,           "
		#define STR0027 "signed by myself, "
		#define STR0028 ", the members of the board"
		#define STR0029 "and those elected."
		#define STR0030 "President of board"
		#define STR0031 "Secretary of board"
		#define STR0032 "Representatives of employees: "
		#define STR0033 "Holder "
		#define STR0034 "Substitute"
		#define STR0035 "Customer ?"
		#define STR0036 "Unit"
		#define STR0037 " - Processing..."
		#define STR0038 "Print Type?"
		#define STR0039 "CIPA Term?"
		#define STR0040 "At "
		#define STR0041 "Report could not be saved."
		#define STR0042 "WARNING"
		#define STR0043 " , with your presence "
		#define STR0044 "Print Blank/Null"
		#define STR0045 "Yes"
		#define STR0046 "No"
		#define STR0047 "Indicates whether blank and null votes are printed in the report (Minutes of CIPA Election)."
		#define STR0048 "Blank Ballots"
		#define STR0049 "Null Ballots"
		#define STR0050 "List not voted?"
		#define STR0051 "Defines whether candidates not voted for must be listed."
		#define STR0052 "Candidates without votes:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Acta De Elei��o", "Ata de Elei��o" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A imprimir...", "Imprimindo..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Acta De Elei��o Dos Representantes Dos Empregados Chsst", "ATA DE ELEI��O DOS REPRESENTANTES DOS EMPREGADOS CIPA" )
		#define STR0004 " dias do m�s "
		#define STR0005 " de "
		#define STR0006 "Aos "
		#define STR0007 If( cPaisLoc $ "ANG|PTG", " no local designado no edital de convoca��o ", " no local designado no Edital de Convoca��o " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " , com a presen�a dos senhores ", " , com a presen�a dos Senhores " )
		#define STR0009 " e "
		#define STR0010 " instalou-se a mesa receptora e apuradora dos votos �s "
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " horas, o sr. presidente da mesa declarou iniciados os trabalhos. durante a vota��o, ", " horas, o Sr. Presidente da mesa declarou iniciados os trabalhos. Durante a vota��o, " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Verificaram-se as seguintes ocorr�ncias: ", "verificaram-se as seguintes ocorr�ncias: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", " horas, o sr. presidente declarou encerrados os trabalhos de elei��o, verificando-se", " horas, o Sr. Presidente declarou encerrados os trabalhos de elei��o, verificando-se" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Que compareceram ", "que compareceram " )
		#define STR0015 " empregados e passando-se � apura��o, na presen�a de quantos"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Desejassem.", "desejassem." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Ap�s o apuramento chegou-se ao seguinte resultado:", "Ap�s a apura��o chegou-se ao seguinte resultado:" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Titular(es)", "Titulare(s)" )
		#define STR0019 "Suplente(s)"
		#define STR0020 "Nome"
		#define STR0021 "Votos"
		#define STR0022 "Ap�s a classifica��o dos representantes dos empregados por ordem de vota��o, dos"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Titulares e suplentes, estes representantes elegeram o ", "titulares e suplentes, esses representantes elegeram o " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Para Vice-presidente.", "para Vice-Presidente." )
		#define STR0025 "Demais votados em ordem decrescente de votos:"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "E, Para Constar, Mandou O Sr. Presidente Da Mesa Que Fosse Lavrada A Presente Acta,", "E, para constar, mandou o Sr. Presidente da mesa que fosse lavrada a presente Ata," )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Por mim assinada, ", "por mim assinada, " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", ", pelos membros da mesa e", ", pelos Membros da mesa e" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Pelos eleitos.", "pelos eleitos." )
		#define STR0030 "Presidente da mesa"
		#define STR0031 "Secret�rio da mesa"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Representantes Dos Empregados:", "Representantes dos Empregados:" )
		#define STR0033 "Titular"
		#define STR0034 "Suplente"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Cliente?", "Cliente ?" )
		#define STR0036 "Loja"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", " � A Processar...", " - Processando..." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Tipo de Impress�o ?", "Tipo de Impressao ?" )
		#define STR0039 "Mandato CIPA ?"
		#define STR0040 "�s "
		#define STR0041 "N�o foi poss�vel gravar o relat�rio"
		#define STR0042 "AVISO"
		#define STR0043 " , com a presen�a do Senhor "
		#define STR0044 "Imprimir Brancos/Nulos?"
		#define STR0045 "Sim"
		#define STR0046 "N�o"
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Indica se os votos brancos e nulos ser�o impressos no relat�rio(Acta de Elei��o CIPA).", "Indica se os votos brancos e nulos ser�o impressos no relat�rio(Ata de Elei��o CIPA)." )
		#define STR0048 "Votos Brancos"
		#define STR0049 "Votos Nulos"
		#define STR0050 "Listar n�o votados?"
		#define STR0051 "Indica se os candidatos que n�o tiveram voto devem ser listados."
		#define STR0052 "Candidatos sem voto:"
	#endif
#endif