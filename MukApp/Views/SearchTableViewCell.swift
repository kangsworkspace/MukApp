//
//  SearchTableViewCell.swift
//  MukApp
//
//  Created by Kang on 11/3/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // MARK: - Interface
    lazy var resImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var resNameLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "번 패티 버어언"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var resAddressLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "올림픽대로 대로변 1길 222리"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var resGroupLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "음식 > 중 최고 > 햄버거 > 맛있어"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var resPhoneLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "010 - 1234 -5678"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 셋업
    private func setMain() {
        setAddView()
        setAutoLayout()
    }
    
    private func setAddView() {
        self.addSubview(resImageView)
        self.addSubview(resNameLabel)
        self.addSubview(resAddressLabel)
        self.addSubview(resGroupLabel)
        self.addSubview(resPhoneLabel)
    }
    
    private func setAutoLayout() {
        
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            resImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            resImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            resImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        // resNameLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resNameLabel.leadingAnchor.constraint(equalTo: resImageView.trailingAnchor, constant: 10),
            resNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        // resAddressLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resAddressLabel.leadingAnchor.constraint(equalTo: resImageView.trailingAnchor, constant: 10),
            resAddressLabel.topAnchor.constraint(equalTo: resNameLabel.bottomAnchor, constant: 5)
        ])
        
        // resGroupLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resGroupLabel.leadingAnchor.constraint(equalTo: resNameLabel.trailingAnchor, constant: 5),
            resGroupLabel.bottomAnchor.constraint(equalTo: resAddressLabel.topAnchor, constant: -5)
        ])
        
        // resPhoneLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resPhoneLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            resPhoneLabel.bottomAnchor.constraint(equalTo: resAddressLabel.bottomAnchor, constant: 0)
        ])
    }
}
