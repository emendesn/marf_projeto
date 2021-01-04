/*
=====================================================================================
Programa.:              MGFFIS17
Autor....:              Atilio Amarilla
Data.....:              15/03/2017
Descricao / Objetivo:   Validar fornecedores no cadastro Entrega por Terceiros
Doc. Origem:            Contrato - GAP FIS02
Solicitante:            Cliente
Uso......:              
Obs......:              Amarra fornecedores. Todos devem possuir a mesma raiz do CNPJ
=====================================================================================
*/
/*
=====================================================================================
Incluir validacao (X3_VLDUSER) nos campos CPW_CODIGO, CPW_LOJA, CPX_CODFOR, CPX_LOJFOR:
IIF(FindFunction("U_MGFFIS17"),U_MGFFIS17(),.T.)
=====================================================================================
Parametro MGF_FIS02A habilita validacao
=====================================================================================
*/
User Function MGFFIS17()
	
	Local lRet	:= .T.
	
	If GetMv("MGF_FIS02A",,.T.) //
		If "CPW" $ ReadVar()
			If !Empty( FwFldGet('CPW_CODIGO') ) .And. !Empty( FwFldGet('CPW_LOJA') ) .And. ;
					!Empty( FwFldGet('CPX_CODFOR',1) ) .And. !Empty( FwFldGet('CPX_LOJFOR',1) )
				If Subs( GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+  FwFldGet('CPW_CODIGO')+FwFldGet('CPW_LOJA'),1,"") , 1 , 8 ) <> ;
						Subs( GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+FwFldGet('CPX_CODFOR',1)+FwFldGet('CPX_LOJFOR',1),1,"") , 1 , 8 )
					lRet := .F.
					Help( ,,"CNPJ - Amarracao Fornecedores", ,"Fornecedores nao pertencem ao mesmo grupo." ,1,0)
				EndIf
			ElseIf !Empty( FwFldGet('CPW_CODIGO') ) .And. !Empty( FwFldGet('CPW_LOJA') ) .And. ;
				Empty( GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+FwFldGet('CPW_CODIGO')+FwFldGet('CPW_LOJA'),1,"") )
				lRet := .F.
				Help( ,,"CNPJ inv�lido", ,"Fornecedor+Loja: "+FwFldGet('CPW_CODIGO') + FwFldGet('CPW_LOJA') ,1,0)
			EndIf
		ElseIf Empty( FwFldGet('CPW_CODIGO') ) .Or. Empty( FwFldGet('CPW_LOJA') )
			lRet := .F.
			Help( ,,"Atencao", ,"Incluir Codigo + Loja",1,0)
		ElseIf !Empty( FwFldGet('CPX_CODFOR') ) .And. !Empty( FwFldGet('CPX_LOJFOR') )
			If Subs( GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+  FwFldGet('CPW_CODIGO')+FwFldGet('CPW_LOJA'),1,"") , 1 , 8 ) <> ;
					Subs( GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+FwFldGet('CPX_CODFOR')+FwFldGet('CPX_LOJFOR'),1,"") , 1 , 8 )
				lRet := .F.
				Help( ,,"CNPJ - Amarracao Fornecedores", ,"Fornecedores nao pertencem ao mesmo grupo." ,1,0)
			EndIf
		EndIf
	EndIf
	
Return lRet
