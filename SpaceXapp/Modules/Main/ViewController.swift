//
//  ViewController.swift
//  SpaceX
//
//  Created by vojta on 15.02.2022.
//
import UIKit
import Combine

enum Section {
    case main
}

class ViewController: UIViewController {
    
    //MARK: - ViewModel
    let viewModel: MainViewModel
    var subscriptons: Set<AnyCancellable> = []
    
    //MARK: -  UI elements
    lazy var mainTableView: UITableView = {
        let collectionView = UITableView(frame: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "search for flight"
        sc.searchBar.autocapitalizationType = .none
        return sc
    }()
    
    init(viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? MainViewModel else { fatalError() }
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMainTableVeiw()
        
        //navigationBar setup
        setupNavBar()
        
        navigationItem.searchController = searchController
        
        let dateFilterItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(sortBy))
        navigationItem.leftBarButtonItem = dateFilterItem
        
        viewModel.$filterByImage
            .sink { filter in
                let val = filter ? ".fill" : ""
                let photoFilterItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle\(val)"),
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(self.filterByPhoto))
                self.navigationItem.rightBarButtonItem = photoFilterItem
                self.viewModel.updateData(sort: true)
            }
            .store(in: &subscriptons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
    }
    
    //MARK: - Navbar button methods
    @objc func filterByPhoto() {
        let ac = UIAlertController(title: "Filter flights", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "show all", style: .default){[weak self] _ in
            self?.viewModel.filterByImage = false
            self?.viewModel.updateData(sort: true)
        })
        
        ac.addAction(UIAlertAction(title: "show only flights with photo", style: .default) {[weak self] _ in
            self?.viewModel.filterByImage = true
            self?.viewModel.updateData(sort: true)
        })
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    //sorts the flights by date...
    @objc func sortBy() {
        let by = viewModel.sorted == .orderedDescending ? ComparisonResult.orderedAscending : .orderedDescending
        
        let image = viewModel.sorted == .orderedDescending ? "up" : "down"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "chevron.\(image).circle")
        
        viewModel.sorted = by
        
        viewModel.updateData(sort: true)
    }
}

//MARK: - refresh controll
extension ViewController {
    
    func addRefreshGesture() {
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self,
                                                action: #selector(handleRefresh),
                                                for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        viewModel.handleRefresh {
            DispatchQueue.main.async { [weak self] in
                self?.mainTableView.refreshControl?.endRefreshing()
            }
        }
    }
}

//MARK: - Configuring MaincollectionViews
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flight = viewModel.searchCollectionOfFlights[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let hasCrew = !flight.crew.isEmpty
        
        let vm = DetailViewModel()
        let vc = DetailViewController(flight: flight, hasCrew: hasCrew, viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
}

extension ViewController {
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        addRefreshGesture()
        navigationItem.title = "SpaceX"
    }
}

extension ViewController {
    
    func setupMainTableVeiw() {
        view.addSubview(mainTableView)
        mainTableView.delegate = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.rowHeight = view.bounds.width
        
        mainTableView.prefetchDataSource = self
        
        
        configureDatasource()
        viewModel.setInitialData()
        mainTableView.sameConstrainghts(as: view)
        
    }
    
    private func configureDatasource() {
        viewModel.dataSource = .init(tableView: mainTableView,
                                     cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath) as! MainTableViewCell
            
            guard self.viewModel.searchCollectionOfFlights.count > indexPath.row else { return cell }
            
            let flight = self.viewModel.searchCollectionOfFlights[indexPath.row]
            //checking if the flight object has images in it
            //if not than adding default image with SpaceX logo
            if let link = flight.links.images.original.first {
                //checking if we had already downloaded this image
                if let image = ImageStorage.shared.getImage(for: link) {
                    cell.mainImageView.image = image
                }else{
                    //sets placeholder as current image of the cell
                    cell.mainImageView.image = UIImage(named: "placeholder")!
                    self.viewModel.downloadImage(from: link) { [weak self] _ in
                        self?.viewModel.setItemNeedsUpdate(id: flight.id)
                    }
                }
            }else{
                let size = UIScreen.main.bounds.size
                
                let image = UIImage(named: "SpaceXLogo")!
                    .scalePreservingAspectRatio(targetSize: size)
                cell.mainImageView.image = image
            }
            
            cell.nameLabel.text = flight.name
            
            cell.dateLabel.text = flight.formatedDate
            return cell
        })
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let flight = self.viewModel.searchCollectionOfFlights[indexPath.row]
            //checking if the flight object has images in it
            //if not than adding default image with SpaceX logo
            if let link = flight.links.images.original.first {
                //checking if we had already downloaded this image
                if nil == ImageStorage.shared.getImage(for: link) {
                    //sets placeholder as current image of the cell
                    self.viewModel.downloadImage(from: link) { [weak self] _ in
                        self?.viewModel.setItemNeedsUpdate(id: flight.id)
                    }
                }
            }
        }
    }
}

//MARK: - Searchbar related methods
extension ViewController: UISearchControllerDelegate,
                          UISearchResultsUpdating,
                          UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        mainTableView.refreshControl = nil
        
        guard let text = searchController.searchBar.text else {
            return
        }
        //checking if text contains some letters
        guard text.replacingOccurrences(of: " ", with: "") != "" else {
            viewModel.updateData(sort: true)
            return
        }
        
        self.viewModel.search(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.updateData(sort: true)
        addRefreshGesture()
    }
}
