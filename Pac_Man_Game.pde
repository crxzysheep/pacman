// setup variables
/*
0 = empty space
1 = wall
2 = space with pellet
3 = ghost only
4 = invincible pellet
*/            //0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18  
int[][] map = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, //0
               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1}, //1
               {1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1}, //2
               {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1}, //3
               {1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1}, //4
               {1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1}, //5
               {1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1}, //6
               {1, 0, 0, 0, 0, 0, 0, 1, 1, 3, 1, 1, 0, 1, 0, 0, 0, 0, 1}, //7
               {1, 1, 1, 1, 0, 1, 0, 1, 3, 3, 3, 1, 0, 1, 1, 1, 1, 0, 1}, //8 //<>//
               {1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1}, //9
               {1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1}, //10
               {1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1}, //11
               {1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1}, //12
               {1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1}, //13
               {1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1}, //14
               {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, //15
               {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}}; //16

boolean menu = true;

// pac man variables
int PacPosX = 190;
int PacPosY = 270;
int PacSpeed = 3;
int PacManLives = 0;
int score = 0;
String PacManDirection = "RIGHT";
String NextDirection = "NONE";
boolean PacManInvincible = false;
int InvincibleTimer = 0;

// ghost variables
int noOfGhosts = 4;
ArrayList<Ghost> ghosts = new ArrayList<Ghost>();

// dot locations
ArrayList<Integer> dotLocations = new ArrayList<Integer>();

// setup the screen
void setup(){
  size(470, 430);  // screen size, (w, h)
  frameRate(30); // 30fps
  resetBoard(); 
  for(int i = 0; i < noOfGhosts; i++) ghosts.add(new Ghost(180, 160, color(random(50, 255), random(50, 255), random(50, 255))));  // spawn ghosts
}// end setup

// main game loop
void draw() { 
  background(0);
  if(menu == true){
    if(PacManLives == 3){
      textSize(100);
      fill(226, 225, 0);
      text("PAC MAN", 50, 200);
      textSize(25);
      text("Press e on your keyboard to start", 60, 250);
    }
    else{
      textSize(100);
      fill(226, 225, 0);
      text("GAME", 90, 130);
      text("OVER", 90, 210);
      textSize(25);
      text("Press e on your keyboard to restart", 60, 250);
    }
  }
  else{
    set_map();
    updatePacMan();
    
    for(int ghost = 0; ghost < ghosts.size(); ghost++){
      ghosts.get(ghost).update();
    }
    
    if(check_dots()){
      resetBoard();
    }
    
    if(InvincibleTimer > 0){
      InvincibleTimer-=1;
    }
    else PacManInvincible = false;
    
    fill(255);
    textSize(15);
    text("Score: "+score, 10, 25);
    text("Lives: "+PacManLives, 10, 410);
    
    if(PacManLives == 0) menu = true;
  }
} // end void draw

// draw game map
void set_map(){ 
  strokeWeight(2);
  for(int row = 0; row < 17; row++){ // y
    for(int col = 0; col < 19; col ++){ // x
      if(map[row][col] == 1) { // draw walls
        stroke(11, 30, 140); // set color
        fill(11, 30, 140); // set color
        
        int tempX = 45+col*20;
        int tempY = 45+row*20;
        
        if(row != 16 && col != 18 && map[row+1][col] == 1 && map[row][col+1] == 1) rect(tempX, tempY, 20, 10);
        if(row != 16 && map[row+1][col] == 1) rect(tempX, tempY, 10, 20);
        else if(col != 18 && map[row][col+1] ==1) rect(tempX, tempY, 20, 10);
        else rect(tempX, tempY, 10, 10);
      } // end draw walls
      else if(map[row][col] == 2){ // draw dots
        stroke(255);
        fill(255);
        circle(50+col*20, 50+row*20, 3);
      } // end dot drawing
      else if(map[row][col] == 4){
        stroke(211, 217, 37);
        fill(211, 217, 37);
        circle(50+col*20, 50+row*20, 8);
      }
    } //end loop
  }// end loops
}// end set map

// check if there are any remaining dots on map
boolean check_dots(){
  for(int row = 0; row < 17; row++){
    for(int col = 0; col < 19; col++){
      if(map[row][col] == 2){
        return false;
      }
    }
  }
  return true;
}

