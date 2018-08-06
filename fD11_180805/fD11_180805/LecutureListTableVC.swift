//
//  LecutureListTableVC.swift
//  fD11_180805
//
//  Created by CAUAD02 on 2018. 8. 5..
//  Copyright © 2018년 CAUAD02. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class LecutureListTable: UITableViewController {

    // 동영상의 Thumbnail을 뽑아내는 함수
    func getThumbnail(videoName: String) -> UIImage? {
        do {
            let file = videoName.components(separatedBy: ".")
            let path = Bundle.main.path(forResource: file[0], ofType: file[1])
            // "."으로 나눠진 두 부분에서 file[0] 앞(lectureTitle) file[1]은 뒷 부분 확장자타입(mov)
            let asset = AVAsset(url: URL(fileURLWithPath: path!))
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            
            imgGenerator.appliesPreferredTrackTransform = true
            
            let coregraphicImage = try imgGenerator.copyCGImage(at: CMTimeMake(1, 2), actualTime: nil)
            let thumbnail = UIImage(cgImage: coregraphicImage)
            
            return thumbnail
        }
        catch {
            print("ERROR GENERATING THUMBNAIL:\(error.localizedDescription)")
            return nil
        }
    }
    
    // 동영상의 RunTime을 초단위로 뽑아내는 함수
    func getLectureRunTime(videoTitle:String) -> Float64 {
        let targetedLecutureVideoPath:String? = Bundle.main.path(forResource: videoTitle, ofType: "mov")
        let targetedLectureVideoURL = URL(fileURLWithPath: targetedLecutureVideoPath!)
        let targetedLecture = AVAsset(url: targetedLectureVideoURL)
        let runtime = targetedLecture.duration
        
        return CMTimeGetSeconds(runtime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lec1 = Lecture(lectureThumbnail: getThumbnail(videoName: "The Cheesecake 01.mov"), lectureWithNumber: "Lec1", lectureTitle: "The Cheesecake 01", lectureRunTime: Int(getLectureRunTime(videoTitle: "The Cheesecake 01")))
        let lec2 = Lecture(lectureThumbnail: getThumbnail(videoName: "The Cheesecake 02.mov"), lectureWithNumber: "Lec2", lectureTitle: "The Cheesecake 02", lectureRunTime: Int(getLectureRunTime(videoTitle: "The Cheesecake 02")))
        let lec3 = Lecture(lectureThumbnail: getThumbnail(videoName: "The Cheesecake 03.mov"), lectureWithNumber: "Lec3", lectureTitle: "The Cheesecake 03", lectureRunTime: Int(getLectureRunTime(videoTitle: "The Cheesecake 03")))
        
        lecturesList.append(lec1)
        lecturesList.append(lec2)
        lecturesList.append(lec3)
        
        self.navigationItem.title = "LecList"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lecturesList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureCell", for: indexPath)

        guard let lecCell = cell as? LectureCell else {
            return cell
        }

        lecCell.lectureThumbnailIMGView?.image = lecturesList[indexPath.row].lectureThumbnail
        lecCell.lectureWithNumberLabel.text = lecturesList[indexPath.row].lectureWithNumber
        lecCell.lectureTitleLabel.text = lecturesList[indexPath.row].lectureTitle
        lecCell.lectureRunTimeLabel.text = String(lecturesList[indexPath.row].lectureRunTime / 60 ) + "분 " + String(lecturesList[indexPath.row].lectureRunTime % 60 ) + "초"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let lecVideoRunVC = segue.destination as? LectureVideoRun
        let selectedIndexPath = self.tableView.indexPathForSelectedRow
        
        if let indexPath = selectedIndexPath {
            lecVideoRunVC?.selectedLecture = lecturesList[indexPath.row]
        }
    }
  

}
