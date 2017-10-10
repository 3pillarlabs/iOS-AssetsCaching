//
//  HeaderView.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 22/09/16.
//  Copyright © 2016 Liliana Bulgaru. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var clearCache: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
