//
//  VideoRunVC.swift
//  fD11_180805
//
//  Created by CAUAD02 on 2018. 8. 5..
//  Copyright © 2018년 CAUAD02. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class LectureVideoRun: UIViewController, AVAudioRecorderDelegate {
    
     var selectedLecture:Lecture?
    @IBOutlet weak var videoView: UIView!
    
    // selectedLecture의 영상 대기 함수
    func initializeVideo() {
        let videoString:String? = Bundle.main.path(forResource: selectedLecture?.lectureTitle, ofType: "mov")
        
        guard let openVideoPath = videoString else {return}
        
        let videoURL = URL(fileURLWithPath: openVideoPath)
        
        videoPlayer = AVPlayer(url: videoURL)
        
        let layer:AVPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        layer.frame = videoView.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.addSublayer(layer)
    }
    
    @IBAction func playVideo(_ sender: Any) {
        videoPlayer?.play()
    }
    
    @IBAction func pauseVideo(_ sender: Any) {
        videoPlayer?.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedLecture?.lectureTitle
        
        // 영상재생준비
        initializeVideo()
        
        // About Recording
        recordingSession = AVAudioSession.sharedInstance()
        
        if let recordNumber:Int = UserDefaults.standard.object(forKey: "recordNumber") as? Int {
            numberOfRecords = recordNumber
            
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
            if hasPermission
            {
                print("ACCEPTED")
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancelled")
    }
    @IBOutlet weak var recordButtonStatus: UIButton!
    
    @IBAction func record(_ sender: Any) {
        // recorder 가 켜져있는지 확인해보기
        if audioRecoder == nil {
            numberOfRecords += 1
            
            let recordFileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // START Recording
            do
            {
                audioRecoder = try? AVAudioRecorder(url: recordFileName, settings: settings)
                audioRecoder.delegate = self
                audioRecoder.record()
                
                recordButtonStatus.setImage(#imageLiteral(resourceName: "RecordING32"), for: .normal)
            }
            catch
            {
                disPlayAlert(title: "OOPS!", message: "Recording Failed!")
            }
        }
            // STOP Recording
        else
        {
            audioRecoder.stop()
            audioRecoder = nil
            
            UserDefaults.standard.set(numberOfRecords, forKey: "recordNumber")
            
            recordButtonStatus.setImage(#imageLiteral(resourceName: "MIC32"), for: .normal)
        }
    }
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        return documentDirectory
    }
    
    func disPlayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var newdata:RecordData?
        let alertView = UIAlertController(title: "저장하시겠습니까?", message: "저장된 녹음 파일은 RecordList에서 확인하실 수 있습니다.", preferredStyle: .alert)
        
        func saveData() {
            newdata = RecordData(lectureTitleOfRecord: (selectedLecture?.lectureTitle)!, numberOfTimesOfRecord: numberOfRecords)
            if let newdata = newdata {
                recordDataCenter.recordDataArray.append(newdata)
            }
            recordDataCenter.save()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        // alert View 구성
        let save = UIAlertAction(title: "저장", style: .default, handler:
        {
            (alert: UIAlertAction!) in
            saveData()
        })
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alertView.addAction(cancel)
        alertView.addAction(save)
        
        self.present(alertView, animated: true, completion: nil)
        print(recordDataCenter.recordDataArray.count)
        print(recordDataCenter.recordDataArray)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
