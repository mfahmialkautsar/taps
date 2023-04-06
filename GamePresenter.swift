import SwiftUI

class GamePresenter: ObservableObject {
  let difficulty: Difficulty
  var players = [Player]()
  @Published var gameCountDown: Int = 60
  @Published var startCountDown: Int = 3
  @Published var triangles = [TriangleView]()
  @Published var circles = [CircleView]()
  @Published var squares = [SquareView]()
  @Published var pentagons = [PentagonView]()
  @Published var isStarted = false
  @Published var showTimesUpSheet = false
  @Published var isModalOpen = false

  init(players: [Player], diffifulty: Difficulty = .medium) {
    self.players = players
    difficulty = diffifulty
  }

  func start(proxies: [GeometryProxy]) {
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      self.startCountDown -= 1
      guard self.startCountDown < 0 else { return }
      timer.invalidate()
      self.isStarted = true
      if proxies.count == 1 {
        for player in self.players {
          for shape in player.shapes {
            _ = self.addShape(proxies[0], shape)
            _ = self.addShape(proxies[0], shape)
            _ = self.addShape(proxies[0], shape)
          }
        }
      } else {
        for i in 0 ..< proxies.count {
          for shape in self.players[i].shapes {
            _ = self.addShape(proxies[i], shape, i)
            _ = self.addShape(proxies[i], shape, i)
            _ = self.addShape(proxies[i], shape, i)
          }
        }
      }
      self.startCountdown()
      guard self.players.count == 1 || proxies.count > 1 else { return }
      for i in 0 ..< proxies.count {
        switch self.difficulty {
        case .easy:
          self.spanRandomObstacle(proxy: proxies[i], shape: .circle, i)
        case .medium:
          self.spanRandomObstacle(proxy: proxies[i], shape: .circle, i)
          self.spanRandomObstacle(proxy: proxies[i], shape: .square, i)
        case .hard:
          self.spanRandomObstacle(proxy: proxies[i], shape: .circle, i)
          self.spanRandomObstacle(proxy: proxies[i], shape: .square, i)
          self.spanRandomObstacle(proxy: proxies[i], shape: .pentagon, i)
        }
      }
    }
  }

  func stop() {
    isStarted = false
  }

  func addPlayers(player: Player) {
    players.append(player)
  }

  private func getShapeAnimation() -> Animation? {
    switch difficulty {
    case .easy:
      return nil
    case .medium:
      return .easeOut(duration: 1)
    case .hard:
      return .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }
  }

  private func addShape(_ proxy: GeometryProxy, _ shape: ShapeEnum, _ group: Int = 1) -> UUID {
    let id: UUID = UUID()
    DispatchQueue.main.async {
      switch shape {
      case .triangle:
        self.triangles.append(TriangleView(id: id, offset: self.randomPosition(size: proxy.size), group: group, animation: self.getShapeAnimation()))
      case .circle:
        self.circles.append(CircleView(id: id, offset: self.randomPosition(size: proxy.size), group: group, animation: self.getShapeAnimation()))
      case .square:
        self.squares.append(SquareView(id: id, offset: self.randomPosition(size: proxy.size), group: group, animation: self.getShapeAnimation()))
      case .pentagon:
        self.pentagons.append(PentagonView(id: id, offset: self.randomPosition(size: proxy.size), group: group, animation: self.getShapeAnimation()))
      }
    }
    return id
  }

  private func removeShape(uuid: UUID) {
    DispatchQueue.main.async {
      do {
        self.triangles.removeAll { $0.id == uuid }
      }
      do {
        self.circles.removeAll { $0.id == uuid }
      }
      do {
        self.squares.removeAll { $0.id == uuid }
      }
      do {
        self.pentagons.removeAll { $0.id == uuid }
      }
    }
  }

  func clickShape(uuid: UUID, player: Player, proxy: GeometryProxy, shape: ShapeEnum, group: Int = 1) {
    removeShape(uuid: uuid)
    if player.shapes.contains(where: { $0 == shape }) {
      player.addScore()
      _ = addShape(proxy, shape, group)
    } else {
      player.reduceScore()
    }
  }

  private func startCountdown() {
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      guard !self.isModalOpen else { return }
      self.gameCountDown -= 1
      guard self.gameCountDown < 1 else { return }
      timer.invalidate()
      self.stop()
      self.showTimesUpSheet = !self.isStarted
    }
  }

  private func spanRandomObstacle(proxy: GeometryProxy, shape: ShapeEnum, _ group: Int = 1) {
    DispatchQueue(label: "\(shape)_random_obstacles", qos: .userInteractive).async {
      while self.isStarted {
        Thread.sleep(forTimeInterval: Double.random(in: 0.5 ..< 1.0))
        guard self.isStarted else { return }
        let id = self.addShape(proxy, shape, group)
        Thread.sleep(forTimeInterval: Double.random(in: 2.5 ..< 3.0))
        guard self.isStarted else { return }
        self.removeShape(uuid: id)
      }
    }
  }

  private func randomPosition(size: CGSize) -> CGSize {
    let width: CGFloat = CGFloat.random(in: 0.0 ... size.width - 100)
    let height: CGFloat = CGFloat.random(in: 0.0 ... size.height - 100)
    return CGSize(width: width, height: height)
  }
}
