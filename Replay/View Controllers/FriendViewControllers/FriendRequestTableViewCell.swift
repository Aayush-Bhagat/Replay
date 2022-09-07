//
//  FriendRequestTableViewCell.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/26/22.
//

import UIKit

protocol FriendRequestCellDelegate: AnyObject{
    func didTapAcceptButton(user: User)
    func didTapDeclineButton(user: User)
}

class FriendRequestTableViewCell: UITableViewCell {
    
    weak var delegate: FriendRequestCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var user: User!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapAcceptButton(_ sender: Any) {
        delegate?.didTapAcceptButton(user: self.user)
    }
    
    
    @IBAction func didTapDeclineButton(_ sender: Any) {
        delegate?.didTapDeclineButton(user: self.user)
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
