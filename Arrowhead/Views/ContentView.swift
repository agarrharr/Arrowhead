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
    }
    enum Action: Sendable {
        case destination(PresentationAction<Destination.Action>)
        case overview(OverviewReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct ContentView: View {
    var bookmarkController = BookmarkController()
    var fileController = FileController()
    @Bindable var store: StoreOf<AppReducer>
    
    var body: some View {
        NavigationView {
            OverviewView(
                store: store.scope(state: \.overview, action: \.overview),
                bookmarkController: bookmarkController,
                fileController: fileController
            )
        }
        .onAppear {
            fileController.loadAllProjects()
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
