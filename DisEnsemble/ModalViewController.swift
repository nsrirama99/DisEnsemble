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
    
    @IBAction func replayAudio(_ sender: Any) {
        //idk how to do this
    }
    
    @IBAction func sendData(_ sender: Any) {
        popUpText.resignFirstResponder()
        let data = true
        
        if(data == true){
            popUpText.text = "Data Recieved and Processed. Swipe down to return to menu."
        }
        
        if let delegate = delegate {
            delegate.startDisensemble()
        }
        dismiss(animated: true, completion: nil)
    }
    

}
