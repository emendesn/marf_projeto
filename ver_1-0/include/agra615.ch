#ifdef SPANISH
	#define STR0001 "Rendimiento"
	#define STR0002 "Mejora del algodon en semilla"
	#define STR0003 "Datos del fardo grande"
	#define STR0004 "Monitor de la produccion"
	#define STR0005 "Registro de la produccion"
	#define STR0006 "Monitor de rendimiento"
	#define STR0007 "Cosecha"
	#define STR0008 "Productor"
	#define STR0009 "Tienda"
	#define STR0010 "Nombre del productor"
	#define STR0011 "Hacienda"
	#define STR0012 "Nombre de la hacienda"
	#define STR0013 "Variedad"
	#define STR0014 "Descripcion"
	#define STR0015 "Fardo grande"
	#define STR0016 "Peso neto"
	#define STR0017 "Turno"
	#define STR0018 "Fardos beneficiados"
	#define STR0019 "Estandar"
	#define STR0020 "Total fardos"
	#define STR0021 "Total bruto"
	#define STR0022 "Total neto"
	#define STR0023 "Doblado"
	#define STR0024 "Conjunto"
	#define STR0025 "Prensa"
	#define STR0026 "Etiqueta"
	#define STR0027 "Fardo"
	#define STR0028 "Peso bruto"
	#define STR0029 "Guardar"
	#define STR0030 "Limpiar"
	#define STR0031 "Finalizar"
	#define STR0032 "Mejora"
	#define STR0033 "Modificar"
	#define STR0034 "Borrar"
	#define STR0035 "Este fardo grande ya se mejoro �desea reabrir la mejora?"
	#define STR0036 "Atencion"
	#define STR0037 "Solamente pueden mejorarse fardos con estado de [2=En lista de embarque, 3=Disponible o 4=En mejora]"
	#define STR0038 "�Atencion!"
	#define STR0039 "�Conjunto de la etiqueta sin validez o no encontrado en el sistema!"
	#define STR0040 "Etiqueta no valida."
	#define STR0041 "�Ya existe etiqueta registrada con esta numeracion!"
	#define STR0042 "Peso maximo"
	#define STR0043 "�Peso del fardo es superior al m�ximo permitido para este conjunto!"
	#define STR0044 "Peso minimo"
	#define STR0045 "�El peso del fardo es inferior al minimo permitido para este conjunto!"
	#define STR0046 " �Conjunto no valido o no ubicado!"
	#define STR0047 "�Este fardo sobrepasa la capacidad maxima de rendimiento del fardo grande!"
	#define STR0048 "El fardo grande alcanz� el porcentaje maximo de rendimiento. �Desea iniciar un nuevo fardo grande? "
	#define STR0049 "�Codigo del fardo grande no valido o no ubicado!"
	#define STR0050 "�Desea cerrar la mejora de este fardo grande?"
	#define STR0051 "Peso neto invalido"
	#define STR0052 "Fecha de mejora"
	#define STR0053 "Fecha de mejora diferente de la fecha base del sistema. �Desea continuar con la mejora?"
	#define STR0054 "No es posible borrar este fardo, clasificaci�n realizada."
