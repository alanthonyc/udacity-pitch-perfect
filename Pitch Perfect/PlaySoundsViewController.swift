//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by A. Anthony Castillo on 6/26/15.
//  Copyright (c) 2015 Alon Consulting, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // MARK: - Class Properties
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    let pitchValueChipmunk:Float = 1000
    let pitchValueDarth:Float = -1000
    
    var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL:receivedAudio.filePathUrl, error:nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UI Actions
    
    @IBAction func stopPlayback(sender: UIButton)
    {
        stopAllAudio()
    }
    
    @IBAction func playRecordingSlowly(sender: UIButton)
    {
        stopAllAudio()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func playRecordingQuickly(sender: UIButton)
    {
        stopAllAudio()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func playReverbEffect(sender: UIButton)
    {
        stopAllAudio()
        playAudioWithReverb()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton)
    {
        stopAllAudio()
        playAudioWithVariablePitch(pitchValueChipmunk)
    }
    
    @IBAction func playDarthAudio(sender: UIButton)
    {
        stopAllAudio()
        playAudioWithVariablePitch(pitchValueDarth)
    }
    
    // MARK: - Audio Control
    
    func stopAllAudio()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.reset()
    }
    
    // MARK: - Special Effects Processing
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioWithEffect(changePitchEffect)
    }
    
    func playAudioWithReverb()
    {
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue:9)!)
        changeReverbEffect.wetDryMix = 100
        playAudioWithEffect(changeReverbEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioUnit)
    {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
