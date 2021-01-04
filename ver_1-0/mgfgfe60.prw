#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} MGFGFE60
Classificar o CTE por item na integracao do GFE

@description
Classifica o CTE por item na integracao do GFE. Busca regra da TES item a item
Chamado pelo programa M116ACOL

@author Cosme Nunes
@since 04/02/2020
@type User Function

@table 
    SF1 - Cabecalho documento de entrada
    SD1 - Itens documento de entrada
    SF2 - Cabecalho documento de saida
    SD2 - Itens documento de saida

@param
    cAliasSD1 - Alias arq. NF Entrada itens
    nX        - Numero da linha do aCols correspondente
    aDoc      - Vetor contendo o documento, serie, fornecedor, loja e itens do documento
    
@return
    Nil 

@menu
    Nao se aplica

@history 
    04/02/2020 - RTASK0010721 - Chamados RITM0036376 - Cosme Nunes
/*/   
User Function MGFGFE60() 

Local _aArea     := GetArea()
Local _aAreSD1	 := SD1->(GetArea())//Local _cAliasSD1 := PARAMIXB[1];Local _nX := PARAMIXB[2]; Local _aDoc      := aClone(PARAMIXB[3])
Local _aRotExc	 := STRTOKARR(SuperGetMV("MGF_GFE60",.F.,''),";") //Rotinas que nao passarao pela validacao
Local _nCnt      := 0
Local _nPosTes   := 0
Local _nPosOper  := 0
Local _czOper    := "" 
Local _cTes      := ""
Local _cOper	 := ""
Local _dDVigRTES := SuperGetMV("MGF_GFE60A",.T.,.T.) //Dt.vigencia p/aplicar a regra de TES por Operacao.
Local _nPosDtDig 
Local _lMGFE60 	 := SuperGetMV("MGF_GFE60B",.T.,.T.) //Habilita classificacao do CTE por item na int. do GFE
Local _nPosProd  := 0
Local _cRet		 := ""
Local _czGrTr	 :=	""
//Private _czOper:= "" 

//Verifica rotinas que nao devem passar pela validacao na pilha de chamada
For _nCnt := 1 To Len(_aRotExc)
    If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
        Return(Nil)
    EndIf
Next

//Verifica se a classificacao do CTE por item na int. do GFE esta habilitada
If !_lMGFE60
    Return(Nil)
EndIf

//Verifica docto gerado a partir da data de vigencia p/aplicar a regra de TES por Operacao
_nPosDtDig:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DTDIGIT"}) //Posicao Dt. digitacao do docto
_dDtDigit := PARAMIXB[3][5][_nPosDtDig] //Dt. digitacao do docto
If !(_dDtDigit >= _dDVigRTES)
	
	Return(Nil)

Else

	_nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"}) //Posicao do produto
	
	//Posiciona item da NFE para buscar a operacao
	SD1->(DBSETORDER(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If SD1->(DbSeek(xFilial("SD1")+PARAMIXB[3][1]+PARAMIXB[3][2]+PARAMIXB[3][3]+PARAMIXB[3][4]+PARAMIXB[3][5][_nPosProd]))//StrZero(_nX,4) -> Item frete <> item NFE!
    	_czOper  := SD1->D1_ZOPER //Operacao do item da NFE
		_czGrTr	 := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_GRTRIB")

		//Verifica TES no cadastro de regra de TES c/_czOper e carrega variaveis de retorno p/o aCols
		_cRet  := U_60MGFEPq(_czOper,_czGrTr) 
		_cTes  := SubStr(_cRet,1,3)
		_cOper := SubStr(_cRet,4,2) 
		//_cTes  := "0G0" ; _cOper := "03" //Teste de alteracao do aCols com valores "chumbados"
		If !Empty(_cTes)

			_nPosTes := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"}) //Posicao do TES
			_nPosOper:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZOPER"}) //Posicao da operacao
			
			//PARAMIXB[3][5][X] - Dimensao com itens do documento
			//If _aDoc[5][_nPosTes] <> _cTes //_aDoc : clone de PARAMIXB[3]

				//Atualiza os campos do aCols com a TES e a operacao do cadastro de regra
				aCols[1][_nPosTes]  := PARAMIXB[3][5][_nPosTes]  := _cTes //PARAMIXB[3][5][_nPosTes]  := _cTes
				aCols[1][_nPosOper] := PARAMIXB[3][5][_nPosOper] := _cOper //PARAMIXB[3][5][_nPosOper] := _cOper
				//MsgInfo("aCols[1][_nPosTes]: "+aCols[1][_nPosTes],"aCols[1]") //Verifica atualização do aCols
				
			//EndIf 

    	EndIf

	EndIf

EndIf 

RestArea(_aAreSD1)
RestArea(_aArea)

Return(Nil)




/*/
======================================================================================
{Protheus.doc} 60MGFEPq()
Pesq.p/buscar TES e Operacao no cad. de regra de TES. 
Regra espelhada do programa de origem MGFGFE28.

