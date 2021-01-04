#ifdef SPANISH
	#define STR0001 "Anular"
	#define STR0002 "Confirmar"
	#define STR0003 "Reescribe"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Archivo de vacantes"
	#define STR0010 "Leyenda"
	#define STR0011 "Vacantes pendientes"
	#define STR0012 "Vacantes Finalizadas"
	#define STR0013 "Ahora el sistema hara la verificacion para ver si la vacante seleccionada para"
	#define STR0014 "borrado esta utilizandose. ��La verificacion puede tardar!!"
	#define STR0015 "�Confirma el borrado de la vacante?"
	#define STR0016 "Log de ocurrencias en el borrado de vacantes"
	#define STR0017 "El campo"
	#define STR0018 "se debe completar cuando la integracion entre los modulos SIGAORG y SIGARSP este activada."
	#define STR0019 "Los Campos"
	#define STR0020 "o"
	#define STR0021 "deberan estar completos, cuando el campo"
	#define STR0022 "sea seleccionado."
	#define STR0023 "No se encontraron la sucursal y la matricula. Seleccione la matricula del responsable por medio de la opcion F3 para que la sucursal y la matricula se inserten correctamente."
	#define STR0024 "El uso compartido de la tabla de funciones (SRJ) debe ser igual o tener menor cantidad de uso compartido Exclusivo (Sucursal/Unidad/Empresa) que la tabla de Vacantes (SQS). Si la tabla de Vacantes (SQS) estuviera con C E E, la SRJ no podr� ser E E E."
	#define STR0025 "Modifique el modo de acceso por medio del Configurador. Archivos SQS y SRJ."
	#define STR0026 "Vacantes"
#else
	#ifdef ENGLISH
		#define STR0001 "Quit"
		#define STR0002 "OK"
		#define STR0003 "Retype"
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Insert"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Vacancies File"
		#define STR0010 "Caption"
		#define STR0011 "Open positions "
		#define STR0012 "Closed positions"
		#define STR0013 "The system will now check if the vacancy selected for                        "
		#define STR0014 "exclusion in use. The checking may take a long time!!"
		#define STR0015 "Confirm deletion of Vacancy?"
		#define STR0016 "Occurrences log when deleting vacancies"
		#define STR0017 "The field"
		#define STR0018 "must be filled out when the Integration between SIGAORG and SIGARSP modules is active."
		#define STR0019 "The fields"
		#define STR0020 "or"
		#define STR0021 "must be filled out when the field"
		#define STR0022 "is selected."
		#define STR0023 "The branch and registration number were not found. Select the registration number of person in charge through option F3 to add branch and registration number."
		#define STR0024 "The functions table sharing (SRJ) must be equal to or have smaller quantity of Exclusive sharing (Branch/Unit/Company) that the Vacancies table (SQS). If the Vacancies table (SQS) has C E E, SRJ cannot be E E E."
		#define STR0025 "Edit the access mode through the Configurator. Files SQS and SRJ."
		#define STR0026 "Positions"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0002 "Confirma"
		#define STR0003 "Redigita"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Registo De Vagas", "Cadastro de Vagas" )
		#define STR0010 "Legenda"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Vagas Em Aberto", "Vagas em Aberto" )
		#define STR0012 "Vagas Encerradas"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "O sistema agora ir� efectuar a verifica��o para ver se a vaga selecionada para", "O Sistema agora ira efetuar a verificacao para ver se a vaga selecionada para" )
		#define STR0014 "exclusao esta sendo utilizada. A verifica��o pode ser demorada !!"
		#define STR0015 "Confirma a exclus�o da Vaga?"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Log De Ocorrencias Na Exclus�o De Vagas", "Log de Ocorrencias na Exclusao de Vagas" )
		#define STR0017 "O campo"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "dever� ser preenchido quando a Integra��o entre os m�dulos SIGAORG e SIGARSP est� activada.", "dever� ser preenchido quando a Integra��o entre os m�dulos SIGAORG e SIGARSP est� ativada." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Os campos", "Os Campos" )
		#define STR0020 "ou"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "dever�o estar preenchidos quando o campo", "dever�o estar preenchidos, quando o campo" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "for seleccionado.", "for selecionado." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "N�o foram localizadas a filial e a matr�cula. Seleccione a matr�cula do respons�vel por meio da op��o F3 para que a filial e a matr�cula sejam inseridas correctamente.", "A filial e matricula n�o foi localizada. Selecione a matricula do respons�vel atrav�s da op��o F3, para que a filial e a matricula seja inserida corretamente." )
		#define STR0024 "O compartilhamento da tabela de fun��es (SRJ) dever� ser igual ou possuir menor quantidade de compartilhamento Exclusivo (Filial/Unidade/Empresa) que a tabela de Vagas (SQS). Se a tabela de Vagas (SQS) estiver com C E E, a SRJ n�o poder� ser E E E."
		#define STR0025 "Altere o modo de acesso atraves do Configurador. Arquivos SQS e SRJ."
		#define STR0026 "Vagas"
	#endif
#endif
