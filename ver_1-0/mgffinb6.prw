#include "protheus.ch"
#include 'parmtype.ch'
/*/{Protheus.doc} MGFCOM87
//Descri��o : Ativada pelo Ponto de Entrada FA080TIT() em FINA080 para gerar registro de Movimenta��o de Reposi��o de Caixinha na baixa de T�tulo
@author Andy Pudja / Eric
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
user function MGFFINB6()
	Local _lRet		:= .T.
	Local _aArea 	:= GetArea()
	Local _cCaixa	:= "" 

	Private cCadastro := OemtoAnsi("Gera�ao Autom�tica de Caixinhas")  // "Manutencao de Caixinhas"
	Private lArgTAL   :=  (cPaisLoc == "ARG" .And. SEU->(FieldPos("EU_TALAO"))>0 ) 
		
	Pergunte("FIA550",.F.)
	
	If AllTrim(SE2->E2_PREFIXO) == "CXA"
		_cCaixa:= SubStr(AllTrim(SE2->E2_HIST),5,3) // "CXA-nnn"
		If !Empty(_cCaixa)
			
			If xFilial("SE2") <> SE2->E2_FILIAL
				cFilAnt := SE2->E2_FILIAL
			EndiF
			//********************
			// Gerando Reposi��o 
			//********************
			dbSelectArea("SET")
			dbSetOrder(1)  // filial + caixa
			dbSeek( xFilial()+_cCaixa)
			U_MGFRepos("SET",SET->(RECNO()),4,.T.) // cAlias,nReg,nOpc,lAutomato=.T. n�o mostra Tela de Reposi��o!!!
			
			//****************************************************
			// Tem de Atrelar esta Reposi��o ao T�tulo que a gerou 
			//****************************************************
			dbSelectArea("SEU")
			RecLock("SEU",.F.)
			REPLACE EU_HISTOR WITH SE2->E2_NUM + " - " + SEU->EU_HISTOR
			MsUnlock()
			
			
			
			
		EndIf
	EndIf
	RestArea(_aArea)
return _lRet