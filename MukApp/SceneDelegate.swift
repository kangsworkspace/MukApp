//
//  SceneDelegate.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // scene 설정
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 탭 바 컨트롤러 생성
        let tabBarCon = UITabBarController()
        
        // CoreDataManager 객체 생성
        let coreDatamanager = CoreDataManager()
        // APIService 객체 생성
        let apiService = APIService()
        
        let menuViewModel = MenuViewModel(coreDataManager: coreDatamanager)
        let mainViewModel = MainViewModel(coreDataManager: coreDatamanager, apiServie: apiService)

        
        // 네이게이션 바 설정
        let vc1 = UINavigationController(rootViewController: MainViewController(viewModel: menuViewModel))
        let vc2 = UINavigationController(rootViewController: ResViewController(viewModel: mainViewModel))
        
        // 뷰 컨트롤러 -> 탭 바 설정
        tabBarCon.setViewControllers([vc1, vc2], animated: false)
        tabBarCon.modalPresentationStyle = .fullScreen
        tabBarCon.tabBar.backgroundColor = .white
        
        // 탭 바 이름
        vc1.title = "룰렛 돌리기"
        vc2.title = "맛집 관리하기"
        
        // 탭 바 이미지
        guard let items = tabBarCon.tabBar.items else { return }
        items[0].image = UIImage(systemName: "shuffle")
        items[1].image = UIImage(systemName: "folder")
        
        // 첫 화면(루트 뷰)를 설정
        window?.rootViewController = tabBarCon
        window?.makeKeyAndVisible()
        
        if #available(iOS 15.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

