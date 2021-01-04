#ifdef SPANISH
	#define STR0001 "(seleccione el entorno)"
	#define STR0002 "�Confirma borrado del Proceso ["
	#define STR0003 "] de Archivo de Configuraciones? "
	#define STR0004 "La sesion ["
	#define STR0005 "] se borro con exito."
	#define STR0006 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reiniciar el Servidor Protheus."
	#define STR0007 "Configuraciones de la sesion"
	#define STR0008 "Asistente de Configuracion de Procesos Comunes"
	#define STR0009 "Nombre del Job"
	#define STR0010 "Funcion Advpl"
	#define STR0011 "Entorno"
	#define STR0012 "Instancias"
	#define STR0013 "Parametros"
	#define STR0014 "Habilitar Job en el START del Servidor Protheus"
	#define STR0015 "Parametros"
	#define STR0016 "Seleccione un Entorno para ejecutar este JOB"
	#define STR0017 "ATENCION: No fue posible verificar la existencia de la funcion ["
	#define STR0018 "] en el entorno ["
	#define STR0019 "ATENCION: La funcion ["
	#define STR0020 "] no se  encontro en el repositorio del entorno ["
	#define STR0021 "�Confirma la inclusion de este Job? "
	#define STR0022 "�Confirma la grabacion de este Job? "
	#define STR0023 "Configuraciones del Proceso ["
	#define STR0024 "] actualizadas con exito."
	#define STR0025 "Debe especificarse el nombre de la Seccion para Procesos Comunes."
	#define STR0026 "Este nombre de Sesion para Procesos Comunes no es valido, pues se trata de una Configuracion de Entorno existente del Protheus Server."
	#define STR0027 "Este nombre de Sesion para Procesos Comunes no es valido, pues se trata de una Configuracion de Job existente del Protheus Server."
	#define STR0028 "Este nombre de Sesion para Procesos Comunes no es valido, pues se trata de una Sesion desconocida actualmente ya existente en el Protheus Server."
	#define STR0029 "Este nombre de Sesion para Procesos Comunes es invalido, pues se trata de una Configuraicon de Host actualmente ya existente en el Protheus Server."
	#define STR0030 "Este nombre de Sesion para Procesos Comunes es invalida, pues se trata de una Configuracion de Driver de Conexion ya existente en el Protheus Server."
	#define STR0031 "Este Sesion para Procesos Comunes esta reigistrada en Protheus Server."
	#define STR0032 "Este nombre de Sesion para Procesos Comunes no es valido, pues se trata de una clave reservada de configuracion del Protheus Server."
	#define STR0033 "La cantidad de Instancias no puede ser cero."
	#define STR0034 "La cantidad de Instancias no puede ser inferior a cero."
	#define STR0035 "Debe informarse el nombre de la Funcion ADVPL."
