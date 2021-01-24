#ifdef SPANISH
	#define STR0001 "Mantenimiento de Apunte de Horas"
	#define STR0002 "Apunte de Horas"
	#define STR0003 "Buscar"
	#define STR0004 "Visualizar"
	#define STR0005 "Incluir"
	#define STR0006 "Modificar"
	#define STR0007 "Borrar"
	#define STR0008 "El apunte no puede modificarse/borrarse, ya que tiene factura."
	#define STR0009 "El apunte no puede modificarse/borrarse, ya que tiene factura previa."
	#define STR0010 "No se encontro ningun asunto registrado"
	#define STR0011 "No se encontro ningun contrato registrado o esta fuera de vigencia en la fecha."
	#define STR0012 "Cotizacion de Moneda no registrada para esta fecha"
	#define STR0013 "Cotizacion de Moneda esta nula para esta fecha"
	#define STR0014 "Cantidad en minutos menor que la minima permitida"
	#define STR0015 "Apuntes del dia superan 24 horas"
	#define STR0016 "Los campos Asunto, Timekeeper, Localidad y Area de Practica deben rellenarse antes de apuntarse las horas."
	#define STR0017 "No puede apuntarse mas de 24 horas en un unico apunte"
	#define STR0018 "Cantidad de horas/minutos del apunte invalida."
	#define STR0019 "Asunto :"
	#define STR0020 "Contrato :"
	#define STR0021 "El apunte no puede modificarse, pues tiene rectificacion manual."
	#define STR0022 " El Asunto no admite apuntes en la fecha. "
	#define STR0023 " Contrato fuera de vigencia en la fecha."
	#define STR0024 "El apunte no puede modificarse/borrarse, ya que se genero por prorrateo."
	#define STR0025 "El apunte no puede modificarse/borrarse, pues se genero por aplazamiento."
	#define STR0026 "El apunte no puede modificarse/borrarse, ya que se genero por division."
	#define STR0027 "El apunte no puede modificarse/borrarse, pues se prorrateo, prorrogo o dividio."
	#define STR0028 "El apunte no puede modificarse/borrarse, pues se importo de Carpe Diem."
	#define STR0029 "�Confirma borrado ?"
	#define STR0032 "El apunte tiene rectificacion(es), que tambien se borrara(n)."
	#define STR0033 "Rectificaciones"
	#define STR0035 "Leyenda"
	#define STR0036 "Estatus de Apuntes"
	#define STR0037 "Pendiente"
	#define STR0038 "En Factura previa"
	#define STR0039 "Facturado"
	#define STR0040 "No podra borrarse el apunte, pues se prorrateo, aplazo o fracciono, y uno o mas descencientes ya forman parte de la factura previa."
	#define STR0041 "El apunte tiene prorrateos, aplazamientos o divisiones, que tambi�n se borrar�n."
	#define STR0042 "Hay problemas con la valorizacion."
