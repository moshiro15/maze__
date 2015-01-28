/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/16976*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

PFont font;

int[] mazeSizes = {
  6,8,10,12,15,20
};
int mazeIndex=0;

Maze maze;
Ball ball;

boolean finished;
long timer;

int secretMazeSize;

void setup() {
  size(650,650);
  //size(screen.width,screen.height); 
  font = loadFont("CuteWriting-60.vlw"); //different font
  //smooth();
  background(#FEE0FF); //color 

  maze = new Maze(width/2-300,height/2-300,600,mazeSizes[0]);

  ball = new Ball(maze.x+maze.step/2, maze.y+maze.step/2,3*maze.step/4,color(#67EDA4)); //changed color

  finished = false;
  timer = millis();
}

void draw() {

  if (!maze.complete) {
    maze.routeStep();
  }

  else {
    if (!finished) {
      background(255);
      maze.display();

      //indicate destination cell
      fill(#C195FF);
      stroke(#FAC7FA);
      strokeWeight(3);
      ellipse(maze.destinationX+maze.step/2,maze.destinationY+maze.step/2,3*maze.step/4+2,3*maze.step/4+2);

      //show player position
      ball.display();

      if (ball.x>maze.destinationX && ball.y>maze.destinationY) {
        finished = true;
      }
    }
    else {
      noStroke(); 
      fill(#E0FFE0); //changed color
      rect(0,0,width,height);
      fill(255);
      rect(width/6,height/2-125,4*width/6,250);
      textFont(font,60);
      textAlign(CENTER,CENTER);
      fill(#F789A7); //changed color
      text("you win!!!\nhit space for\na new maze",width/2,height/2);
    }
  }
}

void keyPressed() {

  if (!finished) {
    boolean[] walls = maze.travelThrough(ball.x, ball.y);

    if (keyCode == UP) {
      if (!walls[0]) ball.place(ball.x,max(maze.step/2,ball.y-maze.step));
    }
    if (keyCode == DOWN) {
      if (!walls[1]) ball.place(ball.x,min(height-maze.step/2,ball.y+maze.step));
    }
    if (keyCode == LEFT) {
      if (!walls[2]) ball.place(max(maze.step/2,ball.x-maze.step),ball.y);
    }
    if (keyCode == RIGHT) {
      if (!walls[3]) ball.place(min(width-maze.step/2,ball.x+maze.step),ball.y);
    }
  }
  else {
    if (key == ' ') {
      background(#E0FFE0); //changed color

      mazeIndex = (mazeIndex+1) % mazeSizes.length;
      maze.reset(mazeSizes[mazeIndex]);
      ball.resize(3*maze.step/4);
      ball.place(maze.x+ maze.step/2, maze.y+maze.step/2);
    }
  }

  //secret maze generation
  if (key == 'n') {
    background(255,245,235);
    secretMazeSize+=10;
    maze.reset(secretMazeSize);
    ball.resize(3*maze.step/4);
    ball.place(maze.x+ maze.step/2, maze.y+maze.step/2);
  }
}

