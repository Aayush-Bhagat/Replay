//
//  SearchFriendCell.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/25/22.
//

import UIKit

protocol SearchFriendTableViewCellDelegate: AnyObject{
    func didTapAddFriendButton(user:User)
}

class SearchFriendCell: UITableViewCell {
    
    weak var delegate: SearchFriendTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var isFriendLabel: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    var user: User!
    
    @IBAction func didTapAddFriendButton(){
        delegate?.didTapAddFriendButton(user: self.user)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user:User){
        self.user = user
        
        nameLabel.text = "\(user.firstname) \(user.lastname)"
        usernameLabel.text = user.username
    }

}
