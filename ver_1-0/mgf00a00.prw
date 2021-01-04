#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
 
/*/
�������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � MGF00A00 �Autor  �Geronimo Benedito Alves                                        �Data �23/11/17 ���                  `
���������������������������������������������������������������������������������������������������������������͹��
���Desc.    �Este programa contem varias funcoes genericas e reutlizaveis para os relatorios solicitados por BI	���
���������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods                                                                              ���
���������������������������������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������  /*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �convData  �Autor  �Geronimo B Alves    � Data �  29/11/17	  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Recebe caracteres no formato data cientifica "20171231"   ���
���          �  e retorna como caracter ou data no formato "31/12/2017"	  ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function convData(cData,cTipoRetorno)
	Local xDataRet := ""

	If !empty(cData)
		If cTipoRetorno == "C"
			If Valtype(cData) == "C"
				xDataRet := Subs(cData,7,2)  +"/" + Subs(cData,5,2)  +"/" + Subs(cData,1,4)
			ElseIF Valtype(cData) == "D"
				xDataRet := Dtoc(cData)
			Else 
				xDataRet := " "
			Endif
		ElseIf cTipoRetorno == "D"
			If Valtype(cData) == "C"
				xDataRet := Stod(cData)
			ElseIF Valtype(cData) == "D"
				xDataRet := cData
			Else 
				xDataRet := " "
			Endif
		Endif 
	Endif

Return xDataRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Array_In  �Autor  �Geronimo B Alves 	 � Data �  29/11/17	  ���
�������������������������������������������������������������������������͹��
���Desc.	� Recebe array de elementos e os retorna em formato caracter, ���
���			� pronto para ser usada na clausula in do SQL				  ���
���			� Comentado o uso do comando AllTrim para tirar os espacos    ���
���			� em branco de todos os elementos, pois no Oracle o tamanho tem que ser exato ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Array_In(_aSelFil)
	Local cArray_In := ""
	Local _nI		:= 0 

	For _nI := 1 to len(_aSelFil)
		_aSelFil[_ni] := StrTran(_aSelFil[_ni],"'","")  					// Retiro as aspas simples, para evitar erros na query 
	Next

	If ! empty(_aSelFil)
		cArray_In := " ( " 
		For _nI := 1 to len(_aSelFil)
			cArray_In += "'" + _aSelFil[_nI] + "', "
		Next
		cArray_In := Subs(cArray_In,1, Len(cArray_In)-2) + " ) "
	Endif

Return cArray_In 

/*/
������������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � Traacpoq �Autor  �Geronimo Benedito Alves																	 �Data �19/03/18       ���
��������������������������������������������������������������������������������������������������������������������������������������������������͹��
���Descricao� Esta funcao ajusta cada elemento/campo do array _aCampoQry, de acordo com os atributos de campo da tabela SX3. O Relacionamento      ���
���			� com o registro equivalente no SX3 � efetuado pelo nome de campo indicado no elemento _nPoCpoX3                                       ���
���			� A regra de prevalencia do conteudo do elemento _aCampoQry ou do conteudo do SX3 segue as regas:                                      ���
���			� 01 O campo do elemento _nPoNome     existe no SX3. Nos elementos que     estejam vazios, usa as propriedades do campo no _aCampoQry. ���
���			� 02 O campo do elemento _nPoNome     existe no SX3. Nos elementos que Nao estejam vazios, Mant�m o conteudo do elemento na _aCampoQry.���
���			� 03 O campo do elemento _nPoNome Nao existe no SX3. Nos elementos que Nao estejam vazios, Mant�m o conteudo do elemento na _aCampoQry.���
���			� 04 O campo do elemento _nPoNome Nao existe no SX3. Nos elementos que     estejam vazios, Insere valores padr�es na _aCampoQry.       ���
���			�                                                                                                                                      ���
��������������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																											       ���
��������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������������  /*/

User Function Traacpoq()
	Local aArea			:= GetArea()
	Local aAreaSX3		:= SX3->( GetArea() )
	Local _nI	:= 0, _nJ := 0, _nX := 0
	//Local _aArrayPre	:= {.F.,.F.,.F.,.F.,.T.,.F.,.F.,.T.,.F.,.F. }		// Array de boleanos indicando quais elementos prevalecer�o sobre o SX3. No inicio do processo os elementos _nPoPreva, e _nPoCpoX3, que sao de controle interno, j� comecam com.T.
	Local _cNomeCpo	:= "" 
	
	Public _nPoCpoX3, _nPoNome, _nPoTitul, _nPoTipo, _nPoTaman, _nPoDecim, _nPoPictu, _nPoApeli, _nPoPicVar 	//,_nPoPreva
	//Public _lNewPosCp := .T.	// .T. == ndica que o relatorio em execucao usa a versao Nova do posicionamento dos campos da _aCampoQry 

	If Valtype(_aCampoQry) <> "A" .or. Len(_aCampoQry) == 0
		RestArea(aAreaSX3)
		RestArea(aArea)
		Return nil
	Endif

	Public CHKaCpoQry := ""

	// Versao atual do tratamento dos elementos do array _aCampoQry. 
	// 01 - Se o campo indicado no elemento _nPoNome     existir no SX3, usa as propriedades dele no _aCampoQry, para os elementos que     estejam vazios, 
	// 02 - Se o campo indicado no elemento _nPoNome     existir no SX3, mantem os conteudos da _aCampoQry,      para os elementos que Nao estejam vazios.
	// 03 - Se o campo indicado no elemento _nPoNome Nao existir no SX3, mantem os conteudos da _aCampoQry,      para os elementos que Nao estejam vazios.
	// 04 - Se o campo indicado no elemento _nPoNome Nao existir no SX3, insere valores padr�es na _aCampoQry,   para os elementos que     estejam vazios.

	_nPoCpoX3:=1; _nPoNome:=2; _nPoTitul:=3; _nPoTipo:=4; _nPoTaman:=5; _nPoDecim:=6; _nPoPictu:=7; _nPoApeli:=8; _nPoPicVar := 9 
	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 

	For _nI	:= 1 to len(_aCampoQry)

		_cNomCpQry	:= ""											// Retorna o nome real do campo na query (antes de ganhar o apelido criado pelo " as "
		_cNomeCpo	:= U_BNomeCpo(_nI, @_cNomCpQry, _aCampoQry)
		_aCampoQry[_ni, _nPoApeli]	:= _cNomeCpo					// Aqui trato para o elemento apelido do array, ficar com o apelido do campo.
		
		dbSelectArea("SX3")
		DbSetOrder(2)
		If SX3->(DbSeek(_aCampoQry[_nI,_nPoCpoX3],.F.))
			_aCampoQry[_ni, _nPoNome ]	:= IIF( Empty  (_aCampoQry[_ni, _nPoNome]  ), 		AllTrim(SX3->X3_CAMPO)		,_aCampoQry[_ni, _nPoNome]  ) 
			_aCampoQry[_ni, _nPoTitul]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTitul] ), 		AllTrim(SX3->X3_DESCRIC)	,_aCampoQry[_ni, _nPoTitul] )  
			_aCampoQry[_ni, _nPoTipo]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTipo]  ), 		AllTrim(SX3->X3_TIPO)		,_aCampoQry[_ni, _nPoTipo]  )
			_aCampoQry[_ni, _nPoTaman]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTaman] ), 		SX3->X3_TAMANHO			,_aCampoQry[_ni, _nPoTaman] )
			_aCampoQry[_ni, _nPoDecim]	:= IIF( ValType(_aCampoQry[_ni, _nPoDecim]) <> "N"	,SX3->X3_DECIMAL			,_aCampoQry[_ni, _nPoDecim] )
			_aCampoQry[_ni, _nPoPictu]	:= IIF( Empty  (_aCampoQry[_ni, _nPoPictu] ), 		AllTrim(SX3->X3_PICTURE)	,_aCampoQry[_ni, _nPoPictu] )
			_aCampoQry[_ni, _nPoApeli]	:= IIF( Empty  (_aCampoQry[_ni, _nPoApeli] ), 		AllTrim(SX3->X3_CAMPO)		,_aCampoQry[_ni, _nPoApeli] )
			_aCampoQry[_ni, _nPoPicVar]	:= IIF( Empty  (_aCampoQry[_ni, _nPoPicVar]), 		AllTrim(SX3->X3_PICTVAR)	,_aCampoQry[_ni, _nPoPicVar])

			// adiciono os novos elementos, necessarios para MsNewGetDados.
			AAdd(_aCampoQry[_ni] ,.T.  )		// Adiciono o Elemento 10 -> SX3->X3_VALID
			AAdd(_aCampoQry[_ni] , ""	)		// Adiciono o Elemento 11 -> SX3->X3_USADO
			AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 12 -> SX3->X3_F3
			AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 13 -> SX3->X3_CONTEXT
			// sx3->(aAdd( aHeaderEx,{x3_titulo,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL, x3_Valid, X3_USADO,X3_TIPO,x3_f3,X3_CONTEXT,X3_CBOX,x3_Relacao,x3_when,x3_visual,X3_VLDUSER,X3_PICTVAR})) 

		Else
		
			// Se o Titulo, Tipo, Tamanho e/ou o Decimal nao foi informado, e o campo nao foi encontrado no SX3, � assumido: "." ,"C" ,50 ,0.
			_aCampoQry[_ni, _nPoTitul]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTitul] ), 		"."	,_aCampoQry[_ni, _nPoTitul] )  
			_aCampoQry[_ni, _nPoTipo]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTipo]  ), 		"C"	,_aCampoQry[_ni, _nPoTipo]  )
			_aCampoQry[_ni, _nPoTaman]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTaman] ), 		50		,_aCampoQry[_ni, _nPoTaman] )
			_aCampoQry[_ni, _nPoDecim]	:= IIF( ValType(_aCampoQry[_ni, _nPoDecim]) <> "N"	,0		,_aCampoQry[_ni, _nPoDecim] )
		
			AAdd(_aCampoQry[_ni] ,.T.  )		// Adiciono o Elemento 10 -> SX3->X3_VALID
			AAdd(_aCampoQry[_ni] , ""	)		// Adiciono o Elemento 11 -> SX3->X3_USADO
			AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 12 -> SX3->X3_F3
			AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 13 -> SX3->X3_CONTEXT
		Endif
		
		// A Variavel abaixo � para ser usada nos logs e depura�oes, demosntrando o conteudo da array _aCampoQry 
		CHKaCpoQry	+= Strzero(_ni,3) +" " + Padr(_aCampoQry[_ni, _nPoCpoX3 ] ,10) +" "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoNome] )  <> "C", Space(35) , Padr(_aCampoQry[_ni, _nPoNome] ,35)  ) + " " 
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoTitul] ) <> "C", Space(30) , Padr(_aCampoQry[_ni, _nPoTitul],30)  ) + " " 
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoTipo]  ) <> "C", Space(01) ,      _aCampoQry[_ni, _nPoTipo]       ) + " "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoTaman] ) <> "N", Space(04) , str (_aCampoQry[_ni, _nPoTaman],4,0) ) + " "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoDecim] ) <> "N", Space(02) , Str (_aCampoQry[_ni, _nPoDecim],2,0) ) + " "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoPictu] ) <> "C", Space(45) , Padr(_aCampoQry[_ni, _nPoPictu],45)  ) + " "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoApeli] ) <> "C", Space(10) , Padr(_aCampoQry[_ni, _nPoApeli],10)  ) + " "
		CHKaCpoQry	+= IIF(ValType(_aCampoQry[_ni, _nPoPicVar]) <> "C", Space(04) , Padr(_aCampoQry[_ni, _nPoPicVar],20) ) + CRLF
		
	Next
	
	/*/		///Comentado todo o trecho entre o Else e o Endif. Refere-se a regra antiga de tratamento da array _aCampoQry de acordo com o SX3 (ou nao).
			///			
	Else	///Indica que o relatorio em execucao usa a versao ANTIGA  do posicionamento dos campos da _aCampoQry
			///Versao ANTIGA da posicao dos elementos do array _aCampoQry. Se o campo indicado no elemento _nPoCpoX3 existir no SX3, usa as propriedades dele no _aCampoQry.
			///Se o campo indicado no elemento _nPoNome NAO existir no SX3, os conteudos anteriores de todos elementos do _aCampoQry sao preservados. 
		_nPoNome:=1; _nPoTitul:=2; _nPoTaman:=3; _nPoTipo:=4; _nPoPreva:=5; _nPoPictu:=6; _nPoDecim:=7; _nPoApeli:=8; _nPoCpoX3:=9; _nPoPicVar := 10

		For _nI	:= 1 to len(_aCampoQry)
			IF Valtype(_aCampoQry[_ni, _nPoPreva]) == "A" .AND. Valtype(_aCampoQry[_ni, _nPoPreva ,1]) == "N"
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoNome ) <> 0
					_aArrayPre[_nPoNome]	:=.T.
				EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoTitul ) <> 0
					_aArrayPre[_nPoTitul]	:=.T.
				EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoTaman ) <> 0
					_aArrayPre[_nPoTaman]	:=.T.
				EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoTipo ) <> 0
					_aArrayPre[_nPoTipo]	:=.T.
				EndIf
				//If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoPreva ) <> 0
				//	_aArrayPre[_nPoPreva]	:=.T.
				//EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoPictu ) <> 0
					_aArrayPre[_nPoPictu]	:=.T.
				EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoDecim ) <> 0
					_aArrayPre[_nPoDecim]	:=.T.
				EndIf
				If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoApeli ) <> 0
					_aArrayPre[_nPoApeli]	:=.T.
				EndIf
				//If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoCpoX3 ) <> 0
				//	_aArrayPre[_nPoCpoX3]	:=.T.
				//EndIf
	
				If Len(_aCampoQry[_ni]) > 9
					If aScan( _aCampoQry[_ni, _nPoPreva] , _nPoPicVar ) <> 0
						_aArrayPre[_nPoPicVar]	:=.T.
					EndIf
				EndIf
	
			Else
				_aArrayPre	:= {.T.,.T.,.F.,.F.,.T.,.F.,.F.,.T.,.T.,.F.}		//	Padrao: Se nao for indicado, quais elementos do _aCampoQry prevalecer�o sobre o SX3, o Default, sera que o os elementos_nPoNome,_nPoTitul,_nPoPreva,_nPoApeli e _nPoCpoX3 (""Nome do campo", "titulo" , "Array prevalece sobre SX3", "apelido do Campo" e "Nome do campo no SX3") prevalecer�o. 
			Endif
	
			_cNomCpQry	:= ""		// Retorna o nome real do campo na query. (antes de ganhar o apelido criado pelo " as " )
			_cNomeCpo	:= U_BNomeCpo(_nI, @_cNomCpQry, _aCampoQry)
			_aCampoQry[_ni, _nPoApeli]	:= _cNomeCpo		// Aqui trato para o elemento _nPoApeli ficar com o apelido do campo.
			
			dbSelectArea("SX3")
			DbSetOrder(2)
			If SX3->(DbSeek(_aCampoQry[_nI,_nPoCpoX3],.F.))
				_aCampoQry[_ni, _nPoNome ]	:= IIF(_aArrayPre[_nPoNome  ], _aCampoQry[_ni, _nPoNome  ], AllTrim(SX3->X3_CAMPO) ) 
				_aCampoQry[_ni, _nPoTitul]	:= IIF(_aArrayPre[_nPoTitul ], _aCampoQry[_ni, _nPoTitul ], AllTrim(SX3->X3_TITULO) )  
				_aCampoQry[_ni, _nPoTaman]	:= IIF(_aArrayPre[_nPoTaman ], _aCampoQry[_ni, _nPoTaman ], SX3->X3_TAMANHO )
				_aCampoQry[_ni, _nPoTipo]	:= IIF(_aArrayPre[_nPoTipo  ], _aCampoQry[_ni, _nPoTipo  ], SX3->X3_TIPO )
				_aCampoQry[_ni, _nPoPictu]	:= IIF(_aArrayPre[_nPoPictu ], _aCampoQry[_ni, _nPoPictu ], AllTrim(SX3->X3_PICTURE) )
				_aCampoQry[_ni, _nPoDecim]	:= IIF(_aArrayPre[_nPoDecim ], _aCampoQry[_ni, _nPoDecim ], SX3->X3_DECIMAL )
				_aCampoQry[_ni, _nPoApeli]	:= IIF(_aArrayPre[_nPoApeli ], _aCampoQry[_ni, _nPoApeli ], AllTrim(SX3->X3_CAMPO) )
				If Len(_aCampoQry[_ni]) > 9
					_aCampoQry[_ni, _nPoPicVar]	:= IIF(_aArrayPre[_nPoPicVar], _aCampoQry[_ni, _nPoPicVar], AllTrim(SX3->X3_PICTVAR) )
				Else
					AAdd(_aCampoQry[_ni] , ""  )	// Adiciono o Elemento 10 -> SX3->X3_PICTVAR 
				Endif
	
				// adiciono os novos elementos, necessarios para MsNewGetDados.
				AAdd(_aCampoQry[_ni] ,.T.  )		// Adiciono o Elemento 11 -> SX3->X3_VALID 
				AAdd(_aCampoQry[_ni] , ""	)		// Adiciono o Elemento 12 -> SX3->X3_USADO 
				AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 13 -> SX3->X3_F3 
				AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 14 -> SX3->X3_CONTEXT
	
				// sx3->(aAdd( aHeaderEx,{x3_titulo,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; 
				// x3_Valid, X3_USADO,X3_TIPO,x3_f3,X3_CONTEXT,X3_CBOX,x3_Relacao,x3_when,x3_visual,X3_VLDUSER,X3_PICTVAR})) 
	
			Else
				// Se campo nao existe no SX3, preservo o _aCampoQry, e adiciono os novos elementos, necessarios para MsNewGetDados.
				If Len(_aCampoQry[_ni]) > 9
					_aCampoQry[_ni, _nPoPicVar]	:= IIF(_aArrayPre[_nPoPicVar], _aCampoQry[_ni, _nPoPicVar], AllTrim(SX3->X3_PICTVAR) )
				Else
					AAdd(_aCampoQry[_ni] , ""  )	// Adiciono o Elemento _nPoPicVar -> SX3->X3_PICTVAR 
				Endif
	
				AAdd(_aCampoQry[_ni] ,.T.  )		// Adiciono o Elemento 11 -> SX3->X3_VALID 
				AAdd(_aCampoQry[_ni] , ""	)		// Adiciono o Elemento 12 -> SX3->X3_USADO 
				AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 13 -> SX3->X3_F3 
				AAdd(_aCampoQry[_ni] , "  " )		// Adiciono o Elemento 14 -> SX3->X3_CONTEXT 
			Endif
		Next
	Endif 
	/*/

	RestArea(aAreaSX3)
	RestArea(aArea)
Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CpoExcel �Autor  �Geronimo Benedito Alves � Data� 06/12/17 ���
�������������������������������������������������������������������������͹��
���Desc.	 � Retorna Array com o(s) code block(s) contendo o(s)		  ���
���			 � comando(s) a ser(em) executado(s) para adicionar uma linha ���
���			 � �(s) aba(s) da planilha excel							  ���
�������������������������������������������������������������������������͹��
���Uso		 � AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CpoExcel(  )
	Local _nPosi_Aba	:= 1 
	Local _cCpoExcel	:= ""
	Local _bCpoExce		:= {|| }
	Local _aCpoExce		:= { }
	Local cNomeCampo	:= ""
	Local _nCampoQry	:= 2
	Local _aCampoAba	:= {}		// Campos que serao contidos em cada Aba

	For	_nPosi_Aba := 1 to len(_aDefinePl[3])
		_bCpoExce		:= {|| }
		_cCpoExcel	:= "_oExcel:AddRow( '" + Alltrim( _aDefinePl[3,_nPosi_Aba]) + "' , '"  + Alltrim(_aDefinePl[4,_nPosi_Aba]) + "'  , { "

		If Empty(_aDefinePl[5])
			_aCampoAba := AClone(_aCampoQry)
		 Else
			If Empty(_aDefinePl[5,_nPosi_Aba])				
				_aCampoAba := AClone(_aCampoQry)
			Else
				_aCampoAba := AClone( _aDefinePl[5, _nPosi_Aba ] )		// Cada Aba, deve ter seu array de campos, nem que seja {} vazio. Neste caso sera incluida todas as colunas
			Endif 
		 Endif

		cNomeCampo	:=_aCampoAba[1,_nPoApeli]

		If _aCampoAba[ 1, _nPoTipo] == "D"
			_cCpoExcel += '  U_ConvData(' + cNomeCampo + ' ,"D") '
		ElseIf _aCampoAba[ 1, _nPoTipo] == "N"
			_cCpoExcel += '  ' + cNomeCampo	
		ElseIf _aCampoAba[ 1, _nPoTipo] == "C"
			If Empty(_aCampoAba[1,_nPoPictu]) .or. _aCampoAba[1,_nPoTaman] > 512	// Se campo for caracter e sem picture, levo o campo (Sem a picture).  Se for maior que 0,5 Kb de caracteres tambem levo sem a picture, por performance
															
				If .T.						//FunName() $ "U_MGF02R01,U_MGF02R03,U_MGF06R12,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01"					//If (FunName() $ "U_MGF02R03,U_MGF06R12" .and. cNomeCampo $ "OBSERVACAO_SC,OBSERVACAO_PEDIDO,OBERVACAO_PRODUTO,OBS_AUDIT" ) .or. (FunName() $ "U_MGF34R07,U_MGF34R17,U_MGF34R18")
					_cCpoExcel += ' U_BINoAcen(' + cNomeCampo + ') '
				Else
					_cCpoExcel += '  ' + cNomeCampo
				Endif
			Else		// Se campo tiver picture, aplico a picture atravez da funcao Transform(). Tiro a acentua��o atravez da funcao U_BINoAcen(). 
						// Para campos vazios, (Empty(cNomeCampo) ) , nao preciso fazer taramento algum.
				If .T.						//FunName() $ "U_MGF02R01,U_MGF02R03,U_MGF06R12,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01"
					_cCpoExcel += ' If( Empty(' + cNomeCampo + '),' + cNomeCampo +', Transform(U_BINoAcen(' + cNomeCampo + ') , "' + _aCampoQry[ 1, _nPoPictu] + '" ) ) '
				Else
					_cCpoExcel += ' If( Empty(' + cNomeCampo + '),' + cNomeCampo +', Transform(' + cNomeCampo + ' , "' + _aCampoQry[ 1, _nPoPictu] + '" ) ) '
				Endif
			Endif
		Else
			_cCpoExcel += '  ' +  cNomeCampo 		// Para _aCampoQry[ _nI, 4] == "C" ou outros tipos de dados
		Endif
		For _nCampoQry := 2 to len(_aCampoAba)						// Leio a partir do segundo campo, pois o primeiro ja foi adicionado na linha acima
			cNomeCampo	:= _aCampoAba[_nCampoQry,_nPoApeli]
			If _aCampoAba[ _nCampoQry, _nPoTipo] == "D"
				_cCpoExcel += ',  U_ConvData(' + cNomeCampo + ' ,"D") '

			ElseIf _aCampoAba[ _nCampoQry, _nPoTipo] == "N"
				_cCpoExcel += ',  ' + cNomeCampo

			ElseIf _aCampoAba[ _nCampoQry, _nPoTipo] == "C"
				If Empty(_aCampoAba[_nCampoQry,_nPoPictu]) .or. _aCampoAba[1,_nPoTaman] > 512	// Se campo for caracter e sem picture, levo o campo (Sem a picture).  Se for maior que 0,5 Kb de caracteres tambem levo sem a picture, por performance
					
					If .T.					//FunName() $ "U_MGF02R01,U_MGF02R03,U_MGF06R12,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01"			//If (FunName() $ "U_MGF02R03,U_MGF06R12" .and. cNomeCampo $ "OBSERVACAO_SC,OBSERVACAO_PEDIDO,OBERVACAO_PRODUTO,OBS_AUDIT" ) .or. (FunName() $ "U_MGF34R07,U_MGF34R17,U_MGF34R18")
						_cCpoExcel += ',  U_BINoAcen(' + cNomeCampo + ') '
					Else
						_cCpoExcel += ',  ' + cNomeCampo
					Endif
				Else		// Se campo tiver picture, aplico a picture atravez da funcao Transform(). Tiro a acentua��o atravez da funcao U_BINoAcen(). 
							// Para campos vazios, (Empty(cNomeCampo) ) , nao preciso fazer taramento algum.
							
					If .T.					//FunName() $ "U_MGF02R01,U_MGF02R03,U_MGF06R12,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01"				//If (FunName() $ "U_MGF02R03,U_MGF06R12" .and. cNomeCampo $ "OBSERVACAO_SC,OBSERVACAO_PEDIDO,OBERVACAO_PRODUTO,OBS_AUDIT" ) .or. (FunName() $ "U_MGF34R07,U_MGF34R17,U_MGF34R18")
						_cCpoExcel += ',If( Empty(' + cNomeCampo + '),' + cNomeCampo +', Transform(U_BINoAcen(' + cNomeCampo + ') , "' + _aCampoQry[ _nCampoQry, _nPoPictu] + '" ) ) '
					Else
						_cCpoExcel += ',If( Empty(' + cNomeCampo + '),' + cNomeCampo +', Transform(' + cNomeCampo + ' , "' + _aCampoQry[ _nCampoQry, _nPoPictu] + '" ) ) '
					Endif
				Endif	
			Else		// Para _aCampoQry[ _nI, 4] == "C" ou outros tipos de dados
				_cCpoExcel += ',  ' +  cNomeCampo 
			Endif
		Next
		_cCpoExcel += ' } ) '
		_bCpoExce := &("{ || " + _cCpoExcel + "}")
		Aadd(_aCpoExce, _bCpoExce )
	Next

	
Return _aCpoExce

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CpoQuery  �Autor  �Geronimo B Alves	� Data �  06/12/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Recebe array com os campos da rotina, e retorna a parte da ���
���			�query com o select e a lista dos campos a serem selecionados���
���			� j� devidamente formatado									���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CpoQuery()
	Local _nI		:= 2 
	Local _cQuery	:= " SELECT " + _aCampoQry[1,_nPoNome]	+CRLF
	For _nI := 2 to len(_aCampoQry)							// Leio a partir do segundo elemento, pois o primeiro ja foi adicionado na linha acima
		_cQuery += " ,  " + _aCampoQry[_nI,_nPoNome]	+CRLF
	Next
	_cQuery += " ,  ' ' as X " +CRLF	// Adiciona o campo X que foi ciado para ser o indice da tabela. A funcao FwmBrowse torna obrigatorio o uso de um indice na tabela.

Return _cQuery

/*
����������������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������ͻ��
���Programa  �QueryCpo  �Autor  � Geronimo B Alves	                        �  Data �  25/04/18  ���
������������������������������������������������������������������������������������������������͹��
���Desc.	� Recebe a Query, e retorna array com os campos do select                          	 ���
���			� Cada elemento da array retornar� com as informacoes:                         		 ���
���			� Nome do campo, Tipo, tamanho e decimal. Obtidas do SX3                         	 ���
������������������������������������������������������������������������������������������������͹��
���Parametro� _cQueryAux - Que a sera "Parseada"                                                 ���
���         � _lRetSemX3 - Se .F. Nao retorna campos nao encontrado no SX3  (Default)            ���
���         �    Se .T. RETORNA tambem os campos nao encontrado no SX3  (como caracter,234,0)    ���
������������������������������������������������������������������������������������������������͹��
���Uso		�                                                                                    ���
������������������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������������
*/
User Function QueryCpo(_cQueryAux, _lRetSemX3 )
	Local aArea			:= GetArea()
	Local _nI	:= _nJ	:= _nPos_Inic	:= _nPos_Fim := 0
	Local _cCampoQry	:= ""
	Local _aCampoQry	:= {}
	Local _aCampoAux	:= {}
	Default _lRetSemX3	:= .F.
	_cTipo		:= ""
	_nTAMANHO	:= 0
	_nDECIMAL	:= 0

	_cQueryAux	:= StrTran(_cQueryAux,"	"," ")  					// Substituo tabulacoes por espacos.
	_cQueryAux	:= Upper  (_cQueryAux)  							// Deixo tudo em maiusulo.
	_cQueryAux	:= StrTran(_cQueryAux, CRLF ," ")  					// Substituo CRLF (chr(13)+ chr(10) por espacos 
	_cQueryAux	:= StrTran(_cQueryAux,"  "," ")  					// Substituo 2 ou mais espacos por apenas um. 1� execucao
	_cQueryAux	:= StrTran(_cQueryAux,"  "," ")  					// Substituo 2 ou mais espacos por apenas um. 2� execucao. Preciso executar este comando 2 vezes para solucionar a ocorrencia de varios espa�os seguidos.
	_cQueryAux	:= StrTran(_cQueryAux," WHERE ", 	",WHERE ")		// Substituo WHERE		por ,WHERE 
	_cQueryAux	:= StrTran(_cQueryAux," ORDER BY "	,",ORDER BY ")	// Substituo ORDER BY 	por ,ORDER BY 
	_cQueryAux	:= StrTran(_cQueryAux," GROUP BY "	,",GROUP BY ")	// Substituo GROUP BY 	por ,GROUP BY
	 
	If "SELECT " $  _cQueryAux
		For _nI := 1 to Len(_cQueryAux)
			If Subs(_cQueryAux,_nI,7)== "SELECT "
				_nPos_Inic	:= _nI + 7
				For _nJ := _nPos_Inic to Len(_cQueryAux)
					If Subs(_cQueryAux,_nJ,6)== " FROM "
						_nPos_Fim	:= _nJ
						_cCampoQry	:= Subs(_cQueryAux, _nPos_Inic , ( _nPos_Fim - _nPos_Inic ) )
						_cCampoQry	:= StrTran( _cCampoQry , " " , "" )		// Retiro os espacos (se houver)
						_aCampoAux	:= StrToArray(_cCampoQry,",")
						Exit
					Endif
				Next 
			Endif
			If _nPos_Inic > 0							// Se ja achei, saio do loop para evitar processamento desnecessario.
				Exit
			Endif
		Next
	Endif

	dbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo

	For _nI := 1 to len(_aCampoAux)						// Tiro os espacos do nome do campo
		_aCampoAux[_nI]	:= AllTrim( _aCampoAux[_nI] )
	Next

	For _nI := 1 to len(_aCampoAux)
		//MsgStop("len(_aCampoAux) == " + str(len(_aCampoAux)) + "  _nI == " + Str(_nI)  )
		If DbSeek(	_aCampoAux[_nI])
			_cTipo		:= U_X3InfCpo(_aCampoAux[_nI], "TIPO") 
			_nTAMANHO	:= U_X3InfCpo(_aCampoAux[_nI], "TAMANHO") 
			_nDECIMAL	:= U_X3InfCpo(_aCampoAux[_nI], "DECIMAL") 

			AAdd(_aCampoQry, {	_aCampoAux[_nI]	,;		// Nome do campo
								_cTipo			,;		// Tipo do campo
								_nTAMANHO		,;		// Tamanho do campo
								_nDECIMAL		})		// Decimal do campo

		Else											// Se nao encontrar o campo no SX3, jogos valores Default nos elementos do array
			If _lRetSemX3
				AAdd(_aCampoQry, {	_aCampoAux[_nI]	,;	// Nome do campo
									"C"				,;	// Tipo do campo
									234				,;	// Tamanho do campo
									0				})	// Decimal do campo
				
			Endif
		Endif
	Next

	RestArea(aArea)
