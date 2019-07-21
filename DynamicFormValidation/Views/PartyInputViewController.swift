//
//  PartyInputViewController.swift
//  Inclusive
//
//  Created by Sam Furlong on 11/30/17.
//  Copyright © 2017 Sam Furlong. All rights reserved.
//

import UIKit
import FirebaseStorage
import FBSDKCoreKit
import ReactiveSwift
import ReactiveCocoa
import Result
class PartyInputViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AlertPresenter{
    var viewModel:PartyInputViewModel = PartyInputViewModel()

    // in the order they appear on the UI
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var partyImageView: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var doneButton: UIButton!
    private let imagePicker = UIImagePickerController()


    @IBAction func partyImageAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // reset the party after the view is reloaded
        
        bindNameField()
        bindDescriptionField()
        bindDateTimePickers()
        bindImagePicker()
        bindImage()
        bindDoneAction()
        bindLocation()
        bindDoneTransition()
        bindErrorPopUps()
        
    }
    
    private func bindNameField(){
        nameTextField.reactive.text <~ viewModel.name
        viewModel.name <~ nameTextField.reactive.continuousTextValues
        nameTextField.becomeFirstResponder()
    }
    private func bindDescriptionField(){
        descriptionTextField.reactive.text <~ viewModel.description
        viewModel.description <~ descriptionTextField.reactive.continuousTextValues
        
    }
    
    
    private func bindDateTimePickers(){
        // configuration and bidirectional binding for startDatePicker
        datePicker.datePickerMode = .date
        datePicker.reactive.date <~ viewModel.date
        viewModel.date <~ datePicker.reactive.dates
        
        // configuration and bidirectional binding for startTimePicker
        startTimePicker.datePickerMode = .time
        startTimePicker.reactive.date <~ viewModel.startTime
        viewModel.startTime <~ startTimePicker.reactive.dates
        
        // configuration and bidirectional binding for endTimePicker
        endTimePicker.datePickerMode = .time
        endTimePicker.reactive.date <~ viewModel.endTime
        viewModel.endTime <~ endTimePicker.reactive.dates
    }
    private func bindImagePicker(){
        imagePicker.delegate = self
        
    }
    private func bindImage(){
        partyImageView.reactive.image <~ viewModel.image
        
    }
    private func bindLocation(){
        locationTextField.reactive.text <~ viewModel.location
        viewModel.location <~ locationTextField.reactive.textValues
        
    }
    private func bindDoneAction(){
        doneButton.reactive.isEnabled <~ viewModel.canBeDone
        doneButton.reactive.pressed = CocoaAction<UIButton>(viewModel.doneAction){(sender:UIButton) in
            return self.viewModel.currentParty.value
            
        }
    }
    /// streams errors from the viewModel and presents an alert with the error description
    private func bindErrorPopUps(){
        let errorSignal = viewModel.error.signal
        errorSignal.take(during: Lifetime.of(self)).observeValues{[unowned self] errorValue in
            guard let error = errorValue else {
                return
            }
            self.presentAlert(with: error.description )
        }
        
        }

    /// observes the done action and when the party has been successfully submitted it the
    private func bindDoneTransition(){
   
        let successTransition = Signal<(),NoError>.Observer{_ in
            self.performSegue(withIdentifier: "PartyCreationSuccess", sender: self)
        }
        let errorTransition = Signal<PartyAPI.PartyUploadError, NoError>.Observer{[unowned self] error in
            self.presentAlert(with: error.event.value?.localizedDescription ?? "An Unexpected Error Occured Please Try Again")
        }
    
        viewModel.doneAction.values.take(during: Lifetime.of(self)).observe(successTransition)
        viewModel.doneAction.errors.take(during: Lifetime.of(self)).observe(errorTransition)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage {
            viewModel.image.swap(image)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? SelectLocationViewController {
            locationViewController.viewModel = viewModel
        }
        
    }
    
    
}
    
    
    
 
