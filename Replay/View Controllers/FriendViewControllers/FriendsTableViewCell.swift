//
//  FriendsTableViewCell.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/27/22.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user:User){
        nameLabel.text = "\(user.firstname) \(user.lastname)"
        usernameLabel.text = user.username
    }

}
