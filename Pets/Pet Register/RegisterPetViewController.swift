//
//  RegisterPetViewController.swift
//  Pets
//
//  Created by Erick Martins on 06/11/21.
//

import UIKit

protocol addPetDelegate{
    func didAddPet(pet: Pet)
}

class RegisterPetViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ColorSelection {
    
    @IBOutlet weak var isVaccinatedSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var birthDateTextF: UITextField!
    @IBOutlet weak var specieTextF: UITextField!
    var selectedColor: UIColor?
    var delegate: addPetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        title = "Cadastrar pet"
        
        //circle imageview config
        imageView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
    }
    
    func setupTextField(){
        
        nameTextF.delegate = self
        birthDateTextF.delegate = self
        specieTextF.delegate = self
    }
    
    @IBAction func changeImageButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Pets", message: "Selecione uma opção", preferredStyle: .actionSheet)
        
        //select from camera
        let cameraButton = UIAlertAction(title: "Câmera", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(cameraButton)
        
        //select from library
        let libraryButton = UIAlertAction(title: "Biblioteca de fotos", style: .default) {_ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(libraryButton)
        
        //cancel button in actionsheet
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage //as? converts the function of the optional to UIImage
        
        if let image = selectedImage{
            imageView.image = image
        }else{
            presentMessage(message: "Você deve selecionar uma imagem")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        let name = nameTextF.text
        let birthDate = birthDateTextF.text
        let specie = specieTextF.text
        
        guard let petName = name, petName != "" else {
            presentMessage(message: "Campo nome deve ser preenchido")
            return
        }
        
        guard let petBirthDate = birthDate, petBirthDate != "" else {
            presentMessage(message: "Campo data de nascimento deve ser preenchido")
            return
        }
        
        guard let petSpecie = specie, petSpecie != "" else {
            presentMessage(message: "Campo espécie deve ser preenchido")
            return
        }
        
        guard let color = selectedColor else{
            
            presentMessage(message: "Você deve selecionar uma cor")
            return
        }
        
        //Constructor parameters
        let pet = Pet(name: petName, specie: petSpecie, birthDate: petBirthDate, color: color, isVaccinated: isVaccinatedSwitch.isOn )
        
        pet.petImage = imageView.image
        delegate?.didAddPet(pet: pet)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true) //close the VC for the view before that
    }
    
    @IBAction func selectColor(_ sender: Any) {
        
        let colorSelectionVC = ColorSelectionViewController()
        present(colorSelectionVC, animated: true, completion: nil)
        
        colorSelectionVC.delegate = self
    }
    
    //select the pet circle image color
    func didSelectColor(color: UIColor) {
        selectedColor = color
        imageView.layer.borderColor = selectedColor?.cgColor
        
        
    }
    
    //Pressing the return on key get back to the view
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
