PImage backgroundImg, groundhogIdleImg, groundhogDownImg, groundhogLeftImg, groundhogRightImg;
PImage lifeImg, cabbageImg, soldierImg, soilImg;
PImage gameOverImg, titleImg, startNormal, restartNormal, startHovered, restartHovered;

final int GAME_START = 0;
final int GAME_RUN   = 1;
final int GAME_OVER  = 2;
int gameState = GAME_START;

final int BUTTON_TOP    = 360;
final int BUTTON_BOTTOM = 420;
final int BUTTON_LEFT   = 248;
final int BUTTON_RIGHT  = 392;
final int GRID = 80;

boolean leftPressed  = false;
boolean rightPressed = false;
boolean downPressed  = false;
boolean noPressed    = true;

int speedX,soldierXAxis,soldierYAxis, oldTime, nowTime;
int groundhogIdleX, groundhogIdleY, groundhogMovingSpeed, groundhogMovingSpeed2;
int cabbageX, cabbageY, lifeImage1X, lifeImage2X, lifeImage3X, outOfCanvas;
int mainX, mainY, hogFrame;
int lastTime=0;

void setup() {

	size(640, 480, P2D);
  backgroundImg     = loadImage("img/bg.jpg");
  groundhogIdleImg  = loadImage("img/groundhogIdle.png"); 
  groundhogDownImg  = loadImage("img/groundhogDown.png");
  groundhogLeftImg  = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage ("img/groundhogRight.png");
  
  lifeImg     = loadImage ("img/life.png");
  cabbageImg  = loadImage("img/cabbage.png");
  soldierImg  = loadImage("img/soldier.png");
  soilImg     = loadImage("img/soil.png");
  
  gameOverImg    = loadImage("img/gameover.jpg");
  titleImg       = loadImage("img/title.jpg");
  startNormal    = loadImage("img/startNormal.png");
  restartNormal  = loadImage("img/restartNormal.png");
  startHovered   = loadImage("img/startHovered.png");
  restartHovered = loadImage("img/restartHovered.png");

  groundhogIdleX = width/2;
  groundhogIdleY = 80;
  groundhogMovingSpeed  = 80;
  groundhogMovingSpeed2 = 20;
    
  //soldier moving speed
  speedX       = 6;
  soldierXAxis = -100;
  soldierYAxis = floor(random(2,6))*80;
 
  //cabbage location
  cabbageX = floor(random(0,8))*80;
  cabbageY = floor(random(2,6))*80;
  
  lifeImage1X = 10;
  lifeImage2X = 80;
  lifeImage3X = -80;
  outOfCanvas = -80;
  
  //frameRate(60);
  //lastTime = millis();

}

