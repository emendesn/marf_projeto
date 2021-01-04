#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include 'parmtype.ch'
 

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE40
Fun��o para altera��o do fornecedor do t�tulo de reten��o do ISS, conforme tabela CE1 - Al�quotas de ISS, e 
a Data de vencimento do t�tulo, conforme a tabela CC2 - Tabelas de municipios do IBGE.

Fun��o chamado pelo PE MT103ISS

@author Natanael Sim�es
@since 18/03/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFGFE40(aRet)

	Local aRotInc := STRTOKARR(SuperGetMV('MGF_GFE40R',.F.,'GFEA065'),';') //Rotinas que passar�o pela valida��o. Separados por ponto e virgula ';'.
	Local nOriMun := SuperGetMV("MGF_GFE40M",.F.,3) //Define a origem do Cod. do Municipio para o ISS: 1 - Prestator / 2 - Unidade / 3 - Orig/Dest Transporte 
	Local cEstISS := ' ' // UF para pagamento do ISS
	Local cCodIBGE	:= ' ' // Codigo IBGE do Estado
	Local nDiaVenc	:= 0	//Dia Recolhimento do ISS
	Local dVcIss	:= aRet[5]	//Data de vencimento do t�tulo de ISS
	Local cTipoDia	:= ' '		//1=Uteis;2=Fixo
	Local cMunISS := ' '// C�digo do Munic�pio para pagamento do ISS
	Local lContinua := .T. // Define se a fun��o deve continuar sendo executada.
	
	//Verifica se as rotinas que devem passar pela valida��o est�o na pilha de chamada para continuar
	For nCnt := 1 To Len(aRotInc)
		If IsInCallStack(Alltrim(aRotInc[nCnt]))
			lContinua := .T. //Se n�o estiver na pilha, retorna o array sem altera��es
			EXIT
		Else
			lContinua := .F.
		EndIf
	Next
	If !lContinua
		Return(aRet)
	EndIf
	
	//Verifica qual cod de munic�pio deve ser utilizado para gera��o do ISS, conforme "MGF_GFE40M". 1 - Prestator / 2 - Unidade / 3 - Orig/Dest Transporte 
	If nOriMun = 1 // 1 - Prestator
		cEstISS	:= AllTrim(MaFisRet(,"NF_UFPREISS"))
		cMunISS := Alltrim(MaFisRet(,"NF_CODMUN"))
		
	ElseIf nOriMun = 2 // 2 - Unidade	
		cEstISS	:= AllTrim(SM0->M0_ESTENT) // UF da Unidade
		cMunISS := SubStr(AllTrim(SM0->M0_CODMUN),3,5) //Munic�pio da Unidade
		
	ElseIf nOriMun = 3 // 3 - Orig/Dest Do Trecho Transporte
	
		//Query nas tabe�a do GFE para encontrar o trecho dentro do mesmo munic�pio
		BeginSQL Alias "GW3TEMP"
			SELECT
			    GW3_FILIAL
			    ,GW3_NRDF       // Numero Nota de Servi�o de transporte
			    ,GW3_SERDF      // S�rie Nota de Servi�o de transporte
			    ,GW3_DTEMIS     // Emiss�o Nota de Servi�o de transporte
			    ,GWU_NRCIDD     // C�digo Cidade de Destino
			    ,GWU_NRCIDO     // C�digo Cidade de Destino
			    ,GW4_NRDC       // N�mero do Doc. de carga
			    ,GW4_SERDC      // S�rie do Doc. de carga
			FROM
			    %Table:GW3% GW3 INNER JOIN %Table:GW4% GW4
			        ON GW3_FILIAL = GW4_FILIAL
			        AND GW3_EMISDF = GW4_EMISDF
			        AND GW3_NRDF = GW4_NRDF
			        AND GW3_SERDF = GW4_SERDF
			        AND GW3_DTEMIS = GW4_DTEMIS
			        INNER JOIN %Table:GWU% GWU
			        ON GW4_FILIAL = GWU_FILIAL
			        AND GW4_EMISDC = GWU_EMISDC
			        AND GW4_TPDC = GWU_CDTPDC
			        AND GW4_SERDC = GWU_SERDC
			        AND GW4_NRDC = GWU_NRDC
			WHERE GW3.%notDel%
			AND GW4.%notDel%
			AND GWU.%notDel%
			AND GWU_NRCIDO = GWU_NRCIDD
			AND GW3_FILIAL = %EXP:SF1->F1_FILIAL%
	        AND GW3_NRDF = %EXP:SF1->F1_DOC%
	        AND GW3_SERDF = %EXP:SF1->F1_SERIE%
	        AND GW3_DTEMIS = %EXP:SF1->F1_EMISSAO%
		EndSQL
		
		GW3TEMP->(DBGoTop())
		If GW3TEMP->(!EOF())
	
			cCodIBGE := Left(GW3TEMP->GWU_NRCIDD,2) //Dois primeiros digitos refere-se ao c�digo IBGE do Estado	
			cEstISS := Posicione("C09",4,xFilial("C09") + Alltrim(cCodIBGE),"C09_UF") //Convete o c�digo do IBGJ do Estado em UF.
			cMunISS := Right(GW3TEMP->GWU_NRCIDD,5) //5 ultimos digitos refere-se ao munic�pio
		EndIf
		
		GW3TEMP->(DbCloseArea())
	EndIf



	If !(Empty(cMunISS) .OR. Empty(cEstISS)) //Nenhuma das vari�veis devem estar vazia.
		
		//Preenche o Array do PE MT103ISS com os novos c�digos de UF e Munic�pio.
		DbSelectArea('CE1') //Al�quotas de ISS
		DbOrderNickName('MGF40SIX1') //CE1_FILIAL+CE1_ESTISS+CE1_CMUISS+CE1_FORISS+CE1_LOJISS
		If DbSeek(xFilial('CE1')+cEstISS+cMunISS)
			aRet[1] := CE1->CE1_FORISS  //Novo c�digo do fornecedor de ISS.
			aRet[2] := CE1->CE1_LOJISS  //Nova loja do fornecedor de ISS.
		EndIf

		//REQ0022384 - 03/JUN/2019 - Preenche data de vencimento do Array do PE MT103ISS, conforme relacionado na tabela CC2		
		DbSelectArea('CC2') //Tabelas de municipios do IBGE 
		DbSetOrder(1) //CC2_FILIAL+CC2_EST+CC2_CODMUN
		If DbSeek(xFilial('CC2')+cEstISS+cMunISS)
			nDiaVenc := CC2->CC2_DTRECO	//Dia Recolhimento do ISS
			cTipoDia := CC2->CC2_TPDIA  // Tipo de dias: 1=Uteis;2=Fixo
		EndIf
		
		If ndiaVenc > 0 .AND. !Empty(cTipoDia)
		
			If cTipoDia = '1' // 1=Uteis
				dVcIss := u_zSumDiaUti(dDatabase,ndiaVenc) //Soma a quantidade de dias uteis
			
			ElseIf cTipoDia = '2' // 2=Fixo
				dVcIss := u_GFE40dtMes(dDatabase,ndiaVenc)	//Retorna a data do proximo m�s, conforme dia enviado.
				dVcIss := DataValida(dVcIss,.F.)			//Verifica se � dia �til e retroage se n�o for.
			EndIf

			aRet[5] := dVcIss   //Novo c�digo do fornecedor de ISS.
		EndIf
		
	EndIf
	
Return(aRet)


/*{Protheus.doc}
============================================================
Retorna a data do proximo m�s, conforme dia enviado.
@param  	dDtAtual -> Data inicial
			nDia -> Dia do m�s
@author 	Natanael Filho
@since  	03/06/2019
@return  	dDtFinal -> Dia �til final
===============================================================
*/
User Function GFE40dtMes(dDtAtual,nDia)

	Local dDtFinal
	
	Default dDtAtual := dDatabase
	Default nDia := 1
	
	dDtFinal := MonthSum(dDtAtual,1)	//Adiciona um M�s � data
	dDtFinal := FirstDay(dDtFinal)	//Depois retorna o primeiro dia do acrescentado
	dDtFinal := DaySum(dDtFinal,(nDia - 1)) //Define o dia do m� enviado ao par�metro.

Return dDtFinal
