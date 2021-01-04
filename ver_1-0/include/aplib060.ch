#ifdef SPANISH
	#define STR0001 "Fecha : "
	#define STR0002 " , Hora: "
	#define STR0003 "Archivo: "
	#define STR0004 "Intentar de nuevo"
	#define STR0005 "Salir"
	#define STR0006 " Atencion "
	#define STR0007 "El registro "
	#define STR0008 " del "
	#define STR0009 " est� en uso."
	#define STR0010 "Usuario : CONSULTE OPERADOR"
	#define STR0011 "Control de transacciones habilitado"
	#define STR0012 "Control de transacciones inhabilitado"
	#define STR0013 "�Y la operacion actual?"
	#define STR0014 "El registro numero "
	#define STR0015 " del archivo "
	#define STR0016 " se encuentra bloqueado por otro usuario."
	#define STR0017 " El numero de conexion es "
	#define STR0018 "en esta operacion"
	#define STR0019 "�Intenta de nuevo? "
	#define STR0020 "Proseguir"
	#define STR0021 "Anular"
	#define STR0022 "Esta operacion ira a deshacer el trabajo realizado"
	#define STR0023 "en la pantalla actual."
	#define STR0024 "El archivo "
	#define STR0025 " tiene 1 registro reservado (Registro "
	#define STR0026 "El archivo "
	#define STR0027 " tiene "
	#define STR0028 " registros reservados "
	#define STR0029 " (Registros "
	#define STR0030 ". Compruebe el programa."
	#define STR0031 "Atencion;"
	#define STR0032 " Consulte el Operador "
	#define STR0033 "Falta MV_LOGSIGA(SX6)"
	#define STR0034 "Probs.Semaforo Transaccion"
	#define STR0035 "El semaforo de transaccion esta demorando para responder. �Intenta de nuevo?"
	#define STR0036 "Esperando liberacion de semaforo"
	#define STR0037 "Este mensaje se cerrara en "
	#define STR0038 " segundos."
	#define STR0039 "La solicitud no puede atenderse por motivo de una violacion de integridad de la Base de datos. La violacion de integridad ocurre cando esta informacion posee vinculos en otras tablas del sistema. Informaciones de la Base de datos: "
	#define STR0040 "Aviso"
	#define STR0041 "ejecutado"
	#define STR0042 "Hay transacciones pendientes"
	#define STR0043 "Si"
	#define STR0044 "No"
	#define STR0045 "Intento de reservar registro en Alias "
	#define STR0046 " en EOF"
	#define STR0047 "Stack de llamadas en MSRLOCK.eof"
	#define STR0048 "Falla al reservar registro durante insercion en Alias "
	#define STR0049 "Nombre del Usuario : "
	#define STR0050 "Comentarios : "
	#define STR0051 "Numero de Codigos Reservados mayor que "
	#define STR0052 "Creando"
	#define STR0053 "Archivo  "
	#define STR0054 "Ordenando campos en el SX3"
