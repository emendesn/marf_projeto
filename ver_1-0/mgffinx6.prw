#Include "Protheus.ch"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "FWMBROWSE.CH"
/*/
=============================================================================
{Protheus.doc} MGFFINX6
Integração com Salesforce Títulos a Receber - Financeiro
@description
Funcao chamada pelo ponto de entrada MS520DEL
Atualizar a Flag, para realizar a integração de titulos de NF excluidas.
@author Rogerio Almeida de Oliveira
@since 19/03/2020
@type Function
@table
 SF2 - Cab NF de saída
 SE1 - Títulos a receber
@param
@return
 Sem retorno
@menu
 Sem menu
/*/

User Function MGFFINX6()
	Local aAreaAtu	:= GetArea()
	Local aAreaSE1	:= SE1->(GetArea())
	Local cAliasSE1	:= GetNextAlias()
 
	__execSql(cAliasSE1," SELECT R_E_C_N_O_ AS SE1RECNO FROM  "+RetSqlName('SE1')+" WHERE E1_NUM =  "+___SQLGetValue(SF2->F2_DOC)+" AND E1_PREFIXO =  "+___SQLGetValue(SF2->F2_SERIE)+" AND E1_CLIENTE =  "+___SQLGetValue(SF2->F2_CLIENTE)+" AND E1_LOJA =  "+___SQLGetValue(SF2->F2_LOJA)+" AND E1_FILIAL = "+___SQLGetValue(SF2->F2_FILIAL)+" AND D_E_L_E_T_= '*'",{},.F.)
	TcSetField(cAliasSE1,"SE1RECNO","N",10,0)

	(cAliasSE1)->(dbGoTop())

	dbSelectArea("SE1")

	While (cAliasSE1)->(!EOF())
        
		SE1->(dbGoTo((cAliasSE1)->SE1RECNO))

		SE1->(RecLock("SE1", .F. ))
			
		SE1->E1_XINTSFO	:= "P" //Flag para integração do titulo com Salesforce
		
        SE1->(MsUnlock())
        (cAliasSE1)->(dbSkip())
	End

	(cAliasSE1)->(dbCloseArea())

RestArea(aAreaAtu)
Return