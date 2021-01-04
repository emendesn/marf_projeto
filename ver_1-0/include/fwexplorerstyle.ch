#DEFINE FLATMODE .T.
#DEFINE RESOLUCTION Eval({|| PtSetTheme("MDI"),GetScreenRes()})
//****************
// Toolbar
//****************
#DEFINE TOOLBARSIZE 25,IIF(FLATMODE,45,25)
#DEFINE TOOLBARHEIGHT 12
#DEFINE BUTTONBARSIZE IIF(FLATMODE,43,25),IIF(FLATMODE,43,25)
#DEFINE TOOLBARIMAGEBACKGROUND   nil
#DEFINE TOOLBARBUTTONIMAGECOPY   "S4WB005N"
#DEFINE TOOLBARBUTTONIMAGECUT    "S4WB006N"
#DEFINE TOOLBARBUTTONIMAGEPASTE  "S4WB007N"
#DEFINE TOOLBARBUTTONIMAGEOK     "OK"
#DEFINE TOOLBARBUTTONIMAGECANCEL "CANCEL"
#DEFINE TOOLBARBUTTONIMAGEFINAL  "FINAL"
#DEFINE STYLETOOLBAR ""
#DEFINE STYLEBUTTONBAR ""
//****************
// AddressBar
//****************
#DEFINE ADDRESSBARHEIGHT 007
#DEFINE ADDRESSBARWIDTH  320
#DEFINE STYLEADDRESSBAR ""
//****************
// SelectorBar
//****************
#DEFINE SELECTORBARHEIGHT 050
#DEFINE SELECTORBARWIDTH  040
#DEFINE STYLESELECTORBARBUTTON	"QPushButton {	color: #4e6195 } "+;
			"QPushButton {			font-size: 12px; }"+;
			"QPushButton {			font-family: calibri; }"+;
			"QPushButton { 			border-style: solid } "+;
			"QPushButton {			background-image: url(rpo:Salvar.PNG )}"+;	
			"QPushButton {			border-image: url(rpo:TransparentBorder.png) 17 17 17 17 stretch }"+;		
			"QPushButton {			border-width: 15px }"+;
			"QPushButton:hover { 	color: #000000 } "+;
			"QPushButton:hover { 	border-style: solid } "+;
			"QPushButton:hover {	border-image: url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch }"+;		
			"QPushButton:hover {	border-width: 15px }"+;
			"QPushButton:focus { 	color: #000000 } "+;
			"QPushButton:focus { 	border-style: solid } "+;
			"QPushButton:focus {	border-image: url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch }"+;		
			"QPushButton:focus {	border-width: 15px }"+;
			"QPushButton:pressed { 	color: #FFFFFF } "+;
			"QPushButton:pressed { 	border-style: solid } "+;
			"QPushButton:pressed {	border-image: url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch }"+;		
			"QPushButton:pressed {	border-width: 15px }"						
#DEFINE STYLESELECTORBARMAINPANEL "QLabel { border-width:3px; }"
#DEFINE STYLESELECTORBARBORDAPANEL "Q3Frame { border-color: #000000; }"
#DEFINE STYLESPLITBUTTON "QPushButton { 	background-color: white } "+;
			"QPushButton { 			color: #bdbdbd } "+;
			"QPushButton { 			border-style: solid } "+;
			"QPushButton {			border-image: url(rpo:SplitBorderWhite.png) 2 2 2 2 stretch }"+;		
			"QPushButton {			border-width: 2px }"+;
			"QPushButton {			font-size: 10px; }"+;			
			"QPushButton:hover { 	color: #000000 } "+;
			"QPushButton:hover { 	border-style: solid } "+;
			"QPushButton:hover {	border-image: url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch }"+;		
			"QPushButton:hover {	border-width: 2px }"+;
			"QPushButton:focus { 	color: #000000 } "+;
			"QPushButton:focus { 	border-style: solid } "+;
			"QPushButton:focus {	border-image: url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch }"+;		
			"QPushButton:focus {	border-width: 2px }"+;
			"QPushButton:pressed { 	color: #ffffff } "+;
			"QPushButton:pressed { 	border-style: solid } "+;
			"QPushButton:pressed {	border-image: url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch }"+;		
			"QPushButton:pressed {	border-width: 2px }"					
//****************
// WorkArea
//****************
#DEFINE STYLEWORKAREAPANEL ""