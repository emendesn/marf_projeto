#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH' 
//#INCLUDE "SIGACUS.CH"
/*
============================================================================================================================
Programa.:              MGFCOM58 
Autor....:              Antonio Carlos        
Data.....:              10/11/2017                                                                                                            
Descricao / Objetivo:   Gravar tabela de amarracao Contrato de Parceria x Filial de Entrega
Doc. Origem:            Compras - GAP ID104
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de Entrada executado no progama MATA125  (Inclui e Altera)
============================================================================================================================
*/  
User Function MGFCOM58()
Local I          := 0   
Local cFilOri	 := cFilAnt
Local cMensagem  := " "
Local lContinua := .T.

Private lExecuta := .T.

IF lContinua = .T.
   
 	
   //cCodEmp := FWCodEmp()
                       
                          
   //msgbox("empresa"+cCodEmp)
 	
 	
 		//		msgAlert("Esta ocorrencia nao possui quantidade disponivel."+SC3->C3_FORNECE)
   // Criado no Matfilcalc para trazer todas empresas e filiais.
   aFilsAtu := MatFilCalc(.t.)   
   
   //UpdParam(aFilsAtu) 
   _Cfil :=""
   _Cnum :="" 
   _Cnum :=SC3->C3_NUM
   
      	FOR I = 1 TO LEN(aFilsAtu)
        	IF !EMPTY(aFilsAtu[I][1]) 
   				if _Cfil ="" 
   				_Cfil :=aFilsAtu[I][2]
    			endif                         
    		ENDIF
    	NEXT I            
                   // Aqui para gravar a filial de entrega para todos os itens do contrato.
                    //msgalert("achou"+_Cfil+" "+_Cnum)
                   	//_cQry	:= " UPDATE " + RetSqlName("SC3") + " SET C3_FILENT ='"+alltrim(_Cfil)+"' "
		    		//_cQry	+= " WHERE C3_NUM = '"+alltrim(_Cnum)+"'  AND D_E_L_E_T_<>'*' "
		    		//TcSqlExec(_cQry)

      //IF INCLUI 
      FOR I = 1 TO LEN(aFilsAtu)
        IF !EMPTY(aFilsAtu[I][1]) 
          DbSelectArea("ZD5") 
   	      ZD5->(dbSetOrder(1))   
          ZD5->(dBGotop())
          IF !DbSeek(xFilial("ZD5")+SC3->C3_NUM+alltrim(aFilsAtu[I][2])+SC3->C3_FORNECE+SC3->C3_LOJA+SC3->C3_ITEM)
                   RecLock("ZD5",.T.)
                   ZD5->ZD5_CONTRA := SC3->C3_NUM   
                   ZD5->ZD5_FORNEC := SC3->C3_FORNECE   
                   ZD5->ZD5_LOJA   := SC3->C3_LOJA
                   //ZD5->ZD5_PROD   := SC3->C3_PRODUTO  
                   ZD5->ZD5_ITEM   := SC3->C3_ITEM                               
                   ZD5->ZD5_FILENT := aFilsAtu[I][2]
                   MsUnLock() 
                   IF EMPTY(SC3->C3_FILENT)
                   	RecLock("SC3",.F.)
                   		SC3->C3_FILENT := aFilsAtu[I][2]
                   	MsUnLock()     
                   ENDIF
          ENDIF
        ENDIF
      NEXT I            
   //ENDIF */
ENDIF 



Return(lExecuta)

Static Function UpdParam(aParam)

	Local cFilOri	:= cFilAnt
	Local nI		:= 0
	
	For nI := 1 to Len( aParam )
		If aParam[nI,1]
			cFilAnt	:= aParam[nI,2] 
			//PutMV(cParam,dParam)
		EndIf
	Next nI

	cFilAnt	:= cFilOri

Return()       

