#ifdef SPANISH
	#define STR0001 "Puntos de Entrada"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Generar Ejemplo"
	#define STR0005 "Incluir"
	#define STR0006 "Modificar"
	#define STR0007 "Borrar"
	#define STR0008 "Punto de Entrada"
	#define STR0009 "Parametros recibidos"
	#define STR0010 "Parametros recibidos"
	#define STR0011 "Archivos PRW |*.PRW|"
	#define STR0012 "Seleccione la carpeta "
	#define STR0013 "Contenido del Parametro ParamIXB["
	#define STR0014 " diferente del esperado "
	#define STR0017 "Error en la creacion del archivo "
	#define STR0018 "Base de datos invalido"
	#define STR0019 "Informe una base de datos valido"
	#define STR0020 "Elija la opcion Todas las bases de datos"
	#define STR0021 "Contenido del Parametro ParamIXB["
	#define STR0022 "  en el punto de Entrada  "
	#define STR0023 "Retorno Inv�lido en el Punto de entrada"
	#define STR0024 "Contenido del Parametro ParamIXB diferente del esperado "
	#define STR0025 "COLOQUE LAS LINEAS ABAJO EN EL CODIGO FUENTE "
	#define STR0026 " PARA LA LLAMADA DEL PUNTO DE ENTRADA"
	#define STR0027 "Retorno Invalido"
	#define STR0028 "Informe un retorno valido para el punto de entrada"
	#define STR0029 "Archivo #1 generado con exito"
	#define STR0030 "Inclusion de Puntos de entrada"
	#define STR0031 "Este asistente lo ayudara a incluir un nuevo punto de entrada ."
	#define STR0032 "Nombre"
	#define STR0033 "Los siguientes puntos deben evaluarse para determinar si el punto de entrada debe crearse"
	#define STR0034 "�El punto de entrada es realmente necesario?"
	#define STR0035 "�La necesidad descrita por el solicitante puede atenderla un recurso ya existente en el sistema?"
	#define STR0036 "�La necesidad descrita por el solicitante podria atenderla una mejora que agregara valor al sistema?"
	#define STR0037 "�El punto de entrada puede introducir vulnerabilidades serias de seguridad al sistema?"
	#define STR0038 "�El punto de entrada puede comprometer seriamente el desempeno del sistema?"
	#define STR0039 "Nombre"
	#define STR0040 "Como debe crearse el punto"
	#define STR0041 "�El nombre del punto es adecuado y sigue los estandares definidos, cuando existen?"
	#define STR0042 "�El punto de disparo sugerido es el mas adecuado?"
	#define STR0043 "�Los datos (parametros) que el punto debe recibir estan disponibles en el punto de disparo sin grandes modificaciones?"
	#define STR0044 "�Los datos que retornaran por el punto estan disponibles o pueden estarlo sin grandes modificaciones?"
	#define STR0045 "Confirme todo el Checklist"
