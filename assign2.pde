

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;
final int GAME_OVER = 3;

final int ONE_BLOCK = 80;
final int SOIL_H = 320;
final int SUN_W = 120;
final int SUN_D = 50; //Distance from center to boundary
final int GRASS_H = 15; //Grass thickness

final int LIFE_W = 50;
final int LIFE_H = 50;
final int LIFE_D = 20; //Distance between life

final int GROUNDHOG_W = 80;
final int GROUNDHOG_H = 80;

final int SOLDIER_W = 80;
final int SOLDIER_H = 80;

final int CABBAGE_W = 80;
final int CABBAGE_H = 80;

PImage bgImg, lifeImg, soilImg, soldierImg, cabbageImg;
PImage groundhogIdleImg, groundhogDownImg, groundhogLeftImg, groundhogRightImg;
PImage gameoverImg, titleImg;
PImage restartHoveredImg, restartNormalImg, startHoveredImg, startNormalImg;

float groundhogX, groundhogY;
float soldierX, soldierY, soldierSpeed;
float cabbageX, cabbageY;
float groundhogLestX, groundhogLestY;

int gameState;
int groundhogMoveTime = 250;
int hitPoints = 2; //groundhog's initial life point
int actionFrame; //groundhog's moving frame 
float lastTime; //time when the groundhog finished moving

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void setup() {
  size(640, 480, P2D);
  // Enter Your Setup Code Here
  bgImg = loadImage("img/bg.jpg");
  lifeImg = loadImage("img/life.png");
  soilImg = loadImage("img/soil.png");
  soldierImg = loadImage("img/soldier.png");
  cabbageImg = loadImage("img/cabbage.png");
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
  gameoverImg = loadImage("img/gameover.jpg");
  titleImg = loadImage("img/title.jpg");
  restartHoveredImg = loadImage("img/restartHovered.png");
  restartNormalImg = loadImage("img/restartNormal.png");
  startHoveredImg = loadImage("img/startHovered.png");
  startNormalImg = loadImage("img/startNormal.png");

  soldierX = 0;
  soldierY = floor(random(4))*ONE_BLOCK + ONE_BLOCK*2;
  soldierSpeed = floor(random(3))+1;

  cabbageX = floor(random(8))*ONE_BLOCK;
  cabbageY = floor(random(4))*ONE_BLOCK + ONE_BLOCK*2;

  groundhogX = ONE_BLOCK*4;
  groundhogY = ONE_BLOCK;

  frameRate(60);
  gameState = GAME_START;
  lastTime = millis(); // save lastest time call the millis();
}

