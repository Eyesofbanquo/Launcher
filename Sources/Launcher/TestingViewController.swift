//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/7/20.
//

import Foundation

#if canImport(Stevia) && canImport(UIKit) && canImport(SnapKit)
import UIKit
import Stevia
import SnapKit

/// The main view controller to use for debugging in the `UISceneDelegate`
public class TestingViewController: UIViewController {
  
  // MARK: - Properties -
  
  private var reuseIdentifier: String = TestCell.reuseIdentifier
  
  private(set) var suites: [[TestSuite]]
  
  // MARK: - Views -
  
  var tableView: UITableView
  
  // MARK: - Init -
  
  public init() {
    tableView = UITableView()
    suites = []
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.sv([
      tableView
    ])
    
    
    tableView.style { t in
      t.separatorStyle = .none
      t.register(TestCell.self, forCellReuseIdentifier: reuseIdentifier)
      t.backgroundColor = .white
      t.tableFooterView = UIView()
      t.delegate = self
      t.dataSource = self
    }
    
  }
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.snp.makeConstraints { make in
      make.leading.equalTo(view.directionalLayoutMargins.leading)
      make.trailing.equalTo(view.directionalLayoutMargins.trailing)
      make.bottom.equalTo(view.directionalLayoutMargins.bottom)
      make.top.equalTo(view.directionalLayoutMargins.top)
    }

  }
}

// MARK: - Suite Management -

extension TestingViewController {
  
  public func register<T: TestSuite & CaseIterable>(suites: [T.Type]) {
    for suite in suites {
      if let addableSuites = suite.allCases as? [TestSuite] {
        self.suites.append(addableSuites)
      }
    }
  }
  
  public func window(forScene scene: UIScene) -> UIWindow? {
    guard let windowScene = (scene as? UIWindowScene) else { return nil }
    
    // Create a new window with the given window scene
    let window = UIWindow(windowScene: windowScene)
    let rootViewController = create()
    
    window.rootViewController = rootViewController
    
    return window
  }
}


// MARK: - Builder -
extension TestingViewController {
  
  internal func create(forTitle title: String? = "View for testing") -> UINavigationController {
    self.title = title
    let navigationController = UINavigationController(rootViewController: self)
    navigationController.title = title
    navigationController.navigationBar.prefersLargeTitles = true
    
    let navAppearance = UINavigationBarAppearance()
    navAppearance.configureWithOpaqueBackground()
//    navAppearance.backgroundColor = .black
//    navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//    navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    navigationController.navigationBar.compactAppearance = navAppearance
    navigationController.navigationBar.standardAppearance = navAppearance
    
    return navigationController
  }
}


// MARK: - Table View Delegates -
extension TestingViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = suites[indexPath.section][indexPath.row]
    
    switch item.presentationMethod {
    case .push:
      self.navigationController?.pushViewController(item.controller(), animated: true)
    case .present:
      self.present(item.controller(), animated: true, completion: nil)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension TestingViewController: UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return suites.count
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard suites[section].count > 0 else { return "unknown" }
    
    return suites[section].first!.name
  }
  
  public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    print(section)
    if let header = view as? UITableViewHeaderFooterView {
      header.contentView.backgroundColor = self.view.backgroundColor
      header.textLabel?.textColor = .white
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suites[section].count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    guard let testCell = cell as? TestCell else { return cell }
    
    let item = suites[indexPath.section][indexPath.row]
    let title = "Tap to showcase \(item.rawValue)."
    
    testCell.configure(withTitle: title)
    testCell.backgroundColor = self.view.backgroundColor
    
    return testCell
  }
  
  
}


#endif