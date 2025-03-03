#include <Servo.h>
#define Umax 60 // maximum angle of the servo motor in degrees
#define Umin -60 // minimum angle
#define Umax_rad 1.0472 // maximum angle of the servo motor in radiants
#define Umin_rad -1.0472 // minimum angle
#define T 0.09 // sampling time
const int echoPin2= 4;
const int trigPin2= 3;
Servo servo;
double setpoint;
double y, y_prev;
double error;
double P, I, D, U;
double I_prev=0, U_prev=0, D_prev=0;
boolean Saturation = false;
double Kp = 3.9;
double Ki = 0.1;
double Kd = 2.3;
double error_prev = 0.0;
float measure (void);
void move_servo(int);
void setup() {
Serial.begin(9600);
pinMode(trigPin2, OUTPUT);
pinMode(echoPin2, INPUT);
servo.attach(9);
delay(1000);
move_servo(90);
delay(2000);
setpoint = .35;
delay(1000);
y_prev = measure(); // ball
delay(1000);
}
void loop() {
delay(3);
y = measure(); // distance of the ball from the sensor ( meters )
y = 0.53*y + 0.47*y_prev ; // ( filtering to reduce noise )
delay (3);
error = round( 100*(y - setpoint) )*0.01;
P = Kp*error;
if ( ! Saturation ) I = I_prev + T*Ki*error;
D = (Kd/T)*(error - error_prev);
D = 0.56*D + 0.44*D_prev; // filtering D
U = P + I + round(100*D)*0.01 ; // U in radiants
if ( U < Umin_rad) {
U=Umin_rad;
Saturation = true;
}
else if ( U > Umax_rad) {
U=Umax_rad;
Saturation = true;
}
else Saturation = false;
U=round(U*180/M_PI); // Transform U in degrees
U=map(U, Umin, Umax, 24, 156);
if (U < 83 || U > 97 || abs(error) > 0.01 ) move_servo( round(U) ); // error threshold
delay (24);
//Serial.print(setpoint*100);
//Serial.print(" ");
Serial.print(y*100);
Serial.print(" ");
Serial.print(U);
Serial.println();
I_prev = I;
y_prev = y;
D_prev = D;
setpoint = setpoint;
error_prev = error;
} float measure (
void) {
long duration=0;
float distance=0;
digitalWrite(trigPin2, LOW);
delayMicroseconds(10);
digitalWrite(trigPin2, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin2, LOW);
duration = pulseIn(echoPin2, HIGH);
distance = (float)duration/58.2;
//Serial.println(distance);
delay(30);
if (distance > 50) distance=50;
else if (distance < 0) distance=0;
return 0.01*(distance);
}
void move_servo(int u) {
servo.write(u);
}
