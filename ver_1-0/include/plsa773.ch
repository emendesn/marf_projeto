#ifdef SPANISH
	#define STR0001 "�No es posible modificar protocolos finalizados!"
	#define STR0002 "Estatus"
	#define STR0003 "E-mail no valido"
	#define STR0004 "�Para enviar un e-mail se debe insertar el e-mail del destinatario correctamente!"
	#define STR0005 "Datos del protocolo"
	#define STR0006 "Cerrar pantalla"
	#define STR0007 "No se encontro criticas para este procedimiento."
	#define STR0008 "Desea generar la Justificativa de Negativa del protocolo: "
	#define STR0009 "�Atencion!"
	#define STR0010 "El archivo de configuracion:"
	#define STR0011 "�No fue encontrado por el servidor!"
	#define STR0012 "El directorio temporal de la estacion no se ha validado:"
	#define STR0013 "Los archivos temporales se grabaran en el directorio:"
	#define STR0014 "Procesamiento anulado"
	#define STR0015 "Hubo un problema con la copia de los archivos de configuracion:"
	#define STR0016 "Iniciando el procesamiento..."
	#define STR0017 "Espere"
	#define STR0018 "Total de Justificativas de Negativas generadas: "
	#define STR0019 "�Desea imprimir el archivo?"
	#define STR0020 "Archivo enviado para imprimir..."
	#define STR0021 "Desea enviar la Justificativa al e-mail: "
	#define STR0022 "E-mail con la Justificativa adjunta enviado con exito..."
	#define STR0023 "E-mail no encontrado en el registro de protocolos..."
	#define STR0024 "Problemas al enviar el e-mail al Usuario. Entre en contacto con el administrador."
	#define STR0025 "Numero de protocolo: "
	#define STR0026 "Nro. Formulario de atencion"
	#define STR0027 "Beneficiario"
	#define STR0028 "Contacto"
	#define STR0029 "Fecha y Hora Protocolo"
	#define STR0030 "�No existen Negativas para esta atencion!"
	#define STR0031 "�No existe atencion con este numero!"
	#define STR0032 "�Problema! �Negativas no encontradas !!!"
	#define STR0033 "�Problema! �Formulario no encontrado!"
	#define STR0034 "Justificativa de Negativas de cobertura - Protocolo: "
	#define STR0035 "Exclusivo para entorno Windows"
	#define STR0036 "Documento no encontrado en el camino: "
	#define STR0037 "Falla a crear el objeto OLE para conectar con WinWord"
	#define STR0038 "Retorno del punto de entrada PL773OBS"
	#define STR0039 "Verifique c�mo debe ser el retorno de la funci�n"
	#define STR0040 "en la documentaci�n disponible en el TDN."
	#define STR0041 "inv�lido"
