
public class Multiplayer extends Gamemode{
  public Multiplayer(int w){
    this.originScreen = null;
    reset(w);
  }
  public Multiplayer(int w, Screen menu){
    this.originScreen = menu;
    reset(w);
  }
  
//TODO: rename posInObject -> posOnMenuItem ?
//  public boolean posInObject(int[] pos, MenuItem o){ //pos is x,y coordinates
//    if (pos[0] >= o.x && pos[0] <= o.x+o.width && pos[1] >= o.y && pos[1] <= o.y+o.height) return true;
//    else return false;
//  }
    
  public void reset(int w){
    this.players = new Player[]{new Player("Blue", color(0,0,255)), 
      new Player("Red", color(255,0,0))};
    this.currentPlayer = this.players[0];
    this.board = new Board(w); // w passed to constructor
    //Screen resetMulti = new Multiplayer(w, originScreen);
    
    // TODO: FIX BUTTON INITIALIZING RECURSION
    //this.buttons = new Button[]{new Button(5,5,50,50,originScreen, -1, "MenuIcon.png"), new Button(5,width-55,50,50,new Multiplayer(w, originScreen), -1, "ResetIcon.png")};
    //this.buttons = new Button[]{new Button(5,width-55,50,50,new Multiplayer(w, originScreen), -1, "MenuIcon.png")};
    this.highlightedObject = null;
    // TODO: add upper menu
  }
  
  public void quitToMenu(){
    this.board.reset(this.board.w);
    //this.running = false;
    if (originScreen != null) currentScreen = originScreen;
    else System.exit(0); // else quit application
  }
  
  public void draw(){
    // draw board
    board.draw();
    // draw buttons
    if (buttons != null) for (Button button : buttons) button.draw();
  }
  
  public void click(int mX, int mY){
    BoardElement clickedObject = this.board.getObjectAtPos(mX, mY);
    if (clickedObject != null){
      if (clickedObject instanceof Line){
        // fill line
        if (((Line)clickedObject).getFilled() != true){ //TODO: add getFilled to line!
          
        }
        ((Line)clickedObject).setFilled(true);
        
        // check if last line filled of box
        Box[] boxes = ((Line)clickedObject).getBoxes();
        ArrayList<Box> filledBoxes = new ArrayList<Box>();
        for (int a = 0; a < boxes.length; a++){
          Box box = boxes[a];
          Line[] lines = box.getLines();
          int filledCounter = 0;
          for (int b = 0; b < lines.length; b++){
            Line line = lines[b];
            if (line.isFilled()) filledCounter += 1;
          }
          if (filledCounter == lines.length) filledBoxes.add(box);
        }
        if (filledBoxes.size() > 0){ // if any filled boxes
          //fill boxes with color
          for (int a = 0; a < filledBoxes.size(); a++){
            Box box = filledBoxes.get(a);
            this.currentPlayer.setScore(this.currentPlayer.getScore() + 1); // += 1
            box.setFillColor(this.currentPlayer.fillColor);
          }
          // check win condition
          int totalScore = 0;
          for (int a = 0; a < this.players.length; a++){
            Player player = this.players[a];
            totalScore += player.getScore();
          }
          if (totalScore == Math.pow(this.board.getWidth(), 2)){
            // game done
            System.out.println("Win!"); // DEBUG
          }
        }
        else {
          // next players turn if no boxes filled
          this.currentPlayer = players[(java.util.Arrays.asList(this.players).indexOf(this.currentPlayer) + 1) % this.players.length];
          
        }
      }
    }
    else{
      // check if any buttons are clicked
      for (Button button : buttons){ // TODO: make function of following?
        if (mX >= button.getX() && mY >= button.getY() && mX < button.getX()+button.getWidth() && mY < button.getY()+button.getHeight()){
          button.click();
          break;
        }
      }
    }
  }
}