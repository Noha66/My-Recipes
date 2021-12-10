//
//  NewRecipeVC.swift
//  SwiftBootcampProject
//
//  Created by Noha Fahad on 01/12/2021.
//

import UIKit

class NewRecipeVC: UIViewController {
    
    var isNewRecipeAdded = true
    var editedRecipe: Recipe?
    var editedRecipeIndex: Int?
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeDetailsTextView: UITextView!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Styling
        recipeDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        recipeDetailsTextView.layer.borderWidth = 0.5
        recipeDetailsTextView.layer.cornerRadius = 15
        addButton.layer.cornerRadius = 15
        
        //Checks if it is a new recipe or edited recipe
        if !isNewRecipeAdded{
            addButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل الوصفة"
            
            if let recipe = editedRecipe{
                recipeTitleTextField.text = recipe.title
                recipeDetailsTextView.text = recipe.recipeDetails
                recipeImg.image = editedRecipe?.image
            }
        }

    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isNewRecipeAdded{
            let newRecipe = Recipe(title: recipeTitleTextField.text!, image: recipeImg.image, recipeDetails: recipeDetailsTextView.text)
        
        //Posts a notification for the new added recipe
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newRecipeAdded"), object: nil, userInfo: ["newRecipeAdded" : newRecipe])
            
        //Shows alert after adding the recipe
            let alert = UIAlertController(title: "تمت الإضافة", message: "لقد قمت بإضافة وصفة جديدة بنجاح", preferredStyle: UIAlertController.Style.alert)
            let closeAlert = UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default) { _ in
                self.tabBarController?.selectedIndex = 0
                self.recipeTitleTextField.text = ""
                self.recipeDetailsTextView.text = ""
                self.recipeImg.image = nil
            }
            alert.addAction(closeAlert)
            present(alert, animated: true, completion: nil)
            
        }else{ //if it is an edited recipe
            let recipe = Recipe(title: recipeTitleTextField.text!, image: recipeImg.image, recipeDetails: recipeDetailsTextView.text)
            
            //Posts a notification for the edited recipe
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentRecipeEdited"), object: nil, userInfo: ["editedRecipe": recipe, "editedRecipeIndex": editedRecipeIndex!])
            
            //Shows alert after editing the recipe
            let alert = UIAlertController(title: "تم التعديل", message: "لقد قمت بتعديل الوصفة بنجاح", preferredStyle: UIAlertController.Style.alert)
            let closeAlert = UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default) { _ in
                self.navigationController?.popViewController(animated: true)
                self.recipeTitleTextField.text = ""
                self.recipeDetailsTextView.text = ""
                self.recipeImg.image = nil
            }
            alert.addAction(closeAlert)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editImageClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

}

extension NewRecipeVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        recipeImg.image = image
    }
}
