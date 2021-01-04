#ifdef SPANISH
	#define STR0001 "Dirección"
	#define STR0002 "Inf. Producto"
	#define STR0003 "Vaya a la dirección"
	#define STR0004 "¿Desea finalizar el control de ubicación?"
	#define STR0005 "Sí"
	#define STR0006 "No"
	#define STR0007 "Confirme"
	#define STR0008 "Copie el unitizador"
	#define STR0009 "Unitidador"
	#define STR0010 "Vaya a la dirección"
	#define STR0011 "Problema en el control de ubicación."
	#define STR0012 "Tome el producto"
	#define STR0013 "Lote"
	#define STR0014 "Cantidad"
	#define STR0015 "¿Sobrepasó el total!"
	#define STR0016 "Cant."
	#define STR0017 "Unidad p/Ubicar"
	#define STR0018 "Dirección origen [VAR01] incorrecta."
	#define STR0019 "Dirección destino [VAR01] incorrecta."
	#define STR0020 "Unitizador [VAR01] incorrecto."
	#define STR0021 "¿Ubicar actividad con cantidad parcial?"
	#define STR0022 "Nueva dirección"
	#define STR0023 "¿Sustituir la dirección?"
	#define STR0024 "Informe el sublote"
	#define STR0025 "Sublote"
	#define STR0026 "Para modificar la dirección pulse CTRL+J en el campo de confirmación de la dirección destino."
	#define STR0027 "¡Atención!"
	#define STR0028 "Finalizar"
	#define STR0029 "Dirección destino"
	#define STR0030 "Producto recolectado. Solo falta finalizar la actividad."
	#define STR0031 "Modificar dirección"
	#define STR0032 "Para control de ubicación con unitizador la cantidad no puede ser menor que uno."
	#define STR0033 "Total"
	#define STR0034 "Ubicada"
	#define STR0035 "Ubicac. Parcial"
	#define STR0036 "Procesando..."
	#define STR0037 "La actividad está agrupada, no permite movimiento parcial."
	#define STR0038 "El lote [VAR01] no consta en el documento actual."
	#define STR0039 "El sublote [VAR01] no consta en el documento actual."
#else
	#ifdef ENGLISH
		#define STR0001 "Address"
		#define STR0002 "Product Info"
		#define STR0003 "Go to the address"
		#define STR0004 "Do you want to close the Addressing?"
		#define STR0005 "Yes"
		#define STR0006 "No"
		#define STR0007 "Confirm!"
		#define STR0008 "Take the unitizer"
		#define STR0009 "Unitizer"
		#define STR0010 "Take to the address"
		#define STR0011 "Problem in addressing."
		#define STR0012 "Take the product"
		#define STR0013 "Batch"
		#define STR0014 "Quantity"
		#define STR0015 "Total was exceeded!"
		#define STR0016 "Qty."
		#define STR0017 "Unit to Address"
		#define STR0018 "Origin address [VAR01] incorrect."
		#define STR0019 "Destination address [VAR01] incorrect."
		#define STR0020 "Unitizer [VAR01] incorrect."
		#define STR0021 "Address activity with partial quantity?"
		#define STR0022 "New address"
		#define STR0023 "Replace address?"
		#define STR0024 "Enter the Sub Lot"
		#define STR0025 "Sub-Batch"
		#define STR0026 "To edit address press CRTL+J on destination address confirmation!"
		#define STR0027 "Attention!"
		#define STR0028 "Close"
		#define STR0029 "Destination address"
		#define STR0030 "Product already collected. You must only close the activity."
		#define STR0031 "Change address"
		#define STR0032 "For addressing with unitizer quantity cannot be lower than one."
		#define STR0033 "Total"
		#define STR0034 "Addressed"
		#define STR0035 "Partial Ender"
		#define STR0036 "Processing..."
		#define STR0037 "The activity is grouped, partial movement is not possible."
		#define STR0038 "Lot [VAR01] is not in the current document."
		#define STR0039 "Sub-batch [VAR01] is not in the current document."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Endereço" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Inf. produto" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Vá para o endereço" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Deseja encerrar o endereçamento?" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Sim" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Não" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Confirme!" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Pegue o unitizador" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Unitidador" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Leve p/o endereço" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Problema no endereçamento." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Pegue o produto" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Lote" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Ultrapassou o total!" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Qtde" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Unidade p/endereçar" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Endereço origem [VAR01] incorreto." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Endereço destino [VAR01] incorreto." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Unitizador [VAR01] incorreto." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Endereçar atividade com quantidade parcial?" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Novo endereço" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Substituir o endereço?" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Informe o sub-lote" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Sub-lote" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Para alterar o endereço pressione CTRL+J no campo de confirmação do endereço destino!" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Atenção!" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Encerrar" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Endereço destino" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Produto já coletado. Faltando apenas finalizar atividade." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Alterar endereço" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Para endereçamento com unitizador a quantidade não pode ser menor que um." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Total" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Endereçada" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Ender parcial" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Processando..." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Atividade está aglutinada, não permite movimentar parcial." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "O Lote [VAR01] não consta no documento atual." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "O Sub-lote [VAR01] não consta no documento atual." )
	#endif
#endif
