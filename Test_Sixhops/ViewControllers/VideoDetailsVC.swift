//
//  VideoDetailsVC.swift
//  Test_Sixhops
//
//  Created by Shivam Chawla on 10/10/23.
//

import UIKit
import Photos

class VideoDetailsVC: UIViewController {
    @IBOutlet weak var videoNameLbl: UILabel!
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var resolutionLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var videoAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = videoAsset?.thumbnailImage
        getVideoInfo(for: videoAsset ?? PHAsset()) {videoName, resolution, duration, videoSize in
            DispatchQueue.main.async{
                self.videoNameLbl.text = videoName
                self.resolutionLbl.text = "\(resolution ?? CGSize())"
                self.durationLbl.text = "\(String(format:"%.3f",duration ?? 0.0))"
                self.sizeLbl.text = "\(String(format:"%.3f",Double(videoSize ?? 0) / (1024 * 1024))) mb"
            }
        }
        
        
    }
    func getVideoInfo(for asset: PHAsset, completion: @escaping (String?, CGSize?, TimeInterval?, Int64?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            guard let avAsset = avAsset as? AVURLAsset else {
                completion(nil, nil, nil, nil)
                return
            }
            
            // Get the video name
            let videoName = avAsset.url.lastPathComponent
            
            // Get the video duration
            let duration = avAsset.duration.seconds
            
            // Get the video size (file size in bytes)
            let videoSize = try? FileManager.default.attributesOfItem(atPath: avAsset.url.path)[.size] as? Int64
            
            // Get the video resolution
            let track = avAsset.tracks(withMediaType: .video).first
            let resolution = track?.naturalSize
            
            completion(videoName, resolution, duration, videoSize)
        }
    }
    
   
}
