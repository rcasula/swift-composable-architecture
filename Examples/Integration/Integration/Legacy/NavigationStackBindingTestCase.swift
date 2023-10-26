import ComposableArchitecture
import SwiftUI

@Reducer
private struct NavigationStackBindingTestCase {
  struct State: Equatable {
    var path: [Destination] = []
    enum Destination: Equatable {
      case child
    }
  }
  enum Action: Equatable, Sendable {
    case goToChild
    case navigationPathChanged([State.Destination])
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .goToChild:
        state.path.append(.child)
        return .none
      case let .navigationPathChanged(path):
        state.path = path
        return .none
      }
    }
  }
}

struct NavigationStackBindingTestCaseView: View {
  private let store = Store(initialState: NavigationStackBindingTestCase.State()) {
    NavigationStackBindingTestCase()
  }

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack(path: viewStore.binding(get: \.path, send: { .navigationPathChanged($0) })) {
        VStack {
          Text("Root")
          Button("Go to child") {
            viewStore.send(.goToChild)
          }
        }
        .navigationDestination(
          for: NavigationStackBindingTestCase.State.Destination.self
        ) { destination in
          switch destination {
          case .child: Text("Child")
          }
        }
      }
    }
  }
}
