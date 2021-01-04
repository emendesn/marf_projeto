#include "protheus.ch"
#define CRLF CHR(13) + CHR(10)

/*/{Protheus.doc} MGFCOM87
//Descrição : Ponto de Entrada MT100TOK() ativada em MATA103, que chama MGFCOM87(), para consistir Natureza da NFE
@author Andy Pudja / Welington
@since 21/11/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
user function MGFCOMB1() // Tratamento para NFE do Tipo "NFS"
	Local _lRetComB1 	:= .T.
	Local _aRotExc		:= STRTOKARR(SuperGetMV("MGF_COMB1R",.F.,'GFEA065;MGFINT09'),";") //Rotinas que não passarão pela validação
	Local _nBloqMSG		:= SuperGetMV("MGF_COMB1B",.T.,2) //Comportamento da rotina: 1-Bloquerá a gravação; 2-Apenas alertará; 0-Nada fara.
	Local _cCodMun 		:= ""
	Local _cEstEnt 		:= ""
	Local _cMsg         := 'Nota Fiscal com Espécie "NFS", deverá utilizar '
	Local _cMsg1        := ""
	Local _cMsg2        := ""
	Local _nErro1		:= 0
	Local _nErro2		:= 0
	Local _nErroT		:= 0 
	Local _nRegEmp		:= SM0->(RecNo())

	//Verifica se as rotinas que não devem passar pela validação estão na pilha de chamada. Se estiver, sai da função. 
	For nCnt := 1 To Len(_aRotExc)
		If IsInCallStack(Alltrim(_aRotExc[nCnt]))
			Return .T.
		EndIf
	Next
	
	dbSelectArea("SM0")
	dbGoto(_nRegEmp)

	_cEstEnt := AllTrim(SM0->M0_ESTENT) 
	_cCodMun := SubStr(AllTrim(SM0->M0_CODMUN),3,5) 
	
	//Verifica os campos de UF e Município.
	If AllTrim(MaFisRet(,"NF_UFPREISS")) <> _cEstEnt 
		_cMsg1 		:= 'Unidade Federal: ' + _cEstEnt  
		_nErro1 	:= 1
		_lRetComB1 	:= .F.
	EndIf
	If AllTrim(MaFisRet(,"NF_CODMUN")) <> _cCodMun 
		_cMsg2 		:= 'Código de Municipio: ' + _cCodMun + " - " + AllTrim(SM0->M0_CIDENT) 
		_nErro2 	:= 2
		_lRetComB1 	:= .F.
	EndIf

	//Composição da mensagem de erro
	_nErroT := _nErro1 + _nErro2
	If _nErroT > 0
		If _nErroT == 1  
			_cMsg += _cMsg1 + " da Filial: " + AllTrim(SM0->M0_CODFIL) + " - " + AllTrim(SM0->M0_FILIAL)			
		Else
			If _nErroT == 2  
				_cMsg += _cMsg2 + " da Filial: " + AllTrim(SM0->M0_CODFIL) + " - " + AllTrim(SM0->M0_FILIAL)			
			Else
				_cMsg += _cMsg1 + " e " + _cMsg2 + " da Filial: " + AllTrim(SM0->M0_CODFIL) + " - " + AllTrim(SM0->M0_FILIAL)			
			EndIf 
		EndIf 
	EndIf
	
	
	//Verifica qual o comportamento foi parâmetrizado para a rotina: 1-Bloquerá a gravação; 2-Apenas alertará; 0-Nada fara.
	If !_lRetComB1 .AND. _nErroT > 0
		If _nBloqMSG = 0
			_lRetComB1 := .T.

		ElseIf _nBloqMSG = 1
			MsgAlert(_cMsg)

		ElseIf MsgYesNo(_cMsg + "." + CRLF + "Deseja continuar?","MGFCOMB1")
				_lRetComB1 := .T.
		EndIf
	EndIf
	
return _lRetComB1