class Checker_Piece{
  
  color checkerColor;
  int x;
  int y;
  boolean Alive;
  boolean king = false;
  
  Checker_Piece(color c , int tempX, int tempY, boolean alive){
    
    checkerColor = c;
    x = tempX;
    y = tempY;
    Alive = alive;
 
  }
  
  void drawPiece(){
    fill(checkerColor);
    
    if (Alive == true){
      
      if (y <= gameBoard.cellSize && player2.playerColor == checkerColor){
        king = true; 
      }
      
      if (y > 7 * gameBoard.cellSize && player1.playerColor == checkerColor){
        king = true; 
      }
      
      circle(this.x,this.y, gameBoard.cellSize/2);
      
      if ( king==true ){
        fill(255);
        circle(this.x, this.y, gameBoard.cellSize/4);
      }
    }
  }
  
  
}  
  
  
