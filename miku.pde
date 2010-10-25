#include <Servo.h>
#include <Tone.h>
#define N_CS3 277
#define N_FS3 370
#define N_GS3 415
#define N_A4 440
#define N_E3 330
#define N_CS4 544
#define N_B4 494

Tone notePlayer;
Servo myServo;
int tempo, num, tempo_count, count, time, sp;
int note[] = {N_CS3, N_FS3, N_FS3, N_FS3, N_GS3, N_A4, N_A4, N_FS3, N_FS3, N_FS3, N_FS3, N_A4, N_GS3, N_E3, N_E3, N_GS3, N_A4, N_FS3, N_FS3, N_FS3, N_FS3, N_CS3, N_FS3, N_FS3, N_FS3, N_GS3, N_A4, N_FS3, N_FS3, 0, N_FS3, N_FS3, N_A4, N_CS4, N_CS4, N_CS4, N_B4, N_A4, N_A4, N_GS3, N_A4, N_FS3, N_FS3, N_FS3, N_FS3, N_CS4, N_CS4, N_B4, N_A4, N_GS3, N_E3, N_E3, N_E3, N_E3, N_GS3, N_B4, N_B4, N_B4, N_B4, N_A4, N_A4, N_GS3, N_GS3, N_A4, N_FS3, N_FS3, N_FS3, 0, N_CS4, N_CS4, N_B4, N_A4, N_GS3, N_E3, N_E3, N_E3, N_E3, N_GS3, N_B4, N_B4, N_B4, N_B4, N_A4, N_GS3, N_A4, N_FS3, N_FS3, 100000};
int thre[] = {2, 2, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4};

void setup() {
  notePlayer.begin(13);
  myServo.attach(10);
  Serial.begin(9600);
  myServo.write(10);
  time = 10;
  sp = 2;
  tempo = 8;
  tempo_count = 0;
  num = 88;
  count = 0;
  notePlayer.play(note[count]);
}

void catch_serial() {
   int serial, i, buf, count;
   serial = Serial.available();
   if(serial > 0) {
      buf = Serial.read();
      buf -= 46;
      if(time == buf) {
         return;
      } else if(time > buf * 3) {
         time = buf * 3;
         for(i = time; i > buf * 3; i -= 3) {
            if(sp > 0) {
               sp--;
            }
         }
      } else if(time < buf * 3) {
          time = buf * 3;
          for(i = time; i < buf * 3; i += 3) {
             sp++;
          }
      }
      Serial.println(time);
   }
}

void loop() {
   int i;
   for(i = 140; i > 65; i -= sp) {
      myServo.write(i);
      catch_serial();
      tempo_count++;
      if(tempo_count >= tempo * thre[count]) {
        tempo_count = 0;
        count++;
        notePlayer.stop();
        if(count == num) {
          count = 0;
        }
        delay(8);
        notePlayer.play(note[count]);
      }
      delay(time);
   }
   for(i = 65; i < 140; i += sp) {
      myServo.write(i);
      catch_serial();
      tempo_count++;
      if(tempo_count >= tempo * thre[count]) {
        tempo_count = 0;
        count++;
        notePlayer.stop();
        if(count == num) {
          count = 0;
        }
        delay(8);
        notePlayer.play(note[count]);
      }
      delay(time);
   }
}