// Enemy objects
class Ghost{
  int GhostX;
  int GhostY;
  String GhostState = "DEAD";
  String GhostDirection = "UP";
  color GhostColor;
  int GhostSpeed = 2;
  int turnTimer = 5;
  
  // setup ghost
  Ghost(int x, int y, color c){ 
    GhostX = x;
    GhostY = y;
    GhostColor = c;
  }// end ghost
  
  void update(){
    int GhostRow = GhostY/20;
    int GhostCol = GhostX/20;
    turnTimer-=1;
    
    // move ghost
    if(GhostDirection == "UP"){
      if(map[GhostRow-1][GhostCol] != 1){
        GhostY-=GhostSpeed;
      }
      if((map[GhostRow][GhostCol-1] != 1 || map[GhostRow][GhostCol+1] != 1) && turnTimer == 0 || map[GhostRow-1][GhostCol] == 1){
        turn();
      }
      else{
        GhostY -= GhostSpeed;
      }
    }
    else if(GhostDirection == "DOWN"){
      if(map[GhostRow+1][GhostCol] != 1){
        GhostY+=GhostSpeed;
      }
      if((map[GhostRow][GhostCol-1] != 1 || map[GhostRow][GhostCol+1] != 1) && turnTimer == 0 || map[GhostRow+1][GhostCol] == 1){
        turn();
      }
      else{
        GhostY += GhostSpeed;
      } 
    }
    else if(GhostDirection == "LEFT"){
      if(map[GhostRow][GhostCol-1] != 1){
        GhostX-=GhostSpeed;
      }
      if((map[GhostRow-1][GhostCol] != 1 || map[GhostRow+1][GhostCol] != 1)&& turnTimer == 0  || map[GhostRow][GhostCol-1] == 1){
        turn();
      }
      else{
        GhostX -= GhostSpeed;
      }
    }
    else if(GhostDirection == "RIGHT"){
      if(map[GhostRow][GhostCol+1] != 1){
        GhostX+=GhostSpeed;
      }
      if((map[GhostRow-1][GhostCol] != 1 || map[GhostRow+1][GhostCol] != 1)&& turnTimer == 0 || map[GhostRow][GhostCol+1] == 1){
        turn();
      }
      else{
        GhostX += GhostSpeed;
      }
    }
    
    // check if ghost touches pac man
    if(GhostRow == (int)PacPosY/20 && GhostCol == (int)PacPosX/20){
      if(!PacManInvincible){
        PacManLives -=1;
        PacPosX = 190;
        PacPosY = 270;
      }
      else if(PacManInvincible){
        score += 200;
        GhostX = 180;
        GhostY = 160;
      }
    }
    
    if(turnTimer == 0){
      turnTimer = 15;
    }
    
    drawGhost();
  }// update movement
  
  void SetGhostColor(color c){
    GhostColor = c;
  }
  
  // ghost graphics
  void drawGhost(){ 
    int x = GhostX+45;
    int y = GhostY+45;
    
    // body 
    noStroke();
    if(PacManInvincible) fill(50, 50, 255);
    else fill(GhostColor);
    arc(x, y, 20, 20, PI, TWO_PI);
  
    triangle(x-10, y, x-10, y+10, x, y);
    triangle(x-10, y+4, x-3, y+10, x+7, y);
    triangle(x-6, y-1, x+3, y+10, x+10, y+3);
    triangle(x-1, y, x+9, y+10, x+10, y);
    
    // eyes
    fill(255);
    circle(x-3, y-1, 7);
    circle(x+5, y-1, 7);
    
    fill(0);
    // pupils
    if(GhostDirection == "UP"){
      circle(x-3, y-3, 3);
      circle(x+5, y-3, 3);
    }
    else if(GhostDirection == "DOWN"){
      circle(x-3, y+1, 3);
      circle(x+5, y+1, 3);
    }
    else if(GhostDirection == "LEFT"){
      circle(x-5, y-1, 3);
      circle(x+3, y-1, 3);
    }
    else if(GhostDirection == "RIGHT"){
      circle(x-1, y-1, 3);
      circle(x+7, y-1, 3);
    }
  }// end draw ghost
  
