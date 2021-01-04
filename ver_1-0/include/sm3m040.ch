#IFDEF SPANISH
   #define STR0001 "Buscar"
   #define STR0002 "Visualizar"
   #define STR0003 "Incluir"
   #define STR0004 "Revertir"
   #define STR0005 "Movimientos Internos"
   #define STR0006 "Este programa permite el mantenimiento de los Movimientos Internos"
   #define STR0007 "Este movimiento interno no es un requerimiento/devolucion manual, por lo tanto no podra accederselo por esta rutina."
   #define STR0008 "Este movimiento ya fue revertido."
   #define STR0009 "Cambie de registro si desea efectuar la reversion."
   #define STR0010 "El producto informado no esta relacionado a la Orden de Produccion."
   #define STR0011 "Informe otro producto u otra Orden de Produccion relacionada al producto."
   #define STR0012 "La Orden de Produccion informada no tiene saldo suficiente."
   #define STR0013 "Informe otra Orden de Produccion."
   #define STR0014 "La cantidad informada debe ser identica a la cantidad informada en la Orden de Produccion."
   #define STR0015 "Informe la cantidad correcta."
   #define STR0016 "Informe el producto correctamente."
   #define STR0017 "No se informo el numero de la OP. Este campo es obligatorio en las producciones."
   #define STR0018 "Digite el numero de la OP."
   #define STR0019 "Movimientos de transferencia se deben revertir en la propia ventana."
   #define STR0020 "Active la rutina de Transferencia y haga la reversion."
   #define STR0021 "N�o � poss�vel realizar a opera��o pois o estoque ficar� negativo."
   #define STR0022 "Para resolver o problema, altere o      par�metro MV_ESTNEG ou contate o        administrador do sistema."	
   #define STR0023 "Encerrar"
   #define STR0024 "Op Encerrada com sucesso."
   #define STR0025 "Problemas com quantidade, OP nao encerrada."
   #define STR0026 "Op nao encontrada ou encerrada."
   #define STR0027 "Movimento nao gerou encerramento da OP"
   #define STR0028 "Estorne o movimento que gerou o encerramento da OP."
   #define STR0029 "LoteNeg"
   #define STR0030 "Saldo em estoque menor que o saldo solicitado."
   #define STR0031 "Saldo em estoque para o produto: "
   #define STR0032 "Quantidade solicitada: "
   #define STR0033 " Nao e possivel encerrar uma ordem de producao vinculada. Encerre a ordem producao principal."
   #define STR0034 "OP principal foi encerrada!"
   #define STR0035 "N�o � poss�vel apontar OP do produto intermedi�rio"
   #define STR0036 "O lote escolhido no apontamento � diferente do lote da OP!"
   #define STR0037 "Lote Apontamento: "
   #define STR0038 "Lote OP: "      
   #define STR0039 "A Op original ja possui quantidade apontadas."
   #define STR0040 "Estorne antes o movimento da Op original."
   #define STR0041 "Movimento Interno com valoriza��o, deve-se informar ao menos um campo com valor maior que zero."
   #define STR0042 "Informe a valoriza��o desse movimento."
   #define STR0043 "Movimento Interno com quantidade igual a zero."
   #define STR0044 "Informe uma quantidade."
   #define STR0045 "N�o � permitido movimenta��o interna para produtos que n�o possuem saldo."
   #define STR0046 "Informe um produto com saldo em estoque."
   #define STR0047 "Rateio"
   #define STR0048 "N�o ser� poss�vel realizar o estorno    desse lancamento pois pertence a um     apontamento de produ��o."
   #define STR0049 "Realize a Exclus�o do Apontamento."
   #define STR0050 "Essa Ordem de Produ��o est� bloqueada portanto n�o poder� ser apontada a produ��o."
   #define STR0051 "O usu�rio responsavel deve desbloquear essa Ordem de Produ��o."
   #define STR0052 "Alterar"
   #define STR0053 "N�o ser� poss�vel realizar a altera��o desse lancamento pois pertencente a movimenta��es do sistema."
   #define STR0054 "Este produto possui controle de lote ou FIFO."
   #define STR0055 "A data de fabrica��o, data de validade e c�digo do lote devem ser preenchidos."
   #define STR0056 "Este produto n�o possui controle de lote ou FIFO."
   #define STR0057 "A data de fabrica��o, data de validade e c�digo do lote n�o devem ser preenchidos."
   #define STR0058 "Movimenta��o sem informa��es de rateio."
   #define STR0059 "Informe o rateio."
