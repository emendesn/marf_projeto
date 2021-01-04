#IFDEF SPANISH
   #define STR0001 "Solicitud"
   #define STR0002 "Tipo"
   #define STR0003 "O.P."
   #define STR0004 "Direccion"
   #define STR0005 "Almacen"
   #define STR0006 "Producto"
   #define STR0007 "Cantidad"
   #define STR0008 "�Confirma la solicitud?"
   #define STR0009 "Atencion"
   #define STR0010 "Espere..."
   #define STR0011 "Tipo de movimiento no existe."
   #define STR0012 "Tipo de movimiento invalido para este proceso"
   #define STR0013 "Aviso"
   #define STR0014 "Orden de produccion no existe"
   #define STR0015 "Orden de Produccion finalizada."
   #define STR0016 "Etiqueta invalida"
   #define STR0017 "Etiqueta ya solicitada"
   #define STR0018 "Etiqueta invalida."
   #define STR0019 "Producto no pertenece a la estructura de esta OP"
   #define STR0020 "Cantidad supera el saldo disponible"
   #define STR0021 "No se encontro direccion"
   #define STR0022 "Direccion bloqueada"
   #define STR0023 "Falla en la grabacion del movimiento, intente nuevamente."
   #define STR0024 "Etiqueta ya leida"
   #define STR0025 "Confirma"
   #define STR0026 "Operador no registrado"
   #define STR0027 "Solicitud/Devolucion"
   #define STR0028 "Seleccione:"
   #define STR0029 "Orden de Produccion"
   #define STR0030 "Centro de Costo"
   #define STR0031 "Informaciones"
   #define STR0032 "Imprime"
   #define STR0033 "Reversion"
   #define STR0034 "Informe el lugar estandar para los materiales en ejecucion - MV_LOCPROC"
   #define STR0035 '�Interrumpe la operacion ?'
   #define STR0036 'Pregunta'
   #define STR0037 "�Confirma la "
   #define STR0038 "solicitud?"
   #define STR0039 "devolucion?"
   #define STR0040 "Tipo de Movimiento invalido"
   #define STR0041 "Devolucion"
   #define STR0042 "OP no registrada"
   #define STR0043 "OP ya Encerrada"
   #define STR0044 "No se permite movimiento con OPs Previstas"
   #define STR0045 "OP ya informada"
   #define STR0046 "cOP"
   #define STR0047 "Centro de costo no registrado"
   #define STR0048 "Etiqueta no ubicada en el almacen de procesos"
   #define STR0049 "Etiqueta no pertenece al almacen de procesos"
   #define STR0050 '�Informa OP ?'
   #define STR0051 "O.P"
   #define STR0052 "C.C"
   #define STR0053 "Producto no pertenece a la estructura de la(s) siguiente(s) OP(s)"
   #define STR0054 "Inconsistencia"
   #define STR0055 "Producto no pertenece a la estructura de la(s) OP(s)"
   #define STR0056 "Producto no reservado para la(s) siguiente(s) OP(s)"
   #define STR0057 "Cantidad informada excede el saldo disponible"
   #define STR0058 "Cantidad mayor que la cantidad de la etiqueta"
   #define STR0059 'Lugar de impresion no configurado, MV_IACD04'
   #define STR0060 'Aviso'
   #define STR0061 "Opcion de reversion no disponible"
   #define STR0062 "Reversion de la O.P"
   #define STR0063 "Reversion del Producto"
   #define STR0064 "Seleccione la"
   #define STR0065 "consulta :"
   #define STR0066 "No existe(n) O.P(s) informada(s)"
   #define STR0067 "OP(s) Leida(s):"
   #define STR0068 "No existe(n) Producto(s) informado(s)"
   #define STR0069 "Producto(s) Leido(s):"
   #define STR0070 "Etiqueta"
   #define STR0071 "O.P no encontrada"
   #define STR0072 "�Confirma la reversion de la OP?"
   #define STR0073 "Producto no encontrado"
   #define STR0074 "�Confirma la reversion del Producto?"
   #define STR0075 "La direccion informada en el parametro MV_ENDPROC no existe en el almacen de procesos"
   #define STR0076 "�Processo interrumpido!"
   #define STR0077 "Falla en el proceso de distribucion."
   #define STR0078 "ERROR"
   #define STR0079 "No se permite la devolucion a una OP ya encerrada"
   #define STR0080 "No se encontro reserva para este producto en la OP "
   #define STR0081 "No se permite la devolucion por OP en la cual la cantidad es mayor que la solicitada"
   #define STR0082 "La cantidad de la devolucion es mayor que el saldo solicitado de este producto para esta OP"
   #define STR0083 "Al devolver esta cantidad, el saldo de la OP podra quedar negativo"
   #define STR0084 "Imprimiendo..."
