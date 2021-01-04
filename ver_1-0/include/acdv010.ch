#IFDEF SPANISH
   #define STR0001 'Seleccione:'
   #define STR0002 "Factura de Entrada"
   #define STR0003 "Produccion"
   #define STR0004 "Autorizacion/Rechazo"
   #define STR0005 'Fact '
   #define STR0006 'Proveed.'
   #define STR0007 'Ctd.'
   #define STR0008 'Documento '
   #define STR0009 'Etiqueta'
   #define STR0010 'Producto'
   #define STR0011 'Direccion'
   #define STR0012 "Al salir perdera lo leido, ¿confirma salida?"
   #define STR0013 "No se encontro Factura"
   #define STR0014 "AVISO"
   #define STR0015 "No se encontro Documento"
   #define STR0016 "Etiqueta invalida."
   #define STR0017 "Ya se leyo este Producto."
   #define STR0018 "Deposito invalido"
   #define STR0019 "Producto no verificado"
   #define STR0020 "No tiene saldo para analizar"
   #define STR0021 "No tiene saldo para distribuir"
   #define STR0022 "No se encontro Direccion"
   #define STR0023 "Direccion bloqueada"
   #define STR0024 "¿Confirma el rechazo de items? "
   #define STR0025 "¿Confirma la autorizacion de items? "
   #define STR0026 "ATENCION"
   #define STR0027 "Espere..."
   #define STR0028 "Falla en el proceso de distribucion."
   #define STR0029 "ERROR"
   #define STR0030 "Etiqueta"
   #define STR0031 "Producto"
   #define STR0032 "Cantidad"
   #define STR0033 "Lote"
   #define STR0034 "Sublote"
   #define STR0035 "CTRL+I Informac.  CTRL+X Revers. CTRL+A Ayuda"
   #define STR0036 "AYUDA"
   #define STR0037 "Revers. de Lectura"
   #define STR0038 'Ctd.  '
   #define STR0039 "Etiqueta:"
   #define STR0040 "No se encontro Etiqueta"
   #define STR0041 "Etiqueta invalida"
   #define STR0042 "Lote invalido"
   #define STR0043 "¿Confirma la reversion de esta Etiqueta?"
   #define STR0044 "Saldo insuficiente"
   #define STR0045 'Producto '
   #define STR0046 'bloqueado para inventario en el almacen '
   #define STR0047 "Producto ya autorizado"
   #define STR0048 "Producto ya rechazado"
   #define STR0049 "Direccion invalida"
   #define STR0050 "Informacion"
   #define STR0051 "Reversion"
   #define STR0052 "Etiqueta invalida, Producto pertenece a un Pallet"
   #define STR0053 "No tiene saldo por analizar en el SD7"
   #define STR0054 "No tiene saldo por analizar en el SD3"
