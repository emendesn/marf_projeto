#ifdef SPANISH
	#define STR0001 "Conferência Mapa de Separação"
	#define STR0002 "RELATORIO"
	#define STR0003 "Mapa"
	#define STR0004 "Conferente"
	#define STR0005 "Separador"
	#define STR0006 "Produto"
	#define STR0007 "Etiqueta"
	#define STR0008 "Embalador"
	#define STR0009 "Quantidade"
	#define STR0010 "Foram encontradas Divergencias na "
	#define STR0011 " Conferencia."
	#define STR0012 "Confere Novamente"
	#define STR0013 "Registra Ocorrencias"
	#define STR0014 "Serviço de conferencia não encontrado!"
	#define STR0015 "Certifique-se que:"
	#define STR0016 "Finalizando a Conferencia."
	#define STR0017 "Aguarde..."
	#define STR0018 "APAGAR ESTE STR"
	#define STR0019 "Microsiga Protheus WMS - LOG de Ocorrencias na Conferencia ("
	#define STR0020 "Log gerado em "
	#define STR0021 ", as "
	#define STR0022 "- O mapa de separação foi gerado;"
	#define STR0023 "- O separador foi atribuido ao mapa consolidado;"
	#define STR0024 "- O status do serviço de conferencia esteja Apto a Executar."
	#define STR0025 "Contagem no.: "
	#define STR0026 "Ocorrencias ("
	#define STR0027 "Ocorrencia :"
	#define STR0028 "Contagem do Sistema"
	#define STR0029 "Contagem do Usuario"
	#define STR0030 "Item"
	#define STR0031 "O LOG "
	#define STR0032 " foi gerado. Entre em contato com seu Supervisor."
	#define STR0033 "Contando Produtos."
	#define STR0034 "Etiqueta invalida !"
	#define STR0035 "O Produto "
	#define STR0036 " nao esta cadastrado. ATENÇÃO: Quando leitura de código de barras, deixe o parâmetro MV_DLCOLET igual a S"
	#define STR0037 "Conferente não autorizado!"
	#define STR0038 "- O endereço de serviço foi atribuido ao mapa consolidado;"
	#define STR0039 "Informe o código do mapa de separação!"
	#define STR0040 "Informe um embalador!"
	#define STR0041 "Recurso "
	#define STR0042 " não cadastrado! (DCD)"
	#define STR0043 "Exitem itens do mapa de separação "
	#define STR0044 " que não estão aptos a conferir!"
	#define STR0045 "O produto "
	#define STR0046 " não pertence ao mapa de separação!"
#else
	#ifdef ENGLISH
		#define STR0001 "Separation Map Check"
		#define STR0002 "REPORT"
		#define STR0003 "Map"
		#define STR0004 "Checking clerk"
		#define STR0005 "Separator"
		#define STR0006 "Product"
		#define STR0007 "Label"
		#define STR0008 "Packer"
		#define STR0009 "Quantity"
		#define STR0010 "Divergences found in "
		#define STR0011 " Checking."
		#define STR0012 "Check it again"
		#define STR0013 "Record Events"
		#define STR0014 "Checking service not found!"
		#define STR0015 "Make sure that:"
		#define STR0016 "Finishing the Checking."
		#define STR0017 "Wait..."
		#define STR0018 "DELETE THIS STR"
		#define STR0019 "Microsiga Protheus WMS - LOG of Occurrences in Checking ("
		#define STR0020 "Log generated in "
		#define STR0021 ", at "
		#define STR0022 "- Separated map created."
		#define STR0023 "- The separator is attributed to the consolidated map."
		#define STR0024 "- The checking service status must be Able to Execute."
		#define STR0025 "Count nr.: "
		#define STR0026 "Occurrences ("
		#define STR0027 "Occurrence:"
		#define STR0028 "System Count"
		#define STR0029 "User Count"
		#define STR0030 "Item"
		#define STR0031 "THE LOG "
		#define STR0032 " is generated. Contact your Supervisor."
		#define STR0033 "Counting Products."
		#define STR0034 "Label not valid!"
		#define STR0035 "Product "
		#define STR0036 " not registered. ATTENTION: For barcode reading, set parameter MV_DLCOLET to S."
		#define STR0037 "Checking clerk not authorized!"
		#define STR0038 "- The service address is attributed to the consolidated map."
		#define STR0039 "Enter code of sorting map!"
		#define STR0040 "Enter a packer!"
		#define STR0041 "Resource "
		#define STR0042 " not registered! (DCD)"
		#define STR0043 "Separation map items exist "
		#define STR0044 " that are not ready to check!"
		#define STR0045 "Product "
		#define STR0046 " does not belong to the separation map!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Conferência Mapa de Separação" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "RELATORIO" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Mapa" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Conferente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Separador" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Etiqueta" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Embalador" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Foram encontradas Divergencias na " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , " Conferencia." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Confere Novamente" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Registra Ocorrencias" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Serviço de conferencia não encontrado!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Certifique-se que:" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Finalizando a Conferencia." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Aguarde..." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "APAGAR ESTE STR" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Microsiga Protheus WMS - LOG de Ocorrencias na Conferencia (" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Log gerado em " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , ", as " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "- O mapa de separação foi gerado;" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "- O separador foi atribuido ao mapa consolidado;" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "- O status do serviço de conferencia esteja Apto a Executar." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Contagem no.: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Ocorrencias (" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Ocorrencia :" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Contagem do Sistema" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Contagem do Usuario" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Item" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "O LOG " )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , " foi gerado. Entre em contato com seu Supervisor." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Contando Produtos." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Etiqueta invalida !" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "O Produto " )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , " nao esta cadastrado. ATENÇÃO: Quando leitura de código de barras, deixe o parâmetro MV_DLCOLET igual a S" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Conferente não autorizado!" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "- O endereço de serviço foi atribuido ao mapa consolidado;" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Informe o código do mapa de separação!" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Informe um embalador!" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Recurso " )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , " não cadastrado! (DCD)" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Exitem itens do mapa de separação " )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , " que não estão aptos a conferir!" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "O produto " )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , " não pertence ao mapa de separação!" )
	#endif
#endif
