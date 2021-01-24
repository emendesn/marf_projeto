#ifdef SPANISH
	#define STR0001 "1=Barras"
	#define STR0002 "2=Lineas"
	#define STR0003 "3=Circular"
	#define STR0004 "1=Sin Leyenda"
	#define STR0005 "2=A la izquierda "
	#define STR0006 "3=Arriba"
	#define STR0007 "4=A la derecha"
	#define STR0008 "5=Abajo"
	#define STR0009 "1=Centralizado"
	#define STR0010 "2=A la izquierda"
	#define STR0011 "3=A la derecha"
	#define STR0012 "Contar"
	#define STR0013 "Sumar"
	#define STR0014 "Generador de graficos - Tabla principal: "
	#define STR0015 "Generar grafico"
	#define STR0016 "Generar grafico"
	#define STR0017 "Nombre del grafico*"
	#define STR0018 "Configuraciones del grafico"
	#define STR0019 "Alineamiento del grafico"
	#define STR0020 "Titulo del grafico"
	#define STR0021 "Configuraciones de la leyenda"
	#define STR0022 "Picture"
	#define STR0023 "Mascara"
	#define STR0024 "Antes del valor"
	#define STR0025 "Despues del valor"
	#define STR0026 "Preview"
	#define STR0027 "Seleccione el tipo de grafico*"
	#define STR0028 "Datos del grafico"
	#define STR0029 "Series"
	#define STR0030 "Agregar serie"
	#define STR0031 "Categoria"
	#define STR0032 "Tabla*"
	#define STR0033 "Campo*"
	#define STR0034 "Periodo"
	#define STR0035 "Esta tabla no tiene relacion con la tabla principal."
	#define STR0036 "Esta tabla ya se esta utilizando en otra serie."
	#define STR0037 "Contar"
	#define STR0038 "Maximo"
	#define STR0039 "Minimo"
	#define STR0040 "Seleccione la tabla..."
	#define STR0041 "Nombre"
	#define STR0042 "Nivel de relacion"
	#define STR0043 "Tabla"
	#define STR0044 "Seleccione el campo..."
	#define STR0045 "Titulo"
	#define STR0046 "¿Desea grabar el grafico?"
	#define STR0047 "Atencion"
	#define STR0048 "¿Desea generar el grafico?"
	#define STR0049 "Existen campos obligatorios no rellenados."
	#define STR0050 "Nivel abajo"
	#define STR0051 "Nivel arriba"
	#define STR0052 "Propia tabla"
	#define STR0053 "Por lo menos una serie debe existir en el grafico."
#else
	#ifdef ENGLISH
		#define STR0001 "1=Bars"
		#define STR0002 "2=Lines"
		#define STR0003 "3=Pie"
		#define STR0004 "1=No Caption"
		#define STR0005 "2=Left"
		#define STR0006 "3=Above"
		#define STR0007 "4=Right"
		#define STR0008 "5=Below"
		#define STR0009 "1=Centralized"
		#define STR0010 "2=Left"
		#define STR0011 "3=Right"
		#define STR0012 "Count"
		#define STR0013 "Sum"
		#define STR0014 "Chart Generator - Main Table: "
		#define STR0015 "Generate Chart"
		#define STR0016 "Generate Chart"
		#define STR0017 "Chart* Name"
		#define STR0018 "Chart Configurations"
		#define STR0019 "Chart Alignment"
		#define STR0020 "Chart Title"
		#define STR0021 "Caption Configurations"
		#define STR0022 "Picture"
		#define STR0023 "Mask"
		#define STR0024 "Before value"
		#define STR0025 "After value"
		#define STR0026 "Preview"
		#define STR0027 "Choose the chart* type"
		#define STR0028 "Chart Data"
		#define STR0029 "Series"
		#define STR0030 "Add Series"
		#define STR0031 "Category"
		#define STR0032 "Table*"
		#define STR0033 "Field*"
		#define STR0034 "Period"
		#define STR0035 "This table does not have any relation with the main table."
		#define STR0036 "This table is being used in another series."
		#define STR0037 "Count"
		#define STR0038 "Maximum"
		#define STR0039 "Minimum"
		#define STR0040 "Choose table..."
		#define STR0041 "Name"
		#define STR0042 "Relationship Level"
		#define STR0043 "Table"
		#define STR0044 "Choose field..."
		#define STR0045 "Title"
		#define STR0046 "Do you want to save the chart?"
		#define STR0047 "Attention"
		#define STR0048 "Do you want to generate the chart?"
		#define STR0049 "There are mandatory fields not field."
		#define STR0050 "Level Below"
		#define STR0051 "Level Above"
		#define STR0052 "Table"
		#define STR0053 "There must be at least one series on the graph."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "1=Barras" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "2=Linhas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "3=Pizza" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "1=Sem Legenda" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "2=À Esquerda" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "3=Acima" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "4=À Direita" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "5=Abaixo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "1=Centralizado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "2=A Esquerda" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "3=A Direita" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Contar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Somar" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Gerador de gráficos - Tabela principal: " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Gerar Gráfico" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Gerar Gráfico" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Nome do gráfico*" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Configurações do Gráfico" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Alinhamento do gráfico" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Título do gráfico*" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Configurações da legenda" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Picture" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Máscara" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Antes do valor" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Depois do valor" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Preview" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Escolha o tipo do gráfico*" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Dados do gráfico" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Séries" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Adicionar Série" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Categoria" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Tabela*" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Campo*" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Período" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Esta tabela não possui relação com a tabela principal." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Esta tabela já está sendo utilizado em outra série." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Contar" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Máximo" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Mínimo" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Escolha a tabela..." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Nome" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Nível de Relacionamento" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Tabela" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Escolha o campo..." )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Título" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Deseja salvar o gráfico?" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", , "Deseja gerar o gráfico?" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", , "Existem campos obrigatórios não preenchidos." )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", , "Nivel Abaixo" )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", , "Nivel Acima" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", , "Própria tabela" )
		#define STR0053 "Pelo menos uma série deve existir no gráfico."
	#endif
#endif
