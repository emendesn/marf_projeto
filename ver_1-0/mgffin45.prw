#Include "Protheus.ch"

//
//
User Function MGFFIN45()

	Local cFilRec	:= Space(TamSX3("E1_FILIAL")[1])
	Local cNumTit	:= Space(TamSX3("E1_NUM")[1])
	Local cParTit	:= Space(TamSX3("E1_PARCELA")[1])

	Local aRet		:= {}
	Local cQuery, nI
	Local aArea
	local lContinua	:= .T.
	Local cAlias	:= GetNextAlias()

	Local oModel	:= FwModelActive()
	Local oMdlZA7	:= oModel:GetModel("ZA7MASTER")
	Local oMdlZA8	:= oModel:GetModel("ZA8GRID")
	Local nLinha	:= oMdlZA8:Length()

	Local nI, lNumTit

	Local aPergs	:= {}

	Local cVldMot	:= 'ExistCpo("SX5","'+cRecMan+'"+aRet[3])'

	Local aSaveLines

	Private cMotRec	:= Space(TamSX3("ZA8_MOTREC")[1])

	If oMdlZA7:GetValue("ZA7_TIPO") <> "2"
		Aviso("FIDC - Seleção Recompra Manual","Opção restrita para processos de recompra!",{"Ok"})
		Return
	EndIf

	aArea	:= GetArea()





















	aPergs := {}

	aAdd( aPergs ,{1,"Filial do Título ",cFilRec,"@!",".T."	,"SM0",".T.",30, .T. })
	aAdd( aPergs ,{1,"Número do Título ",cNumTit,"@!",".T."	,,".T.",50, .T. })
	aAdd( aPergs ,{1,"Parcela do Título ",cParTit,"@!",".T."	,,".T.",30, .F. })
	aAdd( aPergs ,{1,"Motivo da Recompra ",cMotRec,"@!",'ExistCpo("SX5","'+cRecMan+'"+mv_par04)',cRecMan,".T.",50, .T. })


	If !ParamBox(aPergs ,"Parametros FIDC - Recompra Manual",aRet)
		Aviso("FIDC - Seleção Recompra Manual","Processamento Cancelado!",{"Ok"})
		lContinua	:= .F.
	Else
		lNumTit := .F.

		aSaveLine  := FWSaveRows()

		For nI := 1 to oMdlZA8:Length()
			oMdlZA8:GoLine(nI)
			If aRet[1] == oMdlZA8:GetValue("ZA8_FILORI") .And.  aRet[2] == oMdlZA8:GetValue("ZA8_NUM") .And.  aRet[3] == oMdlZA8:GetValue("ZA8_PARCEL")
				Aviso("FIDC - Seleção Recompra Manual","Filial/Título/Parcela já pertence a esta recompra!",{"Ok"})
				lNumTit := .T.
				Exit
			EndIf
		next

		FWRestRows( aSaveLine )

		If !lNumTit





































			__execSql(cAlias," SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, E1_VALOR, ZA8_CODREM FROM  "+RetSqlName('SE1')+" SE1 INNER JOIN  "+RetSqlName('ZA8')+" ZA8 ON ZA8.D_E_L_E_T_= ' ' AND ZA8_FILORI = E1_FILIAL AND ZA8_PREFIX = E1_PREFIXO AND ZA8_NUM = E1_NUM AND ZA8_PARCEL = E1_PARCELA AND ZA8_TIPO = E1_TIPO AND ZA8_STATUS IN ('1','2') AND ZA8_RECOMP NOT IN ('1','2') AND SUBSTR(ZA8_FILIAL,1,2) =  "+___SQLGetValue(SUBS(CFILANT,1,2))+" INNER JOIN  "+RetSqlName('ZA7')+" ZA7 ON ZA7.D_E_L_E_T_= ' ' AND ZA7_FILIAL = ZA8_FILIAL AND ZA7_CODREM = ZA8_CODREM AND ZA7_STATUS IN ('1','2') AND ZA7_TIPO = '1' AND ZA7_DATA <> '        ' AND SUBSTR(ZA7_FILIAL,1,2) =  "+___SQLGetValue(SUBS(CFILANT,1,2))+" WHERE SE1.D_E_L_E_T_= ' ' AND E1_FILIAL =  "+___SQLGetValue(ARET[1])+" AND E1_NUM =  "+___SQLGetValue(ARET[2])+" AND E1_PARCELA =  "+___SQLGetValue(ARET[3])+" AND E1_SITUACA = '1' AND E1_IDCNAB <> ''",{},.F.)

			aQuery := GetLastQuery()

			MemoWrit( "C:\TEMP\"+FunName()+"-RecMan-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )




			If Empty( (cAlias)->E1_NUM )
				Aviso("FIDC - Seleção Recompra Manual","Filial/Título/Parcela não encontrado!",{"Ok"})
			Else
				oMdlZA8:SetNoInsertLine( .F. )
				While !(cAlias)->(EOF())

					cMotRec := aRet[4]

					oMdlZA8:GoLine(nLinha)

					If !Empty( oMdlZA8:GetValue("ZA8_NUM") )
						nLinha++

						oMdlZA8:AddLine()
						oMdlZA8:GoLine( nLinha )
					EndIf

					oMdlZA8:SetValue("ZA8_STATUS"	, "1"							)
					oMdlZA8:SetValue("ZA8_PREFIX"	, (cAlias)->E1_PREFIXO			)
					oMdlZA8:SetValue("ZA8_NUM"		, (cAlias)->E1_NUM				)
					oMdlZA8:SetValue("ZA8_PARCEL"	, (cAlias)->E1_PARCELA			)
					oMdlZA8:SetValue("ZA8_TIPO"		, (cAlias)->E1_TIPO				)
					oMdlZA8:SetValue("ZA8_VENCRE"	, STOD((cAlias)->E1_VENCREA)	)
					oMdlZA8:SetValue("ZA8_VALOR"	, (cAlias)->E1_VALOR			)
					oMdlZA8:SetValue("ZA8_BANCO"	, (cAlias)->E1_PORTADO			)
					oMdlZA8:SetValue("ZA8_AGENCI"	, (cAlias)->E1_AGEDEP			)
					oMdlZA8:SetValue("ZA8_CONTA"	, (cAlias)->E1_CONTA			)
					oMdlZA8:SetValue("ZA8_NUMBOR"	, (cAlias)->ZA8_CODREM			)
					oMdlZA8:SetValue("ZA8_DATBOR"	, STOD((cAlias)->E1_DATABOR)	)
					oMdlZA8:SetValue("ZA8_MOTREC"	, cMotRec						)
					oMdlZA8:SetValue("ZA8_FILORI"	, (cAlias)->E1_FILIAL			)
					(cAlias)->( dbSkip() )
				EndDo

				oMdlZA8:SetNoInsertLine( .T. )
			Endif
			dbSelectArea(cAlias)
			dbCloseArea()

		EndIf
	EndIf






Return

User Function MGFFI45V()

	Local lRet := .T.

Return lRet
