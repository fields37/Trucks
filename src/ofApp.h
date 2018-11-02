#pragma once

#include "ofxiOS.h"
#include "ofxCoreMotion.h"
#include "ofxGPSImpliOS.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        bool checkAcceleration();
        void startPlayingSound(string filename);
        void stopPlayingSound(string filename);
    
        ofxCoreMotion coreMotion;
        ofTrueTypeFont mainFont;
        string aText;
    
        ofSoundPlayer testSound;
        vector<float> accelValues;
        int accelSamples;
        float accelThreshold;
};


