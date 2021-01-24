#ifdef SPANISH
	#define STR0001 "Generacion automatica del Plan de Desarrollo Personal"
	#define STR0002 "Generacion automatica del Plan de metas"
	#define STR0003 "Este programa tiene la finalidad de generar el Plan de"
	#define STR0004 "Desarrollo Personal"
	#define STR0005 "Metas"
	#define STR0006 "a los participantes de acuerdo con el criterio establecido"
	#define STR0007 "Criterio invalido..."
	#define STR0008 "Final del procesamiento"
	#define STR0009 "Atencion"
	#define STR0010 "Tipo do objetivo no registrado."
	#define STR0011 "Tipo objetivo invalido. Informe solamente Tipo de objetivo"
	#define STR0012 "'Plan'"
	#define STR0013 "'Meta'"
	#define STR0014 "Diccionario de datos incompatible con el repositorio, �actualice por favor!"
	#define STR0015 "Periodo no registrado."
	#define STR0016 "Periodo no pertenece al Tipo de Objetivo seleccionado."
	#define STR0017 "Seleccionando los registros"
	#define STR0018 "Desea visualizar los registros seleccionados"
	#define STR0019 "Sucursal Participante                      Nombre                              "
	#define STR0020 "Registros seleccionados por el Criterio "
	#define STR0021 "Confirma grabacion para los participantes"
	#define STR0022 "Grabando los registros"
	#define STR0023 "Ningun registro encontrado"
	#define STR0024 "Parametros "
#else
	#ifdef ENGLISH
		#define STR0001 "Automatic generation of personal development plan "
		#define STR0002 "Automatic generation of goals plan "
		#define STR0003 "The purpose of this program is to generate the chart"
		#define STR0004 "Personal development "
		#define STR0005 "Goals"
		#define STR0006 "to participants according to established criteria "
		#define STR0007 "Invalid criterion..."
		#define STR0008 "End of processing "
		#define STR0009 "Attention"
		#define STR0010 "Objective type not registered."
		#define STR0011 "Invalid objective type. Enter Objective Type only "
		#define STR0012 "'Plan '"
		#define STR0013 "Target"
		#define STR0014 "Data dictionary incompatible with repository, please update! "
		#define STR0015 "Unregistered period."
		#define STR0016 "Period does not belong to the selected Objective Type."
		#define STR0017 "Selecting records"
		#define STR0018 "Do you want to view the records selected?"
		#define STR0019 "Participating Branch                       Name                                "
		#define STR0020 "Records selected by the Criterion "
		#define STR0021 "Confirm saving for participants"
		#define STR0022 "Saving records"
		#define STR0023 "No record was found"
		#define STR0024 "Parameters "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Cria��o automatica do plano de desenvolvimento pessoal", "Gera��o Autom�tica do Plano de Desenvolvimento Pessoal" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Cria��o automatica do plano de metas", "Gera��o Autom�tica do Plano de Metas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Este programa tem a finalidade de criar o plano de", "Este programa tem a finalidade de Gerar o Plano de" )
		#define STR0004 "Desenvolvimento Pessoal"
		#define STR0005 "Metas"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Aos participantes de acordo com o crit�rio estabelecido", "aos participantes de acordo com o crit�rio estabelecido" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Criterio inv�lido...", "Crit�rio Inv�lido..." )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Fim Do Processamento", "Fim do Processamento" )
		#define STR0009 "Aten��o"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Tipo do objetivo n�o registado.", "Tipo do Objetivo n�o cadastrado." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Tipo objetivo inv�lido. informe somente tipo de objetivo", "Tipo Objetivo Inv�lido. Informe somente Tipo de Objetivo" )
		#define STR0012 "'Plano'"
		#define STR0013 "'Meta'"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Base de dados incompat�vel com o reposit�rio, por favor actualize-a!", "Dicion�rio de dados incompat�vel com o reposit�rio, favor atualizar!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Per�odo n�o registado.", "Periodo n�o cadastrado." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Per�odo n�o pertence ao tipo de objectivo seleccionado.", "Periodo n�o pertence ao Tipo de Objetivo selecionado." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "A seleccionar os registos", "Selecionando os registros" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Deseja visualiar os registos seleccionados", "Deseja visualiar os registros selecionados" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Filial participante                        nome                                ", "Filial Participante                        Nome                                " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Registos seleccionados pelo crit�rio ", "Registros selecionados pelo Criterio " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Confirmar grava��o para os participantes", "Confirma grava�ao para os participantes" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "A gravar os registos", "Gravando os registros" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Nenhum registo encontrado", "Nenhum registro encontrado" )
		#define STR0024 "Par�metros "
	#endif
#endif
