//
//  ViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Main뷰 모델
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Interface
    // 서치 컨트롤러
    let searchController = UISearchController(searchResultsController: nil)
    
    // 테이블 뷰
    private let tableView = UITableView()
    
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
        setSearchBar()
        setTableView()
        setAutoLayout()
    }
    
    // 셋업 - 뷰 추가
    func setAddView() {
        view.addSubview(tableView)
    }
    
    // 서치바 셋팅
    func setSearchBar() {
        self.title = "검색"
        
        // 네비게이션 바에 서치 컨트롤러 추가
        navigationItem.searchController = searchController
        
        // PlaceHolder 추가
        searchController.searchBar.placeholder = "추가하려는 맛집을 검색해주세요"
        
        // 서치바 사용
        searchController.searchBar.delegate = self
        
        // 스크롤링 시 가려짐 방지
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // 셋업 - 테이블 뷰
    func setTableView() {
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 60
        
        // 셀 등록
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    // MARK: - AutoLayout
    func setAutoLayout() {
        // tableView 오토 레이아웃 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - 확장
// 서치바 델리게이트
extension SearchViewController: UISearchBarDelegate {
    // 서치바에서 글자가 바뀔 때
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 빈 검색어 검색 안함
        if searchText != "" {
            // 뷰 모델에서 API 요청
            viewModel.searchResFromAPI(keyword: searchText) { result in
                self.tableView.reloadData()
            }
        }
    }
}

// 확장 - 테이블 뷰 델리게이트
extension SearchViewController: UITableViewDelegate {
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resData = viewModel.getResArray()
        viewModel.handleResCellTapped(resData: resData[indexPath.row], fromCurrentVC: self, animated: true)
    }
}

// 확장 - 테이블 뷰 DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getResArray().count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.backgroundColor = .white
        
        let resData = viewModel.getResArray()
        cell.resNameLabel.text = resData[indexPath.row].placeName
        cell.resAddressLabel.text = resData[indexPath.row].roadAddress
        cell.resGroupLabel.text = resData[indexPath.row].group
        cell.resPhoneLabel.text = resData[indexPath.row].phone
        return cell
    }
}


