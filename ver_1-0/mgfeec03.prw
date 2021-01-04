#Include "Protheus.ch"
#include "totvs.ch"

/*
===========================================================================================
Programa.:              MGFEEC03
Autor....:              Francis Oliveira
Data.....:              Out/2016
Descricao / Objetivo:   Browse para cadastrar os documentos   
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/

//=============================== Relacao das Functions =================================
// 01 - Funcao Principal - Cadastro de Documentos -  MGFEEC03()
// 02 - Legendas - LEGEEC03() 
//=======================================================================================


User Function MGFEEC03()

Private cCadastro := "Cadastro de Doc/Ativ Exportacao"

Private aRotina := {}

aAdd( aRotina, {"Pesquisar" 		,"AxPesqui"			,0,1} )
aAdd( aRotina, {"Visualizar"		,"AxVisual"			,0,2} )
aAdd( aRotina, {"Incluir"   		,"AxInclui"			,0,3} )
aAdd( aRotina, {"Alterar"   		,"AxAltera"			,0,4} )
aAdd( aRotina, {"Excluir"      		,"U_DELDOCEX()"		,0,5} )
aAdd( aRotina, {"Legenda"          	,"U_LEGEEC03()"     ,0,3} )

Private aCores := { {"ZZ_TIPO = 'D' ", 'BR_AZUL' },;
                    {"ZZ_TIPO = 'A' ", 'BR_VERDE' } }

Private cAlias := "SZZ"

DbSelectArea(cAlias)
DbSetOrder(1)
DbGoTop()
                         

	mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
	
DbSelectArea(cAlias)
	
Return

// 02 - Legendas
User Function LEGEEC03()
    
    aLegenda := { { "BR_AZUL",     "Documento" },;
                  { "BR_VERDE",    "Atividade" }}
                  
BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return

/*
=====================================================================================
Programa............: DELDOCEX
Autor...............: Barbieri         
Data................: 22/11/2016 
Descricao / Objetivo: Validacao de exclusao de documentos de exportacao
Doc. Origem.........: GAP EEC03
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function DELDOCEX()

	Local cQuery := ""
	Local cAliasZZJ := GetNextAlias()
	
	cQuery += " SELECT '*' "
	cQuery += " FROM " + RetSqlName("ZZJ") + " ZZJ "
	cQuery += " WHERE ZZJ_FILIAL = '"+xFilial("ZZJ")+"' "
	cQuery += " 	AND ZZJ_CODDOC= '"+SZZ->ZZ_CODDOC+"' "
	cQuery += " 	AND ZZJ.D_E_L_E_T_= ' ' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAliasZZJ)
	
	DbSelectArea("ZZ2")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZ2")+SZZ->ZZ_CODDOC)
		MsgInfo("Nao e possivel excluir este doc/ativ, existe relacionamento com cliente!","Atencao")
	ElseIf !(cAliasZZJ)->(Eof())
		MsgInfo("Nao e possivel excluir este doc/ativ, existe relacionamento com Pedido!","Atencao")
	Else   
		If MsgYesNo("Deseja excluir o documento "+SZZ->ZZ_CODDOC+"?")
			DbSelectArea("SZZ")
			RecLock("SZZ",.f.)
			SZZ->(DbDelete())
			SZZ->(MsUnlock())        
		EndIf
	Endif

Return  
