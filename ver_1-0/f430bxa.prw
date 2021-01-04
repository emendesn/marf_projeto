#include 'protheus.ch'
#include 'parmtype.ch'

/*/   {Protheus.doc} F430BXA

Descrição : P.E para títulos baixados no Cnab. P.E pós baixa do título posisiconado
            Gerar registro de Movimentação de Reposição de Caixinha, para títulos baixado;
    		Rotinas pertencentes: Cnab (Fina430.prw)
@author Henrique Vidal
@since 04/03/2020
@return Null
/*/

User Function F430BXA()

	If ExistBlock("MGFFINBI")
		U_MGFFINBI()
    EndIf

Return 