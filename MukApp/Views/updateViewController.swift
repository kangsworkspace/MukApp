//
//  updateViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class updateViewController: UIViewController {
    
    private let tableView = UITableView()
    
    // var menuData: MenuData?
    
    let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        setTableView()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면에 재진입 할 때 -> 테이블 뷰 데이터 리로드
        tableView.reloadData()
    }
    
    func setTableView() {
        
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 120
        
        // 셀 등록
        tableView.register(testTableViewCell.self, forCellReuseIdentifier: "testTableViewCell")
        
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

extension updateViewController: UITableViewDelegate {
    
}

extension updateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coreDataManager.getDataFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "testTableViewCell", for: indexPath) as! testTableViewCell
        
        let menuDatas = coreDataManager.getDataFromCoreData()
        let menuData = menuDatas[indexPath.row]
        cell.menuNameLabel.text = menuData.menuName
        
        let categories = menuData.category?.allObjects as? [CategoryData]
        if let firstCategory = categories?.first {
            cell.categoryNameLabel.text = firstCategory.categoryName
            cell.categoryTextLabel.text = firstCategory.categoryText
        }
        return cell
    }
    
    
}