#else
	#ifdef ENGLISH
		#define STR0001 "Entry Point"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Generate Example"
		#define STR0005 "Add"
		#define STR0006 "Edit"
		#define STR0007 "Delete"
		#define STR0008 "Entry Point"
		#define STR0009 "Received Parameters"
		#define STR0010 "Received Parameters"
		#define STR0011 "PRW |*.PRW| Files"
		#define STR0012 "Select the folder"
		#define STR0013 "Contents of Parameter ParamIXB["
		#define STR0014 " different from the expected "
		#define STR0017 "Error creating file "
		#define STR0018 "Invalid Database:"
		#define STR0019 "Enter a valid database"
		#define STR0020 "Choose the option All data banks"
		#define STR0021 "Content of Parameter ParamIXB["
		#define STR0022 "  in the Entry Point  "
		#define STR0023 "Invalid Return in the Entry Point"
		#define STR0024 "Content of Parameter ParamIXB different from the expected "
		#define STR0025 "PUT THE ROWS BELLOW IN SOURCE CODE "
		#define STR0026 " FOR THE ENTRY POINT CALL"
		#define STR0027 "Invalid Return"
		#define STR0028 "Enter a valid return for the entry point"
		#define STR0029 "Arquivo #1 gerado com sucesso"
		#define STR0030 "Inclus�o de Pontos de entrada"
		#define STR0031 "Este assistente ir� ajud�-lo a inserir um novo ponto de entrada ."
		#define STR0032 "Nome"
		#define STR0033 "Os seguintes pontos devem ser avaliados para determinar se o ponto de entrada deve criado"
		#define STR0034 "O ponto de entrada � realmente necess�rio?"
		#define STR0035 "A necessidade apontada pelo solicitante pode ser atendida por um recurso j� existente no sistema?"
		#define STR0036 "A necessidade apontada pelo solicitante poderia ser atendida por uma melhoria que agregasse valor ao sistema?"
		#define STR0037 "O ponto de entrada pode introduzir vulnerabilidades de seguran�a s�rias ao sistema?"
		#define STR0038 "O ponto de entrada pode comprometer seriamente o desempenho do sistema?"
		#define STR0039 "Nome"
		#define STR0040 "Como o ponto deve ser criado"
		#define STR0041 "O nome do ponto � adequado e segue os padr�es definidos, se existirem?"
		#define STR0042 "O ponto de disparo sugerido � o mais adequado?"
		#define STR0043 "Os dados (par�metros) que o ponto deve receber est�o dispon�veis no ponto de disparo sem grandes altera��es?"
		#define STR0044 "Os dados a serem retornados pelo ponto est�o dispon�veis ou podem ser disponibilizados sem grandes altera��es?"
		#define STR0045 "Confirme todo o Checklist"
	#else
		#define STR0001 "Pontos de Entrada"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Gerar exemplo", "Gerar Exemplo" )
		#define STR0005 "Incluir"
		#define STR0006 "Alterar"
		#define STR0007 "Excluir"
		#define STR0008 "Ponto de entrada"
		#define STR0009 "Par�metros recebidos"
		#define STR0010 "Par�metros recebidos"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Ficheiros PRW |*.PRW|", "Arquivos PRW |*.PRW|" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Seleccione a pasta", "Selecione a Pasta" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Conte�do do par�metro ParamIXB[", "Conte�do do Parametro ParamIXB[" )
		#define STR0014 " diferente do esperado "
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Erro na cria��o do ficheiro ", "Erro na cria��o do Arquivo " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Base de dados inv�lida", "Banco de dados inv�lido" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Informe uma base de dados v�lida", "Informe um banco de dados v�lido" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Escolha a op��o Todos as bases de dados", "Escolha a op��o Todos os bancos de dados" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Conte�do do par�metro ParamIXB", "Conte�do do Parametro ParamIXB" )
		#define STR0022 "  no ponto de entrada  "
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Retorno inv�lido no ponto de entrada", "Retorno Inv�lido no Ponto de entrada" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Conte�do do par�metro ParamIXB diferente do esperado ", "Conte�do do Parametro ParamIXB diferente do esperado " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "COLOQUE AS LINHAS ABAIXO NO C�DIGO FONTE ", "COLOQUE AS LINHAS ABAIXO NO CODIGO FONTE " )
		#define STR0026 " PARA A CHAMADA DO PONTO DE ENTRADA"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Retorno inv�lido", "Retorno Invalido" )
		#define STR0028 "Informe um retorno v�lido para o ponto de entrada"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Ficheiro #1 gerado com sucesso", "Arquivo #1 gerado com sucesso" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Inclus�o de pontos de entrada", "Inclus�o de Pontos de entrada" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Este assistente ir� ajud�-lo a inserir um novo ponto de entrada.", "Este assistente ir� ajud�-lo a inserir um novo ponto de entrada ." )
		#define STR0032 "Nome"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Os seguintes pontos devem ser avaliados para determinar se o ponto de entrada deve ser criado", "Os seguintes pontos devem ser avaliados para determinar se o ponto de entrada deve criado" )
		#define STR0034 "O ponto de entrada � realmente necess�rio?"
		#define STR0035 "A necessidade apontada pelo solicitante pode ser atendida por um recurso j� existente no sistema?"
		#define STR0036 "A necessidade apontada pelo solicitante poderia ser atendida por uma melhoria que agregasse valor ao sistema?"
		#define STR0037 "O ponto de entrada pode introduzir vulnerabilidades de seguran�a s�rias ao sistema?"
		#define STR0038 "O ponto de entrada pode comprometer seriamente o desempenho do sistema?"
		#define STR0039 "Nome"
		#define STR0040 "Como o ponto deve ser criado"
		#define STR0041 "O nome do ponto � adequado e segue os padr�es definidos, se existirem?"
		#define STR0042 "O ponto de disparo sugerido � o mais adequado?"
		#define STR0043 "Os dados (par�metros) que o ponto deve receber est�o dispon�veis no ponto de disparo sem grandes altera��es?"
		#define STR0044 "Os dados a serem retornados pelo ponto est�o dispon�veis ou podem ser disponibilizados sem grandes altera��es?"
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Confirme todo o checklist", "Confirme todo o Checklist" )
	#endif
#endif
