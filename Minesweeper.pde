

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
boolean isLost = false;
int tileCount = 0;
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
         buttons[r][c] = new MSButton(r,c);
      }
    }
    setBombs();
}
public void setBombs()
{
  while(bombs.size() < NUM_BOMBS)
  {
    int r = (int)(Math.random() * 20);
    int c = (int)(Math.random() * 20);
    if(!bombs.contains(buttons[r][c])){
    bombs.add(buttons[r][c]);
  }
 }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
     for (int i = 0; i < NUM_ROWS; i++) {
     for (int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].draw();
      }
    }
}
public boolean isWon(){return false;}
public void displayLosingMessage()
{  
    for(int i=0;i<bombs.size();i++)
        if(bombs.get(i).isClicked()==false)
            bombs.get(i).mousePressed();
    isLost = true;
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("L");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("S");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("E");
}
public void displayWinningMessage()
{
    isLost = true;
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("W");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("N");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
         if (isLost == false) {
        if (mouseButton == RIGHT && buttons[r][c].isClicked()) {}
        else if (mouseButton == RIGHT) {marked = !marked;}
        else if (marked == true) {}
        else if (bombs.contains(this)) {
          clicked = true;
          displayLosingMessage();
        }
        else if (countBombs(r,c) > 0) {
          label = ""+countBombs(r,c);
          if (!clicked) {tileCount+=1;}
          if (tileCount == 400-bombs.size()) {displayWinningMessage();}
          clicked = true;
        }
        else {

          
          if (!clicked) {tileCount+=1;}
          if (tileCount == 400-bombs.size()) {displayWinningMessage();}
          clicked = true;
          
          if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked()) {
          buttons[r-1][c-1].mousePressed();} 
          if(isValid(r-1,c) && !buttons[r-1][c].isClicked()) {
          buttons[r-1][c].mousePressed();}
          if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked()){
          buttons[r-1][c+1].mousePressed();}
          
          if(isValid(r,c-1) && !buttons[r][c-1].isClicked()){
          buttons[r][c-1].mousePressed();}
          if(isValid(r,c+1) && !buttons[r][c+1].isClicked()){
          buttons[r][c+1].mousePressed();}
          
          if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked()){
          buttons[r+1][c-1].mousePressed();}
          if(isValid(r+1,c) && !buttons[r+1][c].isClicked()){
          buttons[r+1][c].mousePressed();}
          if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked()){
          buttons[r+1][c+1].mousePressed();}
        }
      }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         
         else if( !marked && clicked && bombs.contains(this) ) 
             fill(255,0,0);
         else if( marked && bombs.contains(this) ) 
             fill(100);
         else if( !marked && clicked && !bombs.contains(this) ) 
             fill(200);
             
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
      if(r < 20 && r >= 0)
        if(c < 20 && c >= 0)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(row-1,col) == true && bombs.contains(buttons[row-1][col]))
        {
            numBombs++;
        }
        if (isValid(row+1,col) == true && bombs.contains(buttons[row+1][col]))
        {
            numBombs++;
        }
         if (isValid(row,col-1) == true && bombs.contains(buttons[row][col-1]))
        {
            numBombs++;
        }
         if (isValid(row,col+1) == true && bombs.contains(buttons[row][col+1]))
        {
            numBombs++;
        }
         if (isValid(row-1,col+1) == true && bombs.contains(buttons[row-1][col+1]))
        {
            numBombs++;
        }
         if (isValid(row-1,col-1) == true && bombs.contains(buttons[row-1][col-1]))
        {
            numBombs++;
        }
         if (isValid(row+1,col+1) == true && bombs.contains(buttons[row+1][col+1]))
        {
            numBombs++;
        }
         if (isValid(row+1,col-1) == true && bombs.contains(buttons[row+1][col-1]))
        {
            numBombs++;
        }
        return numBombs;
    }
}