@author Cosme Nunes
@since 11/02/2020  
@type User Function 

@param 
    _czOper - Operação do produto
	_czGrTr - Grupo de Tributação do produto

@return
    _cRet - Retorna conteudo  para preenchimento do campo 
/*/
User Function 60MGFEPq(_czOper,_czGrTr)

Local _aArea    := GetArea()

	Local aAreaGW3  := GW3->(Getarea())
	Local aAreaGW4	:= GW4->(Getarea())
	Local aAreaGW1	:= GW1->(Getarea())
	Local aAreaGU3	:= GU3->(Getarea())
	Local aAreaGU7	:= GU7->(Getarea())
	Local aAreaGWN  := GWN->(Getarea())
	Local aAreaZE4  := ZE4->(Getarea())

	Local cGrupo  	:= ""
	Local cTpMov  	:= "" // Frete entrada ou saida
	Local cTribut 	:= GW3->GW3_TRBIMP // Tributacao do documento
	Local cModal  	:= ""
	Local cTpDoc  	:= GW3->GW3_TPDF
	Local cRegTRP 	:= ""
	Local cContr  	:= ""
	Local cFornec 	:= ""
	Local cLoja   	:= ""
	Local cUF	  	:= ""
	Local cOri		:= ""
	Local cDest	    := ""
	Local cQuery  	:= ""
	Local cAliasZE5 := ""
	Local cModalPar := GETMV('MGF_MODAL')
	Local cUso		:= GETMV('MGF_COM28')
	Local cUsoMov	:= "1"//1=Nao;2=Sim
	Local lEx		:= .F.
	Local cTes		:= ""
	Local _cRetTES  := "" //Retorno do TES do cadastro de regra de TES
	Local _cRetOper := "" //Retorno da Operacao do cadastro de regra de TES
	Local _cRet     := ""
	Local _cTime    := ""//SeqArq

	cUso := cUso + GETMV('MGF_COM282')

	If Alltrim(_czGrTr) $ cUso
		cUsoMov := "2"//1=Nao;2=Sim
	EndIf 

	///Busca os dados do ducmento
	If GW3->(!EOF())

		///Frete entrada ou saida
		If GW3->GW3_SITREC <> '6'
			cTpMov := '1'
		Else
			cTpMov := '2'
		EndIf

		////VERIFICA MODAL
		DbSelectArea('GW4')
		GW4->(DbSetOrder(1))//GW4_FILIAL+GW4_EMISDF+GW4_CDESP+GW4_SERDF+GW4_NRDF+DTOS(GW4_DTEMIS)+GW4_EMISDC+GW4_SERDC+GW4_NRDC+GW4_TPDC
		If GW4->(Msseek(XFILIAL('GW4') + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF ))

			DbSelectArea('GW1')
			GW1->(DbSetOrder(1))//GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC
			If GW1->(Msseek(XFILIAL('GW1') + GW4->GW4_TPDC + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC  ))

				DbSelectArea('GWU')
				GWU->(DbSetOrder(6))//GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_CDTRP+GWU_FILIAL+GWU_CDTPDC
				If GWU->(Msseek( GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + GW3->GW3_EMISDF + XFILIAL('GWU') + GW4->GW4_TPDC ))

				    // CIDADE DE ORIGEM
					DbSelectArea('GU3')
					GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
					If GU3->(Msseek( xFilial('GU3') + GW1->GW1_CDREM ))

						DbSelectArea('GU7')
						GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
						If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
								cOri := GU7->GU7_CDUF
						EndIf

					EndIf

				    // CIDADE DE DESTINO
					DbSelectArea('GU3')
					GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
					If GU3->(Msseek( xFilial('GU3') + GW1->GW1_CDDEST ))

						DbSelectArea('GU7')
						GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
						If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
								cDest := GU7->GU7_CDUF
						EndIf

					EndIf

					If !'EX' $ cDest + cOri

					
							// CIDADE DE ORIGEM
							DbSelectArea('GU3')
							GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
							If GU3->(Msseek( xFilial('GU3') + GW1->GW1_EMISDC ))
	
								DbSelectArea('GU7')
								GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
								If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
									 If !GU3->GU3_NATUR  = 'F'        
                       
										If SA2->A2_EST <> cUF
									        cUF := '2'
								        Else
								        	cUF := '1'
							        	EndIf
										cOri := GU7->GU7_CDUF
									 Else
					   
										DbSelectArea('GU7')
										GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
										If GU7->(Msseek( xFilial('GU7') + GWU->GWU_NRCIDO ))									 
											cOri := GU7->GU7_CDUF										
										EndIf			     
								     EndIf
								EndIf
	
							EndIf
	
							//ESTADO DE DESTINO
							DbSelectArea('GU7')
							GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
							If GU7->(Msseek( xFilial('GU7') + GWU->GWU_NRCIDD ))
								cDest := GU7->GU7_CDUF
							EndIf
					Else
						lEx := .T.
					EndIf

					DbSelectArea('GWN')
					GWN->(DbSetOrder(1))//GWN_FILIAL+GWN_NRROM
					If GWN->(Msseek(XFILIAL('GWN') + GW1->GW1_NRROM ))

						If !(ALLTRIM(GWN->GWN_CDCLFR) $ ALLTRIM(cModalPar))
							cModal := '1'
						Else
							cModal := '2'
						EndIf

					EndIf

				EndIf

			EndIf

		EndIf
		////Busca dados da transportadora
		DbSelectArea('SA2')
		SA2->(DbSetorder(3))//A2_FILIAL+A2_CGC
		If SA2->(MsSeek(xFilial('SA2') + GW3->GW3_EMISDF ))

			cRegTRP := SA2->A2_SIMPNAC

			cFornec := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
			cUF		:= SA2->A2_EST

			/// Verifica se e contribuinte
			If SA2->A2_INSCR <> 'ISENTO'
				cContr := '1'
			Else
				cContr := '2'
			EndIf
		EndIf

		/// Verifica em que grupo a Filial esta vinculada
		DbSelectArea('ZE4')
		ZE4->(DbSetorder(1))//ZE4_FILIAL + ZE4_FIL + ZE4_GRUPO
		If ZE4->(MsSeek(xFilial('ZE4') + GW3->GW3_FILIAL))
			cGrupo := ZE4->ZE4_GRUPO
		EndIf

		////Verifica a UF origem de Transporte
		If cTpMov == '1'

			DbSelectArea('SA2')
			SA2->(DbSetOrder(3))//A2_FILIAL+A2_CGC
			If SA2->(MsSeek(xFilial('SA2') + GW3->GW3_EMISDF ))
				If SA2->A2_EST <> cOri
					cUF := '2'
				Else
					cUF := '1'
				EndIf
			EndIf
		Else
			DbSelectArea('SA1')
			SA1->(DbSetOrder(3))//A1_FILIAL+A1_CGC
			If SA1->(MsSeek(xFilial('SA1') + GW3->GW3_CDREM ))
				If SA1->A1_EST <> cUF
					cUF := '2'
				Else
					cUF := '1'
				EndIf
			EndIf

		EndIf
	Endif

	cAliasZE5 := GetNextAlias()

	cQuery := " SELECT ZE5.* " + CRLF
	cQuery += " FROM " + RetSqlName("ZE5") + " ZE5 " + CRLF
	cQuery += " WHERE ZE5_GRUPO  = '" + cGrupo  + "'" + CRLF
	cQuery += " AND   ZE5_TPDOC  = '" + GW3->GW3_CDESP  + "'" + CRLF
	cQuery += " AND   ZE5_TPMOV  = '" + cTpMov  + "'" + CRLF
	cQuery += " AND   ZE5_TPTRIB = '" + cTribut + "'" + CRLF
	cQuery += " AND  (ZE5_UFTRP  = '" + cUF     + "' OR ZE5_UFTRP  = '3') " + CRLF
	cQuery += " AND   ZE5_CONTR  = '" + cContr  + "'" + CRLF
	cQuery += " AND  (ZE5_FORNEC = '" + cFornec + "' OR ZE5_FORNEC = ' ') " + CRLF
	cQuery += " AND  (ZE5_LOJA   = '" + cLoja   + "' OR ZE5_LOJA = ' ' )" + CRLF
	cQuery += " AND   ZE5_TPDF   = '" + cTpDoc  + "'" + CRLF
	cQuery += " AND  (ZE5_REGIME  = '" + cRegTRP + "' OR ZE5_REGIME = ' ')" + CRLF
	cQuery += " AND  (ZE5_TRANSP = '" + cModal  + "' OR ZE5_TRANSP = ' ')" + CRLF
	cQuery += " AND  (ZE5_UFORI  = '" + cOri  + "' OR ZE5_UFORI  = ' ')" + CRLF
	cQuery += " AND  (ZE5_UFDES  = '" + cDest + "' OR ZE5_UFDES  = ' ')" + CRLF
	cQuery += " AND  (ZE5_CONSUM = '" + cUsoMov + "' OR ZE5_CONSUM = ' ')" + CRLF
	If lEx
		cQuery += " AND   ZE5_EXPORT   = '1'" + CRLF
	Else
		cQuery += " AND   ZE5_EXPORT   = '2'" + CRLF
	EndIf
	cQuery += " AND  (ZE5_GRPTRI = '" + _czGrTr + "' OR ZE5_GRPTRI = ' ')" + CRLF //Parametro da rotina

	cQuery += " AND  (ZE5_ZOPER = '" + _czOper + "' OR ZE5_ZOPER = ' ')" + CRLF //Operacao informada no item da nota de entrada
	
	cQuery += " AND   ZE5.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY ZE5_FORNEC DESC, ZE5_GRPTRI DESC, ZE5_ZOPER DESC " // priorizar sempre registros que tem dados nestes campos

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasZE5, .F., .T.)
	
	IIF(Empty(_cTime),_cTime:=substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2),_cTime:=substr(time(),1,2)+substr(time(),4,2)+Soma1(substr(time(),7,2)))
	memoWrite("C:\TEMP\mgfgfe60p_ze5"+_cTime+".txt", cQuery)

	If (cAliasZE5)->(!eof())
		If !Empty((cAliasZE5)->ZE5_TES) //GW3->GW3_TES == GW3->GW3_ZTESOR
			cTes := (cAliasZE5)->ZE5_TES
		Else
			cTes := GW3->GW3_TES
		EndIf
	EndIf

_cRetTES := cTES //Retorna TES
_cRetOper := (cAliasZE5)->ZE5_ZOPER //Retorna Operacao
_cRet := _cRetTES+_cRetOper //Retorna TES + Operacao

	(cAliasZE5)->(dbCloseArea())

	Restarea(aAreaZE4)
	Restarea(aAreaGWN)
	Restarea(aAreaGU7)
	Restarea(aAreaGU3)
	Restarea(aAreaGW1)
	Restarea(aAreaGW4)
	Restarea(aAreaGW3)

RestArea(_aArea)

Return(_cRet)
