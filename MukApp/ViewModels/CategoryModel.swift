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
    
    // MARK: - Common
    // 선택된 카테고리 Name 배열
    private var selCatNameArray: [String] = [""]
    
    // Get -> 선택된 카테고리 Name
    func getSelCatNameArray () -> ([String]) {
        return selCatNameArray
    }
    
    // 선택된 카테고리 Text 배열
    private var selCatTextArray: [String] = [""]
    
    // Get -> 선택된 카테고리 Text
    func getSelCatTextArray () -> ([String]) {
        return selCatTextArray
    }
    
    // MARK: - MainViewController
    // 화면 이동 시 초기화해야할 데이터
    // selCatNameArray
    // selCatTextArray
    // resListNum
    // nextCatNameArray
    
    // 룰렛을 돌릴 때 나올 후보 식당 수
    private var resListNum = 0
    
    // 다음 Category Name 후보
    private var nextCatNameArray: [String] = []
    
    // 플러스 버튼이 눌렸을 때 -> 새로운 카테고리 설정(New)
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

    // +버튼을 눌렀을 때 Set -> Next Category Name)
    func setNextNameArray(catNameArray: [String]) {
        nextCatNameArray = catNameArray
    }
    
    // Get -> Next Category Name
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

    // 후보 식당 숫자 세팅 **** 코드 필요한지 체크하기 ****
    func setResListNum(resNum: Int) {
        resListNum = resNum
    }
    
    // 후보 식당 숫자 리턴
    func getResListNum() -> Int {
        return resListNum
    }
 
    // MARK: - RestaurantViewController
    
  
    
    
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
    
    // resData 배열 리턴
    func getSelResData () -> (Document) {
        return selResData!
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
}
