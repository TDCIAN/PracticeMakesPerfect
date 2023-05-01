//
//  ViewController.swift
//  MyTodoApp
//
//  Created by JeongminKim on 2023/05/01.
//

import UIKit
import SwipeCellKit

class MemoListVC: UIViewController {

    enum SectionType: Int {
        case all = 0
        case isDone = 1
        case notYet = 2
    }
    
    @IBOutlet weak var deleteAllBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var writeNewTodoBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memoList: [Memo] = [
        .init(isDone: false, content: "ㅋㅋㅋㅋ"),
        .init(isDone: false, content: "ㅎㅎㅎㅎ"),
        .init(isDone: false, content: "ㅋㅋㅋㅋ"),
        .init(isDone: false, content: "ㅎㅎㅎㅎ"),
    ]
    
    var snapshot = NSDiffableDataSourceSnapshot<SectionType, Memo>()
    var dataSource: UITableViewDiffableDataSource<SectionType, Memo>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        self.snapshot.appendSections([.all])
        self.snapshot.appendItems(memoList, toSection: .all)
        self.dataSource?.apply(self.snapshot, animatingDifferences: true)
        
        addActions()
    }
    
    fileprivate func addActions() {
        print(#fileID, #function, #line, "- ")
        writeNewTodoBarBtn.target = self
        writeNewTodoBarBtn.action = #selector(showAddMemoAlert)
    }
}

// MARK: - IBActions
extension MemoListVC {
    @objc fileprivate func showAddMemoAlert(_ sender: UIBarButtonItem) {
        print(#fileID, #function, #line, "- ")
        let alert = UIAlertController(title: "메모 추가하기", message: "새 메모를 추가해 주세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            print("")
        }
        alert.textFields?.first?.placeholder = "메모를 입력해 주세요."
        let addMemoAction = UIAlertAction(title: NSLocalizedString("추가", comment: "추가 액션"), style: .default, handler: { [weak self] _ in
            guard let userInput = alert.textFields?.first?.text,
                  let self = self else { return }
            print(#fileID, #function, #line, "- userInput: \(userInput)")
            
            let newMemo = Memo(content: userInput)
            self.memoList.insert(newMemo, at: 0)
            self.snapshot.appendItems(self.memoList, toSection: .all)
            self.dataSource?.apply(self.snapshot, animatingDifferences: true)
        })
        alert.addAction(addMemoAction)
        
        let dismissAction = UIAlertAction(title: "닫기", style: .cancel)
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MemoListVC {
    fileprivate func configureTableView() {
        let cellNib = UINib(nibName: "MemoCell", bundle: nil)
        self.memoTableView.register(cellNib, forCellReuseIdentifier: "MemoCell")
        self.memoTableView.delegate = self
        self.memoTableView.rowHeight = 60
        self.memoTableView.estimatedRowHeight = 100
        dataSource = UITableViewDiffableDataSource(
            tableView: self.memoTableView,
            cellProvider: { (tableView, indexPath, item) -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoCell else { return UITableViewCell() }
                cell.updateUI(with: item, delegate: self)
                return cell
            }
        )
    }
}

extension MemoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let filterAllAction = UIAction(title: "전체") { _ in
            print(#fileID, #function, #line, "- 전체")
        }
        
        let filterIsDoneAction = UIAction(title: "완료") { _ in
            print(#fileID, #function, #line, "- 완료")
        }
        
        let filterNotYetAction = UIAction(title: "미완료") { _ in
            print(#fileID, #function, #line, "- 미완료")
        }
        
        let segmentControl = UISegmentedControl(
            frame: .zero,
            actions: [filterAllAction, filterIsDoneAction, filterNotYetAction]
        )
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        
        return segmentControl
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MemoListVC: SwipeTableViewCellDelegate {
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeCellKit.SwipeActionsOrientation
    ) -> [SwipeCellKit.SwipeAction]? {
        switch orientation {
        case .left:
            let checkDoneAction = SwipeAction(
                style: .default,
                title: "완료여부") { action, indexPath in
                    
                    print(#fileID, #function, #line, "- 완료처리 인덱스패스: \(indexPath.row)")
                }
            checkDoneAction.hidesWhenSelected = true
            checkDoneAction.backgroundColor = .green
            checkDoneAction.image = UIImage(systemName: "checkmark.seal.fill")
            return [checkDoneAction]
        case .right:
            let editAction = SwipeAction(
                style: .default,
                title: "수정하기") { action, indexPath in
                    
                    print(#fileID, #function, #line, "- 수정하기 인덱스패스: \(indexPath.row)")
                }
            editAction.hidesWhenSelected = true
            editAction.backgroundColor = .systemOrange
            editAction.image = UIImage(systemName: "square.and.pencil")
            
            let deleteAction = SwipeAction(
                style: .destructive,
                title: "삭제") { action, indexPath in
                    
                    print(#fileID, #function, #line, "- 삭제하기 인덱스패스: \(indexPath.row)")
                }
            deleteAction.hidesWhenSelected = true
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            return [deleteAction, editAction]
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        editActionsOptionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
    ) -> SwipeOptions {

        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .fill
        options.transitionStyle = .drag
        
        return options
    }
}
