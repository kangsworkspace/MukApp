//
//  ViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class mainViewController: UIViewController {
    
    // 서치 컨트롤러
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
    }
    
    // MARK: - 셋업
    // 셋업 - 메인
    func setMain() {
        // 배경 색 설정
        view.backgroundColor = .white
        
        setAddView()
        setAutoLayout()
        setupSearchBar()
    }
    
    // 셋업 - 뷰 추가
    func setAddView() {

    }
    
    // 서치바 셋팅
        func setupSearchBar() {
            self.title = "맛집 추가하기"

            // 네비게이션 바에 서치 컨트롤러 추가
            navigationItem.searchController = searchController
            
            // 서치바 사용
            searchController.searchBar.delegate = self
            
            // 첫글자 대문자 설정 없애기
            // searchController.searchBar.autocapitalizationType = .none
        }
    
    // MARK: - AutoLayout
    func setAutoLayout() {
        

    }
}

// MARK: - 확장
extension mainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    // 서치바에서 글자가 바뀔때마다 -> 소문자 변환
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // print("으엥")
    }
}
