//
//  RestaurantViewController.swift
//  MukApp
//
//  Created by Kang on 11/26/23.
//

import UIKit

class EditViewController: UIViewController {
    
    let tableView = UITableView()
    
    let mainLable: UILabel = {
        let label = UILabel()
        label.text = "Info"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerTitles: [String] = ["문의", "자주묻는 질문"]
    let questions: [String] = ["맛집의 사진을 변경할 수 있나요?", "가운데 있는 태그(#)를 삭제하고 싶어요", "저장한 맛집을 삭제하고 싶어요"]
    let answers: [String] = [
        """
        
        이미지를 터치하시면 앨범의 이미지를 불러올 수 있습니다.
        만약 앨범에 접근이 불가능하다면 설정에서 
        접근 권한을 허용해주셔야 합니다.
        """,
        """
        
        삭제를 원하시는 태그를 길게 누르시면 삭제 알림이 나타납니다.
        또는 -버튼을 누르시면 마지막에 있는 태그(#)가 삭제됩니다.
        """,
        """
        
        저장한 맛집 목록이 있는 페이지에서 삭제를
        원하시는 맛집을 길게 누르시면
        삭제 알림이 나타납니다.
        """,
    ]
        
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setMain()
    }
    
    func setMain() {
        self.view.backgroundColor = .white
    
        setTableView()
        setAddView()
        setAutoLayout()
    }
    
    func setTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints  = false  
        
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setAddView() {
        self.view.addSubview(tableView)
        self.view.addSubview(mainLable)
    }

    func setAutoLayout() {
        NSLayoutConstraint.activate([
            mainLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainLable.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainLable.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

extension EditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension EditViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // 첫 번째 섹션의 행 수
        } else if section == 1 {
            return 3 // 두 번째 섹션의 행 수
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            content.text = "kangsworkspace@naver.com"
            cell.selectionStyle = .none
        case 1:
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            content.textProperties.color = MyColor.themeColor
            content.text = questions[indexPath.row]
            
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            content.secondaryText = answers[indexPath.row]
        default:
            break
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
}
