//
//  FileManager.swift
//  MukApp
//
//  Created by Kang on 12/27/23.
//

import UIKit

class ImageManager {
    
    // 싱글톤
    static let shared = ImageManager()
    
    private let fileManager = FileManager.default
    
    // 파일 매니저 생성(앱 초기화 때 한번만 실행)
    func makeDirectory() {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        
        // 디렉토리 생성
        do {
            // at: 경로 및 폴더명, 위에서 만든 URL 사용
            // withIntermediateDirectories: “중간 디렉토리들도 만들거니?” 라는 의미
            // attributes: 파일 접근 권한, 그룹 등등 폴더 속성 정의
            try fileManager.createDirectory(
                at: directoryPath,
                withIntermediateDirectories: false,
                attributes: [:]
            )
        } catch {
            print(error)
        }
        
        print("\(url.path)")
    }
    
    // MARK: - Creare: 파일 생성 && Update -> 동일 코드로 동작 시 파일 변경
    func createFile(urlPath: String, image: UIImage) {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지 처리
        guard let imageData = image.jpegData(compressionQuality: 1) else { return } // ?? image.pngData() else { return }
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        // 경로에 파일 만들기
        do {
            try imageData.write(to: imagePath)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Read: 파일 읽기
    func readFile(urlPath: String) -> UIImage {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "person")! }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 hi.txt 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        do {
            // URL을 불러와서 Data타입으로 초기화
            let imageData: Data = try Data(contentsOf: imagePath)
            // Data to UIImage
            let image: UIImage = UIImage(data: imageData) ?? UIImage(systemName: "person")!
            
            return image
        } catch {
            print(error)
            return UIImage(systemName: "person")!
        }
    }
    
    // MARK: - Delete: 파일 삭제
    func deleteFile(urlPath: String) {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 hi.txt 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        do {
            try fileManager.removeItem(at: imagePath)
        } catch {
            print(error)
        }
    }
}
