import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer audio;
FFT         fft;

int BUFFER_SIZE = 512;

void setup() {
  size(500, 500);

  minim = new Minim(this);
  audio = minim.loadFile("test-audio.mp3", BUFFER_SIZE);
  audio.loop();
  fft = new FFT( audio.bufferSize(), audio.sampleRate() );
}

void draw() {
  fft.forward( audio.mix );

  background(0);
  fill(255);
  stroke(255);

  for (int i = 0; i < fft.specSize(); i++) {
    point(i, 500 - fft.getBand(i));
  }


}