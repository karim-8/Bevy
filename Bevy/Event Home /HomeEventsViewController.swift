//
//  HomeEventsViewController.swift
//  Bevy
//
//  Created by KarimAhmed on 22/10/2021.
//

import UIKit

class HomeEventsViewController: UIViewController {
    
    
    @IBOutlet weak var countriesTable: UITableView!
    @IBOutlet weak var menuCollection: UICollectionView!
    let searchController = UISearchController()
    var viewModel: HomeEventsViewModel?
    let refreshControl = UIRefreshControl()
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var menuTitles: [EventType]?
    var eventDetails: [EventData]?
    var filteredEvent = [EventData]()
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 3
    var eventTypeName = ""
    var currentPageIndex = 0
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionItems()
        setupNavigationBar()
        setupTableViewCell()
        setupCollectionViewCell()
        setViewSwipe()
        setCollectionIndicator()
        initSearchController()
        initRefreshController()
    }
    
    //MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
    }
    
    //MARK:- SETUP COLLECTION VIEW
    func setupCollectionItems() {
        self.menuCollection.reloadData()
        self.menuCollection.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    //MARK:- SETUP TABLE VIEW CELL
    func setupTableViewCell() {
        let nib = UINib(nibName: "EventHomeTableViewCell", bundle: nil)
        countriesTable.register(nib, forCellReuseIdentifier: "eventCell")
        countriesTable.separatorColor = .clear
        countriesTable.reloadData()
    }
    
    //MARK:- SETUP COLLECTION VIEW CELL
    func setupCollectionViewCell() {
        let nib = UINib(nibName: "MenuBarCollectionViewCell", bundle: nil)
        menuCollection.register(nib, forCellWithReuseIdentifier: "MenuBarCollectionViewCell")
        menuCollection.reloadData()

    }
    
    //MARK:- SETUP NAVIGATION BAR
    func setupNavigationBar() {
        navigationItem.title = "Events"
        navigationController?.navigationBar.backgroundColor = .gray
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK:- INIT SEARCH CONTROLLER
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = ["All","Home","Away","sddd"]
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK:- INIT REFRESH CONTROLLER
    func initRefreshController() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        countriesTable.refreshControl = refreshControl
    }
    
    //MARK:- Refresh PULL BUTTON
    @objc func pullToRefresh() {
        countriesTable.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- SET COLLECTION INDICATOR
    func setCollectionIndicator() {
        indicatorView.backgroundColor = .lightGray
        if let titles = menuTitles {
            indicatorView.frame = CGRect(x: menuCollection.bounds.minX, y: menuCollection.bounds.maxY - indicatorHeight, width: menuCollection.bounds.width / CGFloat(titles.count), height: indicatorHeight)
        }
        menuCollection.addSubview(indicatorView)
    }
    
    //MARK:- SET SWIPE GESTURE
    func setViewSwipe() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    //MARK:- SWIPE ACTION
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            if let titles = menuTitles {
                if selectedIndex < titles.count - 1 {
                    selectedIndex += 1
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
            selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
            menuCollection.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
            refreshContent(index: 1)
        }
    }
    
    //MARK:- REFRESH CONTENT
    func refreshContent(index: Int){
        viewModel?.getEventsData(linkType: .Eventdetails, pageIndex: 0, type: eventTypeName)
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            var updatedEvents = self.viewModel?.getEventDetails()
            self.eventDetails?.removeAll()
            self.eventDetails = updatedEvents
            updatedEvents?.removeAll()
            self.countriesTable.reloadData()
            self.currentPageIndex = 0
            self.stopLoader(loader: loader)
            
            let desiredX = (self.menuCollection.bounds.width / CGFloat(self.menuTitles?.count ?? 0)) * CGFloat(self.selectedIndex)
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollection.bounds.maxY - self.indicatorHeight, width: self.menuCollection.bounds.width / CGFloat(self.menuTitles?.count ?? 0), height: self.indicatorHeight)
            }
        }
        self.countriesTable.reloadData()
    }
    
    //MARK:- DEINIT
    deinit {
        viewModel = nil
    }
}
