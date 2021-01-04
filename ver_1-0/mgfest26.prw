#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
===========================================================================================
Programa.:              MGFEST26
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   Rotina de baixa da solicitacao ao armazem
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEST26()

Local aRotOld := aRotina 
Local cFieldMark := "CP_OK"

Private oBrowse
Private aMark := {}

// variaveis private mata241 
Private aAlter := {}
Private l185 := .T.
Private cTM := CriaVar("D3_TM")
Private cCC := CriaVar("D3_CC")
Private lA185BxEmp := .F.
Private aItenSD3 := {}
//Private aDadosCQ := {}
//
Private cCCSav := cCC
SD3->(MSUNLOCK()) //Rafael 09/04 - retira o lock do registro SD3 do primeiro Browse
oBrowse := FWMarkBrowse():New()
oBrowse:SetAlias('SCP')
oBrowse:SetDescription('Solicitacoes ao Armazem')
oBrowse:SetFilterDefault('CP_QUANT-CP_QUJE > 0 .AND. CP_STATSA == "L" .AND. CP_STATUS <> "E"') // com saldo, sem pre-requisicao, liberada e nao encerrada
oBrowse:SetFieldMark(cFieldMark)
oBrowse:SetAllMark( {|| Est26AllMark() } )
oBrowse:SetCustomMarkRec( {|| Est26Mk(cFieldMark) } )

aRotina := oBrowse:SetMenuDef("MGFEST26")

oBrowse:Activate()

aRotina := aRotOld

Return NIL


Static Function MenuDef()
	
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' 	   		ACTION 'VIEWDEF.MGFEST26' 	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Baixar Solicita��o'	ACTION 'U_Est26BxSA()' 		OPERATION 4 ACCESS 0
	
Return aRotina


Static Function ModelDef()

// Cria a estrutura a ser usada no Modelo de Dados
Local oStruSCP := FWFormStruct( 1, 'SCP')
Local oModel

// Cria o objeto do Modelo de Dados
//oModel :MPFormModel():New('EST26', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
oModel := MPFormModel():New("EST26", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulario de edicao por campo
oModel:AddFields( 'EST26MASTER', /*cOwner*/, oStruSCP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Baixar Solicita��o ao Armazem' )

// Adiciona a descricao do Componente do Modelo de Dados
//oModel:GetModel( 'EST26MASTER' ):SetDescription( 'Baixar Solicita��o ao Armazem' )
	
//Adiciona chave Primaria
//oModel:SetPrimaryKey({"CP_FILIAL","CP_NUM","CP_ITEM"})
oModel:SetPrimaryKey({})

Return oModel


Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFEST26' )

// Cria a estrutura a ser usada na View
Local oStruSCP := FWFormStruct( 2, 'SCP',,/*lViewUsado*/ )

Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados sera utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_SCP', oStruSCP, 'EST26MASTER' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_SCP', 'SUPERIOR' )

Return oView


Static Function Est26AllMark()
                            
Help( ,, 'Help',, 'Marcacao de todos os registros nao permitida'+CRLF+"Marque apenas os registros a serem processados.", 1, 0 )

Return(.T.)


User Function Est26BxSA()

Local aRotOld := aRotina 
Local lContinua := .F.
//Local bBlock := Nil

// arotina do mata241
Private aRotina	:=  {	{OemToAnsi("Pesquisar")			,"AxPesqui"  , 0 , 1,0,.F.},;		//"Pesquisar"
						{OemToAnsi("Visualizar")		,"A241Visual", 0 , 2,0,nil},;		//"Visualizar"
						{OemToAnsi("Incluir")			,"A241Inclui", 0 , 3,0,nil},;		//"Incluir"
						{OemToAnsi("Estornar")			,"A241Estorn", 0 , 6,0,nil},;		//"Estornar"
						{OemToAnsi("Tracker Cont�bil")	,"CTBC662"   , 0 , 7,0,Nil},;		//"Tracker Cont�bil"
						{OemToAnsi("Legenda")			,"A240Legenda", 0 , 2,0,.F.} }		//"Legenda"

// verifica se algum item foi marcado
aEval(aMark,{|x| IIf(x[2],lContinua:=.T.,Nil)})

If lContinua
	a241Inclui("SD3",0,3)

	// refresh no browse
	//bBlock := oBrowse:GetChange()
	//Eval(bBlock)
	DesmarBrw()
	oBrowse:Refresh(.F.)


//IMPRESS�O DA BAIXA  MIT 678 -- TARCISIO GALEANO 27/11/2018 
If SD3->D3_FILIAL = cfilant

		If MsgYesNo("IMPRIME TERMO DE RETIRADA","RETIRADA")
		    U_MGFEST52()
		Endif

Endif


Else
	APMsgStop("Nenhuma Solicita��o ao Armazem foi marcada.")
Endif	

aRotina := aRotOld


Return()


// rotina chamada pelo ponto de entrada MTA241CPO
// faz o tratamento no array aheader e acols, para gravacao da baixa da solicitacao ao armazem
User Function Est26Cpo(nOpc)

Local aArea := {SD3->(GetArea()),SB1->(GetArea()),GetArea()}
Local nCnt := 0
Local aColsRef := {}
Local cAlias := ""
Local aSaldo := {}
Local lLote := .F.
Local lLocaliza := .F.
Local nSaldoSB2 := 0
Local lContinua := .F.
Local nCntSld := 0
Local nCntSldLin := 0
Local cFilSA := ""
Local nSaldoLinhas := 0
//Local aSaldoLinhas := {}
Local nCntCols := 0
Local aSaldoSoma := {}
Local nSaldoSoma := 0

// chamada da rotina principal pelo menu
If !IsInCallStack("U_MGFEST28")
	
	Return()
Endif

/*
inserido em 26/07/18, pois alguns registros ainda estao sendo gravados com a filial em branco na sd3
foi verificado que isso ocorre as vezes quando o usuario acessa a rotina pelo menu RECENTES, o campo filial aparece na tela do mata241, mas em branco
foi tentado reproduzir o problema em ambiente QA, com usuario criado igual ao que ocorre o problema, mas nao consegui reproduzir
dasta forma, estah sendo validado se o campo filial estah na tela e neste caso nao prossegue a rotina
validado para inclusao e exclusao
*/
If nOpc == 3 .or. nOpc == 4
	If aScan(aHeader,{|x| Alltrim(x[2])=="D3_FILIAL"}) > 0
		APMsgAlert("Campo Filial nao deve aparecer na tela. Acesse a rotina pelo menu 'ESPEC�FICOS' ao inv�s do menu 'RECENTES'.")

		aEval(aArea,{|x| RestArea(x)})		
	
		Return()
	Endif
Endif		

// para chamada de visualizacao ou estorno do movimento, apenas cria os campos referentes a SA
If nOpc == 2 .or. nOpc == 4
	If aScan(aHeader,{|x| Alltrim(x[2])=="D3_NUMSA"}) == 0
		aAdd(aHeader,{ "Numero SA"	, "D3_NUMSA"	, "@!",	TamSX3("D3_NUMSA")[1]	, TamSX3("D3_NUMSA")[2]	, Nil, Nil, "C", "SD3", Nil }) //"Numero SA"
		For nCnt:=1 To Len(aCols)
			// deleta ultimo elemento, que o que indica se acols esta ou nao deletado
			aDel(aCols[nCnt],Len(aCols[nCnt]))

			nPosRecWT := 0
			nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "RECNO WT" } )

			if nPosRecWT == 0
				nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "WT RECNO" } )
			endif

			// redefine campos
			//aCols[nCnt][Len(aCols[nCnt])] := Eval({|| SD3->(dbGoto(aCols[nCnt][aScan(aHeader,{|x| Alltrim(x[1])=="Recno WT"})])),SD3->D3_NUMSA })
			aCols[nCnt][Len(aCols[nCnt])] := Eval({|| SD3->(dbGoto(aCols[nCnt][nPosRecWT])),SD3->D3_NUMSA })

			// insere elemento para indicar se estah ou nao deletado
			aAdd(aCols[nCnt],.F.)
		Next	
	EndIf
	If aScan(aHeader,{|x| Alltrim(x[2])=="D3_ITEMSA"}) == 0
		aAdd(aHeader,{ "Item SA"	, "D3_ITEMSA"	, "@!",	TamSX3("D3_ITEMSA")[1]	, TamSX3("D3_ITEMSA")[2], Nil, Nil, "C", "SD3", Nil }) //"Item SA"
		For nCnt:=1 To Len(aCols)
			// deleta ultimo elemento, que o que indica se acols esta ou nao deletado
			aDel(aCols[nCnt],Len(aCols[nCnt]))

			nPosRecWT := 0
			nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "RECNO WT" } )

			if nPosRecWT == 0
				nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "WT RECNO" } )
			endif

			// redefine campos
			//aCols[nCnt][Len(aCols[nCnt])] := Eval({|| SD3->(dbGoto(aCols[nCnt][aScan(aHeader,{|x| Alltrim(x[1])=="Recno WT"})])),SD3->D3_ITEMSA })
			aCols[nCnt][Len(aCols[nCnt])] := Eval({|| SD3->(dbGoto(aCols[nCnt][nPosRecWT])),SD3->D3_ITEMSA })

			// insere elemento para indicar se estah ou nao deletado
			aAdd(aCols[nCnt],.F.)
		Next	
	Endif		
	aEval(aArea,{|x| RestArea(x)})		
	
	Return()
