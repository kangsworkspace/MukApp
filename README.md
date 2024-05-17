### 사용한 기술 
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white"> <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=Swift&logoColor=white">
### 개발 및 테스트 환경 버전
- Xcode 15.2
- Swift 5.10
- iOS 17.0+
- iPhone 12
- Portrait Only
<br/>

### 앱 소개
### <뭐 먹지? 태그로 관리하는 맛집 & 룰렛>
<img src="https://github.com/kangsworkspace/MukAppOfficial/assets/141600830/b8f26d2d-935a-42aa-9605-8b9751426f0c"  width="900" height="450"/>
<br/>

자주 가는 식당들을 **특정 키워드와 함께 등록**해두고 ex) 지역 - 수원역, 종류 - 양식
<br/>
고민될 때 **랜덤으로 뽑아주는 앱**입니다.

<br/>

### 편하게 맛집을 추가하기 위한 검색기능

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/10e99a6d-3b7b-450b-9d36-2edf5a1c57c1"  width="300" height="650"/>
<br/>

### 맛집을 태그와 함께 저장/수정 가능  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/dbd3bf09-6011-4013-9519-cad105fa9fdc"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/c1c55af3-1743-4dd3-b832-8dd247a82f1c"  width="300" height="650"/> 
<br/>

### 태그를 이용하여 랜덤으로 저장한 맛집을 룰렛 돌리기  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/fd75c6d1-d88e-47d4-86f7-421077b50768"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/b62af681-6c64-45e9-a4f7-918c086e7a2c"  width="300" height="650"/>  
<br/>

### 이미 추가했던 태그는 자동으로 목록에 표시 

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/8d60557a-647e-4cdf-9149-a37d26e51a6d"  width="300" height="650"/>
<br/>

### 이전 조건에 해당되는 식당의 태그만 보여주기  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/bc79d597-1502-45af-b6e9-256167f04814"  width="300" height="650"/>    
<br/>


### 이미지 변경

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/c0403fc4-468c-49fc-b14f-f4d0790b1882"  width="300" height="650"/> 
<br/>

### 링크를 눌러 페이지로 이동하기
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/6aa64849-c6a6-49b7-9a52-5a1e838d3fa4"  width="300" height="650"/>  
<br/>
<br/>
<br/>

## 학습한 내용들     
### 코어데이터 - Relationships  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/8d60557a-647e-4cdf-9149-a37d26e51a6d"  width="300" height="650"/> <img src="https://github.com/kangsworkspace/DataStorage/files/13997469/dataS.pdf"  width="300" height="650"/>

프로젝트에서 맛집을 저장할 때 그림처럼 태그를 중분류 - 소분류로 나누어 저장합니다.  
그래서 데이터 구조는 하나의 식당에 여러개의 태그가 포함되는 형식으로 처리되어야 했습니다.  
<br/>
아래의 방법으로 `RestaurantData entity`가 다수의 `CategoryData entity`를 가지도록 하여  
태그의 개수를 유동적으로 가질 수 있도록 처리했습니다.  
<br/>
1. 식당 데이터를 저장하는 `RestaurantData entity`, 태그 정보를 관리하는 `CategoryData entity`로 `entity`를 분리하였습니다.
2. `RestaurantData entity`와 `CategoryData entity`에 `Relationships`의 타입을 To Many로 설정하였습니다.  
<br/>
<br/>

### 기본 이미지가 아닌 경우에만 경로 생성 및 데이터 저장

데이터를 아끼기 위해 앨범의 이미지를 저장한 경우에만  
파일 매니저를 통해 이미지를 저장하도록 하였습니다.  

