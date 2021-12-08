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
        self.myRecipes = retriveRecipes()
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(newRecipeAdded), name: NSNotification.Name(rawValue: "newRecipeAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recipeEdited), name: NSNotification.Name(rawValue: "currentRecipeEdited"), object: nil)
        
        myRecipesTableView.delegate = self
        myRecipesTableView.dataSource = self
    }
    
    @objc func newRecipeAdded(notification: Notification){
        if let newRecipe = notification.userInfo?["newRecipeAdded"] as? Recipe{
            myRecipes.append(newRecipe)
            myRecipesTableView.reloadData()
            storeRecipes(recipe: newRecipe)
        }
    }
    
    @objc func recipeEdited(notification: Notification){
        if let editedRecipe = notification.userInfo?["editedRecipe"] as? Recipe{
            if let index = notification.userInfo?["editedRecipeIndex"] as? Int{
            myRecipes[index] = editedRecipe
            myRecipesTableView.reloadData()
            updateRecipe(recipe: editedRecipe, index: index)
            }
        }
    }
    
    func storeRecipes(recipe: Recipe){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let recipeEntity = NSEntityDescription.entity(forEntityName: "Recipes", in: managedContex)!
        
        let recipeData = NSManagedObject(entity: recipeEntity, insertInto: managedContex)
        
        recipeData.setValue(recipe.title, forKey: "title")
        recipeData.setValue(recipe.recipeDetails, forKey: "details")
        if let image = recipe.image{
            let dataImage = image.pngData()
            recipeData.setValue(dataImage, forKey: "image")
        }
        
        do{
            try managedContex.save()
        } catch let error as NSError{
            print("Error! \(error)")
        }
        
    }
    func updateRecipe(recipe: Recipe, index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        do{
            let result = try managedContex.fetch(fetchRequest) as! [NSManagedObject]
            
            result[index].setValue(recipe.title, forKey: "title")
            result[index].setValue(recipe.recipeDetails, forKey: "details")
            if let image = recipe.image{
                let dataImage = image.pngData()
                result[index].setValue(dataImage, forKey: "image")
            }
            
            try managedContex.save()
            
            } catch{
            print("Fails to fetch the records")
        }
    }
    
    func deleteRecipe(index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        do{
            let result = try managedContex.fetch(fetchRequest) as! [NSManagedObject]
            
            let deletedRecord = result[index]
            managedContex.delete(deletedRecord)
            try managedContex.save()
            
            } catch{
            print("Fails to fetch the records")
        }
    }
    
    func retriveRecipes() -> [Recipe]{
        var recipes: [Recipe] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        do{
            let result = try managedContex.fetch(fetchRequest) as! [NSManagedObject]
            for record in result{
                let title = record.value(forKey: "title") as! String
                let details = record.value(forKey: "details") as? String
                var recipeImage: UIImage? = nil
                if  let image = record.value(forKey: "image") as? Data{
                    recipeImage = UIImage(data: image)
                }
                let recipe = Recipe(title: title, image: recipeImage, recipeDetails: details ?? "")
                recipes.append(recipe)
            }
        } catch{
            print("Fails to fetch the records")
        }
        return recipes
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
            self.deleteRecipe(index: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
