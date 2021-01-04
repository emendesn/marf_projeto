#ifdef SPANISH
	#define STR0001 "Generacion de Documento Fiscal"
	#define STR0002 "Visualizar"
	#define STR0003 "Generar"
	#define STR0004 "¿Confirma la generacion de los documentos fiscales ?"
	#define STR0005 "Generando Doc. Fiscal..."
	#define STR0006 "Ya existen documentos fiscales emitidos con fecha superior a la fecha de la factura "
	#define STR0007 "No existe cotizacion para la moneda "
	#define STR0008 " para el dia "
	#define STR0009 "No fue posible generar doc. fiscal para factura "
	#define STR0010 "Espere"
	#define STR0011 " o la misma esta bloqueada. No se generara documento fiscal para la factura "
	#define STR0012 "Espere... Marcando Registros"
	#define STR0013 "Marcar Todos"
	#define STR0014 "No fue posible generar doc. fiscal para la(s) factura(s), ya que no existe producto y/o TES."
#else
	#ifdef ENGLISH
		#define STR0001 "Generation of Tax Document"
		#define STR0002 "View"
		#define STR0003 "Generate"
		#define STR0004 "Do you confirm the generation of tax documents?"
		#define STR0005 "Generating Tax Doc..."
		#define STR0006 "There are already tax documents issued with date after invoice date "
		#define STR0007 "There is no quotation for the currency "
		#define STR0008 " for the day "
		#define STR0009 "Tax document could not be generated for invoice "
		#define STR0010 "Wait"
		#define STR0011 " or it is locked. Tax document will not be generated for invoice "
		#define STR0012 "Wait... Selecting Records"
		#define STR0013 "Select All"
		#define STR0014 "Tax doc. could not be generated for the invoice(s), because no product and/or TIO exists."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Geração de documento fiscal", "Geração de Documento Fiscal" )
		#define STR0002 "Visualizar"
		#define STR0003 "Gerar"
		#define STR0004 "Confirma a geração dos documentos fiscais ?"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A gerar doc. fiscal...", "Gerando Doc. Fiscal..." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Já existem documentos fiscais emitidos com data superior à data da factura ", "Já existem documentos fiscais emitidos com data superior a data da fatura " )
		#define STR0007 "Não existe cotação para a moeda "
		#define STR0008 " para o dia "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Não foi possível gerar doc. fiscal para factura ", "Não foi possivel gerar doc. fiscal para fatura " )
		#define STR0010 "Aguarde"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " ou a mesma está bloqueada. Não será gerado documento fiscal para a factura ", " ou a mesma esta bloqueada. Não será gerado documento fiscal para a fatura " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Aguarde... A marcar registos", "Aguarde... Marcando Registros" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Marcar todos", "Marcar Todos" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Não foi possível gerar doc. fiscal para a(s) factura(s), pois não existe artigo e/ou TES.", "Não foi possivel gerar doc. fiscal para a(s) fatura(s), pois não existe produto e/ou TES." )
	#endif
#endif
