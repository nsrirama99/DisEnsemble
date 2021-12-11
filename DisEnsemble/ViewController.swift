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
    func startDisensemble()
}

class ViewController: UIViewController, ModalDelegate {
    
    //AudioModel used to capture microphone data, with a buffer size appropriate for lower sampling rate phones
    //buffer size set to 10 * the lower sampling rate phones
    var bufferSize = 441000
    
    let audio = AudioModel(buffer_size: 441000)
    
    //Local variables to store raw data and fft data for passing to model
    var fftData:[Float] = Array.init(repeating: 0.0, count: 441000/2)
    var timeData:[Float] = Array.init(repeating: 0.0, count: 441000)

    @IBOutlet weak var recordButton: UIButton!
    var recordFlag = false
    
    lazy var dataModel = {
        return DataModel.sharedInstance()
    }()
    
    lazy var instruments = dataModel.getAllInstruments()
    
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
        recordFlag = false
        recordButton.setTitle("Record Audio!", for: .normal)
        
        print(instruments)
        if instruments.count == 0 {
            self.dataModel.loadNames()
            instruments = self.dataModel.getAllInstruments()
        }
        print(instruments)
        
    }


    @IBAction func recordAudio(_ sender: Any) {
        recordButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.recordButton.isEnabled = true
        })
        
        if(!recordFlag) {
            recordButton.setTitle("Stop Recording", for: .normal)
            //if not currently recording, record audio and set up auto-cutoff at 10 seconds
            audio.startMicrophoneProcessing(withFps: 10)
            audio.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10000), execute: {
                self.fftData = self.audio.fftData
                self.timeData = self.audio.timeData
                
                self.audio.endAudioProcessing()
                
                //process audio with models here
                self.processAudio()
            })
            
            recordFlag.toggle()
        } else {
            recordButton.setTitle("Record Audio!", for: .normal)
            self.fftData = self.audio.fftData
            self.timeData = self.audio.timeData
            
            self.audio.endAudioProcessing()
            recordFlag.toggle()
            
            //process audio with models here
            self.processAudio()
        }
    }
    
    func processAudio() {
        //TODO: run through models
        
        let resultsController = storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        resultsController.pickerData = instruments
        self.present(resultsController, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ResultsViewController {
            vc.pickerData = instruments
        }
    }
    
    @IBAction func modalView(_ sender: AnyObject) {
        let viewControllerModal = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        
        viewControllerModal.delegate = self
        viewControllerModal.timeData = self.timeData
        viewControllerModal.fftData = self.fftData
        
        self.present(viewControllerModal,animated: true, completion: nil)
    }
    
    func startDisensemble() {
        print("started")
    }
}

