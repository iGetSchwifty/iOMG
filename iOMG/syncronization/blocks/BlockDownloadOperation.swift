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
    private var invokeNext: (() -> Void)?
    
    init(page: Int, limit: Int, invokeNext: (() -> Void)?, provider: NetworkingProtocol = NetworkingPublisher()) {
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
                if let response = response, self.checkForCache(block: response.data?.first) == false {
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
                if success ?? false {
                    self.invokeNext?()
                }
            })
    }
    
    private func process(response: BlockBatchAPIResponse) -> Bool {
        

        return false
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
                guard foundObjects.count == 0 else { return }
                //if foundObjects.first?.blknum
//                returnVal = true
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
}
