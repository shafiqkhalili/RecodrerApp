//
//  ViewController.swift
//  RecodrerApp
//
//  Created by Shafigh Khalili on 2020-08-07.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var buttonStartRecording: UIButton!
    @IBOutlet weak var buttonStopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func startRecording(_ sender: UIButton) {
        
        labelRecord.text = "Recording in progress!"
        buttonStopRecording.isEnabled = true
        buttonStartRecording.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission(){ [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                    
                    try! self.audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                    self.audioRecorder.delegate = self
                    self.audioRecorder.isMeteringEnabled = true
                    self.audioRecorder.prepareToRecord()
                    self.audioRecorder.record()
                } else {
                    print("Not permitted to record!")
                }
            }
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        labelRecord.text = "Tap to record!"
        buttonStopRecording.isEnabled = false
        buttonStartRecording.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func configureUI(stopBtnEnabled:Bool? = nil,startBtnEnabled:Bool? = nil) {
        
        if let stopBtnEnabled = stopBtnEnabled{
            buttonStopRecording.isEnabled = stopBtnEnabled
        }
        if let startBtnEnabled = startBtnEnabled{
             buttonStartRecording.isEnabled = startBtnEnabled
        }
       
       
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Finished recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recorderAudioLink = sender as! URL
            playSoundVC.recordedAudioURL = recorderAudioLink
        }
    }
    
}

