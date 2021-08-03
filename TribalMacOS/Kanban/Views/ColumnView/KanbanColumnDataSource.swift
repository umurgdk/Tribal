//
//  KanbanColumnDataSource.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit
import Nuke

class KanbanColumnDataSource: NSObject, NSCollectionViewDataSource {
    public var tasks: [Task] = [] {
        didSet { collectionView?.reloadSections([0]) }
    }
    
    public var collectionView: NSCollectionView?
    private var imageLoadingTasks: [URL: Any] = [:]
    
    // MARK: - Dependencies
    private var imagePipeline: ImagePipeline { ImagePipeline.shared }
    
    init(tasks: [Task] = []) {
        self.tasks = tasks
        super.init()
    }
    
    // MARK: - Image Loading
    private func imageDidLoadForItem(at indexPath: IndexPath) {
        collectionView?.reloadItems(at: [indexPath])
    }
    
    private func loadImage(with url: URL, for indexPath: IndexPath) -> NSImage? {
        if let _ = imageLoadingTasks[url] {
            return nil
        }
        
        if let imageContainer = imagePipeline.cache.cachedImage(for: url) {
            return imageContainer.image
        }
        
        let loadTask = imagePipeline.loadImage(with: url) { [weak self] result in
            self?.imageLoadingTasks.removeValue(forKey: url)
            if case .success = result {
                self?.imageDidLoadForItem(at: indexPath)
            }
        }
        
        imageLoadingTasks[url] = loadTask
        return nil
    }
    
    // MARK: - NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count * 2
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(TaskCardItem.self, for: indexPath)
        let task = tasks[indexPath.item % tasks.count]
        if let imageURL = task.coverImageURL, let image = loadImage(with: imageURL, for: indexPath) {
            cell.setTask(task, coverImage: image)
        } else {
            cell.setTask(task, coverImage: nil)
        }
        
        return cell
    }
}
