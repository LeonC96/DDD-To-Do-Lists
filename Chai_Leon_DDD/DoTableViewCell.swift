//
//  TaskTableViewCell.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

	@IBOutlet weak var taskLbl: UILabel!
	@IBOutlet weak var descriptionLbl: UILabel!
	
    var task: Task? {
        didSet{
            guard let task = task else {
                return
            }
            
            taskLbl.text = task.name
            descriptionLbl.text = task.description
            taskLbl.sizeToFit()
            descriptionLbl.sizeToFit()
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
