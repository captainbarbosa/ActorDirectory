//
//  ViewController.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit

class ViewController: UIViewController {

    var actors = [Actor]()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: "actorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.2)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarAppearance()

        showLoadingIndicator()

        /**
         Kick off request to specified endpoint. In a successful case,
         the layout will continue to be set up. In a failure case,
         we display an error view controller instead.
         
         By default, this sample application uses a staging URL that points to
         a local file in the ap bundle. To change this to a real URL,
         use `RoutingPath.actorsProduction`.
         */
        NetworkService.executeRequest(for: RoutingPath.actorsStaging) { [weak self] ( result ) in
            switch result {
            case .success(let directory):
                DispatchQueue.main.async {
                    self?.actors = directory.actors
                    self?.setupLayout()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorIndicator(error: error)
                }
            }
        }
    }

    func setupLayout() {
        view.addSubview(self.collectionView)
        collectionView.reloadData()
        activateConstraints()
        hideLoadingIndicator()
    }

    /**
     Set up the appearance of the navigation var for this view,
     ensuring that we use system colors to be compatible with light
     and dark appearances.
     */
    func setupNavigationBarAppearance() {
        self.title = "Actors"
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemBackground]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemIndigo]
    }

    /**
     Make the collection view fit within the safe area layout guide,
     so content doesn't bleed under devices that have a notch.
     */
    func activateConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView delegate methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as! ActorCollectionViewCell

        let actor = actors[indexPath.row]

        cell.profileImage.loadImage(from: actor.photo)
        cell.nameLabel.text = actor.fullName
        cell.emailLabel.text = actor.email
        cell.phoneLabel.text = actor.phoneNumber
        cell.bioLabel.text = "Known for: \(actor.knownFor)"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 260)
    }
}

// MARK: - Handling loading events
extension ViewController: Loadable {
    func showErrorIndicator(error: Error) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(ErrorViewController(for: error), animated: false)
    }
    
    func showLoadingIndicator() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(LoadingViewController(), animated: false)
    }

    func hideLoadingIndicator() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popToRootViewController(animated: false)
    }
}

