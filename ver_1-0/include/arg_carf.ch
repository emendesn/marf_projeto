#ifdef SPANISH
	#define STR0001 "Estandar de contribuyentes con alto riesgo fiscal"
	#define STR0002 "Para usar la rutina de importacion del archivo de contribuyentes, es necesaria la actualizacion del entorno por el compatibilizador UPDARGCARF."
	#define STR0003 "Importacion"
	#define STR0004 "Seleccion del archivo de contribuyentes"
	#define STR0005 "Parametros"
	#define STR0006 "Archivo de contribuyentes"
	#define STR0007 "¿Desea anular el procesamiento del archivo de contribuyentes ?"
	#define STR0008 "Anular el procesamiento"
	#define STR0009 "Salir"
	#define STR0010 "Procesar archivo informado"
	#define STR0011 "Informe el archivo de contribuyentes"
	#define STR0012 "Archivo"
	#define STR0013 "no encontrado"
	#define STR0014 "Confirma el procesamiento del archivo de contribuyentes"
	#define STR0015 "Procesando el archivo de contribuyentes"
	#define STR0016 "Contribuyentes"
	#define STR0017 "Proceso finalizado"
	#define STR0018 "No se pudo abrir el archivo de contribuyentes"
	#define STR0019 "Actualizando la alicuota de percepcion para proveedores"
	#define STR0020 "Verificacion de los clientes considerados de alto riesgo fiscal"
	#define STR0021 "Aguarde"
	#define STR0022 "Verificacion de los proveedores considerados de alto riesgo fiscal"
	#define STR0023 "Preparando el archivo de Empresas x Zonas fiscales"
	#define STR0024 "Verificacion de los clientes que dejaron la condicion de alto riesgo fiscal"
	#define STR0025 "Verificacion de los proveedores que dejaron la condicion de alto riesgo fiscal"
#else
	#ifdef ENGLISH
		#define STR0001 "Standard of taxpayers with fiscal high risk"
		#define STR0002 "To use import routine of taxpayer file, UPDARGCARF compatibility program must update the environment."
		#define STR0003 "Import"
		#define STR0004 "Selection of taxpayer file"
		#define STR0005 "Parameters"
		#define STR0006 "Taxpayer file"
		#define STR0007 "Do you want to cancel processing of taxpayer file?"
		#define STR0008 "Cancel processing"
		#define STR0009 "Exit"
		#define STR0010 "Process indicated file"
		#define STR0011 "Indicate taxpayer file"
		#define STR0012 "File"
		#define STR0013 "not found"
		#define STR0014 "Do you confirm processing of taxpayer file?"
		#define STR0015 "Processing taxpayer file"
		#define STR0016 "Taxpayers"
		#define STR0017 "Finished process"
		#define STR0018 "Opening taxpayer was not possible"
		#define STR0019 "Updating perception rate for suppliers"
		#define STR0020 "Checking customers considered fiscal high risk"
		#define STR0021 "Wait"
		#define STR0022 "Checking suppliers considered fiscal high risk"
		#define STR0023 "Preparing file Companies x fiscal Zones"
		#define STR0024 "Checking customers that are not fiscal high risk anymore"
		#define STR0025 "Checking suppliers that are not fiscal high risk anymore"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Padrão de contribuintes com alto risco fiscal", "Padrao de contribuintes com alto risco fiscal" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Para utilizar a rotina de importação do ficheiro de contribuintes, é necessária a actualização do ambiente pelo compatibilizador UPDARGCARF.", "Para usar a rotina de importacao do arquivo de contribuintes, e necessaria a atualizacao do ambiente pelo compatibilizador UPDARGCARF." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Importação", "Importacao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Selecção do ficheiro de contribuintes", "Selecao do arquivo de contribuintes" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Parâmetros", "Parametros" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Ficheiro de contribuintes", "Arquivo de contribuintes" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Deseja cancelar o processamento do ficheiro de contribuintes?", "Deseja cancelar o processamento do arquivo de contribuintes ?" )
		#define STR0008 "Cancelar o processamento"
		#define STR0009 "Sair"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Processar ficheiro informado", "Processar arquivo informado" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Informe o ficheiro de contribuintes", "Informe o arquivo de contribuintes" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Ficheiro", "Arquivo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "não encontrado", "nao encontrado" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Confirma o processamento do ficheiro de contribuintes", "Confirma o processamento do arquivo de contribuintes" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "A processar o ficheiro de contribuintes", "Processando o arquivo de contribuintes" )
		#define STR0016 "Contribuintes"
		#define STR0017 "Processo encerrado"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Não foi possível abrir o ficheiro de contribuintes", "Nao foi possível abrir o arquivo de contribuintes" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "A actualizar a alíquota de percepção para fornecedores", "Atualizando a aliquota de percepcao para fornecedores" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Verificação dos clientes considerados de alto risco fiscal", "Verificacao dos clientes considerados de alto risco fiscal" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Aguarde...", "Aguarde" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Verificação dos fornecedores considerados de alto risco fiscal", "Verificacao dos fornecedores considerados de alto risco fiscal" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "A preparar o ficheiro de Empresas x Zonas fiscais", "Preparando o arquivo de Empresas x Zonas fiscais" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Verificação dos clientes que deixaram a condição de alto risco fiscal", "Verificacao dos clientes que deixaram a condição de alto risco fiscal" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Verificação dos fornecedores que deixaram a condição de alto risco fiscal", "Verificacao dos fornecedores que deixaram a condição de alto risco fiscal" )
	#endif
#endif
