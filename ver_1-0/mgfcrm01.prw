#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCRM01
Autor...............: Mauricio Gresele
Data................: 07/10/2016 
Descricao / Objetivo: Cadastro especifico do Controle de conta do vendedor
Doc. Origem.........: CRM - GAP CRM05
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFCRM01()

Local aArea := {GetArea()}

Private cString := "ADL"
Private aRotina
Private cCadastro := "CONTROLE DE CONTA DO VENDEDOR"
Private aTrocaF3 := {}

aRotina := {;
{"Pesquisar"    			, "AxPesqui"                                  	, 0, 1},;
{"Visualizar"               , "U_CRM01Vis(cString)"                        	, 0, 2},;
{"Incluir"                  , "U_CRM01Inc(cString)"            				, 0, 3},;
{"Alterar"                  , "U_CRM01Alt(cString)"						   	, 0, 4},;
{"Excluir"                  , "U_CRM01Exc(cString)"						   	, 0, 5}}

dbSelectArea(cString)
dbSetOrder(1)

mBrowse(06, 01, 22, 75, cString, , , , , , , , , , , .F.)

aEval(aArea,{|x| RestArea(x)})

Return()


User Function CRM01Vis(cString)

Local aAcho := {"ADL_VEND","ADL_ZNMVEN","ADL_ENTIDA","ADL_CODENT","ADL_LOJENT","ADL_NOME","ADL_CGC"}

AxVisual(cString,(cString)->(Recno()),,aAcho)

Return()


User Function CRM01Inc(cString)

Local aArea := {AO4->(GetArea()),GetArea()}
Local nOpc := 0
Local aAcho := {"ADL_VEND","ADL_ZNMVEN","ADL_ENTIDA","ADL_CODENT","ADL_LOJENT","ADL_NOME","ADL_CGC"}

RegToMemory(cString)
nOpc := AxInclui(cString,,,aAcho,,,"U_CRM01IOK()")

If nOpc == 1
	CRM01IO4()
Endif		
		
aEval(aArea,{|x| RestArea(x)})

Return()


User Function CRM01Alt(cString)

Local nOpc := 0
Local aAcho := {"ADL_VEND","ADL_ZNMVEN","ADL_ENTIDA","ADL_CODENT","ADL_LOJENT","ADL_NOME","ADL_CGC"}
Local cChave := ""
Local cChaveAlt := ""
Local cUsuario := ""

RegToMemory(cString)
CRM01Usu(@cUsuario)
cChave := xFilial("AO4")+M->ADL_ENTIDA+Padr(M->ADL_CODENT+M->ADL_LOJENT,TamSX3("AO4_CHVREG")[1])+cUsuario 
cChaveAlt := cChave+M->ADL_VEND

// trata consulta F3
U_CRM01F3(.F.)

nOpc := AxAltera(cString,(cString)->(Recno()),4,aAcho,,,,"U_CRM01AOK('1','"+cChaveAlt+"','"+cChave+"')")

If nOpc == 1
	// exclui registro na AO4 com chave antiga
	CRM01EO4(cChave)
	
	//inclui registro na AO4 com chave nova
	CRM01IO4()
Endif	

Return()


User Function CRM01Exc(cString)

Local nOpc := 0
Local aAcho := {"ADL_VEND","ADL_ZNMVEN","ADL_ENTIDA","ADL_CODENT","ADL_LOJENT","ADL_NOME","ADL_CGC"}
Local lRet := .T.
Local cChave := ""
Local cUsuario := ""
Local cChaveAlt := ""
	
RegToMemory(cString)
CRM01Usu(@cUsuario)
cChave := xFilial("AO4")+M->ADL_ENTIDA+Padr(M->ADL_CODENT+M->ADL_LOJENT,TamSX3("AO4_CHVREG")[1])+cUsuario 
cChaveAlt := cChave+M->ADL_VEND

lRet := U_CRM01AOK('2',cChaveAlt,cChave)
If lRet
	nOpc := AxDeleta(cString,(cString)->(Recno()),5,,aAcho)
    
	// exclui registro da AO4
	If nOpc == 2
		CRM01EO4(cChave)	 
	Endif	
Endif	

Return()


// funcao para validar a inclusao
User Function CRM01IOK()

Local aArea := {ADL->(GetArea()),GetArea()}
Local lRet := .T.

If Empty(M->ADL_LOJENT)
	lRet := .F.
	APMsgStop("Preencher campo Loj.Entidade.")
Endif	

