//
//  ViewController.swift
//  DisEnsemble
//
//  Created by UbiComp on 12/8/21.
//

import UIKit
import CoreML

protocol ModalDelegate {
    //function to display audio playback and start disensembling
}

class ViewController: UIViewController {
    
    //AudioModel used to capture microphone data, with a buffer size appropriate for lower sampling rate phones
    //buffer size set to 10 * the lower sampling rate phones
    let audio = AudioModel(buffer_size: 441000)
    
    //Local variables to store raw data and fft data for passing to model
    var fftData:[Float] = Array.init(repeating: 0.0, count: 44100/2)
    var timeData:[Float] = Array.init(repeating: 0.0, count: 44100)

    //Pre-made models for instrument sound classification
//    lazy var turiModel:PianoModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try PianoModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:SingingModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try SingingModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:GuitarModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try GuitarModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:ViolinModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try ViolinModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:CelloModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try CelloModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:SaxophoneModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try SaxophoneModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:FluteModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try FluteModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:ClarinetModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try ClarinetModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:TrumpetModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try TrumpetModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var turiModel:DrumsModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try DrumsModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
    
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