#else
	#ifdef ENGLISH
		#define STR0001 "Date : "
		#define STR0002 " ,Time: "
		#define STR0003 "File: "
		#define STR0004 "Try Again"
		#define STR0005 "Cancel"
		#define STR0006 "Attention"
		#define STR0007 "The Record "
		#define STR0008 " of "
		#define STR0009 " is in use."
		#define STR0010 "User: CONSULT OPERATOR"
		#define STR0011 "Authorized Control of transactions"
		#define STR0012 "Not Authorized Control of transactions"
		#define STR0013 "About the current operation?"
		#define STR0014 "The record number "
		#define STR0015 " of File "
		#define STR0016 " is blocked by another User."
		#define STR0017 " The connection number is "
		#define STR0018 "in this operation"
		#define STR0019 "Try again? "
		#define STR0020 "Continue"
		#define STR0021 "Cancel"
		#define STR0022 "This operation will undo the work done"
		#define STR0023 "in the current screen"
		#define STR0024 "The file "
		#define STR0025 " 1 record allocated (Record"
		#define STR0026 "The file "
		#define STR0027 " has "
		#define STR0028 " records allocated "
		#define STR0029 " (Records "
		#define STR0030 ". Check program."
		#define STR0031 "Attention"
		#define STR0032 " Search Operator "
		#define STR0033 "MV_LOGSIGA(SX6) Missing"
		#define STR0034 "Transaction Semaphore Error"
		#define STR0035 "The Transaction Semaphore is not responding. Try again?"
		#define STR0036 "Waiting for the Semaphore Release"
		#define STR0037 "This message will be closed in "
		#define STR0038 " seconds."
		#define STR0039 "The requisition assisted due to an integrity violation on the Database. The integrity violation occurs when this information has links with other system tables. Database information: "
		#define STR0040 "Warning"
		#define STR0041 "running"
		#define STR0042 "There are pending transactions"
		#define STR0043 "Yes"
		#define STR0044 "No"
		#define STR0045 "Trying to reserve record in Alias "
		#define STR0046 " in EOF"
		#define STR0047 "Stack of calls in MSRLOCK.eof"
		#define STR0048 "Failure while saving record during Alias insertion. "
		#define STR0049 "User name:        "
		#define STR0050 "Comments    : "
		#define STR0051 "Number of Codes Reserved is higher than"
		#define STR0052 "Creating"
		#define STR0053 "File    "
		#define STR0054 "Arranging fields in SX3"
	#else
		#define STR0001  "Data : "
		Static STR0002 := " , Hora: "
		Static STR0003 := "Arquivo: "
		#define STR0004  "Tentar novamente"
		#define STR0005  "Abandonar"
		Static STR0006 := " Aten��o "
		Static STR0007 := "O registro "
		#define STR0008  " do "
		Static STR0009 := " esta em uso."
		Static STR0010 := "Usu�rio : CONSULTE OPERADOR"
		Static STR0011 := "Controle de transa��es Habilitado"
		Static STR0012 := "Controle de transa��es Desabilitado"
		Static STR0013 := "Quanto a opera��o corrente ?"
		Static STR0014 := "O registro n�mero "
		Static STR0015 := " do Arquivo "
		Static STR0016 := " encontra-se Bloqueado por outro usu�rio."
		#define STR0017  " O n�mero da conex�o � "
		Static STR0018 := "nesta opera��o"
		#define STR0019  "Tenta novamente ? "
		#define STR0020  "Prosseguir"
		#define STR0021  "Cancelar"
		Static STR0022 := "Esta opera��o ir� desfazer o trabalho feito"
		Static STR0023 := "na tela corrente."
		Static STR0024 := "O arquivo "
		Static STR0025 := " tem 1 registro locado (Registro "
		Static STR0026 := "O arquivo "
		#define STR0027  " tem "
		Static STR0028 := " registros locados "
		Static STR0029 := " (Registros "
		Static STR0030 := ". Verifique o programa."
		#define STR0031  "Aten��o;"
		Static STR0032 := " Consulte Operador "
		Static STR0033 := "Falta MV_LOGSIGA(SX6)"
		Static STR0034 := "Probs.Sem�foro Transa��o"
		#define STR0035  "O Sem�foro de transa��o est� demorando a responder.Tenta Novamente ?"
		Static STR0036 := "Aguardando Libera��o de sem�foro"
		Static STR0037 := "Essa mensagem sera fechada em "
		#define STR0038  " segundos."
		Static STR0039 := "A solicitac�o n�o pode ser atendida devido a uma violac�o de integridade do Banco de dados. A violac�o de integridade ocorre quando esta informac�o possui vinculos em outras tabelas do sistema. Informac�es do Banco de dados: "
		#define STR0040  "Aviso"
		Static STR0041 := "executado"
		Static STR0042 := "Existem transac�es pendentes"
		#define STR0043  "Sim"
		Static STR0044 := "N�o"
		Static STR0045 := "Tentativa de reservar registro no Alias "
		Static STR0046 := " em EOF"
		Static STR0047 := "Stack de chamadas em MSRLOCK.eof"
		Static STR0048 := "Falha ao reservar registro durante inserc�o no Alias "
		Static STR0049 := "Nome do Usuario : "
		Static STR0050 := "Comentarios : "
		Static STR0051 := "N�mero de C�digos Reservados maior que "
		Static STR0052 := "Criando"
		Static STR0053 := "Arquivo "
		Static STR0054 := "Ordenando campos no SX3"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := " , hora: "
			STR0003 := "Ficheiro: "
			STR0006 := " aten��o "
			STR0007 := "O registo "
			STR0009 := " est� em utiliza��o."
			STR0010 := "Utilizador : Consulte Operador"
			STR0011 := "Controle De Transac��es Instalado"
			STR0012 := "Controle De Transac��es Desinstalado"
			STR0013 := "Quanto a opera��o corrente ?"
			STR0014 := "O registo n�mero "
			STR0015 := " do ficheiro "
			STR0016 := " encontra-se bloqueado por outro utilizador."
			STR0018 := "nesta opera��o"
			STR0022 := "Esta opera��o ir� desfazer o trabalho feito"
			STR0023 := "No ecr� corrente."
			STR0024 := "O ficheiro "
			STR0025 := " tem 1 registo localizado (registo "
			STR0026 := "O ficheiro "
			STR0028 := " registos localizados "
			STR0029 := " (registos "
			STR0030 := ". verifique o programa."
			STR0032 := " consulte operador "
			STR0033 := "Falta Mv_logsiga(sx6)"
			STR0034 := "Probs.Sem�foro Transac��o"
			STR0036 := "Aguardando Libera��o de sem�foro"
			STR0037 := "Essa mensagem ser� fechada em "
			STR0039 := 'A solicita��o n�o pode ser atendida devido a uma viola��o de integridade dos Bancos de dados. A viola��o de integridade ocorre quando esta informac�o possui v�nculos em outras tabelas do sistema. Informa��o do banco de dados:'
			STR0041 := "Executado"
			STR0042 := "Existem transac��es pendentes"
			STR0044 := "N�o"
			STR0045 := "Tentativa de reservar registo no ali�s "
			STR0046 := " Em Eof"
			STR0047 := "Armazenamento De Chamadas Em Msrlock.eof"
			STR0048 := "Falha ao reservar registo durante inser��o no ali�s "
			STR0049 := "Nome do utilizador : "
			STR0050 := "Coment�rios : "
			STR0051 := "N�mero de c�digos reservados maior que "
			STR0052 := "A criar"
			STR0053 := "Ficheiro "
			STR0054 := "A Ordenar Campos No Sx3"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