Endif	
	
aColsRef := aClone(aCols)
cAlias := oBrowse:Alias()
	
aAlter := {"D3_QUANT"}
cTM := GetMv("MGF_TMBXSA",,"501")
cCC := CriaVar("D3_CC")

SB1->(dbSetOrder(1))
SB2->(dbSetOrder(1))

//reordena amark pelo recno
aSort(aMark,,,{|x,y| x[1] < y[1]})

For nCnt:=1 To Len(aMark)
	If aMark[nCnt][2]
		(cAlias)->(dbGoto(aMark[nCnt][1]))
		If (cAlias)->(Recno()) == aMark[nCnt][1]
			If SB1->(dbSeek(xFilial("SB1")+(cAlias)->CP_PRODUTO))
				// inserido em 28/06/18, pois alguns registros da sd3 estao ficando com o campo d3_filial em branco, inexplicavelmente
				If Empty(cFilAnt)
					APMsgStop("Filial em branco, registro nao sera considerado.")
					Loop
				Endif	
				
				aSaldo := {}
				nSaldoSB2 := 0
				lLote := .F.
				lLocaliza := .F.
				lContinua := .F.
				nSaldoLinhas := 0
				//aSaldoLinhas := {}
				aSaldoSoma := {}
				nSaldoSoma := 0
				
				// validacao para evitar do usuario marcar registros de filiais diferentes
				If (!Empty(cFilSA) .and. cFilSA != (cAlias)->CP_FILIAL) .or. cFil != (cAlias)->CP_FILIAL
					APMsgStop("Registros marcados sao de filiais diferentes."+CRLF+;
					"Marque apenas registros da mesma filial e da filial logada no sistema."+CRLF+;
					"Filial logada no sistema: "+cFil+"."+CRLF+;
					"Nenhum produto sera considerado para baixa.")
					// zera acols
					aCols := aClone(aColsRef)
					
					// zera variaveis private
					cTM := CriaVar("D3_TM")
					cCC := CriaVar("D3_CC")
					Exit
				Endif
				
				cFilSA := (cAlias)->CP_FILIAL
								
				If SB1->B1_RASTRO == "L"
					lLote := .T.
				Endif
				If SB1->B1_LOCALIZ == "S"
					lLocaliza := .T.
				Endif		
				
				If lLote .or. lLocaliza				
					// nao passar a quantidade para a funcao sldporlote, pois a funcao pode retornar a quantidade solicitada em mais de um lote/endereco, compondo a quantidade
					// pela soma dos lotes e enderecos e neste caso a rotina quer o lote/endereco que tenha toda a quantidade solicitada
					//aSaldo := SldPorLote((cAlias)->CP_PRODUTO,(cAlias)->CP_LOCAL,(cAlias)->CP_QUANT-(cAlias)->CP_QUJE,0) 
					aSaldo := SldPorLote((cAlias)->CP_PRODUTO,(cAlias)->CP_LOCAL,9999999999,0)
					/* 
					retorno funcao padrao SldPorLote
					aRetorno
					01 Lote de Controle                  
					02 Sub-Lote                          
					03 Localizacao                       
					04 Numero de Serie                   
					05 Quantidade                        
					06 Quantidade 2aUM                   
					07 Data de Validade                  
					08 Registro do SB2                   
					09 Registro do SBF                   
					10 Array com Registros do SB8 e qtd  
					11 Local                             
					12 Potencia                          
					13 Prioridade do endereco (BF_PRIOR) 
					*/
					/*
					If lLote // nao precisa, pois o padrao jah traz ordenado pela validade
						// ordena pelo menor vencimento
						aSort(aSaldo,,,{|x,y| x[7] < y[7]})
					Endif	
					*/
					For nCntSld:=1 To Len(aSaldo)
						nSaldoLinhas := 0
						// verifica a quantidade jah informada deste lote/endereco nos itens anteriores deste movimento
						For nCntSldLin:=1 To Len(aCols)
							If gdFieldGet("D3_COD",nCntSldLin) == (cAlias)->CP_PRODUTO .and. gdFieldGet("D3_LOCAL",nCntSldLin) == (cAlias)->CP_LOCAL
								If lLote .and. !lLocaliza
									If gdFieldGet("D3_LOTECTL",nCntSldLin) == aSaldo[nCntSld][1] .and. gdFieldGet("D3_NUMLOTE",nCntSldLin) == aSaldo[nCntSld][2]
										//If (nPos:=aScan(aSaldoLinhas,{|x| x[1]==gdFieldGet("D3_LOTECTL",nCntSldLin) .and. x[2]==gdFieldGet("D3_NUMLOTE",nCntSldLin)})) > 0
											nSaldoLinhas += gdFieldGet("D3_QUANT",nCntSldLin)
											//aSaldoLinhas[nPos][4] += gdFieldGet("D3_QUANT",nCntSldLin)
										//Else
										//	aAdd(aSaldoLinhas,{gdFieldGet("D3_LOTECTL",nCntSldLin),gdFieldGet("D3_NUMLOTE",nCntSldLin),"",gdFieldGet("D3_QUANT",nCntSldLin)})
										//Endif		
									Endif
								Endif		
								If !lLote .and. lLocaliza
									If gdFieldGet("D3_LOCALIZ",nCntSldLin) == aSaldo[nCntSld][3]
										//If (nPos:=aScan(aSaldoLinhas,{|x| x[3]==gdFieldGet("D3_LOCALIZ",nCntSldLin)})) > 0
											nSaldoLinhas += gdFieldGet("D3_QUANT",nCntSldLin)
											//aSaldoLinhas[nPos][4] += gdFieldGet("D3_QUANT",nCntSldLin)
										//Else
										//	aAdd(aSaldoLinhas,{"","",gdFieldGet("D3_LOCALIZ",nCntSldLin),gdFieldGet("D3_QUANT",nCntSldLin)})
										//Endif		
									Endif
								Endif		
								If lLote .and. lLocaliza
									If gdFieldGet("D3_LOTECTL",nCntSldLin) == aSaldo[nCntSld][1] .and. gdFieldGet("D3_NUMLOTE",nCntSldLin) == aSaldo[nCntSld][2] .and. gdFieldGet("D3_LOCALIZ",nCntSldLin) == aSaldo[nCntSld][3]
										//If (nPos:=aScan(aSaldoLinhas,{|x| x[1]==gdFieldGet("D3_LOTECTL",nCntSldLin) .and. x[2]==gdFieldGet("D3_NUMLOTE",nCntSldLin) .and. x[3]==gdFieldGet("D3_LOCALIZ",nCntSldLin)})) > 0
											nSaldoLinhas += gdFieldGet("D3_QUANT",nCntSldLin)
											//aSaldoLinhas[nPos][4] += gdFieldGet("D3_QUANT",nCntSldLin)
										//Else
										//	aAdd(aSaldoLinhas,{gdFieldGet("D3_LOTECTL",nCntSldLin),gdFieldGet("D3_NUMLOTE",nCntSldLin),gdFieldGet("D3_LOCALIZ",nCntSldLin),gdFieldGet("D3_QUANT",nCntSldLin)})
										//Endif		
									Endif
								Endif		
							Endif	
						Next	
		            	
		            	If aSaldo[nCntSld][5]-nSaldoLinhas > 0
			            	nSaldoSoma += aSaldo[nCntSld][5]-nSaldoLinhas
		            		aAdd(aSaldoSoma,{0,aSaldo[nCntSld][1],aSaldo[nCntSld][2],aSaldo[nCntSld][7],aSaldo[nCntSld][3],aSaldo[nCntSld][4]})
			            	If nSaldoSoma <= (cAlias)->CP_QUANT-(cAlias)->CP_QUJE
		    	        		aSaldoSoma[Len(aSaldoSoma)][1] := aSaldo[nCntSld][5]-nSaldoLinhas
		        	    	Else	
		            			aSaldoSoma[Len(aSaldoSoma)][1] := ((cAlias)->CP_QUANT-(cAlias)->CP_QUJE)-(nSaldoSoma-(aSaldo[nCntSld][5]-nSaldoLinhas))
		            		Endif	
		            	Endif	

						If nSaldoSoma >= (cAlias)->CP_QUANT-(cAlias)->CP_QUJE
							lContinua := .T.
							Exit
						Endif
					Next
				Else
					// verifica a quantidade jah informada nos itens anteriores deste movimento
					aEval(aCols,{|x,y| IIf(gdFieldGet("D3_COD",y)==(cAlias)->CP_PRODUTO .and. gdFieldGet("D3_LOCAL",y)==(cAlias)->CP_LOCAL,nSaldoLinhas+=gdFieldGet("D3_QUANT",y),Nil)})

					If SB2->(dbSeek(xFilial("SB2")+(cAlias)->CP_PRODUTO+(cAlias)->CP_LOCAL))
						nSaldoSB2 := SaldoSB2() //SaldoMov()
						If nSaldoSB2 >= (cAlias)->CP_QUANT-(cAlias)->CP_QUJE+nSaldoLinhas
							lContinua := .T.
							aSaldoSoma := {(cAlias)->CP_QUANT-(cAlias)->CP_QUJE}
						Endif	
					Endif		
				Endif	
						
				If lContinua 
					For nCntCols:=1 To Len(aSaldoSoma)			
						If Empty(cCC) // assume o centro de custo da 1 SA marcada
							cCC := (cAlias)->CP_CC
							cCCSav := cCC // guarda para nao deixar o usuario trocar
						Endif	
						If cCC != (cAlias)->CP_CC
							APMsgAlert("Centro de Custo diferente das demais SA�s marcadas."+CRLF+;
							"Produto / Armazem: "+(cAlias)->CP_PRODUTO+" / "+(cAlias)->CP_LOCAL+CRLF+;
							"Solicita��o ao Armazem / Item: "+(cAlias)->CP_NUM+" / "+(cAlias)->CP_ITEM+CRLF+;
							"Centro de Custo a ser usado nesta baixa: "+cCC+CRLF+;
							"Centro de Custo deste item da SA: "+(cAlias)->CP_CC+CRLF+;
							"Este produto nao sera considerado para Baixa.")
							Loop
						Endif	
						// preenche os itens do movimento interno
						If !(Len(aCols) = 1 .and. Empty(gdFieldGet("D3_COD",1))) // verifica se primeira linha jah foi preenchida, neste caso, adiciona novas linhas
							aAdd(aCols,aClone(aColsRef[1]))
						Endif	
						gdFieldPut("D3_COD",(cAlias)->CP_PRODUTO,Len(aCols))
						gdFieldPut("D3_DESCRI",SB1->B1_DESC,Len(aCols))			
						gdFieldPut("D3_UM",SB1->B1_UM,Len(aCols))
						//gdFieldPut("D3_QUANT",(cAlias)->CP_QUANT-(cAlias)->CP_QUJE,Len(aCols))
						gdFieldPut("D3_QUANT",IIf((lLote .or. lLocaliza),aSaldoSoma[nCntCols][1],aSaldoSoma[1]),Len(aCols))
						gdFieldPut("D3_SEGUM",SB1->B1_SEGUM,Len(aCols))
						//gdFieldPut("D3_QTSEGUM",ConvUM((cAlias)->CP_PRODUTO,(cAlias)->CP_QUANT-(cAlias)->CP_QUJE,0,2),Len(aCols))
						gdFieldPut("D3_QTSEGUM",ConvUM((cAlias)->CP_PRODUTO,IIf((lLote .or. lLocaliza),aSaldoSoma[nCntCols][1],aSaldoSoma[1]),0,2),Len(aCols))
						gdFieldPut("D3_LOCAL",(cAlias)->CP_LOCAL,Len(aCols))
						gdFieldPut("D3_CONTA",/*SB1->B1_CONTA*/(cAlias)->CP_CONTA,Len(aCols))					
						gdFieldPut("D3_ITEMCTA",/*SB1->B1_ITEMCC*/(cAlias)->CP_ITEMCTA,Len(aCols))
						gdFieldPut("D3_CLVL",/*SB1->B1_CLVL*/(cAlias)->CP_CLVL,Len(aCols))
						gdFieldPut("D3_GRUPO",SB1->B1_GRUPO,Len(aCols))
						gdFieldPut("D3_TIPO",SB1->B1_TIPO,Len(aCols))
						gdFieldPut("D3_NUMSA",(cAlias)->CP_NUM,Len(aCols))
						gdFieldPut("D3_ITEMSA",(cAlias)->CP_ITEM,Len(aCols))
						gdFieldPut("D3_ZQTDSA",(cAlias)->CP_QUANT,Len(aCols))
						gdFieldPut("D3_ZSLDSA",(cAlias)->CP_QUANT-(cAlias)->CP_QUJE,Len(aCols))
						If !Empty((cAlias)->CP_OP)
							gdFieldPut("D3_OP",(cAlias)->CP_OP,Len(aCols))
						Endif	
						If lLote
							//gdFieldPut("D3_LOTECTL",aSaldo[nCntSld][1],Len(aCols))
							gdFieldPut("D3_LOTECTL",aSaldoSoma[nCntCols][2],Len(aCols))
							//gdFieldPut("D3_NUMLOTE",aSaldo[nCntSld][2],Len(aCols))
							gdFieldPut("D3_NUMLOTE",aSaldoSoma[nCntCols][3],Len(aCols))
							//gdFieldPut("D3_DTVALID",aSaldo[nCntSld][7],Len(aCols))
							gdFieldPut("D3_DTVALID",aSaldoSoma[nCntCols][4],Len(aCols))
						Endif
						If lLocaliza	
							//gdFieldPut("D3_LOCALIZ",aSaldo[nCntSld][3],Len(aCols))
							gdFieldPut("D3_LOCALIZ",aSaldoSoma[nCntCols][5],Len(aCols))
							//gdFieldPut("D3_NUMSERI",aSaldo[nCntSld][4],Len(aCols))
							gdFieldPut("D3_NUMSERI",aSaldoSoma[nCntCols][6],Len(aCols))
						Endif	
												
						// Executa gatilhos e validacoes
						If ExistTrigger("D3_COD")
							RunTrigger(2,Len(aCols),,"D3_COD")
						EndIf
						If ExistTrigger("D3_QUANT")
							RunTrigger(2,Len(aCols),,"D3_QUANT")
						EndIf
						If ExistTrigger("D3_LOCAL")
							RunTrigger(2,Len(aCols),,"D3_LOCAL")
						EndIf
					
					//msgalert("aqui"+(cAlias)->CP_NUM)
					
					Next	

				Else
					APMsgAlert("Sem Saldo disponivel em estoque."+CRLF+;
					"Produto / Armazem: "+(cAlias)->CP_PRODUTO+" / "+(cAlias)->CP_LOCAL+CRLF+;
					"Solicita��o ao Armazem / Item: "+(cAlias)->CP_NUM+" / "+(cAlias)->CP_ITEM+CRLF+;
					"Este produto nao sera considerado para Baixa.")
				Endif
			Endif
		Endif			
	Endif