If lRet
	ADL->(dbSetOrder(5))
	If ADL->(dbSeek(xFilial("ADL")+M->ADL_VEND+M->ADL_ENTIDA+M->ADL_CODENT+M->ADL_LOJENT))
		lRet := .F.
		APMsgStop("Já existe registro com esta chave na tabela ADL, Vendedor+Entidade+Cod_Entidade+Loja_Entidade. Verifique!")
	Endif	
Endif
	
aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// funcao para validar a alteracao/exclusao
User Function CRM01AOK(cTipo,cChaveAlt,cChave)

Local aArea := {ADL->(GetArea()),AO4->(GetArea()),AO5->(GetArea()),GetArea()}
Local lRet := .T.
Local cUsuario := ""
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local cUsuarioNew := ""

If Empty(M->ADL_LOJENT)
	lRet := .F.
	APMsgStop("Preencher campo Loj.Entidade.")
Endif	

CRM01Usu(@cUsuario)

If cTipo == "1" // alteracao
	// se nao houve alteracao nos campos da chave, nao deixa confirmar a alteracao
	If cChaveAlt == xFilial("AO4")+M->ADL_ENTIDA+Padr(M->ADL_CODENT+M->ADL_LOJENT,TamSX3("AO4_CHVREG")[1])+cUsuario+M->ADL_VEND  	
		lRet := .F.
		APMsgStop("Não houve alteração nos campos. Feche a tela pelo botão 'Cancelar'.")
	Endif	
Endif
	
If lRet
	If cTipo == "1" // alteracao
		// valida se jah existe esta mesma chave na tabela ADL
		ADL->(dbSetOrder(5))
		If ADL->(dbSeek(xFilial("ADL")+M->ADL_VEND+M->ADL_ENTIDA+M->ADL_CODENT+M->ADL_LOJENT))
			lRet := .F.
			APMsgStop("Já existe registro com esta chave na tabela ADL, Vendedor+Entidade+Cod_Entidade+Loja_Entidade. Verifique!")
		Endif	
	    
		If lRet
			// valida se jah existe esta mesma chave na tabela AO4
			CRM01Usu(@cUsuarioNew,.T.)
			AO4->(dbSetOrder(1))
			If AO4->(dbSeek(xFilial("AO4")+M->ADL_ENTIDA+Padr(M->ADL_CODENT+M->ADL_LOJENT,TamSX3("AO4_CHVREG")[1])+cUsuarioNew))
				lRet := .F.
				APMsgStop("Já existe registro com esta chave na tabela AO4, Vendedor+Entidade+Cod_Entidade+Loja_Entidade. Verifique!")
			Endif	
		Endif
	Endif
	
	// verifica se registro foi usado na tabela AO5
	// obs: para esta verificacao, tem que usar os campos da tabela ADL antes da alteracao, nao pode pegar as variaveis M->
	If lRet
		AO4->(dbSetOrder(1))
		If AO4->(dbSeek(cChave))
			cQ := "SELECT 1 "
			cQ += "FROM "+RetSqlName("AO5")+" AO5 "
			cQ += "WHERE AO5_FILIAL = '"+xFilial("AO5")+"' "
			cQ += "AND AO5_IDESTN = '"+AO4->AO4_IDESTN+"' "
			cQ += "AND AO5_NVESTN = '"+Alltrim(Str(AO4->AO4_NVESTN))+"' "
			cQ += "AND AO5_ENTANE = '"+AO4->AO4_ENTIDA+"' "
			cQ += "AND AO5_CODANE = '"+Subs(AO4->AO4_CHVREG,1,TamSX3("AO5_CODANE")[1])+"' "
			cQ += "AND AO5.D_E_L_E_T_ = ' ' "
			
			cQ := ChangeQuery(cQ)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			
			If (cAliasTrb)->(!Eof())
				lRet := .F.
				APMsgStop("Este registro não pode ser alterado/excluído pois está associado a uma ESTRUTURA DE NEGÓCIOS")
			Endif
			
			(cAliasTrb)->(dbCloseArea())
		Endif
	Endif			
Endif
			
aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// troca consulta generica F3 em funcao do campo ADL_CODENT
User Function CRM01F3(lEntidade) 

Local lRet := .T.

Default lEntidade := .T.

If IIf(lEntidade,&__ReadVar,ADL->ADL_ENTIDA) == "SA1" // Cliente
	aTrocaF3 := {}
Elseif IIf(lEntidade,&__ReadVar,ADL->ADL_ENTIDA) == "SUS" // Prospect
	aTrocaF3 := {{"ADL_CODENT","SUS"}}