void draw() {

  // Switch Game State
  switch(gameState){
    case GAME_START:
      image (titleImg,0,0);
      image (startNormal,248,360);
      if (mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT &&
          mouseY > BUTTON_TOP  && mouseY < BUTTON_BOTTOM){
          image (startHovered,248,360);  //startBotton turn light
          if (mousePressed){             //also the botton has to be pressed
            gameState = GAME_RUN;
          }
       }
    break;

    case GAME_RUN:

      //soldier moving
      soldierXAxis += speedX;
      if (soldierXAxis > width) {soldierXAxis = -100;}
      
      //bg, grass, soil, cabbage
      image(backgroundImg,0,0);
      image(soilImg,0,160);
      noStroke();
      fill(124, 204, 25);
      rect(0,145,width,15);
      image(cabbageImg,cabbageX, cabbageY);
      
      //3 lives
      image(lifeImg,lifeImage1X,10);
      image(lifeImg,lifeImage2X,10);
      image(lifeImg,lifeImage3X,10);
      
      //sun
      fill(253, 184, 19);
      stroke(255, 255, 0);
      strokeWeight(5);
      ellipse(590,50,120,120);
      
      //characters
      //image (groundhogIdleImg,groundhogIdleX,groundhogIdleY);
      image (soldierImg,soldierXAxis,soldierYAxis);
      
      //AABB hit, A=soldier,B=hog
      if( soldierXAxis    < groundhogIdleX+80 && 
          soldierXAxis+80 > groundhogIdleX    &&
          soldierYAxis    < groundhogIdleY+80 &&
          soldierYAxis+80 > groundhogIdleY){
            groundhogIdleX = width/2;
            groundhogIdleY = 80;      // hog back to ground
            if (lifeImage3X == 150){  // -life
              lifeImage3X = outOfCanvas;
            }
            else if(lifeImage2X == 80 && lifeImage3X == outOfCanvas){
              lifeImage2X = outOfCanvas;
            }
            else if (lifeImage1X ==10 && lifeImage2X == outOfCanvas){
              lifeImage1X = outOfCanvas;
            }
          downPressed = false;
          leftPressed = false;
          rightPressed = false;
      }
      
      //AABB hit, A=cabbage,B=hog
      if( cabbageX    < groundhogIdleX+80 &&
          cabbageX+80 > groundhogIdleX    &&
          cabbageY    < groundhogIdleY+80 &&
          cabbageY+80 > groundhogIdleY){
            cabbageX = outOfCanvas;
            cabbageY = outOfCanvas;
            // eat cabbage to +life
            if(lifeImage2X == 80 && lifeImage3X == outOfCanvas){
              lifeImage3X = 150;
            }
            else if (lifeImage1X == 10 && lifeImage2X == outOfCanvas){
              lifeImage2X = 80;
            }
      }
      
      if(lifeImage1X == outOfCanvas){
        gameState = GAME_OVER;
      }
      
      if (downPressed == false && leftPressed == false && rightPressed == false) {
        image(groundhogIdleImg, groundhogIdleX, groundhogIdleY);
      }
  
      if(downPressed){
        hogFrame++;
        if(hogFrame > 0 && hogFrame < 15){
          groundhogIdleY += GRID/15.0;
          image(groundhogDownImg, groundhogIdleX,groundhogIdleY);
        }else{
          groundhogIdleY = mainY+=GRID;
          downPressed = false;
        }
      }
      
      if(leftPressed){
        hogFrame++;
        if(hogFrame >0 && hogFrame <15){
          groundhogIdleX -= GRID/15.0;
          image(groundhogLeftImg, groundhogIdleX,groundhogIdleY);
        }else{
          groundhogIdleX = mainX -=GRID;
          leftPressed = false;
        }
      }
      
      if(rightPressed){
        hogFrame++;
        if(hogFrame >0 && hogFrame <15){
          groundhogIdleX += GRID/15.0;
          image(groundhogRightImg, groundhogIdleX,groundhogIdleY);
        }else{
          groundhogIdleX = mainX +=GRID;
          rightPressed = false;
        }
      }
    break;

    case GAME_OVER:
      image (gameOverImg,0,0);
      image (restartNormal,248,360);
      if (mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT &&
          mouseY > BUTTON_TOP  && mouseY < BUTTON_BOTTOM){
            image (restartHovered,248,360);
            if (mousePressed){
              downPressed    = false;
              leftPressed    = false;
              rightPressed   = false;
              gameState      = GAME_RUN;
              groundhogIdleX = width/2;
              groundhogIdleY = 80;
              lifeImage1X    = 10;
              lifeImage2X    = 80;
              speedX         = 6;
              soldierXAxis   = -100;
              soldierYAxis   = floor(random(2,6))*80;
              cabbageX       = floor(random(0,8))*80;
              cabbageY       = floor(random(2,6))*80;
            }
      }
    break;
  } //for switch
    
  //// delta time  
  //oldTime = nowTime;
  //nowTime = millis();
  
  //if(gameState == GAME_RUN){
  //  if (keyPressed){
  //    if (key == CODED){
  //      switch (keyCode){
  //      case LEFT:
        
  //      if(nowTime - oldTime >=250){
  //        groundhogIdleX -= groundhogMovingSpeed;

  //        nowTime = millis();
  //      }
  //      else{          
  //        groundhogIdleX -=groundhogMovingSpeed/4;
  //        }      
  //      image(groundhogLeftImg,groundhogIdleX,groundhogIdleY);
  //      break;
        
  //      case RIGHT:
  //      if(nowTime - oldTime >=250){
  //        groundhogIdleX += groundhogMovingSpeed;
  //        nowTime = millis();
  //      }else{
  //        groundhogIdleX +=groundhogMovingSpeed/4;
  //        }
  //      image(groundhogRightImg,groundhogIdleX,groundhogIdleY);
  //      break;
        
  //      case DOWN:
  //      if(nowTime - oldTime >=250){
  //        groundhogIdleY += groundhogMovingSpeed;
  //        nowTime = millis();
  //      }else{
  //        groundhogIdleY +=groundhogMovingSpeed/4;
  //        }
  //      image(groundhogDownImg,groundhogIdleX,groundhogIdleY);
  //      break;
  //      } //for switch keyCode
  //    }
  //  }
  //}
  
  // edge limit for hog
  if (groundhogIdleX > width-GRID)  {groundhogIdleX = width-GRID;}
  if (groundhogIdleX < 0)         {groundhogIdleX = 0;}
  if (groundhogIdleY > height-GRID) {groundhogIdleY = height-GRID;}
  
} //for draw

void keyPressed(){
  float oldTime = nowTime;
  float nowTime = millis();
  
  if (gameState == GAME_RUN){
    if (key == CODED){
        switch(keyCode){
        case LEFT:
        if(leftPressed == false && rightPressed == false && downPressed == false){ 
          leftPressed = true;
          noPressed = false;
          if (groundhogIdleX <= 0){
            groundhogIdleX = 0;
          }
          oldTime = nowTime;
        }
        hogFrame =0;
        mainX = groundhogIdleX;
        break;
        
        //if(nowTime-oldTime >250){
        //  leftPressed = true;
        //  noPressed = false;
        //  hogFrame =0;
        //  mainX = groundhogIdleX;
        //  oldTime = nowTime;
        //}else{
        //  leftPressed = false;
        //}
        //break;
               
        case RIGHT:
        if(rightPressed == false && leftPressed == false && downPressed == false){ 
          rightPressed = true;
          noPressed = false;
          if (groundhogIdleX >= width-GRID){
            groundhogIdleX = width-GRID;
          }
          oldTime = nowTime;
        }
        hogFrame =0;
        mainX = groundhogIdleX;
        break;
        
        //if(nowTime-oldTime >250){
        //  rightPressed = true;
        //  noPressed = false;
        //  hogFrame =0;
        //  mainX = groundhogIdleX;
        //  oldTime = nowTime;
        //}else{
        //  rightPressed = false;
        //}
        //break;
        
        case DOWN:
        if(downPressed == false && leftPressed == false && rightPressed == false){ 
          downPressed = true;
          noPressed = false;
          if (groundhogIdleY >= height){
            groundhogIdleY = GRID*5;
          }
          oldTime = nowTime;
        }
        hogFrame =0;
        mainY = groundhogIdleY;
        break;
        
        //if(nowTime-oldTime >250){
        //  downPressed = true;
        //  noPressed = false;
        //  hogFrame =0;
        //  mainY = groundhogIdleY;
        //  oldTime = nowTime;
        //}else{
        //  downPressed = false;
        //}
        //break;
        
        }
      }
  }
}
