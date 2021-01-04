#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT93
Autor...............: Totvs
Data................: Agosto/2018 
Descricao / Objetivo: Rotina chamada pelo PE MA410MNU
Doc. Origem.........: OMS
Solicitante.........: Cliente
Uso.................: 
Obs.................: Forcar reenvio da nota de saida ao Taura
=====================================================================================
*/
User Function MGFFAT93()

Local aArea := {SC6->(GetArea()),SF2->(GetArea()),GetArea()}
Local cChave := ""
Local cGrupoPar := GetMv("MGF_INTNF")
Local aGrupo := UsrRetGrp(UsrRetName(RetCodUsr())) //Carrega Grupos do usuario
//Local cGrupoUsu := ""
Local nCnt := 0
Local lContinua := .F.
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local lGravou := .F.

/*
For nCnt:=1 to Len(aGrupo)
	cGrupoUsu += "'"+aGrupo[nCnt]+"',"
Next
If !Empty(cGrupoUsu)
	cGrupoUsu := Subs(cGrupoUsu,1,Len(cGrupoUsu)-1)
Endif
*/
// verifica se grupo do usuario estah contido nos grupos do parametro da Marfrig
For nCnt:=1 To Len(aGrupo)
	If Alltrim(aGrupo[nCnt]) $ Alltrim(cGrupoPar)
		lContinua := .T.
		Exit
	Endif
Next

If lContinua		
	If "XXX" $ Alltrim(SC5->C5_NOTA) // residuo
		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->(!Eof()) .and. xFilial("SC6")+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
				If !Empty(SC6->C6_NOTA) .and. !"XXX" $ Alltrim(SC6->C6_NOTA)
					cChave := SC5->C5_FILIAL+SC6->C6_NOTA+SC6->C6_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI
					Exit // sai porque na marfrig nao tem pedido que integra com o taura faturado em mais de 1 nota
				Endif
				SC6->(dbSkip())
			Enddo
		Endif
	Else	
		If !Empty(SC5->C5_NOTA)
			cChave := SC5->C5_FILIAL+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI
		Endif	
	Endif				
	
	If Empty(cChave)
		APMsgAlert("Pedido nao esta faturado.")
	Else	
		cQ := "SELECT R_E_C_N_O_ SF2_RECNO "
		cQ += "FROM "+RetSqlName("SF2")+" SF2 "
		cQ += "WHERE F2_FILIAL || F2_DOC || F2_SERIE || F2_CLIENTE || F2_LOJA = '"+cChave+"' "
		//cQ += "AND SF2.D_E_L_E_T_ = ' ' " // OBS: ler tamb�m registros deletados, pois as notas deletadas tambem devem ser reenviadas ao taura
							
		cQ := ChangeQuery(cQ)
							
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasTrb, .F., .T.)
		
		If (cAliasTrb)->(!Eof())
			While (cAliasTrb)->(!Eof())
				SF2->(dbGoto((cAliasTrb)->SF2_RECNO))
				If SF2->(Recno()) == (cAliasTrb)->SF2_RECNO
					SF2->(RecLock("SF2",.F.))
					SF2->F2_ZTAUREE := "S"
					SF2->(MsUnLock())
					lGravou := .T.
				Endif
				(cAliasTrb)->(dbSkip())
			Enddo		
			If lGravou
				APMsgInfo("Campo 'F2_ZTAUREE' gravado com sucesso com conteudo 'S'.")
			Endif	
		Else
			APMsgAlert("Nao foi possivel encontrar a nota de saida."+CRLF+;
			"Chave: "+cChave)
		Endif
		(cAliasTrb)->(dbCloseArea())
	Endif		
Else
	APMsgAlert("Grupo de acesso do usuario nao esta cadastrado no parametro 'MGF_INTNF'"+CRLF+;
	"Nao sera permitido acessar a rotina.")
Endif	
	
aEval(aArea,{|x| RestArea(x)})	

Return()