import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Walker w;
PImage back;


Minim minim;
AudioOutput out;
Delay myDelay;

// the Oscil we use for modulating frequency.
Oscil fm;

void setup() {
  size(640, 360);
  w = new Walker();
  background(0);


  back = loadImage("673nmos3.png");
  surface.setResizable(true);
  
  surface.setSize(640, back.height*640/back.width);
  
  
  // initialize the minim and out objects
  minim = new Minim( this );
  out   = minim.getLineOut();
  myDelay = new Delay( 0.4, 0.6, true, true );

  // make the Oscil we will hear.
  // arguments are frequency, amplitude, and waveform
  Oscil wave = new Oscil( 500, 0.8, Waves.TRIANGLE );
  // make the Oscil we will use to modulate the frequency of wave.
  // the frequency of this Oscil will determine how quickly the
  // frequency of wave changes and the amplitude determines how much.
  // since we are using the output of fm directly to set the frequency 
  // of wave, you can think of the amplitude as being expressed in Hz.
  fm   = new Oscil( 10, 2, Waves.SINE );
  // set the offset of fm so that it generates values centered around 200 Hz
  fm.offset.setLastValue( 200 );
  // patch it to the frequency of wave so it controls it
  fm.patch( wave.frequency );
  // and patch wave to the output
  wave.patch( myDelay ).patch( out );

  

}

void draw() {
  //background(0);
  image(back, 0, 0, width, back.height * width/back.width);

  // Run the walker object
  w.step();
  w.render();
  println(w.x, w.y);
  
  //color c = back.get((int)w.x*back.width/width, (int)w.y*back.width/width);
  color c = get(mouseX, mouseY);


  pushStyle();
    fill(c);
    noStroke();
    rect(0,0,100,100);
  popStyle();
  
  
  float modulateAmount = map( brightness(c),255, 0, 1000, 1 );
  float modulateFrequency = map( brightness(c), 0, 255, 0.1, 100 );
  
  //fm.setFrequency( modulateFrequency );
  fm.setAmplitude( modulateAmount );
}