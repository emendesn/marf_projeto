#ifdef SPANISH
	#define STR0001 "Pendiente Desarrollo"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Resolver"
	#define STR0005 "Actualizar"
	#define STR0006 "Modelo de Datoss de Pendencia Desarrollo"
	#define STR0007 "Datos de Pendiente Desarrollo"
	#define STR0008 "Versiones Producto Desarrollado"
	#define STR0009 "Version Pendiente"
	#define STR0010 "Este pendiente ya posee una version liberada."
	#define STR0011 "No puede informarse un Producto Desarrollado en el momento de la inclusion."
	#define STR0012 "No puede informarse un Presupuesto y un Pedido al mismo momento en la inclusion."
	#define STR0013 "Producto informado no encontrado."
	#define STR0014 "Es necesario Nr Presup/Pedid, Nr Sec Pres/Ped y Prod Pres/Pedid para realizar la inclusion de un pendiente."
	#define STR0015 "La version "
	#define STR0016 " del producto "
	#define STR0017 "Ya se registro en Pendientes"
	#define STR0018 "No se dio toda la informacion del presupuesto."
	#define STR0019 "No se dio toda la informacion del pedido."
	#define STR0020 "No se encontro e pedido informado"
	#define STR0021 "No encontro el presupuesto informado"
	#define STR0022 " no puede suspenderse."
	#define STR0023 " tiene la(s) orden(es) prototipo: "
	#define STR0024 "El producto de codigo "
	#define STR0025 " y descripcion "
	#define STR0026 " no esta registrado como item."
	#define STR0027 "Mensaje de error: "
	#define STR0028 "no se encontro ningun producto destino"
	#define STR0029 "El presupuesto no puede borrarse. "
	#define STR0030 "Ya existe un presupuesto con este codigo item y producto."
	#define STR0031 "Ya existe un pedido de venta con este codigo item y producto."
	#define STR0032 "Usted no puede modificar el producto desarrollado sin eliminar las versiones asociadas antes a el."
	#define STR0033 "El pendiente debe tener al menos una version asociada."
	#define STR0034 "Presupuesto/Sec/Producto"
	#define STR0035 "Pedido/Sec/Producto"
	#define STR0036 "Versiones"
	#define STR0037 "Narrativa"
	#define STR0038 "ya esta aprobada"
	#define STR0039 'Ya existe pendencia de desarrollo utilizando este producto desarrollado con esta version'
	#define STR0040 'Seleccione otro producto/version'
	#define STR0041 'Existe orden prototipo para otra sucursal. Sucursal: '
	#define STR0042 'Se encontro la pendencia en la sucursal '
	#define STR0043 'Acceda al m�dulo SIGADPR mediante esta sucursal.'
	#define STR0044 'Existe un pedido vinculado a esta version. Eliminelo mediante la facturacion'
	#define STR0045 ' Orden prototipo: '
