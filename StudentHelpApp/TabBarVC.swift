//
//  TabBarVC.swift
//  StudentHelpApp
//
//  Created by Кирилл on 21.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var tabBarItem = UITabBarItem()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGray], for: .normal)
        
        for item in self.tabBar.items! {
            
            let unselectedItem: NSDictionary = [NSForegroundColorAttributeName: UIColor.gray]
            let selectedItem: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 139.0/255.0, green: 200.0/255.0, blue: 219.0/255.0, alpha: 1.0)]
            item.setTitleTextAttributes(unselectedItem as? [String : AnyObject], for: .normal)
            item.setTitleTextAttributes(selectedItem as? [String : AnyObject], for: .selected)
            
        }
        
        let selectedImageSearch = UIImage(named: "searchBlue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageSearch = UIImage(named: "searchGrey")?.withRenderingMode(.alwaysOriginal)
        tabBarItem = (self.tabBar.items?[0])!
        tabBarItem.image = DeSelectedImageSearch
        tabBarItem.selectedImage = selectedImageSearch
        
        let selectedImageMessage = UIImage(named: "messageBlue")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageMessage = UIImage(named: "messageGrey")?.withRenderingMode(.alwaysOriginal)
        tabBarItem = (self.tabBar.items?[1])!
        tabBarItem.image = deselectedImageMessage
        tabBarItem.selectedImage =  selectedImageMessage
        
        let selectedImageProfile = UIImage(named: "userBlue")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageProfile = UIImage(named: "userGrey")?.withRenderingMode(.alwaysOriginal)
        tabBarItem = (self.tabBar.items?[2])!
        tabBarItem.image = deselectedImageProfile
        tabBarItem.selectedImage = selectedImageProfile
        
        // selected tab background color
        //let numberOfItems = CGFloat(tabBar.items!.count)
        //let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        
        
        //tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.6078429818, green: 0.8229823709, blue: 0.8866739273, alpha: 0.45) , size: tabBarItemSize)
        
        // initaial tab bar index
        self.selectedIndex = 0

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
