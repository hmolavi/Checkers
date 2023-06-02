// Game Rules:
// Rule #1: if you can hop opver an opponent piece, you must hop!
// Rule #2: you must complete all of your hops for your turn to be over
// Rule #3: your piece becomes a king i.e(can move backwards) once it reaches your opponents side


String nameP1 = "Player1";
color colorP1 = color(235,64,52);

String nameP2 = "Player2";
color colorP2 = color(0);

Player player1;
Player player2;
Board gameBoard;

void setup(){
  size(1000,1000);
  gameBoard = new Board(50, width, height);
  player1 = new Player(nameP1, colorP1, 1 );
  player2 = new Player(nameP2, colorP2, 2 );

  gameBoard.drawBoard();  
  player1.drawPieces();
  player2.drawPieces();
}

void draw(){}

void mousePressed(){
  int col = floor((mouseX - gameBoard.padding)/ gameBoard.cellSize);
  int row = floor((mouseY - gameBoard.padding)/ gameBoard.cellSize);
  
  if (gameBoard.mustHit == true ){
    gameBoard.playerMustHit(col , row);
  }
  else{
    if (gameBoard.playerTurn == 1)
      player1.myTurn(col , row);
      
    else
      player2.myTurn(col , row);
  }
}
