#include 'protheus.ch'
#include 'parmtype.ch'

/*/   {Protheus.doc} F430BXA

Descri��o : P.E para t�tulos baixados no Cnab. P.E p�s baixa do t�tulo posisiconado
            Gerar registro de Movimenta��o de Reposi��o de Caixinha, para t�tulos baixado;
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