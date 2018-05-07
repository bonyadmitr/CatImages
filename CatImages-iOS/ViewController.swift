//
//  ViewController.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class CatViewController: UIViewController {

    @IBOutlet private weak var catImageView: UIImageView!
    
    private lazy var catService = CatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catService.getRandomImage { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.catImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                } 
            }
        }
        
    }
    
}

