//--------------------------------------------------------------------------------------------
// 								SELECT .. FROM
//--------------------------------------------------------------------------------------------
// Devido a limitações na utilização do xTranslate, a princípio a sintaxe para JOINS é:
// FROM (tabela1 WHERE Condicao1, tabela2 WHERE Condicao2,...)
// O join entre as tabelas deve ser feito via parâmetros. Por exemplo:
// TAB SB2, TAB SB1 WHERE B1_CODPROD = ?SB2->B2_CODPROD?
//--------------------------------------------------------------------------------------------
#XTRANSLATE PREPARE SELECT <xlist,...> FROM (<aTables,...>) ;
				[GROUP BY <bGroup>] ;
				[TOP <nTop>] ;
					=> ISAMQry():New({ <aTables> }, { <xList> }, <{bGroup}>, <nTop>)

#XTRANSLATE SELECT <xlist,...> FROM (<aTables,...>) ;
				[GROUP BY <bGroup>] ;
				[TOP <nTop>] ;
					=> ISAMQry():New({ <aTables> }, { <xList> }, <{bGroup}>, <nTop>)

#XTRANSLATE EXECUTE SELECT <xlist,...> FROM (<aTables,...>) ;
				[GROUP BY <bGroup>] ;
				[TOP <nTop>] ;
				[INTO TABLE (<aCampos,...>)] [COUNT TO <nCount>] ;
				[PROC (<bProcedure,...>) ] ;
				[PARAMS <aParams>] ;
					=> ISAMExec(ISAMQry():New({<aTables>},{<xList>},<{bGroup}>,<nTop>),[{ <aCampos> }][{|aLine| <bProcedure> }],[@<nCount>], <aParams>)

#XTRANSLATE XSELECT <xlist,...> FROM (<aTables,...>) ;
				[GROUP BY <bGroup>] ;
				[TOP <nTop>] ;
				[INTO TABLE (<aCampos,...>)] [COUNT TO <nCount>] ;
				[PROC (<bProcedure,...>) ] ;
				[PARAMS <aParams>] ;
					=> ISAMExec(ISAMQry():New({<aTables>},{<xList>},<{bGroup}>,<nTop>),[{ <aCampos> }][{|aLine| <bProcedure> }],[@<nCount>], <aParams>)
//--------------------------------------------------------------------------------------------
// 								UPDATE ... SET
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como código/macro)
//--------------------------------------------------------------------------------------------

#XCOMMAND UPDATE &<cTable> SET (<xlist,...>) ;
				VALUES (<xValues,...>) ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[COUNT TO <nCount>] ;
					=> dbUpdate( { <"xList"> }, { <xValues> }, { <cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder> }, [@<nCount>])

//--------------------------------------------------------------------------------------------
// 								UPDATE ... SET
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como string)
//--------------------------------------------------------------------------------------------

#XCOMMAND UPDATE <cTable> SET (<xlist,...>) ;
				VALUES (<xValues,...>) ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[COUNT TO <nCount>] ;
					=> dbUpdate( { <"xList"> }, { <xValues> }, { <"cTable">, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder> }, [@<nCount>])

//--------------------------------------------------------------------------------------------
// 								INSERT ... INTO
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como código/macro)
//--------------------------------------------------------------------------------------------

#XCOMMAND INSERT INTO &<cTable> (<xlist,...>) ;
				VALUES (<xValues,...>) ;
					=> dbInsert({ <"xList"> }, { <xValues> }, <cTable>)

//--------------------------------------------------------------------------------------------
// 								INSERT ... INTO
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como String)
//--------------------------------------------------------------------------------------------

#XCOMMAND INSERT INTO <cTable> (<xlist,...>) ;
				VALUES (<xValues,...>) ;
					=> dbInsert({ <"xList"> }, { <xValues> }, <"cTable">)

//--------------------------------------------------------------------------------------------
// 								DELETE FROM
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como código/macro)
//--------------------------------------------------------------------------------------------

#XCOMMAND DELETE FROM &<cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[COUNT TO <nCount>] ;
					=> dbDelFrom({ <cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder> }, [@<nCount>])

//--------------------------------------------------------------------------------------------
// 								DELETE FROM
//--------------------------------------------------------------------------------------------
// Efetuado sobre a tabela padrão (ctable tratado como sTRING)
//--------------------------------------------------------------------------------------------