Return _aCampoQry

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �X3InfCpo  �Autor  �Geronimo B Alves	� Data �  25/04/18	���
�������������������������������������������������������������������������͹��
���Desc.		� recebe o nome do campo, e retorna o seu tipo:				���
���			� Caracter, Numerico, Data, Logico ou Memo					���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function X3InfCpo(cNomeCampo, Informacao)
	Local aArea			:= GetArea()
	Local aAreaSX3		:= SX3-> ( GetArea() )
	Local cRetorno		:= " "

	dbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	If DbSeek(cNomeCampo)
		If Informacao == "TITULO"
			cRetorno := SX3->X3_DESCRIC
		ElseIf Informacao == "CAMPO"
			cRetorno := SX3->X3_CAMPO
		ElseIf Informacao == "TIPO"
			cRetorno := SX3->X3_TIPO 
		ElseIf Informacao == "TAMANHO"
			cRetorno := SX3->X3_TAMANHO
		ElseIf Informacao == "DECIMAL"
			cRetorno := SX3->X3_DECIMAL
		ElseIf Informacao == "PICTURE"
			cRetorno := SX3->X3_PICTURE
		Endif
	Endif

	RestArea(aAreaSX3)
	RestArea(aArea)
Return cRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SeleEmp	�Autor  �Geronimo B Alves	� Data �  30/11/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Abre uma tela de markbrowse, mostrando as empresas que o	���
���			� usuario tem acesso para que ele marque quais serao			���
���			� processadas												���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SeleEmp()
	Local aArea			:= GetArea()
	Local aAreaSM0		:= SM0->( GetArea() )
	Local aEmpUsuari	:= {}
	Local _cTmp01		:= GetNextAlias()
	Local cTmp02		:= GetNextAlias()
	Local _nRecnoSM0	:= Recno()
	Local aList			:= {}
	Local nLinEncont	:= 0
	Local cUsuario		:= RetCodUsr()
	Local _cQuery		:= " "	+CRLF
	Local _nI			:= 0

	Private aEmpMarcad	:= {}

	_cQuery := " SELECT USR_ALLEMP FROM SYS_USR WHERE USR_ID = '" + cUsuario + "'  AND D_E_L_E_T_ = ' '  "	+CRLF
	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf
	dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),_cTmp01,.T.,.F.)
	dbSelectArea(_cTmp01)
	dbGoTop()

	If !eof()
		If cUsuario == "000000" .OR. (_cTmp01)->USR_ALLEMP = "1"		// Usuario eh administrador ou tem acesso a todas as empresas

			_cQuery := " SELECT DISTINCT M0_CODIGO  FROM  " + U_IF_BIMFR("PROTHEUS", "SYS_COMPANY"  ) + "  WHERE D_E_L_E_T_ = ' ' ORDER BY M0_CODIGO  "	+CRLF
			If Select(cTmp02) > 0
				dbSelectArea(cTmp02)
				dbCloseArea()
			EndIf
			dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),cTmp02,.T.,.F.)
			dbSelectArea(cTmp02)
			dbGoTop()
			While !eof()
				Aadd(aEmpUsuari , M0_CODIGO )
				DbSkip()
			Enddo

		Else

			_cQuery := " SELECT DISTINCT USR_GRPEMP FROM SYS_USR_FILIAL WHERE USR_ID = '" + cUsuario + "' AND D_E_L_E_T_ = ' '	"	+CRLF
			If Select(cTmp02) > 0
				dbSelectArea(cTmp02)
				dbCloseArea()
			EndIf
			dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),cTmp02,.T.,.F.)
			dbSelectArea(cTmp02)
			dbGoTop()
			While !eof()
				Aadd(aEmpUsuari , (cTmp02)->USR_GRPEMP )
				DbSkip()
			Enddo

		Endif

	Else
		Aadd(aEmpUsuari , SM0->M0_CODIGO )
	Endif										

	If !SeleEmp2(aEmpUsuari,@aList)
		//������������������������������������������������������������������������������Ŀ
		//� Se nao selecionado nenhuma empresa, abandona a rotina							�
		//��������������������������������������������������������������������������������
		DbGoto(_nRecnoSM0)
		RestArea(aAreaSM0)
		RestArea(aArea)
		Return
	Endif

	For _nI := 1 to len(aList)
		If aList[_Ni,1]
			Aadd(aEmpMarcad, aList[_Ni,2] )
		Endif
	Next

	DbGoto(_nRecnoSM0)
	RestArea(aAreaSM0)
	RestArea(aArea)
Return aEmpMarcad

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � USRFIVLD �Autor  �Geronimo B Alves	� Data �  23/11/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Valido se o usuario tem acesso � empresa e filial			���
���			�															���
�������������������������������������������������������������������������͹��
���Parametros� cCodUsr - characters, Codigo do usuario pesquisado			���
���			� (por default, vem o Codigo do usuario logado)				���
���			� cCodEmp - characters, Codigo da empresa / grupo de empresas���
���			� (por default, vem o Codigo da empresa / grupo atual)		���
���			� @param cCodFil, characters, Codigo da filial (por default, ���
���			� vem o Codigo da filial atual)							  ���
���			�															���
���			� exemplo u_zUsrFil("000001", "01", "02")					���
���			� exemplo u_zUsrFil("000001", "01", "0201")					���
�������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods										���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function USRFIVLD(cCodUsr, cCodEmp, cCodFil)
	Local lRet		:=.T.
	Local aUsuarios := FwSFAllUsers()	//AllUsers()
	Local aUsrAux	:= {}
	Local nPosFil	:= 0
	Default cCodUsr := RetCodUsr()
	Default cCodEmp := cEmpAnt
	Default cCodFil := cFilAnt
	//SELECT * FROM SYS_USR_FILIAL  ORDER BY USR_ID, USR_CODEMP, USR_FILIAL

	//Caso encontre o usuario
	If.F.		//nLinEnc > 0
		aUsrAux := aClone(aUsuarios[nLinEnc][2][6])

		//Agora procura pela empresa + filial nos acessos
		nPosFil := aScan(aUsrAux, {|x| x == cCodEmp + cCodFil })

		//Se encontrou a filial ou tem acesso a todas, o retorno sera verdadeiro
		If nPosFil > 0 .Or. "@" $ aUsrAux[1]
			lRet :=.T.
		EndIf
	EndIf

Return lRet


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao	� SeleEmp2  � Autor � Geronimo B Alves		 � Data � 30/11/17 ���
��������������������������������������������������������������������������Ĵ��
���Descri�ao � Seleciona as empresas a serem processadas                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function SeleEmp2(aEmpUsuari,aList)

	//������������������������������������������������������������������������Ŀ
	//� Declaracao de variaveis												�
	//��������������������������������������������������������������������������
	Local lExibe		:=.T.
	Local lReturn		:=.T.
	Local nI			:= 0
	Local cTitulo  	:= OemToAnsi("Selecione as empresas a serem processadas")
	Local nOpc			:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo  	:= {" ", "Codigo", "Empresa", " " }
	Local aTam		:= {10, 30, 200, 01 }
	Local oListBox
	Local oSay
	Local oDlg
	Local nListTam1	:= 250	//280	//590
	Local nListTam2	:= 170	//200	//220
	Local nI
	Local lChk		  

	//������������������������������������������������������������������������Ŀ
	//� Monta array aList							�
	//��������������������������������������������������������������������������
	aList := {}
	For ni := 1 to Len(aEmpUsuari)
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbSeek(aEmpUsuari[ni])
		Aadd( aList, {.F. , aEmpUsuari[ni], SM0->M0_NOME, " " } )
	Next

	//������������������������������������������������������������������������Ŀ
	//� Monta a tela de selecao dos arquivos a serem importados				�
	//��������������������������������������������������������������������������
	If Len(aList) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 035,070 OF oMainWnd
		@ 001,001 LISTBOX oListBox VAR cListBox Fields ;
		HEADER  aTitulo[1],;
		OemtoAnsi(aTitulo[2]),;
		OemtoAnsi(aTitulo[3]),;
		OemtoAnsi(aTitulo[4]) ;
		SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aList)
		oListBox:aColSizes := aTam
		oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo),;
		aList[oListBox:nAt,2],;
		aList[oListBox:nAt,3],;
		aList[oListBox:nAt,4]}}

		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aList, oListBox ) })		// Cria a associacao da tecla F4, � funcao MarcaTodF4()
		
		@ 200, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aList, oListBox )

		@ 200, 130 BUTTON	oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ) Message 'Inverter Selecao' Of oDlg	
		DEFINE SBUTTON oBtnCan	FROM 200,200 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnOk	FROM 200,230 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg	

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )					// Cancela a associacao da tecla F4, � funcao MarcaTodF4()

		If nOpc == 0
			aList := {}
		Endif
	Endif

	If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] ==.T.}) <= 0
		//Aviso("Inconsist�ncia", "Nao foi selecionada nenhuma empresa. Processamento nao sera efetuado",{"Ok"}	,,"Atencao:")
		lReturn :=.F.
	EndIf
Return(lReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	�MARCATODOS�Autor  � Ernani Forastieri  � Data �  27/09/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para marcar/desmarcar todos os itens do	���
���			� ListBox ativo												���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0

	If lMarca							// Quando marco todos, 
		_nDesmarca	:= 0				// _nDesmarca � zero
	Else								// Quando Desmarco todos,
		_nDesmarca	:= Len( aVetor )	// _nDesmarca � igual � quantidade de todas as linhas
	Endif
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI

	oLbx:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������ͻ��
���Rotina	�MarcaTodF4�Autor  �Geronimo Benedito Alves										� Data �	08/05/18  ���
�������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Esta funcao � executada, quando o usuario tecla F4.													���
���			� 01 - Executa MarcaTodos com lChk invertido para alterar todas as linhas							  ���
���			� 02 - Executa VerTodos para ajustar lMarca (lChk) com o novo valor, que devera ser o inverso do atual ���
�������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Generico																								���
�������������������������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������������
*/

Static Function MarcaTodF4( lChk, aList, oListBox )
	lChk	:= ! lChk
	MarcaTodos( lChk,  @aList, oListBox )		 // Executa MarcaTodos com lChk invertido para alterar todas as linhas 
	VerTodos  ( aList, @lChk,  oChk )			 // Executa VerTodos para ajustar lMarca (lChk) com o novo valor, que devera ser o inverso do anterior
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	�INVSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para inverter selecao do ListBox Ativo		���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0
	_nDesmarca	:= 0		// Contador para identificar se existe linhas desmarcadas depois que o Botao "Marcar Todos" foi ativado
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
		
		If !aVetor[nI][1]		// Se encontrar linha que ficou desmarcada,
			_nDesmarca++		// Incremento _nDesmarca 
		Endif
	Next nI

	oLbx:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina	� VERTODOS �Autor  � Ernani Forastieri  � Data �  20/11/04	���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para verificar se estao todos marcardos	���
���			� ou nao														���
�������������������������������������������������������������������������͹��
���Uso		� Generico													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue :=.T.
	Local nI		:= 0

	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1],.F., lTTrue )
	Next nI

	lChk := IIf( lTTrue,.T.,.F. )
	oChkMar:Refresh()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � USRFIARR �Autor  �Geronimo B Alves	� Data �  23/11/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Retorna em uma array, as filiais para as quais o usuario	���
