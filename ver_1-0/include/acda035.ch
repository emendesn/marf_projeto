#IFDEF SPANISH
   #define STR0001 "Conteo no coincide"
   #define STR0002 "Conteo coincide"
   #define STR0003 "No Inventariado"
   #define STR0004 "Buscar"
   #define STR0005 "Visualizar"
   #define STR0006 "Incluir"
   #define STR0007 "Modificar"
   #define STR0008 "Borrar"
   #define STR0009 "Leyenda"
   #define STR0010 "Asiento de Inventario"
   #define STR0011 "Aviso"
   #define STR0012 "No existen items para visualizarse"
   #define STR0013 "Ok"
   #define STR0014 "Es necesario activar el parametro MV_CBPE012"
   #define STR0015 "No es posible realizar modificacion, pues ¡el maestro de "
   #define STR0016 "inventario ya esta procesado!"
   #define STR0017 "inventario ya esta finalizado!"
   #define STR0018 "No es posible borrar este conteo, pues el maestro de "
   #define STR0019 "Conteo no se inicio"
   #define STR0020 "Conteo esta en ejecucion"
   #define STR0021 "Conteo finalizado"
   #define STR0022 "¡Existen campos obligatorios que no se rellenaron!"
   #define STR0023 "Atencion"
   #define STR0024 '¡No es posible realizar la modificacion!'
   #define STR0025 'Producto ya auditado'
   #define STR0026 'el maestro de inventario esta configurado solamente para inventariar '
   #define STR0027 'el produto "'
   #define STR0028 '¡No es posible incluir un producto ya auditado!'
   #define STR0029 'Atencion'
   #define STR0030 "¡Producto no registrado!"
   #define STR0031 "¡Producto y almacen no registrado de saldos!"
   #define STR0032 "Producto sin control de direccion"
   #define STR0033 "Por favor, informe el Almacen y Direccion - Pulse: F12"
   #define STR0034 "¡Producto/Etiqueta invalida!"
   #define STR0035 "Producto diferente del que debe inventariarse."
   #define STR0036 "Lectura invalida"
   #define STR0037 "Etiqueta invalida"
   #define STR0038 "Direccion Invalida"
   #define STR0039 "¡Producto no tiene cantidad variable!"
   #define STR0040 "¿Realmente desea borrar este asiento de inventario?"
   #define STR0041 "¡No existen items por grabarse!"
   #define STR0042 "¿Desea finalizar el conteo?"
   #define STR0043 "¡Codigo de Etiqueta ya leida!"
   #define STR0044 "Codigo de Etiqueta Invalido"
   #define STR0045 "Etiqueta de producto sin direccion"
   #define STR0046 "Producto pertenece a la direccion:"
   #define STR0047 '¡Este maestro de inventario ya esta procesado!'
   #define STR0048 '¡Este maestro de inventario ya esta finalizado!'
   #define STR0049 '¡El codigo del maestro de inventario no puede estar vacio!'
   #define STR0050 '¡El codigo del operador no puede estar vacio!'
   #define STR0051 '¡Operador ya realizo conteo para el inventario!'
   #define STR0052 'Sin Autorizacion'
   #define STR0053 "Solamente el Operador "
   #define STR0054 "puede dar continuidad a este inventario"
   #define STR0055 "Conteos == 1"
   #define STR0056 '¡Operador ejecutando inventario en otro terminal!'
   #define STR0057 '¡Inventario bloqueado para auditoria!'
   #define STR0058 'Control de Localizacion Desactivado.'
   #define STR0059 'Producto no tiene Localizacion.'
   #define STR0060 "Informe Localizacion"
   #define STR0061 "Lugar:"
   #define STR0062 "Direccion:"
   #define STR0063 "Informe el Almacen"
   #define STR0064 "&Confirmar"
   #define STR0065 'Almacen y direccion incorrecto.'
   #define STR0066 'Lo correcto seria:'
   #define STR0067 'Direccion no registrada.'