Next				

aEval(aArea,{|x| RestArea(x)})	


Return()


Static Function Est26Mk(cField)

Local cFldMrk := ""
Local cAlias := oBrowse:Alias()
Local nPos := 0

cFldMrk := cAlias+'->'+cField
// Verifica se o item esta sendo marcado ou desmarcado
If !oBrowse:IsMark()
	(cAlias)->(RecLock(cAlias,.F.))
	&cFldMrk := oBrowse:Mark()
	(cAlias)->(MsUnLock())
	If (nPos:=aScan(aMark,{|x| x[1]==(cAlias)->(Recno())})) == 0
		aAdd(aMark,{(cAlias)->(Recno()),.T.})
	Else
		aMark[nPos][2] := .T.	
	Endif	
Else
	(cAlias)->(RecLock(cAlias,.F.))
	&cFldMrk := ""
	(cAlias)->(MsUnLock())
	If (nPos:=aScan(aMark,{|x| x[1]==(cAlias)->(Recno())})) > 0
		aMark[nPos][2] := .F.
	Endif	
EndIf

Return .T.


// rotina chamada pelo ponto de entrada MTA241DOC
// faz o tratamento para apresentacao ou nao de alguns campos na inclusao do movimento interno de baixa da solicitacao ao armazem
User Function Est26Header(lEstorno)

