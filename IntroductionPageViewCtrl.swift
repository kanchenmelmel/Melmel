//
//  IntroductionPageViewCtrl.swift
//  Melmel
//
//  Created by Work on 19/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

//this class uses page view controller to show user intro info when they first use the app
class IntroductionPageViewCtrl: UIPageViewController {
    
    fileprivate(set) lazy var orderedViewControllers:[UIViewController] = {
        return [self.newViewController("firstIntroductionViewCtrl"),self.newViewController("secondIntroductionViewCtrl"),self.newViewController("thirdIntroductionViewCtrl")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    
        
        
        if let firstViewCtrl = orderedViewControllers.first {
            setViewControllers([firstViewCtrl], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    
    fileprivate func newViewController(_ viewControllerIdentifier:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
    

}

extension IntroductionPageViewCtrl:UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
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
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewCtrl = viewControllers?.first, let firstViewCtrlIndex = orderedViewControllers.index(of: firstViewCtrl) else {
            return 0
        }
        
        return firstViewCtrlIndex
    }
    
    
}
