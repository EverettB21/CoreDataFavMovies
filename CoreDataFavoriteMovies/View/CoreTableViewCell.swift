//
//  CoreTableViewCell.swift
//  CoreDataFavoriteMovies
//
//  Created by Everett Brothers on 11/2/23.
//

import UIKit

class CoreTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
