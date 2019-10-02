//
//  MainPageViewController.swift
//  KiwiInterestingFlights
//
//  Created by xbouma on 02/10/2019.
//  Copyright © 2019 xbouma. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    var flights = [Flight]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        print("Macka maznava")
        let urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        DispatchQueue.global(qos: .userInitiated).async{ [weak self ] in
            print("1")
            if let url = URL(string: urlString){
                print("2")
                if let data = try? Data(contentsOf: url){
                    print("3")
                    self?.parse(jsonData: data)
                    return
                }
            }
            
        }
    }

    func parse(jsonData: Data){
        let decoder = JSONDecoder()
        print("4")
        if let jsonPetitions = try? decoder.decode(Flights.self, from: jsonData){
            print("5")
            flights = jsonPetitions.results
            print(flights)
        }
    }
    
    
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "Green"),
                self.newColoredViewController(color: "Red"),
                self.newColoredViewController(color: "Blue"),
                self.newColoredViewController(color: "Red"),
                self.newColoredViewController(color: "Blue")]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        print("Macka maznava")
        let viewController = FlightsViewController()
        viewController.view.backgroundColor = .random()
        viewController.label.text = "Ahoj"
        return viewController
    }

    

}

extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