#XCOMMAND DELETE FROM <cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[COUNT TO <nCount>] ;
					=> dbDelFrom({ <"cTable">, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder> }, [@<nCount>])

//--------------------------------------------------------------------------------------------
// 								TRANSLATES DE SOURCES
//--------------------------------------------------------------------------------------------
// Os xTranslates abaixo definem fontes de dados a serem utilizadas na cláusula JOIN FROM.
//--------------------------------------------------------------------------------------------

//TABELA PADRÃO, ONDE CTABLE SERÁ TRATADA COMO STRING
#XTRANSLATE QRY <cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<"cTable">, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//TABELA PADRÃO, ONDE CTABLE SERÁ TRATADA COMO CÓDIGO/MACRO
#XTRANSLATE QRY &<cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//TABELA LOCAL, ONDE CTABLE SERÁ TRATADA COMO STRING
#XTRANSLATE TAB <cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<"cTable">, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//TABELA LOCAL, ONDE CTABLE SERÁ TRATADA COMO CÓDIGO/MACRO
#XTRANSLATE TAB &<cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//ARRAY
#XTRANSLATE ARR <cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//OBJ
#XTRANSLATE OBJ <cTable> ;
				[WHERE &<cWhere2>] [WHERE (<cWhere2>)] [WHERE <cWhere>] ;
				[FOR <bFor>] ;
				[ORDER <nOrder>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> {<cTable>, <"cWhere"> <cWhere2>, <{bFor}>, <nOrder>, <cAlias> <"cAlias2">}

//TABELA VIA DBACCESS, ONDE CTABLE É TRATADA COMO UMA STRING
#XTRANSLATE TOP <cTable> ;
				[WHERE &<cWhere>] [WHERE <cWhere2>] ;
				[FOR <bFor>] ;
				[ORDER &<cOrder>] [ORDER <cOrder2>] ;
				[SELECT &<Select>] [SELECT <Select2>] ;
				[GROUP BY &<cGroup>] [GROUP BY <cGroup2>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> { DbObjSql({ <"Select"><Select2> },<"cTable">,<cWhere><"cWhere2">,<cGroup><"cGroup2">,<"cOrder"><cOrder2>),,<bFor>,<cAlias><"cAlias2">}

//TABELA VIA DBACCESS, ONDE CTABLE É TRATADA COMO CÓDIGO/MACRO
#XTRANSLATE TOP &<cTable> ;
				[WHERE &<cWhere>] [WHERE <cWhere2>] ;
				[FOR <bFor>] ;
				[ORDER &<cOrder>] [ORDER <cOrder2>] ;
				[SELECT &<Select,...>] [SELECT <Select2,...>] ;
				[GROUP BY &<cGroup>] [GROUP BY <cGroup2>] ;
				[ALIAS &<cAlias>] [ALIAS <cAlias2>] ;
					=> { DbObjSql( { <"Select"><Select2> },<cTable>,<cWhere><"cWhere2">,<cGroup><"cGroup2">,<"cOrder"><cOrder2>),,<bFor>,<cAlias><"cAlias2">}

//--------------------------------------------------------------------------------------------
// 								TERMOS PARA CLÁUSULA SELECT
//--------------------------------------------------------------------------------------------
// Os termos abaixo são utilizados para aplicação na cláusula select, com funções de agregação
// ou acesso normal a campos
//--------------------------------------------------------------------------------------------
#XTRANSLATE #SUM(<Expression>)  => { "SUM", {|| <Expression> } }
#XTRANSLATE #CONC(<Expression>)  => { "STRSUM", {|| <Expression> } }
#XTRANSLATE #STRSUM(<Expression>)  => { "STRSUM", {|| <Expression> } }
#XTRANSLATE #AVG(<Expression>)  => { "AVG", {|| <Expression> } }
#XTRANSLATE #VALUE(<Expression>) => { "VALUE", {|| <Expression> } }
#XTRANSLATE #MAX(<Expression>)  => { "MAX", {|| <Expression> } }
#XTRANSLATE #MIN(<Expression>)  => { "MIN", {|| <Expression> } }
#XTRANSLATE #COUNT(<Expression>) => { "COUNT", {|| <Expression> } }
#XTRANSLATE #FIRST(<Expression>) => { "FIRST", {|| <Expression> } }
#XTRANSLATE #LAST(<Expression>) => { "LAST", {|| <Expression> } }
#XTRANSLATE #PONDAVG(<Expression1>,<Expression2>) => { "PONDAVG", {|| { <Expression1>, <Expression2> } } }
#XTRANSLATE #PONDAVG(<Expression>) => { "PONDAVG", {|| <Expression> } }
#XTRANSLATE #ARRCONCAT(<Expression>) => { "ARRCONCAT", {|| <Expression> } }
#XTRANSLATE #(<Expression>) => { "VALUE", {|| <Expression> } }

//--------------------------------------------------------------------------------------------
// 								Vetor associativo
//--------------------------------------------------------------------------------------------
// xTransalte para arrays associativos, baseados na classe HashMap
//--------------------------------------------------------------------------------------------

#XTRANSLATE \.HashMap\(\)\:New\(\) => SmAssocArray()
#XTRANSLATE \.<aStruct>\:Put\(<xExpression>, <xValue>\) => SmPtAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Sum\(<xExpression>, <xValue>\) => SmSmAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Minus\(<xExpression>, <xValue>\) => SmMnAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Multiply\(<xExpression>, <xValue>\) => SmMtAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Divide(<xExpression>, <xValue>\) => SmDvAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Power\(<xExpression>, <xValue>\) => SmPwAsocArr(<aStruct>, <xExpression>, <xValue>)
#XTRANSLATE \.<aStruct>\:Get\(<xExpression>\) => smGtAsocArr(<aStruct>, <xExpression>)
#XTRANSLATE \.<aStruct>\:aValues\[<nI>\]\[\#<xExp>\] => smGtAsocArr(<aStruct>\[3\])
#XTRANSLATE \.<aStruct>\:aKeys => <aStruct>\[2\]
#XTRANSLATE \.<aStruct>\:aValues => <aStruct>\[3\]
#XTRANSLATE \.<aStruct>\:Size => <aStruct>\[4\]
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)++ => SmSmAsocArr(<aStruct>, <xExpression>, 1)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)-- => SmMnAsocArr(<aStruct>, <xExpression>, 1)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Put\(<x2>, <v>) => smPtAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Sum\(<x2>, <v>) => smSmAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Minus\(<x2>, <v>) => smMnAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Multiply\(<x2>, <v>) => smMtAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Divide\(<x2>, <v>) => smDvAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Power\(<x2>, <v>) => smPwAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>, <v>)
#XTRANSLATE smGtAsocArr\(<aStruct>, <xExpression>\)\:Get\(<x2>) => smGtAsocArr(smGtAsocArr(<aStruct>, <xExpression>), <x2>)