���			� tem acesso													���
�������������������������������������������������������������������������͹��
���Parametros� cCodUsr - characters, Codigo do usuario pesquisado			���
���			� (por default, vem o Codigo do usuario logado)				���
���			� cCodEmp - characters, Codigo da empresa / grupo de empresas���
���			� (por default, vem o Codigo da empresa / grupo atual)		���
���			� @param cCodFil, characters, Codigo da filial (por default, ���
���			� vem o Codigo da filial atual)							  ���
���			�															���
���			� exemplo u_zUsrFil("000001", "01", "02")					���
���			� exemplo u_zUsrFil("000001", "01", "0201")					���
�������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods										���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function USRFIARR(cCodUsr, cCodEmp, cCodFil)

	Local nGrp		:= 0
	Local nEmp		:= 0
	Local nAtu		:= 0 

	lAllFil :=.T. //Se for.T. ira pegar todas as filiais, se for.F. sera s� da empresa atual
	aAreaM0 := SM0->(GetArea())
	cFilBk  := cFilAnt
	cEmpBk  := cEmpAnt
	aUnitNeg:= Iif(lAllFil, FWAllGrpCompany(), {SM0->M0_CODIGO})
	aEmpAux := Iif(lAllFil, FWAllCompany(), {cEmpAnt})

	For nGrp := 1 To Len(aUnitNeg)									//Percorrendo os grupos de empresa
		cUnidNeg := aUnitNeg[nGrp]
		For nEmp := 1 To Len(aEmpAux)								//Percorrendo as empresas
			cEmpAnt := aEmpAux[nEmp]
			aFilAux := FWAllFilial(cEmpAnt)

			For nAtu := 1 To Len(aFilAux)							//Percorrendo as filiais listadas
				If Len(cFilAnt) > Len(aFilAux[nAtu])				//Se o tamanho da filial for maior, atualiza
					cFilAnt := cEmpAnt + aFilAux[nAtu]
				Else
					cFilAnt := aFilAux[nAtu]
				EndIf

				//Posiciono na empresa (para poder pegar o ident)
				SM0->(DbGoTop())
				SM0->(DbSeek(cUnidNeg+cFilAnt)) //� utilizado o 01, por grupo de empresas, caso necessario rotina pode ser adaptada
				//......................
				//Fazer tratamentos necess�rios neste ponto, se for consultas SQL lembrar de utilizar RetSQLName e FWxFilial
				//......................
			Next
		Next
	Next

	//Voltando backups
	cEmpAnt := cEmpBk
	cFilAnt := cFilBk
	RestArea(aAreaM0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � X3Titulo � Autor �Geronimo B Alves	� Data �  07/12/17	���
�������������������������������������������������������������������������͹��
���Desc.	� Recebe por parametro o nome de um campo e retorna o titulo ���
���			� dele de acordo com o SX3									���
�������������������������������������������������������������������������͹��
���Parametros� cNomeCampo - Nome do Campo									���
�������������������������������������������������������������������������͹��
���Uso		� 													���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function X3Titulo(cNomeCampo )
	Local aArea			:= GetArea()
	Local cTituCampo	:= " "

	dbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	If DbSeek(cNomeCampo)
		cTituCampo := AllTrim(X3Titulo())
	Endif

	RestArea(aArea)
Return cTituCampo


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkGene  � Autor �Geronimo B Alves	� Data �  07/12/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Monta uma tela generica de markbrowse, mostrando registros ���
���			� selecionados pela query recebida por parametro, nos campos ���
���			� tambem recebidos por parametro, para que o usuario marque  ���
���			� quais serao processadas									���
�������������������������������������������������������������������������͹��
���Parametros� _cQuery		- Query para selecao dos registros			���
���			� aCpoMostra[1] - Campo a ser mostrado						���
���			� aCpoMostra[2] - Titulo do Campo							���
���			� aCpoMostra[3] - Tamanho do Campo em caracteres				���
���			� cTitulo		- Titulo dq tela de selecao					���
���			� nPosRetorn	- Numero da posicao do campo na MarkBrowse	���
���			�				- que sera retornado. Ex. Pode ser retornado ���
���			�				- o primeiro, segundo, terceiro ou outro		���
���			�				- campo do MarkBrowse						���
���			� _lBtnCance	- Parametro recebido como referencia. Define se deve(.T.) ou  nao deve(.F.) cancelar todo o processamento caso o usuario ���
���			�					clicar no Botao cancelar. O _lBtnCance � visivel no programa chamador e se retornou como.T., indica que o Botao		���
���			�					foi teclado. Ent�o o programa deve ser finalizado																		���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarkGene(_cQuery, aCpoMostra, cTitulo, nPosRetorn, _lCancProg ,_lInComAll )
	Local aArea			:= GetArea()
	Local _nRecno		:= Recno()
	Local _cTmp01		:= GetNextAlias()
	Local aList			:= {}
	Local aListMarca	:= {}
	Local nLinEncont	:= 0
	Local aEncontrad	:= {}
	Local aLinhaAux		:= {}
	Local lExibe		:= .T.
	Local nI 			:= 0
	Local nOpc  		:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo		:= { }
	Local aTam			:= { }
	Local oListBox
	Local oSay
	Local oDlg
	Local nListTam1		:= 360	//380	//340	//280	//250
	Local nListTam2		:= 230	//220	//200	//170
	Local nI
	Local _nI			:= 0
	
	Default _lInComAll	:= .F.

	Private lChk		:= .F.		  
	Private _nDesmarca		// Contador para identificar se existe linhas desmarcadas

	cTitulo  			:= OemToAnsi(cTitulo)

	Aadd(aTitulo, " " )								// {" ", "Codigo", "Empresa", " " }
	Aadd(aTam	, 120  )									// {10, 30, 200, 01 }
	For _nI := 1 to len(aCpoMostra)
		Aadd(aTitulo, aCpoMostra[_nI,2] )			// Titulo do campo {" ", "Codigo", "Empresa", " " }
		Aadd(aTam	, aCpoMostra[_nI,3] * 1 )		// Tamanho do campo em Pixel {10, 30, 200, 01 } Em media, o Aria 12 tem a largyra de 11 pixel para cada letra
	Next

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf
	dbusearea(.T.,"TOPCONN",TcGenQry(,	,_cQuery),_cTmp01,.T.,.F.)
	dbSelectArea(_cTmp01)
	dbGoTop()

	If !eof()
		dbGoTop()
		While !eof()
			aLinhaAux		:= {}
			Aadd(aLinhaAux,  .F. )
			For _nI := 1 to len(aCpoMostra)
				Aadd(aLinhaAux,	&(aCpoMostra[_nI,1]) )
			Next	
			Aadd(aLinhaAux,	" " )
			Aadd(aList , aLinhaAux )
			DbSkip()
		Enddo
	Else
		MsgStop( "Nao foi encontrado nenhum registro para montar esta tela de selecao de registros" )
		Aadd(aEncontrad , " " )
	Endif										

	_nDesmarca	:= Len(aList)	// Contador para identificar se existe linhas desmarcadas

	//������������������������������������������������������������������������Ŀ
	//� Monta a tela de selecao dos arquivos a serem importados				�
	//��������������������������������������������������������������������������
	If Len(aList) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 040,100 OF oMainWnd

		If Len(aTitulo) == 2
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]) SIZE nListTam1,nListTam2 ON DBLCLICK ( U_DBLCLICK(aList,oListBox,oChk) ) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 3
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]) SIZE nListTam1,nListTam2 ON DBLCLICK ( U_DBLCLICK(aList,oListBox,oChk) ) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]) SIZE nListTam1,nListTam2 ON DBLCLICK ( U_DBLCLICK(aList,oListBox,oChk) ) //NOSCROLL		5,160
		ElseIf Len(aTitulo) > 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]), OemtoAnsi(aTitulo[5])  SIZE nListTam1,nListTam2 ON DBLCLICK ( U_DBLCLICK(aList,oListBox,oChk) ) //NOSCROLL		5,160
		Endif

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aList)
		oListBox:aColSizes := aTam
		//	/*/
		If Len(aTitulo) == 2
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2] }}
		ElseIf Len(aTitulo) == 3
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3]}}
		ElseIf Len(aTitulo) == 4
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4]}}
		ElseIf Len(aTitulo) > 4	
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4], aList[oListBox:nAt,5]}}
		Endif
		// /*/
		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aList, oListBox ) })		// Cria a associacao da tecla F4, � funcao MarcaTodF4()

		@ 250, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aList, oListBox )

		@ 250, 130 BUTTON	oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ) Message 'Inverter Selecao' Of oDlg	
		DEFINE SBUTTON oBtnOk	FROM 250,200 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnCan	FROM 250,260 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg	

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )					// Cancela a associacao da tecla F4, � funcao MarcaTodF4()

		If nOpc == 0
			aList := {}
			If _lCancProg				// Se deve abandonar processamanto caso clique no Botao cancelar, e ele foi cancelado (nOpc == 0) 
				_lCancProg	:= .T.		// Cancelar o programa
				MsgStop("Processamento foi cancelado pelo usuario")
			Else
				_lCancProg	:=.F.		// Nao cancelar o programa. Foi clicado o Botao cancelar, porem o parametro _lCancProg recebidi diz para nao abandonar o programa se isto ocorrese, mas somente limpar/desconsiderar as marca��es  
			Endif
		Else
			_lCancProg	:=.F.			// Nao cancelar o programa. Nao foi clicado o Botao cancelar. 
		Endif
	Endif

	If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] ==.T.}) <= 0
		//Aviso("Inconsist�ncia", "Nao foi selecionado nenhum registro. ",{"Ok"},	,"Atencao:")
		aList := {}
	EndIf

	For _nI := 1 to len(aList)
		If aList[_Ni,1]
			If ValType( aList[_Ni,nPosRetorn + 1] ) == "C"
				//  No retornco de campos caracteres retiro os espa�os. Se o registro esta vazio retorno Space(1), pois no Oracle a clausula In 
				//  nao encontra o conteudo ""
				If Empty( aList[_Ni,nPosRetorn + 1] )
					aList[_Ni,nPosRetorn + 1]	:= Space(1)
				Else
					aList[_Ni,nPosRetorn + 1]	:= AllTrim( aList[_Ni,nPosRetorn + 1])
				Endif
			Endif
			
			Aadd(aListMarca, aList[_Ni,nPosRetorn + 1] )	// nPosRetorn eh o campo que desejo retornar.  Aqui, Somo 1, devido ao campo para checkbox que foi incluido no come�o de cada linha.
		Endif
	Next

	If _nDesmarca == 0				// Se nenhuma linha ficou desmarcada. (Marquei todas as linha)
		If ! _lInComAll             // E _lInComAll <> .T. ou seja nao deve, se marcado todos os itens, trazer todos os itens para a clausula IN
			aListMarca	:= {}		// Deixo o array de marcacao vazio, para nao implementar o filtro. Pois nesta execucao nao preciso filtrar, se � para trazer todos.
		Endif
	Endif

	DbGoto(_nRecno)
	RestArea(aArea)
Return aListMarca

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa � DBLCLICK � Autor �Geronimo B Alves	� Data �  31/08/18	 ���
������������������������������������������������������������������������͹��
���Desc.	� No Duplo click na linha, altera o seu status de Marcado,   ���
���			�desmarcado. Tambem atualiza o conteudo da variav _nDesmarca ���
������������������������������������������������������������������������͹��
���Parametros� aList,oListBox											 ���
������������������������������������������������������������������������͹��
���Retorno	� Nil													     ���
������������������������������������������������������������������������͹��
���Uso		� AP														 ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function DBLCLICK(aList,oListBox,OCHKMAR)

	If	aList[oListBox:nAt,1]			// Se esta marcado, vou desmarcar  
		_nDesmarca++					// Ent�o incremento o _nDesmarca
	Else								// Se esta DESmarcado, vou Marcar  
		_nDesmarca--					// Ent�o decremento o _nDesmarca
	Endif

	If _nDesmarca == 0					// Se esta tudo marcado
		lChk	:= .T.
	Else
		lChk	:= .F.
	Endif
	
	aList[oListBox:nAt,1] := !aList[oListBox:nAt,1]
	oListBox:Refresh()
	oChkMar:Refresh()
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IF_BIMFR � Autor �Geronimo B Alves	� Data �  13/12/17	���
�������������������������������������������������������������������������͹��
���Desc.		�Retorna a tabela ou o esquema.tabela valido para ser incluso���
���			�na clausula from da query. Efetuo o teste, tentando abrir a ���
���			�consulta sem, e depois com o(s) esquema(s) passado como		���
���			�parametros.Se nao conseguir abrir a tabela de nenhuma forma,���
���			�decide a forma de abertura conforme o nome do environment	���
���			� OBS. 01 Onde escrevi Tabela, leia-se Tabela ou View		���
���			� OBS. 02 Se o esquema recebido no parametro EsquemBco1 for  ���
���			� "IF_BIMFR" , este sera o esquema utilizado, se conseguir	���
���			� abrir a tabela.											���
�������������������������������������������������������������������������͹��
���Parametros�															���
�������������������������������������������������������������������������͹��
���Retorno	� Boleano													���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IF_BIMFR(EsquemBco1, TabelaView)
	Local cEnviroSrv
	Local cRet			:= ""
	Default TabelaView	:= " "
	Default EsquemBco1	:= " "

	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))		// Obtem o Environmente utilizado no servidor

	//Os Environments abaixo, apontam para um SGBD onde as View nao necessitam do esquema IF_BIMFR ou o passado no parametro
	//If .F.	// Nos novos ambientes de QA e HML, os users foram criados sem os sinonimos, por isto � preciso sempre o schema antes do nome da tabela 	// cEnviroSrv  $ "QA#GERONIMO#RICARDO#ATILIO#CARNEIRO#DEBUG_PADRAO#FLAVIO#GRESELE#JESUS#LEO" 
	If cEnviroSrv  $ "QA_xxLEO#QxxA#GERONIMO#RICARDO#ATILIO#CARNEIRO#DEBUG_PADRAO#FLAVIO#GRESELE#JESUS#LEO" 		// Trato ambientes do QA
		cRet	:=  TabelaView + " "
		
	Elseif "HML" $ cEnviroSrv																			// Trato ambientes do HML
		//cRet	:= "PROTHEUS_HML." + TabelaView + " "
		cRet	:=  TabelaView + " "
		
	Else																								// Trato ambientes da Producao
		cRet	:= EsquemBco1 +"." + TabelaView + " "
	Endif

Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLDTINIF � Autor �Geronimo B Alves	� Data �  18/12/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Valida se a data final � maior ou igual � data inicial e	���
���			� se o intervalo de dias entre elas � ateh a quantidade de	���
���			� dias maximo de intervalo recebido no terceiro parametro	���
�������������������������������������������������������������������������͹��
���Parametros�															���
�������������������������������������������������������������������������͹��
���Retorno	� Boleano													���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLDTINIF(dDtInicial, dDtFinal, _nInterval)
	Local lRet			:=.T.
	If  dDtFinal < dDtInicial .or. (dDtFinal-dDtInicial) > _nInterval		
		MsgStop("A data final tem que ser maior que a data inicial, e dentro de um intervalo maximo de  " + AllTrim(Str(_nInterval)) + " dias." )
		lRet	:=.F.
	endif		 
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLFIMMAI � Autor �Geronimo B Alves	� Data �  18/12/17	���
�������������������������������������������������������������������������͹��
���Desc.		� Recebe parametro final, inicial e emensagem e emite		���
���			� mensagem caso o final nao seje maior ou igual ao inicial, e���
���			� retorna.F.												���
�������������������������������������������������������������������������͹��
���Parametros�															���
�������������������������������������������������������������������������͹��
���Retorno	� Boleano													���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function VLFIMMAI( xInicial, xFinal, cTextoMsg )                                      	
	Local lRet			:=.T.
	If  xFinal < xInicial		
		MsgStop( cTextoMsg + " final, deve ser maior ou igual � " + cTextoMsg + " inicial." )
		lRet	:=.F.
	endif		 
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TGridRel �Autor �Geronimo Benedito Alves � Data � 04/01/18 ���
�������������������������������������������������������������������������͹��
���Desc.    � Monta os dados e exibe na tela do Grid                      ���
���         �															  ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TGridRel()

	Local aLinha		:={}
	Local _nI			:= ""
	//Local cIndice1		//, cIndice2, cIndice3
	Local _nAlinhamento
	Local oDlgMain
	Local oChk


	Local _cBanco		:= Alltrim(Upper(TCGetDb()))

	Public _nArqName		:= 0
	Public _aArqName		:= {}
	
	Private oBrowse
	Private aRotina		:= MenuDef()
	Private cCadastro	:= _aDefinePl[1]
	Private aSeek := {}, aFieFilter := {}
	Private _lComParam	:= .F.	// RVBJ

	IF MsgYesNo("Imprime Perguntas ?")
		_lComParam	:= .T.
	Endif

	//SetKey( 27 , {|| U_Quit() })		// Se teclar ESC , abandona o processamento e retorna ao menu

	If VALTYPE(_aEmailQry)	== "A"
		If !empty(_aEmailQry)
			_aEmailQry[3]	:= _aEmailQry[3] + _cQuery		// Incremento agora no corpo do e-mail que j� tinha o texto; a query do relatorio. 
			U_BIEnvEml(_aEmailQry[1]/*cTo*/, _aEmailQry[2]/*_cSubject*/, _aEmailQry[3]/*_cCorpo*/ )
		Endif
	Endif

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf

	aStruTRB	:= {}
	For _nI := 1 to len(_aCampoQry)
		aAdd(aStruTRB,{ _aCampoQry[_nI,_nPoApeli] ,;	// Nome do Campo
						_aCampoQry[_nI,_nPoTipo],;		// Tipo
						_aCampoQry[_nI,_nPoTaman],;		// tamanho
						_aCampoQry[_nI,_nPoDecim]})		// N� de decimais
	Next
	aAdd(aStruTRB,{ 	"X" ,;	// Nome do Campo
						"C" ,;	// Tipo
						1   ,;	// tamanho
						0   })	// N� de decimais

	// A linha abaixo nao tem efeito p/ o fonte. � apenas p/ na compilacao nao aparecer a MSG "warning W0003 Local variable __LOCALDRIVER never used"
	__LocalDriver	:= __LocalDriver + ""	

	cNomeArq:=CriaTrab( aStruTRB,.T. )
	
	If .F.		//.T.								// FunName() $ "U_MGF02R03,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01"			//IsInCallStack("U_MGF34R07")	

		//		////MsAguarde({|| INSERT_TRB( _cTmp01, _aCampoQry )    },"Criando a tabela com os dados da Query", "Criando a tabela com os dados da Query",.T. )  //MSAguarde( bAcao, cTitulo ,cMensagem, lAbortar)	Obs. lAborta =.T. habilita o Botao
		dbUseArea(.T.,"TOPCONN"    ,TcGenQry(,,_cQuery),_cTmp01 ,.T. ,.F.)
		cIndice1 := Alltrim(CriaTrab(,.F.))
		//cIndice1 := Left(cIndice1,5)+Right(cIndice1,2)+"A"
		If File(cIndice1+OrdBagExt())
			FErase(cIndice1+OrdBagExt())
		EndIf
		
		IndRegua(_cTmp01, cIndice1, "X"	,,, "Indice CAMPO X")
		//IndRegua(_cTmp01, cIndice1, R_E_C_N_O_	,,, "Indice CAMPO X")



*********************************************************************************************************************************
/* 

// Criacao da Tabela Tempor�ria >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
cCampos	:= ""
_cQueryAux	:= StrTran( _cQuery, " ,  ' ' as X " , "" )		//Retira o treho do X que foi criado para ser o indice da tabela. A funcao FwmBrowse torna obrigatorio o uso de um indice na tabela.
_oTrbRelat := FWTemporaryTable():New( _cTmp01 )  
_oTrbRelat:SetFields(aStruTRB) 
_oTrbRelat:AddIndex("1", {"X"})			//_oTrbRelat:AddIndex("1", {"E2_FILIAL","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_TIPO","E2_FORNECE","E2_LOJA"})
_oTrbRelat:Create()  

_cQuery2 := " INSERT "
AEVAL(aStruTRB,{|e,i| cCampos += IF(i==1, ALLTRIM(e[1])+" " , ","+ALLTRIM(e[1])+" " )  })
_cQuery2 += " INTO "+_oTrbRelat:GetRealName()+" ( "+cCampos+" ) " + _cQuery
MemoWrite( GetTempPath(.T.) + "AAA_Insert_into_do_Trb_.TXT",_cQuery2)
Processa({|| TcSQLExec(_cQuery2)})				// Cria arquivo temporario	// Processa({||SqlToTrb(cQuery, aStru, _cTmp01)}) 
	    If substr(_cBanco,1,6) == "ORACLE"
 		   TCSQLEXEC("COMMIT")
	    EndIf

	//IF (TcSQLExec(cUpd) < 0)
	//  MemoWrite( GetTempPath(.T.) + "AAA_Insert_into_do_Trb_erro_"+StrTran(Time(),":","")+".TXT",TcSQLError() )
	//	Return
	//EndIF

(_cTmp01)->(DbSetOrder(1))  
(_cTmp01)->(DbGoTop())  



*********************************************************************************************************************************		
	If .F.			// Este trecho � somente para estudos e testes
		// Atualiza TOP_FIELD
	    _cQuery := " INSERT INTO TOP_FIELD (FIELD_TABLE, FIELD_NAME, FIELD_TYPE, FIELD_PREC, FIELD_DEC)  "
    	//_cQuery += " VALUES ('"+_cUsertable+RetSQLName(_cArquivo)+"','"+_aCamposSX3[_ni][1]+"','"+_cType+"','"+alltrim(str(_aCamposSX3[_ni][3]))+"','"+alltrim(str(_aCamposSX3[_ni][4]))+"')"
    	_cQuery += " VALUES ('"+_cUsertable+_cArquivo+"','"+_aCamposSX3[_ni][1]+"','"+_cType+"','"+alltrim(str(_aCamposSX3[_ni][3]))+"','"+alltrim(str(_aCamposSX3[_ni][4]))+"')"
    	TCSQLEXEC(_cQuery)
	    If substr(_cBanco,1,6) == "ORACLE"
 		   TCSQLEXEC("COMMIT")
	    EndIf

		// Atualiza tabela CHECKTOP 
		_cQuery := " SELECT MAX(R_E_C_N_O_) RECNO "
  	 	_cQuery += " FROM CHECKTOP "
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '__TOP', .F., .T.)
	    _cQuery := " INSERT INTO CHECKTOP  (CHK_TABLE, CHK_NAME, CHK_TYPE, CHK_PREC, CHK_DEC, CHK_DAT,R_E_C_N_O_)  "
    	//_cQuery += " VALUES ('"+_cUsertable+RetSQLName(_cArquivo)+"','"+Alltrim(_aCamposSX3[_ni][1])+"','"+Alltrim(_cType)+"','"+Alltrim(str(_aCamposSX3[_ni][3]))+"','"+Alltrim(str(_aCamposSX3[_ni][4], 0))+"','"+DTOS(dDataBase)+"',"+Alltrim(str(RECNO + 1, 0))+")"
    	_cQuery += " VALUES ('"+_cUsertable+_cArquivo+"','"+Alltrim(_aCamposSX3[_ni][1])+"','"+Alltrim(_cType)+"','"+Alltrim(str(_aCamposSX3[_ni][3]))+"','"+Alltrim(str(_aCamposSX3[_ni][4], 0))+"','"+DTOS(dDataBase)+"',"+Alltrim(str(RECNO + 1, 0))+")"
    	__TOP->( dbCloseArea() )
    	TCSQLEXEC(_cQuery)
	    If substr(_cBanco,1,6) == "ORACLE"
 		   TCSQLEXEC("COMMIT")
	    EndIf
	EndIf
*********************************************************************************************************************************		
	//Deleta tabela temporaria criada no banco de dados
	If .F.
	If _oTrbRelat <> Nil
		_oTrbRelat:Delete()
		_oTrbRelat := Nil
	Endif
	Endif
*/	
*********************************************************************************************************************************		
		
			//IndRegua("SE3",cArqInd,cChave,,cQuery,OemToAnsi(STR0006))  //"Selecionando Registros..."
			//nIndex := RetIndex("SE3")
			//dbSelectArea("SE3")
			//#IFNDEF TOP
			//	dbSetIndex(cArqInd+OrdBagExt())
			//#ENDIF
			//dbSelectArea("SE3")
			//dbSetOrder(nIndex+1)
	Else
		dbUseArea(.T.,__LocalDriver,cNomeArq          ,_cTmp01 ,.T. ,.F.)
		MsAguarde({|| SqlToTrb(_cQuery, aStruTRB, _cTmp01 )},"Criando a tabela com os dados da Query", "Criando a tabela com os dados da Query",.T. )  //MSAguarde( bAcao, cTitulo ,cMensagem, lAbortar)	Obs. lAborta =.T. habilita o Botao
		cIndice1 := Alltrim(CriaTrab(,.F.))
		//cIndice1 := Left(cIndice1,5)+Right(cIndice1,2)+"A"
		If File(cIndice1+OrdBagExt())
			FErase(cIndice1+OrdBagExt())
		EndIf
		//IndRegua(_cTmp01, cIndice1, "R_E_C_N_O_"	,,, "Indice CAMPO R_E_C_N_O_ ")

	Endif
	
	//INKEY(0.001)
	// dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),_cTmp01,.T.,.F.)		//Metodo antigo, de gravacao no TOPconnect. Aqui, gravava em tabela virtual, no SGBD atraves do Topconnect. Porem a leitura dele, � mais lenta que no Ctree (principalmente se for em Oracle)
	If	.F.							//!(FunName() $ "U_MGF02R03,U_MGF34R06,U_MGF34R07,U_MGF34R17,U_MGF34R18,U_MGF34R25,U_MGF78R01")
		dbSelectArea(_cTmp01)
		dbGoTop()
		If !eof()
			U_TelRel49()
		Else
			MsgStop(" Nao existem dados para os parametros informados" )
			if Select(_cTmp01) > 0
				(_cTmp01)->(dbCloseArea())
				fErase(_cTmp01)
			endif
	
		Endif
			
	Else				//FunName() $ "U_MGF34R07,U_MGF34R17,U_MGF34R18"			//If IsInCallStack("U_MGF34R07")	

					//Campos que irao compor o combo de pesquisa na tela principal
