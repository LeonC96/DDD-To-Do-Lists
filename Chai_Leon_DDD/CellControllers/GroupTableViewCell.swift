//
//  GroupTableViewCell.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-21.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

	
	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var usersLbl: UILabel!
	@IBOutlet weak var nubmerOfTasksLbl: UILabel!
	
	var group: Group? {
		didSet{
			guard let group = group else {
				return
			}
			
			nameLbl.text = group.name
			usersLbl.text = group.users
			nameLbl.sizeToFit()
			//usersLbl.sizeToFit()
			
			//Not yet functional
			nubmerOfTasksLbl.text = ""
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