Local aArea := {SX3->(GetArea()),GetArea()}
Local aCampos := {"D3_ZQTDSA","D3_ZSLDSA"}
Local aCamposErro := {"D3_DTVALID","D3_LOTECTL"} // estes campos estao com problema no x3_usado, estao ficando gravados no formato dos SX�s no system ao inves do formato dos SX�s no banco. O padrao do mata241 estah gravando errado estes campos
Local nCnt := 0

If !lEstorno
	SX3->(dbSetOrder(2))
	For nCnt:=1 To Len(aCampos)
		If SX3->(dbSeek(aCampos[nCnt]))
			SX3->(RecLock("SX3",.F.))
			// chamada da rotina de inclusao da baixa da SA
			If IsInCallStack("U_MGFEST26")
				SX3->X3_USADO := "x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     " // USADO SIM
			Else
				SX3->X3_USADO := "x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       " // USADO NAO
			Endif	
			SX3->(MsUnLock())
		Endif
	Next	
Endif
	
// paleativo ateh o fonte padrao mata241 ser corrigido
// OBS: depois de corrigido este problema no mata241 excluir este trecho do fonte
For nCnt:=1 To Len(aCamposErro)
	If SX3->(dbSeek(aCamposErro[nCnt]))
		SX3->(RecLock("SX3",.F.))
		SX3->X3_USADO := "x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     " // USADO SIM
		SX3->(MsUnLock())
	Endif
