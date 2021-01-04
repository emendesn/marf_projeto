#ifdef SPANISH
	#define STR0001 "Escala de vehículos"
	#define STR0002 "Escala de vehículos"
	#define STR0003 "Escala de vehículos"
	#define STR0004 "Servicio"
	#define STR0005 "INCLUIR"
	#define STR0006 "MODIFICAR"
	#define STR0007 "BORRAR"
	#define STR0008 "COPIAR"
	#define STR0010 "Copiar"
	#define STR0011 "Escala origen:"
	#define STR0012 "Sector origen:"
	#define STR0013 "Escala destino:"
	#define STR0014 "Sector destino:"
	#define STR0015 "Anular"
	#define STR0017 "Ya existe una escala creada con este código, la copia no se efectuará."
	#define STR0019 "Los días seleccionados no son compatibles con los días de servicio, ¡Por favor verifique!"
	#define STR0020 'VISUALIZAR'
	#define STR0021 "Buscar"
	#define STR0022 "Copia efectuada con éxito."
	#define STR0023 "Copia"
	#define STR0024 "No se pudo efectuar la copia de la escala."
	#define STR0025 "Código"
	#define STR0026 "Sector"
	#define STR0027 "Desc. Sector"
	#define STR0028 "Lun"
	#define STR0029 "Lunes"
	#define STR0030 "Mar"
	#define STR0031 "Martes"
	#define STR0032 "Miér"
	#define STR0033 "Miércoles"
	#define STR0034 "Juev"
	#define STR0035 "Jueves"
	#define STR0036 "Vier"
	#define STR0037 "Viernes"
	#define STR0038 "Sáb"
	#define STR0039 "Sábado"
	#define STR0040 "Dom"
	#define STR0041 "Domingo"
	#define STR0042 "Escala actualizada"
	#define STR0043 "Escala desactualizada"
	#define STR0044 "Vehículos por escala"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicle Scale"
		#define STR0002 "Vehicle Scale"
		#define STR0003 "Vehicle Scale"
		#define STR0004 "Service"
		#define STR0005 "ADD"
		#define STR0006 "EDIT"
		#define STR0007 "DELETE"
		#define STR0008 "COPY"
		#define STR0010 "Copy"
		#define STR0011 "Source Scale:"
		#define STR0012 "Source Sector:"
		#define STR0013 "Destination Scale:"
		#define STR0014 "Destination Sector:"
		#define STR0015 "Cancel"
		#define STR0017 "There is already a scale created with this code, copy will not be performed."
		#define STR0019 "Days selected are not compatible with service days, please verify!."
		#define STR0020 'VIEW'
		#define STR0021 "Search"
		#define STR0022 "Successfully copied."
		#define STR0023 "Copy"
		#define STR0024 "Unable to copy scale."
		#define STR0025 "Code"
		#define STR0026 "Sector"
		#define STR0027 "Sector Desc."
		#define STR0028 "Mon"
		#define STR0029 "Monday"
		#define STR0030 "Tue"
		#define STR0031 "Tuesday"
		#define STR0032 "Wed"
		#define STR0033 "Wednesday"
		#define STR0034 "Thu"
		#define STR0035 "Thursday"
		#define STR0036 "Fri"
		#define STR0037 "Friday"
		#define STR0038 "Sat"
		#define STR0039 "Saturday"
		#define STR0040 "Sun"
		#define STR0041 "Sunday"
		#define STR0042 "Scale Updated"
		#define STR0043 "Scale Out-of-date"
		#define STR0044 "Vehicles by Scale"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Escala de Veículos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Escala de Veículos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Escala de Veículos" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Horários" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "INCLUIR" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "ALTERAR" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "EXCLUIR" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "COPIAR" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Copiar" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Escala Origem:" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Setor Origem:" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Escala Destino:" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Setor Destino:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Cancelar" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Já existe uma escala criada com esse código. Informe outro código e tente novamente." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "A frequência selecionada não é compatível com a frequência do Horário. Verifique e tente novamente." )
		#define STR0020 'VISUALIZAR'
		#define STR0021 "Pesquisar"
		#define STR0022 "Cópia efetuada com sucesso."
		#define STR0023 "Cópia"
		#define STR0024 "Não foi possível efetuar a cópia da escala."
		#define STR0025 "Código"
		#define STR0026 "Setor"
		#define STR0027 "Desc. Setor"
		#define STR0028 "Seg"
		#define STR0029 "Segunda-Feira"
		#define STR0030 "Ter"
		#define STR0031 "Terça-Feira"
		#define STR0032 "Qua"
		#define STR0033 "Quarta-Feira"
		#define STR0034 "Qui"
		#define STR0035 "Quinta-Feira"
		#define STR0036 "Sex"
		#define STR0037 "Sexta-Feira"
		#define STR0038 "Sab"
		#define STR0039 "Sábado"
		#define STR0040 "Dom"
		#define STR0041 "Domingo"
		#define STR0042 "Escala Atualizada"
		#define STR0043 "Escala Desatualizada"
		#define STR0044 "Veículos por Escala"
	#endif
#endif
