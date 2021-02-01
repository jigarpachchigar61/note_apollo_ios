//
//  CategoryViewController.swift
//  note_apollo_iOS
//
//  Created by Nency on 01/02/21.
//

import UIKit
import CoreData

class FilterdCategoryViewController: UIViewController {
    var noteTVC: apolloNoteTVC? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryList: [NoteCategory] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getCategoryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 500
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    //MARK: - get old or create a new Category
    func checkCategoryIsThere(_ category: String) -> Bool{
        let request: NSFetchRequest<NoteCategory> = NoteCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", category)
        do {
            let categoryList = try context.fetch(request)
            if categoryList.count > 0{
                return true
            }
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
        return false
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

//MARK: - show Category
extension FilterdCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func getCategoryList(){
        let request: NSFetchRequest<NoteCategory> = NoteCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            categoryList = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error loading Category \(error.localizedDescription)")
        }
    }
    
    func addCategoryInList(name: String){
        do {
            let category = NoteCategory(context: context)
            category.name = name
            try context.save()
            getCategoryList()
        } catch {
            print("Error loading Category \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        let category = categoryList[indexPath.row]
        cell.initCell(name: category.name ?? "")
        return cell
    }
}
