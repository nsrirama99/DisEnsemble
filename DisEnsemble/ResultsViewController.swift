//
//  ResultsViewController.swift
//  DisEnsemble
//
//  Created by UbiComp on 12/8/21.
//

import UIKit

let AUDIO_BUFFER_SIZE = 1024*4

class ResultsViewController: UIViewController,UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let audio = AudioModel(buffer_size: AUDIO_BUFFER_SIZE)
    
    @IBOutlet weak var instrumentPicker: UIPickerView!
    
    var displayImageName = "piano"
    var row = 0
    

    @IBOutlet weak var image: UIImageView!
    
    
    lazy var dataModel = {
        return DataModel.sharedInstance()
    }()
    
    var pickerData:[Any] = ["piano"]// = ["piano"]//["one", "two" , "three"]
    
//    lazy private var imageView: UIImageView? = {
//        return UIImageView.init(image: self.dataModel.getImageWithName(displayImageName))
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audio.startProcessingAudioForPlayback()
        audio.play()

        self.instrumentPicker.delegate = self
        self.instrumentPicker.dataSource = self
        
        instrumentPicker.selectRow(row, inComponent: 0, animated: false)
        if pickerData.count == 0 {
            pickerData.append("Not Sure, or N/A")
        }
        
        self.image.image = self.dataModel.getImageWithName(pickerData[0] as! String)
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let name = pickerData[row] as? String {
            return name
        }
        return "idkman"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(pickerData[0])
        if let name = pickerData[row] as? String {
            image.image = self.dataModel.getImageWithName(name)
            if name == "Not sure, or N/A" {
                image.image = self.dataModel.getImageWithName("questionmark")
            }
            //imageView?.image? = self.dataModel.getImageWithName(name)
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        audio.endAudioProcessing()
        dismiss(animated: true, completion: nil)
        
    }
}