//		Aadd(aSeek,{"ID"   , {{"","C",06,0, "TR_ID"   ,"@!"}}, 1, .T. } )
//		Aadd(aSeek,{"Login", {{"","C",20,0, "TR_LOGIN","@!"}}, 2, .T. } )
//		Aadd(aSeek,{"Nome" , {{"","C",50,0, "TR_NOME" ,"@!"}}, 3, .T. } )
					//Campos que irao compor a tela de filtro
//		Aadd(aFieFilter,{"TR_ID"	, "ID"   , "C", 06, 0,"@!"})
//		Aadd(aFieFilter,{"TR_LOGIN"	, "Login", "C", 20, 0,"@!"})
//		Aadd(aFieFilter,{"TR_NOME"	, "Nome" , "C", 50, 0,"@!"})
	
		dbSelectArea(_cTmp01)
		//dbSetOrder( 1 )
		DbGoTop()

		If !eof()

			//������������������������������������������������������Ŀ
			//� Faz o calculo automatico de dimensoes de objetos		�
			//��������������������������������������������������������
			aSize := MsAdvSize()
			//1 -> Linha  inicial �rea trabalho.
			//2 -> Coluna inicial �rea trabalho.
			//3 -> Linha  final �rea trabalho.
			//4 -> Coluna final �rea trabalho.
			//5 -> Coluna final dialog (janela).
			//6 -> Linha  final dialog (janela).
			//7 -> Linha  inicial dialog (janela).
			//8 -> Coluna inicial dialog (janela).
			aObjects := {}
			AAdd( aObjects, { 100, 100,.T.,.T. } )
			aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
			aPosObj := MsObjSize( aInfo, aObjects )
		
			DEFINE MSDIALOG oDlgMain TITLE _aDefinePl[1] FROM aSize[7], aSize[8] TO aSize[6],aSize[5]-10 OF oMainWnd PIXEL 
		
			oDlgMain:lEscClose :=.T.		// Permite sair do Dialog ao se pressionar a tecla ESC
			
			//oBrowse := FWmBrowse():New()
			oBrowse := FWMBrowse():New()
			oBrowse:setdatatable()     		//--<< Indica que usa uma Tabela                      >>--
			oBrowse:SetAlias( _cTmp01 )
			//_cTmp01 := oBrowse:Alias ( )
			oBrowse:SetDescription( cCadastro )
			oBrowse:setSeek(,aSeek)
			oBrowse:setOwner(oDlgMain)

			//oBrowse:SetTemporary(.T.)
			
			//oBrowse:SetDataQuery( )
			//oBrowse:SetDataTable( )
			
		   	//oBrowse:SetLocate()
			//oBrowse:SetUseFilter(.F.)
			//oBrowse:SetDBFFilter(.F.)
			//oBrowse:SetFilterDefault( "X <> '9'" ) //Exemplo de como inserir um filtro padrao >>> "TR_ST == 'A'"
			//oBrowse:SetFieldFilter(aFieFilter)

			//oBrowse:DisableDetails()

			//oBrowse:SetLineOk ( { |oBrowse| U_linhaBRW( oBrowse ) } ) 
			
				//Legenda da grade, � obrigatorio carregar antes de montar as colunas
	//		oBrowse:AddLegend("TR_ST=='A'","GREEN" 	,"Grupo Administradores")
	//		oBrowse:AddLegend("TR_ST=='C'","BLUE"  	,"Grupo Cont�bil")
	//		oBrowse:AddLegend("TR_ST=='R'","RED"  	,"Grupo RH")
		
			//Detalhes das colunas que serao exibidas
			For _nI	:= 1 to len(_aCampoQry)
				If _aCampoQry[_ni, _nPoTipo] == "D"	
					_nAlinhamento := 0				// Campo data alinhado ao centro       (0)
					
				ElseIf _aCampoQry[_ni, _nPoTipo] == "N"	
					_nAlinhamento := 2				// Campo Numerico Alinhado a Direita   (2)
					
				Else
					_nAlinhamento := 1				// Campo Caracter ou outros, alinhado a esquerda  (1)
					
				Endif
			
				oBrowse:SetColumns(MontaColun  (_aCampoQry[_ni, _nPoApeli] ,_aCampoQry[_ni, _nPoTitul] ,_nI ,_aCampoQry[_ni, _nPoPictu] ,_nAlinhamento ,_aCampoQry[_ni ,_nPoTaman] ,_aCampoQry[_ni, _nPoDecim] ))
				//oBrowse:SetColumns(MontaColun("CAMPO"		,"TITULO"		,01_nPosicao_no_grid, "@!",0_nAlinhamento? ,010_nTamanho, 0_nDecimal ))
	    	Next
					//_aCampoQry[_ni, _nPoNome ]	:= IIF( Empty  (_aCampoQry[_ni, _nPoNome]  ), 		AllTrim(SX3->X3_CAMPO)		,_aCampoQry[_ni, _nPoNome]  ) 
					//_aCampoQry[_ni, _nPoTitul]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTitul] ), 		AllTrim(SX3->X3_DESCRIC)	,_aCampoQry[_ni, _nPoTitul] )  
					//_aCampoQry[_ni, _nPoTipo]		:= IIF( Empty  (_aCampoQry[_ni, _nPoTipo]  ), 		AllTrim(SX3->X3_TIPO)		,_aCampoQry[_ni, _nPoTipo]  )
					//_aCampoQry[_ni, _nPoTaman]	:= IIF( Empty  (_aCampoQry[_ni, _nPoTaman] ), 		SX3->X3_TAMANHO				,_aCampoQry[_ni, _nPoTaman] )
					//_aCampoQry[_ni, _nPoDecim]	:= IIF( ValType(_aCampoQry[_ni, _nPoDecim]) <> "N",	SX3->X3_DECIMAL				,_aCampoQry[_ni, _nPoDecim] )
					//_aCampoQry[_ni, _nPoPictu]	:= IIF( Empty  (_aCampoQry[_ni, _nPoPictu] ), 		AllTrim(SX3->X3_PICTURE)	,_aCampoQry[_ni, _nPoPictu] )
					//_aCampoQry[_ni, _nPoApeli]	:= IIF( Empty  (_aCampoQry[_ni, _nPoApeli] ), 		AllTrim(SX3->X3_CAMPO)		,_aCampoQry[_ni, _nPoApeli] )
					//_aCampoQry[_ni, _nPoPicVar]	:= IIF( Empty  (_aCampoQry[_ni, _nPoPicVar]), 		AllTrim(SX3->X3_PICTVAR)	,_aCampoQry[_ni, _nPoPicVar])
			
			If aLLtrim(Funname()) $ GetNewPar('MGF_00A01' , 'FINA050/') 
				oBrowse:DisableDetails()
			EndIf 
			
			oBrowse:Refresh( .T. ) 		// lGoTop == .T.]
			oBrowse:Activate()
			oDlgMain:Activate(	,,,.F.	,,.T.	,, )
			
	    Else
			MsgStop(" Nao existem dados para os parametros informados" )
	    Endif

		If !Empty(cNomeArq)
			Ferase(cNomeArq+GetDBExtension())
			Ferase(cNomeArq+OrdBagExt())
			cNomeArq := ""
			(_cTmp01)->(DbCloseArea())
			delTabTmp(_cTmp01)
			dbClearAll()
		Endif		
		
	Endif

RETURN


User Function linhaBRW( oBrowse )

/*/
	Local := _nLinha := oBrowse:At( )  + 1
	oBrowse:GoTo ( _nLinha , .T. ) 
	oBrowse:LineRefresh ( _nLinha ) 
	_nLinha := _nLinha - 2
	If _nLinha >= 0
		oBrowse:GoTo ( _nLinha , .T. ) 
		oBrowse:LineRefresh ( _nLinha ) 
	Endif
/*/

	oBrowse:Refresh ( .F. )			// [ lGoTop == .F. nao for�a reposicionamento no topo da tabela]
Return


