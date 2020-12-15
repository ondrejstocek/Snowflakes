//
//  Twitter: @MartinRogalla
//  EmaiL: email@martinrogalla.com
//
//  Created by Martin Rogalla.
//

import UIKit

public class SnowflakesView: UIView {

    private var numberOfSnowflakes: Int = 0
    private var gravityPullRight: Bool = false

    private var animator1: UIDynamicAnimator!
    private var animator2: UIDynamicAnimator!
    private var gravityBehaviour1: UIGravityBehavior!
    private var gravityBehaviour2: UIGravityBehavior!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initGravityAnimator()
        scheduleGravityDirectionChange()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initGravityAnimator()
        scheduleGravityDirectionChange()
    }

    private func initGravityAnimator() {
        gravityBehaviour1 = UIGravityBehavior()
        gravityBehaviour1.magnitude = 0.10
        gravityBehaviour1.gravityDirection.dx = 0.25

        gravityBehaviour2 = UIGravityBehavior()
        gravityBehaviour2.magnitude = 0.20
        gravityBehaviour2.gravityDirection.dx = 0.25

        animator1 = UIDynamicAnimator(referenceView: self)
        animator1.addBehavior(gravityBehaviour1)

        animator2 = UIDynamicAnimator(referenceView: self)
        animator2.addBehavior(gravityBehaviour2)
    }

    private func scheduleGravityDirectionChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 0...1000))) { [weak self] in
            guard let self = self else { return }

            if self.gravityPullRight { // Simulate wind, by changing gravity direction.
                self.gravityBehaviour1.gravityDirection.dx += 0.4
                self.gravityBehaviour2.gravityDirection.dx += 0.5
            } else {
                self.gravityBehaviour1.gravityDirection.dx -= 0.4
                self.gravityBehaviour2.gravityDirection.dx -= 0.5
            }
            self.gravityPullRight.toggle()

            if self.numberOfSnowflakes < 150 {
                DispatchQueue.main.async {
                    self.addNewSnowflake()
                }
            }

            self.scheduleGravityDirectionChange()
        }
    }

    private func addNewSnowflake() {
        let size = CGFloat.random(in: 2...4)
        let snowflake = Snowflake(frame: CGRect(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: -200...0),
            width: size,
            height: size
        ))
        addSubview(snowflake)

        // Randomly assign the snowfalke to one of the two gravity environments.
        let gravityBehaviour = Bool.random() ? gravityBehaviour1 : gravityBehaviour2
        gravityBehaviour!.addItem(snowflake)

        numberOfSnowflakes += 1
        startSnowflakeLifecycle(snowflake)
    }

    private func startSnowflakeLifecycle(_ snowflake: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 5000..<6000))) { [weak self] in
            guard let self = self else { return }

            // Remove the snowflake.
            self.gravityBehaviour1.removeItem(snowflake)
            self.gravityBehaviour2.removeItem(snowflake)
            snowflake.removeFromSuperview()
            self.numberOfSnowflakes -= 1
            // Spawn a new snowflake
            self.addNewSnowflake()
        }
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView != self ? hitView : nil
    }
}
