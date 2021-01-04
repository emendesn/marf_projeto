#include 'protheus.ch'
#include 'parmtype.ch'

//========================================================================================
/*/{Protheus.doc} MGFFATAF
//Habilitar tecla <F4> no campo C6_PRODUTO para chamar rotina Painel de Estoque (MGFEST21)
@type function
@author Ferraz
@since 24/10/2018
@version 12.1.17
@return .T.
@example
@history 24/10/2018, Odair Ferraz, Uso Marfrig, Criação cfe. MIT044: 675
@history 25/10/2018, Odair Ferraz, Uso Marfrig, Alteração da tela chamada para a de Saldo Padrão do Estoque
/*/
//========================================================================================

User Function MGFFATAF()

Local c_RetVar := M->C6_PRODUTO

//iIf(FindFunction("U_MGFEST21") .and. !EMPTY(M->C6_PRODUTO),SetKey(VK_F4,{|| u_MGFEST21()}),SetKey(VK_F4, {||})) 

iIf(FindFunction("MaViewSB2") .and. !EMPTY(M->C6_PRODUTO),SetKey(VK_F9,{|| MaViewSB2(M->C6_PRODUTO)}),SetKey(VK_F9, {||}))
	
return(c_RetVar)




//Rotina chamada no Gatilho do campo C6_PRODUTO
/*
OBS: gatilhos necessarios para este GAP funcionar

SX7
CAMPO: C6_PRODUTO
SEQ: 016
CNT. DOMINIO: C6_PRODUTO
TIPO: PRIMARIO
REGRA: U_MGFFATAF()
POSICIONA: NAO
*/