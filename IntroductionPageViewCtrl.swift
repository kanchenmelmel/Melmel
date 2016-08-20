//
//  IntroductionPageViewCtrl.swift
//  Melmel
//
//  Created by Work on 19/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class IntroductionPageViewCtrl: UIPageViewController {
    
    private(set) lazy var orderedViewControllers:[UIViewController] = {
        return [self.newViewController("firstIntroductionViewCtrl"),self.newViewController("secondIntroductionViewCtrl"),self.newViewController("thirdIntroductionViewCtrl")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        
        if let firstViewCtrl = orderedViewControllers.first {
            setViewControllers([firstViewCtrl], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    
    
    private func newViewController(viewControllerIdentifier:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIdentifier)
    }
    

}

extension IntroductionPageViewCtrl:UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewCtrl = viewControllers?.first, firstViewCtrlIndex = orderedViewControllers.indexOf(firstViewCtrl) else {
            return 0
        }
        
        return firstViewCtrlIndex
    }
    
    
}