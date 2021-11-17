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
        setupTableViewItems()
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
    
    //MARK:- SETUP COLLECTION ITEMS
    func setupCollectionItems() {
        self.menuCollection.reloadData()
        self.menuCollection.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    //MARK:- SETUP TABLE VIEW ITEMS
    func setupTableViewItems() {
        let nib = UINib(nibName: "EventHomeTableViewCell", bundle: nil)
        countriesTable.register(nib, forCellReuseIdentifier: "eventCell")
        countriesTable.separatorColor = .clear
        countriesTable.reloadData()
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
        indicatorView.backgroundColor = .cyan
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

//MARK:- EVENTS TABLE VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredEvent.count
        }
        return eventDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventHomeTableViewCell
            cell?.eventName.text = filteredEvent[indexPath.row].name
            cell?.descriptionLabel.text = filteredEvent[indexPath.row].description
            cell?.eventdate.text = filteredEvent[indexPath.row].start_date ?? "12 April"
            cell?.configreImage(image: filteredEvent[indexPath.row].cover ?? "")
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventHomeTableViewCell
            cell?.eventName.text = eventDetails?[indexPath.row].name
            cell?.descriptionLabel.text = eventDetails?[indexPath.row].description
            cell?.eventdate.text = eventDetails?[indexPath.row].start_date ?? "12 April"
            cell?.configreImage(image: eventDetails?[indexPath.row].cover ?? "")
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var eventDetailsViewController = EventDetailsViewController()
        eventDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? EventDetailsViewController ?? EventDetailsViewController()
        
        if (searchController.isActive) {
            eventDetailsViewController.detailsItems = filteredEvent[indexPath.row]
        }else {
            eventDetailsViewController.detailsItems = eventDetails?[indexPath.row]
        }
        eventDetailsViewController.viewModel = EventDetailsViewModel()
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK:- MENU ITEMS COLLECTION VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCell
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

//MARK:- SCROLL VIEW DELEGTES METHODS
extension HomeEventsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentPage = viewModel?.getSwipigPage(countriesTable: countriesTable, scrollView: scrollView, currentPageIndex: currentPageIndex, eventType: eventTypeName)
        currentPageIndex = currentPage ?? 0
    }
}
