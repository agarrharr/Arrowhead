import ComposableArchitecture
import SwiftUI

@Reducer
struct AppReducer {
    @Reducer(state: .equatable)
    enum Destination {
        case detail
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var overview: OverviewReducer.State = OverviewReducer.State()
        var projects: [Project] = []
    }
    
    enum Action: Sendable {
        case `internal`(InternalAction)
        case view(ViewAction)
        
        case destination(PresentationAction<Destination.Action>)
        case overview(OverviewReducer.Action)
        
        @CasePathable
        enum InternalAction: Sendable {
            case onLoad(Result<[Project], Error>)
        }
        
        @CasePathable
        enum ViewAction {
            case onAppear
        }
    }
    
    @Dependency(\.fileClient) var fileClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .internal(action):
                switch action {
                case .onLoad:
                    // TODO: handle error
                    return .none
                }
                
            case let .view(action):
                switch action {
                case .onAppear:
                    return .run { send in
                        do {
                            try await fileClient.loadAllProjects()
//                            await send(.internal(.onLoad(.success(projects))))
                        } catch {
                            await send(.internal(.onLoad(.failure("Failure" as! Error))))
                        }
                    }
                }
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct ContentView: View {
    var bookmarkController = BookmarkController()
    @Bindable var store: StoreOf<AppReducer>
    
    var body: some View {
        NavigationView {
            OverviewView(
                store: store.scope(state: \.overview, action: \.overview),
                bookmarkController: bookmarkController
            )
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppReducer.State()) {
            AppReducer()
        })
    }
}
