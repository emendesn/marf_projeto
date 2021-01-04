#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT121BRW
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Este ponto de entrada possui a mesma funcionalidade do ponto MT120BRW com o diferencial de que possibilita que a rotina MATA121 seja utilizada no Configurador (SIGACFG) para definir regras de Privilégios de acesso ao pedido de compras para usuários incluindo o menu personalizado do ponto de entrada.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=51249528
=====================================================================================
*/
User Function MT121BRW()

Local nPos := 0

If findfunction("U_xMC8120M")	
	AADD(aRotina,{OemToAnsi('Log Aprovacao'),"U_xMC8120M", 0 , 2, 0, nil})
Endif
If findfunction("U_MGFCOMP")
	AADD(aRotina,{	OemtoAnsi("Descrição do Produto") ,'U_MGFCOMP', 0 , 4, 0, nil })  
Endif
If findfunction("U_MGFMatr")
	AADD(aRotina,{	OemtoAnsi("Imprimir") ,'U_MGFMatr', 0 , 4, 0, nil })  
Endif
If findfunction("U_MGFCTB09")
	AADD(aRotina,{	OemtoAnsi("Incluir Rateio") ,'U_MGFCTB09', 0 , 4, 0, nil })  
Endif		
If findfunction("U_TAE02_ALT")
	AADD(aRotina,{	OemtoAnsi("Altera Produto") ,'U_TAE02_ALT', 0 , 4, 0, nil })  
Endif		
// tela para consultar NFE´s relacionadas ao PC/Aut. Entr.
If findfunction("U_MGFCOM91")
	AADD(aRotina,{	OemtoAnsi("Consulta NFE relacionadas ao PC/Aut.Ent.") ,'U_MGFCOM91', 0 , 4, 0, nil })  
Endif		
If findfunction("U_MGFCOM98")
	AADD(aRotina,{	OemtoAnsi("Cancela Pedidos de compras") ,'U_MGFCOM98', 0 , 4, 0, nil })  
Endif		
	
// excluir relatorio de pedido de compra padrao do menu, pois deve ficar somente o relatorio customizado de pedido de compra, 'U_MGFMatr' 
If (nPos:=aScan(aRotina,{|x| Alltrim(Upper(x[2]))=="A120IMPRI"})) > 0
	aDel(aRotina,nPos)
	aRotina := aSize(aRotina,Len(aRotina)-1)
Endif
	
Return