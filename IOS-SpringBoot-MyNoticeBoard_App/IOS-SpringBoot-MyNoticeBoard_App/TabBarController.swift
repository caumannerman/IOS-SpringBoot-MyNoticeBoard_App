//
//  TabBarController.swift
//  IOS-SpringBoot-MyNoticeBoard_App
//
//  Created by 양준식 on 2022/04/14.
//

import UIKit

//게시판 . 검색. 글쓰기 . 알림 . 내정보 총 5개의 tabBatItem으로 구성

class TabBarController: UITabBarController{
    
    private lazy var noticeBoardViewController: UIViewController = {
        let viewController = UINavigationController( rootViewController: NoticeBoardViewController())
        let tabBarItem = UITabBarItem(title: "게시판", image: UIImage(systemName: "list.bullet.indent"), tag: 0)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.red], for: .selected) UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.red], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemMint], for: .selected)
        
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var searchViewController: UIViewController = {
        let viewController = SearchViewController()
        let tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "ellipsis.circle"), tag: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemMint], for: .selected)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var newPostViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: NewPostViewController()) 
        let tabBarItem = UITabBarItem(title: "글쓰기", image: UIImage(systemName: "pencil"), tag: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemMint], for: .selected)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var alarmViewController: UIViewController = {
        let viewController = AlarmViewController()
        let tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "alarm"), tag: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemMint], for: .selected)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var myPageViewController: UIViewController = {
        let viewController = MyPageViewController()
        let tabBarItem = UITabBarItem(title: "내정보", image: UIImage(systemName: "person"), tag: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemMint], for: .selected)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [noticeBoardViewController, searchViewController, newPostViewController, alarmViewController, myPageViewController]
    }
}