Next	
	
aEval(aArea,{|x| RestArea(x)})	

Return()


// rotina chamada pelo ponto de entrada MTA241MNU
// insere nova opcao no menu
User Function Est26Menu()

Local nPos := 0

// chamada pela rotina de baixa da SA especifica
If IsInCallStack("U_MGFEST28")
	aAdd(aRotina,{OemToAnsi("Baixar Solicita��o ao Armazem"),"U_MGFEST26",0,4,0,Nil})
	aAdd(aRotina,{OemToAnsi("Relatorio para Baixas da SA"),"U_Est26RelBx",0,2,0,Nil})	
	/* obs: nao tirar nenhuma opcao do arotina, senao a funcao de estorno padrao do mata241 nao funciona
	If (nPos:=aScan(aRotina,{|x| x[2]=="A241Inclui"})) > 0
		aDel(aRotina,nPos)
		aRotina := aSize(aRotina,Len(aRotina)-1)
	Endif	
	*/
	// muda o nome da rotina que eh apresentado em tela
	cCadastro := "Baixa de Solicita��o ao Armazem"
Endif	

Return()


// rotina chamada pelo ponto de entrada MTA105MNU
// insere nova opcao no menu, insere rotina padrao de encerramento da SA, na tela de manutencao da SA
User Function Est26SAMenu()

aAdd(aRotina,{OemToAnsi("Encerrar SA"),"U_Est26EncSA",0,5,0,Nil})

aAdd(aRotina,{OemToAnsi("Log Envio SA para aprovacao do RH"),"U_MGFES74A",0,5,0,Nil})

aAdd(aRotina,{OemToAnsi("Log Retorno da aprovacao SA pelo RH"),"U_MGFES74B",0,5,0,Nil})

Return()


// rotina para encerrar a SA, chamada diretamente da tela de manutencao da SA
User Function Est26EncSA()

// variavel padrao do mata185
Private l185Auto := .F.

A185Encer("SCP",SCP->(Recno()),7)

Return()


// rotina chamada no x3_vlduser do campo D3_QUANT
User Function Est26VlQtd()

Local lRet := .T.

If IsInCallStack("U_MGFEST28") .and. Type("oBrowse") != "U"
	If M->D3_QUANT > gdFieldGet("D3_ZSLDSA",n)
		lRet := .F.
		APMsgStop("Quantidade digitada maior que o saldo da Solicita��o ao Armazem.")
	Endif
Endif		

Return(lRet)


// rotina chamada pelo ponto de entrada MT241TOK
// grava variaveis usadas para que o tratamento da baixa da solicitacao ao armazem seja feita pelo padrao, na inclusao do movimento interno mod. II
User Function Est26TOk()
/*
Local aArea := {SCP->(GetArea()),GetArea()}
Local lRet := .T.
Local lPimsInt	:= SuperGetMV("MV_PIMSINT",.F.,.F.)
Local nCnt := 0

// trata variavel private aDadosCQ usada na inclusao do movimento interno, para baixa da solicitao ao armazem
If IsInCallStack("U_MGFEST28") .and. Type("aDadosCQ") != "U"
	SCP->(dbSetOrder(1))
	aDadosCQ := {}
	For nCnt:=1 To Len(aCols)
		If !gdDeleted(nCnt)
			If SCP->(dbSeek(xFilial("SCP")+gdFieldGet("D3_NUMSA",nCnt)+gdFieldGet("D3_ITEMSA",nCnt)))
				aAdd(aDadosCQ,{	.T.				,;									// Marca de selecao
								SCP->CP_NUM		,; 									// Numero da SA
								SCP->CP_ITEM	,;									// Item da SA
								SCP->CP_PRODUTO	,;									// Produto
								SCP->CP_DESCRI	,;									// Descricao do Produto
								SCP->CP_LOCAL	,;									// Armazem
								SCP->CP_UM		,;									// UM
								Transform(gdFieldGet("D3_QUANT",nCnt),PesqPictQt('D3_QUANT')),;	// Qtd. a Requisitar (Formato Caracter)
								gdFieldGet("D3_QUANT",nCnt)	,;									// Qtd. a Requisitar
								SCP->CP_CC		,;									// Centro de Custo
								SCP->CP_SEGUM	,;									// 2a.UM
								gdFieldGet("D3_QTSEGUM",nCnt)	,;									// Qtd. 2a.UM
								SCP->CP_OP		,;									// Ordem de Producao
								SCP->CP_CONTA	,;									// Conta Contabil
								SCP->CP_ITEMCTA	,;									// Item Contabil
								SCP->CP_CLVL		,;									// Classe Valor
								CriaVar('AFH_PROJET',.F.),; 				 	// Projeto
								SCP->CP_NUMOS 	,;									// Nr. da OS
								CriaVar('AFH_TAREFA',.F.),;				 	// Tarefa
								"SCP"	,;										// Alias Walk-Thru
								SCP->(RecNo()) ,;								// Recno Walk-Thru
								Iif(lPimsint,SCP->CP_NRBPIMS,' ')})								// Numero Boletim PIMS
			Endif
		Endif
	Next
Endif								

aEval(aArea,{|x| RestArea(x)})	
*/
Local lRet := .T.