#ELSE
   #IFDEF ENGLISH
      #define STR0001 "Search"
      #define STR0002 "View"
      #define STR0003 "Insert"
      #define STR0004 "Reverse"
      #define STR0005 "Internal Transactions"
      #define STR0006 "This program makes it possible to edit Internal Transactions"
      #define STR0007 "This internal movements is not a manual requisition / return, therefore it cannot be accessed by this routine."
      #define STR0008 "This movement was already reversed."
      #define STR0009 "Change the registration if you want to reverse."
      #define STR0010 "The entered product is not related to the Production Order."
      #define STR0011 "Enter another product or another Production Order related to the product."
      #define STR0012 "The entered Production Order has no enough balance."
      #define STR0013 "Enter another Production Order."
      #define STR0014 "The entered quantity must be the same as the one entered in the Production Order."
      #define STR0015 "Enter the correct quantity."     
      #define STR0016 "Enter the product corretly."
      #define STR0017 "The PO number was not entered; this field is compulsory in productions."
      #define STR0018 "Enter the PO number."
      #define STR0019 "Transference movements must be reversed on the screen itself."
      #define STR0020 "Refer to the transference routine and reverse them."
      #define STR0021 "N�o � poss�vel realizar a opera��o pois o estoque ficar� negativo."
      #define STR0022 "Para resolver o problema, altere o      par�metro MV_ESTNEG ou contate o        administrador do sistema."		  
      #define STR0023 "Encerrar"
      #define STR0024 "Op Encerrada com sucesso."
      #define STR0025 "Problemas com quantidade, OP nao encerrada."
      #define STR0026 "Op nao encontrada ou encerrada."
      #define STR0027 "Movimento nao gerou encerramento da OP"
      #define STR0028 "Estorne o movimento que gerou o encerramento da OP."
      #define STR0029 "LoteNeg"
      #define STR0030 "Saldo em estoque menor que o saldo solicitado."
      #define STR0031 "Saldo em estoque para o produto: "
      #define STR0032 "Quantidade solicitada: "
      #define STR0033 " Nao e possivel encerrar uma ordem de producao vinculada. Encerre a ordem producao principal."
      #define STR0034 "OP principal foi encerrada!"
      #define STR0035 "N�o � poss�vel apontar OP do produto intermedi�rio"
      #define STR0036 "O lote escolhido no apontamento � diferente do lote da OP!"
      #define STR0037 "Lote Apontamento: "
      #define STR0038 "Lote OP: "      
      #define STR0039 "A Op original ja possui quantidade apontadas."
      #define STR0040 "Estorne antes o movimento da Op original."
      #define STR0041 "Movimento Interno com valoriza��o, deve-se informar ao menos um campo com valor maior que zero."
      #define STR0042 "Informe a valoriza��o desse movimento."
      #define STR0043 "Movimento Interno com quantidade igual a zero."
      #define STR0044 "Informe uma quantidade."
      #define STR0045 "N�o � permitido movimenta��o interna para produtos que n�o possuem saldo."
      #define STR0046 "Informe um produto com saldo em estoque."
      #define STR0047 "Rateio"
      #define STR0048 "N�o ser� poss�vel realizar o estorno    desse lancamento pois pertence a um     apontamento de produ��o."
      #define STR0049 "Realize a Exclus�o do Apontamento."
      #define STR0050 "Essa Ordem de Produ��o est� bloqueada portanto n�o poder� ser apontada a produ��o."
      #define STR0051 "O usu�rio responsavel deve desbloquear essa Ordem de Produ��o."
      #define STR0052 "Alterar"
      #define STR0053 "N�o ser� poss�vel realizar a altera��o desse lancamento pois pertencente a movimenta��es do sistema."
      #define STR0054 "Este produto possui controle de lote ou FIFO."
      #define STR0055 "A data de fabrica��o, data de validade e c�digo do lote devem ser preenchidos."
      #define STR0056 "Este produto n�o possui controle de lote ou FIFO."
      #define STR0057 "A data de fabrica��o, data de validade e c�digo do lote n�o devem ser preenchidos."
      #define STR0058 "Movimenta��o sem informa��es de rateio."
      #define STR0059 "Informe o rateio."
   #ELSE
      #define STR0001 "Pesquisar"
      #define STR0002 "Visualizar"
      #define STR0003 "Incluir"
      #define STR0004 "Estornar"
      #define STR0005 "Movimentacoes Internas"
      #define STR0006 "Este programa permite a manuten��o das Movimentacoes Internas"
      #define STR0007 "Esta movimenta��o interna n�o � uma requisi��o / devolu��o manual, portanto n�o poder� ser acessada por esta rotina."
      #define STR0008 "Esta movimenta��o j� foi estornada."
      #define STR0009 "Mude de registro se quiser efetuar o estorno."
      #define STR0010 "O produto informado n�o est� relacionado a Ordem de Produ��o."
      #define STR0011 "Informe outro produto ou outra Ordem de Produ��o relacionada ao produto."
      #define STR0012 "A Ordem de Produ��o informada n�o tem saldo suficiente."
      #define STR0013 "Informe outra Ordem de Produ��o."
      #define STR0014 "A quantidade informada dever� ser id�ntica a quantidade informada na Ordem de Produ��o."
      #define STR0015 "Informe a quantidade correta."
      #define STR0016 "Informe o produto corretamente."
      #define STR0017 "O n�mero da OP est� em branco e este campo � obrigat�rio nas produ��es."
      #define STR0018 "Digite o n�mero da OP."
      #define STR0019 "Movimenta��es de transferencia devem ser estornadas na propria tela."
      #define STR0020 "V� at� a rotina de Transferencia e fa�a o estorno."
      #define STR0021 "N�o � poss�vel realizar a opera��o pois o estoque ficar� negativo."
      #define STR0022 "Para resolver o problema, altere o      par�metro MV_ESTNEG ou contate o        administrador do sistema."		  
      #define STR0023 "Encerrar"
      #define STR0024 "Op Encerrada com sucesso."
      #define STR0025 "Problemas com quantidade, OP nao encerrada."
      #define STR0026 "Op nao encontrada ou encerrada."
      #define STR0027 "Movimento nao gerou encerramento da OP"
      #define STR0028 "Estorne o movimento que gerou o encerramento da OP."
      #define STR0029 "LoteNeg"
      #define STR0030 "Saldo em estoque menor que o saldo solicitado."
      #define STR0031 "Saldo em estoque para o produto: "
      #define STR0032 "Quantidade solicitada: "
      #define STR0033 " Nao e possivel encerrar uma ordem de producao vinculada. Encerre a ordem producao principal."
      #define STR0034 "OP principal foi encerrada!"
      #define STR0035 "N�o � poss�vel apontar OP do produto intermedi�rio"
      #define STR0036 "O lote escolhido no apontamento � diferente do lote da OP!"
      #define STR0037 "Lote Apontamento: "
      #define STR0038 "Lote OP: "      
      #define STR0039 "A Op original ja possui quantidade apontadas."
      #define STR0040 "Estorne antes o movimento da Op original."
      #define STR0041 "Movimento Interno com valoriza��o, deve-se informar ao menos um campo com valor maior que zero."
      #define STR0042 "Informe a valoriza��o desse movimento."
      #define STR0043 "Movimento Interno com quantidade igual a zero."
      #define STR0044 "Informe uma quantidade."
      #define STR0045 "N�o � permitido movimenta��o interna para produtos que n�o possuem saldo."
      #define STR0046 "Informe um produto com saldo em estoque."
      #define STR0047 "Rateio"
      #define STR0048 "N�o ser� poss�vel realizar o estorno    desse lancamento pois pertence a um     apontamento de produ��o."
      #define STR0049 "Realize a Exclus�o do Apontamento."
      #define STR0050 "Essa Ordem de Produ��o est� bloqueada portanto n�o poder� ser apontada a produ��o."
      #define STR0051 "O usu�rio responsavel deve desbloquear essa Ordem de Produ��o."
      #define STR0052 "Alterar"
      #define STR0053 "N�o ser� poss�vel realizar a altera��o desse lancamento pois pertencente a movimenta��es do sistema."
      #define STR0054 "Este produto possui controle de lote ou FIFO."
      #define STR0055 "A data de fabrica��o, data de validade e c�digo do lote devem ser preenchidos."
      #define STR0056 "Este produto n�o possui controle de lote ou FIFO."
      #define STR0057 "A data de fabrica��o, data de validade e c�digo do lote n�o devem ser preenchidos."
      #define STR0058 "Movimenta��o sem informa��es de rateio."
      #define STR0059 "Informe o rateio."
   #ENDIF
#ENDIF