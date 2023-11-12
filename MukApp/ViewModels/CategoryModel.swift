//
//  CategoryModel.swift
//  MukApp
//
//  Created by Kang on 11/12/23.
//

import UIKit

final class CategoryModel {

    // MARK: - 싱글톤
    static let shared = CategoryModel()
    private init() {}
    
    
    // 코어 데이터에 저장할 카테고리 배열
    private var selCatNameArray: [String] = []
    private var selCatTextArray: [String] = []
    private var selResData: Document?
    
    // 코어 데이터에 저장할 카테고리 배열 세팅
    func setCategoryArray(text: String, category: String) {
        // 선택된 카테고리에 더하기(이후 코어 데이터에 저장)
        if category == "name" {
            print("저장 전 selCatNameArray: \(self.selCatNameArray)")
            self.selCatNameArray.append(text)
            print("저장 후 selCatNameArray: \(self.selCatNameArray)")
        } else {
            print("저장 전 selCatTextArray: \(self.selCatTextArray)")
            self.selCatTextArray.append(text)
            print("저장 후 selCatTextArray: \(self.selCatTextArray)")
        }
    }
    
    // 코어 데이터에 저장할 resData 배열 세팅
    func setResData(resData: Document) {
        selResData = resData
    }
    
    // Name 카테고리 리턴
    func getSelCatNameArray () -> ([String]) {
        return selCatNameArray
    }
    
    // Text 카테고리 리턴
    func getSelCatTextArray () -> ([String]) {
        return selCatTextArray
    }
    
    // resData 배열 리턴
    func getSelResData () -> (Document) {
        return selResData!
    }
}
