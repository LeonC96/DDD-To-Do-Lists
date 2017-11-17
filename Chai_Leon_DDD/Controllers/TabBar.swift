//
//  TabBar.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-17.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

extension UITabBar{
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		var sizeThatFits = super.sizeThatFits(size)
		sizeThatFits.height = 100 // adjust your size here
		return sizeThatFits
	}
}
