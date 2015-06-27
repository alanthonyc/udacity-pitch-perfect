//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by A. Anthony Castillo on 5/28/15.
//  Copyright (c) 2015 Alon Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{
    // MARK: -
    // MARK: --- Class Properties
    
    // MARK: UI Properties
    
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    // MARK: Audio Recording Properties
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let defaultAudioFilename = "my_audio.wav"
    let playSoundsVCIdentifier = "stopRecording"

    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool)
    {
        setUIStateReady()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - PlaySoundsViewController Interface
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == playSoundsVCIdentifier) {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // MARK: - Audio Processing
    
    @IBAction func recordAudio(sender: UIButton)
    {
        setUIStateRecording()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = defaultAudioFilename
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier(playSoundsVCIdentifier, sender:recordedAudio) //recordedAudio initiates segue
            
        } else {
            println("error while recording")
            setUIStateReady()
        }
    }
    
    @IBAction func stopRecording(sender: UIButton)
    {
        setUIStateReady()
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    // MARK: - UI State Management
    
    func setUIStateRecording()
    {
        self.recordingInProgressLabel.alpha = 1.0;
        self.stopButton.hidden = false
        self.recordingButton.enabled = false
    }
    
    func setUIStateReady()
    {
        self.recordingInProgressLabel.alpha = 0.0
        self.stopButton.hidden = true
        self.recordingButton.enabled = true
    }
}