![1111](https://github.com/kangsworkspace/DataStorage/assets/141600830/b92fba2e-2d9c-4629-b333-767a6db2fda9)  
   
**맛집 데이터를 저장하는 경우입니다.**   
```swift
 // 코어 데이터에 맛집 추가
    func addResToCoreData(restaurantData: Document, catNameArray: [String], catTextArray: [String], resImage: UIImage) {
        
        // 데이터 할당
        let address = restaurantData.address ?? ""
        let group = restaurantData.group ?? ""
        
        // 번호 에러처리
        let phone = if restaurantData.phone != "" {
            restaurantData.phone
        } else {
            "번호 정보 없음"
        }
        
        let placeName = restaurantData.placeName ?? ""
        let roadAddress = restaurantData.roadAddress ?? ""
        let placeURL = restaurantData.placeURL ?? ""
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString: String = formatter.string(from: date)
        
        // 기본 이미지가 아니면 이미지 파일 생성
        if !checkCommonImage(image: resImage) {
            imageManager.createFile(urlPath: dateString, image: resImage)
        }
        
        guard catNameArray.count == catTextArray.count else {
            fatalError("The length of catNameArray and catTextArray must be the same.")
        }
        
        coreDataManager.saveResToCoreData(address: address, group: group, phone: phone!, placeName: placeName, roadAddress: roadAddress, placeURL: placeURL, date: date, imagePath: dateString, categoryNameArray: catNameArray, categoryTextArray: catTextArray) {
        }
    }
```
 
!checkCommonImage(image: resImage) 함수를 통해 전달받은 이미지가 에셋에 있는 기본 이미지인지 확인합니다.  
아래는 checkCommonImage(image: UIImage) 함수의 내용입니다.   

```swift
private func checkCommonImage(image: UIImage) -> Bool {
        
        //  13개
        switch image {
        case let image where image == RestaurantImages.korean :
            return true
        case let image where image == RestaurantImages.chicken :
            return true
        case let image where image == RestaurantImages.bakery :
            return true
        case let image where image == RestaurantImages.dessertCafe :
            return true
        default:
            return false
        }
    }
 ```
   
여기서 false가 리턴된다면 앨범의 이미지를 따로 저장한 것이라고 볼 수 있게 됩니다.   
그러면 파일 매니저를 통해 이미지 파일을 저장하고 이 때 파일의 경로가 생성됩니다.  
 
반대로 true가 리턴된다면 기본 이미지를 저장한 것이라고 볼 수 있게 됩니다.  
파일의 경로가 생성되지 않습니다.   
 
 
**맛집 데이터를 불러오는 경우**   
1.앨범의 이미지를 저장한 경우와 2.에셋에 있는 기본 이미지로 저장한 경우로 나누었습니다.   
   
파일 매니저에서 데이터를 불러온 결과가 UIImage(systemName: "person") 일 때는 파일 경로가 없고   
반대로 불러온 결과과 UIImage(systemName: "person")가 아닐 경우에는   
파일 경로와 해당 경로에 저장한 이미지가 있다는 것이기 때문에 리턴된 이미지를 사용하도록 하였습니다.  
```swift
  resImageView.image = if imageManager.readFile(urlPath: imagePath) != UIImage(systemName: "person") {
                    imageManager.readFile(urlPath: imagePath)
                } else {
                	// 맛집의 group에 따라 에셋 이미지 할당
                	if let resGroup = restaurantCoreData.group {
                        switch resGroup {
                        case let groupString where groupString.contains("한식"):
                            RestaurantImages.korean
                        case let groupString where groupString.contains("치킨"):
                            RestaurantImages.chicken
                        case let groupString where groupString.contains("제과"):
                            RestaurantImages.bakery
                        default:
                            RestaurantImages.restaurant
                        }
                }
  }
```

### 아쉬운 점  
1. 파일 매니저에서 데이터를 불러올 때 **리턴값을 옵셔널**로 하고 **옵셔널에 대한 에러 처리**를 하는게 훨씬 깔끔한 코드가 나올 것 같습니다.  
2. 이미지 경로를 초 단위의 Date 값으로 하였지만 UUID를 사용하는것이 더 좋을거 같습니다.  
<br/>

### WebView
초기에는 아래와 같이 사파리 앱이 풀스크린으로 나타났습니다.  
이 방식으로는 네비게이션 바의 작은 버튼을 눌러서 돌아가거나  
홈 화면으로 돌아가면서 앱을 다시 켜줘야해서 사용성이 떨어졌습니다.  
<br/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/1d7ed3e7-2e71-4326-9690-692ef37cfcb6"  width="300" height="650"/> <img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/38c2271e-7441-4417-bc08-157f63c8ae10"  width="300" height="650"/>   
<br/>

그래서 아래의 코드처럼 `SFSafariViewController`를 사용하여 WebView를 모달로 띄웠습니다.
```swift
func goWebPage(url: String, fromVC: UIViewController) {
    if url != "등록된 정보가 없습니다" {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        fromVC.present(safariViewController, animated: true)
    }
}
``` 
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/38eb23ff-e074-44b9-9521-08fec0fed093"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/9d682da0-197e-4e83-a672-949988672669"  width="300" height="650"/>   

# 추가 / 보완하면 좋을 내용들
### 디자인 패턴
- **문제점 1: 어중간한 디자인 패턴**      
  MVVM패턴을 적용하려고 하였으나 패턴에 대한 이해가 부족하여 어중간한 디자인 패턴이 되었습니다.
  
- **문제점 2: `View Model`을 분리 X**  
  공통적으로 사용할만한 코드가 많아서 일부러 View Model을 분리하지 않았습니다.
  하지만 프로젝트가 커지면서 코드가 복잡해졌고 갈수록 덩어리진 코드에 생산성이 떨어졌습니다.  

# 사용한 라이브러리  
[DropDown](https://github.com/AssistoLab/DropDown)
- 태그 버튼에 해당하는 UI에 사용되었습니다. 

[카카오 API Service](https://developers.kakao.com)
- 검색 기능에 사용되었습니다.  

[Alamofire](https://github.com/Alamofire/Alamofire)
- 네트워킹 기능에 사용되었습니다.  

# License  
Licensed under the [MIT](https://github.com/kangsworkspace/MukAppOfficial/blob/main/LICENSE) license.

