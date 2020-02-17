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
public class Launcher: UIViewController {
  
  // MARK: - Properties -
  
  var mainApp: UIViewController?
  
  private var reuseIdentifier: String = LauncherCell.reuseIdentifier
  
  private var suiteTypes: [Suite.Type] = []
  private(set) var suites: [[Suite]]
  
  // MARK: - Views -
  
  var tableView: UITableView
  
  // MARK: - Init -
  
  public init() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
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

      t.separatorStyle = .singleLine
      t.register(LauncherCell.self, forCellReuseIdentifier: reuseIdentifier)
      t.backgroundColor = .systemGroupedBackground
      t.tableFooterView = UIView()
      t.delegate = self
      t.dataSource = self
      t.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
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

extension Launcher {
  
  public func register(suites: [Suite.Type]) {
    for suite in suites {
      self.suiteTypes.append(suite)
      self.suites.append(suite.enabled)
    }
  }
  
  public func createWindow(forScene scene: UIScene) -> UIWindow? {
    guard let windowScene = (scene as? UIWindowScene) else { return nil }
    
    // Create a new window with the given window scene
    let createWindow = UIWindow(windowScene: windowScene)
    let rootViewController = create()
    
    createWindow.rootViewController = rootViewController
    
    return createWindow
  }
}


// MARK: - Builder -
extension Launcher {
  
  internal func create(forTitle title: String? = "Launcher 😈") -> UINavigationController {
    self.title = title
    let navigationController = UINavigationController(rootViewController: self)
    navigationController.title = title
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.tintColor = .label
    
    let runAppBarButtonAppearance = UIBarButtonItemAppearance(style: .plain)
    runAppBarButtonAppearance.normal.titleTextAttributes = [.backgroundColor: UIColor.white]
    
    let backBarButtonAppearance = UIBarButtonItemAppearance(style: .plain)
    backBarButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
    
    let runAppBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.runMainApplication))
    runAppBarButtonItem.tintColor = .systemGreen
    self.navigationItem.rightBarButtonItem = runAppBarButtonItem
    
    let navAppearance = UINavigationBarAppearance()
    navAppearance.configureWithOpaqueBackground()
    
    navAppearance.backgroundColor = UIColor.systemGroupedBackground
    navAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    navAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    navAppearance.buttonAppearance = runAppBarButtonAppearance
    navAppearance.backButtonAppearance = backBarButtonAppearance
    
    navigationController.navigationBar.compactAppearance = navAppearance
    navigationController.navigationBar.standardAppearance = navAppearance
    navigationController.navigationBar.scrollEdgeAppearance = navAppearance
    
    return navigationController
  }
  
  @objc internal func runMainApplication() {
    guard let mainApp = mainApp else { return }
    
    navigationController?.pushViewController(mainApp, animated: true)
  }
}


// MARK: - Table View Delegates -
extension Launcher: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = suites[indexPath.section][indexPath.row]
    let controller = item.controller()
    switch item.presentationMethod {
    case .push:
      self.navigationController?.pushViewController(controller, animated: true)
    case .present:
      self.present(controller, animated: true, completion: nil)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension Launcher: UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return suites.count
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard suites[section].count > 0 else { return "unknown" }
    
    return suiteTypes[section].suiteName
  }
  
  public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    print(section)
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.textColor = .label
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suites[section].count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    guard let testCell = cell as? LauncherCell else { return cell }
    
    let item = suites[indexPath.section][indexPath.row]
    let title = "Tap to showcase \(item.rowTitle)."
    
    testCell.configure(withTitle: title)
    testCell.backgroundColor = self.view.backgroundColor
    
    return testCell
  }
  
}

#endif
