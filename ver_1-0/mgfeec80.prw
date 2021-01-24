#include "rwmake.ch"
#include "protheus.ch"
#include "totvs.ch"

/*/{Protheus.doc} MGFEEC80

Descrição : Função para gerar parcelas a pagar no embarque de exportação.
			
			A rotina EECAE100 padrão Totvs parou de tratar processos de embarque com intermediação, a partir de 
			chamada via ExecAuto. Veja FNC
			
			Processos de intermediação só estão funcionando via tela. 
			
			Como o job MGFINT72 altera dados do processo de embarque via Execauto, estava ficando sem parcela a pagar
			da filial do exterior para o Brasil. 
			
			Criado essa rotina para que quando passar pela gravação das parcelas, o ponto de entrada grave a parcela do evento 133 que deveria estar sendo criada pelo execauto. 
			
			O Job MGFINT72, devido ao mesmo erro da rotina EEACE100 já gera os títulos de embarque offshore para a filial do exterior manualmente. 
			
			Aberto FNC na Totvs para tratar correção do execauto na rotina EECAE100. 
			
			Após correção e validação do processo, esse fonte deve ser removido do projeto juntamente com 
			a chamada desta função no fonte EECAF200.PRW
			
			FNC TOTVS 	: 8828093 
			PRB MARFRIG	: PRB0040826

@author Henrique Vidal
@since 30/04/2020
@return Null
/*/

User Function MGFEEC80()

	Default _aPrcOff := {}

	If (IsInCallStack("U_MGFINT72") .Or. IsInCallStack("U_MONINT72") ) .and. GetNewPar('MGF_INT72X' , .T.)
		
		cDespIntFin	  += '/133'		
		aParcOffShore := AF200GPCD( AF200TotParc(cFilBr)[1],EEC->(EEC_CONDPA+Str(EEC_DIASPA, 3)),dDTEMBA,"133",EEC->EEC_FORN,EEC->EEC_FOLOJA,"" )
				
		If Empty(_aPrcOff)
			_aPrcOff := AClone(aParcOffShore)
		Else
			aParcOffShore := _aPrcOff	// Filial 90001 calculando errado no programa padrão, altero para o valod calculado na filail Brasil.
		EndIF

		aadd( aparc 	, aParcOffShore )
	EndIf

Return