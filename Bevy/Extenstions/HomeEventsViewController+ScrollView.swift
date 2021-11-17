//
//  HomeEventsViewController+ScrollView.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

//MARK:- SCROLL VIEW DELEGTES METHODS
extension HomeEventsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentPage = viewModel?.getSwipigPage(countriesTable: countriesTable, scrollView: scrollView, currentPageIndex: currentPageIndex, eventType: eventTypeName)
        currentPageIndex = currentPage ?? 0
    }
}