If IsInCallStack("U_MGFEST28") .and. Type("cCCSav") != "U"
	If cCCSav != cCC .or. Empty(cCC)
		lRet := .F.
		APMsgAlert("Centro de Custo do cabecalho nao pode ser diferente do cadastrado na SA e nao pode ser vazio."+CRLF+;
		"Centro de Custo da SA: "+cCCSav)
	Endif	
Endif	

// inserido em 28/06/18, pois alguns registros da sd3 estao ficando com o campo d3_filial em branco, inexplicavelmente
If lRet
	If IsInCallStack("U_MGFEST28")
		If Empty(cFilAnt)
			lRet := .F.
			APMsgStop("Filial em branco, movimento nao sera confirmado.")
		Endif
	Endif
Endif		

Return(lRet)


// rotina chamada pelo ponto de entrada MBrwBtn
// impede utilizacao da opcao de inclusao padrao do movimento interno mod II, na rotina de baixa da solicitacao ao armazem
User Function Est26Brw()

Local lRet := .T.
Local cAlias := ParamIxb[1]
Local nRecno := ParamIxb[2]
Local nOpcao := ParamIxb[3]
Local cFunc := ParamIxb[4]

If cAlias = "SD3" .and. Upper(cFunc) = "A241INCLUI" .and. FunName() = "MGFEST28" .and. nOpcao == 3
	lRet := .F.
	ApMsgStop("Essa opcao nao deve ser executada nesta rotina.")
Endif	

If cAlias = "SD3" .and. Upper(cFunc) = "A241ESTORN" .and. FunName() = "MGFEST28" .and. nOpcao == 6
	U_Est26Header(.T.)
Endif

Return(lRet)


// rotina chamada pelo ponto de entrada SD3240I / SD3240E
// valida o estorno do movimento interno, somente deixa estornar se for movimento realizado para solicitacao ao armazem
User Function Est26VEst()

Local aArea := {SD3->(GetArea()),GetArea()}
Local lRet := .T.
Local nCnt := 0

// na rotina especifica de baixa da sa, somente permite estornar movimentos que tenham sido gerados a partir de SA�s
If IsInCallStack("U_MGFEST28")
	aEval(aCols,{|x,y| IIf((Empty(gdFieldGet("D3_NUMSA",y)) .or. Empty(gdFieldGet("D3_ITEMSA",y))),lRet:=.F.,Nil)})
	If !lRet
		APMsgStop("Somente movimentos gerados a partir de Solicitacoes ao Armazem podem ser estornados por esta rotina."+CRLF+;
		"Utilize a rotina padrao de Movimentos Internos mod. II para realizar este estorno.")
	Endif	
Else
	If SD3->D3_ZORIGEM != "MGFEST08" // movimentos gerados pela rotina especifica de baixa da SA via coletor
		If IsInCallStack("MATA241")
			 // na rotina padrao mata241 nao pode deixar estornar movimentos que tenham sido feitos pela rotina especifica
			For nCnt:=1 To Len(aCols)

				nPosRecWT := 0
				nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "RECNO WT" } )

				if nPosRecWT == 0
					nPosRecWT := aScan( aHeader,{ |x| upper( allTrim( x[ 1 ] ) ) == "WT RECNO" } )
				endif

				//SD3->(dbGoto(aCols[nCnt][aScan(aHeader,{|x| Alltrim(x[1])=="Recno WT"})]))
				//If SD3->(Recno()) == aCols[nCnt][aScan(aHeader,{|x| Alltrim(x[1])=="Recno WT"})]
				If SD3->(Recno()) == aCols[nCnt][nPosRecWT]
					If !Empty(SD3->D3_NUMSA) .or. !Empty(SD3->D3_ITEMSA)
						lRet := .F.
						Exit
					Endif
				Endif
			Next			
		ElseIf IsInCallStack("MATA240")	
			If !Empty(SD3->D3_NUMSA) .or. !Empty(SD3->D3_ITEMSA)
				lRet := .F.
			Endif
		Endif
		If !lRet
			APMsgStop("Movimentos gerados a partir de Solicitacoes ao Armazem nao podem ser estornados por esta rotina."+CRLF+;
			"Utilize a rotina espec�fica de Baixa de Solicita��o ao Armazem para realizar este estorno.")
		Endif
	Endif		
Endif
        
aEval(aArea,{|x| RestArea(x)})	

Return(lRet)	


// rotina chamada pelo ponto de entrada MT241EST
// grava campos complementares no estorno do movimento interno
User Function Est26GEst(cOper)

Local aArea := {SB2->(GetArea()),SCP->(GetArea()),GetArea()}