#ELSE
   #IFDEF ENGLISH
      #define STR0001 "Request"
      #define STR0002 "Type"
      #define STR0003 "P.O."
      #define STR0004 "Address"
      #define STR0005 "Warehouse"
      #define STR0006 "Product"
      #define STR0007 "Quantity"
      #define STR0008 "Confirm request?"
      #define STR0009 "Attention"
      #define STR0010 "Wait..."
      #define STR0011 "Movement type doesnt exist."
      #define STR0012 "Movement type invalid for this process"
      #define STR0013 "Warn."
      #define STR0014 "Production order doesnt exist"
      #define STR0015 "Production order finished"
      #define STR0016 "Invalid label"
      #define STR0017 "Label already requested"
      #define STR0018 "Invalida label"
      #define STR0019 "Product doesnt pertain to this PO's structure"
      #define STR0020 "Quantity exceeds balance available"
      #define STR0021 "Address not found"
      #define STR0022 "Address blocked"
      #define STR0023 "Error saving movement, try again."
      #define STR0024 "Label already read"
      #define STR0025 "Confirm"
      #define STR0026 "Operator not registered"
      #define STR0027 "Request/Return"
      #define STR0028 "Select:"
      #define STR0029 "Production Order"
      #define STR0030 "Cost Center"
      #define STR0031 "Information"
      #define STR0032 "Print"
      #define STR0033 "Reversal"
      #define STR0034 "Input the standard location for materials in process - MV_LOCPROC"
      #define STR0035 'Abort the operation ?'
      #define STR0036 'Question'
      #define STR0037 "Confirm  "
      #define STR0038 "request?"
      #define STR0039 "return?"
      #define STR0040 "Invalid movement type"
      #define STR0041 "Return"
      #define STR0042 "PO not registered"
      #define STR0043 "PO already closed"
      #define STR0044 "Movement with foreseen POs not allowed"
      #define STR0045 "PO already input"
      #define STR0046 "cOP"
      #define STR0047 "Cost center not registered"
      #define STR0048 "Label not addressed in the process warehouse"
      #define STR0049 "Label doesnt pertain to process warehouse"
      #define STR0050 'Input PO ?'
      #define STR0051 "P.O"
      #define STR0052 "C.C"
      #define STR0053 "Product doesnt pertain to the structure of PO(s) below"
      #define STR0054 "Inconsistency"
      #define STR0055 "Product doesnt pertain to the structure of PO(s)"
      #define STR0056 "Product not pledged for PO(s) below"
      #define STR0057 "Quantity input exceeds available balance"
      #define STR0058 "Quantity more than quantity on label"
      #define STR0059 'Print location not configured, MV_IACD04'
      #define STR0060 'Warn.'
      #define STR0061 "Reversal option not available"
      #define STR0062 "P.O reversal"
      #define STR0063 "Product reversal"
      #define STR0064 "Select "
      #define STR0065 "Query :"
      #define STR0066 "Input P.O(s) dont exist"
      #define STR0067 "PO(s) read:"
      #define STR0068 "Input product(s) dont exist"
      #define STR0069 "Product(s) read:"
      #define STR0070 "Label"
      #define STR0071 "O.P nao encontrada"
      #define STR0072 "Confirma o estorno da OP ?"
      #define STR0073 "Produto nao encontrado"
      #define STR0074 "Confirma o estorno do Produto ?"
      #define STR0075 "Address input in parameter MV_ENDPROC doesnt exist in process warehouse"
      #define STR0076 "Process aborted !!!"
      #define STR0077 "Error in distribution process."
      #define STR0078 "ERR."
      #define STR0079 "Return to an already closed PO not allowed"
      #define STR0080 "Pledge for this product not found in the PO"
      #define STR0081 "Return to PO is not allowed if the quantity is more than that requested"
      #define STR0082 "Quantity returned is more than the balance requested of this product for this PO"
      #define STR0083 "If this quantity is returned the PO balance may become negative"
      #define STR0084 "Imprimindo..."
   #ELSE
      #define STR0001 "Requisicao"
      #define STR0002 "Tipo"
      #define STR0003 "O.P."
      #define STR0004 "Endereco"
      #define STR0005 "Armazem"
      #define STR0006 "Produto"
      #define STR0007 "Quantidade"
      #define STR0008 "Confirma a requisicao?"
      #define STR0009 "Atencao"
      #define STR0010 "Aguarde..."
      #define STR0011 "Tipo de movimento nao existe."
      #define STR0012 "Tipo de movimento invalido para este processo"
      #define STR0013 "Aviso"
      #define STR0014 "Ordem de producao nao existe"
      #define STR0015 "Ordem de Producao finalizada."
      #define STR0016 "Etiqueta invalida"
      #define STR0017 "Etiqueta ja requisitada"
      #define STR0018 "Etiqueta invalida."
      #define STR0019 "Produto nao pertence a estrutura desta OP"
      #define STR0020 "Quantidade excede o saldo disponivel"
      #define STR0021 "Endereco nao encontrado"
      #define STR0022 "Endereco bloqueado"
      #define STR0023 "Falha na gravacao da movimentacao, tente novamente."
      #define STR0024 "Etiqueta ja lida"
      #define STR0025 "Confirma"
      #define STR0026 "Operador nao cadastrado"
      #define STR0027 "Requisicao/Devolucao"
      #define STR0028 "Selecione:"
      #define STR0029 "Ordem de Producao"
      #define STR0030 "Centro de Custo"
      #define STR0031 "Informacoes"
      #define STR0032 "Imprime"
      #define STR0033 "Estorno"
      #define STR0034 "Informe o local padrao para os materiais em processo - MV_LOCPROC"
      #define STR0035 'Aborta a operacao ?'
      #define STR0036 'Pergunta'
      #define STR0037 "Confirma a "
      #define STR0038 "requisicao?"
      #define STR0039 "devolucao?"
      #define STR0040 "Tipo de Movimento invalido"
      #define STR0041 "Devolucao"
      #define STR0042 "OP nao cadastrada"
      #define STR0043 "OP ja Encerrada"
      #define STR0044 "Nao e permitida movimentacao com OPs Previstas"
      #define STR0045 "OP ja informada"
      #define STR0046 "cOP"
      #define STR0047 "Centro de custo nao cadastrado"
      #define STR0048 "Etiqueta nao enderecada no armazem de processos"
      #define STR0049 "Etiqueta nao pertence ao armazem de processos"
      #define STR0050 'Informa OP ?'
      #define STR0051 "O.P"
      #define STR0052 "C.C"
      #define STR0053 "Produto nao pertence a estrutura da(s) OP(s) abaixo"
      #define STR0054 "Inconsistencia"
      #define STR0055 "Produto nao pertence a estrutura da(s) OP(s)"
      #define STR0056 "Produto nao empenhado para a(s) OP(s) abaixo"
      #define STR0057 "Quantidade informada excede o saldo disponivel"
      #define STR0058 "Quantidade maior do que a quantidade da etiqueta"
      #define STR0059 'Local de impressao nao configurado, MV_IACD04'
      #define STR0060 'Aviso'
      #define STR0061 "Opcao de estorno nao disponivel"
      #define STR0062 "Estorno da O.P"
      #define STR0063 "Estorno do Produto"
      #define STR0064 "Selecione a"
      #define STR0065 "consulta :"
      #define STR0066 "Nao existe O.P(s) informada(s)"
      #define STR0067 "OP(s) Lida(s):"
      #define STR0068 "Nao existe Produto(s) informado(s)"
      #define STR0069 "Produto(s) Lido(s):"
      #define STR0070 "Etiqueta"
      #define STR0071 "O.P nao encontrada"
      #define STR0072 "Confirma o estorno da OP ?"
      #define STR0073 "Produto nao encontrado"
      #define STR0074 "Confirma o estorno do Produto ?"
      #define STR0075 "O endereco informado no parametro MV_ENDPROC nao existe no armazem de processos"
      #define STR0076 "Processo abortado !!!"
      #define STR0077 "Falha no processo de distribuicao."
      #define STR0078 "ERRO"
      #define STR0079 "Nao e permitido a devolucao para uma OP ja encerrada"
      #define STR0080 "Nao foi encontrado empenho para este produto na OP "
      #define STR0081 "Nao e permitida a devolucao por OP onde a quantidade e maior do que a requisitada"
      #define STR0082 "A quantidade da devolucao e maior do que o saldo requisitado deste produto para esta OP"
      #define STR0083 "Ao devolver esta quantidade o saldo da OP podera ficar negativo"
      #define STR0084 "Imprimindo..."
   #ENDIF
#ENDIF