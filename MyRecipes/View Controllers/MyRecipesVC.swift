//
//  ViewController.swift
//  SwiftBootcampProject
//
//  Created by Noha Fahad on 30/11/2021.
//

import UIKit
import CoreData

class MyRecipesVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var myRecipesTableView: UITableView!
    var myRecipes: [Recipe] = []
    
    override func viewDidLoad() {
        self.myRecipes = RecipeDatabase.retriveRecipes()
        super.viewDidLoad()
        
        //New recipe added notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(newRecipeAdded), name: NSNotification.Name(rawValue: "newRecipeAdded"), object: nil)
        
        //Edited recipe notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(recipeEdited), name: NSNotification.Name(rawValue: "currentRecipeEdited"), object: nil)
        
        myRecipesTableView.delegate = self
        myRecipesTableView.dataSource = self
    }
    
    @objc func newRecipeAdded(notification: Notification){
        if let newRecipe = notification.userInfo?["newRecipeAdded"] as? Recipe{
            myRecipes.append(newRecipe)
            myRecipesTableView.reloadData()
            RecipeDatabase.storeRecipes(recipe: newRecipe)
        }
    }
    
    @objc func recipeEdited(notification: Notification){
        if let editedRecipe = notification.userInfo?["editedRecipe"] as? Recipe{
            if let index = notification.userInfo?["editedRecipeIndex"] as? Int{
            myRecipes[index] = editedRecipe
            myRecipesTableView.reloadData()
            RecipeDatabase.updateRecipe(recipe: editedRecipe, index: index)
            }
        }
    }
}

extension MyRecipesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = myRecipes[indexPath.row]
        cell.recipeName.text = recipe.title
        cell.recipeImg.image = recipe.image
        cell.recipeImg.layer.cornerRadius = 15
        cell.recipeView.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "recipeDetails") as? RecipeDetailsVC
        let recipe = myRecipes[indexPath.row]
        if let viewController = vc{
            viewController.recipe = recipe
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //Swip right to delete a recipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "حذف") { action, view, completionHandler in
            self.myRecipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            RecipeDatabase.deleteRecipe(index: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
