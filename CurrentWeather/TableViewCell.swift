//
//  TableViewCell.swift
//  CurrentWeather
//
//  Created by Louis Curty on 05/04/2017.
//  Copyright © 2017 Louis Curty. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{
    
    //MARK: Properties

    @IBOutlet weak var imagePred: UIImageView!
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var tempMorn: UILabel!
    @IBOutlet weak var tempEve: UILabel!
    @IBOutlet weak var tempNight: UILabel!
    
}
