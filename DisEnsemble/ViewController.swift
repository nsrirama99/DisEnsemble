//
//  ViewController.swift
//  DisEnsemble
//
//  Created by UbiComp on 12/8/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func modalView(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let viewControllerModal = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
            
            self.present(viewControllerModal,animated: true, completion: nil)
        }
        
        
    }
}

