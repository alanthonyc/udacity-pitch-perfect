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
    
    @IBOutlet weak var recordingProgressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    // MARK: Audio Recording Properties
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var audioFilePathUrl:NSURL!
    let defaultAudioFilename = "my_audio.wav"
    let playSoundsVCIdentifier = "stopRecording"

    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = defaultAudioFilename
        let pathArray = [dirPath, recordingName]
        audioFilePathUrl = NSURL.fileURLWithPathComponents(pathArray)!
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
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: audioFilePathUrl, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier(playSoundsVCIdentifier, sender:recordedAudio)
            
        } else {
            println("Error while recording.")
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
        self.recordingProgressLabel.text = "recording"
        self.stopButton.hidden = false
        self.recordingButton.enabled = false
        self.pauseButton.hidden = false
    }
    
    func setUIStateReady()
    {
        self.recordingProgressLabel.text = "Tap to Record"
        self.stopButton.hidden = true
        self.recordingButton.enabled = true
        self.pauseButton.hidden = true
        let image = UIImage(named: "pauseButton") as UIImage?
        self.pauseButton.setImage(image, forState: .Normal)
    }
    
    // MARK: - Pause Recording
    @IBAction func pauseRecording(sender:UIButton)
    {
        if (audioRecorder != nil) {
            if (audioRecorder.recording) {
                audioRecorder.pause()
                self.recordingProgressLabel.text = "paused"
                let image = UIImage(named: "recordButton") as UIImage?
                self.pauseButton.setImage(image, forState: .Normal)
                
            } else {
                audioRecorder.record()
                self.recordingProgressLabel.text = "recording"
                let image = UIImage(named: "pauseButton") as UIImage?
                self.pauseButton.setImage(image, forState: .Normal)
            }
        }
    }
}