//Incluido para suprir a necessidade de ter todas as empresas e filiais
//Tarcisio galeano - 09/01/2018
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Funcao    � MatFilCalc (Original MA330FCalc)                           ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Microsiga Software S/A                   � Data � 22/01/06 ���
��������������������������������������������������������������������������Ĵ��
��� Descricao � Funcao para selecao das filiais para calculo por empresa   ���
��������������������������������������������������������������������������Ĵ��
���Parametros � ExpL1 = Indica se apresenta tela para selecao              ���
���           � ExpA2 = Lista com as filiais a serem consideradas (Batch)  ���
��������������������������������������������������������������������������ĳ��
���Retorno    � Array: aFilsCalc[3][n]                                     ���
���           � aFilsCalc[1][n]:           - Logico                        ���
���           � aFilsCalc[2][n]: Filial    - Caracter                      ���
���           � aFilsCalc[3][n]: Descricao - Caracter                      ���
���           � aFilsCalc[4][n]: CNPJ      - Caracter                      ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � Generico                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
static Function MatFilCalc(lMostratela,aListaFil)
Local aFilsCalc:={}
Local aAreaSM0:=SM0->(GetArea())
// Variaveis utilizadas na selecao de categorias
Local oChkQual,lQual,oQual,cVarQ,oDlg
// Carrega bitmaps
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")
// Variaveis utilizadas para lista de filiais
Local nx        := 0
Local nAchou    := 0

Default lMostraTela :=.F.
Default aListaFil:={{.T., cFilAnt}}
                          
//��������������������������������������������������������������Ŀ
//� Carrega filiais da empresa corrente                          �
//����������������������������������������������������������������
dbSelectArea("SM0")
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
	//����������������������������������������������������������������Ŀ
	//� aEmpresas - Contem as filiais que sao permitidas para o acesso |
	//| do usuario corrente.                                           |
	//������������������������������������������������������������������
	//nPos := Ascan(aEmprecsas,{|x| AllTrim(x)==Alltrim(SM0->M0_CODIGO+SM0->M0_CODFIL)})
	//If nPos > 0
		//IF SM0->M0_CODFIL <> '010001'
			Aadd(aFilsCalc,{.F.,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_CGC})
        //msgbox("filial "+SM0->M0_CODFIL+" "+SM0->M0_FILIAL+" "+SM0->M0_CGC)
        //ENDIF
	//EndIf	                             

	dbSkip()
EndDo
RestArea(aAreaSM0)

//��������������������������������������������������������������Ŀ
//� Monta tela para selecao de filiais                           �
//����������������������������������������������������������������
If lMostraTela
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Contrato x Filial") STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
	@ 05,15 TO 125,300 LABEL OemToAnsi("Selecao") OF oDlg  PIXEL
	@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT OemToAnsi("Filial") SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilsCalc, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.))
	@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi("Filial"),OemToAnsi("Razao social") SIZE 273,090 ON DBLCLICK (aFilsCalc:=MtFClTroca(oQual:nAt,aFilsCalc),oQual:Refresh()) NoScroll OF oDlg PIXEL
	oQual:SetArray(aFilsCalc)
	oQual:bLine := { || {If(aFilsCalc[oQual:nAt,1],oOk,oNo),aFilsCalc[oQual:nAt,2],aFilsCalc[oQual:nAt,3]}}
	DEFINE SBUTTON FROM 134,200 TYPE 1 ACTION If(MtFCalOk(aFilsCalc,.T.,.T.),oDlg:End(),) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,240 TYPE 2 ACTION If(MtFCalOk(aFilsCalc,.F.,.T.),oDlg:End(),) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,280 TYPE 15 ACTION If(MtFCalOk(aFilsCalc,.T.,U_MGFCOM84()),oDlg:End(),) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTER
	//��������������������������������������������������������������Ŀ
	//� Valida lista de filiais passada como parametro               �
	//����������������������������������������������������������������
