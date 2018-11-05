#include "ofApp.h"

// Stores the system time, in seconds, when the program began execution
double startTime;

//--------------------------------------------------------------
void ofApp::setup(){
    // Setup framerate and background
    ofSetFrameRate(60);
    ofBackground(255, 255, 0);
    
    //old OF default is 96 - but this results in fonts looking larger than in other programs.
    ofTrueTypeFont::setGlobalDpi(72);
    
    // font setup
    mainFont.load("verdana.ttf", 60);
    mainFont.setLineHeight(64.0f);
    mainFont.setLetterSpacing(1.037);
    
    // Setup accelerometer
    coreMotion.setupAccelerometer();
    coreMotion.setupAttitude(CMAttitudeReferenceFrameXMagneticNorthZVertical);
    accelSamples = 50;
    accelThreshold = 0.1;
    accelValues.assign(accelSamples, 0.0f);
    
    // Load in the audio
    testSound.load("Chris_01.mp3");
    testSound.setVolume(1.0f);
    //testSound.play();
    
    // Initialize location tracking
    //ofxGPS::startLocation();
    ofLog(OF_LOG_NOTICE, "setup");
    
    // Get the initialization time
    startTime = ofGetCurrentTime().getAsSeconds();
}

// Whether or not the audio is currently being interpolated (either up or down)
bool lerping = false;

//--------------------------------------------------------------
void ofApp::update(){
    checkAcceleration();
    if (lerping) handleAudioLerp();
    else if (checkAcceleration()){
        if (!testSound.isPlaying()) startPlayingSound("");
    }
    else if (testSound.isPlaying()) stopPlayingSound("");
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofClear(0);
    // Draw the text with accelerometer data
    mainFont.drawString(aText, 50, 500);
    // Print elapsed time
    //mainFont.drawString(ofToString(ofGetCurrentTime().getAsSeconds() - startTime), 50, 650);
}

// Read the acceleration and check if it's above a threshold
bool ofApp::checkAcceleration(){
    // Update IMU readings
    coreMotion.update();
    ofVec3f accel = coreMotion.getUserAcceleration();
    
    //Update samples and average
    for (int i = 1; i < accelValues.size(); i++){
        accelValues[i - 1] = accelValues[i];
    }
    accelValues[accelValues.size() - 1] = accel.length();
    // Find the average sampled acceleration rate
    float average = 0;
    for (int i = 0; i < accelValues.size(); i++){
        average += accelValues[i];
    }
    average /= accelValues.size();
    
    aText = "Acceleration: " + ofToString(average);
    return average > accelThreshold;
}



// The number of milliseconds a clip takes to start up or stop
static float audioLerpTime = 1;
// Start and stop volume values for audio lerp
static float audioLerpMin = 0;
static float audioLerpMax = 1.0;
// Values describing the current state of audio interpolation
bool lerpingUp = false;
float lerpStartTime;

// Play the specified audio file
void ofApp::startPlayingSound(string filename){
    // Setup the audio ramp-up, start playing
    // Note: on iPhone, audio seems to play through wired headphones, but not Bluetooth
    testSound.setVolume(audioLerpMin);
    lerping = true;
    lerpingUp = true;
    lerpStartTime = ofGetElapsedTimef();
    testSound.play();
}

// Stop playing the current sound file
void ofApp::stopPlayingSound(string filename){
    // Setup the audio ramp-down
    testSound.setVolume(audioLerpMax);
    lerping = true;
    lerpingUp = false;
    lerpStartTime = ofGetElapsedTimef();
}

// Handle the starting and stopping ramping up and down of volume
void ofApp::handleAudioLerp(){
    if (!lerping) return;
    // Case starting audio play
    if (lerpingUp){
        // Check if interpolation is finished
        if (ofGetElapsedTimef() - lerpStartTime > audioLerpTime){
            testSound.setVolume(audioLerpMax);
            lerping = false;
        }
        // Otherwise set current value
        else testSound.setVolume(ofLerp(audioLerpMin, audioLerpMax,
                                        (ofGetElapsedTimef() - lerpStartTime) / audioLerpTime));
    }
    // Case stopping audio play
    else{
        // Check if interpolation is finished
        if (ofGetElapsedTimef() - lerpStartTime > audioLerpTime){
            testSound.setVolume(0);
            lerping = false;
            testSound.stop();
        }
        // Otherwise set current value
        else testSound.setVolume(ofLerp(audioLerpMax, audioLerpMin,
                                        (ofGetElapsedTimef() - lerpStartTime) / audioLerpTime));
    }
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

