#include "ofApp.h"

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
    accelSamples = 10;
    //accelValues.assign(accelSamples, 0.0f);
    
    // Load in the audio
    testSound.load("Chris_01.mp3");
    testSound.setVolume(1.0f);
    testSound.play();
}

//--------------------------------------------------------------
void ofApp::update(){
    if (checkAcceleration()){
        
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofClear(0);
    mainFont.drawString(aText, 50, 500);
}

// Read the acceleration and check if it's above a threshold
bool ofApp::checkAcceleration(){
    // Update IMU readings
    coreMotion.update();
    ofVec3f accel = coreMotion.getAccelerometerData();
    
    // Update samples and average
//    for (int i = 1; i < accelValues.size(); i++){
//        accelValues[i - 1] = accelValues[i];
//    }
//    accelValues[accelValues.size() - 1] = accel.length();
    //float average = std::accumulate(accelValues.begin(), accelValues.end(), 0) / accelValues.size();
    
    
    //aText = "Acceleration: " + ofToString(average);
    return false;
}

// Play the specified audio file
void ofApp::playSound(string filename){
    testSound.stop();
    testSound.play();
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
