//
//  ExplorerViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import Combine
import Foundation
import CoreData

class ExplorerViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    var controller: NSFetchedResultsController<Block>?
    
    @Published var blocks: [Block] = []
    override init() {
        super.init()
        refreshFromCoreData()
    }
    
    func refreshSearch(_ searchText: String) {
        DispatchQueue.main.async {
            var newBlocks = self.controller?.fetchedObjects ?? []
            newBlocks = newBlocks.filter{ block in
                return (block.blknum?.hasPrefix(searchText) ?? false) || searchText == ""
            }
            newBlocks.sort(by: { (lhs, rhs) -> Bool in
                return UInt64(lhs.blknum ?? "") ?? 0 > UInt64(rhs.blknum ?? "") ?? 0
            })
            self.blocks = newBlocks
        }
    }
    
    private func refreshFromCoreData() {
        let context = PersistentContainer.viewContext
        let request: NSFetchRequest<Block> = Block.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: true)]
        self.controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller?.delegate = self
        do {
            try self.controller?.performFetch()
        } catch let error {
            print(error)
        }
        updateBlocks()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateBlocks()
    }
    
    func updateBlocks() {
        DispatchQueue.main.async {
            var newBlocks = self.controller?.fetchedObjects ?? []
            newBlocks.sort(by: { (lhs, rhs) -> Bool in
                return UInt64(lhs.blknum ?? "") ?? 0 > UInt64(rhs.blknum ?? "") ?? 0
            })
            self.blocks = newBlocks
        }
    }
}
