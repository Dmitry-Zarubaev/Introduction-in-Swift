//
//  Lesson_4.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 24.01.2022.
//

import Foundation


struct VehicleWeight {
    let curbWeight: Int
    let dryWeight: Int
    // Gross Vehicle Weight Rating
    let gvwr: Int
    
    init?(curbWeight: Int, dryWeight: Int, gvwr: Int) {
        if (gvwr > 0 && curbWeight > 0 && dryWeight > 0 && curbWeight > dryWeight && gvwr > curbWeight) {
            self.curbWeight = curbWeight
            self.dryWeight = dryWeight
            self.gvwr = gvwr
        } else {
            return nil
        }
    }
    
    public func getPayloadCapacity() -> Int {
        return gvwr - curbWeight
    }
}

struct CarFrame {
    let vin: String?
    let fuelTank: Int
    let weight: VehicleWeight
    let driveLayout: WheelDriveLayout
    let enginePosition: EnginePosition
    
    let seats: Int
    let maxSpeed: Int
    
    public func isValidVIN() -> Bool {
        if let vin = self.vin {
            // https://en.wikipedia.org/wiki/Vehicle_identification_number#Components
            return vin.count == 17
        } else {
            return false
        }
    }
}


enum CarAction {
    case Engine(act: EngineAction)
    case Fuel(volume: Int)
    case GlassWindows(act: GlassWindowAction)
    case Payload(act: PayloadAction)
}


class Car {
    let manufacturer: String?
    let model: String?
    let year: Int?
    let frame: CarFrame
    
    private var engine: Engine?

    private var isGlassWindowRaised: Bool = true
    private var isEngineStarted: Bool = false
    
    private var payload: Int = 0
    private var fuel: Int = 0
    
    public var isEngineReadyToStart: Bool {
        get {
            if let engine = self.engine {
                return engine.isValidEngine() && fuel > 0
            } else {
                return false
            }
        }
    }
    
    init(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine? = nil) {
        // <> using of IF here causing the 'constant '' used before being initialized' error
        self.model = model.isEmpty ? model : nil
        self.year = year >= 1886 ? year : nil // https://www.daimler.com/company/tradition/company-history/1885-1886.html
        self.manufacturer = manufacturer.isEmpty ? manufacturer : nil
        // </>

        self.frame = frame
    }
    
    convenience init(who manufacturer: String, what model: String, frame: CarFrame, engine: Engine? = nil) {
        self.init(who: manufacturer, what: model, when: 0, frame: frame, engine: engine)
    }
    
    convenience init(when year: Int, frame: CarFrame, engine: Engine? = nil) {
        self.init(who: "", what: "", when: year, frame: frame, engine: engine)
    }
    
    convenience init(frame: CarFrame, engine: Engine? = nil) {
        self.init(who: "", what: "", when: 0, frame: frame, engine: engine)
    }
    
    convenience init(frame: CarFrame) {
        self.init(who: "", what: "", when: 0, frame: frame, engine: nil)
    }

    
    public func printState() -> Void {
        let occupation: String
        switch self.payload {
            case let x where x == frame.weight.getPayloadCapacity():
                occupation = "car is carrying the max payload"
            case let x where x == 0:
                occupation = "car isn't carrying any paylod"
            default:
                occupation = "current payload is \(payload)"
        }
        print("Glass windows are \(isGlassWindowRaised ? "raised" : "lowered"), the engine \(isEngineStarted ? "is working" : "turned off"), the \(occupation).")
    }
    
    public func printInfo() -> Void {
        var introduction: String = ""
        
        introduction += "\(model == nil ? "This is an unknown model" : "\(model!) car") was made "
        introduction += "by \(manufacturer ?? "an unknown manufacturer") "
        introduction += year == nil ? "in unknown year." : "in \(year!)."
        
        let message = """
        \(introduction). Max payload capacity for this vehicle is \(frame.weight.getPayloadCapacity()) kg and gross weight is \(frame.weight.gvwr) kg.
        The engine placed in the \(frame.enginePosition.rawValue.lowercased()) of its body and the car has the \(frame.driveLayout.rawValue.lowercased()) wheel drive layout.
        About the car's engine. \(engine == nil ? "Right now it hasn't had any engine" : engine!.getInfo()).
        """
        print(message)
    }
    
    private func actWithEngine(action: EngineAction) -> Void {
        if let _ = self.engine {
            switch action {
                case .Start:
                    if isEngineReadyToStart {
                        print(isEngineStarted ? "The engine is already working!" : "The engine has started fine! Listen how it roars!")
                        isEngineStarted = true
                    } else {
                        print("This engine isn't ready to start")
                    }
                case .TurnOff:
                    print(isEngineStarted ? "The engine is turned off now!" : "The engine is already stopped and was cold for a long time!")
                    isEngineStarted = false
            }
        } else {
            print("This car doesn't have any engine inside!")
        }
    }
    
    private func actWithGlassWindow(action: GlassWindowAction) -> Void {
        switch action {
            case .Lower:
            print(isGlassWindowRaised ? "Glass windows have been lowered!" : "It's already lowered!")
                isGlassWindowRaised = false
            case .Raise:
            print(isGlassWindowRaised ? "It's already raised!" : "Glass windows have been raised!")
                isGlassWindowRaised = true
        }
    }
    
    private func actWithPayload(action: PayloadAction) -> Void {
        switch action {
            case .PlaceIn(let volume):
                if (payload + volume > frame.weight.getPayloadCapacity()) {
                    print("You can't place so much payload in this trunk! Take less on \(payload + volume - frame.weight.getPayloadCapacity()) kg.")
                } else if (volume <= 0) {
                    print("Are you kidding?!")
                } else {
                    payload += volume
                    print("Payload was placed with great care and accuracy.")
                }
            case .TakeFrom(let volume):
                if (payload - volume < 0) {
                    print("Hey! You're asking too much! Take your \(payload) kg of payload!")
                    payload = 0
                } else if (payload == 0) {
                    print("The trunk is empty. You can't take anything from it.")
                } else {
                    self.payload -= volume
                    print("Here is your luggage, sir!")
                }
        }
    }
    
    private func fillFuelTank(volume: Int) -> Void {
        if volume < 0 {
            print("Something totally wrong here.")
        } else {
            if fuel + volume > frame.fuelTank {
                print("You're filling too much! The tank is full now and \(fuel + volume - frame.fuelTank) liters are redundant.")
            } else {
                print("Safe road to you!")
            }
        }
    }
    
    public func doCarAction(do action: CarAction) -> Void {
        switch action {
            case .Engine(let engineAct):
                actWithEngine(action: engineAct)
            case .GlassWindows(let windowsAct):
                actWithGlassWindow(action: windowsAct)
            case .Payload(let payloadAct):
                actWithPayload(action: payloadAct)
            case .Fuel(let volume):
                fillFuelTank(volume: volume)
        }
    }
}

class Forklift: Car {
    private var cargo: Int
    
    override init(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine? = nil) {
        super.init(who: manufacturer, what: model, when: year, frame: frame, engine: engine)
    }
    
//    public func carryCargo(cargo: Int) -> Void {
//        if
//    }
}

class Truck: Car {
    override func doCarAction(do action: CarAction) {
        switch action {
            case .Payload(_):
                print("You can't do it without a forklift at least!")
            default:
                super.doCarAction(do: action)
        }
    }
    
    public
}
