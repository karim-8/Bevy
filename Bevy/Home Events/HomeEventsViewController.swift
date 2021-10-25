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
    var viewModel: HomeEventsViewModel?
    
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var menuTitles: [EventType]?
    var eventDetails: [EventData]?
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 3
    var eventTypeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionItems()
        setupNavigationBar()
        setupTableViewItems()
        setViewSwipe()
        setCollectionIndicator()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
    }
    
    func setupCollectionItems() {
        self.menuCollection.reloadData()
        self.menuCollection.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    func setupTableViewItems() {
        countriesTable.separatorColor = .clear
        countriesTable.reloadData()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Events"
        navigationController?.navigationBar.backgroundColor = .gray
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    func setCollectionIndicator() {
        indicatorView.backgroundColor = .white
        indicatorView.frame = CGRect(x: menuCollection.bounds.minX, y: menuCollection.bounds.maxY - indicatorHeight, width: menuCollection.bounds.width / CGFloat(menuTitles!.count), height: indicatorHeight)
        menuCollection.addSubview(indicatorView)
    }
    
    func setViewSwipe() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            if selectedIndex < menuTitles!.count - 1 {
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
    
    
    func refreshContent(index: Int){
        viewModel?.getEventsData(linkType: .Eventdetails, pageIndex: 1, type: eventTypeName)

        
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            var updatedEvents = self.viewModel?.getEventDetails()
                self.eventDetails?.removeAll()
                self.eventDetails = updatedEvents
                updatedEvents?.removeAll()
            
            self.stopLoader(loader: loader)
            let desiredX = (self.menuCollection.bounds.width / CGFloat((self.menuTitles?.count)!)) * CGFloat(self.selectedIndex)
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollection.bounds.maxY - self.indicatorHeight, width: self.menuCollection.bounds.width / CGFloat((self.menuTitles?.count)!), height: self.indicatorHeight)
            }
        }
        self.countriesTable.reloadData()

    }
}

//MARK:- TABLE VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDetails!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = eventDetails?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        var eventDetailsViewController = EventDetailsViewController()
        eventDetailsViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? EventDetailsViewController)!
        eventDetailsViewController.detailsItems = eventDetails?[indexPath.row]
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}

//MARK:- COLLECTION VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (menuTitles?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.setupCell(text: (menuTitles?[indexPath.item].name!)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / CGFloat((menuTitles?.count)!), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        eventTypeName = (menuTitles?[indexPath.row].name!)!
        refreshContent(index: indexPath.row)
    }
}