#else
	#ifdef ENGLISH
		#define STR0001 "Maintenance of Annotation of Hours"
		#define STR0002 "Annotation of Hours"
		#define STR0003 "Search"
		#define STR0004 "View"
		#define STR0005 "Include"
		#define STR0006 "Alter"
		#define STR0007 "Delete"
		#define STR0008 "Annotation cannot be modified/deleted because it has an invoice. "
		#define STR0009 "Annotation cannot be modified/deleted because it has a pre-invoice. "
		#define STR0010 "No registered subject was found"
		#define STR0011 "No registered contract was found or it is outside the expiry date."
		#define STR0012 "Currency Quotation not registered for the date"
		#define STR0013 "Exchange rate is zero for this date "
		#define STR0014 "Quantity in minutes lower than minimum allowed "
		#define STR0015 "Day annotations exceed 24 hours "
		#define STR0016 "The fields Subject, Timekeeper, Location and Practice Area must be entered before annotating the hours.    "
		#define STR0017 "Not more than 24 hourse can be annotated in a single annotation"
		#define STR0018 "Invalid number of hours/minutes of annotation. "
		#define STR0019 "Subject: "
		#define STR0020 "Agreement:"
		#define STR0021 "Annotation cannot be changed because it has manual modification.  "
		#define STR0022 " The topic does not allow annotations on the date"
		#define STR0023 "Contract outside validity on ."
		#define STR0024 "Annotation cannot be modified/deleted because an apportionment has been generated."
		#define STR0025 "Annotation cannot be modified/deleted because an advance has been generated."
		#define STR0026 "Annotation cannot be modified/deleted because it has been generated by division."
		#define STR0027 "Annotation cannot be modified/deleted because it has been apportioned, put off or divided."
		#define STR0028 "Annotation cannot be modified/deleted because it has been imported from Carpe Diem."
		#define STR0029 "Confirm deletion ?"
		#define STR0032 "Annotation has correction(s) which too will be deleted."
		#define STR0033 "Corrections"
		#define STR0035 "Caption"
		#define STR0036 "Annotation status "
		#define STR0037 "Pending "
		#define STR0038 "In pre-invoice"
		#define STR0039 "Billed "
		#define STR0040 "Annotation cannot be deleted because it was apportioned, held or split and one or more are part of the pre-invoice. "
		#define STR0041 "Annotation has apportionments, holdovers or splits to be deleted, too. "
		#define STR0042 "Problems valuing. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Manuten��o De Registos De Horas", "Manuten��o de Apontamentos de Horas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Registo De Horas", "Apontamento de Horas" )
		#define STR0003 "Pesquisar"
		#define STR0004 "Visualizar"
		#define STR0005 "Incluir"
		#define STR0006 "Alterar"
		#define STR0007 "Excluir"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "O apontamento n�o pode ser alterado/exclu�do, pois possui factura.", "O apontamento n�o pode ser alterado/exclu�do, pois possui fatura." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "O apontamento n�o pode ser alterado/exclu�do, pois possui factura proforma.", "O apontamento n�o pode ser alterado/exclu�do, pois possui pr�-fatura." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "N�o foi encontrado nenhum assunto registado", "N�o foi encontrado nenhum assunto cadastrado" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o foi encontrado nenhum contrato registado ou est� fora de vig�ncia na data.", "N�o foi encontrado nenhum contrato cadastrado ou est� fora de vigencia na data." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Cota��o da moeda n�o registada para esta data", "Cota��o da Moeda n�o cadastrada para esta data" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Cota��o da moeda est� nula para esta data", "Cota��o da Moeda est� nula para esta data" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Quantidade em minutos menor que a m�nima permitida", "Quantidade em minutos menor que a minima permitida" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Registos do dia ultrapassaram 24 horas", "Apontamentos do dia ultrapassaram 24 horas" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Os campos assunto, timekeeper, localidade e �rea de pr�tica devem estar preenchidos antes de se apontar as horas.", "Os campos Assunto, Timekeeper, Localidade e �rea de Pr�tica devem estar preenchidos antes de se apontar as horas." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "N�o se pode apontar mais que 24 horas num �nico registo", "N�o se pode apontar mais que 24 horas em um �nico apontamento" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Quantidade de horas/minutos do registo inv�lida.", "Quantidade de horas/minutos do apontamento inv�lida." )
		#define STR0019 "Assunto :"
		#define STR0020 "Contrato :"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "O registo n�o pode ser alterado pois possui rectifica��o manual.", "O apontamento n�o pode ser alterado, pois possui retifica��o manual." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "O assunto n�o aceita registos na data. ", " O Assunto n�o aceita apontamentos na data. " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Contrato fora de vig�ncia na data.", " Contrato fora de vig�ncia na data." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "O apontamento n�o pode ser alterado/exclu�do, pois foi criado por rateio.", "O apontamento n�o pode ser alterado/exclu�do, pois foi gerado por rateio." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "O apontamento n�o pode ser alterado/exclu�do, pois foi criado por adiamento.", "O apontamento n�o pode ser alterado/exclu�do, pois foi gerado por adiamento." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "O apontamento n�o pode ser alterado/exclu�do, pois foi criado por divis�o.", "O apontamento n�o pode ser alterado/exclu�do, pois foi gerado por divis�o." )
		#define STR0027 "O apontamento n�o pode ser alterado/exclu�do, pois foi rateado, adiado ou dividido."
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "O Apontamento N�o Pode Ser Alterado/exclu�do, Pois Foi Importado Do Carpe Diem.", "O apontamento n�o pode ser alterado/exclu�do, pois foi importado do Carpe Diem." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Cofacturairma elimina��o ?", "Confirma exclus�o ?" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "O registo possui rectificac�o(�es), que tamb�m ser�(�o) eliminada(s).", "O apontamento possui retifica��o(�es), que tamb�m ser�(�o) exclu�da(s)." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Rectifica��es", "Retifica��es" )
		#define STR0035 "Legenda"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Estado De Apontamentos", "Status de Apontamentos" )
		#define STR0037 "Em Aberto"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Em Factura Proforma", "Em Pr�-Fatura" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Facturado", "Faturado" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "O registo n�o pode ser exclu�do, pois foi rateado, adiado ou dividido, e um ou mais descendentes j� faz parte de factura proforma.", "O apontamento n�o pode ser excu�do, pois foi rateado, adiado ou dividido, e um ou mais descendentes j� faz parte de pr�-fatura." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "O registo possu� rateios,adiamentos ou divis�es, que tamb�m ser�(�o) exclu�do(s).", "O apontamento possui rateios,adiamentos ou divis�es, que tamb�m ser�(�o) exclu�do(s)." )
		#define STR0042 "Existem problemas com a valoriza��o."
	#endif
#endif