If IsInCallStack("U_MGFEST28") .or. SD3->D3_ZORIGEM == "MGFEST08"
	SCP->(dbSetOrder(1))
	SB2->(dbSetOrder(1))
	If SCP->(dbSeek(xFilial("SCP")+SD3->D3_NUMSA+SD3->D3_ITEMSA))
		SCP->(RecLock("SCP",.F.))
		If cOper == "I"
			SCP->CP_QUJE := SCP->CP_QUJE+SD3->D3_QUANT
			If SCP->CP_QUJE > SCP->CP_QUANT
				SCP->CP_QUJE := SCP->CP_QUANT
			Endif
			If SCP->CP_QUJE == SCP->CP_QUANT .and. SCP->CP_STATUS != "E"
				SCP->CP_STATUS := "E"
				SCP->CP_PREREQU := "S" // gravado apenas para atualizar corretamente a legenda da tela de SA
			Else
				If SCP->CP_PREREQU == "S"
					SCP->CP_PREREQU := "" // forca a limpeza deste campo no estorno, pois em algumas ocasioes estah ficando gravado indevidamente
				Endif	
			Endif	
		Else
			SCP->CP_QUJE := SCP->CP_QUJE-SD3->D3_QUANT
			If SCP->CP_PREREQU == "S"
				SCP->CP_PREREQU := "" // forca a limpeza deste campo no estorno, pois em algumas ocasioes estah ficando gravado indevidamente
			Endif	
			If SCP->CP_QUJE < 0
				SCP->CP_QUJE := 0
			Endif
			If SCP->CP_QUJE < SCP->CP_QUANT .and. SCP->CP_STATUS == "E"
				SCP->CP_STATUS := ""
				If SCP->CP_PREREQU == "S"
					SCP->CP_PREREQU := "" // gravado apenas para atualizar corretamente a legenda da tela de SA
				Endif	
			Endif	
		Endif	
		SCP->(MsUnLock())
		/* nao mexer neste campo
		//--> Atualizar o Saldo das Solicitacoes ao Armazem
		If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL))
			SB2->(RecLock("SB2",.F.))
			SB2->B2_QEMPSA := IIf(cOper=="I", SB2->B2_QEMPSA+StaticCall(MATA185,A185QtdNeg,SD3->D3_QUANT,SCP->CP_NUM,SCP->CP_ITEM)
			SB2->(MsUnlock())
		EndIf
		*/
	Endif
Endif		
	
aEval(aArea,{|x| RestArea(x)})	

Return()


// rotina chamada pelo ponto de entrada MT241LOK
User Function Est26LOk(nLinha)

Local lRet := .T.

// somente valida movimentos que tenham sido gerados a partir de SA�s
If IsInCallStack("U_MGFEST28")
	If Empty(gdFieldGet("D3_NUMSA",nLinha)) .or. Empty(gdFieldGet("D3_ITEMSA",nLinha))
		lRet := .F.
		APMsgStop("Nao � permitida a inclusao de linhas para movimentos de baixa de Solicita��o ao Armazem.")
	Endif
	If lRet
		// OBS: forca para a variavel do foco ser a de D3_QUANT, pois se for a D3_COD estah dando erro na funcao padrao A240Quant()
		If __ReadVar != "D3_QUANT"
			__ReadVar := "D3_QUANT"
		Endif	
	Endif	
Endif		

Return(lRet)


// rotina para desmarcar os registros no refresh do browse, para retorno da tela de inclusao do movimento interno, sem os registros marcados
Static Function DesmarBrw()

Local nCnt := 0
Local cAlias := oBrowse:Alias()
Local aArea := {(cAlias)->(GetArea()),GetArea()}

For nCnt:=1 To Len(aMark)
	If aMark[nCnt][2]
		(cAlias)->(dbGoto(aMark[nCnt][1]))
		If (cAlias)->(Recno()) == aMark[nCnt][1]
			(cAlias)->(RecLock(cAlias,.F.))
			(cAlias)->CP_OK := "" // limpa marca
			(cAlias)->(MsUnLock())
		Endif
	Endif
Next			

// zera aMark
aMark := {}

aEval(aArea,{|x| RestArea(x)})	

Return()


// relatorio de baixa da SA
User Function Est26RelBx()

Local oReport

// verifica se filial corrente eh a mesma da logada
// variavel private cFil declarada no fonte MGFEST28
If Type("cFil") != "U"
	If cFilAnt != cFil .and. !Empty(cFil)
		cFilAnt := cFil
	Endif
Endif	

//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

// retorna pergunta padrao do mata241
Pergunte("MTA240",.F.)

Return()


Static Function ReportDef()

Local oReport,oCab1,oCab2,oItens
Local aPergs := {}

oReport := TReport():New("MGFEST26","Relatorio de Baixa da Solicita��o ao Armazem","MGFEST26",{|oReport| ReportPrint(oReport,oCab1,oCab2,oItens)},"Este programa ira emitir o relatorio de baixa da Solicita��o ao Armazem.")
oReport:SetPortrait(.T.) 

