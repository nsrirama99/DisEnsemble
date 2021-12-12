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
    
    @IBOutlet weak var popUpText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancelAudio(_ sender: Any) {
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
    }
    
    @IBAction func sendData(_ sender: Any) {
        popUpText.resignFirstResponder()
        let data = true
        
        if(data == true){
            popUpText.text = "Data Recieved and Processed. Swipe down to return to menu."
        }
        
        if let delegate = delegate {
            delegate.processAudio()
            //delegate.startDisensemble()
        }
        dismiss(animated: true, completion: nil)
    }
    

}
