//
//  ViewController.swift
//  Waterfall CollectionView
//
//  Created by Alley Pereira on 22/07/21.
//

import UIKit
import CHTCollectionViewWaterfallLayout

// https://dog.ceo/api/breeds/image/random/50

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {

    private var model: Model?

    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.columnCount = 2
        layout.itemRenderDirection = .leftToRight
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collection
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func fetchData() {
        APICaller.shared.getData { result in
            DispatchQueue.main.async {
                self.model = result
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.message.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.identifier,
                for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }


        let url = URL(string: (self.model!.message[indexPath.row]))

        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                cell.configure(image: UIImage(data: data!))
            }
        }).resume()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 200...400))
    }

}
