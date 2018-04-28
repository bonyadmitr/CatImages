//
//  TodayViewController.swift
//  CatImages-macOS-widget
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import NotificationCenter

/// mac-today-extension must be sandboxed to debug
class TodayViewController: NSViewController {

    @IBOutlet private weak var catImageView: NSImageView!
    
    private lazy var catService = CatService()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
}

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
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
        
        completionHandler(.newData)
    }
}
