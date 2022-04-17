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

final class ViewController: UIViewController {
    
    //MARK: - ViewModel
    let viewModel: MainViewModelProtocol
    var subscriptons: Set<AnyCancellable> = []
    let presenter: MainPresenter
    
    //MARK: -  UI elements
    private lazy var mainCollectionView: MainCollectionView = {
        let collectionView = MainCollectionView()
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
    
    init(viewModel: MainViewModelProtocol, presenter: BasePresenter) {
        guard let presenter = presenter as? MainPresenter else { fatalError() }
        
        self.viewModel = viewModel
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.parent = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMainCollectionView()
        
        //navigationBar setup
        setupNavBar()
        
        navigationItem.searchController = searchController
        
        let dateFilterItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(sortBy))
        navigationItem.leftBarButtonItem = dateFilterItem
        
        viewModel.filterByImagePublisher
            .sink { [weak self] filter in
                guard let self = self else { return }
                
                let val = filter ? ".fill" : ""
                let imageName = "line.3.horizontal.decrease.circle\(val)"
                let photoFilterItem = UIBarButtonItem(image: UIImage(systemName: imageName),
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
    @objc private
    func filterByPhoto() {
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
    @objc private
    func sortBy() {
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
        mainCollectionView.collectionView.refreshControl = UIRefreshControl()
        mainCollectionView.collectionView.refreshControl?.addTarget(self,
                                                action: #selector(handleRefresh),
                                                for: .valueChanged)
    }
    
    @objc private
    func handleRefresh() {
        viewModel.handleRefresh {
            DispatchQueue.main.async { [weak self] in
                self?.mainCollectionView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

//MARK: - Configuring MaincollectionViews
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let flight = viewModel.searchCollectionOfFlights[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell else { return }
        
        let imageFrame = cell.convert(cell.mainImageView.frame, to: view)
        let fromFrame = collectionView.convert(cell.frame, to: collectionView.superview)
        
        presenter.fromFrame = fromFrame
        presenter.imageFrame = imageFrame
        
        presenter.present(data: flight)
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
    func setupMainCollectionView() {
        view.addSubview(mainCollectionView)
        mainCollectionView.collectionView.delegate = self
        
        mainCollectionView.configure(viewModel: viewModel)
        
        viewModel.setInitialData()
        mainCollectionView.sameConstrainghts(as: view)
    }
}

//MARK: - Searchbar related methods
extension ViewController: UISearchControllerDelegate,
                          UISearchResultsUpdating,
                          UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        mainCollectionView.collectionView.refreshControl = nil
        
        guard let text = searchController.searchBar.text else {
            return
        }
        //added delay for typing to fast - the app was crashing before...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            guard text == searchController.searchBar.text else {
                return
            }
            //checking if text contains some letters
            guard text.replacingOccurrences(of: " ", with: "") != "" else {
                self.viewModel.updateData(sort: true)
                return
            }
            self.viewModel.search(text: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.updateData(sort: true)
        addRefreshGesture()
    }
}
