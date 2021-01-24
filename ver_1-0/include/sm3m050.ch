#IFDEF SPANISH
   #define STR0001 'Buscar'
   #define STR0002 'Visualizar'
   #define STR0003 'Incluir'
   #define STR0004 'Modificar'
   #define STR0005 'Borrar'
   #define STR0006 "Estructuras de Productos"
   #define STR0007 "Este programa permite el mantenimiento de la Estructura de Productos."
   #define STR0008 'Estructuras'
   #define STR0009 'Visualizacion'
   #define STR0010 'Inclusion'
   #define STR0011 'Modificacion'
   #define STR0012 'Borrado'
   #define STR0013 "No se encontro ninguna referencia al producto en cuestion en el Archivo de Productos."
   #define STR0014 "Verifique la integridad de los archivos de datos y de los indices utilizados por la rutina."
   #define STR0015 'Codigo:'
   #define STR0016 'Unidad:'
   #define STR0017 'Estructura Similar:'
   #define STR0018 'Cantidad Base:'
   #define STR0019 'Buscar...'
   #define STR0020 "No existe registro con esta informacion."
   #define STR0021 "Utilice un producto ya registrado o registre este producto antes de usarlo."
   #define STR0022 "No existe registro relacionado a este codigo. Informe un codigo que exista en el archivo o implantelo en el programa de mantenimiento del archivo."
   #define STR0023 "Elija un registro valido."
   #define STR0024 "Existe estructura registrada para este producto."
   #define STR0025 "Un producto no puede tener mas de una estructura registrada. No es posible incluir otra estructura para este producto."
   #define STR0026 "No se permite incluir componentes en productos con cantidad negativa."
   #define STR0027 "No intente incluir componentes en este producto porque el mismo tiene cantidad negativa, lo que generara devoluciones en el momento de la produccion."
   #define STR0028 "Estrutura no registrada."
   #define STR0029 "Utilice como estructura similar una estructura ya registrada."
   #define STR0030 "El producto principal no puede ser un componente de la estructura similar."
   #define STR0031 "Esta estrutura similar no puede ser usada para este producto. Seleccione otra estructura como similar."
   #define STR0032 "La cantidad base no puede ser negativa."
   #define STR0033 "Registre una cantidad positiva."
   #define STR0034 "Un producto 'FINAL' no puede ser componente de su 'INTERMEDIO'."
   #define STR0035 "Seleccione otro producto para componente de esta estructura."
   #define STR0036 "Un producto 'FINAL' no puede ser componente de su 'INTERMEDIO'. El producto:"
   #define STR0037 " tiene como componentes los productos de esta estructura."
   #define STR0038 "Seleccione otro producto como componente de la estructura."
   #define STR0039 "Hora informada incorrecta."
   #define STR0040 "El numero de minutos no puede superar 59,99. Digite el número de minutos correctamente."
   #define STR0041 "El producto no puede tener cantidad negativa porque ya tiene estructura registrada."
   #define STR0042 "No intente registrar una cantidad negativa en este producto."
   #define STR0043 "Cada modificacion en una estructura puede generar una nueva revision para"
   #define STR0044 "el control historial de modificaciones en determinado producto."
   #define STR0045 "¿La modificacion debe generar una nueva revision para esta estructura?"
   #define STR0046 "Revision estructura"
   #define STR0047 "No es posible que el mismo producto conste dos veces en el mismo nivel de la estructura con la misma secuencia."
   #define STR0048 "Registre otra secuencia para este producto o utilice otro producto como componente."
   #define STR0049 '  Producto                  Cant.Basica'
   #define STR0050 'Componentes                  Cantidad'
   #define STR0051 '  Ninguna divergencia...'
   #define STR0052 '  Total'
   #define STR0053 "Buscar"
   #define STR0054 "Componente"
   #define STR0055 "Seleccionando registros..."
   #define STR0056 "Mapa de divergencias"
   #define STR0057 ""
   #define STR0058 ""
	#define STR0059 "Produto com Ordem de producao em aberto."
	#define STR0060 "Encerre todas as ordens de producao deste produto, antes de alterar sua estrutura."
