//
//  DoingTaskTableViewCell.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-09.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class DoingTaskTableViewCell: UITableViewCell {
    
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dueDateLbl: UILabel!
	
    var task: Task? {
        didSet {
            guard let task = task else { return }
            
            nameLabel.text = task.name
            descriptionLabel.text = task.description
            nameLabel.sizeToFit()
            descriptionLabel.sizeToFit()
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .short
			dueDateLbl.text = dateFormatter.string(from: task.dueDate)
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
    @IBAction func doneButton(_ sender: UIButton) {
    }
    
}
