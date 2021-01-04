#ifdef SPANISH
	#define STR0001 "Lotes financieros"
	#define STR0002 "Procesado"
	#define STR0003 "RED"
	#define STR0004 "GREEN"
	#define STR0005 "Por procesar"
	#define STR0006 "Ajusta lote"
	#define STR0007 "Visualizar"
	#define STR0008 "Procesa lote"
	#define STR0009 "Actualización de la ficha"
	#define STR0010 " ya se procesó "
	#define STR0011 "Help"
	#define STR0012 "Actualización de la ficha"
	#define STR0013 " Se procesó correctamente"
	#define STR0014 "Help"
	#define STR0015 " ya se procesó "
	#define STR0016 "Help"
	#define STR0017 "GTP asiento financ. Bj.pagar"
	#define STR0018 "Título pagar"
	#define STR0019 "Título cobrar"
	#define STR0020 "GA015Ajust"
	#define STR0021 "GV015Visua"
	#define STR0022 "GI015Proce"
	#define STR0023 "El lote "
#else
	#ifdef ENGLISH
		#define STR0001 "Finance Batches"
		#define STR0002 "Processed"
		#define STR0003 "RED"
		#define STR0004 "GREEN"
		#define STR0005 "Processing"
		#define STR0006 "Adjust Batch"
		#define STR0007 "View"
		#define STR0008 "Process Lot"
		#define STR0009 "Form Update"
		#define STR0010 " already Processed "
		#define STR0011 "Help"
		#define STR0012 "Form Update"
		#define STR0013 " successfully Processed"
		#define STR0014 "Help"
		#define STR0015 " already Processed "
		#define STR0016 "Help"
		#define STR0017 "GTP Financ. Entry Payable W-OFF"
		#define STR0018 "Payable Bill"
		#define STR0019 "Receivable Bill"
		#define STR0020 "GA015Ajust"
		#define STR0021 "GV015Visua"
		#define STR0022 "GI015Proce"
		#define STR0023 "Batch "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Lotes Financeiros" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Processado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "RED" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "GREEN" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Á Processar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Ajustar Lote" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Processar Lote" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Atualização da Ficha" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , " já foi Processado " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Help" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Atualização da Ficha" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , " foi Processado com Sucesso" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Help" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , " já foi Processado " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Help" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "GTP Lcto Financ. BX.Pagar" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Titulo Pagar" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Titulo Receber" )
		#define STR0020 "GA015Ajust"
		#define STR0021 "GV015Visua"
		#define STR0022 "GI015Proce"
		#define STR0023 "O Lote "
	#endif
#endif
