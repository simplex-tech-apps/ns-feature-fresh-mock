//
//  FreshCoordinator.swift
//  NSFeatureFreshMock
//
//  Created by apple on 12/07/26.
//

import SwiftData
import SwiftUI
import NammaAppUI

@MainActor
struct FreshViewFactory {
    @ViewBuilder
    func buildPage(_ page: FreshCoordinatorPage) -> some View {
        switch page {
        case .landingPage(let freshViewModel):
            FreshLandingView(freshViewModel: freshViewModel)
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: FreshCoordinatorSheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func buildCover(_ cover: FreshCoordinatorCover) -> some View {
        EmptyView()
    }
}

enum FreshCoordinatorPage: Hashable {
    case landingPage(FreshViewModel)
}

enum FreshCoordinatorSheet: String, Identifiable {
    var id: String { rawValue }
    case noSheet
}

enum FreshCoordinatorCover: String, Identifiable {
    var id: String { rawValue }
    case noCover
}

extension EnvironmentValues {
    @Entry var FreshCoordinator: FreshCoordinator?
    @Entry var FreshViewModel: FreshViewModel?
}

@Observable
class FreshCoordinator: NSObject {
    var path: NavigationPath = NavigationPath()
    var sheet: FreshCoordinatorSheet?
    var cover: FreshCoordinatorCover?
    private(set) var currenScreen: [FreshCoordinatorPage] = []
    
    func push(page: FreshCoordinatorPage) {
        currenScreen.append(page)
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        currenScreen.removeLast()
        path.removeLast(last)
    }
    
    func popToRoot() {
        currenScreen.removeAll()
        path.removeLast(path.count)
    }
    
    func present(sheet: FreshCoordinatorSheet) {
        self.sheet = sheet
    }
    
    func present(cover: FreshCoordinatorCover) {
        self.cover = cover
    }
    
    func popSheet() {
        withAnimation(.spring()) {
            self.sheet = nil
        }
    }
    
    func popCover() {
        self.cover = nil
    }
}

public struct FreshCoordinatorView: View {
    @State
    private var freshCoordinator = FreshCoordinator()
    @State
    private var freshViewModel: FreshViewModel = FreshViewModel()
    @State
    private var appTheme = AppThemeManager.shared
    
    let freshViewFactory: FreshViewFactory = FreshViewFactory()
    
    public init() {}
    
    public var body: some View {
        freshViewFactory.buildPage(.landingPage(freshViewModel))
            .navigationDestination(for: FreshCoordinatorPage.self) {
                freshViewFactory.buildPage($0)
            }
            .sheet(item: $freshCoordinator.sheet) { freshViewFactory.buildSheet($0).presentationBackground(appTheme.current.secondary).presentationDetents([.medium]).presentationCornerRadius(24)
            }
            .fullScreenCover(item: $freshCoordinator.cover) {
                freshViewFactory.buildCover($0)
            }
    }
}
