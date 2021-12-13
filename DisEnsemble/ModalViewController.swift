//
//  ModalViewController.swift
//  DisEnsemble
//
//  Created by UbiComp on 12/8/21.
//

import UIKit



class ModalViewController: UIViewController {

    var delegate:ModalDelegate?
    
    //Local variables to store raw data and fft data for passing to model
    var fftData:[Float] = []
    var timeData:[Float] = []
    
    var bufferSize = 441000
    let audio = AudioModel(buffer_size: 441000)
    
    var playAudioFlag:Bool = true
    
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var popUp: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAudioFlag = true
        // Do any additional setup after loading the view.
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancelAudio(_ sender: Any) {
        audio.endAudioProcessing()
        audio.endPlayback()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replayAudio(_ sender: Any) {
        //idk how to do this
        
        //TODO: The below print statements were used to look at how the buffers act with different recording lengths
        //the timeData array is filled from right to left, ie the later indices are filled first. We'll have to strip some of the 0's from the beginning of the array (if they exist) so playback isn't always 10seconds
        //fftData always have exactly 9 values which are -inf at the end of the array for some reason
        
        //print(timeData[0..<110])
        //print(timeData[timeData.count-100..<timeData.count])
        //print(fftData[fftData.count-100..<fftData.count])
        
        //audio.startProcessingSinewaveForPlayback()

        playAudioFlag.toggle()
        
        if !playAudioFlag {
            DispatchQueue.main.async {
                self.popUp.text = "Playing back audio..."
                self.replayButton.setTitle("Stop Playback", for: .normal)
            }
            self.audio.playBuffer(arr: timeData)
        } else {
            DispatchQueue.main.async {
                self.popUp.text = ""
                self.replayButton.setTitle("Replay Captured Audio", for: .normal)
            }
            self.audio.endPlayback()
        }

//        audio.startProcessingAudioForPlayback(audio: self.timeData)
//        audio.play()
        

        
        
    }
    
    @IBAction func sendData(_ sender: Any) {
        popUp.resignFirstResponder()
        let data = true
        
        if(data == true){
            popUp.text = "Data Recieved and Processed. Swipe down to return to menu."
        }
        
        if let delegate = delegate {
            delegate.processAudio()
            //delegate.startDisensemble()
        }
        audio.endAudioProcessing()
        dismiss(animated: true, completion: nil)
    }

}
