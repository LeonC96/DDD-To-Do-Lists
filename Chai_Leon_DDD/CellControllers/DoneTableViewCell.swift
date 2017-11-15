//
//  DoneTableViewCell.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-14.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dueDateLbl: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var task: Task? {
		didSet {
			guard let task = task else {
				return
				
			}
			
			nameLabel.text = task.name
			descriptionLabel.text = task.description
			nameLabel.sizeToFit()
			
			dueDateLbl.text = Utils.dateToString(date: task.dueDate)
			dueDateLbl.sizeToFit()
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
