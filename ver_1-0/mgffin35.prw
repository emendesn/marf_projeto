#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa............: MGFFIN35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela para cadastro de Atendente
=====================================================================================
*/
User Function MGFFIN35()
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= ""	//ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "AxInclui" 	, 0 , 3 },; 
						{ "Excluir" 	, "u_FIN35Del" 	, 0 , 5 }} 

Private bFiltraBrw 	:= { || FilBrowse( "ZZ8" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Atendente" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "ZZ8" ) 

EndFilBrw( "ZZ8" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL ) 

/*
=====================================================================================
Programa............: MGFFAT35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Exclusao de Atendente
=====================================================================================
*/
User Function FIN35Del()
Local aArea		:= GetArea()
      
DbSelectArea("ZZB")
DbSetOrder(2)
If DbSeek(xFilial("ZZB")+ZZ8->ZZ8_USUARI)
	MsgInfo("Nao � possivel excluir este Atendente porque j� realizou atendimento a cliente!","Atencao")
Else
	DbSelectArea("ZZ8")
	RecLock("ZZ8")
		ZZ8->(DbDelete())
	ZZ8->(MsUnlock())        
Endif

//Finaliza o Filtro         
RestArea(aArea)
	
Return  


/*
=====================================================================================
Programa............: MGFFIN35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela para cadastro de Posicionamento do cliente
=====================================================================================
*/
User Function MGFIN35B()
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= ""	//ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "AxInclui" 	, 0 , 3 },; 
						{ "Alterar" 	, "AxAltera" 	, 0 , 3 },; 
						{ "Excluir" 	, "u_FI35BDel" 	, 0 , 5 }} 

Private bFiltraBrw 	:= { || FilBrowse( "ZZ9" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Posicao" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "ZZ9" ) 

EndFilBrw( "ZZ9" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL ) 

/*
=====================================================================================
Programa............: MGFFAT35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Exclusao de Posicao
=====================================================================================
*/
User Function FI35BDel()
Local aArea		:= GetArea()
      
DbSelectArea("ZZB")
DbSetOrder(3)
If DbSeek(xFilial("ZZB")+ZZ9->ZZ9_CODPOS)
	MsgInfo("Nao � possivel excluir porque existe atendimento com este posicionamento de cliente!","Atencao")
Else
	DbSelectArea("ZZ9")
	RecLock("ZZ9")
		ZZ9->(DbDelete())
	ZZ9->(MsUnlock())        
Endif

//Finaliza o Filtro         
RestArea(aArea)
	
Return  


/*
=====================================================================================
Programa............: MGFFIN35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela para cadastro de Gerente
=====================================================================================
*/
User Function MGFIN35C()
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= ""	//ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "AxInclui" 	, 0 , 3 },; 
						{ "Alterar" 	, "AxAltera" 	, 0 , 3 },; 
						{ "Excluir" 	, "u_FI35CDel" 	, 0 , 5 }} 

Private bFiltraBrw 	:= { || FilBrowse( "ZZA" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Gerente" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "ZZA" ) 

EndFilBrw( "ZZA" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL ) 

/*
=====================================================================================
Programa............: MGFFAT35
Autor...............: Marcos Andrade         
Data................: 27/10/2016 
Descricao / Objetivo: Cadastro de Gerente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Exclusao de Gerente
=====================================================================================
*/
User Function FI35CDel()
Local aArea		:= GetArea()
      
DbSelectArea("ZZA")
RecLock("ZZA")
	ZZA->(DbDelete())
ZZA->(MsUnlock())        


//Finaliza o Filtro         
RestArea(aArea)
	
Return  





