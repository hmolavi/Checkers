class Player{
  
  boolean ForwardRight = false;
  boolean ForwardLeft = false;
  boolean BackwardsRight = false;
  boolean BackwardsLeft = false;
  boolean finalDecision = false;
  color playerColor;
  int xAxis;
  int yAxis;
  int prevxAxis = 0;
  int prevyAxis = 0;
  int indexOfPiece = -1;
  String playerName;
  
  Checker_Piece [] playerPieces = new Checker_Piece[12];
  
  Player(String n, color c, int playerNum){ 
    String orientation = "Top";
    if (playerNum == 2)
      orientation = "Bottom";
    playerName = n;
    println(playerName, "is Player", playerNum , "\t", orientation);
    playerColor = c;
    
    // pieces are placed in diffrent locations based on the player number
    if (playerNum == 1){
      int x = gameBoard.padding + int(gameBoard.cellSize/2);
      int y = gameBoard.padding + int(gameBoard.cellSize/2);
      
      for (int i=0;i<12;i++){  
        this.playerPieces[i] = new Checker_Piece( playerColor, x , y , true); 
        
        x += 2 * gameBoard.cellSize;
        if ( (y > gameBoard.padding + gameBoard.cellSize) && (x >= gameBoard.padding + (8 * gameBoard.cellSize)) ){
          x -= 9 * gameBoard.cellSize;
          y += gameBoard.cellSize;
        }
        else if (x >= gameBoard.padding + (8*gameBoard.cellSize) ){
          x -= 7 * gameBoard.cellSize;
          y += gameBoard.cellSize;
        }
      }
    }
  
    else{  
      int x = gameBoard.padding + int( 3*gameBoard.cellSize/2);
      int y = height - ( gameBoard.padding + int( gameBoard.cellSize/2));
      
      for (int i=0;i<12;i++){  
        
        this.playerPieces[i] = new Checker_Piece( playerColor, x , y , true); 
      
        x += 2 *  gameBoard.cellSize;
        
        if ( (y < gameBoard.padding + (7 * gameBoard.cellSize)) && (x > gameBoard.padding + (8 * gameBoard.cellSize)) ){
          x -= 7 * gameBoard.cellSize;
          y -= gameBoard.cellSize;
        }
          
        if (x >= gameBoard.padding + (8 * gameBoard.cellSize) ){
          x -=  9 * gameBoard.cellSize;
          y -= gameBoard.cellSize;
        }
      }   
    }
  }
  
  void drawPieces(){
    
    for(int i=0; i<12;i++){
      playerPieces[i].drawPiece();
    }
  }
  
  void myTurn(int col, int row){
    
    this.xAxis = col;
    this.yAxis = row;
    
    if (finalDecision == true)
      finalChoice();
    
    else{  
      
      indicateIndex();
                  
      gameBoard.drawBoard();
      player1.drawPieces();
      player2.drawPieces();
      
      if (indexOfPiece == -1)
        println("Not a valid choice. Pick again");
      
      else{
        possibleMoves();
      }
    }
  }

  void finalChoice(){
    
    boolean changed = choicePicked();
    
    finalDecision = false;
    if (changed){     
      
      gameBoard.playerTurn ++;
      if (gameBoard.playerTurn == 3)
        gameBoard.playerTurn = 1;
      
      println("______________________________");
      println(gameBoard.otherPlayer.playerName + "'s turn!");
      println();      
      
      gameBoard.drawBoard();
      player1.drawPieces();
      player2.drawPieces(); 
            
      if (gameBoard.checkForPossibleHits())
        gameBoard.mustHit = true;
    }
    else 
      myTurn(xAxis, yAxis);
  }

  void possibleMoves(){
    
    fill(255,255,0, 200);
    rect( (playerPieces[indexOfPiece].x - (gameBoard.cellSize/2)), (playerPieces[indexOfPiece].y - (gameBoard.cellSize/2)), gameBoard.cellSize, gameBoard.cellSize );
  
    ForwardRight = forwardLR( "R" , xAxis, yAxis, gameBoard.forwardDirection);
    if (ForwardRight == true){
      fill(226,230,46, 200);
      circle( (playerPieces[indexOfPiece].x + gameBoard.cellSize), (playerPieces[indexOfPiece].y + gameBoard.forwardDirection * gameBoard.cellSize), gameBoard.cellSize/2 + 5);
    }
    ForwardLeft = forwardLR( "L" , xAxis, yAxis, gameBoard.forwardDirection);
    if (ForwardLeft == true){
      fill(226,230,46, 200);
      circle( (playerPieces[indexOfPiece].x - gameBoard.cellSize), (playerPieces[indexOfPiece].y + gameBoard.forwardDirection * gameBoard.cellSize), gameBoard.cellSize/2 + 5);
    }
    
    BackwardsRight = backwardsLR( "R" , xAxis, yAxis, gameBoard.forwardDirection, indexOfPiece);
    if (BackwardsRight == true){
      fill(226,230,46, 200);
      circle( (playerPieces[indexOfPiece].x + gameBoard.cellSize), (playerPieces[indexOfPiece].y + -1 * gameBoard.forwardDirection * gameBoard.cellSize), gameBoard.cellSize/2 + 5);
    }    
    BackwardsLeft = backwardsLR( "L" , xAxis, yAxis, gameBoard.forwardDirection, indexOfPiece);
    if (BackwardsLeft == true){
      fill(226,230,46, 200);
      circle( (playerPieces[indexOfPiece].x - gameBoard.cellSize), (playerPieces[indexOfPiece].y + -1 * gameBoard.forwardDirection * gameBoard.cellSize), gameBoard.cellSize/2 + 5);
    }        
    
    if ( ( (ForwardRight==false && ForwardLeft==false) && (BackwardsRight==false && BackwardsLeft==false) ) &&  playerPieces[indexOfPiece].king ){
      println();
      println("Can't move that King. Try another!");
      return;
    }
    
    else if ( (ForwardRight==false && ForwardLeft==false) && playerPieces[indexOfPiece].king == false ){
      println();
      println("Can't move that piece. Try another!");
      return;
    }
    else {
      prevxAxis = xAxis;
      prevyAxis = yAxis;
      finalDecision = true;
    }
  }

  int indicateIndex(){
    
    indexOfPiece =-1;
    
    for(int i=0;i<12;i++){
        
      if (playerPieces[i].Alive){
        if ( (floor((playerPieces[i].x - gameBoard.padding)/ gameBoard.cellSize) == xAxis) && (floor((playerPieces[i].y - gameBoard.padding)/ gameBoard.cellSize) == yAxis) ){
          indexOfPiece = i;
          return i;
        }
      }
    }
    return -1;
  }
  
  boolean backwardsLR( String LeftorRight , int xAxis, int yAxis, int fDirection, int index){
    
    if ( playerPieces[index].king == false)
      return false;
    
    int LoR = -1;
    
    if (LeftorRight == "R")
      LoR = 1;
      
    int yLimit = -1;
    if (fDirection == -1)
      yLimit = 8;
      
    if ( (xAxis + LoR) == 8 || (xAxis + LoR) == -1 )
      return false;
    
    if ( (yAxis - gameBoard.forwardDirection) == yLimit) 
      return false;
    
    for(int i=0;i<12;i++){
        if ( ( (floor((playerPieces[i].x - gameBoard.padding) / gameBoard.cellSize) == (xAxis+LoR) ) && (floor((playerPieces[i].y - gameBoard.padding) / gameBoard.cellSize) == (yAxis-fDirection) ) ) && playerPieces[i].Alive )
          return false;
        
        if ( ( (floor((gameBoard.otherPlayer.playerPieces[i].x - gameBoard.padding) / gameBoard.cellSize) == (xAxis+LoR) ) && (floor((gameBoard.otherPlayer.playerPieces[i].y - gameBoard.padding) / gameBoard.cellSize) == (yAxis-fDirection) ) ) && gameBoard.otherPlayer.playerPieces[i].Alive )
          return false;
    }
    return true;  
  }
    
  boolean forwardLR ( String LeftorRight , int xAxis, int yAxis, int fDirection){
    int LoR = -1;
    
    if (LeftorRight == "R")
      LoR = 1;
      
    int yLimit = -1;
    if (fDirection == 1)
      yLimit = 8;
    
    if ( (xAxis + LoR) == 8 || (xAxis + LoR) == -1 )
      return false;
    
    if ( (yAxis + gameBoard.forwardDirection) == yLimit) 
      return false;
    
    for(int i=0;i<12;i++){
        if ( ( (floor((playerPieces[i].x - gameBoard.padding) / gameBoard.cellSize) == (xAxis+LoR) ) && (floor((playerPieces[i].y - gameBoard.padding) / gameBoard.cellSize) == (yAxis+fDirection) ) ) && playerPieces[i].Alive )
          return false;
        
        if ( ( (floor((gameBoard.otherPlayer.playerPieces[i].x - gameBoard.padding) / gameBoard.cellSize) == (xAxis+LoR) ) && (floor((gameBoard.otherPlayer.playerPieces[i].y - gameBoard.padding) / gameBoard.cellSize) == (yAxis+fDirection) ) ) && gameBoard.otherPlayer.playerPieces[i].Alive )
          return false;
    }
    return true;
  }
    
  boolean choicePicked(){
    
    if ( (xAxis == prevxAxis+1 && yAxis == prevyAxis + gameBoard.forwardDirection) && ForwardRight==true ){
      playerPieces[indexOfPiece].x += int(gameBoard.cellSize);
      playerPieces[indexOfPiece].y += int(gameBoard.forwardDirection * gameBoard.cellSize);       
      return true;
    }    
    if ( (xAxis == prevxAxis-1 && yAxis == prevyAxis + gameBoard.forwardDirection) && ForwardLeft==true ){
      playerPieces[indexOfPiece].x += int(- gameBoard.cellSize);
      playerPieces[indexOfPiece].y += int(gameBoard.forwardDirection * gameBoard.cellSize);
      return true;
    }
    
    if ( (xAxis == prevxAxis+1 && yAxis == prevyAxis - gameBoard.forwardDirection) && BackwardsRight==true ){
      playerPieces[indexOfPiece].x += int(gameBoard.cellSize);
      playerPieces[indexOfPiece].y += int(- gameBoard.forwardDirection * gameBoard.cellSize);
      return true;
    }
    if ( (xAxis == prevxAxis-1 && yAxis == prevyAxis - gameBoard.forwardDirection) && BackwardsRight==true ){
      playerPieces[indexOfPiece].x += int(- gameBoard.cellSize);
      playerPieces[indexOfPiece].y += int(- gameBoard.forwardDirection * gameBoard.cellSize);
      return true;
    }

    return false;
  }
  

}