#ELSE
   #IFDEF ENGLISH
      #define STR0001 'Search'
      #define STR0002 'View'
      #define STR0003 'Insert'
      #define STR0004 'Edit'
      #define STR0005 'Delete'
      #define STR0006 "Products Structure"
      #define STR0007 "This program allows the maintenance of Products Structure."
      #define STR0008 'Structures'
      #define STR0009 'View'
      #define STR0010 'Insert'
      #define STR0011 'Edito'
      #define STR0012 'Delete'
      #define STR0013 "No reference to the product in question was found in the Products File."
      #define STR0014 "Check the Integrity of Data and Indexes used by this routine."
      #define STR0015 'Code:'
      #define STR0016 'Unit:'
      #define STR0017 'Similar Structure:'
      #define STR0018 'Base Quantity:'
      #define STR0019 'Search...'
      #define STR0020 "There is no registration with this information."
      #define STR0021 "Use another product already registered or register this product before using it."
      #define STR0022 "There is no registration related to this code. Enter an existing code or execute the implementation in the file maintenance program."
      #define STR0023 "Choose a valid registration"
      #define STR0024 "There is registered structure for this product"
      #define STR0025 "A product cannot have more than one registered structure. It is not possible to insert another strucutre for this product"
      #define STR0026 "It is not possible to insert components in products with negative quantity."
      #define STR0027 "Do not try to insert components in this product for it has negative quantity, that is, it will generate returns at the production time."
      #define STR0028 "Structure not registered."
      #define STR0029 "Use as similar structure a structure already registered."
      #define STR0030 "The main product cannot be a component of the similar structure."
      #define STR0031 "This similar structure cannot be used for this product. Select another structurre as similar."
      #define STR0032 "The base quantity cannot be negative."
      #define STR0033 "Register a positive quantity."
      #define STR0034 "A 'FINAL' product cannot be component of an 'INTERMEDIARY' one.
      #define STR0035 "Select another product for this structure`s component."
      #define STR0036 "A 'FINAL' product cannot be component of an 'INTERMEDIARY' one.The product:"
      #define STR0037 " has as components the products of this structurea."
      #define STR0038 "Select another product as component of the structure."
      #define STR0039 "Wrong hour entered."
      #define STR0040 "The number of minutes cannot exceed 59,99. Enter a correct number for minutes."
      #define STR0041 "The product cannot have negative quantity for it already has registered structure."
      #define STR0042 "Do not try to register negative quantity in this product."
      #define STR0043 "Each modification in a structure may generate a new revision to"
      #define STR0044 "the history control of modification in a certain product."
      #define STR0045 "Should the modification generate a new revision for this structure?"
      #define STR0046 "Revision Structure"
      #define STR0047 "The same product cannot be two times in the same level of the structure with the same sequence."
      #define STR0048 "Register another sequence for this product or use another product as component."
      #define STR0049 '  Product                   Basic Qtty.'
      #define STR0050 'Components                   Quantity'
      #define STR0051 '  No Divergence...'
      #define STR0052 '  Total'
      #define STR0053 "Search"
      #define STR0054 "Component"
      #define STR0055 "Selecting Registrations.."
      #define STR0056 "Divergences map"
      #define STR0057 ""
      #define STR0058 ""
		#define STR0059 "Produto com Ordem de producao em aberto."
		#define STR0060 "Encerre todas as ordens de producao deste produto, antes de alterar sua estrutura."
   #ELSE
      #define STR0001 'Pesquisar'
      #define STR0002 'Visualizar'
      #define STR0003 'Incluir'
      #define STR0004 'Alterar'
      #define STR0005 'Excluir'
      #define STR0006 "Estruturas de Produtos"
      #define STR0007 "Este programa permite a manutenção da Estrutura de Produtos."
      #define STR0008 'Estruturas'
      #define STR0009 'Visualização'
      #define STR0010 'Inclusão'
      #define STR0011 'Alteração'
      #define STR0012 'Exclusão'
      #define STR0013 "Não foi encontrada nenhuma referência ao produto em questão no arquivo de Cadastro de Produtos."
      #define STR0014 "Verifique a Integridade dos Arquivos de Dados e dos Indices utilizados pela rotina."
      #define STR0015 'Código:'
      #define STR0016 'Unidade:'
      #define STR0017 'Estrutura Similar:'
      #define STR0018 'Quantidade Base:'
      #define STR0019 'Pesquisar...'
      #define STR0020 "Não existe registro com esta informação."
      #define STR0021 "Utilize um produto já cadastrado ou cadastre este produto antes de usá-lo."
      #define STR0022 "Não existe registro relacionado a este código. Informe um código que exista no cadastro, ou efetue a implantação no programa de manutenção do cadastro."
      #define STR0023 "Escolha um registro válido."
      #define STR0024 "Existe estrutura cadastrada para este produto."
      #define STR0025 "Um produto não pode ter mais de uma estrutura cadastrada. Não será possível incluir mais uma estrutura para este produto."
      #define STR0026 "Não é permitido incluir componentes em produtos com quantidade negativa."
      #define STR0027 "Não tente incluir componentes neste produto, pois o mesmo tem quantidade negativa, ou seja, irá gerar devoluções no momento da produção."
      #define STR0028 "Estrutura nåo cadastrada."
      #define STR0029 "Utilize como estrutura similar uma estrutura já cadastrada."
      #define STR0030 "O produto principal não pode ser um componente da estrutura similar."
      #define STR0031 "Esta estrutura similar não pode ser usada para este produto. Selecione outra estrutura como similar."
      #define STR0032 "A quantidade base não pode ser negativa."
      #define STR0033 "Cadastre uma quantidade positiva."
      #define STR0034 "Um produto 'PAI' não pode ser componente de seu 'FILHO'."
      #define STR0035 "Selecione outro produto para componente desta estrutura."
      #define STR0036 "Um produto 'PAI' não pode ser componente de seu 'FILHO'.O produto :"
      #define STR0037 " tem como componentes os  produtos  desta	estrutura."
      #define STR0038 "Selecione outro produto como componente da estrutura."
      #define STR0039 "Hora informada incorreta."
      #define STR0040 "O número de minutos não pode ultrapassar 59,99. Digite o número de minutos corretamente."
      #define STR0041 "O produto não pode ter quantidade negativa pois já tem estrutura cadastrada."
      #define STR0042 "Não tente cadastrar uma quantidade negativa neste produto."
      #define STR0043 "Cada altera‡„o em uma estrutura pode gerar uma nova revis„o para"
      #define STR0044 "o controle hist¢rico de altera‡”es em determinado produto."
      #define STR0045 "A altera‡„o deve gerar uma nova revis„o para esta estrutura ?"
      #define STR0046 "Revis„o Estrutura"
      #define STR0047 "Não é possível o mesmo produto estar duas vezes no mesmo nível da estrutura com a mesmo sequência."
      #define STR0048 "Cadastre outra sequência para este produto ou utilize outro produto como componente."
      #define STR0049 '  Produto                   Qtd. Basica'
      #define STR0050 'Componentes                Quantidade'
      #define STR0051 '  Nenhuma Divergencia...'
      #define STR0052 '  Total'
      #define STR0053 "Pesquisar"
      #define STR0054 "Componente"
      #define STR0055 "Selecionando Registros..."
      #define STR0056 "Mapa de divergencias"
      #define STR0057 "Data inicial superior à data final."
      #define STR0058 "A data inicial deve ser inferior à data final."
		#define STR0059 "Produto com Ordem de producao em aberto."
		#define STR0060 "Encerre todas as ordens de producao deste produto, antes de alterar sua estrutura."
   #ENDIF
#ENDIF
