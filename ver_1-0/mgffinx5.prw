#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
/*/
=============================================================================
{Protheus.doc} MGFFINX5
Integração com Salesforce Dados Financeiros
@description
Funcao chamada pelos pontos de entrada FA330BX e FA330EAC
Funcao para atualizar a Flag, na compensação de títulos ou estorno da compensação.
@author Rogerio Almeida de Oliveira
@since 30/01/2020
@type Function
@table
 SA1 - Clientes
 SE1 - Contas a Receber
 @param

@return
 Sem retorno
@menu
 Sem menu
/*/
User Function MGFFINX5()
    Local lRetCl    := .F.
    Private cTipos  := SuperGetMv( "MGFWSC81E" , , "NF/JR/RA")  
    
    lRetCl := vldCli() //Valida Cliente
    //ORIGEM
    If lRetCl
        //Atualiza flag do titulo Original 
        FINX5ORI(cCliente,cLoja,cNum,cParcela)    
    EndIf

    //DESTINO
    //Verificar se o tipo do título está na regra de integração.
    If ALLTRIM(SE1->E1_TIPO) $ cTipos
        If lRetCl
            recLock("SE1", .F.)
                SE1->E1_XINTSFO := "P"
            SE1->(msUnLock())            
        endif
    endif
    
Return


/*/
==============================================================================================================================================================================
{Protheus.doc} vldCli()
Valida se é um cliente é válido p/ integrar o seu título com Salesforce
@type function
@author Rogerio Almeida
@since 21/01/2020
@version P12
/*/
static function vldCli()
Local cQrySA1  := ""
Local lRetSA1  := .F.
Local lFilPes := superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica

cQrySA1 := "SELECT A1_COD "			 									+ CRLF
cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ CRLF
cQrySA1 += " WHERE"														+ CRLF
cQrySA1 += "	SA1.D_E_L_E_T_ <> '*' "							     	+ CRLF
cQrySA1 += "	AND SA1.A1_COD	   =	'"+ SE1->E1_CLIENTE + "'"       + CRLF
cQrySA1 += "	AND SA1.A1_LOJA	   =	'"+ SE1->E1_LOJA + "'"			+ CRLF
if lFilPes
	cQrySA1 += "	AND SA1.A1_PESSOA = 'J' "					     	+ CRLF
endIf
cQrySA1 += "	AND SA1.A1_EST <> 'EX' "						     	+ CRLF
cQrySA1 += "    AND SA1.A1_XIDSFOR  <> ' ' "						    + CRLF
cQrySA1 += "	AND SA1.A1_FILIAL	=	'" + xFilial("SA1")		+ "'"	+ CRLF

tcQuery changeQuery(cQrySA1) New Alias "QRYSA1"

if !QRYSA1->(EOF())
	lRetSA1 := .T.
endif

QRYSA1->(DBCloseArea())

return lRetSA1


/*/
==============================================================================================================================================================================
{Protheus.doc} FINX5ORI()
Atualiza Flag do título Original
@type function
@author Rogerio Almeida
@since 30/01/2020
@version P12
/*/
static function FINX5ORI(cCliente,cLoja,cNum,cParcela)
	Local cUpdSE1 := ""
    
    cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
    cUpdSE1 += "	SET "															+ CRLF
    cUpdSE1 += "	E1_XINTSFO = 'P' "												+ CRLF

    cUpdSE1 += " WHERE D_E_L_E_T_	<> '*' "                                        + CRLF
    cUpdSE1 += " AND E1_CLIENTE = '"+cCliente+"' "                                  + CRLF
    cUpdSE1 += " AND E1_LOJA = '"+cLoja+"' "                                        + CRLF
    cUpdSE1 += " AND E1_NUM = '" +cNum+"' "                                         + CRLF
    cUpdSE1 += " AND E1_PARCELA = '" +cParcela+"' "                                 + CRLF
    cUpdSE1 += " AND E1_FILIAL	=	'" + xFilial("SE1") + "'"			            + CRLF
    cUpdSE1 += " AND E1_TIPO IN "+FormatIn(cTipos,"/")                              + CRLF 

    if tcSQLExec( cUpdSE1 ) < 0
        conout("Não foi possível executar UPDATE -FINX5TitOri." + CRLF + tcSqlError())
    endif
    
Return