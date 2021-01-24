#include "rwmake.ch"
#include "protheus.ch"
#include "totvs.ch"

/*/{Protheus.doc} MGFEEC80

Descri��o : Fun��o para gerar parcelas a pagar no embarque de exporta��o.
			
			A rotina EECAE100 padr�o Totvs parou de tratar processos de embarque com intermedia��o, a partir de 
			chamada via ExecAuto. Veja FNC
			
			Processos de intermedia��o s� est�o funcionando via tela. 
			
			Como o job MGFINT72 altera dados do processo de embarque via Execauto, estava ficando sem parcela a pagar
			da filial do exterior para o Brasil. 
			
			Criado essa rotina para que quando passar pela grava��o das parcelas, o ponto de entrada grave a parcela do evento 133 que deveria estar sendo criada pelo execauto. 
			
			O Job MGFINT72, devido ao mesmo erro da rotina EEACE100 j� gera os t�tulos de embarque offshore para a filial do exterior manualmente. 
			
			Aberto FNC na Totvs para tratar corre��o do execauto na rotina EECAE100. 
			
			Ap�s corre��o e valida��o do processo, esse fonte deve ser removido do projeto juntamente com 
			a chamada desta fun��o no fonte EECAF200.PRW
			
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
			aParcOffShore := _aPrcOff	// Filial 90001 calculando errado no programa padr�o, altero para o valod calculado na filail Brasil.
		EndIF

		aadd( aparc 	, aParcOffShore )
	EndIf

Return