void draw() {
  // Switch Game State
  switch(gameState) {

    // Game Start
  case GAME_START:
    image(titleImg, 0, 0, width, height);
    image(startNormalImg, 248, 360, 144, 60);
    // mouse action
    if (mouseX > 248 && mouseX < 392 && mouseY > 360 && mouseY < 420) {
      if (mousePressed) {
        gameState = GAME_RUN;
      } else {
        image(startHoveredImg, 248, 360, 144, 60);
      }
    }
    break;  

    // Game Run
  case GAME_RUN:
    image(bgImg, 0, 0, width, height);
    image(soilImg, 0, ONE_BLOCK*2, width, SOIL_H);
    //life
    if (hitPoints == 0) {
      gameState = GAME_OVER;
    }
    if (hitPoints == 1) {
      image(lifeImg, LIFE_D/2, LIFE_D/2, LIFE_W, LIFE_H);
    }
    if (hitPoints == 2) {
      image(lifeImg, LIFE_D/2, LIFE_D/2, LIFE_W, LIFE_H);
      image(lifeImg, LIFE_D*4, LIFE_D/2, LIFE_W, LIFE_H);
    }
    if (hitPoints == 3) {
      image(lifeImg, LIFE_D/2, LIFE_D/2, LIFE_W, LIFE_H);
      image(lifeImg, LIFE_D*4, LIFE_D/2, LIFE_W, LIFE_H);
      image(lifeImg, LIFE_D/2 + LIFE_D*7, LIFE_D/2, LIFE_W, LIFE_H);
    }
    //sun
    strokeWeight(5);
    stroke(255, 255, 0);
    fill(253, 184, 19);
    ellipse(width - SUN_D, SUN_D, SUN_W, SUN_W);
    //grass
    noStroke();
    fill(124, 204, 25);
    rect(0, ONE_BLOCK*2 - GRASS_H, width, GRASS_H);
    //cabbage
    image(cabbageImg, cabbageX, cabbageY, CABBAGE_W, CABBAGE_H);
    if (groundhogX + GROUNDHOG_W > cabbageX && groundhogX < cabbageX + CABBAGE_W
      && groundhogY + GROUNDHOG_H > cabbageY && groundhogY < cabbageY + CABBAGE_H) {
      cabbageX = width + CABBAGE_W; //cabbage is eaten
      hitPoints = hitPoints+1;
    }
    //soldier
    soldierX += soldierSpeed;
    soldierX %= (width+SOLDIER_W);
    image(soldierImg, soldierX-SOLDIER_W, soldierY, SOLDIER_W, SOLDIER_H);
    if (groundhogX + GROUNDHOG_W > soldierX-SOLDIER_W && groundhogX < soldierX) {
      if (groundhogY + GROUNDHOG_H > soldierY && groundhogY < soldierY + SOLDIER_H) {
        //When the groundhog hits a soldier, it reduces one life point.
        hitPoints = hitPoints-1;
        //Groundhog willn't return to its original position when its life point is zeroed
        if (hitPoints > 0 && hitPoints <= 3) {
          groundhogX = ONE_BLOCK*4;
          groundhogY = ONE_BLOCK;
        }
        //When returning to its original position, the groundhog doesn't start moving directly
        downPressed = false; 
        leftPressed = false;
        rightPressed = false;
      }
    }
    //groundhog
    //print(downPressed+"\n");
    //When the button is not pressed, draw the groundhogIdle image
    if (downPressed == false && leftPressed == false && rightPressed == false) {
      image(groundhogIdleImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
    }
    //draw the groundhogDown image between 1-14 frames
    if (downPressed) {
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15) {
        groundhogY += ONE_BLOCK / 15.0;
        image(groundhogDownImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
      } else {
        groundhogY = groundhogLestY + ONE_BLOCK;
        downPressed = false;
      }
    }
    //draw the groundhogLeft image between 1-14 frames
    if (leftPressed) {
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15) {
        groundhogX -= ONE_BLOCK / 15.0;
        image(groundhogLeftImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
      } else {
        groundhogX = groundhogLestX - ONE_BLOCK;
        leftPressed = false;
      }
    }
    //draw the groundhogRight image between 1-14 frames
    if (rightPressed) {
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15) {
        groundhogX += ONE_BLOCK / 15.0;
        image(groundhogRightImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
      } else {
        groundhogX = groundhogLestX + ONE_BLOCK;
        rightPressed = false;
      }
    }

    //groundhog: boundary detection
    if (groundhogX >= width - ONE_BLOCK) {
      groundhogX = width - ONE_BLOCK;
    }
    if (groundhogX <= 0) {
      groundhogX = 0;
    }
    if (groundhogY >= height - ONE_BLOCK) {
      groundhogY = height - ONE_BLOCK;
    }
    if (groundhogY <= 0) {
      groundhogY = 0;
    }
    break;

    // Game Over
  case GAME_OVER:
    image(gameoverImg, 0, 0, width, height);
    image(restartNormalImg, 248, 360, 144, 60);
    // mouse action
    if (mouseX > 248 && mouseX < 392 && mouseY > 360 && mouseY < 420) {
      if (mousePressed) {
        downPressed =false;
        leftPressed = false;
        rightPressed = false;
        soldierX = 0;
        soldierY = floor(random(4))*ONE_BLOCK + ONE_BLOCK*2;
        soldierSpeed = floor(random(3))+1;
        cabbageX = floor(random(8))*ONE_BLOCK;
        cabbageY = floor(random(4))*ONE_BLOCK + ONE_BLOCK*2;
        hitPoints = 2;
        groundhogX = ONE_BLOCK*4;
        groundhogY = ONE_BLOCK;
        gameState = GAME_RUN;
      } else {
        image(restartHoveredImg, 248, 360, 144, 60);
      }
    }
    break;
  }
}

void keyPressed() {
  float newTime = millis(); //time when the groundhog started moving
  if (key == CODED) {
    switch (keyCode) {
    case DOWN:
      if (newTime - lastTime > 250) {
        downPressed = true;
        actionFrame = 0;
        groundhogLestY = groundhogY;
        lastTime = newTime;
      }
      break;
    case LEFT:
      if (newTime - lastTime > 250) {
        leftPressed = true;
        actionFrame = 0;
        groundhogLestX = groundhogX;
        lastTime = newTime;
      }
      break;
    case RIGHT:
      if (newTime - lastTime > 250) {
        rightPressed = true;
        actionFrame = 0;
        groundhogLestX = groundhogX;
        lastTime = newTime;
      }
      break;
    }
  }
}
