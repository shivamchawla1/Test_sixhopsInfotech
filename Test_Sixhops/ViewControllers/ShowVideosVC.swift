//
//  ShowVideosVC.swift
//  Test_Sixhops
//
//  Created by Shivam Chawla on 10/10/23.
//

import UIKit
import Photos

class ShowVideosVC: UIViewController {
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var videoAssets: [PHAsset] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            
            // Handle restricted or denied state
            if status == .restricted || status == .denied
            {
                print("Status: Restricted or Denied")
            }
            
            // Handle limited state
            if status == .limited
            {
                self?.loadVideos()
                print("Status: Limited")
            }
            
            // Handle authorized state
            if status == .authorized
            {
                self?.loadVideos()
                print("Status: Full access")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
        // Request access to PhotosApp
       
    }
    
    func loadVideos() {
        self.videoAssets.removeAll()
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        fetchResult.enumerateObjects { asset, _, _ in
            
            self.videoAssets.append(asset)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func proceedBtnActn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
        vc.videoAsset = self.videoAssets[selectedIndexPath?.item ?? 0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ShowVideosVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoAssets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowVideosCVC", for: indexPath) as! ShowVideosCVC
        
        cell.layer.borderWidth = 0
        
        proceedBtn.isHidden = true
        
        cell.imageView.image = videoAssets[indexPath.item].thumbnailImage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ShowVideosCVC
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blue.cgColor
        self.selectedIndexPath = indexPath
        
        proceedBtn.isHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ShowVideosCVC
        cell.layer.borderWidth = 0
    }
    
}

extension PHAsset {
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
}
