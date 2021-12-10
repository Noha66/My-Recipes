//
//  TableViewCell.swift
//  SwiftBootcampProject
//
//  Created by Noha Fahad on 30/11/2021.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDate: UILabel!
    @IBOutlet weak var recipeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
