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
//    lazy var pianoModel:PianoModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try PianoModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
    lazy var singingModel:singing_classifier = {
        do{
            let config = MLModelConfiguration()
            return try singing_classifier(configuration: config)
        }catch{
            print(error)
            fatalError("Could not load custom model")
        }
    }()
//
//    lazy var guitarModel:GuitarModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try GuitarModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var violinModel:ViolinModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try ViolinModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var celloModel:CelloModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try CelloModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var saxModel:SaxophoneModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try SaxophoneModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var fluteModel:FluteModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try FluteModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var clarinetModel:ClarinetModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try ClarinetModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var trumpetModel:TrumpetModel = {
//        do{
//            let config = MLModelConfiguration()
//            return try TrumpetModel(configuration: config)
//        }catch{
//            print(error)
//            fatalError("Could not load custom model")
//        }
//    }()
//
//    lazy var drumModel:DrumsModel = {
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
        
        let doubleArray:[Double] = self.timeData.map{Double($0)}
        let seq = self.toMLMultiArray(doubleArray)
        var iter = 0
        //TODO: uncomment once models have been imported
//        guard let outputTuri = try? self.pianoModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
        guard let outputTuri = try? self.singingModel.prediction(audio: seq) else {
            fatalError("Unexpected runtime error.")
        }
        if outputTuri.path == 1 {
            self.results.append(instruments[iter])
        }
        iter+=1
//
//        guard let outputTuri = try? self.guitarModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.saxModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.fluteModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.clarinetModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.drumModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.violinModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.celloModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1
//
//        guard let outputTuri = try? self.trumpetModel.prediction(sequence: seq) else {
//            fatalError("Unexpected runtime error.")
//        }
//        if outputTuri.target == 1 {
//            self.results.append(instruments[iter])
//        }
//        iter+=1


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