#XTRANSLATE Array\(\#\) => HashMap():New()
#XTRANSLATE \[\#<xExpression>,<xExpression2> => :Get(<xExpression>)\[\#<xExpression2>
#XTRANSLATE \[\#<xExpression>\] := <xValue> => :Put(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\] += <xValue> => :Sum(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\] -= <xValue> => :Minus(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\] *= <xValue> => :Multiply(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\] /= <xValue> => :Divide(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\] ^= <xValue> => :Power(<xExpression>, <xValue>)
#XTRANSLATE \[\#<xExpression>\]\+\+ <xValue> => :Sum(<xExpression>, 1)
#XTRANSLATE \[\#<xExpression>\]\-\- <xValue> => :Minus(<xExpression>, 1)
#XTRANSLATE \[\#<xExpression>\] => :Get(<xExpression>)

//
#XCOMMAND TRY => 	SmTry() ;;
					BEGIN SEQUENCE

#XCOMMAND CATCH [TO <oError>] => 	RECOVER ;;
									[<oError> := ] SmCatch()

#XCOMMAND ENDTRY => END SEQUENCE ;;
					SmEndTry()

#XCOMMAND THROW <cError> => UserException(<cError>)

#XCOMMAND SMTHROW TYPE <cType> ERROR <cError> => UserException('{"type":' + SmTrimJson(<cType>) + ',"error":' + SmTrimJson(<cError>) + '}')

#XCOMMAND SCAN => Do While !Eof()
#XCOMMAND SCAN WHILE <Condition> => Do While !Eof() .And. (<aTables>)
#XCOMMAND ENDSCAN => dbSkip();;
					EndDo

#XCOMMAND SCAN <TABLE> => Do While (<TABLE>)->(!Eof())
#XCOMMAND SCAN <TABLE> WHILE <Condition> => Do While (<TABLE>)->(!Eof() .And. (<aTables>))
#XCOMMAND ENDSCAN <TABLE> => (<TABLE>)->(dbSkip());;
										EndDo