#else
	#ifdef ENGLISH
		#define STR0001 "Development Pendency"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Solve"
		#define STR0005 "Update"
		#define STR0006 "Data Model of Development Pendency"
		#define STR0007 "Data of Development Pendency"
		#define STR0008 "Developed product versions"
		#define STR0009 "Pendency Version"
		#define STR0010 "This pendency has already a release version."
		#define STR0011 "A Developed Product cannot be entered at the moment of the addition."
		#define STR0012 "A budget and an order cannot be added at the same time as the addition."
		#define STR0013 "Entered product not found."
		#define STR0014 "A Budget/Order No., Budg/Ord Seq No. is needed to add a pendency."
		#define STR0015 "Version "
		#define STR0016 " product "
		#define STR0017 " is already registered in pending "
		#define STR0018 "Not all budget information were added."
		#define STR0019 "Not all order information were added."
		#define STR0020 "The entered order was not found"
		#define STR0021 "The entered budget was not found"
		#define STR0022 " cannot be suspended."
		#define STR0023 " has the prototype order(s): "
		#define STR0024 "The product code "
		#define STR0025 " and description "
		#define STR0026 " not registered as item."
		#define STR0027 "Error message: "
		#define STR0028 "No target product was found"
		#define STR0029 "Budget cannot be deleted. "
		#define STR0030 "There is already a budget with this item code and product."
		#define STR0031 "There is already a sales order with this item code and product."
		#define STR0032 "You are now allowed to edit the developed product without removing previously associated versions."
		#define STR0033 "The pendency should have at least one associated version."
		#define STR0034 "Quotation/Seq/Product"
		#define STR0035 "Order/Seq/Product"
		#define STR0036 "Versions"
		#define STR0037 "Narrative"
		#define STR0038 " is already released"
		#define STR0039 'There is already a development pending action using this product developed with this version'
		#define STR0040 'Select another product/version'
		#define STR0041 'There is prototype order for another branch. Branch: '
		#define STR0042 'Pending action found on branch '
		#define STR0043 'Access the SIGADPR module through this branch.'
		#define STR0044 'There is a order related to this version. Eliminate it through invoicing'
		#define STR0045 ' Prototype Order: '
	#else
		#define STR0001 "Pend�ncia Desenvolvimento"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Resolver"
		#define STR0005 "Atualizar"
		#define STR0006 "Modelo de Dados de Pend�ncia Desenvolvimento"
		#define STR0007 "Dados de Pend�ncia Desenvolvimento"
		#define STR0008 "Vers�es Produto Desenvolvido"
		#define STR0009 "Vers�o Pend�ncia"
		#define STR0010 "Esta pend�ncia j� possui uma vers�o liberada."
		#define STR0011 "N�o pode ser informado um Produto Desenvolvido no momento da inclus�o."
		#define STR0012 "N�o pode ser informado um Or�amento e um Pedido ao mesmo momento na inclus�o."
		#define STR0013 "Produto informado n�o encontrado."
		#define STR0014 "� necess�rio Nr Or�am/Pedid, Nr Seq Or�/Ped e Prod Or�am/Pedid para fazer a inclus�o de uma pend�ncia."
		#define STR0015 "A vers�o "
		#define STR0016 " do produto "
		#define STR0017 " j� est� cadastrada na pend�ncia "
		#define STR0018 "N�o foi informado todas as informa��es do or�amento."
		#define STR0019 "N�o foi informado todas as informa��es do pedido."
		#define STR0020 "N�o encontrou o pedido informado"
		#define STR0021 "N�o encontrou o or�amento informado"
		#define STR0022 " n�o pode ser suspensa."
		#define STR0023 " tem a(s) ordem(ns) prot�tipo: "
		#define STR0024 "O produto de c�digo "
		#define STR0025 " e descri��o "
		#define STR0026 " n�o est� cadastrado como item."
		#define STR0027 "Mensagem do erro: "
		#define STR0028 "N�o foi encontrado nenhum produto destino"
		#define STR0029 "O or�amento n�o pode ser excluido. "
		#define STR0030 "J� existe um or�amento com este c�digo item e produto."
		#define STR0031 "J� existe um pedido de venda com este c�digo item e produto."
		#define STR0032 "Voc� n�o pode alterar o produto desenvolvido sem remover as vers�es associadas a ele antes."
		#define STR0033 "A pend�ncia deve ter pelo menos uma vers�o associada."
		#define STR0034 "Or�amento/Seq/Produto"
		#define STR0035 "Pedido/Seq/Produto"
		#define STR0036 "Vers�es"
		#define STR0037 "Narrativa"
		#define STR0038 " j� est� liberada"
		#define STR0039 'J� existe pend�ncia de desenvolvimento utilizando este produto desenvolvido com esta vers�o'
		#define STR0040 'Selecione outro produto/vers�o'
		#define STR0041 'Existe ordem prot�tipo para outra filial. Filial: '
		#define STR0042 'Foi encontrada pend�ncia na filial '
		#define STR0043 'Acesse o m�dulo SIGADPR atrav�s desta filial.'
		#define STR0044 'Existe pedido relacionado � esta vers�o. Elimine-o atrav�s do faturamento'
		#define STR0045 ' Ordem Prot�tipo: '
	#endif
#endif
