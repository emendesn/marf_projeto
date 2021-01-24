#Include "Protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT02
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de departamentos
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para cadastro departamentos utilizada na tabela de preco
=====================================================================================
*/

User Function MGFFAT02() 
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= ""	//ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "AxInclui" 	, 0 , 3 },; 
						{ "Alterar" 	, "AxAltera" 	, 0 , 4 },; 
						{ "Excluir" 	, "u_T02Del" 	, 0 , 5 },;
						{ "Usuarios" 	, "u_FT02Usr" 	, 0 , 6 }} 

Private bFiltraBrw 	:= { || FilBrowse( "SZD" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Departamento" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "SZD" ) 

EndFilBrw( "SZD" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL ) 

/*
=====================================================================================
Programa............: MGFFAT03
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de Tipos de pedido
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Exclusao de tipo de pedido
=====================================================================================
*/
User Function T02Del()
      
DbSelectArea("SZF")
DbSetOrder(2)
If DbSeek(xFilial("SZF")+SZD->ZD_COD)
	MsgInfo("Não é possivel excluir este departamento porque possui relacionamento com tabela de preço!","Atenção")
Else
	DbSelectArea("SZE")
	DbSetOrder(1)
	If DbSeek(xFilial("SZE")+SZD->ZD_COD)
	
		While SZE->ZE_FILIAL == xFilial("SZE") .AND. SZE->ZE_CODDEP == SZD->ZD_COD
			RecLock("SZE")
				SZE->(DbDelete())
			SZE->(MsUnlock())      	
			SZE->(DbSkip())
		End	
	Endif	
	DbSelectArea("SZD")
	RecLock("SZD")
		SZD->(DbDelete())
	SZD->(MsUnlock())        
Endif
	
Return  



/*
=====================================================================================
Programa............: MGFFAT02
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de departamentos X Usuarios
Doc. Origem.........: Contrato - GAP FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para Amarração entre o Departamento x Usuarios
=====================================================================================
*/       


User Function FT02Usr()

Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= "ZE_CODDEP == '" + SZD->ZD_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 		, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 		, 0 , 2 },; 
						{ "Incluir" 	, "u_T02Inclui" 	, 0 , 3 },; 
						{ "Excluir" 	, "u_T02DelUsr" 	, 0 , 5 }} 
//						{ "Alterar" 	, "AxAltera" 	, 0 , 4 },; 

Private bFiltraBrw 	:= { || FilBrowse( "SZE" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro Departamento x Usuario" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "SZE" ) 

EndFilBrw( "SZE" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL )
                       

/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de inclusao de favorecidos
=====================================================================================
*/

User Function T02Inclui (cAlias, nReg, nOpc) 
Local aArea		:= GetArea()      

AxInclui(cAlias,nReg,nOpc,,,,"u_F02Valid()")
                                
RestArea(aArea)
                        
Return


/*
=====================================================================================
Programa............: MGFFAT02
Autor...............: Marcos Andrade         
Data................: 15/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFAT02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de Exclusao da amarracao Fornecedor x Usuario
=====================================================================================
*/

User Function T02DelUsr (cAlias, nReg, nOpc) 
      
DbSelectArea("SZE")
RecLock("SZE")
	SZE->(DbDelete())
SZE->(MsUnlock())        
	
Return  
                            
                             
User Function F02RetUsr()                                                                                       
Local cRet	:= ""

cRet	:= UsrRetName(M->ZE_USER)

Return(cRet)                          

User Function  F02Valid()
Local aArea	:= GetArea()
Local lRet	:= .T.     
                        
DbSelectArea("SZE")
DbSetOrder(1)
If DbSeek(xFilial("SZE")+M->ZE_CODDEP+M->ZE_USER)
	MsgInfo("Funcionario já cadastrado para este departamento!")
	lRet:=.F.
Endif

RestArea(aArea)
Return(lRet)