#ELSE
   #IFDEF ENGLISH
      #define STR0001 'Select:'
      #define STR0002 "Inflow Invoice"
      #define STR0003 "Production"
      #define STR0004 "Release/Rejection"
      #define STR0005 'Invo. '
      #define STR0006 'Supp.'
      #define STR0007 'Qty.'
      #define STR0008 'Document '
      #define STR0009 'Label'
      #define STR0010 'Product'
      #define STR0011 'Address'
      #define STR0012 "Exiting, you will lose all that was read, confirm?"
      #define STR0013 "Invoice not found"
      #define STR0014 "WARN."
      #define STR0015 "Document not found"
      #define STR0016 "Invalid Label"
      #define STR0017 "Product already read"
      #define STR0018 "Invalid warehouse"
      #define STR0019 "Product not checked"
      #define STR0020 "No balance to be analyzed"
      #define STR0021 "No balance to be distributed"
      #define STR0022 "Address not found"
      #define STR0023 "Address blocked"
      #define STR0024 " Confirm rejection of items? "
      #define STR0025 " Confirm release of items? "
      #define STR0026 "ATTENTION"
      #define STR0027 "Wait..."
      #define STR0028 "Error in distribution process."
      #define STR0029 "ERR."
      #define STR0030 "Label"
      #define STR0031 "Product"
      #define STR0032 "Quantity"
      #define STR0033 "Lot"
      #define STR0034 "SubLot"
      #define STR0035 "CTRL+I Information CTRL+X Reversal CTRL+A Help"
      #define STR0036 "HELP"
      #define STR0037 "Reading reversal"
      #define STR0038 'Qty. '
      #define STR0039 "Label:"
      #define STR0040 "Label not found"
      #define STR0041 "Invalid label"
      #define STR0042 "Invalid lot"
      #define STR0043 "Confirm reversal of this Label?"
      #define STR0044 "Balance insufficient"
      #define STR0045 'Product '
      #define STR0046 ' blocked for inventory in warehouse '
      #define STR0047 "Product already released"
      #define STR0048 "Product already rejected"
      #define STR0049 "Invalid address"
      #define STR0050 "Information"
      #define STR0051 "Reversal"
      #define STR0052 "Invalid label, produto pertains to a Pallet"
      #define STR0053 "No balance to analyze in SD7"
      #define STR0054 "No balance to analyze in SD3"
   #ELSE
      #define STR0001 'Selecione:'
      #define STR0002 "Nota de Entrada"
      #define STR0003 "Producao"
      #define STR0004 "Liberacao/Rejeicao"
      #define STR0005 'Nota '
      #define STR0006 'Forn.'
      #define STR0007 'Qtde.'
      #define STR0008 'Documento '
      #define STR0009 'Etiqueta'
      #define STR0010 'Produto'
      #define STR0011 'Endereco'
      #define STR0012 "Saindo perdera o que foi lido, confirma saida?"
      #define STR0013 "Nota nao encontrada"
      #define STR0014 "AVISO"
      #define STR0015 "Documento nao encontrado"
      #define STR0016 "Etiqueta invalida."
      #define STR0017 "Produto ja foi lido."
      #define STR0018 "Armazem invalido"
      #define STR0019 "Produto nao conferido"
      #define STR0020 "Nao tem saldo a analisar"
      #define STR0021 "Nao tem saldo a distribuir"
      #define STR0022 "Endereco nao encontrado"
      #define STR0023 "Endereco bloqueado"
      #define STR0024 " Confirma a rejeicao dos itens? "
      #define STR0025 " Confirma a liberacao dos itens? "
      #define STR0026 "ATENCAO"
      #define STR0027 "Aguarde..."
      #define STR0028 "Falha no processo de distribuicao."
      #define STR0029 "ERRO"
      #define STR0030 "Etiqueta"
      #define STR0031 "Produto"
      #define STR0032 "Quantidade"
      #define STR0033 "Lote"
      #define STR0034 "SubLote"
      #define STR0035 "CTRL+I Informacao CTRL+X Estorno CTRL+A Ajuda"
      #define STR0036 "AJUDA"
      #define STR0037 "Estorno da Leitura"
      #define STR0038 'Qtde. '
      #define STR0039 "Etiqueta:"
      #define STR0040 "Etiqueta nao encontrada"
      #define STR0041 "Etiqueta invalida"
      #define STR0042 "Lote invalido"
      #define STR0043 "Confirma o estorno desta Etiqueta?"
      #define STR0044 "Saldo insuficiente"
      #define STR0045 'Produto '
      #define STR0046 ' bloqueado para inventario no armazem '
      #define STR0047 "Produto ja liberado"
      #define STR0048 "Produto ja rejeitado"
      #define STR0049 "Endereco invalido"
      #define STR0050 "Informacao"
      #define STR0051 "Estorno"
      #define STR0052 "Etiqueta invalida, Produto pertence a um Pallet"
      #define STR0053 "Nao tem saldo a analisar no SD7"
      #define STR0054 "Nao tem saldo a analisar no SD3"
   #ENDIF
#ENDIF
