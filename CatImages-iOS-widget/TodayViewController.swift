//
//  TodayViewController.swift
//  CatImages-iOS-widget
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    
    @IBOutlet private weak var catImageView: UIImageView!
    
    private lazy var catService = CatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            //            widgetActiveDisplayModeDidChange(.compact, withMaximumSize: CGSize(width: 500, height: 100))
        }
        //        preferredContentSize.height = 100
        
    }
    
    func updateWidget() {
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

extension TodayViewController: NCWidgetProviding {
    
    /// "This method will not be called on widgets linked against iOS versions 10.0 and later."
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    /// Perform any setup necessary in order to update the view.
    /// If an error is encountered, use NCUpdateResult.Failed
    /// If there's no update required, use NCUpdateResult.NoData
    /// If there's an update, use NCUpdateResult.NewData
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateWidget()
        completionHandler(.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            /// maxSize for iPhone 5: width 304.0, height 110.0
            preferredContentSize = maxSize //CGSize(width: maxSize.width, height: 100)
        } else { /// expanded
            preferredContentSize = CGSize(width: maxSize.width, height: 300)
        }
    }
    
}
