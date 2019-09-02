//
//  SightDetailsViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 01/09/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit

class SightDetailsViewController: UIViewController {

    var locationImage: UIImage?
    var locationName: String?
    var locationDescription: String?
    var locationAddress: String?
    
    @IBAction func closeWindowButton(_ sender: Any) {
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        // Do any additional setup after loading the view.
        
        imageView.image = locationImage
        nameLabel.text = locationName
        addressLabel.text = locationAddress
        descriptionLabel.text = locationDescription
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let totalContentHeight = imageView.frame.height + nameLabel.frame.height + addressLabel.frame.height + descriptionLabel.frame.height
        scrollView.contentSize = CGSize(width: 375, height: totalContentHeight + 30)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