aadd(aPergs,{"Solicitacao ao Armazem de ?"	,"","","mv_ch1","C",06,0,0 ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SCP","","","","","","",""})
aadd(aPergs,{"Solicitacao ao Armazem ate ?"	,"","","mv_ch2","C",06,0,0 ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SCP","","","","","","",""})
aadd(aPergs,{"Solicitante de ?"				,"","","mv_ch3","C",06,0,0 ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","","","",""})
aadd(aPergs,{"Solicitante ate ?"			,"","","mv_ch4","C",06,0,0 ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","","","",""})
aadd(aPergs,{"Data de ?"	      			,"","","mv_ch5","D",08,0,0 ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Data ate ?"	      			,"","","mv_ch6","D",08,0,0 ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1("MGFEST26",aPergs)

Pergunte(oReport:uParam,.F.)

oCab1 := TRSection():New(oReport,"SA",{"SCP"},/*{Array com as ordens do relatorio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oCab1,"CP_NUM"		,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	

oCab2 := TRSection():New(oCab1,"Solicitante",{"SCP"},/*{Array com as ordens do relatorio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oCab2,"cName"		,/*Tabela*/,"Solicitante"/*Titulo*/,"@!"/*Picture*/,40/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/{|| cName			})	
TRCell():New(oCab2,"CP_EMISSAO"	,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New(oCab2,"dEntrega"	,/*Tabela*/,"Data Entrega"	,PesqPict("SCP","CP_EMISSAO")		,TamSX3("CP_EMISSAO"	)[1]	,/*lPixel*/,{|| 			},,,)

oItens := TRSection():New(oCab1,"Itens",{"SCP"},/*{Array com as ordens do relatorio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oItens:SetTotalInLine(.T.)
TRCell():New(oItens,"CP_ITEM"		,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New(oItens,"CP_PRODUTO"	,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oItens,"CP_DESCRI"		,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oItens,"CP_UM"			,"SCP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oItens,"nQtdLib"		,/*Tabela*/,"Qtd. Liberada"		,PesqPict("SCP","CP_QUANT")		,TamSX3("CP_QUANT"	)[1]	,/*lPixel*/,{|| (cAliasTrb)->CP_QUANT-(cAliasTrb)->CP_QUJE	},,,"RIGHT")
TRCell():New(oItens,"nQtdAte" 		,/*Tabela*/,"Qtd. Atendida"		,PesqPict("SCP","CP_QUANT")		,TamSX3("CP_QUANT"	)[1]	,/*lPixel*/,{|| 	},,,"RIGHT")
TRCell():New(oItens,"nQtdSld" 		,/*Tabela*/,"Qtd. Saldo"		,PesqPict("SCP","CP_QUANT")		,TamSX3("CP_QUANT"	)[1]	,/*lPixel*/,{|| 	},,,"RIGHT")
TRCell():New(oItens,"cLocal" 		,/*Tabela*/,"Armazem"			,PesqPict("SCP","CP_LOCAL")		,TamSX3("CP_LOCAL"	)[1]	,/*lPixel*/,{|| 	},,,)
TRCell():New(oItens,"cLote" 		,/*Tabela*/,"Lote"				,PesqPict("SD3","D3_LOTECTL")	,TamSX3("D3_LOTECTL")[1]	,/*lPixel*/,{|| 	},,,)
TRCell():New(oItens,"cEnd" 			,/*Tabela*/,"Endereco"			,PesqPict("SD3","D3_LOCALIZ")	,TamSX3("D3_LOCALIZ")[1]	,/*lPixel*/,{|| 	},,,)

Return(oReport)


Static Function ReportPrint(oReport,oCab1,oCab2,oItens)

TRImpAna(oReport,oCab1,oCab2,oItens)

Return


Static Function TRImpAna(oReport,oCab1,oCab2,oItens)

Local aArea := {SCP->(GetArea()),GetArea()}        
Local cAliasTrb := GetNextAlias()
Local oBreak := Nil
Local cSA := ""
Local cName := ""

oReport:Section(1):Section(1):Cell("cName"	):SetBlock({|| cName				})

oReport:Section(1):Section(2):Cell("nQtdLib"):SetBlock({|| (cAliasTrb)->CP_QUANT-(cAliasTrb)->CP_QUJE	})

oReport:Section(1):BeginQuery()	
BeginSql Alias cAliasTrb
SELECT SCP.*,R_E_C_N_O_ SCP_RECNO
FROM %Table:SCP% SCP
WHERE CP_FILIAL = %xFilial:SCP%
AND CP_NUM >= %Exp:mv_par01% AND CP_NUM <= %Exp:mv_par02%
AND CP_CODSOLI >= %Exp:mv_par03% AND CP_CODSOLI <= %Exp:mv_par04%
AND CP_EMISSAO >= %Exp:dTos(mv_par05)% AND CP_EMISSAO <= %Exp:dTos(mv_par06)% 
AND CP_QUANT-CP_QUJE > 0
AND CP_STATSA = 'L'
AND CP_STATUS <> 'E'
AND SCP.%notdel%       
ORDER BY CP_FILIAL,CP_NUM,CP_ITEM
EndSql       
oReport:Section(1):EndQuery()

oReport:SetMeter((cAliasTrb)->(LastRec()))
dbSelectArea(cAliasTrb)

oBreak := TRBreak():New(oReport:Section(1),{|| SCP->CP_NUM},,.F.) //"Total Filial : "

SCP->(dbSetOrder(1))
While !oReport:Cancel() .And. !(cAliasTrb)->(Eof())
	SCP->(dbGoto((cAliasTrb)->SCP_RECNO))
	If SCP->(Recno()) == (cAliasTrb)->SCP_RECNO
		cSA := SCP->CP_NUM
		cName := UsrFullName(SCP->CP_CODSOLI)
			
		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
	
		oReport:Section(1):Section(1):Init()
		oReport:Section(1):Section(1):PrintLine()
	
		While !oReport:Cancel() .and. !(cAliasTrb)->(Eof()) .and. (cAliasTrb)->CP_NUM == cSA
			SCP->(dbGoto((cAliasTrb)->SCP_RECNO))
			If SCP->(Recno()) == (cAliasTrb)->SCP_RECNO
				oReport:Section(1):Section(2):Init()
				oReport:Section(1):Section(2):PrintLine()	
			Endif	
			(cAliasTrb)->(dbSkip())
		Enddo
		    
		oReport:Section(1):Section(2):Finish()	
		oReport:Section(1):Section(1):Finish()		
		oReport:Section(1):Finish()
		oReport:SkipLine()		
	Endif		
Enddo
		
(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})		

Return()


// rotina criada, pois na P12 esta funcao foi removida do RPO
// foi usada como base a rotina padrao da versao P11.8
Static Function AjustaSX1(cPerg, aPergs)
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nj		:= 1
Local aArea		:= GetArea()
Local lUpdHlp	:= .T.

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3","X1_PYME","X1_GRPSXG","X1_HELP","X1_PICTURE","X1_IDFIL"}

dbSelectArea( "SX1" )
dbSetOrder(1)

cPerg := PadR( cPerg , Len(X1_GRUPO) , " " )

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek( cPerg + Right( Alltrim( aPergs[nX][11] ) , 2) )

		If ( ValType( aPergs[nX][Len( aPergs[nx] )]) = "B" .And. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif

	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]		
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(ALLTRIM( aPergs[nX][11] ), 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0 .And. ValType(aPergs[nX][nJ]) != "A"
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
	Endif
	cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

	If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
		aHelpSpa := aPergs[nx][Len(aPergs[nx])]
	Else
		aHelpSpa := {}
	Endif
	
	If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
		aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
	Else
		aHelpEng := {}
	Endif

	If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
		aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
	Else
		aHelpPor := {}
	Endif

	// Caso exista um help com o mesmo nome, atualiza o registro.
	lUpdHlp := ( !Empty(aHelpSpa) .and. !Empty(aHelpEng) .and. !Empty(aHelpPor) )
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdHlp)
	
Next
RestArea(aArea)

Return()

