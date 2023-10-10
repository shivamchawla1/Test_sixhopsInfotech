//
//  ViewController.swift
//  Test_Sixhops
//
//  Created by Shivam Chawla on 10/10/23.
//

import UIKit

class HomePageVC: UIViewController {
    @IBOutlet weak var loadVideosBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadVideosBtn.layer.cornerRadius = loadVideosBtn.frame.height / 2
        loadVideosBtn.layer.borderWidth = 1
    }
    
    

    @IBAction func loadVideosActn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowVideosVC") as! ShowVideosVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

