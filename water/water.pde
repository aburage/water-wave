// 水面波の模倣

float [][] high = new float [150][150];  // 波の高さ
float [][] Vel = new float [150][150];   // 波の速さ
int [][] col = new int [150][150];       // 色
float accel;  // 加速度
int n=5;      // point位置の倍数

void setup() {
  size(750, 750, P3D);
  strokeWeight(8);
  strokeCap(SQUARE);  // strokeを四角形で描画
  colorMode(HSB, 360);   // HSBモード(最大値360)
  frameRate(50);
  for (int x=0; x<150-1; x++) {
    for (int y=0; y<150-1; y++) {
      high[x][y]=0;
      Vel[x][y]=0;
    }
  }
  high[75][75]=3;  // (75,75)に水滴を落とす
}

float t=0;
int camY=200;  // カメラ視点Y
int d3=0;

void draw() {
  background(200, 0, 360);
  if (keyPressed) {
    // カメラ視点Yの変化
    if (keyCode == UP) camY += 10;
    if (keyCode == DOWN) camY -= 10;
  }

  for (int x=1; x<150-1; x++) {
    for (int y=1; y<150-1; y++) {
      // ラプラシアンフィルタを使った加速度計算
      float accel = high[x][y-1]+ high[x][y+1]+high[x-1][y]+high[x+1][y]-high[x][y]*4;  // ラプラシアンフィルタ
      accel = accel*0.5; 
      Vel[x][y]=(Vel[x][y]+accel)*0.9; // 減衰定数を0.9に設定
      // 一番外側の周の高さを0
      high[0][y]=0;
      high[149][y]=0;
      high[x][0]=0;
      high[x][149]=0;
    }
  }
  // 点の描画
  for (int x=0; x<150-1; x++) {
    for (int y=0; y<150-1; y++) {
      col[x][y]= int(800*high[x][y]);  
      if (col[x][y]<0)  col[x][y]=-col[x][y];  // colorが負の場合に正に変換
      col[x][y]=int(map(col[x][y], 0, 360, 0, 170));
      stroke(200, 20, 360-col[x][y]);
      if (d3%2==0) {  // 平面の場合
        camera(width/2, height/2, height/2 / tan(PI*60/ 360), width/2, height/2, 0, 0, 1, 0);
        point(n+n*x, n+n*y, 0);
      }
      if (d3%2==1) {  // 立体の場合
        camera(-300, camY, -200, 300, 300, 300, 0, -1, 0);
        point(n*x, 60+80*high[x][y], n*y);
      }
      high[x][y] += Vel[x][y];  // 波の高さに加速度を足して新しい波の高さとする
    }
  }
  t+=0.01;
}

// 水滴の落ちる位置の決定
void mousePressed() {
  int mx= mouseX/n; 
  int my= mouseY/n;
  high[mx][my]=3;
}

// 平面と立体の切り替え
void keyPressed() {
  if (keyCode==ENTER) d3++;
}
