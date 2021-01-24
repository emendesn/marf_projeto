#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFTAE33
Função que processa a integração do titulo de antecipação financeira para a transportadora oriundo do TAURA
@type function
@author Paulo da Mata
@since 23/07/2020
@version 1.0
/*/

User Function MGFTAE33(cE2FILIAL,cNATUREZA,cNUM,cACAO,cCNPJ,dEMISSAO,aItens)

	Local cErro := ""
	Local cForn := Space(06)
	Local cLoja := Space(02)
	
	Local nI        := 0
	Local nTit      := 0
	
	Local aRetorno  := {}
	Local aSE2      := {}
	Local aErro     := {}
	Local aTables	:= { "SA2" , "SE2" , "SED", "SE4" }
	
	Local bContinua := .T.
		
	Private lMsErroAuto   := .F.

	RPCSetType( 3 )
	RpcSetEnv('01',cE2FILIAL,"","","COM","RPC",aTables)

	// Inicia o processo de criação ou exclusão da antecipação à transportadora
	For nTit := 1 to Len(aItens)

		If ValType(aItens[nTit][4]) != "N" .Or. Empty(aItens[nTit][4])
			AADD(aRetorno ,"2")
			AADD(aRetorno,'Valor informado está no formato errado')
			bContinua := .F.
		EndIf	

		// Efetua a Validação dos Campos 
		If bContinua
			// 1 - Verifica se é inclusão ou exclusão e se a Filial está cadastrada
			If !(cACAO $ '13')
				AADD(aRetorno ,"2")
				AADD(aRetorno,'E2_ACAO:Ação deverá ser : 1=Inclusão ou 3=Exclusão')
				bContinua := .F.
			Else
				If !FWFilExist(cEmpAnt,cE2FILIAL)
					AADD(aRetorno ,"2")
					AADD(aRetorno,'E2_FILIAL:Filial não cadastrada')
					bContinua := .F.
				EndIf
			EndIf

			If bContinua
				// 2 - Verifica se o fornecedor estão cadastrados
				SA2->(dbSetOrder(3)) // A2_FILIAL+A2_CGC
				If SA2->(!dbSeek(xFilial("SA2")+PADR(cCNPJ,TamSX3("A2_CGC")[1])))
					AADD(aRetorno ,"2")
					AADD(aRetorno,'FORNECEDOR SA2: Fornecedor (Transportadora) não cadastrado na tabela de Fornecedores ( SA2 ).')
					bContinua := .F.
				Else 
					cForn := SA2->A2_COD
					cLoja := SA2->A2_LOJA
				EndIf    

			EndIf

			If bContinua

				// 3 - Verifica se a natureza está cadastrada
				dbSelectArea('SED')
				SED->(dbSetOrder(1)) // ED_FILIAL+ED_CODIGO

				If SED->(!dbSeek(xFilial('SED')+PADR(cNATUREZA,TamSX3("ED_CODIGO")[1]))) .OR. Empty(cNATUREZA)
					AADD(aRetorno ,"2")
					AADD(aRetorno,'E2_NATUREZ:Natureza não cadastrada')
					bContinua := .F.
				EndIf

			EndIf

		EndIf              

		If cACAO == "1"
		
			U_MFCONOUT("Verificando a existencia do titulo - "+CNUM+" da filial "+cE2FILIAL)

			dbSelectArea("SE2")
			dbSetOrder(1)

			If dbSeek(cE2FILIAL+"TAU"+PADR(cNUM,TAMSX3("E2_NUM")[1])+PADR(aItens[nTit][1],TAMSX3("E2_PARCELA")[1])+"NDF"+PADR(cForn,TAMSX3("E2_FORNECE")[1])+;
		    		                  PADR(cLoja,TAMSX3("E2_LOJA")[1]))
                                                                      
				U_MFCONOUT("Titulo "+CNUM+" já Existe.")
			   
				AADD(aRetorno ,"2")						
				AADD(aRetorno ,"Título "+CNUM+" já incluído")
				bContinua := .F.

			EndIf

		EndIf	

		// Se for uma exclusão (Indicada no JSON)
		If bContinua .And. cACAO == '3'

			dbSelectArea('SE2')
			SE2->(dbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

			If dbSeek(cE2FILIAL+"TAU"+PADR(cNUM,TAMSX3("E2_NUM")[1])+PADR(aItens[nTit][1],TAMSX3("E2_PARCELA")[1])+"NDF"+PADR(cForn,TAMSX3("E2_FORNECE")[1])+;
		                              PADR(cLoja,TAMSX3("E2_LOJA")[1]))

				RecLock("SE2",.f.)
				SE2->(dbDelete())
				SE2->(MsUnLock())

				bContinua := .T.
				AADD(aRetorno ,"1")
				AADD(aRetorno ,'ANTECIPACAO Excluída com sucesso')
			Else
				bContinua := .F.
				AADD(aRetorno ,"2")
				AADD(aRetorno ,'ANTECIPACAO INEXISTENTE')
			EndIf	

		EndIf

		// Se for uma Inclusão (indicado no JSON)
		If bContinua .AND. cACAO == '1'

			SetFunName("FINA050")
			Pergunte("FIN050",.F.)

			Mv_Par05 := SetParMV(PADR("FIN050",10),"05",2)
			Mv_Par09 := SetParMV(PADR("FIN050",10),"09",2)

			Begin Transaction
				aSE2 := {}

				AADD(aSE2, { "E2_FILIAL"   , cE2FILIAL     		, NIL })
				AADD(aSE2, { "E2_PREFIXO"  , "TAU"        		, NIL })
				AADD(aSE2, { "E2_NUM"      , cNUM   			, NIL })
				AADD(aSE2, { "E2_PARCELA"  , aItens[nTit][1] 	, NIL })
				AADD(aSE2, { "E2_TIPO"     , "NDF"        		, NIL })
				AADD(aSE2, { "E2_NATUREZ"  , cNATUREZA   		, NIL })
				AADD(aSE2, { "E2_FORNECE"  , cForn        		, NIL })
				AADD(aSE2, { "E2_LOJA"     , cLoja        		, NIL })
				AADD(aSE2, { "E2_EMISSAO"  , dEMISSAO			, NIL })
				AADD(aSE2, { "E2_VENCTO"   , aItens[nTit][2]    , NIL })
				AADD(aSE2, { "E2_VENCREA"  , aItens[nTit][3]   	, NIL })
				AADD(aSE2, { "E2_VALOR"    , aItens[nTit][4]    , NIL })

				MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 3)  //  3 = Inclusao

				If lMsErroAuto

					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					For nI := 1 to Len(aErro)
						cErro += aErro[nI] + CRLF
					Next nI

					AADD(aRetorno ,"2")
					AADD(aRetorno,cErro)

					DisarmTransaction()
					Return aRetorno

				Else

					AADD(aRetorno ,"1")
					AADD(aRetorno,'ANTECIPACAO Incluida com sucesso !!!' )

				EndIf

			End Transaction

			// Reforça a gravação do campo E2_FILIAL, se o mesmo não for igual a variável cE2FILIAL
			dbSelectArea("SE2")
			dbSetOrder(1)

			If dbSeek(xFilial("SE2")+"TAU"+PADR(cNUM,TAMSX3("E2_NUM")[1])+PADR(aItens[nTit][1],TAMSX3("E2_PARCELA")[1])+"NDF"+PADR(cForn,TAMSX3("E2_FORNECE")[1])+;
		                               	   PADR(cLoja,TAMSX3("E2_LOJA")[1]))
				If SE2->E2_FILIAL != cE2FILIAL
				   RecLock("SE2",.F.)
				   SE2->E2_FILIAL  := cE2FILIAL
				   SE2->E2_FILORIG := cE2FILIAL
				   MsUnlock()
				EndIf

				U_MFCONOUT("ANTECIPACAO Incluida com sucesso ")
				
			EndIf   

		EndIf
			
	Next

Return aRetorno     

/*/{Protheus.doc} SETPARMV
Função que processa a integração do titulo de antecipação financeira para a transportadora oriundo do TAURA
@type function
@author Paulo da Mata
@since 23/07/2020
@version 1.0
/*/

Static Function SetParMV(cPerg,cOrdem,xValor)

	SX1->(dbSetOrder(1))  // X1_GRUPO, X1_ORDEM

	If SX1->(dbSeek(cPerg+cOrdem,.F.))
		SX1->(Reclock("SX1",.F.))

		If ValType(xValor) != "N"
			SX1->X1_CNT01 := xValor
		Else	
			SX1->X1_PRESEL := xValor
		EndIf	

		SX1->(MsUnlock())

	EndIf

	SetMVValue(cPerg,"Mv_Par"+cOrdem,xValor)
	&("Mv_Par"+cOrdem) := xValor

Return(xValor)