#ELSE
   #IFDEF ENGLISH
      #define STR0001 "Count not checked"
      #define STR0002 "Count checked"
      #define STR0003 "Not inventoried"
      #define STR0004 "Search"
      #define STR0005 "View"
      #define STR0006 "Add"
      #define STR0007 "Modify"
      #define STR0008 "Delete"
      #define STR0009 "Legend"
      #define STR0010 "Inventory entry"
      #define STR0011 "Warn."
      #define STR0012 "No items to be viewed"
      #define STR0013 "Ok"
      #define STR0014 "The parameter MV_CBPE012 must be activated"
      #define STR0015 "Cannot be modified since the inventory master"
      #define STR0016 "is already processed!"
      #define STR0017 "is already finalized!"
      #define STR0018 "This count cannot be deleted since the count master "
      #define STR0019 "has not started"
      #define STR0020 "is in progress"
      #define STR0021 "is finalized"
      #define STR0022 "There are mandatory fields that were not filled!!!"
      #define STR0023 "Attention"
      #define STR0024 'Cannot be changed!'
      #define STR0025 'Product already audited'
      #define STR0026 'Inventory master is configured to inventory only '
      #define STR0027 'the product "'
      #define STR0028 'An already audited product cannot be added!'
      #define STR0029 'Attention'
      #define STR0030 "Product not registered!"
      #define STR0031 "Product and warehouse not registered with balances!"
      #define STR0032 "Product without address control"
      #define STR0033 "Please input Warehouse and Address - Press: F12"
      #define STR0034 "Invalid Product/ Label!!"
      #define STR0035 "Product different from that to be inventoried."
      #define STR0036 "Invalid reading"
      #define STR0037 "Invalid label"
      #define STR0038 "Invalid address"
      #define STR0039 "Product has no variable quantity!"
      #define STR0040 "Really want to delete this inventory entry?"
      #define STR0041 "No items to be saved!"
      #define STR0042 "Wish to terminate counting?"
      #define STR0043 "Label Code already read!"
      #define STR0044 "Label Code invalid"
      #define STR0045 "Product Label without address"
      #define STR0046 "Product pertains to address:"
      #define STR0047 'This inventory master is already processed!'
      #define STR0048 'This inventory master is already finalized!'
      #define STR0049 'Inventory master code cannot be blank!'
      #define STR0050 'Operator code cannot be blank!'
      #define STR0051 'Operator already made count for the inventory!'
      #define STR0052 'No permission'
      #define STR0053 "Only the Operator"
      #define STR0054 " can continue this inventory"
      #define STR0055 "Counts == 1"
      #define STR0056 'Operator running inventory in another terminal!'
      #define STR0057 'Inventory blocked for auditing!'
      #define STR0058 'Location conrol deactivated'
      #define STR0059 'Product has no location.'
      #define STR0060 "Input Location"
      #define STR0061 "Locat.:"
      #define STR0062 "Address:"
      #define STR0063 "Input Warehouse"
      #define STR0064 "&Confirm"
      #define STR0065 'Warehouse and address wrong'
      #define STR0066 'Correct would be:'
      #define STR0067 'Address not registered.'
   #ELSE
      #define STR0001 "Contagem nao Batida"
      #define STR0002 "Contagem Batida"
      #define STR0003 "Nao Inventariado"
      #define STR0004 "Pesquisar"
      #define STR0005 "Visualisar"
      #define STR0006 "Incluir"
      #define STR0007 "Alterar"
      #define STR0008 "Excluir"
      #define STR0009 "Legenda"
      #define STR0010 "Lancamento de Inventario"
      #define STR0011 "Aviso"
      #define STR0012 "Nao existem itens para serem visualizados"
      #define STR0013 "Ok"
      #define STR0014 "Necessario ativar o parametro MV_CBPE012"
      #define STR0015 "Nao eh possivel realizar alteracao, pois o mestre de "
      #define STR0016 "inventario ja esta processado!"
      #define STR0017 "inventario ja esta finalizado!"
      #define STR0018 "Nao eh possivel excluir esta contagem, pois o mestre de "
      #define STR0019 "Contagem nao iniciada"
      #define STR0020 "Contagem em andamento"
      #define STR0021 "Contagem finalizada"
      #define STR0022 "Existem campos obrigatorios que nao foram preenchidos!!!"
      #define STR0023 "Atencao"
      #define STR0024 'Nao eh possivel realizar alteracao!'
      #define STR0025 'Produto ja auditado'
      #define STR0026 'O mestre de inventario esta configurado para inventariar somente '
      #define STR0027 'o produto "'
      #define STR0028 'Nao eh possivel incluir um produto ja auditado!'
      #define STR0029 'Atencao'
      #define STR0030 "Produto nao cadastrado!"
      #define STR0031 "Produto e armazem nao cadastrado de saldos!"
      #define STR0032 "Produto sem controle de endereco"
      #define STR0033 "Favor informar o Armazem e Endereco - Tecle: F12"
      #define STR0034 "Produto/Etiqueta invalida!!"
      #define STR0035 "Produto diferente do que deve ser inventariado."
      #define STR0036 "Leitura invalida"
      #define STR0037 "Etiqueta invalida"
      #define STR0038 "Endereco Invalido"
      #define STR0039 "Produto nao possui quantidade variavel!"
      #define STR0040 "Deseja realmete excluir este lancamento de inventario?"
      #define STR0041 "Nao existem itens a serem gravados!"
      #define STR0042 "Deseja finalizar a contagem?"
      #define STR0043 "Codigo de Etiqueta ja lida!"
      #define STR0044 "Codigo de Etiqueta Invalido"
      #define STR0045 "Etiqueta de produto sem endereco"
      #define STR0046 "Produto pertence ao endereco:"
      #define STR0047 'Este mestre de inventario ja esta processado!'
      #define STR0048 'Este mestre de inventario ja esta finalizado!'
      #define STR0049 'O codigo do mestre de inventario nao pode estar vazio!'
      #define STR0050 'O codigo do operador nao pode estar vazio!'
      #define STR0051 'Operador ja realizou contagem para o inventario!'
      #define STR0052 'Sem Permissao'
      #define STR0053 "Somente o Operador "
      #define STR0054 " pode dar continuidade a este inventario"
      #define STR0055 "Contagens == 1"
      #define STR0056 'Operador executando inventario em outro terminal!'
      #define STR0057 'Inventario bloqueado para auditoria!'
      #define STR0058 'Controle de Localizacao Desativado.'
      #define STR0059 'Produto nao tem Localizacao.'
      #define STR0060 "Informar Localizacao"
      #define STR0061 "Local:"
      #define STR0062 "Endereco:"
      #define STR0063 "Informe o Armazem"
      #define STR0064 "&Confirmar"
      #define STR0065 'Armazem e endereco incorreto.'
      #define STR0066 'O correto seria:'
      #define STR0067 'Endereco nao cadastrado.'
   #ENDIF
#ENDIF
