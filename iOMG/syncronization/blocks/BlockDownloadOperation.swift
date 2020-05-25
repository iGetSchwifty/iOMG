//
//  BlockDownloadOperation.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class BlockDownloadOperation: QueuedOperation {
    private var _cancellable: AnyCancellable?
    final var disposeable: AnyCancellable? {
        return _cancellable
    }
    private var provider: NetworkingProtocol?
    private var page: Int
    private var limit: Int
    private var invokeNext: ((Bool) -> Void)?
    
    init(page: Int, limit: Int, invokeNext: ((Bool) -> Void)?, provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        self.page = page
        self.limit = limit
        self.invokeNext = invokeNext
        super.init(priority: .normal)
    }
    
    final override func main() {
        guard !isCancelled else {
            cancel()
            return
        }

        var initRequest = URLRequest(url: URLService.blockInfo)
        initRequest.httpMethod = "POST"
        initRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        initRequest.httpBody = try? JSONEncoder().encode(PageData(page: page, limit: limit))
        _cancellable = provider?.dataTaskPublisher(for: initRequest)
            .map({ [weak self] response -> BlockBatchAPIResponse? in
                guard let self = self else { return nil }
                guard !self.isCancelled else {
                    self.cancel()
                    return nil
                }
                
                do {
                    return try JSONDecoder().decode(BlockBatchAPIResponse.self, from: response)
                } catch let error {
                    print(error)
                    return nil
                }
            })
            .map({ [weak self] response -> Bool in
                guard let self = self else { return false }
                guard !self.isCancelled else {
                    self.cancel()
                    return false
                }
                if let response = response, response.data?.count ?? 0 > 0 {
                    return self.process(response: response)
                } else {
                    return false
                }
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.completed()
            }, receiveValue: { [weak self] success in
                guard let self = self else { return }
                guard !self.isCancelled else {
                    self.completed()
                    return
                }
                self.invokeNext?(success ?? false)
            })
    }
    
    private func process(response: BlockBatchAPIResponse) -> Bool {
        let returnVal = !self.checkForCache(block: response.data?.first)
        let context = PersistentContainer.newBackgroundContext()
        context.performAndWait {
            let fetchReq: NSFetchRequest<Block> = Block.fetchRequest()
            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]
            var foundObjects: [Block]?
            do {
                foundObjects = try context.fetch(fetchReq)
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
            
            // Goes brrrr....
            response.data?.forEach({ model in
                if foundObjects?.contains(where: { obj -> Bool in
                    return obj.blkhash == model.hash
                }) == false {
                    let block = Block(context: context)
                    block.blkhash = model.hash
                    block.blknum = model.blknum
                    block.ethHeight = model.ethHeight
                    block.txCount = model.txCount
                }
            })
            
            do {
                try context.save()
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
    
    
    private func checkForCache(block: BlockBatchModel?) -> Bool {
        guard let block = block else { return false }
        
        let context = PersistentContainer.newBackgroundContext()
        var returnVal = false
        context.performAndWait {
            let fetchReq: NSFetchRequest<Block> = Block.fetchRequest()
            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]

            do {
                let foundObjects = try context.fetch(fetchReq)
                guard foundObjects.count != 0 else { return }
                if block.blknum > foundObjects.last?.blknum ?? 0 && block.blknum <= foundObjects.first?.blknum ?? block.blknum {
                    returnVal = true
                }
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
}