Else
	// Checa parametros enviados
	For nx:=1 to Len(aListaFil)
		nAchou:=ASCAN(aFilsCalc,{|x| x[2] == aListaFil[nx,2]})
		If nAchou > 0
			aFilsCalc[nAchou,1]:=.T.
		EndIf
	Next nx
	// Valida e assume somente filial corrente em caso de problema
	If !MtFCalOk(aFilsCalc,.T.,.F.)                      
	
		For nx:=1 to Len(aFilsCalc)
			// Adiciona filial corrente
			aFilsCalc[nx,1]:=(aFilsCalc[nx,2]==cFilAnt)
		Next nx
	EndIf
EndIf
RETURN aFilsCalc

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Funcao    � MtFCalOk (Original MA330FOk)                               ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Microsiga Software S/A                   � Data � 22/01/06 ���
��������������������������������������������������������������������������Ĵ��
��� Descricao � Checa marcacao das filiais para calculo por empresa        ���
��������������������������������������������������������������������������Ĵ��
���Parametros � ExpA1 = Array com a selecao das filiais                    ���
���           � ExpL1 = Valida array de filiais (.t. se ok e .f. se cancel)���
���           � ExpL2 = Mostra tela de aviso no caso de inconsistencia     ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � Generico                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function MtFCalOk(aFilsCalc,lValidaArray,lMostraTela)
Local lRet:=.F.
Local nx:=0

Default lMostraTela := .T.

If !lValidaArray
	aFilsCalc := {}
	lRet := .T.
Else
	// Checa marcacoes efetuadas
	For nx:=1 To Len(aFilsCalc)
		If aFilsCalc[nx,1]
			lRet:=.T.
		EndIf
	Next nx
	// Checa se existe alguma filial marcada na confirmacao
	//If !lRet
	//	If lMostraTela
	//		Aviso(OemToAnsi("teste"),OemToAnsi("teste"),{"Ok"})
	//	EndIf
	//EndIf
EndIf

Return lRet

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Funcao    � MtFClTroca(Original CA330Troca)                            ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Microsiga Software S/A                   � Data � 12/01/06 ���
��������������������������������������������������������������������������Ĵ��
��� Descricao � Troca marcador entre x e branco                            ���
��������������������������������������������������������������������������Ĵ��
���Parametros � ExpN1 = Linha onde o click do mouse ocorreu                ���
���           � ExpA2 = Array com as opcoes para selecao                   ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � Protheus 8.11                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function MtFClTroca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FullRange� Autor � Felipe Nunes de Toledo� Data � 30/01/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Converte os parametros do tipo range, para um range cheio, ���
���          � caso o conteudo do parametro esteja vazio.                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �FullRange(cPerg)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cPerg = Nome do Grupo de Perguntas                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function FullRange(cPerg)
Local aArea      := { SX1->(GetArea()), GetArea() }
Local aTamSX3    := {}
Local cMvPar     := ''
Local nTamSX1Cpo := Len(SX1->X1_GRUPO)

cPerg := Upper(PadR(cPerg,nTamSX1Cpo))

SX1->( dbSetOrder(1) )
SX1->( MsSeek(cPerg) )
Do While SX1->( !Eof() .And. Trim(X1_GRUPO) == Trim(cPerg) )
	If Upper(SX1->X1_GSC) == 'R'
		cMvPar := 'MV_PAR'+SX1->X1_ORDEM
		If Empty(&(cMvPar))
			aTamSX3 := TamSx3(SX1->X1_CNT01)
			If Upper(aTamSX3[3]) == 'C'
				&(cMvPar) := Space(aTamSX3[1])+'-'+Replicate('z',aTamSX3[1])
			ElseIf Upper(aTamSX3[3]) == 'D'
				&(cMvPar) := '01/01/80-31/12/49'
			ElseIf Upper(aTamSX3[3]) == 'N'
				&(cMvPar) := Replicate('0',aTamSX3[1])+'-'+Replicate('9',aTamSX3[1])
			EndIf
		EndIf
	EndIf
	SX1->( dbSkip() )
EndDo

RestArea( aArea[1] )
RestArea( aArea[2] )
Return Nil


