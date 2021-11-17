//
//  HomeEventsViewController+MenuBar.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

//MARK:- MENU ITEMS COLLECTION VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCollectionViewCell", for: indexPath) as? MenuBarCollectionViewCell
        cell?.setupCell(text: menuTitles?[indexPath.item].name ?? "")
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.view.frame.width / CGFloat(menuTitles?.count ?? 0), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedIndex = indexPath.item
        eventTypeName = menuTitles?[indexPath.row].name ?? ""
        refreshContent(index: indexPath.row)
    }
}
