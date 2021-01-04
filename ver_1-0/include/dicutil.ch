#IFDEF SPANISH
	#xTransLate TITLE_DE => cTitle+" de"
	#xTransLate TITLE_ATE => cTitle+" até"
#ELSE
	#IFDEF ENGLISH
		#xTransLate TITLE_DE => cTitle+" de"
		#xTransLate TITLE_ATE => cTitle+" até"
	#ELSE
		#xTransLate TITLE_DE => cTitle+" de"
		#xTransLate TITLE_ATE => cTitle+" até"
	#ENDIF
#ENDIF

//TODO: Terminar xTranslate para perguntas (parambox)
/*#xTransLate QUESTION [FIELD <cField>] [TITLE <cTitle>] [COMBO <aCombo,...>] [DEFAULT <uDefault>];
				[VALID <cValid>] [WHEN <cWhen>] [REQUIRED <lRequired>] [UNIQUE <lUnique>]
				[SIZE <aTam>] CONPAD
	=> DicQuest(aParam, aConds, [<cField>], [<lUnique>],, [<lRequired>], [<cTitle>], [<uDefault>] ;
				, [<"cValid">], [<"cWhen">]	, [<aTam>], cConPad	, cType		, nComboIni, [<aCombo>])*/