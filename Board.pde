class Board {
  
  int height;
  int width;
  color [] CheckerBoard = {color(210,105,30),color(139,69,19)} ;
  color backgroundColor;  
  int padding;
  float cellSize;  
  int playerTurn = 1;
  Checker_Piece [] player1Pieces = new Checker_Piece [12];
  Checker_Piece [] player2Pieces = new Checker_Piece [12]; 
  ArrayList<String> PossibleHitsxAxis = new ArrayList<String>();
  ArrayList<String> PossibleHitsyAxis = new ArrayList<String>();
  Player otherPlayer;
  Player currentPlayer = player1;
  int forwardDirection = -1;
  boolean mustHit = false;
  boolean playerTurnAgain = false;
  int indexOfPiecetoMove;
  
  
  Board(int p, int w, int h){
    
    this.height = h;
    this.width = w;
    
    padding = p;
    cellSize = (width-(2*float(padding)))/8;
    
    background(255);
  
  } 
  
  
  void drawBoard(){
    try{
      detrmineOtherPlayer();
      determineforwardDirection();
      background(currentPlayer.playerColor);
    }
    catch(Exception e){background(255);}
    float x=0;
    float y = float(padding);
    int p=0;
    for(int i=0; i<8;i++){
      for(int j=0; j<8;j++){
        x = j* cellSize + float(padding);
        fill(CheckerBoard[p%2]);
        noStroke();
        rect(x,y,cellSize,cellSize);
        p++;
      }
      --p;
      y += cellSize;
    }
  }
    
  void playerMustHit(int xAxis, int yAxis){
        
    detrmineOtherPlayer();
    currentPlayer.xAxis = xAxis;
    currentPlayer.yAxis = yAxis;
 
    int indexOfPiece = currentPlayer.indicateIndex();
    
    if (playerTurnAgain == true)
    //if (checkForPossibleHits())
      checkIfValidMove(xAxis, yAxis);
      
    else if (indexOfPiece == -1){
      println("Not a valid choice. Pick again");  
    }
    
    else{
      indexOfPiecetoMove = indexOfPiece;
      
      gameBoard.drawBoard();
      player1.drawPieces();
      player2.drawPieces();
    
      fill(255,255,0, 200);
      rect( (currentPlayer.playerPieces[indexOfPiece].x - (gameBoard.cellSize/2)), (currentPlayer.playerPieces[indexOfPiece].y - (gameBoard.cellSize/2)), gameBoard.cellSize, gameBoard.cellSize );
      
      for (int i=0;i<PossibleHitsxAxis.size();i++){
        fill(255,255,0,120);
        circle( float(PossibleHitsxAxis.get(i)) * cellSize + cellSize/2 + padding, float(PossibleHitsyAxis.get(i)) * cellSize + cellSize/2 + padding, cellSize/2 );
      }
      
      currentPlayer.prevxAxis = xAxis;
      currentPlayer.prevyAxis = yAxis;
      
      playerTurnAgain = true;
       
    }
  }

  boolean checkForPossibleHits(){
    detrmineOtherPlayer();
    PossibleHitsxAxis.clear();
    PossibleHitsyAxis.clear();
    
    for (int i=0;i<12;i++){
      if (currentPlayer.playerPieces[i].Alive){
      
        int xAxis = int(floor(currentPlayer.playerPieces[i].x - padding)/ cellSize) ;
        int yAxis = int(floor(currentPlayer.playerPieces[i].y - padding)/ cellSize) ;
        
        for (int j=0;j<12;j++){
          if (otherPlayer.playerPieces[j].Alive){
          
            int xAxisOther = int(floor((otherPlayer.playerPieces[j].x - padding)/ cellSize));
            int yAxisOther = int(floor((otherPlayer.playerPieces[j].y - padding)/ cellSize));
            
                  
            if (  ( xAxis + 1 == xAxisOther ) && (yAxis + forwardDirection == yAxisOther ) ){
              if ( currentPlayer.forwardLR("R", xAxisOther, yAxisOther, forwardDirection) ){                
                PossibleHitsxAxis.add(str( xAxis + 2 ));
                PossibleHitsyAxis.add(str( yAxis + 2 * forwardDirection ));
                                
                fill(255,255,0);
                circle(currentPlayer.playerPieces[i].x + 2 * cellSize, currentPlayer.playerPieces[i].y + 2 * cellSize * forwardDirection, cellSize/2);
              }
            }
            
            else if ( ( xAxis - 1 == xAxisOther )  && (yAxis + forwardDirection == yAxisOther ) ){
              if ( currentPlayer.forwardLR("L", xAxisOther, yAxisOther, forwardDirection) ){
                PossibleHitsxAxis.add(str( xAxis - 2 ));
                PossibleHitsyAxis.add(str( yAxis + 2 * forwardDirection ));
    
                fill(255,255,0);
                circle(currentPlayer.playerPieces[i].x - 2 * cellSize, currentPlayer.playerPieces[i].y + 2 * cellSize * forwardDirection, cellSize/2);
              }
            }
            
            
            int indexOfPiece = currentPlayer.indicateIndex();
            
            if (  ( xAxis + 1 == xAxisOther ) && (yAxis - forwardDirection == yAxisOther ) ){
              if ( currentPlayer.backwardsLR("R", xAxisOther, yAxisOther, forwardDirection, indexOfPiece) ){                
                PossibleHitsxAxis.add(str( xAxis + 2 ));
                PossibleHitsyAxis.add(str( yAxis + 2 * -forwardDirection ));
                                
                fill(255,255,0);
                circle(currentPlayer.playerPieces[i].x + 2 * cellSize, currentPlayer.playerPieces[i].y + 2 * cellSize * -forwardDirection, cellSize/2);
              }
            }
            
            else if ( ( xAxis - 1 == xAxisOther )  && (yAxis - forwardDirection == yAxisOther ) ){
              if ( currentPlayer.backwardsLR("L", xAxisOther, yAxisOther, forwardDirection, indexOfPiece) ){
                PossibleHitsxAxis.add(str( xAxis - 2 ));
                PossibleHitsyAxis.add(str( yAxis + 2 * -forwardDirection ));
    
                fill(255,255,0);
                circle(currentPlayer.playerPieces[i].x - 2 * cellSize, currentPlayer.playerPieces[i].y + 2 * cellSize * -forwardDirection, cellSize/2);
              }
            }            
          }
        }
      }
    }
    
    if (PossibleHitsxAxis.size() > 0)
      return true;
    else
      return false;
  }
  
  void checkIfValidMove( int xAxis, int yAxis){
    
    playerTurnAgain = false;
    boolean valid = false;
    for(int i=0;i<PossibleHitsxAxis.size();i++){
            
      if (xAxis == int(PossibleHitsxAxis.get(i)) && yAxis == int(PossibleHitsyAxis.get(i)) ){
        
        if (currentPlayer.playerName == player1.playerName){
           int indexOfPiecetoElim = findPiecetoElim( currentPlayer.prevxAxis + (currentPlayer.xAxis - currentPlayer.prevxAxis)/2 , currentPlayer.prevyAxis + (currentPlayer.yAxis - currentPlayer.prevyAxis)/2 );
           
           if (indexOfPiecetoElim != -1){
             player1.playerPieces[indexOfPiecetoMove].x += (currentPlayer.xAxis - currentPlayer.prevxAxis) * cellSize ;
             player1.playerPieces[indexOfPiecetoMove].y += (currentPlayer.yAxis - currentPlayer.prevyAxis) * cellSize ;
             PossibleHitsxAxis.remove(i);
             PossibleHitsyAxis.remove(i);             
             player2.playerPieces[indexOfPiecetoElim].Alive = false;
             valid = true;
           }
        }
       
        if (currentPlayer.playerName == player2.playerName){
           int indexOfPiecetoElim = findPiecetoElim( currentPlayer.prevxAxis + (currentPlayer.xAxis - currentPlayer.prevxAxis)/2 , currentPlayer.prevyAxis + (currentPlayer.yAxis - currentPlayer.prevyAxis)/2 );
           
           if (indexOfPiecetoElim != -1){
             player2.playerPieces[indexOfPiecetoMove].x += (currentPlayer.xAxis - currentPlayer.prevxAxis) * cellSize ;
             player2.playerPieces[indexOfPiecetoMove].y += (currentPlayer.yAxis - currentPlayer.prevyAxis) * cellSize ;
             
             PossibleHitsxAxis.remove(i);
             PossibleHitsyAxis.remove(i);
             
             player1.playerPieces[indexOfPiecetoElim].Alive = false;
             valid = true;
           }        
         } 
      }
    }
    
    if (valid == true ){
      
      drawBoard();
      player1.drawPieces();
      player2.drawPieces();
      
      
      if (checkForPossibleHits() == false){
        mustHit = false;
        playerTurn ++;
        if (playerTurn == 3)
          playerTurn = 1;
          
        println("______________________________");
        println(otherPlayer.playerName + "'s turn!");
        println();
        
        drawBoard();
        player1.drawPieces();
        player2.drawPieces();
        
        if (gameBoard.checkForPossibleHits())
          gameBoard.mustHit = true;      
      }
    }
    
    else{
      drawBoard();
      player1.drawPieces();
      player2.drawPieces(); 
      checkForPossibleHits();
    }
  }
  
  int findPiecetoElim ( int x, int y ){
    for(int i=0;i<12;i++){
    
      if (otherPlayer.playerPieces[i].Alive){
        if ( (floor((otherPlayer.playerPieces[i].x - gameBoard.padding)/ gameBoard.cellSize) == x) && (floor((otherPlayer.playerPieces[i].y - gameBoard.padding)/ gameBoard.cellSize) == y) ){
          return i;
        }
      }
    }
    return -1;    
  }

  void detrmineOtherPlayer(){
    otherPlayer = player1;
    currentPlayer = player2;
    
    if (playerTurn == 1){
      otherPlayer = player2;
      currentPlayer = player1;
    }
    return;
  }
  
  void determineforwardDirection(){
    this.forwardDirection = -1;
      if (playerTurn == 1)
        this.forwardDirection = 1;
    return;
  }
}
