//
//  Data.swift
//  fD11_180805
//
//  Created by CAUAD02 on 2018. 8. 5..
//  Copyright © 2018년 CAUAD02. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import AVFoundation

var videoPlayer:AVPlayer?

class Lecture: NSObject, NSCoding {
    var lectureThumbnail:UIImage?
    var lectureWithNumber:String
    var lectureTitle:String
    var lectureRunTime:Int
    
    init (lectureThumbnail:UIImage?, lectureWithNumber:String, lectureTitle:String, lectureRunTime:Int) {
        self.lectureThumbnail = lectureThumbnail
        self.lectureWithNumber = lectureWithNumber
        self.lectureTitle = lectureTitle
        self.lectureRunTime = lectureRunTime
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lectureThumbnail, forKey: "thumbnail")
        aCoder.encode(self.lectureWithNumber, forKey: "lecNumber")
        aCoder.encode(self.lectureTitle, forKey: "lecTitle")
        aCoder.encode(self.lectureRunTime, forKey: "lecRunTime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lectureThumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? UIImage
        self.lectureWithNumber = aDecoder.decodeObject(forKey: "lecNumber") as! String
        self.lectureTitle = aDecoder.decodeObject(forKey: "lecTitle") as! String
        self.lectureRunTime = aDecoder.decodeObject(forKey: "lecRunTime") as! Int
    }
}

var lecturesList:[Lecture] = [] // Lectures의 목록들을 array로 배열 선언

class LectureCell : UITableViewCell {
    @IBOutlet weak var lectureThumbnailIMGView: UIImageView!
    @IBOutlet weak var lectureWithNumberLabel: UILabel!
    @IBOutlet weak var lectureTitleLabel: UILabel!
    @IBOutlet weak var lectureRunTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
