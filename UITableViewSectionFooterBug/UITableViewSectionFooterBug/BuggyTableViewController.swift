//
//  BuggyTableViewController.swift
//  UITableViewSectionFooterBug
//
//  Created by Jordan Zucker on 9/16/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import CoreData

class BuggyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<TestItem>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TestItemTableViewCell.self, forCellReuseIdentifier: TestItemTableViewCell.reuseIdentifier())
        tableView.register(ButtonHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ButtonHeaderFooterView.reuseIdentifier())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let allTestItemsFetchRequest: NSFetchRequest<TestItem> = TestItem.fetchRequest()
        allTestItemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TestItem.title), ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: allTestItemsFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        view.setNeedsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Add test item
    
    func addTestItemButtonTapped(sender: UIButton) {
        UIApplication.persistentContainer.performBackgroundTask { (context) in
            let createdTestItem = TestItem(context: context)
            createdTestItem.title = "\(Date())"
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    // MARK: Cells
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        guard let testItemCell = cell as? TestItemTableViewCell else {
            fatalError()
        }
        guard let testItem = fetchedResultsController?.object(at: indexPath) else { fatalError("Unexpected Object in FetchedResultsController")
        }
        testItemCell.update(object: testItem)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: TestItemTableViewCell.reuseIdentifier(), for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    // MARK: Editing
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let currentFRC = fetchedResultsController else {
            fatalError()
        }
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletingKeyword = currentFRC.object(at: indexPath)
            let mainViewContext = viewContext
            mainViewContext.perform {
                mainViewContext.delete(deletingKeyword)
                do {
                    try mainViewContext.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            
        }
    }
    
    // MARK: Section Footers
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ButtonHeaderFooterView.height()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ButtonHeaderFooterView.reuseIdentifier()) as? ButtonHeaderFooterView else {
            return nil
        }
        footerView.update(title: "Add test item ...", target: self, action: #selector(self.addTestItemButtonTapped(sender:)))
        return footerView
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            guard let cell = tableView.cellForRow(at: indexPath!) else {
                fatalError()
            }
            configureCell(cell: cell, indexPath: indexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
