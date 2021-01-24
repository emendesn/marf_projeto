#ifdef SPANISH
	#define STR0001 "Integracion de rescisiones"
	#define STR0002 "Este programa realizara la integracion de las rescisiones para el archivo de    "
	#define STR0003 "movimiento mensual, transfiriendo los datos y actualizandolos                "
	#define STR0004 "�Confirma configuracion de los parametros?"
	#define STR0005 "�Final del proceso de integracion!"
	#define STR0006 "�Atencion!"
	#define STR0007 "�El procedimiento seleccionado no es de rescision!"
	#define STR0008 "�El periodo seleccionado ya se integro!"
	#define STR0009 '�El "Alias" informado no existe!'
#else
	#ifdef ENGLISH
		#define STR0001 "Termination Integration"
		#define STR0002 "This program will make the Integration of terminations to the file    "
		#define STR0003 "monthly transactions, to transfer and update data                "
		#define STR0004 "Confirm configuration of the parameters?"
		#define STR0005 "End of integration process!"
		#define STR0006 "Attention!"
		#define STR0007 "The selected script is not a termination contract!"
		#define STR0008 "The selected period is already integrated!"
		#define STR0009 'Alias entered does not exist!'
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Integra��o de Rescis�es" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Este programa realizar� a Integra��o das rescis�es para o arquivo de    " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "movimento mensal, transferindo os dados e atualizando-os                " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Confirma configura��o dos par�metros?" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Fim do processo de Integra��o!" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Aten��o!" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "O roteiro selecionado n�o � de Rescis�o!" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "O per�odo selecionado ja foi integrado!" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , 'O "Alias" informado n�o existe!' )
	#endif
#endif