/*/
��������������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � TelRel49 �Autor  �Geronimo Benedito Alves																			 �Data �31/01/18 ���
����������������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.	� Este programa contem as funcoes p/ criar o objeto MsNewGetDados, que mostrar� em tela os dados dos relatorios com mais que 1 coluna    ���
���			� Criada esta funcao, por que a anterior que usava o objeto TGrid mostrava em tela, no maximo 48 colunas					             ���
����������������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																					                                 ���
����������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������������������  /*/
User Function TelRel49()
	Local oGetDad
	Local nX			:= 0
	Local _nI			:= 0
	Local nI			:= 0
	Local oBtnAdd		:= nil
	//Local nTop		:= 000	
	//Local nLeft		:= 001
	//Local nBottom		:= 270		//250	//280	//270
	//Local nRight		:= 650		//400	//500	//650
	Local nStyle		:= nil		//GD_UPDATE
	Local cLinhaOk		:= nil
	Local cTudoOk		:= nil
	Local cIniCpos		:= nil
	Local aAlter		:= {}
	Local nFreeze		:= 0
	Local nMax			:= 999999
	Local cFieldOk		:= nil
	Local cSuperDel		:= nil
	Local cDelOk		:= nil
	Local oDlgMain 
	Local aHeadTab		:= {}
	Local aColsTab		:= {}
	Local uChange		:= nil
	Local cTela			:= nil
	Local cNomeCampo	:= ""
	Local _nArqName		:= 0
	Local _aArqName		:= {}

	Private INCLUI, VISUAL, ALTERA, DELETA
	INCLUI 		:=.F.
	VISUAL 		:=.T.
	ALTERA 		:=.F.
	DELETA 		:=.F.

	dbSelectArea(_cTmp01)
	_nLastRec	:= LastRec()
	DbGotop()	// Retorno ao inicio do arquivo
	
	//                       ("MGF_BIREGI", <lHelp>, <cPadr�o>, <Filial do sistema> )
	If IsInCallStack("U_MGF34R02") .and. _nLastRec > SuperGetMV("MGF_BIREGI",   .F.,    274483 )		// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
                
		//  // MsgRun("Gerando Planilha: " + _aDefinePl[1], _aDefinePl[1], {|| Planilha("FWRITE900", @_nArqName,@_aArqName) })	//Gera planilha excel com formatacao FWRITE900

		DbGoBottom()	// Vou para o fim do arquivo
		DbSkip()		// Desco mais um registro para dar eof() e assim a tela da GetDados ser montada vazia, ganhando tempo de processamento para o usuario

		Do While .T.
			MsgRun("Gerando Planilha: " + _aDefinePl[1], _aDefinePl[1], {|| Planilha("FWRITE900", @_nArqName,@_aArqName) })	//Gera planilha excel com formatacao FWRITE900
			IF MsgYesNo("Fim da geracao da Planilha: " + _aDefinePl[1] +CRLF+ CRLF+  "Deseja sair do Programa ?" +CRLF+CRLF+ "Escolha SIM, se a planilha foi gerada com sucesso. " +CRLF+ "Escolha NAO para gerar a planilha, se ela nao foi gerada. ")
				// Antes de encerrar o processamento, fecho o arquivo temporario e o excluo do disco
				if Select(_cTmp01) > 0
					(_cTmp01)->(dbCloseArea())
					fErase(_cTmp01)
				endif
				Return		// Abandono a rotina, para voltar ao menu
				
			Endif
		Enddo

	Endif
	
	
	//������������������������������������������������������������������������������Ŀ
	//�Define os campos a serem exibidos												�
	//��������������������������������������������������������������������������������
	////  01				02					03	04  05						06  07 08	09										
	//_aCampoQry	:= { ;
	//{ "COD_FILIAL"	,"Cod. Filial"		,12, "C", CONTROL_ALIGN_LEFT	,"", 8, ""	,"A1_FILIAL" }, ;	
	//{ "NOME_FILIAL"	,"Nome Filial"		,40, "C", CONTROL_ALIGN_LEFT	,"", 8, ""	,"A1_NOME" 	}, ;	
	//{ "NUMERO_SC"	,"N� Solicitacao"	,06, "C", CONTROL_ALIGN_LEFT	,"", 8, ""	,"C1_NUM"	}, ;	

	//�����������������������������������������������������������������������������Ŀ
	//� Monta o aHeader da getdados													�
	//�������������������������������������������������������������������������������

	aHeadTab := {}
	DbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nX := 1 to Len(_aCampoQry)

		// sx3->(aAdd( aHeaderEx,{x3_titulo,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; 
		// x3_Valid, X3_USADO,X3_TIPO,x3_f3,X3_CONTEXT,X3_CBOX,x3_Relacao,x3_when,x3_visual,X3_VLDUSER,X3_PICTVAR})) 
		aAdd(aHeadTab,{_aCampoQry[nX,_nPoTitul] ,;	// Titulo
		AllTrim(  _aCampoQry[nX,_nPoNome]  ),;		// Nome Campo
		_aCampoQry[nX,_nPoPictu],;					// SX3->X3_PICTURE
		_aCampoQry[nX,_nPoTaman],;  				// Tamanho
		_aCampoQry[nX,_nPoDecim],;  				// Decimais
		.T.,;  										// Validacao
		"",;										// X3_USADO
		_aCampoQry[nX,_nPoTipo],;					// TIPO
		"  " ,;										// X3_F3
		"  ",;										// X3_CONTEXT
		""			,""		,""		,""	,""	,""	})
		If !Empty( _aCampoQry[nX,_nPoPicVar] )							// Se tem X3_PICTVAR para este campo,
			aHeadTab[len(aHeadTab),16]	:= _aCampoQry[nX,_nPoPicVar]	// Levo o PICTVAR informado na array para a montagem da tela de browse.
			aHeadTab[len(aHeadTab),06]	:= ""							// E tambem, limpo a posicao do Picture.
		Endif 
	Next nX

	//�����������������������������������������������������������������������������Ŀ
	//� Monta os acols da getdados													�
	//�������������������������������������������������������������������������������
	// Dados						
	dbSelectArea(_cTmp01)
	//nConta := 0

	While ! eof()
		aLinha	:= {}
		For _nI := 1 to len( _aCampoQry )
			//nPosNomCpo	:= If( Empty(_aCampoQry[_nI,_nPoApeli] ) , _nPoNome, _nPoApeli )
			cNomeCampo	:= _aCampoQry[_nI,_nPoApeli]
			If _aCampoQry[ _nI, _nPoTipo] == "D"
				//Aadd( aLinha, U_ConvData( &(_aCampoQry[ _nI, nPosNomCpo]) ,"C") )
				Aadd( aLinha, U_ConvData( &( cNomeCampo ) ,"C") )

			ElseIf _aCampoQry[ _nI, _nPoTipo] == "N"
				//Aadd( aLinha, &(_aCampoQry[_nI, nPosNomCpo] ) )		//Aadd( aLinha, Transform( &(_aCampoQry[_nI, nPosNomCpo]), _aCampoQry[_nI, _nPoPictu] ) )
				Aadd( aLinha, &( cNomeCampo ) )		//Aadd( aLinha, Transform( &(_aCampoQry[_nI, nPosNomCpo]), _aCampoQry[_nI, _nPoPictu] ) )

			Else		// Para _aCampoQry[ _nI, _nPoTipo] == "C" ou outros tipos de dados
				//Aadd( aLinha, &(_aCampoQry[_nI, nPosNomCpo])  ) 
				Aadd( aLinha, &( cNomeCampo )  ) 
			Endif

		Next
		AADD( aLinha,.F. )
		AADD( aColsTab, aLinha )
		DbSkip()

	Enddo

	If Len(aColsTab) == 0
		Aadd(aColsTab,Array(Len(aHeadTab)+1))
		//For _nI := 1 To Len(aHeadTab)
			//aColsTab[Len(aColsTab)][_nI]	:= CriaVar(aHeadTab[_nI,_nPoCpoX3],.F.)
		//Next _nI
		
		For _nI := 1 To Len(aHeadTab)
			If _aCampoQry[ _nI, _nPoTipo] == "D"
				aColsTab[Len(aColsTab)][_nI]	:= CTOD("")

			ElseIf _aCampoQry[ _nI, _nPoTipo] == "N"
				aColsTab[Len(aColsTab)][_nI]	:= 0

			Else		// Para _aCampoQry[ _nI, _nPoTipo] == "C" ou outros tipos de dados
				aColsTab[Len(aColsTab)][_nI]	:= space(10)
				
			Endif

		Next
		aColsTab[Len(aColsTab)][Len(aHeadTab)+1] :=.T.
	Endif

	//������������������������������������������������������Ŀ
	//� Faz o calculo automatico de dimensoes de objetos		�
	//��������������������������������������������������������
	aSize := MsAdvSize()
	//1 -> Linha  inicial �rea trabalho.
	//2 -> Coluna inicial �rea trabalho.
	//3 -> Linha  final �rea trabalho.
	//4 -> Coluna final �rea trabalho.
	//5 -> Coluna final dialog (janela).
	//6 -> Linha  final dialog (janela).
	//7 -> Linha  inicial dialog (janela).
	//8 -> Coluna inicial dialog (janela).
	aObjects := {}
	AAdd( aObjects, { 100, 100,.T.,.T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlgMain TITLE _aDefinePl[1] FROM aSize[7], aSize[8] TO aSize[6],aSize[5]-10 OF oMainWnd PIXEL 

	oDlgMain:lEscClose :=.T.		// Permite sair do Dialog ao se pressionar a tecla ESC
	oGetDad := MsNewGetDados():New(aPosObj[1,1]+2, aPosObj[1,2], aPosObj[1,3]-10, aPosObj[1,4]-3, nStyle, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oDlgMain, @aHeadTab, @aColsTab, uChange, cTela )	

	oGetDad:Enable ( )
	oGetDad:ForceRefresh ( )
	oGetDad:OWND:LESCCLOSE :=.T.	// Permite sair da GetDados ao se pressionar a tecla ESC

	If IsInCallStack("U_MGF34R02") .and. _nLastRec > SuperGetMV("MGF_BIREGI",   .F.,    274483 )		// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
		@ 005,010 BUTTON "Gera Planilha Excel " SIZE 100, 020 ACTION MsgRun("Gerando Planilha: " + _aDefinePl[1], _aDefinePl[1], {|| Planilha("FWRITE900", @_nArqName,@_aArqName) }) Object oBtnAdd  //Gera planilha excel com formatacao "FWRITE900"
	Else
		@ 005,010 BUTTON "Gera Planilha Excel " SIZE 100, 020 ACTION MsgRun("Gerando Planilha: " + _aDefinePl[1], _aDefinePl[1], {|| Planilha("FWMsExcelEx", @_nArqName,@_aArqName) }) Object oBtnAdd  //Gera planilha excel com formatacao FWMsExcelEx
	Endif

	//SetKey( 27 , {||})		// desabilita o chamamento da funcao U_Quit, pelo acionamento da tecla ESC
	oDlgMain:Activate(	,,,.F.	,,.T.	,, )

	// Antes de encerrar o processamento, fecho o arquivo temporario e o excluo do disco
	if Select(_cTmp01) > 0
		(_cTmp01)->(dbCloseArea())
		fErase(_cTmp01)
	endif

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �'Planilha �Autor  �Geronimo Bened Alves� Data �  04/01/18	���
�������������������������������������������������������������������������͹��
���Desc.		� Executa o criacao da planilha excel com os dados da		���
���			� tabela temporaria											���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Planilha(ModoCrioPlan, _nArqName, _aArqName)

	Local _cPastaGrv 	:= ""	// Pasta onde sera gravado o arquivo excel em formato xml ou csv
	Local _oExcel		:= ""
	Local nX			:= 0
	Local nCount		:= 0

	Local _Ni 			:= _nX	:= _nJ	:= _nPosi_Aba := _nPosiColu := 0
	Local _oExcelApp
	Local aCabExcel		:={}
	Local aItensExcel	:={}
	Local aItem
	Local cConteudo		:= ""
	Local _cArqCabec 	:= CriaTrab(,.F.)+".htm"
	Local nArq			:= fCreate(_cArqCabec,0)
	Local Comand_DOS	:= ""
	Local cLinGravar	:= ""	// Conteudo � ser gravado em cada linha
	Local n900linhas	:= 0	// Contador de linhas inclusas na variavel cLinGravar. Ao atingir 900 gravo-a em disco. Diminuir I/O melhorando a performance 
	Local oList1			:= ""
	Local _cCriaabre	:= "CRIA_PLANILHA"
	Local oBotao_Ok
	Local cNomePlani	:= ""
	Local cNomeCampo	:= ""
	Local _nLinhPlan	:=	5	//N� de linhas gravadas na planilha (o limite do excel � 1.048.576 linhas), J� come�a com 5 devido as linhas de cabecalho
	Local _nLastRec	:= (_cTmp01)->( LastRec() )
	Local _lPlanCSV	:= IsInCallStack("U_MGF34R02") .and. _nLastRec > SuperGetMV("MGF_BIREGI",   .F.,    274483 )		// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
	Local _cNmAbaPar	:= ""	// Nome da Aba de Parametros quando usada

	If len( _aDefinePl[3] ) > 1					// Se a planilha excel tiver duas ou mais abas, nao posso usar o FWMsExcelEx() 
		_oExcel		:= FWMsExcel():New()		// Quando  tem duas ou mais abas, nao posso usar o metodo antigo FWMsExcel()
		_oExcel:SetFontSize(10)					// Tamanho do fonte = 10
	Else
		_oExcel		:= FWMsExcelEX():New()
		_oExcel:SetUTF8Encode(.F.)			//oFwMsEx:SetUTF8Encode(.F.)     // Geronimo, retornar aqui quando Barbi atualizar a LIB do QA. Somente depois subir
		
		// Azul Claro      Decimal 153,217,234    Hexadecimal 99,D9,EA
		// Verde Escuro    Deimal   80,150,50     Hexadecimal 50,96,32

		//_oExcel:SetLineFrColor("#FF0000")
		//_oExcel:SetLineBgColor("#FF0000")
		//_oExcel:SetCelFrColor("#FFFFFF")		// Preto
		//_oExcel:SetCelBgColor("#D7BCFB")		// Roxo
		//_oExcel:Set2LineBgColor("#99D9EA")	// Azul Claro   
		//_oExcel:Set2LineFrColor("#509632")   	// Verde Escuro
		//_oExcel:Set2LineBold( .T. )
		//FWMsExcelEX():SetLineFrColor("#FF0000")
		//FWMsExcelEX():SetLineBgColor("#FF0000")
		//FWMsExcelEX():SetCelFrColor("#FFFFFF")		// Preto
		//FWMsExcelEX():SetCelBgColor("#D7BCFB")		// Roxo
		//FWMsExcelEX():Set2LineBgColor("#99D9EA")	// Azul Claro   
		//FWMsExcelEX():Set2LineFrColor("#509632")   	// Verde Escuro
		//FWMsExcelEX():Set2LineBold( .T. )

		FWMsExcelEX():Set2LineBgColor("#FF0000")	// Vermelho   

	Endif

	//dbSelectArea(_cTmp01)
	_nLastRec	:= (_cTmp01)->( LastRec() )
	_lPlanCSV	:= IsInCallStack("U_MGF34R02") .and. _nLastRec > SuperGetMV("MGF_BIREGI",   .F.,    274483 )		// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   

	Default ModoCrioPlan:= "FWMsExcelEx"

	MakeDir( "C:\EXCEL\" )			// For�o a criacao do "C:\EXCEL\" para que mesmo na primeira vez, do usuario, a linha abaixo retorne.T. se criou com sucesso. 
	If MakeDir( "C:\EXCEL\" )
		_cPastaGrv 	:= "C:\EXCEL\"	// Pasta onde sera gravado o arquivo excel em formato xml ou csv.
	Else
		_cPastaGrv 	:= GetTempPath(.T.)	// Pasta onde sera gravado o arquivo excel em formato xml ou csv. //Resultado: "C:\Users\user01\AppData\Local\Temp\"
	Endif

	// Apago as planilhas com o mesmo nome base do relatorio (sem a data e a hora) e com sufixo .x* (.xml, .xls, etc) ou .csv na pasta temporaria do usuario. 
	// Desde que, sejam  mais velhos do que 7 dias.
	If _lPlanCSV	// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
		aFiles := Directory(_cPastaGrv+_aDefinePl[2]+"*.csv" )
	Else
		aFiles := Directory(_cPastaGrv+_aDefinePl[2]+"*.x*" )
	Endif
	nCount := Len( aFiles )
	For nX := 1 to nCount
		If aFiles[nX,3] < Date() - 4					// Desde que, sejam  mais velhos do que 4 dias.
			Ferase(_cPastaGrv + aFiles[nX,1] )
		Endif
	Next nX

	// Apago as planilhas com o nome do relatorio e o sufixo .xml e .xls (ou .csv) na pasta \system do servidor Protheus
	If _lPlanCSV	// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
		aFiles := Directory( _aDefinePl[2]+"*.csv" )
	Else
		aFiles := Directory( _aDefinePl[2]+"*.x*" )
	Endif
	nCount := Len( aFiles )
	For nX := 1 to nCount
		Ferase( aFiles[nX,1] )
	Next nX

	If _nArqName == 0
		If _lPlanCSV	// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
			cNomePlani	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".csv"
   		Else
			cNomePlani	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".xml"
		Endif
		_nArqName++
		Aadd( _aArqName, cNomePlani)
		_cCriaabre	:= "CRIA_PLANILHA"

	ElseIf _nArqName == 1 .or. _nArqName == 2
		_nArqName++
		_cCriaabre	:= "REABRE_PANILHA"
		_cReabrePl	:=  _aArqName[1]

	ElseIf _nArqName > 2
		_nArqName++
		_cCriaabre	:= "REABRE_PANILHA"
		_aPlantela	:= {}
		For _nI := 1 to len(_aArqName)
			If File(_cPastaGrv + _aArqName[_nI])
				Aadd(_aPlantela , _aArqName[_nI] )
			Endif
		Next

		If Len(_aPlantela) > 0
			nList		:= Len(_aPlantela)					// O nList inicia com a ultima planilha criada
			_oDlg_ArqN	:= ""
			aItems		:= {}
			Aadd(_aPlantela , "Criar Nova Planilha" )
			DEFINE DIALOG _oDlg_ArqN TITLE "Selecione a planilha Excel que deseja abrir, ou selecione Criar nova planilha.  Depois, feche esta janela." FROM 010,010 TO 550,700 PIXEL
			For _nI := 1 to Len(_aPlantela)
				Aadd(aItems, _aPlantela[_Ni] )
			Next
			//oList1 := TListBox():New(001,001,{|u|if(Pcount()>0,nList:=u,nList)},aItems,100,100	,,_oDlg_ArqN	,,	,,.T.)	// // Usando o New
			oList1 := TListBox():New(001,001,{|u|if(Pcount()>0,nList:=u,nList)},aItems,350,250	,,_oDlg_ArqN	,,	,,.T., , { || _oDlg_ArqN:End() }      )	// // Usando o New
			DEFINE SBUTTON oBotao_Ok FROM 255,020 TYPE 1 ACTION (_oDlg_ArqN:End())		ENABLE OF _oDlg_ArqN	// linha.coluna
			ACTIVATE DIALOG _oDlg_ArqN CENTERED
			If nList	== Len(aItems)
				_cCriaabre	:= "CRIA_PLANILHA"
				
				If _lPlanCSV	// Se relatorio for o MGF34R02 e a query retornou mais registros que a memoria comporta ao gerar planilha pelo FWMsExcelEx, crio a planilha pelo metodo FWRITE900. Em testes o maximo suportado no MGF34R02 foram 274.483 registros (de 01/04/18 � 15/04/18) todas as filiais.   
					cNomePlani	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".csv"
				Else
					cNomePlani	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".xml"
				Endif

				Aadd( _aArqName, cNomePlani)
			Else
				_cCriaabre	:= "REABRE_PANILHA" 
				_cReabrePl	:=  _aArqName[nList]
			Endif

		Else
			_cCriaabre	:= "CRIA_PLANILHA"
		Endif

	Endif

	If _cCriaabre =="REABRE_PANILHA"
		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open(_cPastaGrv+_cReabrePl) 	// Comando que efetivamente ABRE a planilha na pasta da maquina local do usuario
		_oExcelApp:SetVisible(.T.)
		_oExcelApp:Destroy()								//Encerra o processo do gerenciador de tarefas
		Return												// Abandona a rotina e volta a tela do MsNewGetDados
	Endif

	If ModoCrioPlan == "FWMsExcelEx"		// Teclado o Botao "Gera Planilha Excel"

		For _nPosi_Aba	:= 1 to len(_aDefinePl[3])
			 
			If Empty(_aDefinePl[5]) .or. len(_aDefinePl[5]) < _nPosi_Aba
				Aadd(_aDefinePl[5] , {} )	
				_aDefinePl[5, _nPosi_Aba] := aClone(_aCampoQry)
			Endif
			If Empty(_aDefinePl[5,_nPosi_Aba])				
				_aDefinePl[5,_nPosi_Aba] := aClone(_aCampoQry)
			Endif 

		Next

		For _nPosi_Aba	:= 1 to len(_aDefinePl[3])
			_oExcel:AddworkSheet(_aDefinePl[3,_nPosi_Aba])							// Cria a Aba na Planilha
			_oExcel:AddTable(_aDefinePl[3,_nPosi_Aba], _aDefinePl[4,_nPosi_Aba])	// Cria a Tabela dentro da Aba

			For _nPosiColu := 1 to len(_aDefinePl[5, _nPosi_Aba])
				// Os campos numericos com casas decimais diferentes de 2 sao mostrado no excel com o tipo geral. Ou seja a coluna sera numerica e cada
				// c�lula ter� somente a quantidade de casas decimais necessarias, descartando os zeros irrelevantes. Ex 123,4000 sera mostrado como 123,4.
				If _aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTipo] == "N" .AND. _aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoDecim] <> 2	
				//						Aba/WorkSheet			,Tabela da aba				,Coluna											,Alinhamento(1-Left,2-Center,3-Right )	,	,	,	,Formato da celula (1-General,2-Number,3-Monet�rio,4-DateTime)											,Totaliza a coluna, ou nao (.T. /.F.)
					_oExcel:AddColumn( _aDefinePl[3,_nPosi_Aba]	,_aDefinePl[4,_nPosi_Aba]	,_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTitul]	,3										 ,	,	,	,1																																																																																																													,							,						,		,		,,	,	,	,.F.  )

				Else

					// Aqui formato as celulas tipo Data,caracter e numericos com 2 casas decimais. Nesta formata��o as 2 casas decimais, sempre sao mostradas
					// pois foram formatadas como 2=number. Infelizmente os numeros com quantidade de casas decimais diferente de 2 nao levam este tipo de 
					// formata�ao porque se assim o fossem, mostrariam sempre 2 casas decimais na celula.
					//					Aba/WorkSheet			,Tabela da aba				,Coluna											,Alinhamento(1-Left,2-Center,3-Right )																																																,		,			,,Formato da celula (1-General,2-Number,3-Monet�rio,4-DateTime)											,Totaliza a coluna, ou nao (.T. /.F.)
					_oExcel:AddColumn( _aDefinePl[3,_nPosi_Aba]	,_aDefinePl[4,_nPosi_Aba]	,_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTitul]	,If(_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTipo]=="N", 3,  If(_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTipo]=="D", 2, 1)  )	,If(_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTipo]=="N", 2, If(_aDefinePl[5,_nPosi_Aba,_nPosiColu,_nPoTipo]=="D", 4, 1) )			,.F. )
				Endif
			Next
		Next

		dbSelectArea(_cTmp01)
		(_cTmp01)->(Dbgotop())
		While (_cTmp01)->(!Eof())

			For _Ni	:= 1 to len(_aCpoExce)
				If Eval(_aDefinePl[6,_Ni] )
					Eval( _aCpoExce [_Ni] )
				Endif
			Next
			(_cTmp01)->(DbSkip())
			
		Enddo

		If Type( "_lComParam" ) <> "U" .And.  (_lComParam)	// RVBJ - 12/03/20
			_cNmAbaPar	:= "Parametros"

			_oExcel:AddworkSheet(_cNmAbaPar)				// Cria a Aba na Planilha
			_oExcel:AddTable(_cNmAbaPar, _aDefinePl[2])		// Cria a Tabela dentro da Aba

			_oExcel:AddColumn( _cNmAbaPar,_aDefinePl[2]	, _cNmAbaPar	, 1,1,.F. )
			_oExcel:AddColumn( _cNmAbaPar,_aDefinePl[2]	, "Conteudo"	, 1,1,.F. )

			_oExcel:AddRow(_cNmAbaPar, _aDefinePl[2] , {"Data de Emissao", DTOC(DATE()) }) 

			If Type( "_cCODFILIA" ) <> "U" .And.  ! Empty(	_cCODFILIA)
				// Ignoro os parenteses da variavel _cCODFILIA
				_oExcel:AddRow(_cNmAbaPar, _aDefinePl[2] , {"Filial", SUBS( _cCODFILIA, 4,LEN(_cCODFILIA)-6) }) 
			Endif
			If Type( "_cCODEMPRE" ) <> "U" .And.  ! Empty(	_cCODEMPRE)
				// Ignoro os parenteses da variavel _cCODEMPRE
				_oExcel:AddRow(_cNmAbaPar, _aDefinePl[2] , {"Empresa", SUBS( _cCODEMPRE, 4,LEN(_cCODEMPRE)-6) }) 
			Endif

			// Demais parametro(s)
			For _Ni	:= 1 to Len( _aParambox)
				If valtype( _aParambox[_Ni][3]) == "D"
					_oExcel:AddRow(_cNmAbaPar, _aDefinePl[2] , {_aParambox[_Ni][2],  dtoc(stod(_aRet[_Ni])) }) 
				Else
					_oExcel:AddRow(_cNmAbaPar, _aDefinePl[2] , {_aParambox[_Ni][2], _aRet[_Ni]}) 
				Endif
			Next

			//Aadd(_aDefinePl[6], {||.T.}			)
		Endif

		If !Empty(_oExcel:aWorkSheet)
			// Metodo anterior. A planilha excel era gerada diretamente na maquina do usuario, e al� aberta.
			//_oExcel:Activate()
			//_oExcel:GetXMLFile(_cPastaGrv+cNomePlani)
			//_oExcel:DeActivate()
			//_oExcelApp := MsExcel():New()
			//_oExcelApp:WorkBooks:Open(_cPastaGrv+cNomePlani)		// Abre uma planilha
			//_oExcelApp:SetVisible(.T.)
			//_oExcelApp:Destroy()

			// Metodo atual. A planilha excel � gerada no servidor Protheus, e copiado para a maquina do usuario, onde ela � aberta
			_oExcel:Activate()
			_oExcel:GetXMLFile(cNomePlani)
			_oExcel:DeActivate()	//	21/08/18 Geronimo

			inkey(.2)				//	21/08/18 Geronimo 

			CpyS2T("\SYSTEM\"+cNomePlani, _cPastaGrv)			// Copia a planilha da pasta System do servidor para a pasta da maquina local do usuario
			inkey(.5)
			_oExcelApp := MsExcel():New()
			inkey(.5)
			_oExcelApp:WorkBooks:Open(_cPastaGrv+cNomePlani) 	// Comando que efetivamente ABRE a planilha na pasta da maquina local do usuario
			_oExcelApp:SetVisible(.T.)
			_oExcelApp:Destroy()								//Encerra o processo do gerenciador de tarefas

		Else
			MsgStop("Nao h� dados para geracao da planilha.")
		EndIf

	ElseIf ModoCrioPlan == "FWRITE" .or. ModoCrioPlan == "FWRITE900"			// Teclado F11 ou F12  

		_aDefinePl[2]	:= NoAcento(_aDefinePl[2])

		// Apago as planilhas com o nome do relatorio e o sufixo .CSV na pasta temporaria do usuario
		aFiles := Directory(_cPastaGrv+_aDefinePl[2]+"*.CSV" )
		nCount := Len( aFiles )
		For nX := 1 to nCount
			Ferase(_cPastaGrv + aFiles[nX,1] )
		Next nX

		// Apago as planilhas com o nome do relatorio e o sufixo .CSV na pasta \system do servidor Protheus
		aFiles := Directory( _aDefinePl[2]+"*.CSV" )
		nCount := Len( aFiles )
		For nX := 1 to nCount
			Ferase( aFiles[nX,1] )
		Next nX

		cNomePlani	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".CSV"
		_nQtdCampo	:= len(_aCampoQry)

		For _nX := 1 to _nQtdCampo
			cNomeCampo	:= _aCampoQry[_nX,_nPoApeli] 
			cTituloCampo:= _aCampoQry[_nX,_nPoTitul]
			AADD(aCabExcel, {cNomeCampo ,_aCampoQry[_nX,_nPoTipo] })

			cLinGravar	+= cTituloCampo
			If _nX < _nQtdCampo
				cLinGravar	+= ";"
			Else
				cLinGravar	+= chr(13) + chr(10)
			Endif
		Next

		nArq_Name	:= fCreate(cNomePlani,0)										// Crio o arqvuivo CSV
		FWrite(nArq_Name, _aDefinePl[2] +chr(13) +chr(10), Len(_aDefinePl[2])+2)		// Gravo a linha com o nome da tabela
		FWrite(nArq_Name, Space(3)	+chr(13) +chr(10), 3+2				)		// Gravo uma linha em branco (Pulo linha na planilha)
		FWrite(nArq_Name, cLinGravar					,Len(cLinGravar)  )		// Gravo a linha de cabecalho dos campos

		dbSelectArea(_cTmp01)
		(_cTmp01)->(Dbgotop())
		cLinGravar	:= ""
		While (_cTmp01)->(!EOF())
			//aItem := Array(_nQtdCampo)
			//cLinGravar	:= ""
			For nX := 1 to _nQtdCampo
				IF aCabExcel[nX][2] == "C"
					//aItem[nX]	:= CHR(160)+ AllTrim( (_cTmp01)->&(aCabExcel[nX][1]) )
					cLinGravar	+= CHR(160)+ AllTrim( (_cTmp01)->&(aCabExcel[nX][1]) )
				ELSEIF aCabExcel[nX][2] == "D"
					//aItem[nX]	:= Dtoc(StoD((_cTmp01)->&(aCabExcel[nX][1]) ))
					cLinGravar	+= Dtoc((_cTmp01)->&(aCabExcel[nX][1]) )
				ELSEIF aCabExcel[nX][2] == "N"
					//cAux	 := Strtran(Alltrim(Str( (_cTmp01)->&(aCabExcel[nX][1]) ,20,2) ) , ".", "," ) 
					//aItem[nX] := cAux	// gravo valor sempre. Mesmo que seja 0,00		// //aItem[nX] := IIf(cAux == "0,00" , "" , cAux )		// No anterior, se fosse 0,00 grava nil
					cLinGravar	+= Strtran(Alltrim(Str( (_cTmp01)->&(aCabExcel[nX][1]) ,20,2) ) , ".", "," )
				ELSE
					//aItem[nX]	:= (_cTmp01)->&(aCabExcel[nX][1]) 
					cLinGravar	+= (_cTmp01)->&(aCabExcel[nX][1])
				ENDIF
				If nX < _nQtdCampo
					cLinGravar	+= ";"
				Else
					cLinGravar	+= chr(13) + chr(10)
				Endif

			Next nX
			n900linhas++
			_nLinhPlan++					// Incremento o contador de linhas gravadas na planilha

			If ModoCrioPlan == "FWRITE"			// No ModoCrioPlan == "FWRITE", gravo linha, a Linha. Por isto 
				n900linhas	:= 900				// A cada passagem. torno n900linhas := 900 para forcar a gravacao linha a linha, ao inves de a cada 900. 
			Endif

			If n900linhas > 899
				FWrite(nArq_Name, cLinGravar					,Len(cLinGravar)  )		// Gravo as linhas de registros da planilha
				n900linhas	:= 0
				cLinGravar	:= ""
			Endif
			
			If _nLinhPlan > 1048570				// Antes de gravar mais de 1.048.576 termino a gravacao, pois este � o limite de linhas do excel
				Exit
			Endif

			(_cTmp01)->(dbSkip())

		Enddo

		If n900linhas > 0															// Se for maior que 0, tenho linhas para gravar. Ent�o gravo-as. 
			FWrite(nArq_Name, cLinGravar					,Len(cLinGravar)  )		// Gravo as linhas de registros da planilha
			n900linhas	:= 0
			cLinGravar	:= ""
		Endif

		fClose(nArq_Name)

		CpyS2T("\SYSTEM\"+cNomePlani, _cPastaGrv)			// Copia a planilha da pasta System do servidor para a pasta da maquina local do usuario
		//inkey(.5)
		_oExcelApp := MsExcel():New()
		//inkey(.5)
		_oExcelApp:WorkBooks:Open(_cPastaGrv+cNomePlani) 	// Abre a planilha na pasta da maquina local do usuario
		//inkey(.5)
		_oExcelApp:SetVisible(.T.)
		_oExcelApp:Destroy()								//Encerra o processo do gerenciador de tarefas


	ElseIf ModoCrioPlan == "DLGTOEXCEL"			// Teclado F10

		_nQtdCampo	:= len(_aCampoQry)
		
		For _nX := 1 to _nQtdCampo
			cNomeCampo	:= _aCampoQry[_nX,_nPoApeli]
			nQtd_Decim	:= _aCampoQry[_nX,_nPoDecim]
			AADD(aCabExcel, {cNomeCampo ,_aCampoQry[_nX,_nPoTipo], _aCampoQry[_nX,_nPoTaman], nQtd_Decim})
		Next
		dbSelectArea(_cTmp01)
		(_cTmp01)->(Dbgotop())
		While (_cTmp01)->(!EOF())
			aItem := Array(_nQtdCampo)
			For nX := 1 to _nQtdCampo
				IF aCabExcel[nX][2] == "C"
					aItem[nX] := CHR(160)+(_cTmp01)->&(aCabExcel[nX][1])
				ELSE
					aItem[nX] := (_cTmp01)->&(aCabExcel[nX][1])
				ENDIF
			Next nX
			AADD(aItensExcel,aItem)
			aItem := {}
			(_cTmp01)->(dbSkip())
		Enddo

		For _nX := 1 to _nQtdCampo
			aCabExcel[_nX,_nPoNome]:=_aCampoQry[_nX,_nPoTitul]  //Troco o nome do campo, (Necessario no loop acima), pelo apelido, (mais amigvel na planilha)	
		Next

		MsgRun("Favor Aguardar.", "Exportando Registros para o Excel", {||DlgToExcel({{"GETDADOS", _aDefinePl[2], aCabExcel, aItensExcel}})})

	ElseIf ModoCrioPlan == "COPYTO"		// Neste caso, ModoCrioPlan == "DBF"  

		// https://forum.imasters.com.br/topic/400851-exportar-consulta-para-xls-ou-txt		// O comando spool, exporta para txt. Inclusive HTML e CSV:

		// Este exporta para html
		cExCopyHTM	:=	" set echo off " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET LINESIZE 20000 " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET VERIFY OFF " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET FEEDBACK OFF " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET PAGESIZE 20000 " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET MARKUP HTML ON ENTMAP ON SPOOL ON PREFORMAT OFF " + chr(13) + chr(10)
		cExCopyHTM	+=	" SPOOL <<caminho a exportar>>; " + chr(13) + chr(10)
		cExCopyHTM	+=	" select * from <<tabela>>  " + chr(13) + chr(10)
		cExCopyHTM	+=	" spool off; " + chr(13) + chr(10)
		cExCopyHTM	+=	" SET MARKUP HTML OFF ENTMAP OFF SPOOL OFF PREFORMAT ON " + chr(13) + chr(10)
		cExCopyHTM	+=	" exit; " + chr(13) + chr(10)

		//Este exporta para csv:
		cExCopyCSV	:=	' set echo off ' + chr(13) + chr(10)
		cExCopyCSV	+=	' set pagesize 50000 ' + chr(13) + chr(10)
		cExCopyCSV	+=	' set colsep ";" ' + chr(13) + chr(10)
		cExCopyCSV	+=	' set linesize 20000 ' + chr(13) + chr(10)
		cExCopyCSV	+=	' set trimout on ' + chr(13) + chr(10)
		cExCopyCSV	+=	' SPOOL <<caminho a exportar>>; ' + chr(13) + chr(10)
		cExCopyCSV	+=	' select * from <<tabela>> ' + chr(13) + chr(10)
		cExCopyCSV	+=	' spool off; ' + chr(13) + chr(10)
		cExCopyCSV	+=	' exit; ' + chr(13) + chr(10)

		//aRddDriver	:= {'DBFCDXADS','TOPCONN','BTVCDX','CTREECDX'}
		//cRdd == 'DBFCDXADS' )
		//cRdd := 'DBFCDXAX'
		//cRdd := 'DBFCDX'

		_cDatatime	:= "_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".DBF"

		_cArTXTSDF	:= "AAATXT_SDF" + _cDatatime + ".CSV"
		cNomePlani	:= _cArTXTSDF

		//COPY TO &_cArCDXADS		VIA "DBFCDXADS"		//	Invalid RDD DBFCDXADS - ADS Error - Could not load ACE32.dll
		//COPY TO &_cArCDXAX		VIA "DBFCDXAX"		//	Invalid RDD DBFCDXAX  - ADS Error - Could not load ACE32.dll
		//COPY TO &_cArCDX		VIA "DBFCDX"			// Data base files can only be created on the server
		//COPY TO &_cArTXTDEL 	DELIMITED WITH ";" 	//WITH ";"		//COPY TO &cNomePlani VIA "DBFCDX"	// Executa sempre no formato ctree, ou seja "DBFCDXADS"

		Copy To &_cArTXTSDF		SDF

		CpyS2T("\SYSTEM\"+ cNomePlani, _cPastaGrv)			// Copia a planilha da pasta System do servidor para a pasta da maquina local do usuario
		//inkey(.5)
		_oExcelApp := MsExcel():New()
		//inkey(.5)
		_oExcelApp:WorkBooks:Open(_cPastaGrv+cNomePlani) 	// Abre a planilha na pasta da maquina local do usuario
		//inkey(.5)
		_oExcelApp:SetVisible(.T.)
		_oExcelApp:Destroy()								//Encerra o processo do gerenciador de tarefas

		If .F.
			_cArqCabec	:= _cPastaGrv + "CABECALHO" + "_"+Dtos(date())+"_"+StrTran(Time(),":","") + "_xCabecalho.CSV"		// ".xCabecalho"
			_cArqRegis	:= _cPastaGrv + "REGISTROS" + "_"+Dtos(date())+"_"+StrTran(Time(),":","") + "_xRegistros.CSV"
			cNomePlani	:= _cPastaGrv + _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + "_Tudo.CSV"
			_cArqCopia	:= _aDefinePl[2]+"_"+Dtos(date())+"_"+StrTran(Time(),":","") + ".BAT"
			nArq		 := fCreate(_cArqCabec,0)					//		 Aqui eu crio o arquivo de cabecalho do CSV/Excel

			For _nI := 1 to len(_aCampoQry)
				cConteudo += StrTran( _aCampoQry[_nI,_nPoTitul] , " " , "_" )
				If _nI <> len(_aCampoQry)				// Apos o ultimo elemento nao coloco virgula. 
					cConteudo += ";"
				Endif
			Next
			cConteudo += CHR(13) + CHR(10) 
			FWrite(nArq,cConteudo,Len(cConteudo))
			fClose(nArq)

			dbSelectArea(_cTmp01)		//		 Aqui eu crio o arquivo de Registros do CSV/Excel
			(_cTmp01)->(Dbgotop())
			COPY TO &_cArqRegis DELIMITED WITH ";" 	//WITH ";"		//COPY TO &cNomePlani VIA "DBFCDX"	// Executa sempre no formato ctree, ou seja "DBFCDXADS" 
			//ShellExecute(< cAcao >, < cArquivo >			,< cParam >, < cDirTrabalho >, [ nOpc ] )
			Comand_DOS	:= "COPY " + _cArqCabec + " + " + _cArqRegis + " " + cNomePlani
			nArq_Copia	:= fCreate(_cArqCopia,0)				//		 Aqui eu Copio, juntando o arquivo de cabecalho. com o arquivo de registros, craindo o arquivo CSV/Excel final
			FWrite(nArq_Copia,Comand_DOS,Len(Comand_DOS))
			fClose(nArq_Copia)
			shellExecute("Open", _cArqCopia , " " , "_cPastaGrv" , 1 )	 
			inkey(.2)		// Verificar comando WaitRun()

			//CpyS2T("\SYSTEM\"+_cArqCabec, _cPastaGrv)	// Copia a planilha da pasta System do servidor para a pasta da maquina local do usuario
			inkey(.3)

			//Aqui eu Abro pelo excel, o arquivo CSV criado.		//ShellExecute(< cAcao >, < cArquivo >			,< cParam >, < cDirTrabalho >, [ nOpc ] )
			inkey(.5)
			ShellExecute("open","excel.exe", cNomePlani , "",5)

		Endif 

	EndIf

Return Nil

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
���Programa  �ParameRe  �Autor  �Geronimo Benedito ALves			� Data �  19/01/2018	���
���������������������������������������������������������������������������������������͹��
���Desc.		� Monta a tela para obter os parametros da query que ira gerar o relatorio ���
���			� Tambem alimenta com conteudo validos as variaveis 						���
���			� Tambem alimenta as variaveis _bCpoExce e _cQuery							���
���			�																			���
���������������������������������������������������������������������������������������͹��
���Uso		� AP																		���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
*/

User function ParameRe(_aParambox, _bParameRe, _aRet )
	Local lRet	:=.T.
	Local _nI	:= 0

	//_nColunas	:= Len(_aCampoQry)
	_cTmp01		:= GetNextAlias() 

	SetKey( K_CTRL_F8 , {|| U_BIEmlini("Bi_e_Protheus") })		// teclado CTRL+F8 (Codigo inkey -27), executa a funcao que ira alimentar a array, para o envio do email com a query do relatorio para a equipe de desenvolvimento do B.I. e do Protheus.
	SetKey( K_CTRL_F9 , {|| U_BIEmlini("Protheus") })			// teclado CTRL+F9 (Codigo inkey -28), executa a funcao que ira alimentar a array, para o envio do email com a query do relatorio para a equipe de desenvolvimento			do Protheus.
	If Len(_aParambox) > 0
		lRet := ParamBox(_aParambox, _aDefinePl[2], @_aRet	,,	,,	,,	,,.T.,.T. )	// Executa funcao PARAMBOX p/ obter os parametros da query que gerar� o relatorio
	Endif
	SetKey( K_CTRL_F8 , {||} )	// Cancela a associacao da tecla CTRL + F8 (Codigo inkey -27) , � funcao que ira enviar o email com a query do programa para a equipe de desenvolvimanto do B.I  e do Protheus.
	SetKey( K_CTRL_F9 , {||} )	// Cancela a associacao da tecla CTRL + F9 (Codigo inkey -28) , � funcao que ira enviar o email com a query do programa para a equipe de desenvolvimanto de B.I	do Protheus.

	If !lRet
		MsgInfo("Cancelado pelo usuario")
		Return lRet
	Endif

	If Empty(_bParameRe)
		For _nI := 1 to len(_aRet)
			If Valtype(_aRet[_nI]) == "D"
				_aRet[_nI]	:= Dtos(_aRet[_nI])
			Endif
		Next
	Endif

	If !Empty(_bParameRe)
		Eval( _bParameRe )		// Ajusta os parametros digitados, Exemplo: colocar Executar, nas variaveis de Data, executar Alltrim nas variaveis que serao usadas na cluasula like da query, etc.
	Endif

	U_Traacpoq()

	_cQuery		:= U_CpoQuery()	// FUNCAO QUE cria a parte da query referente � selecao dos campos. 
	_aCpoExce	:= U_CpoExcel()	// Funcao que cria a array com o(s) code block(s) que ira(�o) gerar as linhas de detalhe da(s) aba(s) da planilha excel, baseado no registro da tabela temporaria sobre a qual o ponteiro esteja posicionado. A formata��o � definida pelo array _aCampoQry

Return lRet



/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � BNomeCpo �Autor  �Geronimo Benedito Alves																	 �Data �31/01/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.    � Retorna o nome do campo, baseado no elemento _nPoNome do _aCampoQry. Se o elemento conter apenas o nome do campo, retorna-o.   ���
���			� Se conter a expressao "as", retorna o apelido � direita do "as", dentro do elemento.											 ���
���			� 											                                                                                     ���
���			� OBS. Se o nome do campo/apelido for maior que 10 bytes fa�o um tratamento criando ou alterando o apelido com um novo nome,     ���
���			�      com o tamanho de 10 bytes                                                                                                 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																												 ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������  /*/
User Function BNomeCpo(_nI, _cNomCpQry, _aCampoQry )
	Local nPosicao		:= 0
	Local cNomCpoOri	:= Upper(StrTran(_aCampoQry[_nI,_nPoNome], "	"," "))  //Primeiro pelo StrTran substituo tabulacoes por espacos. Depois deixo tudo em maiusulo.
	Local cNomCpoRet	:= ""
	Local _nJ			:= 0
	
	// Variavel Static que conta quantas vezes � encontrado um nome/apelido de campo com mais de 10 bytes, e que depois de tratado para ter s� 10 bytes, 
	// conflita o seu nome com o de outro nome de campo j� usado.
	// Um novo nome para o campo/apelido � criado com os primeiros 8 caracteres do nome, mais este contador devido ao limite de tamanho de nome de campos
	Static _cQNomeGra	:= "00"	
	Static aNomCpoRet	:= {}		// Variavel Static que armazena os nomes de campos utilizados na query
	Default _cNomCpQry	:= ""		// Retorna o nome real do campo na query. (antes de ganhar o apelido criado pelo " as " )	 

	cNomCpoOri	:= StrTran(cNomCpoOri, CRLF ," ")  		// Substituo CRLF (chr(13)+ chr(10) por " " 
	cNomCpoOri	:= StrTran(cNomCpoOri,"  "," ")  		// Substituo 2 ou mais espacos seguidos por apenas um espaco seguido. 1� execucao
	cNomCpoOri	:= StrTran(cNomCpoOri,"  "," ")  		// Substituo 2 ou mais espacos seguidos por apenas um espaco seguido. 1� execucao (Preciso executar este comando 2 vezes para solucionar a ocorrencia de varios espa�os, um do lado do outro.)

	//nPosicao	:= Rat( cNomCpoOri , " AS "	)			// Nao funcionou, esta linha de procura de "as" ladeado por Espa�os em ambos os lados

	If " AS " $  cNomCpoOri
		For _nJ := 1 to Len(cNomCpoOri)
			if " AS " $  Subs(cNomCpoOri, _nJ , Len(cNomCpoOri) )
				nPosicao := _nJ
			Else
				Exit
			Endif
		Next -1
	Endif
	If nPosicao == 0			// Nao tem apelido 		(Nao tem " AS ")

		//If Empty(_cNomCpQry)
		//	_cNomCpQry	:= _aCampoQry[_nI,_nPoCpoX3]		// Quando o nome do campo da query vem vazio, assumo o nome do campo no SX3
		//	cNomCpoRet	:= _aCampoQry[_nI,_nPoCpoX3]		// Quando o nome do campo da query vem vazio, assumo o nome do campo no SX3
		//Else
		//	_cNomCpQry	:= Alltrim(cNomCpoOri)		// Nao tem apelido, entao retorno o nome do campo na query
		//	cNomCpoRet	:= Alltrim(cNomCpoOri)		// Nao tem apelido, entao retorno o nome do campo na query
		//Endif

		_cNomCpQry	:= Alltrim(cNomCpoOri)		// Nao tem apelido, entao retorno o nome do campo na query
		cNomCpoRet	:= Alltrim(cNomCpoOri)		// Nao tem apelido, entao retorno o nome do campo na query
	Else
		_cNomCpQry	:= Alltrim( Subs(cNomCpoOri, 1, nPosicao  )  )		// Obtenho o nome real    da coluna. Que esta antes  do " as "
		cNomCpoRet	:= Alltrim( Subs(cNomCpoOri, nPosicao + 4 )  )		// Obtenho o nome apelido da coluna. Que esta depois do " as "
	Endif
	
	If Len(cNomCpoRet) > 10
	
		If  AScan( aNomCpoRet, Left(cNomCpoRet,10) ) == 0	// Verifico se os primeiros 10 caracteres do campo, ainda nao foram usados para nomear um outro campo anterior
			cNomCpoRet	:=     Left(cNomCpoRet,10) 			// Se nao foi usado ainda, uso os 10 primeiros caracters para nomear o campo
			aAdd( aNomCpoRet, cNomCpoRet )		// Armazeno o nome do campo na array de controle de nome de campos criados
		Else		
	   		_cQNomeGra	:= Soma1( _cQNomeGra , 2 )
			cNomCpoRet	:= Subs(cNomCpoRet,1,8)+ _cQNomeGra // Caso j� usado, uso os 8 primeiros caracteres mais o contador _cQNomeGra  (01,02,03,etc) 	
			aAdd( aNomCpoRet, cNomCpoRet )		// Armazeno o nome do campo na array de controle de nome de campos criados
		Endif
			
		// Aqui trato para o elemento _nPoNome ficar compativel com o apelido do campo. Isto por que o apelido e' ajustado na funcao U_BNomeCpo
		// Quando o nome ou apelido tiver um tamanho maior que 10 bytes.	
		If nPosicao == 0			// Nao tem apelido 		(Nao tem " AS ")
			_aCampoQry[_nI,_nPoNome]	:= cNomCpoOri + " AS " + cNomCpoRet
		Else
			_aCampoQry[_nI,_nPoNome]	:= subs( cNomCpoOri, 1, nPosicao) + " AS " + cNomCpoRet
		Endif
		
	Else 
		aAdd( aNomCpoRet, cNomCpoRet )		// Armazeno o nome do campo na array de controle de nome de campos criados
	Endif
	
Return cNomCpoRet

/*/  
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � Quit 	�Autor  �Geronimo Benedito Alves																		�Data �10/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.		� nenhuma rotinas de fechamento de arquivo/tabela � executada, o que pode causar perda informacao que nao tenha sido confirmada ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																											���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������  /*/

User Function Quit()
 
__Quit()
 
Return( Nil )


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � BIEmlini �Autor  �Geronimo Benedito Alves																		�Data �11/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.		� Devido ao acionamento simultaneo das teclas CRTL+F8 ou CTRL+F9, (codigo inkey -28), no momento da digitacao dos parametros	���
���			� do relatorio a array _aEmailQry � alimentada (inicializada), permitindo assim o envio de e-mail contendo a query do relatorio ���
���			� para depura��o e conferencia do programa fonte																				���
���			� Se for Teclado CRTL+F8, sera enviado � equipe de desenvolvimento do Protheus													��� 
���			� Se for Teclado CRTL+F9, sera enviado � equipe de desenvolvimento de B.I. e do Protheus										��� 
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���_aEmailQry� _aEmailQry[1] := Email dos destinatarios do e-mail separados por virgula														���
���			� _aEmailQry[2] := Subject do e-mail																							���
���			� _aEmailQry[3] := Corpo do e-mail com a Descricao e a query																	���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																											���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������  /*/

User Function BIEmlini(_cEquipe)

	Local _cTexto	:= "Query do programa "+FunName()+ " - "+FunDesc()+" , para analise. Usuario "+ UsrRetName ( RetCodUsr ( ) ) +" , ambiente "+GetEnvServer() + " .			"
	
	_aEmailQry	:= {}	// Limpo a array para alimenta-la

	AVISO( "Foi teclado CTRL+F8 ou CTRL+F9", "O acionamento simultaneo das teclas CTRL+F8 ou CTRL+F9, executa a rotina de envio da query do relatorio por e-mail."+CRLF+CRLF  + "CTRL+F8 envia o e-mail para a equipe de desenvolvimento B.I. Cliente e Protheus." +CRLF+CRLF  + "CTRL+F9 envia o e-mail para a equipe de desenvolvimento Protheus.", , 3 )
	If _cEquipe == "Bi_e_Protheus"
		//Aadd(_aEmailQry, GetNewPar("MGF_BIEML1","geronimoalves@gmail.com;geronimo.alves@dwcconsult.com.br; ricardo.pinheiro@dwcconsult.com.br; paulo.sousa@marfrig.com.br; priscilla.sombini@marfrig.com.br; stefano.brisotto@marfrig.com.br " ) )
		Aadd(_aEmailQry, GetMv("MGF_BIEML1") )

	Else		// _cEquipe == "Protheus"
		//Aadd(_aEmailQry, GetNewPar("MGF_BIEML2","geronimoalves@gmail.com;geronimo.alves@dwcconsult.com.br;ricardo.pinheiro@dwcconsult.com.br " ) )
		Aadd(_aEmailQry, GetMv("MGF_BIEML2") )
	Endif
	Aadd(_aEmailQry, _cTexto  )
	Aadd(_aEmailQry, _cTexto + CRLF  )
		
Return


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � BIEnvEml �Autor  �Geronimo Benedito Alves																		�Data �12/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.		� Funcao padrao de envio de e-mail para as rotinas de B.I. Ela recebe os parametros abaixo e efetua o envio do e-mail			���
���			� parametro 01 -  _cPara		: char, destinarario(s) do e-mail																	���
���			� parametro 02 -  _cSubject  : char, titulo/Subject do e-mail																	���
���			� parametro 03 -  _cCorpo	: char, Corpo do E-mail contendo a query															���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso		� Cliente Global Foods																											���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������  /*/
User Function BIEnvEml(_cPara ,_cSubject, _cCorpo)

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:=.T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail	:= GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail	:= GETMV("MGF_EMAIL")	// paulo.sousa@marfrig.com.br
	Local cErrMail
	
	nMailPort := GETMV("MGF_PTMAIL")
	
	oMail := TMailManager():New()
	
	if nParSmtpP == 25
		oMail:SetUseSSL(.F. )
		oMail:SetUseTLS(.F. )
		//oMail:Init("", cSmtpSrv, cCtMail, cPwdMail	,, nParSmtpP)
		oMail:Init("", cSmtpSrv, "", ""	,, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL(.T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail	,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS(.T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail	,, nSmtpPort)
	endif
	
	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()
	
	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail :=.F.
		Return (lRetMail)
	Endif
	
	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail :=.F.
			Return (lRetMail)
		Endif
	Endif
	
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom					:= cEmail
	oMessage:cTo					:= _cPara
	oMessage:cCc					:= ""
	oMessage:cSubject				:= _cSubject
	oMessage:cBody					:= _cCorpo

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_cArqAnexo := CriaTrab(NIL, .F.) + ".txt"	
    Private nHandle := FCREATE("\" + _cArqAnexo)
  
    if nHandle = -1
        MsgStop("Erro ao criar arquivo - ferror " + Str(Ferror()))
    else
        FWrite(nHandle, _cCorpo + CRLF)
        FClose(nHandle)
        
		xRet := oMessage:AttachFile( _cArqAnexo )
		if xRet < 0
			cMsg := "Could not attach file " + _cArqAnexo
			//conout( cMsg )
			MsgStop( cMsg )
		endif
    endif

/*/	
	_cArqAnexo := CriaTrab(NIL, .F.)	
	lRetMemowrite := MemoWrite( _cArqAnexo, _cCorpo )
	If lRetMemowrite
		xRet := oMessage:AttachFile( _cArqAnexo )
		if xRet < 0
			cMsg := "Could not attach file " + _cArqAnexo
			//conout( cMsg )
			MsgStop( cMsg )
		endif
	endif
/*/	
	
	nErro := oMessage:Send( oMail )
	
	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail :=.F.
		Return (lRetMail)
	Endif
	
	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()
	
	IF FERASE("\" + _cArqAnexo) == -1
		MsgAlert("Erro na elimina��o do arquivo anexado ao e-mail do disco. Erro n� " + STR(FERROR()))
	ELSE
		//MsgAlert("Arquivo anexado ao e-mail eliminado do disco!" )		// Nao precisa aparecer esta mensagem ao usuario. Exceto em Debug
	ENDIF

Return


//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � WhereAnd	�Autor  � Geronimo Benedito Alves																	�Data �  01/08/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que recebe cada linha da clausula Where da query, trata-a e a devolve. A regra deste tratamento �:                        ���
//���			� - Recebe a variavel _lIncluiLi, se ela for .T., esta linha deve ser adicionada � query, se for .F., a linha nao deve ser incluida���
//���			� - � cada linha � adicionada em seu inicio o comando "Where" ou "And" conforme necessario e de acordo com os parametros do usuario ���
//���			� - � cada linha � adicionada em seu Final o comando CRLF que � o salto de linha                                                   ���
//���			� - Se a linha contiver o comando LIKE, no conteudo do aRet[XX] usado nesta linha sera efetuado o comando AllTrim()                ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function WhereAnd( _lIncluiLi , _cLinWhere )
	Local _nI			:= 0
	Local _cLetra		:= ""
	Local _cLinhaAux	:= ""
	Local _nPartLike	:= 1		// 0=Come�o da linha, 1=dentro do like (entre o primeiro % e segundo %) 3=fim da linha (depois do segundo %)

	If Valtype(_lIncluiLi) == "L" .and. _lIncluiLi
	

		// Para melhorar esta fun�ao, preciso retirar o upper da lina abaixo e substitui-la por um for next que usando uma variavel auxiliar substitui 
		// os Where e And por ma�usculos 
		_cLinWhere := Upper(_cLinWhere)
		_cLinWhere	:= StrTran(_cLinWhere,"	"," ")  			// Substituo tabulacoes por espacos.
		
		If Subs(Alltrim(_cLinWhere),1,5) == "WHERE"					// Tiro o WHERE original da query, pois isto sera feito dinamicamente em tempo de execucao, conformme os parametros preenchidos pelo usuario 
			_cLinWhere	:= STRTRAN( _cLinWhere, "WHERE", "", 1, 1 )
		Endif
	
		If Subs(Alltrim(_cLinWhere),1,3) == "AND"					// Tiro o AND   original da query, pois isto sera feito dinamicamente em tempo de execucao, conformme os parametros preenchidos pelo usuario 
			_cLinWhere	:= STRTRAN( _cLinWhere, "AND", "", 1, 1 )
		Endif
	
		_cWhereAnd	:= Iif(_cWhereAnd == "" , " WHERE " , " AND " )		// Na primeira condicao da query � inserido WHERE, nas demais � inserido AND
		_cLinWhere	:= _cWhereAnd + _cLinWhere							// Insiro o Where ou o And no inicio da linha
		
		If " LIKE " $ _cLinWhere
			For _nI := 1 to len(_cLinWhere)
				_cLetra := Subs(_cLinWhere,_nI,1)

				If _nPartLike == 2
					If _cLetra <> Space(1)			// Tiro os espacos do like.  (do _aRet[XX] )
						_cLinhaAux	+= _cLetra
					Endif
					
					If _cLetra == "%"				// Se encontrei o segundo %, passei para a parte final da linha (parte 3) 
						_nPartLike := 3
					Endif
				Else
					_cLinhaAux	+= _cLetra
				Endif
				
				If " LIKE " $ _cLinhaAux .AND. "%"  $ _cLinhaAux .AND. _nPartLike == 1
					_nPartLike := 2
				Endif
			Next   

			_cLinWhere := _cLinhaAux                   

		Endif

		_cLinWhere += CRLF		// Insiro um salto de linha ao final dela
		
	Else
		_cLinWhere	:= ""		// retorno vazio quando nao devo incluir esta linha
	Endif
	
Return _cLinWhere 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkProd  � Autor �Geronimo B Alves	 � Data �   13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Monta uma tela de markbrowse, mostrando os Produtos         ���
���			� selecionados pela query recebida por parametro, nos campos ���
���			� tambem recebidos por parametro, para que o usuario marque  ���
���			� quais serao processadas									���
�������������������������������������������������������������������������͹��
���Parametros� _cQuery		- Query para selecao dos registros			���
���			� aCpoMostra[1] - Campo a ser mostrado						���
���			� aCpoMostra[2] - Titulo do Campo							���
���			� aCpoMostra[3] - Tamanho do Campo em caracteres				���
���			� cTitulo		- Titulo dq tela de selecao					���
���			� nPosRetorn	- Numero da posicao do campo na MarkBrowse	���
���			�				- que sera retornado. Ex. Pode ser retornado ���
���			�				- o primeiro, segundo, terceiro ou outro		���
���			�				- campo do MarkBrowse						���
���			� _lBtnCance	- Parametro recebido como referencia. Define se deve(.T.) ou  nao deve(.F.) cancelar todo o processamento caso o usuario ���
���			�					clicar no Botao cancelar. O _lBtnCance � visivel no programa chamador e se retornou como.T., indica que o Botao		���
���			�					foi teclado. Ent�o o programa deve ser finalizado																		���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarkProd(_cQuery, aCpoMostra, cTitulo, nPosRetorn, _lCancProg )
	Local aArea			:= GetArea()
	Local _nRecno		:= Recno()
	Local _cTmp01		:= GetNextAlias()
	Local aListMarca	:= {}
	Local nLinEncont	:= 0
	Local aEncontrad	:= {}
	Local aLinhaAux		:= {}
	Local lExibe		:= .T.
	Local nI 			:= 0
	Local nOpc  		:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo		:= { }
	Local aTam			:= { }
	Local oSay
	Local oDlg
	Local nListTam1		:= 600	//400					//380	//340	//280	//250
	Local nListTam2		:= 230					//220	//200	//170
	Local nI
	//	Nesta versao, a variavel lChk � criada como private no MGF06R20 para ser tratada l�, caso retrne marcada.		  
	Local _nI			:= 0
	Local oButProd		:= ""

	Private aList		:= {}
	Private oListBox

	Private _oCodProdu, _oDesProdu
	Private _cCodProdu	:= Space(tamSx3("B1_COD")[1])
	Private _cDesProdu	:= Space(tamSx3("B1_DESC")[1])

	Private _lCodProdu	:= .T. 			// Na Come�a a digitacao por codigo, e nao Descricao de Produto
	Private _nPosCpCHK	:= 2			// Posicao do campo a checar no array. Pode ser 2 para por Codigo, ou 3 por Descricao
	Private _cUltiDesc	:= "XYZXYZABCD" + Space(tamSx3("B1_DESC")[1]-10) 	// Ultima Descricao pesquisada. Se for a mesma da atual, pesquisa a partir da proxima linha. Se for outr, pesquisa a partir da linha 1

	cTitulo  			:= OemToAnsi(cTitulo)

	Aadd(aTitulo, " " )								// {" ", "Codigo", "Empresa", " " }
	Aadd(aTam	, 120  )									// {10, 30, 200, 01 }
	For _nI := 1 to len(aCpoMostra)
		Aadd(aTitulo, aCpoMostra[_nI,2] )			// Titulo do campo {" ", "Codigo", "Empresa", " " }
		Aadd(aTam	, aCpoMostra[_nI,3] * 1 )		// Tamanho do campo em Pixel {10, 30, 200, 01 } Em media, o Aria 12 tem a largyra de 11 pixel para cada letra
	Next

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf
	dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),_cTmp01,.T.,.F.)
	dbSelectArea(_cTmp01)
	dbGoTop()

	If !eof()
		dbGoTop()
		While !eof()
			aLinhaAux		:= {}
			Aadd(aLinhaAux,  .F. )
			For _nI := 1 to len(aCpoMostra)
				//If _ni := 1															// Na Coluna B1_COD
				//	If AllTrim( &(aCpoMostra[_nI,1]) ) $ "817979/758711/855659"	// Se encontrado algum destes produtos
				//		aLinhaAux[1] := .T.											// Marca-o como selecionado
				//	Endif 
				//Endif 
			
				Aadd(aLinhaAux	,&(aCpoMostra[_nI,1]) )
			Next	
			Aadd(aLinhaAux	," " )
			Aadd(aList , aLinhaAux )
			DbSkip()
		Enddo
	Else
		MsgStop( "Nao foi encontrado nenhum registro para montar esta tela de selecao de registros" )
		Aadd(aEncontrad , " " )
	Endif										

	//������������������������������������������������������������������������Ŀ
	//� Monta a tela de selecao dos arquivos a serem importados				�
	//��������������������������������������������������������������������������
	If Len(aList) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 040,160 OF oMainWnd		// 040,100 OF oMainWnd
		@ 03,  05 Say "No relatorio, sempre serao listados, por padrao, ao menos os produtos 817979, 758711 e 855659. Por isto, eles nao aparecem na selecao abaixo "    of oDlg Pixel
		//@ 07,  15 Say "Tecle <F7> para pesquisar/Marcar os produtos "    of oDlg Pixel
	
		If Len(aTitulo) == 2
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 3
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) > 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]), OemtoAnsi(aTitulo[5])  SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		Endif

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aList)
		oListBox:aColSizes := aTam

		If Len(aTitulo) == 2
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2] }}
		ElseIf Len(aTitulo) == 3
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3]}}
		ElseIf Len(aTitulo) == 4
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4]}}
		ElseIf Len(aTitulo) > 4	
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), aList[oListBox:nAt,2], aList[oListBox:nAt,3], aList[oListBox:nAt,4], aList[oListBox:nAt,5]}}
		Endif

		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aList, oListBox ) })			// Cria a associacao da tecla F4, � funcao MarcaTodF4()
		SetKey(VK_F7,{|| F7_Produto( @lChk, oChk ) })						// Cria a associacao da tecla F7, � funcao F7_Produto()

		@ 250, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aList, oListBox )

		@ 250, 130 BUTTON	oButInv Prompt '&Inverter'  Size 30, 12 Pixel        Action ( InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ) Message 'Inverter Selecao' Of oDlg	
		DEFINE SBUTTON oBtnOk	FROM 250,180 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnCan	FROM 250,220 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg	
		@ 250, 290 BUTTON	oButProd Prompt '&Pesquisar Produto <F7>'  Size 60, 12 Pixel Action ( F7_Produto( @lChk, oChk )  ) Message 'Procura Produto' Of oDlg	

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )					// Cancela a associacao da tecla F4, � funcao MarcaTodF4()	//Keyboard chr(27)
		SetKey( VK_F7 , {||} )					// Cancela a associacao da tecla F7, � funcao F7_Produto()

		If nOpc == 0
			aList := {}
			If _lCancProg				// Se deve abandonar processamanto caso clique no Botao cancelar, e ele foi cancelado (nOpc == 0) 
				_lCancProg	:= .T.		// Cancelar o programa
				MsgStop("Processamento foi cancelado pelo usuario")
			Else
				_lCancProg	:=.F.		// Nao cancelar o programa. Foi clicado o Botao cancelar, porem o parametro _lCancProg recebido diz para nao abandonar o programa se isto ocorrese, mas somente limpar/desconsiderar as marca��es  
			Endif
		Else
			_lCancProg	:=.F.			// Nao cancelar o programa. Nao foi clicado o Botao cancelar. 
		Endif
	Endif

	If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] ==.T.}) <= 0
		//Aviso("Inconsist�ncia", "Nao foi selecionado nenhum registro. ",{"Ok"}	,,"Atencao:")
		aList := {}
	EndIf

	For _nI := 1 to len(aList)
		If aList[_Ni,1]
			If ValType( aList[_Ni,nPosRetorn + 1] ) == "C"
				//  No retornco de campos caracteres retiro os espa�os. Se o registro esta vazio retorno Space(1), pois no Oracle a clausula In 
				//  nao encontra o conteudo ""
				If Empty( aList[_Ni,nPosRetorn + 1] )
					aList[_Ni,nPosRetorn + 1]	:= Space(1)
				Else
					aList[_Ni,nPosRetorn + 1]	:= AllTrim( aList[_Ni,nPosRetorn + 1])
				Endif
			Endif
			
			Aadd(aListMarca, aList[_Ni,nPosRetorn + 1] )	// nPosRetorn eh o campo que desejo retornar.  Aqui, Somo 1, devido ao campo para checkbox que foi incluido no come�o de cada linha.
		Endif
	Next

	If lChk						// Se Marquei listar todos
		aListMarca	:= {}		// Deixo o array de marcacao vazio, para nao implementar o filtro.
	Endif

	DbGoto(_nRecno)
	RestArea(aArea)
Return aListMarca


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F7_Produto �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Ao ser teclado F7, abre janela para localizar e marcar      ���
���			� produto pesquisando-o atraves do Codigo ou da Descricao     ���
���			� Chamo a consulta padrao do SB1 de forma automatica colocando���
���			� a tecla F3 no teclado atraves do comando Keyboard chr(114)  ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F7_Produto( lChk, oChk  )

Local _nI := oListBox:nAt
local oDlgPesq 	// , oBtOk , oBtCan, oOrdem, oBtPar
Local oBuSemacao
//Local oButMarca, oButDesMar
Local nOpcao 
nOpcao := 0
//Local cOrdem
//Local aOrdens := {}
//Local nOrdem := 1

//AAdd( aOrdens, "Codigo" )
//AAdd( aOrdens, "Descricao" )

SetKey(VK_F7,{|| MarcaDesma() })						// Cria a associacao da tecla F7, � funcao MarcaDesma()
SetKey(VK_F8,{|| Codig_Desc( ) })						// Cria a associacao da tecla F8, � funcao Codig_Desc()

DEFINE MSDIALOG oDlgPesq TITLE "Digite o Codigo, ou a Descricao do produto" FROM 00,00 TO 140,360 PIXEL			// 100,500  // 050,200  // 075,300
  @ 002, 002 Say    "Digite o Codigo ou a Descricao do Produto a ser Pesquisado ou Marcado" of oDlgPesq Pixel

  @ 020, 002 Say    "Codigo    :" of oDlgPesq Pixel
  @ 020, 040 MSGET  _oCodProdu VAR _cCodProdu Picture "@!" SIZE 070,09   F3 "SB1"    Valid chkCodProd( ) When .T. OF oDlgPesq PIXEL	//When WhenCodigo() OF oDlgPesq PIXEL

  @ 035, 002 Say    "Descricao :" of oDlgPesq Pixel
  @ 035, 040 MSGET  _oDesProdu VAR _cDesProdu Picture "@!" SIZE 120,09               Valid chkDesProd( ) When .T. OF oDlgPesq PIXEL	//When WhenDescri() OF oDlgPesq PIXEL

  @ 050, 002 Say    "Tecle F7 para Marcar ou Desmarcar a Linha Atual."          of oDlgPesq Pixel
  @ 060, 002 Say    "Tecle F8 para alternar pesquisar por Codigo ou pesquisar por Descricao." of oDlgPesq Pixel
  @ 050, 300 BUTTON	oBuSemacao Prompt ' ' Size 001, 001 Pixel Action ( nOpcao := 99  ) Message ' ' // Of oDlgPesq	

  //@ 030, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
  //@ 005,150 BUTTON	oButMarca  Prompt '&Marca/Desmarca a Linha Atual'    Size 100, 12 Pixel Action ( nOpcao := 1 , MarcaDesma() ) Message 'Marca/Desmarca o Produto da linha atual'    // Of oDlgPesq
  //@ 020,170 BUTTON	oButDesMar Prompt '&Desmarca Linha Atual' Size 70, 12 Pixel Action ( nOpcao := 0 , DesmarcaPr() ) Message 'Desmarca o Produto da linha atual' // Of oDlgPesq	
  //DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  //DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN.F. OF oDlgPesq PIXEL

	If	_lCodProdu						// Se atualmente esta configurado para digitacao por codigo.
		_oCodProdu:LVISIBLECONTROL	:= .T.
		_oCodProdu:SetFocus()
		_oDesProdu:LVISIBLECONTROL	:= .F.
	
	Else
		_oCodProdu:LVISIBLECONTROL	:= .F.
		_oDesProdu:LVISIBLECONTROL	:= .T.
		_oDesProdu:SetFocus()
	
	Endif
	
ACTIVATE MSDIALOG oDlgPesq //CENTER

SetKey(VK_F7,{|| F7_Produto( @lChk, oChk ) })						// Cria a associacao da tecla F7, � funcao F7_Produto(), que eera a funcao original da F7
SetKey(VK_F8,{||  })												// Desfaz a associacao da tecla F8, � Qualquer funcao

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TeclaF3 �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Insiro a tecla F3 no teclado, para o Get chamar a consulta  ���
���			� padrao SB1 de forma automatica.                             ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TeclaF3()
Keyboard chr(114)		// Inserido na clausula When. Deveria inserir no teclado a tecla F3 (VK_F3) para chamar de modo automatico a consulta padrao SB1 

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �chkCodProd �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Se encontro o Codigo de produto digitado marco a linha.     ���
���			� Se nao for encontrar, navego ate que a linha do listBox seja���
���			� maior do que o codigo que foi digitado.                     ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function chkCodProd()
	Local _nJ
	Local lRet := ! _lCodProdu		// Quando digitado o codigo do produto, retorno .F. para nao perder o foco. Quando for digitar a Descricao, retorno .T. para perder o foco e ir para o campo Descricao
	Local lPosicionou := .T.

	//If !(_oCodProdu:lModified)// Nao houve digitacao no MSGet (ou esta funcao foi chamada por outro Botao), nao efetuo nenhum tratamento e saio da validacao
	//	Return .T.     			// Aqui h� um problema. Se retornar .F. a acao de outro Botao nao � executada. Se retornar .T. perco o foco do MSGet _oCodProduto
	//Endif
	
	For _nJ := 1 to len(aList)
		If _cCodProdu == aList[_nJ ,_nPosCpCHK ]	// Se encontrei o produto digitado
		
			If !empty( _cCodProdu )		// Se o _oCodProdu, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				aList[ _nJ ,1]	:= .T.
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		ElseIf _cCodProdu <  aList[_nJ ,_nPosCpCHK ]		// Se a linha do ListBox for maior que o produto digitado 
			oListBox:nAt	:= _nJ				// posiciono na linha
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		Endif
	Next

	If !lPosicionou									// Se nao achou nenhum elemento, 
		oListBox:nAt	:= Len(aList)				// posiciono no ultimo elemento
		oListBox:Refresh()
	Endif
		
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �chkDesProd �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Se encontro exatamente a Descricao do produto digitado marco���
���			�  a linha. Se encontrar, a digitacao contida em uma linha,   ���
���			�  paro nela. Se nao encontrar, navego ate que a linha do     ���
���			� listBox seja maior do que o codigo que foi digitado.        ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function chkDesProd( )
	Local _nJ
	Local lRet := _lCodProdu		// Quando digitado a Descricao do produto, retorno .F. para nao perder o foco. Quando for digitar o Codigo, retorno .T. para perder o foco e ir para o campo Codigo do Produto
	Local lPosicionou := .T.
	Local _nLinhPesq	:= If(_cDesProdu==_cUltiDesc, oListBox:nAt+1, 1 ) // Linha a partir da qual inicio a pesquisa da Descricao. Se for a mesma da pesquisa anterior, inicio a partir da proxima linha, se for diferente, procuro � partir da linha 1)

	//If (_oDesProdu:lModified)// Nao houve digitacao no campo do MSGet (ou esta funcao foi chamada pelo Botao Marca/Desmarca), nao efetuo nenhum tratamento 
		_cUltiDesc	:= _cDesProdu				// Atualizo a ultima Descricao pesquisada.
		_cDesProdu	:= AllTrim(_cDesProdu)
	//Endif

	//If !(_oDesProdu:lModified)// Nao houve digitacao no campo do MSGet (ou esta funcao foi chamada pelo Botao Marca/Desmarca), nao efetuo nenhum tratamento 
	//	Return .T.     		// E saio da validacao, retornando .T. pois se retornar .F. a acao do Botao nao � executada.
	//Endif
	
	For _nJ := _nLinhPesq to len(aList)
		If _cDesProdu $ aList[_nJ ,_nPosCpCHK ]	// Verifico se a Descricao digitada esta contida na linha
		
			If !empty( _cDesProdu )		// Se a Descricao, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				If _cDesProdu == Alltrim( aList[_nJ ,_nPosCpCHK ])	// Se a Digitacao for exatamente o Descricao da linha, marco-a
					aList[ _nJ ,1]	:= .T.
				Endif
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		Endif
	Next

	If _nJ >= len(aList)					// Se nao achou nenhum elemento, 
		oListBox:nAt	:= 1				// posiciono no primeiro elemento para possibilitar nova pesquisa
		oListBox:Refresh()
	 	Inkey(.5)
	 	MsgStop("Pesquisa encontrou o fim da Lista. Reposicionado no come�o da lista")
	Endif
	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaDesma �Autor  �Geronimo B Alves 	 � Data  �  14/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Marca/Desmarca o produto da linha atual do Browse.  (F7)    ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MarcaDesma( )
	aList[ oListBox:nAt ,1]	:= !aList[ oListBox:nAt ,1]	// Marco/Desmarco a linha atual
	oListBox:Refresh()									// Atualizo a tela
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Codig_Desc �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Alterna a digitacao por codigo ou descricao, ajustando as variaveis de controles ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Codig_Desc()

If	_lCodProdu						// Se atualmente esta configurado para digitacao por codigo.

	_lCodProdu			:= .F. 		// Altero a Digitacao para, por Descricao (.F.)
	_nPosCpCHK			:= 3		// Altero a posicao do campo a checar no array. Mudo de 2 por Codigo, para 3 por Descricao
	MsgRun("Aguarde... Ordenando a tela em ordem de Descricao","",{|| CursorWait(),U_OrdemTel(3)})
	//KeyBoard Chr( 9 )				// Tecla TAB para mover o foco de um campo get para o outro K_CTRL_I 
	//KeyBoard Chr( 9 )				// Tecla TAB para mover o foco de um campo get para o outro K_CTRL_I 
	_oCodProdu:LVISIBLECONTROL	:= .F.
	_oDesProdu:LVISIBLECONTROL	:= .T.
	_oDesProdu:SetFocus()
	
Else								// Se atualmente esta configurado para digitacao por Descricao. 
	_lCodProdu	:= .T. 				// Altero a Digitacao para, por Codigo (.T.)
	_nPosCpCHK	:= 2				// Altero a posicao do campo a checar no array. Mudo de 3 por Descricao, para 2 por Codigo, para 
	MsgRun("Aguarde... Ordenando a tela em ordem de Codigo","",{|| CursorWait(),U_OrdemTel(2)})
	//KeyBoard Chr( 9 )				// Tecla TAB para mover o foco de um campo get para o outro K_CTRL_I 
	//KeyBoard Chr( 9 )				// Tecla TAB para mover o foco de um campo get para o outro K_CTRL_I 
	_oCodProdu:LVISIBLECONTROL	:= .T.
	_oDesProdu:LVISIBLECONTROL	:= .F.
	_oCodProdu:SetFocus()

Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OrdemTel �Autor  �Geronimo B Alves 	 � Data  �  16/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Altera a ordem que os dados sao apresentados na tela para   ���
���     	� serem ordenados em ordem crescesnte pelo elemento recebido  ���
���     	� no parametro                                                ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function OrdemTel( _nColuna )

	aList := aSort(aList,,, { |x, y| x[_nColuna] < y[_nColuna] })
	//oListBox:SetArray(aList)		// Coloco a array ordenada como a nova lista
	oListBox:nAt		:= 1		// Torno a 1� linha como a linha ativa
	oListBox:Refresh()				// Atualizo a tela
	
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WhenCodigo �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Retorno .T. ou .F. para o When da digitacao do campo codigo,���
���Desc.	� conforme o conteudo do da variavel _lCodProdu               ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Static Function WhenCodigo( )
//	lRet		:= _lCodProdu
//Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WhenDescri �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Retorno .T. ou .F. para o When da digitacao do campo        ���
���Desc.	� Descricao, conforme o conteudo do da variavel _lCodProdu    ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Static Function WhenDescri( )
//	lRet		:=  ! _lCodProdu
//Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkForn  � Autor �Geronimo B Alves	� Data �  17/08/18	���
�������������������������������������������������������������������������͹��
���Desc.	� Monta uma tela de markbrowse, mostrando os fornecedores    ���
���			� selecionados pela query recebida por parametro, nos campos ���
���			� tambem recebidos por parametro, para que o usuario marque  ���
���			� quais serao processadas									���
�������������������������������������������������������������������������͹��
���Parametros� _cQuery		- Query para selecao dos registros			���
���			� aCpoMostra[1] - Campo a ser mostrado						���
���			� aCpoMostra[2] - Titulo do Campo							���
���			� aCpoMostra[3] - Tamanho do Campo em caracteres				���
���			� cTitulo		- Titulo dq tela de selecao					���
���			� nPosRetorn	- Numero da posicao do campo na MarkBrowse	���
���			�				- que sera retornado. Ex. Pode ser retornado ���
���			�				- o primeiro, segundo, terceiro ou outro		���
���			�				- campo do MarkBrowse						���
���			� _lBtnCance	- Parametro recebido como referencia. Define se deve(.T.) ou  nao deve(.F.) cancelar todo o processamento caso o usuario ���
���			�					clicar no Botao cancelar. O _lBtnCance � visivel no programa chamador e se retornou como.T., indica que o Botao		���
���			�					foi teclado. Ent�o o programa deve ser finalizado																		���
�������������������������������������������������������������������������͹��
���Uso		� AP														 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarkForn(_cQuery, aCpoMostra, cTitulo, nPosRetorn, _lCancProg )
	Local aArea			:= GetArea()
	Local _nRecno		:= Recno()
	Local _cTmp01		:= GetNextAlias()
	Local aListMarca	:= {}
	Local nLinEncont	:= 0
	Local aEncontrad	:= {}
	Local aLinhaAux		:= {}
	Local lExibe		:= .T.
	Local nI 			:= 0
	Local nOpc  		:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo		:= { }
	Local aTam			:= { }
	Local oSay
	Local oDlg
	Local nListTam1		:= 600	//400					//380	//340	//280	//250
	Local nListTam2		:= 230					//220	//200	//170
	Local nI
	Local lChk		  
	Local _nI			:= 0
	Local oButForn		:= ""

	Private aList		:= {}
	Private oListBox

	Private _oCodForne, _oDesForne
	Private _cCodForne	:= Space(tamSx3("A2_COD")[1]) + Space(tamSx3("A2_LOJA")[1])
	Private _cDesForne	:= Space(tamSx3("A2_NOME")[1])

	Private _lCodForne	:= .T. 			// Na Come�a a digitacao por codigo, e nao Descricao de Fornecedor
	Private _nPosCpCHK	:= 2			// Posicao do campo a checar no array. Pode ser 2 para por Codigo, ou 3 por Descricao
	Private _cUltiDesc	:= "XYZXYZABCD" + Space(tamSx3("A2_NOME")[1]-10) 	// Ultima Descricao pesquisada. Se for a mesma da atual, pesquisa a partir da proxima linha. Se for outr, pesquisa a partir da linha 1

	cTitulo  			:= OemToAnsi(cTitulo)

	Aadd(aTitulo, " " )								// {" ", "Codigo", "Empresa", " " }
	Aadd(aTam	, 120  )									// {10, 30, 200, 01 }
	For _nI := 1 to len(aCpoMostra)
		Aadd(aTitulo, aCpoMostra[_nI,2] )			// Titulo do campo {" ", "Codigo", "Empresa", " " }
		Aadd(aTam	, aCpoMostra[_nI,3] * 1 )		// Tamanho do campo em Pixel {10, 30, 200, 01 } Em media, o Aria 12 tem a largyra de 11 pixel para cada letra
	Next

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf
	dbusearea(.T.,"TOPCONN",TcGenQry(	,,_cQuery),_cTmp01,.T.,.F.)
	dbSelectArea(_cTmp01)
	dbGoTop()

	If !eof()
		dbGoTop()
		While !eof()
			aLinhaAux		:= {}
			Aadd(aLinhaAux,  .F. )
			For _nI := 1 to len(aCpoMostra)
				//If _ni := 1															// Na Coluna B1_COD
				//	If AllTrim( &(aCpoMostra[_nI,1]) ) $ "817979/758711/855659"	// Se encontrado algum destes Fornecedores
				//		aLinhaAux[1] := .T.											// Marca-o como selecionado
				//	Endif 
				//Endif 
			
				Aadd(aLinhaAux	,&(aCpoMostra[_nI,1]) )
			Next	
			Aadd(aLinhaAux	," " )
			Aadd(aList , aLinhaAux )
			DbSkip()
		Enddo
	Else
		MsgStop( "Nao foi encontrado nenhum registro para montar esta tela de selecao de registros" )
		Aadd(aEncontrad , " " )
	Endif										

	//������������������������������������������������������������������������Ŀ
	//� Monta a tela de selecao dos arquivos a serem importados				�
	//��������������������������������������������������������������������������
	If Len(aList) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 040,160 OF oMainWnd		// 040,100 OF oMainWnd
		@ 03,  05 Say " "    of oDlg Pixel
	
		If Len(aTitulo) == 2
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 3
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) == 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]) SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		ElseIf Len(aTitulo) > 4
			@ 001,001 LISTBOX oListBox VAR cListBox Fields HEADER  aTitulo[1], OemtoAnsi(aTitulo[2]), OemtoAnsi(aTitulo[3]), OemtoAnsi(aTitulo[4]), OemtoAnsi(aTitulo[5])  SIZE nListTam1,nListTam2 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL		5,160
		Endif

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aList)
		oListBox:aColSizes := aTam

		If Len(aTitulo) == 2
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), Transform(aList[oListBox:nAt,2],"@R 999999-99")  }}
		ElseIf Len(aTitulo) == 3
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), Transform(aList[oListBox:nAt,2],"@R 999999-99"), aList[oListBox:nAt,3]}}
		ElseIf Len(aTitulo) == 4
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), Transform(aList[oListBox:nAt,2],"@R 999999-99"), aList[oListBox:nAt,3], aList[oListBox:nAt,4]}}
		ElseIf Len(aTitulo) > 4	
			oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo), Transform(aList[oListBox:nAt,2],"@R 999999-99"), aList[oListBox:nAt,3], aList[oListBox:nAt,4], aList[oListBox:nAt,5]}}
		Endif

		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aList, oListBox ) })			// Cria a associacao da tecla F4, � funcao MarcaTodF4()
		SetKey(VK_F7,{|| F7_Fornece( @lChk, oChk ) })						// Cria a associacao da tecla F7, � funcao F7_Fornece()

		@ 250, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aList, oListBox )

		@ 250, 130 BUTTON	oButInv Prompt '&Inverter'  Size 30, 12 Pixel        Action ( InvSelecao( @aList, oListBox, @lChk, oChk ), VerTodos( aList, @lChk, oChk ) ) Message 'Inverter Selecao' Of oDlg	
		DEFINE SBUTTON oBtnOk	FROM 250,180 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnCan	FROM 250,220 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg	
		@ 250, 290 BUTTON	oButForn Prompt '&Pesquisar Fornecedor <F7>'  Size 80, 12 Pixel Action ( F7_Fornece( @lChk, oChk )  ) Message 'Procura Fornecedor' Of oDlg	

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )					// Cancela a associacao da tecla F4, � funcao MarcaTodF4()	//Keyboard chr(27)
		SetKey( VK_F7 , {||} )					// Cancela a associacao da tecla F7, � funcao F7_Fornece()

		If nOpc == 0
			aList := {}
			If _lCancProg				// Se deve abandonar processamanto caso clique no Botao cancelar, e ele foi cancelado (nOpc == 0) 
				_lCancProg	:= .T.		// Cancelar o programa
				MsgStop("Processamento foi cancelado pelo usuario")
			Else
				_lCancProg	:=.F.		// Nao cancelar o programa. Foi clicado o Botao cancelar, porem o parametro _lCancProg recebido diz para nao abandonar o programa se isto ocorrese, mas somente limpar/desconsiderar as marca��es  
			Endif
		Else
			_lCancProg	:=.F.			// Nao cancelar o programa. Nao foi clicado o Botao cancelar. 
		Endif
	Endif

	If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] ==.T.}) <= 0
		//Aviso("Inconsist�ncia", "Nao foi selecionado nenhum registro. ",{"Ok"}	,,"Atencao:")
		aList := {}
	EndIf

	For _nI := 1 to len(aList)
		If aList[_Ni,1]
			If ValType( aList[_Ni,nPosRetorn + 1] ) == "C"
				//  No retornco de campos caracteres retiro os espa�os. Se o registro esta vazio retorno Space(1), pois no Oracle a clausula In 
				//  nao encontra o conteudo ""
				If Empty( aList[_Ni,nPosRetorn + 1] )
					aList[_Ni,nPosRetorn + 1]	:= Space(1)
				Else
					aList[_Ni,nPosRetorn + 1]	:= AllTrim( aList[_Ni,nPosRetorn + 1])
				Endif
			Endif
			
			Aadd(aListMarca, aList[_Ni,nPosRetorn + 1] )	// nPosRetorn eh o campo que desejo retornar.  Aqui, Somo 1, devido ao campo para checkbox que foi incluido no come�o de cada linha.
		Endif
	Next

	If lChk						// Se Marquei listar todos
		aListMarca	:= {}		// Deixo o array de marcacao vazio, para nao implementar o filtro.
	Endif

	DbGoto(_nRecno)
	RestArea(aArea)
Return aListMarca


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F7_Fornece �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Ao ser teclado F7, abre janela para localizar e marcar      ���
���			� Fornecedor pesquisando-o atraves do Codigo ou da Descricao     ���
���			� Chamo a consulta padrao do SB1 de forma automatica colocando���
���			� a tecla F3 no teclado atraves do comando Keyboard chr(114)  ���
�������������������������������������������������������������������������͹��
���Uso		� AP														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F7_Fornece( lChk, oChk  )

Local _nI := oListBox:nAt
local oDlgPesq 	// , oBtOk , oBtCan, oOrdem, oBtPar
Local oBuSemacao
//Local oButMarca, oButDesMar
Local nOpcao 
nOpcao := 0
//Local cOrdem
//Local aOrdens := {}
//Local nOrdem := 1

//AAdd( aOrdens, "Codigo" )
//AAdd( aOrdens, "Descricao" )

SetKey(VK_F7,{|| MarcaDesma() })						// Cria a associacao da tecla F7, � funcao MarcaDesma()
SetKey(VK_F8,{|| CodDescFor( ) })						// Cria a associacao da tecla F8, � funcao CodDescFor()

DEFINE MSDIALOG oDlgPesq TITLE "Digite o Codigo, ou a Descricao do Fornecedor" FROM 00,00 TO 140,360 PIXEL			// 100,500  // 050,200  // 075,300
  @ 002, 002 Say    "Digite o Codigo ou a Descricao do Fornecedor a ser Pesquisado ou Marcado" of oDlgPesq Pixel

  @ 020, 002 Say    "Codigo    :" of oDlgPesq Pixel
  @ 020, 040 MSGET  _oCodForne VAR _cCodForne Picture "@R 999999-99" SIZE 070,09   F3 "SA2"    Valid chkCodForn( ) When .T. OF oDlgPesq PIXEL	//When WhenCodigo() OF oDlgPesq PIXEL

  @ 035, 002 Say    "Descricao :" of oDlgPesq Pixel
  @ 035, 040 MSGET  _oDesForne VAR _cDesForne Picture "@!" SIZE 120,09               Valid chkDesForn( ) When .T. OF oDlgPesq PIXEL	//When WhenDescri() OF oDlgPesq PIXEL

  @ 050, 002 Say    "Tecle F7 para Marcar ou Desmarcar a Linha Atual."          of oDlgPesq Pixel
  @ 060, 002 Say    "Tecle F8 para alternar pesquisar por Codigo ou pesquisar por Descricao." of oDlgPesq Pixel
  @ 050, 300 BUTTON	oBuSemacao Prompt ' ' Size 001, 001 Pixel Action ( nOpcao := 99  ) Message ' ' // Of oDlgPesq	

  //@ 030, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
  //@ 005,150 BUTTON	oButMarca  Prompt '&Marca/Desmarca a Linha Atual'    Size 100, 12 Pixel Action ( nOpcao := 1 , MarcaDesma() ) Message 'Marca/Desmarca o Fornecedor da linha atual'    // Of oDlgPesq
  //@ 020,170 BUTTON	oButDesMar Prompt '&Desmarca Linha Atual' Size 70, 12 Pixel Action ( nOpcao := 0 , DesmarcaPr() ) Message 'Desmarca o Fornecedor da linha atual' // Of oDlgPesq	
  //DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  //DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN.F. OF oDlgPesq PIXEL

	If	_lCodForne						// Se atualmente esta configurado para digitacao por codigo.
		_oCodForne:LVISIBLECONTROL	:= .T.
		_oCodForne:SetFocus()
		_oDesForne:LVISIBLECONTROL	:= .F.
	
	Else
		_oCodForne:LVISIBLECONTROL	:= .F.
		_oDesForne:LVISIBLECONTROL	:= .T.
		_oDesForne:SetFocus()
	
	Endif
	
ACTIVATE MSDIALOG oDlgPesq //CENTER

SetKey(VK_F7,{|| F7_Fornece( @lChk, oChk ) })					// Cria a associacao da tecla F7, � funcao F7_Fornece(), que eera a funcao original da F7
SetKey(VK_F8,{||  })												// Desfaz a associacao da tecla F8, � Qualquer funcao

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �chkCodForn �Autor  �Geronimo B Alves 	 � Data  �  13/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Se encontro o Codigo de Fornecedor digitado marco a linha.     ���
���			� Se nao for encontrar, navego ate que a linha do listBox seja���
���			� maior do que o codigo que foi digitado.                     ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function chkCodForn()
	Local _nJ
	Local lRet := ! _lCodForne		// Quando digitado o codigo do Fornecedor, retorno .F. para nao perder o foco. Quando for digitar a Descricao, retorno .T. para perder o foco e ir para o campo Descricao
	Local lPosicionou := .T.

	//If !(_oCodForne:lModified)// Nao houve digitacao no MSGet (ou esta funcao foi chamada por outro Botao), nao efetuo nenhum tratamento e saio da validacao
	//	Return .T.     			// Aqui h� um problema. Se retornar .F. a acao de outro Botao nao � executada. Se retornar .T. perco o foco do MSGet _oCodFornecedor
	//Endif
	
	For _nJ := 1 to len(aList)
		If _cCodForne == aList[_nJ ,_nPosCpCHK ]	// Se encontrei o Fornecedor digitado
		
			If !empty( _cCodForne )		// Se o _oCodForne, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				aList[ _nJ ,1]	:= .T.
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		ElseIf _cCodForne <  aList[_nJ ,_nPosCpCHK ]		// Se a linha do ListBox for maior que o Fornecedor digitado 
			oListBox:nAt	:= _nJ				// posiciono na linha
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		Endif
	Next

	If !lPosicionou									// Se nao achou nenhum elemento,
		oListBox:nAt	:= Len(aList)				// posiciono no ultimo elemento
		oListBox:Refresh()
	Endif
		
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �chkDesForn �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Se encontro exatamente a Descricao do Fornecedor digitado marco���
���			�  a linha. Se encontrar, a digitacao contida em uma linha,   ���
���			�  paro nela. Se nao encontrar, navego ate que a linha do     ���
���			� listBox seja maior do que o codigo que foi digitado.        ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function chkDesForn( )
	Local _nJ
	Local lRet := _lCodForne		// Quando digitado a Descricao do Fornecedor, retorno .F. para nao perder o foco. Quando for digitar o Codigo, retorno .T. para perder o foco e ir para o campo Codigo do Fornecedor
	Local lPosicionou := .T.
	Local _nLinhPesq	:= If(_cDesForne==_cUltiDesc, oListBox:nAt+1, 1 ) // Linha a partir da qual inicio a pesquisa da Descricao. Se for a mesma da pesquisa anterior, inicio a partir da proxima linha, se for diferente, procuro � partir da linha 1)

	_cUltiDesc	:= _cDesForne				// Atualizo a ultima Descricao pesquisada.
	_cDesForne	:= AllTrim(_cDesForne)

	//If !(_oDesForne:lModified)// Nao houve digitacao no campo do MSGet (ou esta funcao foi chamada pelo Botao Marca/Desmarca), nao efetuo nenhum tratamento 
	//	Return .T.     		// E saio da validacao, retornando .T. pois se retornar .F. a acao do Botao nao � executada.
	//Endif
	
	For _nJ := _nLinhPesq to len(aList)
		If _cDesForne $ aList[_nJ ,_nPosCpCHK ]	// Verifico se a Descricao digitada esta contida na linha
		
			If !empty( _cDesForne )		// Se a Descricao, estiver com brancos, nao marco a linha. Para evitar marcac��es involuntarias na 1� Linha.
				If _cDesForne == Alltrim( aList[_nJ ,_nPosCpCHK ])	// Se a Digitacao for exatamente o Descricao da linha, marco-a
					aList[ _nJ ,1]	:= .T.
				Endif
			Endif
			oListBox:nAt	:= _nJ
			oListBox:Refresh()
			lPosicionou := .T.
			Exit
			
		Endif
	Next

	If _nJ >= len(aList)					// Se nao achou nenhum elemento, 
		oListBox:nAt	:= 1				// posiciono no primeiro elemento para possibilitar nova pesquisa
		oListBox:Refresh()
	 	Inkey(.5)
	 	MsgStop("Pesquisa encontrou o fim da Lista. Reposicionado no come�o da lista")
	Endif
	
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  CodDescFor �Autor  �Geronimo B Alves 	 � Data  �  15/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.	� Alterna a digitacao por codigo ou descricao, ajustando as variaveis de controles ���
�������������������������������������������������������������������������͹��
���Uso		� 														      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CodDescFor()

If	_lCodForne						// Se atualmente esta configurado para digitacao por codigo.

	_lCodForne			:= .F. 		// Altero a Digitacao para, por Descricao (.F.)
	_nPosCpCHK			:= 3		// Altero a posicao do campo a checar no array. Mudo de 2 por Codigo, para 3 por Descricao
	MsgRun("Aguarde... Ordenando a tela em ordem de Descricao","",{|| CursorWait(),U_OrdemTel(3)})
	_oCodForne:LVISIBLECONTROL	:= .F.
	_oDesForne:LVISIBLECONTROL	:= .T.
	_oDesForne:SetFocus()
	
Else								// Se atualmente esta configurado para digitacao por Descricao. 
	_lCodForne	:= .T. 				// Altero a Digitacao para, por Codigo (.T.)
	_nPosCpCHK	:= 2				// Altero a posicao do campo a checar no array. Mudo de 3 por Descricao, para 2 por Codigo, para 
	MsgRun("Aguarde... Ordenando a tela em ordem de Codigo","",{|| CursorWait(),U_OrdemTel(2)})
	_oCodForne:LVISIBLECONTROL	:= .T.
	_oDesForne:LVISIBLECONTROL	:= .F.
	_oCodForne:SetFocus()

Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BINoAcen �Autor  �Geronimo BenEDITO Alves � Data � 01/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por retirar caracteres especiais das     ���
���          �String                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BINoAcen(cMens)

Local cByte,ni
Local s1:= "�����" + "�����" + "�����" + "�����" + "�����" + "�����" + "�����" + "�����"  + "����" + "��" + "<>&'" + '"'
Local s2:= "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC" + "    " + " "		//Linha melhorada, passando caracteres selecionados
//Local s2:= "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC" + "    " + " "		//Linha original. Linha base
Local nPos:=0, nByte
Local cRet:=''

For ni := 1 To Len(cMens)
	cByte := Substr(cMens,ni,1)
 	nByte := ASC(cByte)
  	nPos  := At(cByte,s1)
   	If nPos > 0
    	cByte := Substr(s2,nPos,1)
	Else
	    If nByte < 32 .Or. nByte > 125
    		cByte := " "
	    EndIf
    EndIf

    cRet += cByte
Next
Return(AllTrim(cRet))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaColun� Autor� Geronimo BenEDITO Alves� Data � 08/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por retirar caracteres especiais das     ���
���          �String                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MontaColun(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData 	:= {||}
	Local cTipoDado	:= "C"
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0
	
	If nArrData > 0
		If nAlign == 0		// Campo tipo Data, que alinho ao centro.

			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")			// Usar esta linha, se TRB for CTREE
			//bData := &("{|| Stod(" + cCampo +") }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")	// Usar esta linha, se TRB for no SGBD
			cTipoDado	:= "D"

		ElseIf nAlign == 2		
			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
			cTipoDado	:= "N"
			
		Else
			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
			cTipoDado	:= "C"

		Endif
	EndIf
	
	/* Array da coluna
	[n][01] Titulo da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Mascara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edicao
	[n][09] Code-Block de validacao da coluna apos a edicao
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execucao do duplo clique
	[n][12] Variavel a ser utilizada na edicao (ReadVar)
	[n][13] Code-Block de execucao do clique no header
	[n][14] Indica se a coluna esta deletada
	[n][15] Indica se a coluna sera exibida nos detalhes do Browse
	[n][16] Opcoes de carga dos dados (Ex: 1=Sim, 2=Nao)
	*/
	
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
	
Return {aColumn}
 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef �Autor  �Geronimo BenEDITO Alves � Data � 08/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria o menu do Browse que mostra os dados da consulta na   ���
���          � tabela temporaria. Opcao Gera Planilha                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()
	Local aArea		:= GetArea()
	Local aRotina 	:= {}

	AADD(aRotina, {"Gera Planilha"	, "U_GeraPlan()"		, 0, 3, 0, .F. })
	
	//AADD(aRotina1, {"Consulta Produto"	, "MATC050()"		, 0, 6, 0, Nil })
	//AADD(aRotina1, {"Legenda"			, "U_EXEM992L"		, 0,11, 0, Nil })
	//AADD(aRotina, {"Pesquisar"			, "PesqBrw"			, 0, 1, 0, .T. })
	//AADD(aRotina, {"Visualizar"			, "U_EXEM992I"		, 0, 2, 0, .F. })
	//AADD(aRotina, {"Incluir"			, "U_EXEM992I"		, 0, 3, 0, Nil })
	//AADD(aRotina, {"Alterar"			, "U_EXEM992I"		, 0, 4, 0, Nil })
	//AADD(aRotina, {"Excluir"			, "U_EXEM992I"		, 0, 5, 3, Nil })
	
	//AADD(aRotina, {"Mais acoes..."    	, aRotina1          , 0, 4, 0, Nil }      )
	
	RestArea(aArea)
Return( aRotina )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GeraPlan�Autor  �Geronimo BenEDITO Alves � Data � 08/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     � Chama a funcao Planilha usando a MsgRun para mostrar uma   ���
���          � regua de processamento na tela                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GeraPlan()

	MsgRun("Gerando Planilha: " + _aDefinePl[1], _aDefinePl[1], {|| Planilha("FWMsExcelEx", @_nArqName,@_aArqName) }) 
	dbSelectArea(_cTmp01)
	(_cTmp01)->(Dbgotop())


Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INSERT_TRB� Autor �Geronimo BenEDITO Alves � Data �08/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     � Alimenta o arquivo TRB dentro do banco com o comando       ���
���          � Insert Into                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Static Function INSERT_TRB( _cTmp01, _aCampoQry )
//	Local _nI			:= 2 
//	Local _nPosiFrom	:= At( " FROM " ,_cQuery )		// At( < cPesquisa >, < cDestino >, [ nStart ] )
//	Local InsertInto	:= ""
//	InsertInto	:= " INSERT INTO " + _cTmp01 + "(" + _aCampoQry[1,_nPoNome]	+CRLF
//	For _nI := 2 to len(_aCampoQry)		// Leio a partir do segundo elemento, pois o primeiro ja foi adicionado na linha acima.
//		InsertInto += " ,  " + _aCampoQry[_nI,_nPoNome]	+CRLF
//	Next
//	InsertInto += " ' ' as X )  " +CRLF	// Adiciona o campo X que foi ciado para ser o indice da tabela. A funcao FwmBrowse torna obrigatorio o uso de um indice na tabela.
//	InsertInto	:= " SELECT " + _aCampoQry[1,_nPoNome]	+CRLF
//	For _nI := 2 to len(_aCampoQry)		// Leio a partir do segundo elemento, pois o primeiro ja foi adicionado na linha acima.
//		InsertInto += " ,  " + _aCampoQry[_nI,_nPoNome]	+CRLF
//	Next
//	InsertInto += " FROM (  " +CRLF	
//	InsertInto += " _cQuery " +CRLF	
//	InsertInto += " ) " +CRLF 
//	//INSERT INTO EMPREGADOS(CODIGO,NOME, SALARIO, SECAO)
//    //  SELECT CODIGO,NOME,SALARIO, SECAO
//    //  FROM EMPREGADOS_FILIAL
//    //  WHERE DEPARTAMENTO = 2	
//Return


/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
���Programa �ParameR2  �Autor  � Geronimo Benedito ALves          � Data �  06/12/2018  ���
���������������������������������������������������������������������������������������͹��
���Desc.	� Esta rotina � executada depois do Parambox que obtem os parametros da     ���
���			� query que ira gerar o relatorio.                                          ���
���			� Ela trata os parametros, para deixa-los com conteudos validos. Exemplo,   ���
���			� executa dtos() nos parametros de data, e Eval( _bParameRe ) quando 	    ���
���			� necessario.				            				            		���
���			� Tambem alimenta as variaveis _bCpoExce e _cQuery				            ���
���			�																			���
���������������������������������������������������������������������������������������͹��
���Uso		� AP																		���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
*/
User function ParameR2(_aParambox, _bParameRe, _aRet ,_lRet )
	Local _nI	:= 0

	_cTmp01		:= GetNextAlias() 

	If !_lRet
		MsgInfo("Cancelado pelo usuario")
		Return _lRet
	Endif

	If Empty(_bParameRe)
		For _nI := 1 to len(_aRet)
			If Valtype(_aRet[_nI]) == "D"
				_aRet[_nI]	:= Dtos(_aRet[_nI])
			Endif
		Next
	Endif

	If !Empty(_bParameRe)
		Eval( _bParameRe )		// Ajusta os parametros digitados, Exemplo: colocar Executar, nas variaveis de Data, executar Alltrim nas variaveis que serao usadas na cluasula like da query, etc.
	Endif

	U_Traacpoq()

	_cQuery		:= U_CpoQuery()	// FUNCAO QUE cria a parte da query referente � selecao dos campos. 
	_aCpoExce	:= U_CpoExcel()	// Funcao que cria a array com o(s) code block(s) que ira(�o) gerar as linhas de detalhe da(s) aba(s) da planilha excel, baseado no registro da tabela temporaria sobre a qual o ponteiro esteja posicionado. A formata��o � definida pelo array _aCampoQry

Return _lRet

