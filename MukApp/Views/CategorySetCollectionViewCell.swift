//
//  CategorySetCollectionViewCell.swift
//  MukApp
//
//  Created by Kang on 11/9/23.
//

import UIKit

class CategorySetCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 셋업
    // 셋업 - 메인
    func setMain() {
        self.backgroundColor = .gray
    }
}
