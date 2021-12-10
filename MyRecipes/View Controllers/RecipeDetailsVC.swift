//
//  RecipeDetailsVC.swift
//  SwiftBootcampProject
//
//  Created by Noha Fahad on 01/12/2021.
//

import UIKit

class RecipeDetailsVC: UIViewController {
    var recipe: Recipe!
    var index: Int!

    @IBOutlet weak var editRecipeButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeDetailsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets up the recipe details screen
        setupUI()
        editRecipeButton.layer.cornerRadius = 15
        
        //Edited recipe notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(recipeEdited), name: NSNotification.Name(rawValue: "currentRecipeEdited"), object: nil)
    }
    
    @IBAction func editRecipeButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "newRecipe") as? NewRecipeVC
        if let viewController = vc{
            viewController.isNewRecipeAdded = false
            viewController.editedRecipe = recipe
            viewController.editedRecipeIndex = index
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func recipeEdited(notification: Notification){
        if let editedRecipe = notification.userInfo?["editedRecipe"] as? Recipe{
            recipe = editedRecipe
            setupUI()
        }
    }
    func setupUI(){
        recipeNameLabel.text = recipe.title
        recipeDetailsLabel.text = recipe.recipeDetails
        recipeImageView.image = recipe.image
    }
}
