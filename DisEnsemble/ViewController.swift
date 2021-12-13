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
    func processAudio()
}

class ViewController: UIViewController, ModalDelegate {
    
    //AudioModel used to capture microphone data, with a buffer size appropriate for lower sampling rate phones
    //buffer size set to 10 * the lower sampling rate phones
    var bufferSize = 480000
    let audio = AudioModel(buffer_size: 480000)
    //Local variables to store raw data and fft data for passing to model
    var fftData:[Float] = Array.init(repeating: 0.0, count: 480000/2)
    var timeData:[Float] = Array.init(repeating: 0.0, count: 480000)

    @IBOutlet weak var recordButton: UIButton!
    var recordFlag = false
    var runAudioFlag = true
    
    lazy var dataModel = {
        return DataModel.sharedInstance()
    }()
    
    lazy var instruments = dataModel.getAllInstruments()
    var results:[Any] = []
    
    //Pre-made models for instrument sound classification
    lazy var pianoModel:piano_classifier = {
        do{
            let config = MLModelConfiguration()
            return try piano_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var singingModel:singing_classifier = {
        do{
            let config = MLModelConfiguration()
            return try singing_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var aGuitarModel:acousticguitar_classifier = {
        do{
            let config = MLModelConfiguration()
            return try acousticguitar_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()
    
    lazy var eGuitarModel:electricguitar_classifier = {
        do{
            let config = MLModelConfiguration()
            return try electricguitar_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var violinModel:violin_classifier = {
        do{
            let config = MLModelConfiguration()
            return try violin_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var celloModel:cello_classifier = {
        do{
            let config = MLModelConfiguration()
            return try cello_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var saxModel:saxophone_classifier = {
        do{
            let config = MLModelConfiguration()
            return try saxophone_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var fluteModel:flute_classifier = {
        do{
            let config = MLModelConfiguration()
            return try flute_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var clarinetModel:clarinet_classifier = {
        do{
            let config = MLModelConfiguration()
            return try clarinet_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var trumpetModel:trumpet_classifier = {
        do{
            let config = MLModelConfiguration()
            return try trumpet_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()

    lazy var drumModel:drums_classifier = {
        do{
            let config = MLModelConfiguration()
            return try drums_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()
    
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
            runAudioFlag = true
            recordButton.setTitle("Stop Recording", for: .normal)
            //if not currently recording, record audio and set up auto-cutoff at 10 seconds
            audio.startMicrophoneProcessing(withFps: 20)
            audio.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10000), execute: {
                if self.runAudioFlag {
                    self.fftData = self.audio.fftData
                    self.timeData = self.audio.timeData
                    
                    self.audio.endAudioProcessing()
                    
                    self.recordFlag = false
                    self.recordButton.setTitle("Record Audio!", for: .normal)
                    self.modalView()
                    
                }
            })
            
            recordFlag.toggle()
        } else {
            runAudioFlag = false
            recordButton.setTitle("Record Audio!", for: .normal)
            self.fftData = self.audio.fftData
            self.timeData = self.audio.timeData
            
            self.audio.endAudioProcessing()
            recordFlag.toggle()
            
            modalView()
        }
    }
    
    func processAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            //TODO: test with imported models when they exist
            self.startDisensemble()
            
            let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            resultsController.pickerData = self.results
            self.present(resultsController, animated: true, completion: nil)
        })
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ResultsViewController {
            vc.pickerData = results
        }
    }
    
    func modalView() {
        let viewControllerModal = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController

        viewControllerModal.delegate = self
        viewControllerModal.timeData = self.timeData
        viewControllerModal.fftData = self.fftData

        self.present(viewControllerModal,animated: true, completion: nil)
    }
//    @IBAction func modalView(_ sender: AnyObject) {
//        let viewControllerModal = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
//
//        viewControllerModal.delegate = self
//        viewControllerModal.timeData = self.timeData
//        viewControllerModal.fftData = self.fftData
//
//        self.present(viewControllerModal,animated: true, completion: nil)
//    }
    
    func startDisensemble() {
        print("started")
        //clear out previous results before doing new prediction
        self.results.removeAll()
        
        var downsampled:[Float] = []
        for index in stride(from: 0, to: self.timeData.count, by: 3) {
            downsampled.append(self.timeData[index])
        }
        var chunks:[MLMultiArray] = []
        for end in stride(from: 15600, to: downsampled.count, by: 15600) {
            let start = end - 15600
            chunks.append(try! MLMultiArray(downsampled[start..<end]))
        }
        
        var predictions = [String: Int]()
        for instrument in instruments {
            predictions[instrument as! String] = 0
        }
        
        for chunk in chunks {
            guard let pianoOutput = try? self.pianoModel.prediction(deep_features: chunk) else {
                fatalError("Error calling predict.")
            }
            predictions["piano"]! += Int(pianoOutput.target)
            
            guard let singingOutput = try? self.singingModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["singing"]! += Int(singingOutput.target)

            guard let aGuitarOutput = try? self.aGuitarModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["guitar"]! += Int(aGuitarOutput.target)
            
            guard let eGuitarOutput = try? self.eGuitarModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["guitar"]! += Int(eGuitarOutput.target)

            guard let saxophoneOutput = try? self.saxModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["saxophone"]! += Int(saxophoneOutput.target)

            guard let fluteOutput = try? self.fluteModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["flute"]! += Int(fluteOutput.target)

            guard let clarinetOutput = try? self.clarinetModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["clarinet"]! += Int(clarinetOutput.target)

            guard let drumOutput = try? self.drumModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["drums"]! += Int(drumOutput.target)

            guard let violinOutput = try? self.violinModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["violin"]! += Int(violinOutput.target)

            guard let celloOutput = try? self.celloModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["cello"]! += Int(celloOutput.target)

            guard let trumpetOutput = try? self.trumpetModel.prediction(deep_features: chunk) else {
                fatalError("Unexpected runtime error.")
            }
            predictions["trumpet"]! += Int(trumpetOutput.target)
        }
        
        print(predictions)
        for instrument in instruments {
            if predictions[instrument as! String] ?? 0 > 0 {
                results.append(instrument)
            }
        }
    }
    
    
    // convert to ML Multi array
    // https://github.com/akimach/GestureAI-CoreML-iOS/blob/master/GestureAI/GestureViewController.swift
    // adapted from link above to work for our dataset
    // It should use floats instead of doubles, but floats aren't supported on the iOS versions developers had access to
    private func toMLMultiArray(_ arr: [Double]) -> MLMultiArray {
        let arraySize = bufferSize/2
        guard let sequence = try? MLMultiArray(shape:[NSNumber(value: arraySize)], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray could not be created")
        }
        let size = Int(truncating: sequence.shape[0])
        for i in 0..<size {
            sequence[i] = NSNumber(floatLiteral: arr[i])
        }
        return sequence
    }
}

