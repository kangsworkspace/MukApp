//
//  CategoryModel.swift
//  MukApp
//
//  Created by Kang on 11/12/23.
//

import UIKit

enum CellState {
    case new
    case set
}


final class CategoryModel {
    
    // MARK: - 싱글톤
    static let shared = CategoryModel()
    private init() {}
    
    // MARK: - MainViewController
    
    // 선택된 카테고리 Name 배열
    private var selCatNameArray: [String] = [""]
    // 선택된 카테고리 Text 배열
    private var selCatTextArray: [String] = [""]
    // 룰렛을 돌릴 때 나올 후보 식당 수
    private var resListNum = 0
    // 다음 Category Name 후보
    private var nextCatNameArray: [String] = []
    
    // 플러스 버튼이 눌렸을 때 -> New
    func plusButtonTapped() -> Bool {
        // cellState 확인
        let cellState = checkCellState()
        
        // cellState가 set이면 진행 -> true 리턴
        if cellState == CellState.set {
            addNewCategory()
            print("빈 배열 생성")
            print(selCatNameArray)
            print(selCatTextArray)
            return true
        }
        // cellState가 set이 아니면 진행 X -> false 리턴
        else {
            return false
        }
    }
    
    // 마이너스 버튼이 눌렸을 때
    func minusButtonTapped() {
        // 마지막 CategoryArray 삭제
        deleteLastCat()
    }
    
    // 코어 데이터에 저장할 카테고리 네임 배열 세팅
    func setCategoryNameArray(text: String) {
        self.selCatNameArray[selCatNameArray.count - 1] = text
        print("저장 후 selCatNameArray: \(self.selCatNameArray)")
    }
    
    // 코어 데이터에 저장할 카테고리 텍스트 배열 세팅
    func setCategoryTextArray(text: String) {
        self.selCatTextArray[selCatTextArray.count - 1] = text
        print("저장 후 selCatTextArray: \(self.selCatTextArray)")
    }

    // set Next Category Name
    func setNextNameArray(catNameArray: [String]) {
        nextCatNameArray = catNameArray
    }
    
    // get Next Category Name
    func getNextNameArray() -> [String] {
        return nextCatNameArray
    }
    
    // 마지막 스트링이 모두 ""이 아닌지 체크
    func checkLastArrayNew() -> Bool {
        // 마지막 스트링이 중 하나가 "" 이면 True
        if selCatNameArray.last == "" || selCatTextArray.last == "" {
            return true
            // 마지막 스트링이 모두 "" 이 아니면 False
        } else {
            return false
        }
    }
    
    // 마지막 스트링에 "" 넣기
    func addNewCategory() {
        selCatNameArray.append("")
        selCatTextArray.append("")
    }
    
    // 마지막 스트링 삭제하기
    func deleteLastCat() {
        selCatNameArray.removeLast()
        selCatTextArray.removeLast()
    }
    
    // 셀 State 확인
    func checkCellState() -> CellState {
        if checkLastArrayNew() {
            return CellState.new
        } else {
            return CellState.set
        }
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
    
    // MARK: - Common

    
    
    // MARK: - 기타
    
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
    
    // 저장할 때 사용?
    private var selResData: Document?
    
    // *** 삭제할 코드 ***
    private var isCatSelected = false
    private var isCatNameAppending = true
    private var isNeedToFixText = false
    private var isNeedToDeleteCat = false
    //
    
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
    
    // *** 삭제할 코드 ***
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
    
    // *** 삭제할 코드
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
