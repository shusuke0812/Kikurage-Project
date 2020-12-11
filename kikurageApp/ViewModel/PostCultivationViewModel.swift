//
//  PostCultivationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationViewModelDelegate: class {
    /// 栽培記録の投稿に成功した
    func didSuccessPostCultivation()
    /// 栽培記録の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostCultivation(errorMessage: String)
    /// 栽培記録画像の投稿に成功した
    func didSuccessPostCultivationImages()
    /// 栽培記録画像の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostCultivationImages(errorMessage: String)
}
class PostCultivationViewModel {
    /// 栽培記録リポジトリ
    private let cultivationRepository: CultivationRepositoryProtocol
    /// デリゲート
    internal weak var delegate: PostCultivationViewModelDelegate?
    /// 栽培記録
    var cultivation: KikurageCultivation
    /// 栽培記録のFirestore Document ID
    var postedCultivationDocumentId: String?
    
    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
        self.cultivation = KikurageCultivation()
    }
}
// MARK: - Firebase Firestore Method
extension PostCultivationViewModel {
    func postCultivation(kikurageUserId: String) {
        self.cultivationRepository
            .postCultivation(kikurageUserId: kikurageUserId, kikurageCultivation: self.cultivation, completion: { response in
                switch response {
                case .success(let documentReference):
                    print(documentReference)
                    self.postedCultivationDocumentId = documentReference.documentID
                    self.delegate?.didSuccessPostCultivation()
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedPostCultivation(errorMessage: "DEBUG: 栽培記録データの投稿に失敗しました")
                }
            })
    }
}
// MARK: - Firebase Storage Method
extension PostCultivationViewModel {
    func postCultivationImages(kikurageUserId: String, imageData: [Data?], firestoreDocumentId: String) {
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserId)/\(Constants.FirestoreCollectionName.cultivations)/\(firestoreDocumentId)/images/"
        self.cultivationRepository.postCultivationImages(imageData: imageData, imageStoragePath: imageStoragePath, completion: { response in
            switch response {
            case .success(let successMessage):
                print("DEBUG: \(successMessage)")
                self.delegate?.didSuccessPostCultivationImages()
            case .failure(let error):
                print("DEBUG: \(error)")
                self.delegate?.didFailedPostCultivationImages(errorMessage: "栽培記録画像の保存に失敗しました")
            }
        })
    }
}