EndIf

If lEntidade
	M->ADL_CODENT := CriaVar("ADL_CODENT")
	M->ADL_LOJENT := CriaVar("ADL_LOJENT")
Endif
	
Return(lRet)			


User Function CRM01Ent()

Local cString := M->ADL_ENTIDA //IIf(M->ADL_ENTIDA == "1","SA1",IIf(M->ADL_ENTIDA == "2","SUS",""))
Local lRet := .F.
Local aCampo := IIf(M->ADL_ENTIDA == "SA1",{"A1_NOME","A1_CGC"},IIf(M->ADL_ENTIDA == "SUS",{"US_NOME","US_CGC"},{"",""}))//IIf(M->ADL_ENTIDA == "1",{"A1_NOME","A1_CGC"},IIf(M->ADL_ENTIDA == "2",{"US_NOME","US_CGC"},{"",""}))
Local aCampoRet := {}

// deixa sair do campo quando estiver em branco
If Empty(&__ReadVar)
  	M->ADL_NOME := CriaVar("ADL_NOME")
   	M->ADL_CGC := CriaVar("ADL_CGC")

	Return(.T.)
Endif
	
If !Empty(cString)// .and. !Empty(M->ADL_CODENT)
	If __ReadVar == "M->ADL_CODENT"
		lRet := ExistCpo(cString,&__ReadVar+IIf(!Empty(M->ADL_LOJENT),M->ADL_LOJENT,""))
	Endif
	If __ReadVar == "M->ADL_LOJENT"
		lRet := ExistCpo(cString,M->ADL_CODENT+&__ReadVar)
	Endif
	
	// preenche demais campos da tela
	If lRet
		If __ReadVar == "M->ADL_CODENT"
			aCampoRet := GetAdvFVal(cString,{aCampo[1],aCampo[2]},xFilial(cString)+&__ReadVar+IIf(!Empty(M->ADL_LOJENT),M->ADL_LOJENT,""),1,{"",""})
       	Endif
		If __ReadVar == "M->ADL_LOJENT"
			aCampoRet := GetAdvFVal(cString,{aCampo[1],aCampo[2]},xFilial(cString)+M->ADL_CODENT+&__ReadVar,1,{"",""})
       	Endif
       	M->ADL_NOME := aCampoRet[1]
       	M->ADL_CGC := aCampoRet[2]
	Endif
	
Endif
	
Return(lRet)			


// inclui registro na tabela AO4
Static Function CRM01IO4()

Local aArea := {AO4->(GetArea()),GetArea()}
Local cUsuario := ""
	
CRM01Usu(@cUsuario)
AO4->(dbSetOrder(1))
If AO4->(!dbSeek(xFilial("AO4")+ADL->ADL_ENTIDA+Padr(ADL->ADL_CODENT+ADL->ADL_LOJENT,TamSX3("AO4_CHVREG")[1])+cUsuario))
	AO4->(RecLock("AO4",.T.))
	AO4->AO4_FILIAL := xFilial("AO4")
	AO4->AO4_ENTIDA := ADL->ADL_ENTIDA
	AO4->AO4_CHVREG := ADL->ADL_CODENT+ADL->ADL_LOJENT
	AO4->AO4_CODUSR := cUsuario
	AO4->AO4_CTRLTT := .T.           
	AO4->AO4_PERVIS := .F.
	AO4->AO4_PEREDT := .F.
	AO4->AO4_PEREXC := .F.
	AO4->AO4_PERCOM := .F.
	AO4->AO4_TPACES := "1"
	AO4->AO4_PRIORI := "0"	
	AO4->(MsUnLock())
Endif

aEval(aArea,{|x| RestArea(x)})

Return()


// exclui registro na tabela AO4
Static Function CRM01EO4(cChave)

AO4->(dbSetOrder(1))
If AO4->(dbSeek(cChave))
	AO4->(RecLock("AO4",.F.))
	AO4->(dbDelete())
	AO4->(MsUnLock())
Endif

Return()


Static Function CRM01Usu(cUsuario,lNewUser)

Default lNewUser := .F.

If !lNewUser
	cUsuario := Posicione("AO3",2,xFilial("AO3")+ADL->ADL_VEND,"AO3_CODUSR")
Else
	cUsuario := Posicione("AO3",2,xFilial("AO3")+M->ADL_VEND,"AO3_CODUSR")
Endif	
If Empty(cUsuario)
	cUsuario := Space(TamSX3("AO3_CODUSR")[1])
Endif	

Return()