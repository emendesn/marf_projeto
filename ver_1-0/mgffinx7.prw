#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
/*/
=============================================================================
{Protheus.doc} MGFFINX7
Integração com Salesforce Dados de Desconto de Contratos
@description
Funcao chamada pelo ponto de entrada CNTA300
Funcao para atualizar a Flag no cad. do cliente , ao realizar a manutenção em contratos.
Doc. Origem:  Contrato - GAP MGFGCT02
@author Rogerio Almeida de Oliveira
@since 13/03/2020
@type Function
@table
 SA1 - Clientes
@param
@return
 Sem retorno
@menu
 Sem menu
/*/

User Function MGFFINX7(cProc)

    Local lFilPes := superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica
    Local aAreaAtu      := GetArea()    
    Local nI            := 0    
    Local aParam	    := {}
	Local cIdPonto	    := ""
    //Variaveis de contrato:
    Local oModel 		:= nil
    Local oMolSA1		:= nil
    Local aSaveLines    := {} 
    Local cCliente      := " "
    Local cLoja         := " "
    Local cUpdSA1       := " "
    Local xRet          := .T.    
    //Variaveis de revisão:
    Local oModelR 		:= nil 
    Local oMoSA1R		:= nil 
    Local aSaveLineR    := {}  
    Local cClientR      := " " 
    Local cLojaR        := " " 
    Local cUpdA1R       := " "
   
    aParam		:= PARAMIXB
    
    If aParam <> NIL
        cIdPonto    := aParam[2]
    endif    
   
    //Processo 1 - Tratamento de Contrato
    If (cProc == "1")  

        if ( cIdPonto == "MODELCOMMITNTTS" ) 
            
            oModel      :=  FWModelActive()
            oMolSA1	    :=  oModel:GetModel("CNCDETAIL")
            aSaveLines  :=  FWSaveRows()

            For nI := 1 To oMolSA1:Length()
                
                cCliente      := " "
                cLoja         := " "
                oMolSA1:GoLine( nI )

                //Independente da operacao precisa ajustar o flag do cliente 
                If oMolSA1:IsDeleted()
                    cCliente  := oMolSA1:getValue("CNC_CLIENT", nI)
                    cLoja     := oMolSA1:getValue("CNC_LOJACL", nI)               
                ElseIf oMolSA1:IsInserted()
                    cCliente  := oMolSA1:getValue("CNC_CLIENT", nI)
                    cLoja     := oMolSA1:getValue("CNC_LOJACL", nI)  
                ElseIf oMolSA1:IsUpdated()
                    cCliente  := oMolSA1:getValue("CNC_CLIENT", nI)
                    cLoja     := oMolSA1:getValue("CNC_LOJACL", nI)  
                EndIf

                If !Empty(cCliente) .and. !Empty(cLoja)
                    //Update da tabela de preço na tabela de Cliente
                    cUpdSA1 := "UPDATE " + retSQLName("SA1")											+ CRLF
                    cUpdSA1 += "	SET"																+ CRLF
                    cUpdSA1 += "		A1_XINTSFO = 'P' "              								+ CRLF
                    cUpdSA1 += " WHERE"																	+ CRLF
                    cUpdSA1 += " 		A1_COD		=	'" + cCliente +"'"	                            + CRLF
                    cUpdSA1 += " 	AND	A1_LOJA		=	'" + cLoja +"'"	                                + CRLF
                    cUpdSA1 += " 	AND	A1_EST	<>	'EX' "          	                                + CRLF        
                    if lFilPes
                        cUpdSA1 += "	AND	A1_PESSOA = 'J' "			        			            + CRLF
                    endif
                    cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1") +"'"	                    + CRLF
                    cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

                    if tcSQLExec( cUpdSA1 ) < 0
                        conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
                    endif
                
                endif

            Next

            FWRestRows( aSaveLines )
        endif    

        RestArea(aAreaAtu)
    ENDIF

    //Processo 2 - Tratamento de Revisão de Contrato
    if(cProc == "2") 
    
        if (cIdPonto == "FORMPOS") //Formulário pos revisão
            
            oModelR     :=  FWModelActive()
            oMoSA1R	    :=  oModelR:GetModel("CNCDETAIL")
            aSaveLineR  :=  FWSaveRows()

            For nI := 1 To oMoSA1R:Length()
                
                cClientR      := " "
                cLojaR         := " "
                oMoSA1R:GoLine( nI )

                cClientR  := oMoSA1R:getValue("CNC_CLIENT", nI)
                cLojaR     := oMoSA1R:getValue("CNC_LOJACL", nI)            

                If !Empty(cClientR) .and. !Empty(cLojaR)
                    //Update da tabela de preço na tabela de Cliente
                    cUpdA1R := "UPDATE " + retSQLName("SA1")											+ CRLF
                    cUpdA1R += "	SET"																+ CRLF
                    cUpdA1R += "		A1_XINTSFO = 'P' "              								+ CRLF
                    cUpdA1R += " WHERE"																	+ CRLF
                    cUpdA1R += " 		A1_COD		=	'" + cClientR +"'"	                            + CRLF
                    cUpdA1R += " 	AND	A1_LOJA		=	'" + cLojaR +"'"	                            + CRLF
                    cUpdA1R += " 	AND	A1_EST	<>	'EX' "          	                                + CRLF        
                    if lFilPes
                        cUpdA1R += "	AND	A1_PESSOA = 'J' "			        			            + CRLF
                    endif
                    cUpdA1R += " 	AND	A1_FILIAL	=	'" + xFilial("SA1") +"'"	                    + CRLF
                    cUpdA1R += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

                    if tcSQLExec( cUpdA1R ) < 0
                        conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
                    endif
                
                endif

            Next

            FWRestRows( aSaveLineR )
        endif    

        RestArea(aAreaAtu)    

    ENDIF

Return xRet