#else
	#ifdef ENGLISH
		#define STR0001 "It is not possible to change Closed Protocols!!!"
		#define STR0002 "Status"
		#define STR0003 "Invalid E-mail"
		#define STR0004 "To send an e-mail, you must add the Recipient e-mail correctly!!!"
		#define STR0005 "Protocol Data"
		#define STR0006 "Close Screen"
		#define STR0007 "Criticism not found for the procedure."
		#define STR0008 "Do you want to generate the Negative Justification of the protocol: "
		#define STR0009 "Attention"
		#define STR0010 "Configuration file:"
		#define STR0011 "was not found by the server!!!"
		#define STR0012 "Temporary directory of the Station not validated:"
		#define STR0013 "Temporary files are recorded on the directory:"
		#define STR0014 "Processing Canceled"
		#define STR0015 "There was a problem with the copy of configuration files:"
		#define STR0016 "Starting processing..."
		#define STR0017 "Wait"
		#define STR0018 "Total of Negative Justifications generated: "
		#define STR0019 "Do you wish to print the file?"
		#define STR0020 "File sent to print..."
		#define STR0021 "Do you want to send the Justification for the e-mail: "
		#define STR0022 "E-mail with attached Justification  successfully sent..."
		#define STR0023 "E-mail not found in Protocols register..."
		#define STR0024 "Problems sending e-mail to User. Contact the Administrator."
		#define STR0025 "Protocol Number: "
		#define STR0026 "Service Form No."
		#define STR0027 "Beneficiary"
		#define STR0028 "Contact"
		#define STR0029 "Protocol Date and Time"
		#define STR0030 "There are no Negatives for this Service!!!"
		#define STR0031 "There is no Service with this number!!!"
		#define STR0032 "Problem!!! Negatives not found!!!"
		#define STR0033 "Problem!!! Form not found!!!"
		#define STR0034 "Coverage Negatives Justification - Protocol: "
		#define STR0035 "For Windows environment only"
		#define STR0036 "Document not found in path: "
		#define STR0037 "Failure when creating the OLE object to converse with WinWord"
		#define STR0038 "Return of PL773OBS entry point"
		#define STR0039 "Check how to return function"
		#define STR0040 "in documentation available at TDN."
		#define STR0041 "Invalid"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel alterar Protocolos Encerrados.", "N�o � poss�vel alterar Protocolos Encerrados !!!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "E-mail inv�lido", "E-mail Inv�lido" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Para o envio de e-mail, deve-se inserir o E-mail do Destinat�rio correctamente.", "Para o envio de e-mail deve-se inserir o E-mail do Destinat�rio corretamente !!!" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Dados do protocolo", "Dados do Protocolo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Fechar ecr�", "Fechar Tela" )
		#define STR0007 "N�o encontrado cr�ticas para o procedimento."
		#define STR0008 "Deseja gerar a Justificativa de Negativa do protocolo: "
		#define STR0009 "Aten��o"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "O ficheiro de configura��o:", "O arquivo de configura��o:" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "n�o foi encontrado pelo Servidor.", "n�o foi encontrado pelo Servidor!!!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "N�o foi validado o direct�rio tempor�rio da Esta��o:", "N�o foi validado o diret�rio tempor�rio da Esta��o:" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Os ficheiros tempor�rios ser�o gravados no direct�rio:", "Os arquivos tempor�rios ser�o gravados no diret�rio:" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Processamento cancelado", "Processamento Cancelado" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Houve um problema com a c�pia dos ficheiros de configura�ao:", "Houve um problema com a c�pia dos arquivos de configura�ao:" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A iniciar o processamento...", "Iniciando o processamento..." )
		#define STR0017 "Aguarde"
		#define STR0018 "Total de Justificativas de Negativas geradas: "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Deseja imprimir o ficheiro?", "Deseja Imprimir o Arquivo ?" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Ficheiro enviado para impress�o...", "Arquivo enviado para impressao..." )
		#define STR0021 "Deseja enviar a Justificativa para o e-mail: "
		#define STR0022 "E-mail com a Justificativa em anexo enviado com sucesso..."
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "E-mail n�o encontrado no registo de Protocolos...", "E-mail n�o encontrado no cadastro de Protocolos..." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Problemas ao enviar o e-mail ao utilizador. Entre em contacto com o administrador.", "Problemas ao enviar o e-mail ao Usu�rio. Entre em contato com o administrador." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "N�mero protocolo.: ", "N�mero Protocolo.: " )
		#define STR0026 "N� Guia Atendimento"
		#define STR0027 "Benefici�rio"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Contacto", "Contato" )
		#define STR0029 "Data e Hora Protocolo"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "N�o existem negativas para este atendimento.", "N�o existem Negativas para este Atendimento !!!" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "N�o existe atendimento com este n�mero.", "N�o existe Atendimento com este n�mero !!!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Problema! Negativas n�o encontradas.", "Problema !!! Negativas n�o encontradas !!!" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Problema! Guia n�o encontrada.", "Problema !!! Guia n�o encontrada !!!" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Justificativa de negativas de cobertura - Protocolo: ", "Justificativa de Negativas de Cobertura - Protocolo: " )
		#define STR0035 "Exclusivo para ambiente Windows"
		#define STR0036 "Documento n�o encontrado no caminho: "
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Falha ao criar o objecto OLE para conversar com WinWord", "Falha ao criar o objeto OLE para conversar com WinWord" )
		#define STR0038 "Retorno do ponto de entrada PL773OBS"
		#define STR0039 "Verifique como deve ser o retorno da fun��o"
		#define STR0040 "na documenta��o dispon�vel no TDN."
		#define STR0041 "inv�lido"
	#endif
#endif
