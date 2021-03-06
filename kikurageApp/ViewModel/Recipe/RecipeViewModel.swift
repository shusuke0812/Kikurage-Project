//
//  RecipeViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol RecipeViewModelDelegate: AnyObject {
    /// きくらげ料理記録の取得に成功した
    func didSuccessGetRecipes()
    /// きくらげ料理記録の取得に失敗した
    func didFailedGetRecipes(errorMessage: String)
}

class RecipeViewModel: NSObject {
    /// 料理記録リポジトリ
    private let recipeRepository: RecipeRepositoryProtocol
    /// デリゲート
    internal weak var delegate: RecipeViewModelDelegate?
    ///　きくらげ料理データ
    var recipes: [(recipe: KikurageRecipe, documentId: String)] = []
    /// セクション数
    private let sectionNumber = 1

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
    }
}
// MARK: - Firebase Firestore Method
extension RecipeViewModel {
    /// きくらげ料理記録を読み込む
    func loadRecipes(kikurageUserId: String) {
        self.recipeRepository.getRecipes(kikurageUserId: kikurageUserId) { [weak self] response in
            switch response {
            case .success(let recipes):
                self?.recipes = recipes
                self?.delegate?.didSuccessGetRecipes()
            case .failure(let error):
                self?.delegate?.didFailedGetRecipes(errorMessage: "\(error)")
            }
        }
    }
}
// MARK: - UITableView DataSource
extension RecipeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sectionNumber
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.recipeTableViewCell, for: indexPath)! // swiftlint:disable:this force_cast
        cell.setUI(recipe: self.recipes[indexPath.row].recipe)
        return cell
    }
}
