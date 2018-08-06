//
//  RecordData.swift
//  fD11_180805
//
//  Created by CAUAD02 on 2018. 8. 5..
//  Copyright © 2018년 CAUAD02. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class RecordData:NSObject, NSCoding {
    var lectureTitleOfRecord:String?
    var numberOfTimesOfRecord:Int?
    
    init (lectureTitleOfRecord:String, numberOfTimesOfRecord:Int) {
        self.lectureTitleOfRecord = lectureTitleOfRecord
        self.numberOfTimesOfRecord = numberOfTimesOfRecord
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lectureTitleOfRecord, forKey: "lectureTitleOfRecord")
        aCoder.encode(self.numberOfTimesOfRecord, forKey: "numberOfTimesOfRecord")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lectureTitleOfRecord = aDecoder.decodeObject(forKey: "lectureTitleOfRecord") as? String
        self.numberOfTimesOfRecord = aDecoder.decodeObject(forKey: "numberOfTimesOfRecord") as? Int
    }
}

let recordDataCenter:RecordDataCenter = RecordDataCenter() // 여기세 RecordDataCenter 을 상속시킴
let fileName = "RecordData.m4a"

var recordingSession: AVAudioSession!
var audioRecoder:AVAudioRecorder!
var audioPlayer:AVAudioPlayer!

var numberOfRecords:Int = 0

class RecordDataCenter {
    var recordDataArray:[RecordData] = []
    
    var filePath:String {
        get {
           let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            return documentDirectory + fileName
        }
    }
    init() {
        if FileManager.default.fileExists(atPath: self.filePath){
        
        if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath) as? [RecordData] {
            recordDataArray += unarchArray
        }
        else {
            recordDataArray += makeData()
            }
        }
    }
    func makeData() -> [RecordData] {
        var depositDatas:[RecordData] = []
        print("[depositDatas]를 새로 생성합니다.")
        return depositDatas
    }
        
    func save() {
        NSKeyedArchiver.archiveRootObject(self.recordDataArray, toFile: self.filePath)
        print("archive saved to: \(self.filePath)")
    }
}

class RecordCell: UITableViewCell {
    @IBOutlet weak var savedRecordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}



