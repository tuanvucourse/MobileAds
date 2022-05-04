//
//  TestViewController.swift
//  MobileAds
//
//  Created by ANH VU on 16/03/2022.
//

import UIKit

public class TestViewController: UIViewController {

    @IBOutlet weak var imgTest: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
       
        imgTest.image = UIImage(named: "ic_test", in: Bundle(for: type(of: self)), compatibleWith: nil)
        // Do any additional setup after loaaddChildViewControllerding the view.
    }

}