  void turn(){
    int GhostPosCol = GhostX / 20;
    int GhostPosRow = GhostY / 20;
    ArrayList<String> availableTurns = new ArrayList<String>();
    
    if(map[GhostPosRow-1][GhostPosCol] != 1){
      availableTurns.add("UP");
    }
    if(map[GhostPosRow+1][GhostPosCol] != 1){
      availableTurns.add("DOWN");
    }
    if(map[GhostPosRow][GhostPosCol+1] != 1){
      availableTurns.add("RIGHT");
    }
    if(map[GhostPosRow][GhostPosCol-1] != 1){
      availableTurns.add("LEFT");
    }
    
    GhostDirection = availableTurns.get((int) random(0, availableTurns.size()));
  } // end turn
}// end Ghost class

void resetBoard(){
  for(int col = 0; col < 17; col++) for(int row = 0; row < 19; row++) if(map[col][row] == 0) map[col][row] = 2;
  map[14][1] = 4;
  map[3][1] = 4;
  map[1][16] = 4;
  map[15][16] = 4;  
} // end reset board

// update pac man and movement
void updatePacMan(){
  int PacManCol = PacPosX/20;
  int PacManRow = PacPosY/20;
  PacSpeed = 3;
  
  // increase score
  if(map[PacManRow][PacManCol] == 2){ 
    map[PacManRow][PacManCol] = 0;
    score+=100;
  }
  else if(map[PacManRow][PacManCol] == 4){
    PacManInvincible = true;
    InvincibleTimer = 100;
    map[PacManRow][PacManCol] = 0;
  }
  
  // movement and stopping
  if(PacManDirection == "UP" ){
    if(map[(int) (PacPosY-13)/20][PacManCol] == 1) PacSpeed = 0;
    else PacPosY -= PacSpeed;
  }
  if(PacManDirection == "DOWN" ){
    if(map[(int) (PacPosY+13)/20][PacManCol] == 1) PacSpeed = 0;
    else PacPosY += PacSpeed;
  }
  if(PacManDirection == "LEFT" ){
    if(map[PacManRow][(int) (PacPosX-9)/20] == 1) PacSpeed = 0;
    else PacPosX -= PacSpeed;
  }
  if(PacManDirection == "RIGHT" ){
    if(map[PacManRow][(int) (PacPosX+13)/20] == 1) PacSpeed = 0;
    else PacPosX += PacSpeed;
  }
  
  // turn
  if(NextDirection == "UP"){
    if(map[(int)(PacPosY-11)/20][PacManCol] != 1){
      PacManDirection = "UP";
      PacPosX = PacManCol*20+5;
    }
  }
  else if(NextDirection == "DOWN"){
    if(map[(int) (PacPosY+13)/20][PacManCol] != 1) {
      PacManDirection = "DOWN";
      PacPosX = PacManCol*20+5;
    }
  }
  else if(NextDirection == "LEFT"){
    if(map[PacManRow][(int) (PacPosX-11)/20] != 1) {
      PacManDirection = "LEFT";
      PacPosY = PacManRow*20+10;
    }
  }
  else if(NextDirection == "RIGHT"){
    if(map[PacManRow][(int) (PacPosX+15)/20] != 1){
      PacManDirection = "RIGHT";
      PacPosY = PacManRow*20+10;
    }
  }
  
  // pac man graphic
  fill(226,225,0);
  stroke(0);
  arc(PacPosX+45, PacPosY+40, 20, 20, radians(45), radians(315), PIE);
} // end pac man update

// player input
void keyPressed(){
  if(key == CODED){
    if(keyCode == UP) NextDirection = "UP";
    else if(keyCode == DOWN) NextDirection = "DOWN";
    else if(keyCode == LEFT) NextDirection = "LEFT";
    else if(keyCode == RIGHT) NextDirection = "RIGHT";
  }
  else if(key == 'e' || key == 'E'){
    menu = !menu;
    PacPosX = 190;
    PacPosY = 270;
    PacSpeed = 3;
    PacManLives = 3;
    resetBoard();
  }
  if(menu == true){
    
  }
}// end player input
