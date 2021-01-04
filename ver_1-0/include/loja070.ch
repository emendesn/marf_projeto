#ifdef SPANISH
	#define STR0001 "B&usqueda"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar "
	#define STR0006 "Administradoras financieras"
	#define STR0007 "Administradoras"
	#define STR0008 "Confirma"
	#define STR0009 "Reescribe"
	#define STR0010 "Salir   "
	#define STR0011 "�Cuanto al borrado?"
	#define STR0012 "Invalido elegir tipo de administradora con numero de caracteres mayor que el tamano de campo"
	#define STR0013 "Integridad referencial"
	#define STR0014 "Favor informar un Cod. de Administradora diferente, pues ya hay un cliente con este codigo!"
	#define STR0015 "Modelo de Datos Administradora Financiera y Intereses en Tarjeta"
	#define STR0016 "Datos de la Administradora Financiera"
	#define STR0017 "Tasa de Intereses en Tarjeta"
	#define STR0018 "Intervalo de Cuotas ya abarcado."
	#define STR0019 "Seleccione un intervalo no registrado."
	#define STR0020 "Campos de Cuotas con valor invalido."
	#define STR0021 "Digite un valor valido en las cuotas."
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "View      "
		#define STR0003 "Add "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "Financial Administrators "
		#define STR0007 "Administrators "
		#define STR0008 "Confirm"
		#define STR0009 "Retype  "
		#define STR0010 "Quit    "
		#define STR0011 "About deleting?"
		#define STR0012 "Invalid to choose administrator type with number of characters higher than the field size. "
		#define STR0013 "Referencial integrity  "
		#define STR0014 "Please, indicate a Code of a different Administrator because there is already a customer with this code!"
		#define STR0015 "Model of Financial Company Data and Card Interest"
		#define STR0016 "Financial Company Data"
		#define STR0017 "Card Rate Interest"
		#define STR0018 "Interval of Installments already considered."
		#define STR0019 "Select an interval not registered."
		#define STR0020 "Installment fields with invalid value."
		#define STR0021 "Enter a valid value in the installments."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Administradoras Financeiras"
		#define STR0007 "Administradoras"
		#define STR0008 "Confirma"
		#define STR0009 "Redigita"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Quanto � Exclus�o?", "Quanto a Exclus�o?" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Inv�lido escolher tipo de administra��o com n�mero de caracteres maior que o tamanho do campo.", "Invalido escolher tipo de administradora com n�mero de caracteres maior que o tamanho do campo." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Integridade refer�ncial", "Integridade referencial" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Favor informar um C�d. de Administradora diferente, pois j� existe um cliente com este c�digo!", "Favor informar um Cod. de Administradora diferente, pois ja existe um cliente com este codigo!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Modelo de dados administradora financeira e juros em cart�o", "Modelo de Dados Administradora Financeira e Juros em Cartao" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Dados da administradora financeira", "Dados da Administradora Financeira" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Taxa de juros em cart�o", "Taxa de Juros em Cartao" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Intervalo de parcelas j� abrangido.", "Intervalo de Parcelas ja abrangido." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Seleccione um intervalo n�o registado.", "Selecione um intervalo nao cadastrado." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Campos de parcela com valor inv�lido.", "Campos de Parcela com valor invalido." )
		#define STR0021 "Digite um valor v�lido nas parcelas."
	#endif
#endif