#else
	#ifdef ENGLISH
		#define STR0001 "Yield"
		#define STR0002 "Seed cotton processing"
		#define STR0003 "Bale data"
		#define STR0004 "Production Monitor"
		#define STR0005 "Production Entry"
		#define STR0006 "Revenue Monitor"
		#define STR0007 "Crop"
		#define STR0008 "Producer"
		#define STR0009 "Store"
		#define STR0010 "Producer name."
		#define STR0011 "Farm"
		#define STR0012 "Farm name"
		#define STR0013 "Variety"
		#define STR0014 "Description"
		#define STR0015 "Bale"
		#define STR0016 "Net Weight"
		#define STR0017 "Shift"
		#define STR0018 "Processed Bales"
		#define STR0019 "Standard"
		#define STR0020 "Bales Total"
		#define STR0021 "Gross Total"
		#define STR0022 "Net Total"
		#define STR0023 "Ribbed"
		#define STR0024 "Set"
		#define STR0025 "Press"
		#define STR0026 "Label"
		#define STR0027 "Bale"
		#define STR0028 "Gross Weight"
		#define STR0029 "Save"
		#define STR0030 "Clear"
		#define STR0031 "Close"
		#define STR0032 "Processing"
		#define STR0033 "Edit"
		#define STR0034 "Delete"
		#define STR0035 "This bale has already been processed, do you wan to reopen processing?"
		#define STR0036 "Attention"
		#define STR0037 "Only burdens with state of [2=In Packing List, 3=Available or 4=In processing] can be benefited"
		#define STR0038 "Warning!"
		#define STR0039 "Label assembly invalid or not found in the system!!!"
		#define STR0040 "Invalid label"
		#define STR0041 "There is already a registered label with this numbering!!!"
		#define STR0042 "Maximum Weight"
		#define STR0043 "The bale weight is greater than the maximum value established for this assembly!"
		#define STR0044 "Minimum Weight"
		#define STR0045 "The bale weight is smaller than the minimum value established for this assembly!"
		#define STR0046 "Assembly not valid or not found!"
		#define STR0047 "This bale surpasses the maximum capacity of bale yield!"
		#define STR0048 "The bale reached the yield maximum percentage, do you want to start a new bale? "
		#define STR0049 "Bale code not valid or not found!"
		#define STR0050 "Do you want to Close this bale processing?"
		#define STR0051 "Invalid net weight"
		#define STR0052 "Benefit Date"
		#define STR0053 "Benefit date different from system base date. Proceed with benefit?"
		#define STR0054 "Unable to delete this bale, classification already performed."
	#else
		#define STR0001 "Rendimento"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Beneficiamento de algod�o em caro�o", "Beneficiamento de Algod�o Em Caro�o" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Dados do fardo", "Dados do Fard�o" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Monitor da produ��o", "Monitor da Produ��o" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Lan�amento da produ��o", "Lan�amento da Produ��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Monitor de rendimento", "Monitor de Rendimento" )
		#define STR0007 "Safra"
		#define STR0008 "Produtor"
		#define STR0009 "Loja"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Nome do produtor", "Nome do Produtor" )
		#define STR0011 "Fazenda"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Nome da fazenda", "Nome da Fazenda" )
		#define STR0013 "Variedade"
		#define STR0014 "Descri��o"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Fardo", "Fardao" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Peso l�quido", "Peso Liquido" )
		#define STR0017 "Turno"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Fardos beneficiados", "Fardos Beneficiados" )
		#define STR0019 "Padr�o"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Total fardos", "Total Fardos" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Total bruto", "Total Bruto" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Total l�quido", "Total Liquido" )
		#define STR0023 "Costelado"
		#define STR0024 "Conjunto"
		#define STR0025 "Prensa"
		#define STR0026 "Etiqueta"
		#define STR0027 "Fardo"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Peso bruto", "Peso Bruto" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Gravar", "Salvar" )
		#define STR0030 "Limpar"
		#define STR0031 "Encerrar"
		#define STR0032 "Beneficiamento"
		#define STR0033 "Alterar"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Este fardo j� foi beneficiado. Deseja reabriar o beneficiamento?", "Este fard�o j� foi beneficiado, deseja reabriar o beneficiamento?" )
		#define STR0036 "Aten��o"
		#define STR0037 "Somente fardos com estado de [2=Em Romaneio, 3=Dispon�vel ou 4=Em beneficiamento] podem ser beneficiados"
		#define STR0038 "Aten��o!"
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Conjunto da etiqueta inv�lido ou n�o encontrado no sistema!", "Conjunto da etiqueta inv�lido ou n�o encontrado no sistema!!!" )
		#define STR0040 "Etiqueta inv�lida"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "J� existe etiqueta registada com esta numera��o.", "Ja existe etiqueta cadastrada com esta numera��o!!!" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Peso m�ximo", "Peso Maximo" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Peso da fardo superior ao m�ximo estabelecido para este conjunto.", "O peso da fardo maior que o m�ximo estabelecido para este conjunto!" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Peso m�nimo", "Peso Minimo" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Peso da fardo inferior ao minimo estabelecido para este conjunto.", "O peso da fardo � menor que o minimo estabelecido para este conjunto!" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Conjunto inv�lido ou n�o localizado.", "Conjunto inv�lido ou nao localizado!" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Este fardo ultrapassa a capacidade m�xima de redimento do fardo.", "Este fardo ultrapassa a capacidade m�xima de redimento do fard�o!" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "O fardo atingiu a percentagem m�xima de redimento. Deseja iniciar um novo fard�o? ", "O fard�o atingiu o percentual m�ximo de redimento, Deseja iniciar um novo fard�o? " )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "C�digo do fardo inv�lido ou n�o localizado.", "C�digo do fard�o invalido ou n�o localizado!" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Desaja encerrar o beneficiamento deste fard�o?", "Desaja Encerrar o beneficiamento deste fard�o?" )
		#define STR0051 "Peso liquido inv�lido"
		#define STR0052 "Data Beneficiamento"
		#define STR0053 "Data beneficiamento diferente da data base do sistema. Deseja prosseguir com o beneficiamento?"
		#define STR0054 "N�o � poss�vel excluir esse fardo, classifica��o j� realizada."
	#endif
#endif
