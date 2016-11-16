/* realtimeControlExample<br/>
   is an example of doing realtime control with an instrument
   <p>
   For more information about Minim and additional features, visit http://code.compartmental.net/minim/
   <p>   
   author: Anderson Mills<br/>
   Anderson Mills's work was supported by numediart (www.numediart.org)
*/

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;
// this time we also need effects because the filters are there for this release
import ddf.minim.effects.*;


Walker w;
PImage back;


Minim minim;
AudioOutput out;
NoiseInstrument myNoise;

void setup() {
  size(640, 360);
  w = new Walker();
  background(0);


  back = loadImage("673nmos3.png");
  surface.setResizable(true);
  
  surface.setSize(640, back.height*640/back.width);
  
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 512 );
  // need to initialize the myNoise object   
  myNoise = new NoiseInstrument( 1.0, out );

  // play the note for 100.0 seconds
  out.playNote( 0, 100.0, myNoise );
  
  
  frameRate(24);
}

void draw() {
  //background(0);
  image(back, 0, 0, width, back.height * width/back.width);

  // Run the walker object
  w.step();
  w.render();
  println(w.x, w.y);
  
  color c = back.get((int)w.x*back.width/width, (int)w.y*back.width/width);
  //color c = get(mouseX, mouseY);


  pushStyle();
    fill(c);
    noStroke();
    rect(0,0,100,100);
  popStyle();
  
  

   // map the position of the mouse to useful values
  float freq = map( brightness(c), 0, 255, 4400, 15 );
  float q = map( hue(c), 0, 255, 80, 100 );
  // and call the methods of the instrument to change the sound
  myNoise.setFilterCF( freq );
  myNoise.setFilterQ( q );
}


// Every instrument must implement the Instrument interface so 
// playNote() can call the instrument's methods.

// This noise instrument uses white noise and two bandpass filters
// to make a "whistling wind" sound.  By changing using the methods which
// change the frequency and the bandwidth of the filters, the sound changes.

class NoiseInstrument implements Instrument
{
  // create all variables that must be used throughout the class
  Noise myNoise;
  Multiplier multiply;
  AudioOutput out;
  BandPass filt1, filt2;
  Summer sum; 
  float freq1, freq2, freq3;
  float bandWidth1, bandWidth2;
  float filterFactor;
  
  // constructors for this intsrument
  NoiseInstrument( float amplitude, AudioOutput output )
  {
    // equate class variables to constructor variables as necessary 
    out = output;
    
    // give some initial values to the realtime control variables
    freq1 = 150.0;
    bandWidth1 = 10.0;
    filterFactor = 1.7;
    
    // create new instances of any UGen objects
    myNoise = new Noise( amplitude, Noise.Tint.WHITE );
    multiply = new Multiplier( 0 );
    filt1 = new BandPass( freq1, bandWidth1, out.sampleRate() );
    filt2 = new BandPass( freq2(), bandWidth2(), out.sampleRate() );
    sum = new Summer();

    // patch everything (including the out this time)
    myNoise.patch( filt1 ).patch( sum );
    myNoise.patch( filt2 ).patch( sum );
    sum.patch( multiply );
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // set the multiply to 1 to turn on the note
    multiply.setValue( 1 );
    multiply.patch( out );
  }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // set the multiply to 0 to turn off the note 
    multiply.setValue( 0 );
    multiply.unpatch( out );
  }
  
  // this is a helper method only used internally to find the second filter
  float freq2()
  {
    // calculate the second frequency based on the first
    return filterFactor*freq1;
  }
  
  // this is a helper method only used internally 
  // to find the bandwidth of the second filter
  float bandWidth2()
  {
    // calculate the second bandwidth based on the first
    return filterFactor*bandWidth1;
  }
  
  // this is a method to set the center frequencies
  // of the two filters based on the CF of the first
  void setFilterCF( float cf )
  {
    freq1 = cf;
    filt1.setFreq( freq1 );
    filt2.setFreq( freq2() );
  }
  
  // this is a method to set the bandwidths
  // of the two filters based on the BW of the first
  void setFilterBW( float bw )
  {
    bandWidth1 = bw;
    filt1.setBandWidth( bandWidth1 );
    filt2.setBandWidth( bandWidth2() );
  }
 
  // this is a method to set the Q (inverse of bandwidth)
  // of the two filters based on the  
  void setFilterQ( float q )
  {
    setFilterBW( freq1/q );
  }
}