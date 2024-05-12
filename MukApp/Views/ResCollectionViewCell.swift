//
//  RestaurantcollectionViewCell.swift
//  MukApp
//
//  Created by Kang on 10/28/23.
//

import UIKit

class ResCollectionViewCell: UICollectionViewCell {
    
    var indexPathNum: Int = 0
    
    // 생성 - 메인 이미지 뷰 
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var retaurantNameLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.mainImageView.image = nil
    }
    
    // MARK: - 셋업
    // 셋업 - 메인
    func setMain() {        
        setAddView()
        setAutoLayout()
    }
    
    // 셋업 - 애드 뷰
    func setAddView() {
        self.addSubview(mainImageView)
        self.addSubview(retaurantNameLabel)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        // mainImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mainImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            mainImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // retaurantNameLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            retaurantNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            retaurantNameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 3),
            retaurantNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -2),
        ])
    }
}