#else
	#ifdef ENGLISH
		#define STR0001 "(select an environment)"
		#define STR0002 "Confirm Process deletion       ["
		#define STR0003 "] of the Configurations File?   "
		#define STR0004 "Section ["
		#define STR0005 "] was deleted successfully."
		#define STR0006 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0007 "Section Configuration "
		#define STR0008 "Common Processes Configuration Assistant      "
		#define STR0009 "Job Name   "
		#define STR0010 "ADVPL Function"
		#define STR0011 "Environment"
		#define STR0012 "Areas     "
		#define STR0013 "Parameters"
		#define STR0014 "Enable Job on the Protheu Server START     "
		#define STR0015 "Parameters"
		#define STR0016 "Select an Environment to accomplish this JOB   "
		#define STR0017 "WARNING : It was not possible to check the function existence ["
		#define STR0018 "] in the environment ["
		#define STR0019 "WARNING : Function ["
		#define STR0020 "] was not found in the environment repository   ["
		#define STR0021 "Confirm insertion of these Jobs? "
		#define STR0022 "Confirm saving of these Jobs?    "
		#define STR0023 "Process Configurations    ["
		#define STR0024 "] updated successfully.   "
		#define STR0025 "The section name for Common Processes must be specified.    "
		#define STR0026 "This Section name for Common Processes is not valid, since it deals with an Environment Configuration currently in the Protheus Server."
		#define STR0027 "This Section name for Common Processes is not valid, since it deals with a Job Configuration currently in the Protheus Server.   "
		#define STR0028 "This Section name for Common Processes is not valid, since it deals with an unkown Section currently in the Protheus Server.              "
		#define STR0029 "This Section name for Common Processes is not valid, since it deals with the Host Configuration currently in the Protheus Server.           "
		#define STR0030 "This Section name for Common Processes is not valid, since it deals with the Connection Driver Configuration already in the Protheus Server.  "
		#define STR0031 "This Section name for Common Processes is already registered in the Protheus Server."
		#define STR0032 "This Section name for Common Processes is not valid, since it deals with the Protheus Server configuration booked key.         "
		#define STR0033 "The area quantity cannot be zero.          "
		#define STR0034 "The area quantity cannot be lower than zero.          "
		#define STR0035 "ADVPL Function Name should be informed.   "
	#else
		Static STR0001 := "(selecione o ambiente)"
		Static STR0002 := "Confirma a dele��o do Processo ["
		Static STR0003 := "] do Arquivo de Configura��es ? "
		Static STR0004 := "A Se��o ["
		Static STR0005 := "] foi deletada com sucesso."
		Static STR0006 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0007 := "Configura��es da Se��o"
		Static STR0008 := "Assistente de Configura��o de Processos Comuns"
		Static STR0009 := "Nome do Job"
		Static STR0010 := "Fun��o Advpl"
		#define STR0011  "Ambiente"
		#define STR0012  "Inst�ncias"
		#define STR0013  "Par�metros"
		Static STR0014 := "Habilitar Job no START do Servidor Protheus"
		#define STR0015  "Par�metros"
		Static STR0016 := "Selecione um Ambiente para a execu��o deste JOB"
		Static STR0017 := "ATEN��O : N�o foi poss�vel verificar a exist�ncia da fun��o ["
		#define STR0018  "] no ambiente ["
		Static STR0019 := "ATEN��O : A fun��o ["
		#define STR0020  "] n�o foi encontrada no reposit�rio do ambiente ["
		Static STR0021 := "Confirma a inclus�o deste Jobs ? "
		Static STR0022 := "Confirma a grava��o deste Jobs ? "
		Static STR0023 := "Configura��es do Processo ["
		Static STR0024 := "] atualizadas com sucesso."
		Static STR0025 := "O nome da Se��o para Processos Comuns deve ser especificado."
		Static STR0026 := "Este nome de Se��o para Processos Comuns n�o � v�lido, pois trata-se de uma Configura��o de Ambiente j� existente do Protheus Server."
		Static STR0027 := "Este nome de Se��o para Processos Comuns  n�o � v�lido, pois trata-se de uma Configura��o de Job j� existente do Protheus Server."
		Static STR0028 := "Este nome de Se��o para Processos Comuns n�o � v�lido, pois trata-se de uma Se��o desconhecida atualmente j� existente no Protheus Server."
		Static STR0029 := "Este nome de Se��o para Processos Comuns n�o � v�lido, pois trata-se de uma Configura��o de Host atualmente j� existente no Protheus Server."
		Static STR0030 := "Este nome de Se��o para Processos Comuns n�o � v�lido, pois trata-se de uma Configura��o de Driver de Conex�o j� existente no Protheus Server."
		Static STR0031 := "Este Se��o para Processos Comuns j� est� cadastrada no Protheus Server."
		Static STR0032 := "Este nome de Se��o para Processos Comuns n�o � v�lido, pois trata-se de uma chave reservada de configura��o do Protheus Server."
		#define STR0033  "A quantidade de Inst�ncias n�o pode ser zero."
		#define STR0034  "A quantidade de Inst�ncias n�o pode ser menor que zero."
		Static STR0035 := "O Nome da Fun��o ADVPL deve ser informado."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "(seleccione o ambiente)"
			STR0002 := "Confirma a elimina��o do processo ["
			STR0003 := "] do ficheiro de configura��es ? "
			STR0004 := "A sec��o ["
			STR0005 := "] foi eliminada com sucesso."
			STR0006 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0007 := "Configura��es Da Sec��o"
			STR0008 := "Assistente De Configura��o De Processos Comuns"
			STR0009 := "Nome Do Trabalho"
			STR0010 := "fun��o advpl"
			STR0014 := "Instalar Job No Iniciar Do Servidor Protheus"
			STR0016 := "Seleccione Um Ambiente Para A Execu��o Deste Job"
			STR0017 := "Aten��o : n�o foi poss�vel verificar a exist�ncia da fun��o ["
			STR0019 := "Aten��o : a fun��o ["
			STR0021 := "Confirma a inclus�o deste jobs ? "
			STR0022 := "Confirma a grava��o deste jobs ? "
			STR0023 := "Configura��es do processo ["
			STR0024 := "] actualizadas com sucesso."
			STR0025 := "O nome da sec��o para processos comuns deve ser especificado."
			STR0026 := "Este Nome De Sec��o Para Processos Comuns N�o � V�lido, Pois Trata-se De Uma Configura��o De Ambiente J� Existente no Protheus Server."
			STR0027 := "Este Nome De Sec��o Para Processos Comuns  N�o � V�lido, Pois Trata-se De Uma Configura��o De Trabalho J� Existente no Protheus Server ."
			STR0028 := "Este Nome De Sec��o Para Processos Comuns N�o � V�lido, Pois Trata-se De Uma Sec��o Desconhecida Actualmente, J� Existente No Protheus Server ."
			STR0029 := "Este nome de sec��o para processos comuns n�o � v�lido, pois trata-se de uma Configura��o de Host actualmente j� existente no Protheus Server ."
			STR0030 := "Este nome de Sec��o para Processos Comuns n�o � v�lido, pois trata-se de uma Configura��o de Percursor de Liga��o j� existente no Protheus Server ."
			STR0031 := "Esta Sec��o para Processos Comuns j� est� registada no Protheus Server."
			STR0032 := "Este nome de Sec��o para Processos Comuns n�o � v�lido, pois trata-se de uma chave reservada de configura��o do Protheus Server."
			STR0035 := "O nome da fun��o advpl deve ser introduzido."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF