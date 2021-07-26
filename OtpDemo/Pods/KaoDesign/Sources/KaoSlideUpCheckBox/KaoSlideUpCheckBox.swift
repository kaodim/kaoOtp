//
//  KaoSlideUpCheckBox.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 8/5/19.
//

import UIKit

public class FilterList {
	public let id: Int
	public let title: String
	public var selected: Bool

	public init(id: Int, title: String, selected: Bool) {
		self.id = id
		self.title = title
		self.selected = selected
	}
}

public class KaoSlideUpCheckBox: UIView {

	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet private weak var doneButton: UIButton!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var serviceLabel: UILabel!
	@IBOutlet private weak var unselectButton: UIButton!
	@IBOutlet private weak var selectButton: UIButton!

	private var selectedIndex: [Int] = []
	private var lists: [FilterList] = []
	private var containerView: UIView!
	private var selectedList: Int? {
		didSet {
			reloadTable()
		}
	}
	public var countDescription: String!
	public var persistentLists: String = ""

	public var closeTapped: (() -> Void)?
	public var doneTapped: ((_ lists: [FilterList]) -> Void)?
	public var unselectTapped: (() -> Void)?
	public var selectTapped: (() -> Void)?

	// MARK: - init methods
	override public init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupViews()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}

	// MARK: - Setup UI
	private func setupViews() {
		containerView = loadViewFromNib()
		containerView.frame = frame
		containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(containerView)
		setupLabel()
	}

	private func loadViewFromNib() -> UIView {
		let nib = UIView.nibFromDesignIos("KaoSlideUpCheckBox")
		guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
			fatalError("Nib not found.")
		}
		return view
	}

	private func updateSelectedIndex(_ index: Int) {
		let selectedIndex = lists[index].selected
		lists[index].selected = !selectedIndex
		selectedList = index
		handleSelectionCase()
	}

	private func updateBasedOnID(_ id: [Int]) {
		if !id.isEmpty {
			for list in lists {
				list.selected = selectedIndex.contains(list.id)
			}
			
			handleSelectionCase()
			reloadTable()
		}
	}

	private func handleSelectionCase() {
		setupLabel()
		checkSelection()

		let hasSelected = lists.contains(where: { $0.selected == true })
		doneButtonEnabled(hasSelected ? true : false)
	}

	private func getSelected() -> [FilterList] {
		let selected = lists.filter { $0.selected == true}
		return selected
	}

	public func setupLabel() {
		let selected = lists.filter { $0.selected }.count
		serviceLabel.text = "\(selected)/" + "\(lists.count) \(countDescription ?? "")"
	}

	public func reloadTable() {
		tableView.reloadData()
	}

	public func configureTitle(_ title: String) {
		titleLabel.text = title
	}

	public func configureSelectTitle(_ unselectTitle: String, _ selectTitle: String) {
		unselectButton.setTitle(unselectTitle, for: .normal)
		selectButton.setTitle(selectTitle, for: .normal)
	}

	public func configureHeaderButton(_ close: String, _ done: String) {
		closeButton.setTitle(close, for: .normal)
		doneButton.setTitle(done, for: .normal)
	}

	public func configureTableView(_ lists: [FilterList], selectedLists: [FilterList]) {
		tableView.registerFromDesignIos(KaoSlideUpCheckBoxTableViewCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.removeFooterView()
		tableView.separatorStyle = .none
		handleSelection(lists, selectedLists: selectedLists)
		setupLabel()
	}

	private func handleSelection(_ lists: [FilterList], selectedLists: [FilterList]) {
		self.lists = lists
		// handle selection from persistent if its empty
		if persistentLists.isEmpty {
			if selectedLists.isEmpty {
				// first time load with no persistence saved, show all as selected
				checkAll(true)
			} else {
				for list in selectedLists {
					selectedIndex.append(list.id)
				}
			}
		} else {
			let lists = persistentLists.components(separatedBy: ", ")
			for persistent in lists {
				selectedIndex.append(Int(persistent) ?? 0)
			}
		}
		self.updateBasedOnID(selectedIndex)
	}

	public func checkAll(_ value: Bool) {
		for service in lists {
			service.selected = value
		}

		handleSelectionCase()
		reloadTable()
	}

	private func checkSelection() {
		let selected = lists.filter { $0.selected == true }.count == lists.count
		let unselected = lists.filter { $0.selected == false }.count == lists.count
		unselectEnabled(unselected ? false : true)
		selectEnabled(selected ? false : true)
	}

	public func unselectEnabled(_ status: Bool) {
		unselectButton.isEnabled = status
		let color = status ? UIColor.kaoColor(.vividBlue) : UIColor.kaoColor(.dustyGray2)
		unselectButton.setTitleColor(color, for: .normal)
	}

	public func selectEnabled(_ status: Bool) {
		selectButton.isEnabled = status
		let color = status ? UIColor.kaoColor(.vividBlue) : UIColor.kaoColor(.dustyGray2)
		selectButton.setTitleColor(color, for: .normal)
	}

	public func doneButtonEnabled(_ status: Bool) {
		doneButton.isEnabled = status
		let color = status ? UIColor.kaoColor(.vividBlue) : UIColor.kaoColor(.dustyGray2)
		doneButton.setTitleColor(color, for: .normal)
	}

	@IBAction func doneDidTapped() {
		doneTapped?(getSelected())
	}

	@IBAction func closeDidTapped() {
		closeTapped?()
	}

	@IBAction func unselectedDidTapped() {
		unselectTapped?()
		unselectEnabled(false)
		selectEnabled(true)
	}

	@IBAction func selectDidTapped() {
		selectTapped?()
		selectEnabled(false)
		unselectEnabled(true)
	}
}

extension KaoSlideUpCheckBox: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lists.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: KaoSlideUpCheckBoxTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		cell.selectionStyle = .none
		let service = lists[indexPath.row]

		cell.configure(service.title, selected: service.selected)
		return cell
	}
}

extension KaoSlideUpCheckBox: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		updateSelectedIndex(indexPath.row)
	}
}
