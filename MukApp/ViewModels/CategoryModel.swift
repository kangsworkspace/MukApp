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
    
    
    private var isCatSelected = false
    private var isCatNameAppending = true
    private var isNeedToFixText = false
    private var isNeedToDeleteCat = false
    
    private var resListNum = 0
    
    // 코어 데이터에 저장할 카테고리 배열 세팅
    func setCategoryNameArray(text: String) {
        // 카테고리 네임 추가
        if isCatNameAppending {
            self.selCatNameArray.append(text)
            setIsNameAppendingFalse()
            setIsNeedToDeleteCatTrue()
            print(isCatNameAppending)
            print("저장 후 selCatNameArray: \(self.selCatNameArray)")
        }
        // 카테고리 네임 변경(Text 설정 후)
        else if selCatNameArray.count == selCatTextArray.count {
            self.selCatNameArray[selCatNameArray.count - 1] = text
            
            // 설정한 텍스트 초기화
            selCatTextArray.removeLast()
            setIsNeedToDeleteCatTrue()
            print(isCatNameAppending)
            print("저장 후 selCatNameArray: \(self.selCatNameArray)")
            
            // 설정한 텍스트 -> 선택해주세요로 바꾸기 설정
            isNeedToFixText = true
        }
        // 카테고리 네임 변경(Text 설정 전)
        else {
            self.selCatNameArray[selCatNameArray.count - 1] = text
            setIsNeedToDeleteCatTrue()
            print(isCatNameAppending)
            print("저장 후 selCatNameArray: \(self.selCatNameArray)")
        }
    }
    
    
    // 코어 데이터에 저장할 텍스트 카테고리 배열 세팅
    func setCategoryTextArray(text: String) {
        // 카테고리 텍스트 수정
        if selCatNameArray.count == selCatTextArray.count {
            self.selCatTextArray[selCatTextArray.count - 1] = text
            print("저장 후 selCatTextArray: \(self.selCatTextArray)")
            setIsNeedToDeleteCatFalse()
        // 카테고리 텍스트  추가
        } else {
            self.selCatTextArray.append(text)
            print("저장 후 selCatTextArray: \(self.selCatTextArray)")
            setIsNeedToDeleteCatFalse()
        }
    }
    
    // 코어 데이터에 저장할 카테고리 배열 세팅
    func setCategoryNameArray(text: String, category: String) {
        // 카테고리 텍스트 수정 // 카테고리 텍스트 추가
        if category == "Name" {
            self.selCatNameArray.append(text)
            print("저장 후 selCatNameArray: \(self.selCatNameArray)")
        } else if selCatNameArray.count == selCatTextArray.count {
            self.selCatTextArray[selCatTextArray.count - 1] = text
            print("저장 후 selCatTextArray: \(self.selCatTextArray)")
        // 카테고리 텍스트  추가
        } else {
            self.selCatTextArray.append(text)
            print("저장 후 selCatTextArray: \(self.selCatTextArray)")
        }
       
    }
    
    // 코어 데이터에 저장할 resData 배열 세팅
    func setResData(resData: Document) {
        print("setResData")
        print(resData.phone ?? "")
        print(resData.placeName ?? "")
        print(resData.placeURL ?? "")
        print(resData.roadAddress ?? "")
        print(resData.address ?? "")
        print(resData.group ?? "")
        selResData = resData
    }
    
    // 선택된 카테고리 세팅
    func setIsCatSelected() {
        isCatSelected.toggle()
    }
    
    func setIsCatSelectedTrue() {
        isCatSelected = true
    }
    
    func setIsCatSelectedFalse() {
        isCatSelected = false
    }
    
    // 선택된 카테고리 리턴
    func getIsCatSelected() -> Bool {
        return isCatSelected
    }
    
    // 후보 식당 숫자 세팅
    func setResListNum(resNum: Int) {
        resListNum = resNum
    }
    
    // 후보 식당 숫자 리턴
    func getResListNum() -> Int {
        return resListNum
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
    
    
    // category 모델의 (행렬 == categoryCnt -1)번째 데이터 삭제해주기.
    func handleMinusAction() {
        // + 다음 바로 - 버튼을 누른 경우
        if isNeedToDeleteCat {
            setIsNeedToDeleteCatTrue()
            return
        }
        // 둘 다 입력한 상태에서 삭제
        else if selCatNameArray.count == selCatTextArray.count {
            selCatNameArray.removeLast()
            selCatTextArray.removeLast()
            print("selCatNameArray: \(selCatNameArray)")
            print("selCatTextArray: \(selCatTextArray)")
            setIsNameAppendingFalse()
            setIsCatSelectedTrue()
        // 하나만 입력한 상태에서 삭제
        } else {
            selCatNameArray.removeLast()
            print("selCatNameArray: \(selCatNameArray)")
            print("selCatTextArray: \(selCatTextArray)")
            setIsNameAppendingFalse()
            setIsCatSelectedTrue()
        }
    }
    
    // MARK: - Common
    func setIsNameAppendingTrue() {
        isCatNameAppending = true
    }
    
    func setIsNameAppendingFalse() {
        isCatNameAppending = false
    }
    
    func setIsNeedToDeleteCatTrue() {
        isNeedToDeleteCat = true
    }
    
    func setIsNeedToDeleteCatFalse() {
        isNeedToDeleteCat = false
    }
    
    func getIsNeedToFix() -> Bool {
        return isNeedToFixText
    }
}
