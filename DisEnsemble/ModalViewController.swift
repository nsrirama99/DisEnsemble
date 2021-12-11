//
//  ModalViewController.swift
//  DisEnsemble
//
//  Created by UbiComp on 12/8/21.
//

import UIKit



class ModalViewController: UIViewController {

    @IBOutlet weak var popUpText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendData(_ sender: Any) {
        var data = true
        
        if(data == true){
            popUpText.text = "Data Recieved and Processed. Swipe down to return to menu."
        }
    }
    

}
