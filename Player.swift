class Player {
    var score: Int = 0
    var shapes = [ShapeEnum]()
    func addScore() {
        score += 10
    }
    func reduceScore() {
        score -= 10
    }
    func addShape(shape: ShapeEnum) {
        shapes.append(shape)
    }
}
