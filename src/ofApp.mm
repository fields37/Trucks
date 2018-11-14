#include "ofApp.h"

// Stores the system time, in seconds, when the program began execution
double startTime;

// The ofSoundPlayer playing the different sound files
ofSoundPlayer soundPlayer;

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
    findAudioClips();
    loadNextClip();
    soundPlayer.setVolume(1.0f);
    soundPlayer.setLoop(false);
    //soundPlayer.play();
    
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
    if (soundPlayer.getPosition() >= 0.99){
        ofSleepMillis(10000);
        ofLog(OF_LOG_NOTICE, "next");
        loadNextClip();
    }
    
    // Find the current acceleration, handle ramp-ups and downs, start or stop audio if necessary
    checkAcceleration();
    if (lerping) handleAudioLerp();
    else if (checkAcceleration()){
        if (!soundPlayer.isPlaying()) startPlayingSound("");
    }
    else if (soundPlayer.isPlaying()) stopPlayingSound("");
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
    // Make the soundPlayer go back by 2 * audioLerpTime seconds
    soundPlayer.setPositionMS(MAX(0, soundPlayer.getPosition() - (2000 * audioLerpTime)));
    
    // Setup the audio ramp-up, start playing
    // Note: on iPhone, audio seems to play through wired headphones, but not Bluetooth
    soundPlayer.setVolume(audioLerpMin);
    lerping = true;
    lerpingUp = true;
    lerpStartTime = ofGetElapsedTimef();
    soundPlayer.play();
}

// Stop playing the current sound file
void ofApp::stopPlayingSound(string filename){
    // Setup the audio ramp-down
    soundPlayer.setVolume(audioLerpMax);
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
            soundPlayer.setVolume(audioLerpMax);
            lerping = false;
        }
        // Otherwise set current value
        else soundPlayer.setVolume(ofLerp(audioLerpMin, audioLerpMax,
                                        (ofGetElapsedTimef() - lerpStartTime) / audioLerpTime));
    }
    // Case stopping audio play
    else{
        // Check if interpolation is finished
        if (ofGetElapsedTimef() - lerpStartTime > audioLerpTime){
            soundPlayer.setVolume(0);
            lerping = false;
            soundPlayer.stop();
        }
        // Otherwise set current value
        else soundPlayer.setVolume(ofLerp(audioLerpMax, audioLerpMin,
                                        (ofGetElapsedTimef() - lerpStartTime) / audioLerpTime));
    }
}

// Whether or not to shuffle the audio clips
bool shuffleClips = false;
// Directory holding the audio clips,
static string audioPath = "Clips/";
static string statePath = "userstate.txt";
ofDirectory directory;
// Index of next clip to be loaded
int clipIndex = 0;
vector<ofFile> audioFiles;

// Read in the name of all the audio clips in the selected directory
void ofApp::findAudioClips(){
    // Restrict the relevant files to .mp3's, sort alphabetically
    directory.allowExt("mp3");
    directory.listDir(audioPath);
    directory.sort();
    // Populate the list of files
    audioFiles = directory.getFiles();
    if (shuffleClips){
        ofLog(OF_LOG_NOTICE, "randomizing");
        ofRandomize(audioFiles);
    }
    //ofLog(OF_LOG_NOTICE, ofToString(audioFiles.size()));
}

// Load the currently indexed clip into the ofSoundPlayer
// Advance the audio clip index
void ofApp::loadNextClip(){
    soundPlayer.load(audioFiles[clipIndex].getAbsolutePath());
    clipIndex = (clipIndex + 1) % audioFiles.size();
    ofLog(OF_LOG_NOTICE, ofToString(clipIndex));
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

