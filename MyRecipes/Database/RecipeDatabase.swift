//
//  RecipeDatabase.swift
//  MyRecipes
//
//  Created by Noha Fahad on 10/12/2021.
//
import UIKit
import CoreData
class RecipeDatabase{
    
    //Store the recipe in Recipe ِentity
    static func storeRecipes(recipe: Recipe){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let recipeEntity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContex)!
        
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
    
    //Update the recipe in Recipe ِentity
    static func updateRecipe(recipe: Recipe, index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
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
    
    //Delete the recipe from Recipe ِentity
    static func deleteRecipe(index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do{
            let result = try managedContex.fetch(fetchRequest) as! [NSManagedObject]
            
            let deletedRecord = result[index]
            managedContex.delete(deletedRecord)
            try managedContex.save()
            
            } catch{
            print("Fails to fetch the records")
        }
    }
    
    //Retrive the recipes from Recipe ِentity
    static func retriveRecipes() -> [Recipe]{
        var recipes: [Recipe] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
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
